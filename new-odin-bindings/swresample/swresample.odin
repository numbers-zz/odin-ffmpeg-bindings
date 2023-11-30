/*
	Odin bindings for FFmpeg's `swresample` library.
	Bindings available under FFmpeg's license (GNU LGPL, v2.1+). See `LICENSE.md` in the package's top directory.

	Copyright (c) 2021 Jeroen van Rijn. All rights reserved.

	Libraries copyright their respective owner, available under their own licenses.
*/
package ffmpeg_swresample

import "../types"

when ODIN_OS == .Windows { foreign import swresample "swresample.lib"       }
when ODIN_OS == .Linux  { foreign import swresample "system:libswresample" }

/*
	`swresample_*` functions.
*/
@(default_calling_convention="c", link_prefix="swresample_")
foreign swresample {
	// Return the LIBswresample_VERSION_INT constant
	// major, minor, micro := version >> 16, (version >> 8) & 255, version & 255
	version :: proc() -> (version: u32) ---

	// Return the libswresample build-time configuration.
	configuration :: proc() -> (build_time_configuration: cstring) ---

	// Return the libswresample license.
	license :: proc() -> (license: cstring) ---

}

@(default_calling_convention="c", link_prefix="swr_")
foreign swresample {
	// Gets the AVClass for Software_Resample_Context
	get_class :: proc() -> ^types.Class ---

	// Allocates Software_Resample_Context
	alloc :: proc() -> ^types.Software_Resample_Context ---

	// Initializes context after user parameters have been set
	init :: proc(s: ^types.Software_Resample_Context) -> i32 ---

	// Checks whether an swr context has been initialized or not
	is_initialized :: proc(s: ^types.Software_Resample_Context) -> i32 ---

	// Allocates Software_Resample_Context if needed and sets/resets common parameters
	alloc_set_opts2 :: proc(s: ^types.Software_Resample_Context,
							out_ch_layout: ^types.Channel_Layout, out_sample_fmt: types.Sample_Format, out_sample_rate: i32, 
							in_ch_layout: ^types.Channel_Layout, in_sample_fmt: types.Sample_Format, in_sample_rate: i32,
							log_offset: i32, log_ctx: rawptr) -> ^types.Software_Resample_Context ---

	// Frees the given Software_Resample_Context and sets the pointer to NULL
	free :: proc(s: ^^types.Software_Resample_Context) ---

	// Closes the context so that is_initialized() returns 0
	close :: proc(s: ^types.Software_Resample_Context) ---

	// Converts audio
	convert :: proc(s: ^types.Software_Resample_Context, buffer_out: [^][^]u8, out_count: i32, buffer_in: [^][^]u8, in_count: i32) -> i32 ---

	// Converts the next timestamp from input to output
	next_pts :: proc(s: ^types.Software_Resample_Context, pts: i64) -> i64 ---

	// Activates resampling compensation ("soft" compensation)
	set_compensation :: proc(s: ^types.Software_Resample_Context, sample_delta: i32, compensation_distance: i32) -> i32 ---

	// Sets a customized input channel mapping
	set_channel_mapping :: proc(s: ^types.Software_Resample_Context, channel_map: ^i32) -> i32 ---

	// Generates a channel mixing matrix
	build_matrix2 :: proc(in_layout: ^types.Channel_Layout, out_layout: ^types.Channel_Layout, center_mix_level: f64, surround_mix_level: f64,
						lfe_mix_level: f64, rematrix_maxval: f64, rematrix_volume: f64, swr_matrix: ^f64, stride: i32, matrix_encoding: types.Matrix_Encoding, log_ctx: rawptr) -> i32 ---

	// Sets a customized remix matrix
	set_matrix :: proc(s: ^types.Software_Resample_Context, swr_matrix: ^f64, stride: i32) -> i32 ---

	// Drops the specified number of output samples
	drop_output :: proc(s: ^types.Software_Resample_Context, count: i32) -> i32 ---

	// Injects the specified number of silence samples
	inject_silence :: proc(s: ^types.Software_Resample_Context, count: i32) -> i32 ---

	// Gets the delay the next input sample will experience relative to the next output sample
	get_delay :: proc(s: ^types.Software_Resample_Context, base: i64) -> i64 ---

	// Finds an upper bound on the number of samples that the next convert call will output, if called with in_samples of input samples
	get_out_samples :: proc(s: ^types.Software_Resample_Context, in_samples: i32) -> i32 ---

	// Converts the samples in the input AVFrame and writes them to the output AVFrame
	convert_frame :: proc(swr: ^types.Software_Resample_Context, output: ^types.Frame, input: ^types.Frame) -> i32 ---

	// Configures or reconfigures the Software_Resample_Context using the information provided by the AVFrames
	config_frame :: proc(swr: ^types.Software_Resample_Context, out: ^types.Frame, frame_in: ^types.Frame) -> i32 ---

 }
/*
	swr_alloc
	swr_alloc_set_opts
	swr_build_matrix
	swr_close
	swr_config_frame
	swr_convert
	swr_convert_frame
	swr_drop_output
	swr_ffversion
	swr_free
	swr_get_class
	swr_get_delay
	swr_get_out_samples
	swr_init
	swr_inject_silence
	swr_is_initialized
	swr_next_pts
	swr_set_channel_mapping
	swr_set_compensation
	swr_set_matrix
*/