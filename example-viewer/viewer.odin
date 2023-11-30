package viewer

import "ffmpeg:avformat"
import "ffmpeg:avcodec"
import "ffmpeg:swscale"
import "ffmpeg:types"
import "ffmpeg:avutil"

import "core:fmt"
import "core:os"
import "core:strings"
import "core:time"

import "vendor:sdl2"

@(deferred_out=cleanup_sdl2)
init_sdl2 :: proc()->(^sdl2.Window,^sdl2.Renderer,^sdl2.Surface){
    sdl2.Init(sdl2.INIT_EVERYTHING)
    
    win:=sdl2.CreateWindow("test",
        sdl2.WINDOWPOS_CENTERED,
        sdl2.WINDOWPOS_CENTERED,
        1024,960,
        sdl2.WINDOW_RESIZABLE | sdl2.WINDOW_SHOWN)

        
	backend_idx: i32 = -1
	if n := sdl2.GetNumRenderDrivers(); n <= 0 {
		fmt.eprintln("No render drivers available")
		return nil,nil,nil //bad, wrong, evil
	} else {
		for i in 0..<n {
			info: sdl2.RendererInfo
			if err := sdl2.GetRenderDriverInfo(i, &info); err == 0 {
				// NOTE(bill): "direct3d" seems to not work correctly
				if info.name == "opengl" {
					backend_idx = i
					break
				}
			}
		}
	}
    rend:=sdl2.CreateRenderer(win,backend_idx,sdl2.RendererFlags{.ACCELERATED})
    surf:=sdl2.CreateRGBSurface(cast(u32)sdl2.WINDOW_SHOWN,400,400,32,0xff000000,0x00ff0000,0x0000ff00,0x000000ff)

    return win,rend,surf
}

cleanup_sdl2 :: proc(win:^sdl2.Window,rend:^sdl2.Renderer,surf:^sdl2.Surface){
    sdl2.FreeSurface(surf)
    sdl2.DestroyRenderer(rend)
    sdl2.DestroyWindow(win)
    sdl2.Quit()
}

VideofileContext :: struct{
    fname:cstring,
    format_ctx:^types.Format_Context,
    codec_ctx:^types.Codec_Context,
    codec:^types.Codec,
    codec_params:^types.Codec_Parameters,
    vid_stream_idx:i32,
}

poll_events :: proc() {
    event:sdl2.Event
    for sdl2.PollEvent(&event){
        if event.type == sdl2.EventType.QUIT{
            appState.quit=true
            break
        }
        if event.type == sdl2.EventType.KEYDOWN {
            #partial switch event.key.keysym.scancode{
                case .ESCAPE:
                    appState.quit = true
                    break
            }
        }
    }
}


@(deferred_in=cleanup_video_file)
open_video_file :: proc(vidstruct:^VideofileContext,f_input:cstring){
    c_err:i32

    c_err = avformat.open_input(&vidstruct.format_ctx,f_input,nil,nil)
    assert(c_err==0,fmt.aprintf("Couldn't open input: %s","hi"))
    c_err = avformat.find_stream_info(vidstruct.format_ctx,nil)
    assert(c_err==0,fmt.aprintf("Couldn't find stream info: %s",avutil.av_error(c_err)))

    avformat.dump_format(vidstruct.format_ctx,0,f_input,0)

    vidstruct.vid_stream_idx=-1
    local_codec:^types.Codec
    local_codec_params:^types.Codec_Parameters
    //find video stream
    for i:u32=0; i<vidstruct.format_ctx.nb_streams; i+=1{

        local_codec_params = vidstruct.format_ctx.streams[i].codecpar 
        local_codec = avcodec.find_decoder(local_codec_params.codec_id)
        if local_codec_params.codec_type == types.Media_Type.Video{

            vidstruct.vid_stream_idx = cast(i32)i
            vidstruct.codec=local_codec
            vidstruct.codec_params = local_codec_params
            break
        }

    }

    assert(vidstruct.vid_stream_idx>-1,"Files does not contain a video stream")

    vidstruct.codec_ctx = avcodec.alloc_context3(vidstruct.codec)
    avcodec.parameters_to_context(vidstruct.codec_ctx,vidstruct.codec_params)
    avcodec.open2(vidstruct.codec_ctx,vidstruct.codec,nil)

}

cleanup_video_file :: proc(vidstruct:^VideofileContext,fname:cstring){
    defer avformat.free_context(vidstruct.format_ctx)
    defer avformat.close_input(&(vidstruct.format_ctx))
}


grab_video_frame :: proc(vid_ctx:^VideofileContext){
    packet := avcodec.packet_alloc()
    defer avcodec.packet_free(&packet)

    response:i32
    cerr:i32
    idx:int
    for{
        //grab compressed packet
        cerr = avformat.read_frame(vid_ctx.format_ctx,packet)
        assert(cerr>=0, fmt.aprintf("Could not read frame. Error %d",cerr))

        if packet.stream_index == vid_ctx.vid_stream_idx {
            //uncompress if video
            response = decode_packet(packet,vid_ctx.codec_ctx,appState.current_frame,idx)
            idx += 1
            avcodec.packet_unref(packet)
            break
        }
        avcodec.packet_unref(packet)
    }
}

AppState :: struct{
    quit:bool,
    current_frame:^types.Frame
}

//global
appState:AppState

main :: proc(){

    win,rend,surf := init_sdl2()

    appState.current_frame = avutil.frame_alloc()
    defer avutil.frame_free(&appState.current_frame)

    vid_ctx:VideofileContext
    open_video_file(&vid_ctx,`C:\Users\rmast\Downloads\SampleVideo_1280x720_1mb.mp4`)

    idx:int
    frame_rate := avutil.q2d(vid_ctx.format_ctx.streams[vid_ctx.vid_stream_idx].avg_frame_rate)
    curr_time := time.now()
    for  {
        poll_events()
        if appState.quit{
            break
        }
        if time.duration_seconds(time.diff(curr_time,time.now()))>=1/frame_rate{
            curr_time = time.now()
            grab_video_frame(&vid_ctx)
            render_frame(rend,surf,appState.current_frame)
            
            fmt.printf("frame %d\n",idx)
            idx += 1
        }
    }
}

decode_packet :: proc(packet:^types.Packet,codec_ctx:^types.Codec_Context,frame:^types.Frame,idx:int)->i32{
    response :i32= avcodec.send_packet(codec_ctx,packet)
    frame_filename:string=fmt.aprintf("./stuff %d.pgm",idx)
    //why is this a for loop? Should be one frame each?
    response = avcodec.receive_frame(codec_ctx,frame)
    if  avutil.av_error(response) == types.AVError.EOF || 
        avutil.av_error(response)==types.AVError.EAGAIN {
        return response 
    } else if response<0 {
        //EAGAIN is more like "try again".
        fmt.printf("Error receiving frame from decoder: %s\n",avutil.av_error(response))
        return response
    }
    if response>=0{
        if frame.format.video != types.Pixel_Format.YUV420P{
            fmt.println("Warning: the generated file may not be a grayscale image, but could e.g. be just the R component if the video format is RGB");
        }
    }
    
    return 0
}


render_frame :: proc(rend:^sdl2.Renderer, surf:^sdl2.Surface, frame:^types.Frame){
    //copy data from frame buffer to render buffer
    tex:= sdl2.CreateTexture(rend,cast(u32)sdl2.PixelFormatEnum.IYUV,sdl2.TextureAccess.STREAMING,frame.width,frame.height)

    assert(tex!=nil,fmt.aprintf("SDL Error: %s",strings.clone_from_cstring(sdl2.GetError())))
    defer sdl2.DestroyTexture(tex)
    cerr:i32
    //texture must be YV12 or IYUV
    cerr = sdl2.UpdateYUVTexture(tex,nil,frame.data[0],frame.linesize[0],
                                  frame.data[1],frame.linesize[1],
                                  frame.data[2],frame.linesize[2])
    assert(cerr==0,fmt.aprintf("Could not update YUV texture: %s",strings.clone_from_cstring(sdl2.GetError())))

    sdl2.SetRenderDrawColor(rend,255,255,255,255)
    sdl2.RenderClear(rend)
    sdl2.RenderCopy(rend,tex,nil,nil)
    sdl2.RenderPresent(rend)
}
