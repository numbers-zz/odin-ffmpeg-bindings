/*
	Odin bindings for FFmpeg's `swscale` library.
	Bindings available under FFmpeg's license (GNU LGPL, v2.1+). See `LICENSE.md` in the package's top directory.

	Copyright (c) 2021 Jeroen van Rijn. All rights reserved.

	Libraries copyright their respective owner, available under their own licenses.
*/
package ffmpeg_swscale

import "../types"

when ODIN_OS == .Windows { foreign import swscale "swscale.lib"       }
when ODIN_OS == .Linux   { foreign import swscale "system:libswscale" }

/*
	`swscale_*` functions.
*/
@(default_calling_convention="c", link_prefix="swscale_")
foreign swscale {
	// Return the LIBswscale_VERSION_INT constant
	// major, minor, micro := version >> 16, (version >> 8) & 255, version & 255
	version :: proc() -> (version: u32) ---

	// Return the libswscale build-time configuration.
	configuration :: proc() -> (build_time_configuration: cstring) ---

	// Return the libswscale license.
	license :: proc() -> (license: cstring) ---
}
@(default_calling_convention="c", link_prefix="sws_")
foreign swscale {

// Returns a pointer to yuv<->rgb coefficients for the given colorspace
getCoefficients :: proc(colorspace: types.Software_Scale_ColorSpace) -> ^i32 ---

// Returns a positive value if pix_fmt is a supported input format, 0 otherwise
isSupportedInput :: proc(pix_fmt: types.Pixel_Format) -> i32 ---

// Returns a positive value if pix_fmt is a supported output format, 0 otherwise
isSupportedOutput :: proc(pix_fmt: types.Pixel_Format) -> i32 ---

// Checks if endianness conversion is supported
isSupportedEndiannessConversion :: proc(pix_fmt: types.Pixel_Format) -> i32 ---

// Allocates an empty Sws_Context
alloc_context :: proc() -> ^types.Sws_Context ---

// Initializes the swscaler context sws_context
init_context :: proc(sws_context: ^types.Sws_Context, srcFilter: ^types.Software_Scale_Filter, dstFilter: ^types.Software_Scale_Filter) -> i32 ---

// Frees the swscaler context Sws_Context
freeContext :: proc(Sws_Context: ^types.Sws_Context) ---

// Allocates and returns an Sws_Context
//TODO: This seems to mix the organized and disorganized flags defined in types.odin.
// figure out how they are acutally grouped.
getContext :: proc(srcW: i32, srcH: i32, srcFormat: types.Pixel_Format, dstW: i32, dstH: i32, dstFormat: types.Pixel_Format, flags: i32, srcFilter: ^types.Software_Scale_Filter, dstFilter: ^types.Software_Scale_Filter, param: ^f64) -> ^types.Sws_Context ---

// Scales the image slice in srcSlice and puts the resulting scaled slice in the image in dst
scale :: proc(c: ^types.Sws_Context, srcSlice: [^]^u8, srcStride: [^]i32, srcSliceY: i32, srcSliceH: i32, dst: [^]^u8, dstStride: [^]i32) -> i32 ---

// Scales source data from src and writes the output to dst
scale_frame :: proc(c: ^types.Sws_Context, dst: ^types.Frame, src: ^types.Frame) -> i32 ---

// Initializes the scaling process for a given pair of source/destination frames
frame_start :: proc(c: ^types.Sws_Context, dst: ^types.Frame, src: ^types.Frame) -> i32 ---

// Finishes the scaling process for a pair of source/destination frames
frame_end :: proc(c: ^types.Sws_Context) ---

// Indicates that a horizontal slice of input data is available in the source frame
send_slice :: proc(c: ^types.Sws_Context, slice_start: uint, slice_height: uint) -> i32 ---

// Requests a horizontal slice of the output data to be written into the frame
receive_slice :: proc(c: ^types.Sws_Context, slice_start: uint, slice_height: uint) -> i32 ---

// Gets the alignment of the received slice
receive_slice_alignment :: proc(c: ^types.Sws_Context) -> uint ---

// Sets the colorspace details
setColorspaceDetails :: proc(c: ^types.Sws_Context, inv_table: [4]i32, srcRange: i32, table: [4]i32, dstRange: i32, brightness: i32, contrast: i32, saturation: i32) -> i32 ---

// Gets the colorspace details
getColorspaceDetails :: proc(c: ^types.Sws_Context, inv_table: ^^i32, srcRange: ^i32, table: ^^i32, dstRange: ^i32, brightness: ^i32, contrast: ^i32, saturation: ^i32) -> i32 ---

// Allocates and returns an uninitialized vector with length coefficients
allocVec :: proc(length: i32) -> ^types.Software_Scale_Vector ---

// Returns a normalized Gaussian curve used to filter stuff
getGaussianVec :: proc(variance: f64, quality: f64) -> ^types.Software_Scale_Vector ---

// Scales all the coefficients of a by the scalar value
scaleVec :: proc(a: ^types.Software_Scale_Vector, scalar: f64) ---

// Scales all the coefficients of a so that their sum equals height
normalizeVec :: proc(a: ^types.Software_Scale_Vector, height: f64) ---

// Frees a Software_Scale_Vector
freeVec :: proc(a: ^types.Software_Scale_Vector) ---

// Gets the default Software_Scale_Filter
getDefaultFilter :: proc(lumaGBlur: f32, chromaGBlur: f32, lumaSharpen: f32, chromaSharpen: f32, chromaHShift: f32, chromaVShift: f32, verbose: i32) -> ^types.Software_Scale_Filter ---

// Frees a Software_Scale_Filter
freeFilter :: proc(filter: ^types.Software_Scale_Filter) ---

// Checks if context can be reused, otherwise reallocates a new one
getCachedContext :: proc(sws_context: ^types.Sws_Context, srcW: i32, srcH: i32, srcFormat: types.Pixel_Format, dstW: i32, dstH: i32, dstFormat: types.Pixel_Format, flags: i32, srcFilter: ^types.Software_Scale_Filter, dstFilter: ^types.Software_Scale_Filter, param: ^f64) -> ^types.Sws_Context ---

// Converts an 8-bit paletted frame into a frame with a color depth of 32 bits
convertPalette8ToPacked32 :: proc(src: [^]u8, dst: [^]u8, num_pixels: i32, palette: [^]u8) ---

// Converts an 8-bit paletted frame into a frame with a color depth of 24 bits
convertPalette8ToPacked24 :: proc(src: [^]u8, dst: [^]u8, num_pixels: i32, palette: [^]u8) ---

// Gets the AVClass for Sws_Context
get_class :: proc() -> ^types.Class ---

}

//GENERAL TODO:
// Odin arrays have length calculations that get propagated to callers.
//Are they OK to use in the C structs, or do they store their length directly?

/*
	sws_addVec
	sws_allocVec
	sws_alloc_context
	sws_alloc_set_opts
	sws_cloneVec
	sws_convVec
	sws_convertPalette8ToPacked24
	sws_convertPalette8ToPacked32
	sws_freeContext
	sws_freeFilter
	sws_freeVec
	sws_getCachedContext
	sws_getCoefficients
	sws_getColorspaceDetails
	sws_getConstVec
	sws_getContext
	sws_getDefaultFilter
	sws_getGaussianVec
	sws_getIdentityVec
	sws_get_class
	sws_init_context
	sws_isSupportedEndiannessConversion
	sws_isSupportedInput
	sws_isSupportedOutput
	sws_normalizeVec
	sws_printVec2
	sws_scale
	sws_scaleVec
	sws_setColorspaceDetails
	sws_shiftVec
	sws_subVec
*/