/*
	Odin bindings for FFmpeg's `avcodec` library.
	Bindings available under FFmpeg's license (GNU LGPL, v2.1+). See `LICENSE.md` in the package's top directory.

	Copyright (c) 2021 Jeroen van Rijn. All rights reserved.

	Libraries copyright their respective owner, available under their own licenses.
*/
package ffmpeg_avcodec

import "ffmpeg:types"
import "core:c"

when ODIN_OS == .Windows { foreign import avcodec "avcodec.lib"       }
when ODIN_OS == .Linux   { foreign import avcodec "system:libavcodec" }

/*
	Globals.
*/
@(default_calling_convention="c")
foreign avcodec {
	avcodec_string :: proc(buf:[^]byte, buf_size:i32, enc:^types.Codec_Context, encode:i32) ---

	/*
		av_codec_ffversion: cstring
		^ segfaults on access. Address way out of range.
	*/
}

/* 
	Functions that conflict with similarly named av_ versions
*/
@(default_calling_convention="c", link_prefix="av")
foreign avcodec {
	//===avcodec.h===
	subtitle_free :: proc(sub:^types.Subtitle)  ---
	//===avdct.h===
	codec_dct_alloc :: proc()->^types.DCT ---
	codec_dct_init :: proc(avdct:^types.DCT)->i32  ---
	codec_dct_get_class :: proc()->^types.Class ---
}
/*
	`avcodec_*` functions, except for `avcodec_string`, because that would conflict with the string type.
*/
@(default_calling_convention="c", link_prefix="avcodec_")
foreign avcodec {
	//===avcodec.h===

	// Return the LIBAVCODEC_VERSION_INT constant
	// major, minor, micro := version >> 16, (version >> 8) & 255, version & 255
	version         :: proc() -> (version: u32) ---

	// Return the libavcodec build-time configuration.
	configuration   :: proc() -> (build_time_configuration: cstring) ---

	// Return the libavcodec license.
	license         :: proc() -> (license: cstring) ---

	alloc_context3 :: proc(codec:^types.Codec)->^types.Codec_Context ---
	free_context :: proc(avctx:^^types.Codec_Context)  ---
	get_class :: proc()->^types.Class ---
	
	get_subtitle_rect_class :: proc()->^types.Class ---
	parameters_from_context :: proc(par:^types.Codec_Parameters, codec:^types.Codec_Context)->i32 ---
	parameters_to_context :: proc(codec:^types.Codec_Context, par:^types.Codec_Parameters)-> i32 ---
	open2 :: proc(avctx:^types.Codec_Context, codec:^types.Codec, options:^^types.Dictionary)->i32  ---
	close :: proc(avctx:^types.Codec_Context)->i32  ---
	default_get_buffer2 :: proc(s:^types.Codec_Context, frame:^types.Frame,  flags:types.Codec_Flags)->i32  ---
	default_get_encode_buffer :: proc(s:^types.Codec_Context, pkt:^types.Packet,  flags:types.Codec_Flags_2)->i32  ---
	align_dimensions :: proc(s:^types.Codec_Context, width:^i32, height:^i32)  ---
	align_dimensions2 :: proc(s:^types.Codec_Context, width:^i32, height:^i32, linesize_align:[types.NUM_DATA_POINTERS]int) ---
	//chroma_location_enum_to_pos :: proc(xpos:^i32, ypos:^i32, pos:types.Chroma_Location)->i32  ---
	//chroma_location_pos_to_enum :: proc(xpos:i32, ypos:i32)->types.Chroma_Location  ---
	decode_subtitle2 :: proc(avctx:^types.Codec_Context, sub:^types.Subtitle, got_sub_ptr:^i32, avpkt:^types.Packet)->i32 ---
	send_packet :: proc(avctx:^types.Codec_Context, avpkt:^types.Packet)->i32  ---
	receive_frame :: proc(avctx:^types.Codec_Context, frame:^types.Frame)->i32  ---
	send_frame :: proc(avctx:^types.Codec_Context, frame:^types.Frame)->i32  ---
	receive_packet :: proc(avctx:^types.Codec_Context, avpkt:^types.Packet)->i32  ---
	get_hw_frames_parameters :: proc(avctx:^types.Codec_Context, device_ref:^types.Buffer_Ref, hw_pix_fmt:types.Pixel_Format, out_frames_ref:^^types.Buffer_Ref)->i32 ---
	encode_subtitle :: proc(avctx:^types.Codec_Context, buf:[^]byte,  buf_size:i32, sub:^types.Subtitle)->i32 ---
	pix_fmt_to_codec_tag :: proc(pix_fmt:types.Pixel_Format)->u32  ---
	find_best_pix_fmt_of_list :: proc(pix_fmt_list:[^]types.Pixel_Format, src_pix_fmt:types.Pixel_Format, has_alpha:i32, loss_ptr:^i32)->types.Pixel_Format ---
	default_get_format :: proc(s:^types.Codec_Context, fmt:^types.Pixel_Format)->types.Pixel_Format  ---
	default_execute :: proc(c:^types.Codec_Context, func:proc(c2:^types.Codec_Context, arg2:rawptr)->int,arg:rawptr, ret:^i32, count:i32, size:i32)->i32  ---
	default_execute2 :: proc(c:^types.Codec_Context, func:proc(c2:^types.Codec_Context, arg2:rawptr, arg3:i32, arg4:i32)->i32,arg:rawptr, ret:^i32,  count:i32)->i32  ---
	fill_audio_frame :: proc(frame:^types.Frame,  nb_channels:i32, sample_fmt:types.Sample_Format, buf:[^]byte, buf_size:i32,  align:i32)->i32 ---
	flush_buffers :: proc(avctx:^types.Codec_Context)  ---

	//===codec.h===
	find_decoder :: proc(id:types.Codec_ID)->^types.Codec ---
	find_decoder_by_name :: proc(name:cstring)->^types.Codec ---
	find_encoder :: proc(id:types.Codec_ID)->^types.Codec ---
	find_encoder_by_name :: proc(name:cstring)->^types.Codec ---
	get_hw_config :: proc(codec:^types.Codec,  index:i32)->^types.Codec_Hardware_Config ---
	

	//===codec_desc.h===
	descriptor_get :: proc(id:types.Codec_ID)->^types.Codec_Descriptor ---
	descriptor_next :: proc(prev:^types.Codec_Descriptor)->^types.Codec_Descriptor ---
	descriptor_get_by_name :: proc(name:cstring)->^types.Codec_Descriptor ---
	
	//===codec_id.h===
	get_type :: proc(codec_id:types.Codec_ID)->types.Media_Type  ---
	get_name :: proc(id:types.Codec_ID)->cstring ---
	profile_name :: proc(codec_id:types.Codec_ID,  profile:i32)->cstring ---
	
	
	//===codec_par.h===
	parameters_alloc :: proc()->^types.Codec_Parameters ---
	parameters_free :: proc(par:^^types.Codec_Parameters)  ---
	parameters_copy :: proc(dst:^types.Codec_Parameters, src:^types.Codec_Parameters)->i32  ---
	
	is_open :: proc(s:^types.Codec_Context)->i32  ---
}


@(default_calling_convention="c", link_prefix="av_")
foreign avcodec {
	//===ac3_parser.h===
	ac3_parse_header :: proc(buf:^byte, size:uintptr, bitstream_id:^u8, frame_size:^u16)->i32 ---
	//===adts_parser.h===
	adts_header_parse :: proc(buf:^byte, samples:[]u32, frames:^u8)->i32 ---
	//===d3d11va.h===
	d3d11va_alloc_context :: proc()->^types.D3D11VA_Context ---

	//===defs.h===
	cpb_properties_alloc :: proc(size:^uintptr)->^types.Codec_Bitrate_Properties ---
	xiphlacing :: proc(s:[^]byte, v:u32)->u32  --- 

	//===dirac.h===
	dirac_parse_sequence_header :: proc(dsh:^^types.Dirac_Sequence_Header, buf:[^]byte, buf_size:uintptr, log_ctx:rawptr)->i32 ---

	//===dv_profile.h===
	dv_frame_profile :: proc(sys:^types.DV_Profile, frame:[^]byte, buf_size:uint) ---
	dv_codec_profile :: proc( width:i32,  height:i32, pix_fmt:types.Pixel_Format)->^types.DV_Profile ---
	dv_codec_profile2 :: proc( width:i32,  height:i32, pix_fmt:types.Pixel_Format, frame_rate:types.Rational)->^types.DV_Profile ---

	//===jni.h===
	jni_set_java_vm :: proc(vm:rawptr, log_ctx:rawptr)->i32  ---
	jni_get_java_vm :: proc(log_ctx:rawptr)->rawptr ---

	//===mediacodec.h===
	mediacodec_alloc_context :: proc()->^types.Media_Codec_Context ---
	mediacodec_default_init :: proc(avctx:^types.Codec_Context, ctx:^types.Media_Codec_Context, surface:rawptr)->i32  ---
	mediacodec_default_free :: proc(avctx:^types.Codec_Context)  ---
	mediacodec_release_buffer :: proc(buffer:^types.Media_Codec_Buffer,  render:i32)->i32  ---
	mediacodec_render_buffer_at_time :: proc(buffer:^types.Media_Codec_Buffer, time:i64)->i32  ---

	//===avcodec.h===
	parser_iterate :: proc(opaque:^rawptr)->^types.Codec_Parser ---
	parser_init :: proc( codec_id:i32)->^types.Codec_Parser_Context ---
	parser_parse2 :: proc(s:^types.Codec_Parser_Context, avctx:^types.Codec_Context, poutbuf:^[^]byte, poutbuf_size:^i32, buf:[^]byte,  buf_size:i32, pts:i64, dts:i64, pos:i64)->i32 ---
	parser_close :: proc(s:^types.Codec_Parser_Context)  ---

	get_audio_frame_duration :: proc(avctx:^types.Codec_Context,  frame_bytes:i32)->i32  ---
	fast_padded_malloc :: proc(ptr:rawptr, size:^u32, min_size:uintptr)  ---
	fast_padded_mallocz :: proc(ptr:rawptr, size:^u32, min_size:uintptr)  ---


	//===codec_id.h===
	get_bits_per_sample :: proc(codec_id:types.Codec_ID)->i32  ---
	get_exact_bits_per_sample :: proc(codec_id:types.Codec_ID)->i32  ---
	get_pcm_codec :: proc( fmt:types.Sample_Format,  be:i32)->types.Codec_ID  ---
	
	//===codec_par.h===
	get_audio_frame_duration2 :: proc(par:^types.Codec_Parameters,  frame_bytes:i32)->i32  ---

	//===codec.h===
	get_profile_name :: proc(codec:^types.Codec,  profile:i32)->cstring ---

	
}

/* FFT Functions */
@(default_calling_convention="c", link_prefix="av_")
foreign avcodec {
	//===avfft.h===
	fft_init :: proc( nbits:i32,  inverse:i32)->^types.FFT_Context ---
	fft_permute :: proc(s:^types.FFT_Context, z:^types.FFT_Complex)  ---
	fft_calc :: proc(s:^types.FFT_Context, z:^types.FFT_Complex)  ---
	fft_end :: proc(s:^types.FFT_Context)  ---
}

// BSF Functions
@(default_calling_convention="c", link_prefix="av_")
foreign avcodec {
	//===bsf.h===
	bsf_get_by_name :: proc(name:cstring)->^types.Bit_Stream_Filter ---
	bsf_iterate :: proc(opaque:^rawptr)->^types.Bit_Stream_Filter ---
	bsf_alloc :: proc(filter:^types.Bit_Stream_Filter, ctx:^^types.BSF_Context)->i32  ---
	bsf_init :: proc(ctx:types.BSF_Context)->i32  ---
	bsf_send_packet :: proc(ctx:types.BSF_Context, pkt:^types.Packet)->i32  ---
	bsf_receive_packet :: proc(ctx:types.BSF_Context, pkt:^types.Packet)->i32  ---
	bsf_flush :: proc(ctx:types.BSF_Context)  ---
	bsf_free :: proc(ctx:^^types.BSF_Context)  ---
	bsf_get_class :: proc()->^types.Class ---

	bsf_list_alloc :: proc()->^types.BSF_List ---
	bsf_list_free :: proc(lst:^^types.BSF_List)  ---
	bsf_list_append :: proc(lst:^types.BSF_List, bsf:types.BSF_Context)->i32  ---
	bsf_list_append2 :: proc(lst:^types.BSF_List,  bsf_name:cstring, options:^^types.Dictionary)->i32  ---
	bsf_list_finalize :: proc(lst:^^types.BSF_List, bsf:^^types.BSF_Context)->i32  ---
	bsf_list_parse_str :: proc(str:cstring, bsf:^^types.BSF_Context)->i32  ---
	bsf_get_null_filter :: proc(bsf:^^types.BSF_Context)->i32  ---
}

@(default_calling_convention="c", link_prefix="av_")
foreign avcodec {
	//===packet.h===
	packet_side_data_new :: proc(psd:^[^]types.Packet_Side_Data,pnb_sd:i32,type:types.Packet_Side_Data_Type,size:uintptr,flags:i32)->^types.Packet_Side_Data ---
	packet_side_data_add :: proc(psd:^[^]types.Packet_Side_Data,pnb_sd:i32,type:types.Packet_Side_Data_Type,data:rawptr,size:uintptr,flags:i32)->^types.Packet_Side_Data ---
	packet_side_data_get :: proc(psd:[^]types.Packet_Side_Data,pnb_sd:i32,type:types.Packet_Side_Data_Type)->^types.Packet_Side_Data ---
	packet_side_data_remove :: proc(psd:[^]types.Packet_Side_Data,pnb_sd:i32,type:types.Packet_Side_Data_Type) ---
	packet_side_data_free :: proc(psd:^[^]types.Packet_Side_Data,pnb_sd:i32) ---
	packet_side_data_name :: proc(type:types.Packet_Side_Data_Type)->cstring ---


	packet_alloc :: proc()->^types.Packet ---
	packet_clone :: proc(src:^types.Packet)->^types.Packet ---
	packet_free :: proc(pkt:^^types.Packet)  ---
	new_packet :: proc(pkt:^types.Packet,  size:i32)->types.AVError_Int  ---
	shrink_packet :: proc(pkt:^types.Packet,  size:i32)  ---
	grow_packet :: proc(pkt:^types.Packet,  grow_by:i32)->i32  ---
	packet_from_data :: proc(pkt:^types.Packet, data:[^]byte,  size:i32)->types.AVError_Int  ---
	packet_new_side_data :: proc(pkt:^types.Packet, type:types.Packet_Side_Data_Type, size:uintptr)->[^]byte ---
	packet_add_side_data :: proc(pkt:^types.Packet, type:types.Packet_Side_Data_Type, data:[^]byte, size:uintptr)-> types.AVError_Int ---
	packet_shrink_side_data :: proc(pkt:^types.Packet, type:types.Packet_Side_Data_Type, size:uintptr)-> types.AVError_Int ---
	packet_get_side_data :: proc(pkt:^types.Packet, type:types.Packet_Side_Data_Type, size:^uintptr)->[^]byte ---
	packet_pack_dictionary :: proc(dict:^types.Dictionary, size:^uintptr)->[^]byte ---
	packet_unpack_dictionary :: proc(data:^byte, size:uintptr, dict:^^types.Dictionary)->types.AVError_Int ---
	packet_free_side_data :: proc(pkt:^types.Packet)  ---
	packet_ref :: proc(dst:^types.Packet, src:^types.Packet)->types.AVError_Int  ---
	packet_unref :: proc(pkt:^types.Packet)  ---
	packet_move_ref :: proc(dst:^types.Packet, src:^types.Packet)  ---
	packet_copy_props :: proc(dst:^types.Packet, src:^types.Packet)->types.AVError_Int  ---
	packet_make_refcounted :: proc(pkt:^types.Packet)->types.AVError_Int  ---
	packet_make_writable :: proc(pkt:^types.Packet)->types.AVError_Int  ---
	packet_rescale_ts :: proc(pkt:^types.Packet, tb_src:types.Rational, tb_dst:types.Rational)  ---
}

@(default_calling_convention="c", link_prefix="av_")
foreign avcodec {
	//===qsv.h===
	//qsv_alloc_context :: proc()->^types.QSV_Context ---

	//VDPAU is for Unix video decoding API for using GPUs.

	/*
	vdpau_hwaccel_get_render2 :: proc(ctx:^AVVDPAUContext)->AVVDPAU_Render2  ---
	vdpau_hwaccel_set_render2 :: proc(ctx:^AVVDPAUContext, render:AVVDPAU_Render2)  ---
	vdpau_bind_context :: proc(avctx:^types.Codec_Context, device:VdpDevice, get_proc_address:^VdpGetProcAddress, flags:uint)->int ---
	vdpau_get_surface_parameters :: proc(avctx:^types.Codec_Context, type:^types.VdpChromaType, width:^u32, height:^u32)->int ---
	vdpau_alloc_context :: proc()->^AVVDPAUContext ---
*/


	vorbis_parse_init :: proc(extradata:[^]byte, extradata_size:i32)->types.Vorbis_Parse_Context ---
	vorbis_parse_free :: proc(s:^^types.Vorbis_Parse_Context)  ---
	vorbis_parse_frame_flags :: proc(s:^types.Vorbis_Parse_Context, buf:[^]byte, buf_size:i32, flags:^types.Vorbis_Flags)-> i32 ---
	vorbis_parse_frame :: proc(s:^types.Vorbis_Parse_Context, buf:^byte, buf_size:i32)-> i32 ---
	vorbis_parse_reset :: proc(s:^types.Vorbis_Parse_Context)  ---
}

/*
	`av_codec_*` functions.
*/
@(default_calling_convention="c", link_prefix="av_codec_")
foreign avcodec {
	//===codec.h===
	// Iterate over all codecs
	iterate    :: proc(iter: ^rawptr) -> (codec: ^types.Codec) ---
	is_decoder ::  proc(codec: ^types.Codec) -> c.int ---
	is_encoder :: proc(codec: ^types.Codec) -> c.int ---

}
/*
	av_ac3_parse_header
	av_adts_header_parse
	av_bitstream_filter_close
	av_bitstream_filter_filter
	av_bitstream_filter_init
	av_bitstream_filter_next
	av_bsf_alloc
	av_bsf_flush
	av_bsf_free
	av_bsf_get_by_name
	av_bsf_get_class
	av_bsf_get_null_filter
	av_bsf_init
	av_bsf_iterate
	av_bsf_list_alloc
	av_bsf_list_append
	av_bsf_list_append2
	av_bsf_list_finalize
	av_bsf_list_free
	av_bsf_list_parse_str
	av_bsf_next
	av_bsf_receive_packet
	av_bsf_send_packet
	av_codec_get_chroma_intra_matrix
	av_codec_get_codec_descriptor
	av_codec_get_codec_properties
	av_codec_get_lowres
	av_codec_get_max_lowres
	av_codec_get_pkt_timebase
	av_codec_get_seek_preroll
	av_codec_is_decoder
	av_codec_is_encoder
	av_codec_iterate
	av_codec_next
	av_codec_set_chroma_intra_matrix
	av_codec_set_codec_descriptor
	av_codec_set_lowres
	av_codec_set_pkt_timebase
	av_codec_set_seek_preroll
	av_copy_packet
	av_copy_packet_side_data
	av_cpb_properties_alloc
	av_d3d11va_alloc_context
	av_dct_calc
	av_dct_end
	av_dct_init
	av_dirac_parse_sequence_header
	av_dup_packet
	av_dv_codec_profile
	av_dv_codec_profile2
	av_dv_frame_profile
	av_fast_padded_malloc
	av_fast_padded_mallocz
	av_fft_calc
	av_fft_end
	av_fft_init
	av_fft_permute
	av_free_packet
	av_get_audio_frame_duration
	av_get_audio_frame_duration2
	av_get_bits_per_sample
	av_get_codec_tag_string
	av_get_exact_bits_per_sample
	av_get_pcm_codec
	av_get_profile_name
	av_grow_packet
	av_hwaccel_next
	av_imdct_calc
	av_imdct_half
	av_init_packet
	av_jni_get_java_vm
	av_jni_set_java_vm
	av_lockmgr_register
	av_mdct_calc
	av_mdct_end
	av_mdct_init
	av_mediacodec_alloc_context
	av_mediacodec_default_free
	av_mediacodec_default_init
	av_mediacodec_release_buffer
	av_mediacodec_render_buffer_at_time
	av_new_packet
	av_packet_add_side_data
	av_packet_alloc
	av_packet_clone
	av_packet_copy_props
	av_packet_free
	av_packet_free_side_data
	av_packet_from_data
	av_packet_get_side_data
	av_packet_make_refcounted
	av_packet_make_writable
	av_packet_merge_side_data
	av_packet_move_ref
	av_packet_new_side_data
	av_packet_pack_dictionary
	av_packet_ref
	av_packet_rescale_ts
	av_packet_shrink_side_data
	av_packet_side_data_name
	av_packet_split_side_data
	av_packet_unpack_dictionary
	av_packet_unref
	av_parser_change
	av_parser_close
	av_parser_init
	av_parser_iterate
	av_parser_next
	av_parser_parse2
	av_picture_copy
	av_picture_crop
	av_picture_pad
	av_qsv_alloc_context
	av_rdft_calc
	av_rdft_end
	av_rdft_init
	av_register_bitstream_filter
	av_register_codec_parser
	av_register_hwaccel
	av_shrink_packet
	av_vorbis_parse_frame
	av_vorbis_parse_frame_flags
	av_vorbis_parse_free
	av_vorbis_parse_init
	av_vorbis_parse_reset
	av_xiphlacing
	avcodec_align_dimensions
	avcodec_align_dimensions2
	avcodec_alloc_context3
	avcodec_chroma_pos_to_enum
	avcodec_close
	avcodec_copy_context
	avcodec_dct_alloc
	avcodec_dct_get_class
	avcodec_dct_init
	avcodec_decode_audio4
	avcodec_decode_subtitle2
	avcodec_decode_video2
	avcodec_default_execute
	avcodec_default_execute2
	avcodec_default_get_buffer2
	avcodec_default_get_encode_buffer
	avcodec_default_get_format
	avcodec_descriptor_get
	avcodec_descriptor_get_by_name
	avcodec_descriptor_next
	avcodec_encode_audio2
	avcodec_encode_subtitle
	avcodec_encode_video2
	avcodec_enum_to_chroma_pos
	avcodec_fill_audio_frame
	avcodec_find_best_pix_fmt2
	avcodec_find_best_pix_fmt_of_2
	avcodec_find_best_pix_fmt_of_list
	avcodec_find_decoder
	avcodec_find_decoder_by_name
	avcodec_find_encoder
	avcodec_find_encoder_by_name
	avcodec_flush_buffers
	avcodec_free_context
	avcodec_get_chroma_sub_sample
	avcodec_get_class
	avcodec_get_context_defaults3
	avcodec_get_frame_class
	avcodec_get_hw_config
	avcodec_get_hw_frames_parameters
	avcodec_get_name
	avcodec_get_pix_fmt_loss
	avcodec_get_subtitle_rect_class
	avcodec_get_type
	avcodec_is_open
	avcodec_open2
	avcodec_parameters_alloc
	avcodec_parameters_copy
	avcodec_parameters_free
	avcodec_parameters_from_context
	avcodec_parameters_to_context
	avcodec_pix_fmt_to_codec_tag
	avcodec_profile_name
	avcodec_receive_frame
	avcodec_receive_packet
	avcodec_register
	avcodec_register_all
	avcodec_send_frame
	avcodec_send_packet
	avcodec_string
	avpicture_alloc
	avpicture_fill
	avpicture_free
	avpicture_get_size
	avpicture_layout
	avpriv_ac3_channel_layout_tab
	avpriv_ac3_parse_header
	avpriv_align_put_bits
	avpriv_codec2_mode_bit_rate
	avpriv_codec2_mode_block_align
	avpriv_codec2_mode_frame_size
	avpriv_codec_get_cap_skip_frame_fill_param
	avpriv_copy_bits
	avpriv_dca_convert_bitstream
	avpriv_dca_parse_core_frame_header
	avpriv_dca_sample_rates
	avpriv_dnxhd_get_frame_size
	avpriv_dnxhd_get_hr_frame_size
	avpriv_dnxhd_get_interlaced
	avpriv_do_elbg
	avpriv_exif_decode_ifd
	avpriv_find_pix_fmt
	avpriv_find_start_code
	avpriv_fits_header_init
	avpriv_fits_header_parse_line
	avpriv_get_raw_pix_fmt_tags
	avpriv_h264_has_num_reorder_frames
	avpriv_init_elbg
	avpriv_mjpeg_bits_ac_chrominance
	avpriv_mjpeg_bits_ac_luminance
	avpriv_mjpeg_bits_dc_chrominance
	avpriv_mjpeg_bits_dc_luminance
	avpriv_mjpeg_val_ac_chrominance
	avpriv_mjpeg_val_ac_luminance
	avpriv_mjpeg_val_dc
	avpriv_mpa_bitrate_tab
	avpriv_mpa_freq_tab
	avpriv_mpeg4audio_get_config
	avpriv_mpeg4audio_get_config2
	avpriv_mpeg4audio_sample_rates
	avpriv_mpegaudio_decode_header
	avpriv_packet_list_free
	avpriv_packet_list_get
	avpriv_packet_list_put
	avpriv_pix_fmt_bps_avi
	avpriv_pix_fmt_bps_mov
	avpriv_split_xiph_headers
	avpriv_tak_parse_streaminfo
	avpriv_toupper4
	avsubtitle_free
*/