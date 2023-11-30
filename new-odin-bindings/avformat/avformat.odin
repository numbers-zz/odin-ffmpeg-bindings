/*
	Odin bindings for FFmpeg's `avformat` library.
	Bindings available under FFmpeg's license (GNU LGPL, v2.1+). See `LICENSE.md` in the package's top directory.

	Copyright (c) 2021 Jeroen van Rijn. All rights reserved.

	Libraries copyright their respective owner, available under their own licenses.
*/
package ffmpeg_avformat

import "ffmpeg:types"

when ODIN_OS == .Windows { foreign import avformat "avformat.lib"       }
when ODIN_OS == .Linux  { foreign import avformat "system:libavformat" }

/*
	Globals.
*/

//AV_FRAME_FILENAME_FLAGS_MULTIPLE:= 1 ///< Allow multiple %d

@(default_calling_convention="c")
foreign avformat {
	/*
		av_codec_ffversion: cstring
		^ segfaults on access. Address way out of range.
	*/
}

/*
	`avformat_*` functions.
*/
@(default_calling_convention="c", link_prefix="avformat_")
foreign avformat {
	//===avformat.h===

	// Return the LIBAVFORMAT_VERSION_INT constant
	// major, minor, micro := version >> 16, (version >> 8) & 255, version & 255
	version :: proc() -> (version: u32) ---

	// Return the libavformat build-time configuration.
	configuration :: proc() -> (build_time_configuration: cstring) ---

	// Return the libavformat license.
	license :: proc() -> (license: cstring) ---

	// Does global initialization of network libraries.
	network_init :: proc() -> i32 ---

	// Undoes the initialization done by avformat_network_init.
	network_deinit :: proc() -> i32 ---

	// Allocates an AVFormatContext.
	alloc_context :: proc() -> ^types.Format_Context ---

	// Frees an AVFormatContext and all its streams.
	free_context :: proc(s: ^types.Format_Context) ---

	// Gets the Class for AVFormatContext.
	get_class :: proc() -> ^types.Class ---

	// Adds a new stream to a media file.
	new_stream :: proc(s: ^types.Format_Context, c: ^types.Codec) -> ^types.Stream ---

	// Allocates an AVFormatContext for an output format.
	alloc_output_context2 :: proc(ctx: ^^types.Format_Context, oformat: ^types.Output_Format, format_name: cstring, filename: cstring) -> i32 ---

	// Opens an input stream and reads the header.
	open_input :: proc(ps: ^^types.Format_Context, url: cstring, fmt: ^types.Input_Format, options: ^^types.Dictionary) -> i32 ---

	// Reads packets of a media file to get stream information.
	find_stream_info :: proc(ic: ^types.Format_Context, options: ^^types.Dictionary) -> i32 ---

	// Seeks to timestamp ts.
	seek_file :: proc(s: ^types.Format_Context, stream_index: i32, min_ts: i64, ts: i64, max_ts: i64, flags: types.Format_Seek_Flags) -> i32 ---
	
	// Discards all internally buffered data.
	flush :: proc(s: ^types.Format_Context) -> i32 ---

	// Closes an opened input AVFormatContext.
	close_input :: proc(s: ^^types.Format_Context) ---

	// Allocates the stream private data and writes the stream header to an output media file.
	write_header :: proc(s: ^types.Format_Context, options: ^^types.Dictionary) -> i32 ---

	// Allocates the stream private data and initializes the codec, but does not write the header.
	init_output :: proc(s: ^types.Format_Context, options: ^^types.Dictionary) -> i32 ---
	
	// Gets the index entry count for the given AVStream.
	index_get_entries_count :: proc(st: ^types.Stream) -> i32 ---

	// Gets the AVIndexEntry corresponding to the given index.
	index_get_entry :: proc(st: ^types.Stream, idx: i32) -> ^types.Index_Entry ---

	// Gets the AVIndexEntry corresponding to the given timestamp.
	index_get_entry_from_timestamp :: proc(st: ^types.Stream, wanted_timestamp: i64, flags: i32) -> ^types.Index_Entry ---

	// Tests if the given container can store a codec.
	query_codec :: proc(ofmt: ^types.Output_Format, codec_id: types.Codec_ID, std_compliance: i32) -> i32 ---

	// Returns the table mapping RIFF FourCCs for video to libavcodec AVCodecID.
	get_riff_video_tags :: proc() -> ^types.Codec_Tag ---

	// Returns the table mapping RIFF FourCCs for audio to AVCodecID.
	get_riff_audio_tags :: proc() -> ^types.Codec_Tag ---

	// Returns the table mapping MOV FourCCs for video to libavcodec AVCodecID.
	get_mov_video_tags :: proc() -> ^types.Codec_Tag ---

	// Returns the table mapping MOV FourCCs for audio to AVCodecID.
	get_mov_audio_tags :: proc() -> ^types.Codec_Tag ---

	// Checks if the stream is matched by the stream specifier.
	match_stream_specifier :: proc(s: ^types.Format_Context, st: ^types.Stream, spec: cstring) -> i32 ---

	// Queues attached pictures.
	queue_attached_pictures :: proc(s: ^types.Format_Context) -> i32 ---

	// Transfers internal timing information from one stream to another.
	transfer_internal_stream_timing_info :: proc(ofmt: ^types.Output_Format, ost: ^types.Stream, ist: ^types.Stream, copy_tb: types.Timebase_Source) -> i32 ---

}

@(default_calling_convention="c", link_prefix="av_format_")
foreign avformat {
	 // Causes global side data to be injected in the next packet of each stream.
	 inject_global_side_data :: proc(s: ^types.Format_Context) ---
}
/*
	`av_*` functions.
*/
@(default_calling_convention="c", link_prefix="av_")
foreign avformat {
	//===avformat.h===
	get_packet :: proc(s: ^types.IO_Context,pkt: ^types.Packet,size: i32)-> i32 ---

	// Reads data and appends it to the current content of the Packet.
	append_packet :: proc(s: ^types.IO_Context, pkt: ^types.Packet, size: i32) -> i32 ---

	disposition_from_string :: proc(disp:cstring)->types.Disposition_Flags ---
	disposition_to_string :: proc(disposition:types.Disposition_Flags)->cstring ---

	// Gets the parser context of a stream.
	stream_get_parser :: proc(s: ^types.Stream) -> ^types.Codec_Parser_Context ---

	format_inject_global_side_data :: proc(s:^types.Format_Context) ---

	// Returns the method used to set ctx->duration.
	fmt_ctx_get_duration_estimation_method :: proc(ctx: ^types.Format_Context) -> types.Duration_Estimation_Method ---

	// Iterates over all registered muxers.
	muxer_iterate :: proc(opaque: ^rawptr) -> ^types.Output_Format ---

	// Iterates over all registered demuxers.
	demuxer_iterate :: proc(opaque: ^rawptr) -> ^types.Input_Format ---

	// Allocates a new program.
	new_program :: proc(s: ^types.Format_Context, id: i32) -> ^types.Program ---

	// Finds AVInputFormat based on the short name of the input format.
	find_input_format :: proc(short_name: cstring) -> ^types.Input_Format ---

	// Guesses the file format.
	probe_input_format :: proc(pd: ^types.Probe_Data, is_opened: i32) -> ^types.Input_Format ---
	// Guesses the file format.
	probe_input_format2 :: proc(pd: ^types.Probe_Data, is_opened: i32, score_max: ^int) -> ^types.Input_Format ---

	// Guesses the file format.
	probe_input_format3 :: proc(pd: ^types.Probe_Data, is_opened: i32, score_ret: ^int) -> ^types.Input_Format ---

	// Probes a bytestream to determine the input format.
	probe_input_buffer2 :: proc(pb: ^types.IO_Context, fmt: ^^types.Input_Format, url: cstring, logctx: rawptr, offset: u32, max_probe_size: u32) -> i32 ---

	// Probes a bytestream to determine the input format.
	probe_input_buffer :: proc(pb: ^types.IO_Context, fmt: ^^types.Input_Format, url: cstring, logctx: rawptr, offset: u32, max_probe_size: u32) -> i32 ---

	// Finds the programs which belong to a given stream.
	find_program_from_stream :: proc(ic: ^types.Format_Context, last: ^types.Program, s: i32) -> ^types.Program ---

	// Adds a stream index to a program.
	program_add_stream_index :: proc(ac: ^types.Format_Context, progid: i32, idx: u32) ---

	// Finds the "best" stream in the file.
	// No flags currently defined.
	find_best_stream :: proc(ic: ^types.Format_Context, type: types.Media_Type, wanted_stream_nb: i32, related_stream: i32, decoder_ret: ^^types.Codec, flags: i32) -> i32 ---
	// Returns the next frame of a stream.
	read_frame :: proc(s: ^types.Format_Context, pkt: ^types.Packet) -> i32 ---

	// Seeks to the keyframe at timestamp.
	seek_frame :: proc(s: ^types.Format_Context, stream_index: i32, timestamp: i64, flags: types.Format_Seek_Flags) -> i32 ---

	// Starts playing a network-based stream at the current position.
	read_play :: proc(s: ^types.Format_Context) -> i32 ---

	// Pauses a network-based stream.
	read_pause :: proc(s: ^types.Format_Context) -> i32 ---

	// Writes a packet to an output media file.
	write_frame :: proc(s: ^types.Format_Context, pkt: ^types.Packet) -> i32 ---

	// Writes a packet to an output media file ensuring correct interleaving.
	interleaved_write_frame :: proc(s: ^types.Format_Context, pkt: ^types.Packet) -> i32 ---

	// Writes an uncoded frame to an output media file.
	write_uncoded_frame :: proc(s: ^types.Format_Context, stream_index: i32, frame: ^types.Frame) -> i32 ---

	// Writes an uncoded frame to an output media file.
	interleaved_write_uncoded_frame :: proc(s: ^types.Format_Context, stream_index: i32, frame: ^types.Frame) -> i32 ---

	// Tests whether a muxer supports uncoded frame.
	write_uncoded_frame_query :: proc(s: ^types.Format_Context, stream_index: i32) -> i32 ---

	// Writes the stream trailer to an output media file and frees the file private data.
	write_trailer :: proc(s: ^types.Format_Context) -> i32 ---

	// Returns the output format in the list of registered output formats which best matches the provided parameters.
	guess_format :: proc(short_name: cstring, filename: cstring, mime_type: cstring) -> ^types.Output_Format ---

	// Guesses codec ID based on muxer and filename.
	guess_codec :: proc(fmt: ^types.Output_Format, short_name: cstring, filename: cstring, mime_type: cstring, type: types.Media_Type) -> types.Codec_ID ---

	// Gets timing information for the data currently output.
	get_output_timestamp :: proc(s: ^types.Format_Context, stream: i32,dts: ^i64, wall: ^i64) -> i32 ---

	// Sends a hexadecimal dump of a buffer to the specified file stream.
	hex_dump :: proc(f: ^types.File, buf: [^]byte, size: i32) ---

	// Sends a hexadecimal dump of a buffer to the log.
	hex_dump_log :: proc(avcl: ^types.Class, level: i32, buf: [^]byte, size: i32) ---

	// Sends a dump of a packet to the specified file stream.
	pkt_dump2 :: proc(f: ^types.File, pkt: ^types.Packet, dump_payload: i32, st: ^types.Stream) ---

	// Sends a dump of a packet to the log.
	pkt_dump_log2 :: proc(avcl: ^types.Class, level: i32, pkt: ^types.Packet, dump_payload: i32, st: ^types.Stream) ---

	// Gets the AVCodecID for the given codec tag.
	codec_get_id :: proc(tags: ^^types.Codec_Tag, tag: u32) -> types.Codec_ID ---

	// Gets the codec tag for the given codec id.
	codec_get_tag :: proc(tags: ^^types.Codec_Tag, id: types.Codec_ID) -> u32 ---

	// Gets the codec tag for the given codec id.
	codec_get_tag2 :: proc(tags: ^^types.Codec_Tag, id: types.Codec_ID, tag: ^u32) -> i32 ---

	// Finds the default stream index.
	find_default_stream_index :: proc(s: ^types.Format_Context) -> i32 ---

	// Gets the index for a specific timestamp.
	index_search_timestamp :: proc(st: ^types.Stream, timestamp: i64, flags: i32) -> i32 ---

	// Adds an index entry into a sorted list. Updates the entry if the list already contains it.
	add_index_entry :: proc(st: ^types.Stream, pos: i64, timestamp: i64, size: i32, distance: i32, flags: i32) -> i32 ---

	// Splits a URL string into components.
	url_split :: proc(proto: cstring, proto_size: i32, authorization: cstring, authorization_size: i32, hostname: cstring, hostname_size: i32,
	port_ptr: ^int, path: cstring, path_size: i32, url: cstring) ---

	// Prints detailed information about the input or output format.
	dump_format :: proc(ic: ^types.Format_Context, index: i32, url: cstring, is_output: i32) ---

	// Returns the path with '%d' replaced by a number.
	get_frame_filename2 :: proc(buf: cstring, buf_size: i32, path: cstring, number: i32, flags: types.Frame_Filename_Flags) -> i32 ---

	// Returns the path with '%d' replaced by a number.
	get_frame_filename :: proc(buf: cstring, buf_size: i32, path: cstring, number: i32) -> i32 ---

	// Checks whether filename actually is a numbered sequence generator.
	filename_number_test :: proc(filename: cstring) -> i32 ---

	// Generates an SDP for an RTP session.
	sdp_create :: proc(ac: ^^types.Format_Context, n_files: i32, buf: cstring, size: i32) -> i32 ---

	// Returns a positive value if the given filename has one of the given extensions, 0 otherwise.
	match_ext :: proc(filename: cstring, extensions: cstring) -> i32 ---

	// Guesses the sample aspect ratio of a frame.
	guess_sample_aspect_ratio :: proc(format: ^types.Format_Context, stream: ^types.Stream, frame: ^types.Frame) -> types.Rational ---

	// Guesses the frame rate.
	guess_frame_rate :: proc(ctx: ^types.Format_Context, stream: ^types.Stream, frame: ^types.Frame) -> types.Rational ---

	// Gets the internal codec timebase from a stream.
	stream_get_codec_timebase :: proc(st: ^types.Stream) -> types.Rational ---
}

//AVIO functions
@(default_calling_convention="c", link_prefix="av_")
foreign avformat {

	// Returns the name of the protocol that will handle the passed URL.
	io_find_protocol_name :: proc(url: cstring) -> cstring ---

	// Returns AVIO_FLAG_* access flags corresponding to the access permissions of the resource in url.
	io_check :: proc(url: cstring, flags: i32) -> i32 ---

	// Opens directory for reading.
	io_open_dir :: proc(s: ^^types.IO_Dir_Context, url: cstring, options: ^^types.Dictionary) -> i32 ---

	// Gets next directory entry.
	io_read_dir :: proc(s: ^types.IO_Dir_Context, next: ^^types.IO_Dir_Entry) -> i32 ---

	// Closes directory.
	
	io_close_dir :: proc(s: ^^types.IO_Dir_Context) -> i32 ---

	// Frees entry allocated by avio_read_dir().
	io_free_directory_entry :: proc(entry: ^^types.IO_Dir_Entry) ---

	// Allocates and initializes an AVIOContext for buffered I/O.
	io_alloc_context :: proc(buffer: [^]byte, buffer_size: i32, write_flag: i32, opaque: ^types.Class,
							read_packet: proc(^types.Class, [^]u8, i32) -> i32,
							write_packet: proc(^types.Class, [^]u8, i32) -> i32,
							seek: proc(^types.Class, i64, i32) -> i64) -> ^types.IO_Context ---

	// Frees the supplied IO context and everything associated with it.
	io_context_free :: proc(s: ^^types.IO_Context) ---

	io_w8 :: proc(s: ^types.IO_Context, b: i32) ---
	io_write :: proc(s: ^types.IO_Context, buf: ^u8, size: i32) ---
	io_wl64 :: proc(s: ^types.IO_Context, val: u64) ---
	io_wb64 :: proc(s: ^types.IO_Context, val: u64) ---
	io_wl32 :: proc(s: ^types.IO_Context, val: u32) ---
	io_wb32 :: proc(s: ^types.IO_Context, val: u32) ---
	io_wl24 :: proc(s: ^types.IO_Context, val: u32) ---
	io_wb24 :: proc(s: ^types.IO_Context, val: u32) ---
	io_wl16 :: proc(s: ^types.IO_Context, val: u32) ---
	io_wb16 :: proc(s: ^types.IO_Context, val: u32) ---

	// Writes a NULL-terminated string.
	io_put_str :: proc(s: ^types.IO_Context, str: cstring) -> i32 ---

	// Converts an UTF-8 string to UTF-16LE and writes it.
	io_put_str16le :: proc(s: ^types.IO_Context, str: cstring) -> i32 ---

	// Converts an UTF-8 string to UTF-16BE and writes it.
	io_put_str16be :: proc(s: ^types.IO_Context, str: cstring) -> i32 ---

	// Marks the written bytestream as a specific type.
	io_write_marker :: proc(s: ^types.IO_Context, time: i64, type: types.IO_Data_Marker_Type) ---


	// fseek() equivalent for AVIOContext.
	io_seek :: proc(s: ^types.IO_Context, offset: i64, whence: i32) -> i64 ---

	// Skips given number of bytes forward.
	io_skip :: proc(s: ^types.IO_Context, offset: i64) -> i64 ---

	// Gets the filesize.
	io_size :: proc(s: ^types.IO_Context) -> i64 ---

	// Similar to feof() but also returns nonzero on read errors.
	io_feof :: proc(s: ^types.IO_Context) -> i32 ---

	// Writes a formatted string to the context.
	io_vprintf :: proc(s: ^types.IO_Context, fmt: cstring, ap: types.va_list) -> i32 ---

	// Writes a formatted string to the context.
	io_printf :: proc(s: ^types.IO_Context, fmt: cstring) -> i32 ---

	// Writes a NULL terminated array of strings to the context.
	io_print_string_array :: proc(s: ^types.IO_Context, strings: [^]cstring) ---

	// Forces flushing of buffered data.
	io_flush :: proc(s: ^types.IO_Context) ---

	// Reads size bytes from AVIOContext into buf.
	io_read :: proc(s: ^types.IO_Context, buf: [^]u8, size: i32) -> i32 ---

	// Reads size bytes from AVIOContext into buf. This is allowed to read fewer bytes than requested.
	io_read_partial :: proc(s: ^types.IO_Context, buf: [^]u8, size: i32) -> i32 ---

	// Reads an 8-bit unsigned integer.
	io_r8 :: proc(s: ^types.IO_Context) -> i32 ---

	// Reads a 16-bit little-endian integer.
	io_rl16 :: proc(s: ^types.IO_Context) -> u32 ---

	// Reads a 24-bit little-endian integer.
	io_rl24 :: proc(s: ^types.IO_Context) -> u32 ---

	// Reads a 32-bit little-endian integer.
	io_rl32 :: proc(s: ^types.IO_Context) -> u32 ---

	// Reads a 64-bit little-endian integer.
	io_rl64 :: proc(s: ^types.IO_Context) -> u64 ---

	// Reads a 16-bit big-endian integer.
	io_rb16 :: proc(s: ^types.IO_Context) -> u32 ---

	// Reads a 24-bit big-endian integer.
	io_rb24 :: proc(s: ^types.IO_Context) -> u32 ---

	// Reads a 32-bit big-endian integer.
	io_rb32 :: proc(s: ^types.IO_Context) -> u32 ---

	// Reads a 64-bit big-endian integer.
	io_rb64 :: proc(s: ^types.IO_Context) -> u64 ---

	// Reads a string from pb into buf.
	io_get_str :: proc(pb: ^types.IO_Context, maxlen: i32, buf: cstring, buflen: i32) -> i32 ---

	// Reads a UTF-16 string from pb and converts it to UTF-8.
	io_get_str16le :: proc(pb: ^types.IO_Context, maxlen: i32, buf: [^]byte, buflen: i32) -> i32 ---
	io_get_str16be :: proc(pb: ^types.IO_Context, maxlen: i32, buf: [^]byte, buflen: i32) -> i32 ---

	// Creates and initializes an AVIOContext for accessing the resource indicated by url.
	io_open :: proc(s: ^^types.IO_Context, url: cstring, flags: types.IO_Flags) -> i32 ---

	// Creates and initializes an AVIOContext for accessing the resource indicated by url.
	io_open2 :: proc(s: ^^types.IO_Context, url: cstring, flags: types.IO_Flags,
					int_cb: ^types.IO_Interrupt_CB, options: ^^types.Dictionary) -> i32 ---

	// Closes the resource accessed by the AVIOContext s and frees it.
	io_close :: proc(s: ^types.IO_Context) -> i32 ---

	// Closes the resource accessed by the AVIOContext *s, frees it and sets the pointer pointing to it to NULL.
	io_closep :: proc(s: ^^types.IO_Context) -> i32 ---

	// Opens a write only memory stream.
	io_open_dyn_buf :: proc(s: ^^types.IO_Context) -> i32 ---

	// Returns the written size and a pointer to the buffer.
	io_get_dyn_buf :: proc(s: ^types.IO_Context, pbuffer: ^[^]u8) -> i32 ---

	// Returns the written size and a pointer to the buffer.
	io_close_dyn_buf :: proc(s: ^types.IO_Context, pbuffer: ^[^]u8) -> i32 ---

	// Iterates through names of available protocols.
	io_enum_protocols :: proc(opaque: ^rawptr, output: i32) -> cstring ---
	// Gets Class by names of available protocols.
	io_protocol_get_class :: proc(name: cstring) -> ^types.Class ---

	// Pauses and resumes playing.
	io_pause :: proc(h: ^types.IO_Context, pause: i32) -> i32 ---

	// Seeks to a given timestamp relative to some component stream.
	io_seek_time :: proc(h: ^types.IO_Context, stream_index: i32, timestamp: i64, flags: types.Format_Seek_Flags) -> i64 ---

	// Reads contents of h into print buffer.
	io_read_to_bprint :: proc(h: ^types.IO_Context, pb: ^types.BPrint, max_size: uintptr) -> i32 ---

	// Accepts and allocates a client context on a server context.
	io_accept :: proc(s: ^types.IO_Context, c: ^^types.IO_Context) -> i32 ---

	// Performs one step of the protocol handshake to accept a new client.
	io_handshake :: proc(c: ^types.IO_Context) -> i32 ---
 }

/*
	av_add_index_entry
	av_append_packet
	av_apply_bitstream_filters
	av_codec_get_id
	av_codec_get_tag
	av_codec_get_tag2
	av_demuxer_iterate
	av_demuxer_open
	av_dump_format
	av_filename_number_test
	av_find_best_stream
	av_find_default_stream_index
	av_find_input_format
	av_find_program_from_stream
	av_fmt_ctx_get_duration_estimation_method
	av_format_get_audio_codec
	av_format_get_control_message_cb
	av_format_get_data_codec
	av_format_get_metadata_header_padding
	av_format_get_opaque
	av_format_get_open_cb
	av_format_get_probe_score
	av_format_get_subtitle_codec
	av_format_get_video_codec
	av_format_inject_global_side_data
	av_format_set_audio_codec
	av_format_set_control_message_cb
	av_format_set_data_codec
	av_format_set_metadata_header_padding
	av_format_set_opaque
	av_format_set_open_cb
	av_format_set_subtitle_codec
	av_format_set_video_codec
	av_get_frame_filename
	av_get_frame_filename2
	av_get_output_timestamp
	av_get_packet
	av_guess_codec
	av_guess_format
	av_guess_frame_rate
	av_guess_sample_aspect_ratio
	av_hex_dump
	av_hex_dump_log
	av_iformat_next
	av_index_search_timestamp
	av_interleaved_write_frame
	av_interleaved_write_uncoded_frame
	av_match_ext
	av_muxer_iterate
	av_new_program
	av_oformat_next
	av_pkt_dump2
	av_pkt_dump_log2
	av_probe_input_buffer
	av_probe_input_buffer2
	av_probe_input_format
	av_probe_input_format2
	av_probe_input_format3
	av_program_add_stream_index
	av_read_frame
	av_read_pause
	av_read_play
	av_register_all
	av_register_input_format
	av_register_output_format
	av_sdp_create
	av_seek_frame
	av_stream_add_side_data
	av_stream_get_codec_timebase
	av_stream_get_end_pts
	av_stream_get_parser
	av_stream_get_r_frame_rate
	av_stream_get_recommended_encoder_configuration
	av_stream_get_side_data
	av_stream_new_side_data
	av_stream_set_r_frame_rate
	av_stream_set_recommended_encoder_configuration
	av_url_split
	av_write_frame
	av_write_trailer
	av_write_uncoded_frame
	av_write_uncoded_frame_query
	avformat_alloc_context
	avformat_alloc_output_context2
	avformat_close_input
	avformat_find_stream_info
	avformat_flush
	avformat_free_context
	avformat_get_class
	avformat_get_mov_audio_tags
	avformat_get_mov_video_tags
	avformat_get_riff_audio_tags
	avformat_get_riff_video_tags
	avformat_init_output
	avformat_match_stream_specifier
	avformat_network_deinit
	avformat_network_init
	avformat_new_stream
	avformat_open_input
	avformat_query_codec
	avformat_queue_attached_pictures
	avformat_seek_file
	avformat_transfer_internal_stream_timing_info
	avformat_write_header
	avio_accept
	avio_alloc_context
	avio_check
	avio_close
	avio_close_dir
	avio_close_dyn_buf
	avio_closep
	avio_context_free
	avio_enum_protocols
	avio_feof
	avio_find_protocol_name
	avio_flush
	avio_free_directory_entry
	avio_get_dyn_buf
	avio_get_str
	avio_get_str16be
	avio_get_str16le
	avio_handshake
	avio_open
	avio_open2
	avio_open_dir
	avio_open_dyn_buf
	avio_pause
	avio_print_string_array
	avio_printf
	avio_protocol_get_class
	avio_put_str
	avio_put_str16be
	avio_put_str16le
	avio_r8
	avio_rb16
	avio_rb24
	avio_rb32
	avio_rb64
	avio_read
	avio_read_dir
	avio_read_partial
	avio_read_to_bprint
	avio_rl16
	avio_rl24
	avio_rl32
	avio_rl64
	avio_seek
	avio_seek_time
	avio_size
	avio_skip
	avio_w8
	avio_wb16
	avio_wb24
	avio_wb32
	avio_wb64
	avio_wl16
	avio_wl24
	avio_wl32
	avio_wl64
	avio_write
	avio_write_marker
	avpriv_dv_get_packet
	avpriv_dv_init_demux
	avpriv_dv_produce_packet
	avpriv_io_delete
	avpriv_io_move
	avpriv_mpegts_parse_close
	avpriv_mpegts_parse_open
	avpriv_mpegts_parse_packet
	avpriv_new_chapter
	avpriv_register_devices
	avpriv_set_pts_info
*/