/*
	Odin bindings for FFmpeg's `avfilter` library.
	Bindings available under FFmpeg's license (GNU LGPL, v2.1+). See `LICENSE.md` in the package's top directory.

	Copyright (c) 2021 Jeroen van Rijn. All rights reserved.

	Libraries copyright their respective owner, available under their own licenses.
*/
package ffmpeg_avfilter

import "ffmpeg:types"

when ODIN_OS == .Windows { foreign import avfilter "avfilter.lib"       }
when ODIN_OS == .Linux  { foreign import avfilter "system:libavfilter" }

/*
	`avfilter_*` functions, except for `avfilter_string`, because that would conflict with the string type.
*/

AVFILTER_CMD_FLAG_ONE:=   1 ///< Stop once a filter understood the command (for target=all for example), fast filters are favored automatically
AVFILTER_CMD_FLAG_FAST:=  2 ///< Only execute command when its fast (like a video out that supports contrast adjustment in hw)


// A function pointer to be executed multiple times, possibly in parallel.
avfilter_action_func :: #type proc(ctx: ^types.Filter_Context, arg: rawptr, jobnr: i32, nb_jobs: i32) -> i32

// A function executing multiple jobs, possibly in parallel.
avfilter_execute_func :: #type proc(ctx: ^types.Filter_Context, func: avfilter_action_func, arg: rawptr, ret: ^i32, nb_jobs: i32) -> i32 


@(default_calling_convention="c", link_prefix="avfilter_")
foreign avfilter {
	//===avfilter.h===

	// Return the LIBavfilter_VERSION_INT constant
	// major, minor, micro := version >> 16, (version >> 8) & 255, version & 255
	version :: proc() -> (version: u32) ---

	// Return the libavfilter build-time configuration.
	configuration :: proc() -> (build_time_configuration: cstring) ---

	// Return the libavfilter license.
	license :: proc() -> (license: cstring) ---

	pad_get_name :: proc(pads:[^]types.Filter_Pad, pad_idx:i32)->cstring ---
	pad_get_type :: proc(pads:[^]types.Filter_Pad, pad_idx:i32)->types.Media_Type ---
	filter_pad_count :: proc(filter:^types.Filter, is_output:i32)->u32 ---

	link :: proc(src:^types.Filter_Context, srcpad:u32, dst:^types.Filter_Context, dstpad:u32)->i32 ---
	link_free :: proc(link:^^types.Filter_Link) ---

	config_links :: proc(filter:^types.Filter_Context)->i32 ---

	//It is recommended to use avfilter_graph_send_command().
	process_command :: proc(filter:^types.Filter_Context, cmd:cstring, arg:cstring, res:[^]byte, res_len:i32, flags:types.Filter_Cmd_Flags)->i32 ---

	get_by_name :: proc(name:cstring)->^types.Filter ---

	// Initializes a filter with supplied parameters.
	init_str :: proc(ctx: ^types.Filter_Context, args: cstring) -> i32 ---

	// Initializes a filter with supplied dictionary of options.
	init_dict :: proc(ctx: ^types.Filter_Context, options: ^^types.Dictionary) -> i32 ---

	// Frees a filter context.
	free :: proc(filter: ^types.Filter_Context) ---

	// Inserts a filter in the middle of an existing link.
	insert_filter :: proc(link: ^types.Filter_Link, filt: ^types.Filter_Context, filt_srcpad_idx: u32, filt_dstpad_idx: u32) -> i32 ---

	// Gets the class of a filter context.
	get_class :: proc() -> ^types.Class ---

	// Allocates a filter graph.
	graph_alloc :: proc() -> ^types.Filter_Graph ---

	// Creates a new filter instance in a filter graph.
	graph_alloc_filter :: proc(graph: ^types.Filter_Graph, filter: ^types.Filter, name: cstring) -> ^types.Filter_Context ---

	// Gets a filter instance identified by instance name from graph.
	graph_get_filter :: proc(graph: ^types.Filter_Graph, name: cstring) -> ^types.Filter_Context ---

	// Creates and adds a filter instance into an existing graph.
	graph_create_filter :: proc(filt_ctx: ^^types.Filter_Context, filt: ^types.Filter, name: cstring, args: cstring, opaque: rawptr, graph_ctx: ^types.Filter_Graph) -> i32 ---
	
	graph_set_auto_convert :: proc(graph:^types.Filter_Graph, flags:types.Filter_Auto_Convert) ---
	
	graph_config :: proc(graphctx:^types.Filter_Graph, log_ctx:rawptr)->i32 ---
	graph_free :: proc(graph:^^types.Filter_Graph) ---

	// A linked-list of the inputs/outputs of the filter chain.
	inout_alloc :: proc()->^types.Filter_In_Out ---
	inout_free :: proc(inout:^^types.Filter_In_Out) ---

	// Parses a filter graph and links it to the given graph.
	graph_parse :: proc(graph: ^types.Filter_Graph, filters: cstring, inputs: ^types.Filter_In_Out, outputs: ^types.Filter_In_Out, log_ctx: rawptr) -> i32 ---

	// Parses a filter graph, updates the inputs and outputs, and links it to the given graph.
	graph_parse_ptr :: proc(graph: ^types.Filter_Graph, filters: cstring, inputs: ^^types.Filter_In_Out, outputs: ^^types.Filter_In_Out, log_ctx: rawptr) -> i32 ---

	// Parses a filter graph, returns the unlinked inputs and outputs, and links it to the given graph.
	graph_parse2 :: proc(graph: ^types.Filter_Graph, filters: cstring, inputs: ^^types.Filter_In_Out, outputs: ^^types.Filter_In_Out) -> i32 ---

	graph_segment_parse :: proc(graph: ^types.Filter_Graph, graph_str:cstring,flags:i32,seg: ^^types.Filter_Graph_Segment)->i32 ---

	graph_segment_create_filters :: proc(seg: ^Filter_Graph_Segment,flags:i32)->i32 ---

	graph_segment_apply_opts :: proc(seg: ^Filter_Graph_Segment,flags:i32)->i32 ---

	graph_segment_init :: proc(seg: ^Filter_Graph_Segment,flags:i32)->i32 ---

	graph_segment_link :: proc(seg: ^Filter_Graph_Segment,flags:i32, inputs:^^Filter_In_Out,outputs:^^Filter_In_Out)->i32 ---

	graph_segment_apply :: proc(seg: ^Filter_Graph_Segment,flags:i32, inputs:^^Filter_In_Out,outputs:^^Filter_In_Out)->i32 ---

	graph_segment_free :: proc(seg: ^^Filter_Graph_Segment) ---


	// Sends a command to one or more filter instances in the graph.
	graph_send_command :: proc(graph: ^types.Filter_Graph, target: cstring, cmd: cstring, arg: cstring, res: [^]byte, res_len: i32, flags: types.Filter_Cmd_Flags) -> i32 ---


	// Queues a command for one or more filter instances in the graph.
	//target = "all" sends to all filters.
	graph_queue_command :: proc(graph: ^types.Filter_Graph, target: cstring, cmd: cstring, arg: cstring, flags: types.Filter_Cmd_Flags, ts: f64) -> i32 ---

	// Dumps a graph into a human-readable string representation.
	graph_dump :: proc(graph: ^types.Filter_Graph, options: cstring) -> cstring ---

	// Requests a frame on the oldest sink link in the graph.
	graph_request_oldest :: proc(graph: ^types.Filter_Graph) -> i32 ---
}

//===buffersink.h===
@(default_calling_convention="c", link_prefix="av_")
foreign avfilter {
	// Gets a frame with filtered data from sink.
	buffersink_get_frame_flags :: proc(ctx: ^types.Filter_Context, frame: ^types.Frame, flags: types.Buffer_Sink_Flags) -> i32 ---

	// Sets the frame size for an audio buffer sink.
	buffersink_set_frame_size :: proc(ctx: ^types.Filter_Context, frame_size: u32) ---

	// Buffer sink accessors to get the properties of the stream.
	buffersink_get_type :: proc(ctx: ^types.Filter_Context) -> types.Media_Type ---
	buffersink_get_time_base :: proc(ctx: ^types.Filter_Context) -> types.Rational ---
	buffersink_get_format :: proc(ctx: ^types.Filter_Context) -> i32 ---
	buffersink_get_frame_rate :: proc(ctx: ^types.Filter_Context) -> types.Rational ---
	buffersink_get_w :: proc(ctx: ^types.Filter_Context) -> i32 ---
	buffersink_get_h :: proc(ctx: ^types.Filter_Context) -> i32 ---
	buffersink_get_sample_aspect_ratio :: proc(ctx: ^types.Filter_Context) -> types.Rational ---
	buffersink_get_channels :: proc(ctx: ^types.Filter_Context) -> i32 ---
	buffersink_get_sample_rate :: proc(ctx: ^types.Filter_Context) -> i32 ---
	buffersink_get_hw_frames_ctx :: proc(ctx: ^types.Filter_Context) -> ^types.Buffer_Ref ---

	// Gets a frame with filtered data from sink.
	buffersink_get_frame :: proc(ctx: ^types.Filter_Context, frame: ^types.Frame) -> i32 ---

	// Gets a frame with filtered data from sink with the ability to specify the number of samples read.
	buffersink_get_samples :: proc(ctx: ^types.Filter_Context, frame: ^types.Frame, nb_samples: i32) -> i32 ---
 
}

//===buffersrc.h===
@(default_calling_convention="c", link_prefix="av_")
foreign avfilter {
    // Gets the number of failed requests.
    buffersrc_get_nb_failed_requests :: proc(buffer_src: ^types.Filter_Context) -> u32 ---

    // Allocates a new BufferSrcParameters instance.
    buffersrc_parameters_alloc :: proc() -> ^types.Filter_Buffer_Src_Parameters ---

    // Initializes the buffersrc or abuffersrc filter with the provided parameters.
    buffersrc_parameters_set :: proc(ctx: ^types.Filter_Context, param: ^types.Filter_Buffer_Src_Parameters) -> i32 ---

    // Adds a frame to the buffer source.
    buffersrc_write_frame :: proc(ctx: ^types.Filter_Context, frame: ^types.Frame) -> i32 ---

    // Adds a frame to the buffer source.
    buffersrc_add_frame :: proc(ctx: ^types.Filter_Context, frame: ^types.Frame) -> i32 ---

    // Adds a frame to the buffer source.
    buffersrc_add_frame_flags :: proc(buffer_src: ^types.Filter_Context, frame: ^types.Frame, flags: types.Buffer_Src_Flags) -> i32 ---

    // Closes the buffer source after EOF.
    buffersrc_close :: proc(ctx: ^types.Filter_Context, pts: i64, flags: types.Buffer_Src_Flags) -> i32 ---
}

@(default_calling_convention="c", link_prefix="av_filter_")
foreign avfilter {
	//===avfilter.h===
	iterate :: proc(opaque:^rawptr)->^types.Filter ---
}
/*
	av_abuffersink_params_alloc
	av_buffersink_get_channel_layout
	av_buffersink_get_channels
	av_buffersink_get_format
	av_buffersink_get_frame
	av_buffersink_get_frame_flags
	av_buffersink_get_frame_rate
	av_buffersink_get_h
	av_buffersink_get_hw_frames_ctx
	av_buffersink_get_sample_aspect_ratio
	av_buffersink_get_sample_rate
	av_buffersink_get_samples
	av_buffersink_get_time_base
	av_buffersink_get_type
	av_buffersink_get_w
	av_buffersink_params_alloc
	av_buffersink_set_frame_size
	av_buffersrc_add_frame
	av_buffersrc_add_frame_flags
	av_buffersrc_close
	av_buffersrc_get_nb_failed_requests
	av_buffersrc_parameters_alloc
	av_buffersrc_parameters_set
	av_buffersrc_write_frame
	av_filter_ffversion
	av_filter_iterate
	avfilter_add_matrix
	avfilter_config_links
	avfilter_free
	avfilter_get_by_name
	avfilter_get_class
	avfilter_graph_alloc
	avfilter_graph_alloc_filter
	avfilter_graph_config
	avfilter_graph_create_filter
	avfilter_graph_dump
	avfilter_graph_free
	avfilter_graph_get_filter
	avfilter_graph_parse
	avfilter_graph_parse2
	avfilter_graph_parse_ptr
	avfilter_graph_queue_command
	avfilter_graph_request_oldest
	avfilter_graph_send_command
	avfilter_graph_set_auto_convert
	avfilter_init_dict
	avfilter_init_str
	avfilter_inout_alloc
	avfilter_inout_free
	avfilter_insert_filter
	avfilter_link
	avfilter_link_free
	avfilter_link_get_channels
	avfilter_link_set_closed
	avfilter_make_format64_list
	avfilter_mul_matrix
	avfilter_next
	avfilter_pad_count
	avfilter_pad_get_name
	avfilter_pad_get_type
	avfilter_process_command
	avfilter_register
	avfilter_register_all
	avfilter_sub_matrix
	avfilter_transform
*/