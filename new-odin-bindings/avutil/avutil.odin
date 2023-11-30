/*
	Odin bindings for FFmpeg's `avutil` library.
	Bindings available under FFmpeg's license (GNU LGPL, v2.1+). See `LICENSE.md` in the package's top directory.

	Copyright (c) 2021 Jeroen van Rijn. All rights reserved.

	Libraries copyright their respective owner, available under their own licenses.
*/
package ffmpeg_avutil

import "../types"

when ODIN_OS == .Windows { foreign import avutil "avutil.lib"       }
when ODIN_OS == .Linux  { foreign import avutil "system:libavutil" }

//Figure this out later.
ptrdiff_t :: distinct int
time_t :: distinct int
/*
	`avutil_*` functions.
*/
@(default_calling_convention="c", link_prefix="avutil_")
foreign avutil {
	// Return the LIBavutil_VERSION_INT constant
	// major, minor, micro := version >> 16, (version >> 8) & 255, version & 255
	version :: proc() -> (version: u32) ---

	// Return the libavutil build-time configuration.
	configuration :: proc() -> (build_time_configuration: cstring) ---

	// Return the libavutil license.
	license :: proc() -> (license: cstring) ---
}

/*
	`av_*` functions.
*/
@(default_calling_convention="c", link_prefix="av_")
foreign avutil {
	//===adler32.h===
	adler32_update :: proc(adler:types.Adler, buf:[^]byte,len:uintptr)->types.Adler ---

	//===aes_ctr.h===
	// Allocates an AESCTR context.
	aes_ctr_alloc :: proc() -> ^types.AESCTR ---

	// Initializes an AESCTR context.
	aes_ctr_init :: proc(a: ^types.AESCTR, key: [^]u8) -> i32 ---

	// Releases an AESCTR context.
	aes_ctr_free :: proc(a: ^types.AESCTR) ---

	// Processes a buffer using a previously initialized context.
	aes_ctr_crypt :: proc(a: ^types.AESCTR, dst: [^]u8, src: [^]u8, size: i32) ---

	// Gets the current iv.
	aes_ctr_get_iv :: proc(a: ^types.AESCTR) -> [^]u8 ---

	// Generates a random iv.
	aes_ctr_set_random_iv :: proc(a: ^types.AESCTR) ---

	// Forcefully changes the 8-byte iv.
	aes_ctr_set_iv :: proc(a: ^types.AESCTR, iv: [^]u8) ---

	// Forcefully changes the "full" 16-byte iv, including the counter.
	aes_ctr_set_full_iv :: proc(a: ^types.AESCTR, iv: [^]u8) ---

	// Increments the top 64 bit of the iv.
	aes_ctr_increment_iv :: proc(a: ^types.AESCTR) ---

	//===aes.h===
	// Allocates an AES context.
	aes_alloc :: proc() -> ^types.AES ---

	// Initializes an AES context.
	aes_init :: proc(a: ^types.AES, key: [^]u8, key_bits: i32, decrypt: b32) -> i32 ---

	// Encrypts or decrypts a buffer using a previously initialized context.
	aes_crypt :: proc(a: ^types.AES, dst: [^]u8, src: [^]u8, count: i32, iv: [^]u8, decrypt: b32) ---

	//===ambient_viewing_environment.h===
	ambient_viewing_environment_alloc :: proc(size:^uintptr)-> types.Ambient_Viewing_Environment ---
	ambient_viewing_environment_create_side_data :: proc(frame:^types.Frame)-> types.Ambient_Viewing_Environment ---

	//===audio_fifo.h===
	// Frees an Audio_Fifo.
	audio_fifo_free :: proc(af: ^types.Audio_Fifo) ---

	// Allocates an Audio_Fifo.
	audio_fifo_alloc :: proc(sample_fmt: types.Sample_Format, channels: i32, nb_samples: i32) -> ^types.Audio_Fifo ---

	// Reallocates an Audio_Fifo.
	audio_fifo_realloc :: proc(af: ^types.Audio_Fifo, nb_samples: i32) -> i32 ---

	// Writes data to an Audio_Fifo.
	audio_fifo_write :: proc(af: ^types.Audio_Fifo, data: ^rawptr, nb_samples: i32) -> i32 ---

	// Peeks data from an Audio_Fifo.
	audio_fifo_peek :: proc(af: ^types.Audio_Fifo, data: ^rawptr, nb_samples: i32) -> i32 ---

	// Peeks data from an Audio_Fifo.
	audio_fifo_peek_at :: proc(af: ^types.Audio_Fifo, data: ^rawptr, nb_samples: i32, offset: i32) -> i32 ---

	// Reads data from an Audio_Fifo.
	audio_fifo_read :: proc(af: ^types.Audio_Fifo, data: ^rawptr, nb_samples: i32) -> i32 ---

	// Drains data from an Audio_Fifo.
	audio_fifo_drain :: proc(af: ^types.Audio_Fifo, nb_samples: i32) -> i32 ---

	// Resets the Audio_Fifo buffer.
	audio_fifo_reset :: proc(af: ^types.Audio_Fifo) ---

	// Gets the current number of samples in the Audio_Fifo available for reading.
	audio_fifo_size :: proc(af: ^types.Audio_Fifo) -> i32 ---

	// Gets the current number of samples in the Audio_Fifo available for writing.
	audio_fifo_space :: proc(af: ^types.Audio_Fifo) -> i32 ---

	//===avstring.h===
	// Returns non-zero if pfx is a prefix of str.
	strstart :: proc(str: cstring, pfx: cstring, ptr: ^cstring) -> i32 ---

	// Returns non-zero if pfx is a prefix of str independent of case.
	stristart :: proc(str: cstring, pfx: cstring, ptr: ^cstring) -> i32 ---

	// Locates the first case-independent occurrence in the string haystack of the string needle.
	stristr :: proc(haystack: cstring, needle: cstring) -> cstring ---

	// Locates the first occurrence of the string needle in the string haystack where not more than hay_length characters are searched.
	strnstr :: proc(haystack: cstring, needle: cstring, hay_length: uintptr) -> cstring ---

	// Copies the string src to dst.
	strlcpy :: proc(dst: cstring, src: cstring, size: uintptr) -> uintptr ---

	// Appends the string src to the string dst.
	strlcat :: proc(dst: cstring, src: cstring, size: uintptr) -> uintptr ---

	// Appends output to a string, according to a format.
	strlcatf :: proc(dst: cstring, size: uintptr, fmt: cstring, varargs: ..any) -> uintptr ---

	// Prints arguments following specified format into a large enough auto allocated buffer.
	asprintf :: proc(fmt: cstring, varargs: ..any) -> cstring ---

	// Unescapes the given string.
	get_token :: proc(buf: ^cstring, term: cstring) -> cstring ---

	// Splits the string into several tokens.
	strtok :: proc(s: cstring, delim: cstring, saveptr: ^cstring) -> cstring ---

	// Locale-independent case-insensitive compare.
	strcasecmp :: proc(a: cstring, b: cstring) -> i32 ---

	// Locale-independent case-insensitive compare.
	strncasecmp :: proc(a: cstring, b: cstring, n: uintptr) -> i32 ---

	// Locale-independent strings replace.
	streplace :: proc(str: cstring, from: cstring, to: cstring) -> cstring ---

	// Thread safe basename.
	basename :: proc(path: cstring) -> cstring ---

	// Thread safe dirname.
	dirname :: proc(path: cstring) -> cstring ---

	// Matches instances of a name in a comma-separated list of names.
	match_name :: proc(name: cstring, names: cstring) -> i32 ---

	// Appends path component to the existing path.
	append_path_component :: proc(path: cstring, component: cstring) -> cstring ---

	// Escapes string in src.
	escape :: proc(dst: ^cstring, src: cstring, special_chars: cstring, mode: types.Escape_Mode, flags: types.Escape_Flags) -> i32 ---

	// Reads and decodes a single UTF-8 code point (character) from the buffer in *buf.
	utf8_decode :: proc(codep: ^i32, bufp: ^[^]u8, buf_end: ^u8, flags: types.UTF8_Flags) -> i32 ---

	// Checks if a name is in a list.
	match_list :: proc(name: cstring, list: cstring, separator: byte) -> i32 ---

	// Locale-independent sscanf implementation.
	sscanf :: proc(str: cstring, format: cstring, varargs:..any) -> i32 ---


	///===avutil.h===	
	// Returns the LIBAVUTIL_VERSION_INT constant.
	util_version :: proc() -> u32 ---

	// Returns an informative version string.
	version_info :: proc() -> cstring ---

	// Returns the libavutil build-time configuration.
	util_configuration :: proc() -> cstring ---

	// Returns the libavutil license.
	util_license :: proc() -> cstring ---

	// Returns a string describing the media_type enum.
	get_media_type_string :: proc(media_type: types.Media_Type) -> cstring ---

	// Returns a single letter to describe the given picture type.
	get_picture_type_char :: proc(pict_type: types.Picture_Type) -> byte ---

	// Computes the length of an integer list.
	int_list_length_for_size :: proc(elsize: u32, list: rawptr, term: u64) -> u32 ---

	// Returns the fractional representation of the internal time base.
	get_time_base_q :: proc() -> types.Rational ---

	// Fills the provided buffer with a string containing a FourCC (four-character code) representation.
	fourcc_make_string :: proc(buf: cstring, fourcc: types.FourCC) -> cstring ---



	//===base64.h===
	// Decodes a base64-encoded string.
	base64_decode :: proc(out: [^]u8, instr: cstring, out_size: i32) -> i32 ---

	// Encodes data to base64 and null-terminates.
	base64_encode :: proc(out: [^]u8, out_size: i32, inbuf: [^]u8, in_size: i32) -> cstring ---



	// Allocates a Blowfish context.
	blowfish_alloc :: proc() -> ^types.Blowfish ---

	// Initializes a Blowfish context.
	blowfish_init :: proc(ctx: ^types.Blowfish, key: [^]u8, key_len: i32) ---

	// Encrypts or decrypts a buffer using a previously initialized context.
	blowfish_crypt_ecb :: proc(ctx: ^types.Blowfish, xl: ^u32, xr: ^u32, decrypt: b32) ---

	// Encrypts or decrypts a buffer using a previously initialized context.
	blowfish_crypt :: proc(ctx: ^types.Blowfish, dst: [^]u8, src: [^]u8, count: i32, iv: [^]u8, decrypt: b32) ---


	//===bprint.h===
	// Initializes a print buffer.
	bprint_init :: proc(buf: ^types.BPrint, size_init: u32, size_max: u32) ---

	// Initializes a print buffer using a pre-existing buffer.
	bprint_init_for_buffer :: proc(buf: ^types.BPrint, buffer: [^]byte, size: u32) ---

	// Appends a formatted string to a print buffer.
	bprintf :: proc(buf: ^types.BPrint, fmt: cstring, varargs: ..any) ---

	// Appends a formatted string to a print buffer.

	vbprintf :: proc(buf: ^types.BPrint, fmt: cstring, vl_arg: types.va_list) ---

	// Appends char c n times to a print buffer.
	bprint_chars :: proc(buf: ^types.BPrint, c: byte, n: u32) ---

	// Appends data to a print buffer.
	bprint_append_data :: proc(buf: ^types.BPrint, data: [^]byte, size: u32) ---

	// Appends a formatted date and time to a print buffer.
	bprint_strftime :: proc(buf: ^types.BPrint, fmt: cstring, tm: ^types.Tm) ---

	// Allocates bytes in the buffer for external use.
	bprint_get_buffer :: proc(buf: ^types.BPrint, size: u32, mem: ^[^]byte, actual_size: ^u32) ---

	// Resets the string to "" but keep internal allocated data.
	bprint_clear :: proc(buf: ^types.BPrint) ---

	// Finalizes a print buffer.
	bprint_finalize :: proc(buf: ^types.BPrint, ret_str: ^cstring) -> i32 ---

	// Escapes the content in src and append it to dstbuf.
	bprint_escape :: proc(dstbuf: ^types.BPrint, src: cstring, special_chars: cstring, mode: types.Escape_Mode, flags: types.Escape_Flags) ---
	
	
	//===buffer.h===
	// Allocates an AVBuffer of the given size using av_malloc().
	buffer_alloc :: proc(size: uintptr) -> ^types.Buffer_Ref ---

	// Same as buffer_alloc(), except the returned buffer will be initialized to zero.
	buffer_allocz :: proc(size: uintptr) -> ^types.Buffer_Ref ---

	// Creates an AVBuffer from an existing array.
	buffer_create :: proc(data: [^]u8, size: uintptr, free: proc(opaque: rawptr, data: [^]u8), opaque: rawptr, flags: types.Buffer_Flags) -> ^types.Buffer_Ref ---

	// Default free callback, which calls av_free() on the buffer data.
	buffer_default_free :: proc(opaque: rawptr, data: [^]u8) ---

	// Creates a new reference to an AVBuffer.
	buffer_ref :: proc(buf: ^types.Buffer_Ref) -> ^types.Buffer_Ref ---

	// Frees a given reference and automatically free the buffer if there are no more references to it.
	buffer_unref :: proc(buf: ^^types.Buffer_Ref) ---

	// Returns 1 if the caller may write to the data referred to by buf.
	buffer_is_writable :: proc(buf: ^types.Buffer_Ref) -> b32 ---

	// Returns the opaque parameter set by buffer_create.
	buffer_get_opaque :: proc(buf: ^types.Buffer_Ref) -> rawptr ---

	buffer_get_ref_count :: proc(buf: ^types.Buffer_Ref) -> i32 ---

	// Creates a writable reference from a given buffer reference, avoiding data copy if possible.
	buffer_make_writable :: proc(buf: ^^types.Buffer_Ref) -> i32 ---

	// Reallocates a given buffer.
	buffer_realloc :: proc(buf: ^^types.Buffer_Ref, size: uintptr) -> i32 ---

	// Ensures dst refers to the same data as src.
	buffer_replace :: proc(dst: ^^types.Buffer_Ref, src: ^types.Buffer_Ref) -> i32 ---

	// Allocates and initializes a buffer pool.
	buffer_pool_init :: proc(size: uintptr, alloc: proc(size: uintptr) -> ^types.Buffer_Ref) -> ^types.Buffer_Pool ---

	// Allocates and initializes a buffer pool with a more complex allocator.
	buffer_pool_init2 :: proc(size: uintptr, opaque: rawptr, alloc: proc(opaque: rawptr, size: uintptr) -> ^types.Buffer_Ref, pool_free: proc(opaque: rawptr)) -> ^types.Buffer_Pool ---

	// Marks the pool as being available for freeing.
	buffer_pool_uninit :: proc(pool: ^^types.Buffer_Pool) ---

	// Allocates a new AVBuffer, reusing an old buffer from the pool when available.
	buffer_pool_get :: proc(pool: ^types.Buffer_Pool) -> ^types.Buffer_Ref ---

	// Queries the original opaque parameter of an allocated buffer in the pool.
	buffer_pool_buffer_get_opaque :: proc(ref: ^types.Buffer_Ref) -> rawptr ---


	//===camellia.h===
	// Allocates an AVCAMELLIA context.
	camellia_alloc :: proc() -> ^types.CAMELLIA ---

	// Initializes an AVCAMELLIA context.
	camellia_init :: proc(ctx: ^types.CAMELLIA, key: [^]u8, key_bits: i32) -> i32 ---

	// Encrypts or decrypts a buffer using a previously initialized context.
	camellia_crypt :: proc(ctx: ^types.CAMELLIA, dst: [^]u8, src: [^]u8, count: i32, iv: [^]u8, decrypt: b32) ---

	//===cast5.h===
	// Allocates an AVCAST5 context.
	cast5_alloc :: proc() -> ^types.CAST5 ---

	// Initializes an AVCAST5 context.
	cast5_init :: proc(ctx: ^types.CAST5, key: [^]u8, key_bits: i32) -> i32 ---

	// Encrypts or decrypts a buffer using a previously initialized context, ECB mode only.
	cast5_crypt :: proc(ctx: ^types.CAST5, dst: [^]u8, src: [^]u8, count: i32, decrypt: b32) ---

	// Encrypts or decrypts a buffer using a previously initialized context.
	cast5_crypt2 :: proc(ctx: ^types.CAST5, dst: [^]u8, src: [^]u8, count: i32, iv: [^]u8, decrypt: b32) ---

	//===channel_layout.h===
	channel_name :: proc(buf:cstring, buf_size:uintptr, channel:types.Channel)->i32 ---
	channel_name_bprint :: proc(bp:^types.BPrint, channel_id:types.Channel) ---
	channel_description :: proc(buf:cstring, buf_size:uintptr, channel:types.Channel)->i32 ---
	channel_description_bprint :: proc(bp:^types.BPrint, channel_id:types.Channel) ---
	channel_from_string :: proc(name:cstring)->types.Channel ---
	channel_layout_from_mask :: proc(channel_layout:^types.Channel_Layout, mask:u64)-> i32 ---
	channel_layout_from_string :: proc(channel_layout:^types.Channel_Layout, str:cstring)-> i32 ---
	channel_layout_default :: proc(channel_layout:^types.Channel_Layout, nb_channels:i32) ---
	channel_layout_standard :: proc(opaque:^rawptr)->types.Channel_Layout ---
	channel_layout_uninit :: proc(channel_layout:^types.Channel_Layout) ---
	channel_layout_copy :: proc(dst:^types.Channel_Layout, src:^types.Channel_Layout)->i32 ---
	channel_layout_describe :: proc(channel_layout:^types.Channel_Layout, buf:cstring, buf_size:uintptr)->i32 ---
	channel_layout_describe_bprint :: proc(channel_layout:^types.Channel_Layout,bp:^types.BPrint)->i32 ---
	channel_layout_channel_from_index :: proc(channel_layout:^types.Channel_Layout,idx:u32)->types.Channel ---
	channel_layout_index_from_channel :: proc(channel_layout:^types.Channel_Layout,channel:types.Channel)->i32 ---
	channel_layout_index_from_string :: proc(channel_layout:^types.Channel_Layout,name:cstring)->i32 ---
	channel_layout_channel_from_string :: proc(channel_layout:^types.Channel_Layout,name:cstring)->types.Channel ---
	channel_layout_subset :: proc(channel_layout:^types.Channel_Layout,mask:u64)->u64 ---
	channel_layout_check :: proc(channel_layout:^types.Channel_Layout)-> b32 ---
	channel_layout_compare :: proc(ch1:^types.Channel_Layout,ch2:^types.Channel_Layout)-> i32 ---
	
	//===cpu.h===
	// Returns the flags which specify extensions supported by the CPU.
	get_cpu_flags :: proc() -> types.Cpu_Flags ---

	// Disables cpu detection and forces the specified flags.
	force_cpu_flags :: proc(flags: types.Cpu_Flags) ---

	// Parses CPU caps from a string and updates the given AV_CPU_* flags based on that.
	parse_cpu_caps :: proc(flags: ^types.Cpu_Flags, s: cstring) -> i32 ---

	// Returns the number of logical CPU cores present.
	cpu_count :: proc() -> i32 ---

	// Overrides cpu count detection and forces the specified count.
	cpu_force_count :: proc(count: i32) ---

	// Gets the maximum data alignment that may be required by FFmpeg.
	cpu_max_align :: proc() -> uintptr ---


	//===crc.h===
	// Initializes a CRC table.
	crc_init :: proc(ctx: ^types.CRC, le: i32, bits: i32, poly: u32, ctx_size: i32) -> i32 ---

	// Gets an initialized standard CRC table.
	crc_get_table :: proc(crc_id: types.CRC_Id) -> ^types.CRC ---

	// Calculates the CRC of a block.
	crc :: proc(ctx: ^types.CRC, crc: u32, buffer: [^]u8, length: uintptr) -> u32 ---

	//===csp.h===
		
	/**
	* Retrieves the Luma coefficients necessary to construct a conversion matrix
	* from an enum constant describing the colorspace. */
	csp_luma_coeffs_from_avcsp :: proc(csp:types.Color_Space)->^types.Luma_Coefficients ---

	/**
	* Retrieves a complete gamut description from an enum constant describing the
	* color primaries. */
	csp_primaries_desc_from_id :: proc(prm:types.Color_Primaries)->^types.Color_Primaries_Desc ---

	/**
	* Detects which enum AVColorPrimaries constant corresponds to the given complete
	* gamut description. */
	csp_primaries_id_from_desc :: proc(prm:^types.Color_Primaries_Desc)->types.Color_Primaries ---

	/**
	* Determine a suitable 'gamma' value to match the supplied
	* AVColorTransferCharacteristic.
	*/
	csp_approximate_trc_gamma :: proc(trc:types.Color_Transfer_Characteristic)->f64 ---

	/**
	* Determine the function needed to apply the given
	* AVColorTransferCharacteristic to linear input.
	*/
	csp_trc_func_from_id :: proc(trc:types.Color_Transfer_Characteristic)->types.csp_trc_function ---


	//===des.h===
	// Allocates an AVDES context.
	des_alloc :: proc() -> ^types.DES ---

	// Initializes an AVDES context.
	des_init :: proc(d: ^types.DES, key: [^]u8, key_bits: i32, decrypt: b32) -> i32 ---

	// Encrypts / decrypts using the DES algorithm.
	des_crypt :: proc(d: ^types.DES, dst: [^]u8, src: [^]u8, count: i32, iv: [^]u8, decrypt: b32) ---

	// Calculates CBC-MAC using the DES algorithm.
	des_mac :: proc(d: ^types.DES, dst: [^]u8, src: [^]u8, count: i32) ---

	//===detection_bbox.h===
	detection_bbox_alloc :: proc(nb_bboxes:u32, out_size:^uintptr)->^types.Detection_Bounding_Box_Header ---
	detection_bbox_create_side_data :: proc(frame:^types.Frame, nb_bboxes:u32)->^types.Detection_Bounding_Box_Header ---


	//===dict.h===
	// Gets a dictionary entry with matching key.
	dict_get :: proc(m: ^types.Dictionary, key: cstring, prev: ^types.Dictionary_Entry, flags: types.Dictionary_Flags) -> ^types.Dictionary_Entry ---

	// Gets number of entries in dictionary.
	dict_count :: proc(m: ^types.Dictionary) -> i32 ---

	// Sets the given entry in *pm, overwriting an existing entry.
	dict_set :: proc(pm: ^^types.Dictionary, key: cstring, value: cstring, flags: types.Dictionary_Flags) -> i32 ---

	// Convenience wrapper for dict_set that converts the value to a string and stores it.
	dict_set_int :: proc(pm: ^^types.Dictionary, key: cstring, value: i64, flags: types.Dictionary_Flags) -> i32 ---

	// Parses the key/value pairs list and adds the parsed entries to a dictionary.
	dict_parse_string :: proc(pm: ^^types.Dictionary, str: cstring, key_val_sep: cstring, pairs_sep: cstring, flags: types.Dictionary_Flags) -> i32 ---

	// Copies entries from one Dictionary struct into another.
	dict_copy :: proc(dst: ^^types.Dictionary, src: ^types.Dictionary, flags: types.Dictionary_Flags) -> i32 ---

	// Frees all the memory allocated for a Dictionary struct and all keys and values.
	dict_free :: proc(m: ^^types.Dictionary) ---

	// Gets dictionary entries as a string.
	dict_get_string :: proc(m: ^types.Dictionary, buffer: ^cstring, key_val_sep: byte, pairs_sep: byte) -> i32 ---


	//===display.h===
	// Extracts the rotation component of the transformation matrix.
	display_rotation_get :: proc(matrix_in: [9]i32) -> f64 ---

	// Initializes a transformation matrix describing a pure counterclockwise rotation by the specified angle (in degrees).
	display_rotation_set :: proc(matrix_in: [9]i32, angle: f64) ---

	// Flips the input matrix horizontally and/or vertically.
	display_matrix_flip :: proc(matrix_in: [9]i32, hflip: i32, vflip: i32) ---



	//===dovi_meta.h===	
	// Allocates a DOVI_Decoder_Configuration_Record structure and initializes its fields to default values.
	dovi_alloc :: proc(size: ^uintptr) -> ^types.DOVI_Decoder_Configuration_Record ---

	dovi_metadata_alloc :: proc(size: ^uintptr)->^types.DOVI_Metadata ---

	//===downmix_info.h===
	// Gets a frame's FRAME_DATA_DOWNMIX_INFO side data for editing.
	downmix_info_update_side_data :: proc(frame: ^types.Frame) -> ^types.Downmix_Info ---
	
	//===encryption_info.h===
	// Allocates an Encryption_Info structure and sub-pointers to hold the given number of subsamples.
	encryption_info_alloc :: proc(subsample_count: u32, key_id_size: u32, iv_size: u32) -> ^types.Encryption_Info ---

	// Allocates an Encryption_Info structure with a copy of the given data.
	encryption_info_clone :: proc(info: ^types.Encryption_Info) -> ^types.Encryption_Info ---
	
	// Frees the given encryption info object.
	encryption_info_free :: proc(info: ^types.Encryption_Info) ---

	// Creates a copy of the Encryption_Info that is contained in the given side data.
	encryption_info_get_side_data :: proc(side_data: [^]u8, side_data_size: uintptr) -> ^types.Encryption_Info ---

	// Allocates and initializes side data that holds a copy of the given encryption info.
	encryption_info_add_side_data :: proc(info: ^types.Encryption_Info, side_data_size: ^uintptr) -> [^]u8 ---

	// Allocates an Encryption_Init_Info structure and sub-pointers to hold the given sizes.
	encryption_init_info_alloc :: proc(system_id_size: u32, num_key_ids: u32, key_id_size: u32, data_size: u32) -> ^types.Encryption_Init_Info ---

	// Frees the given encryption init info object.
	encryption_init_info_free :: proc(info: ^types.Encryption_Init_Info) ---

	// Creates a copy of the Encryption_Init_Info that is contained in the given side data.
	encryption_init_info_get_side_data :: proc(side_data: [^]u8, side_data_size: uintptr) -> ^types.Encryption_Init_Info ---

	// Allocates and initializes side data that holds a copy of the given encryption init info.
	encryption_init_info_add_side_data :: proc(info: ^types.Encryption_Init_Info, side_data_size: ^uintptr) -> [^]u8 ---


	//===error.h===
	// Puts a description of the AVERROR code errnum in errbuf.
	strerror :: proc(errnum: i32, errbuf: cstring, errbuf_size: uintptr) -> i32 ---

	//===eval.h===
	// Parses and evaluates an expression.
	expr_parse_and_eval :: proc(res: ^f64, s: cstring, const_names: ^^cstring, const_values: ^f64, func1_names: ^^cstring, funcs1: ^^proc(opaque: rawptr, arg1:f64) -> f64, func2_names: ^^cstring, funcs2: ^^proc(opaque: rawptr, arg1:f64, arg2:f64) -> f64, opaque: rawptr, log_offset: i32, log_ctx: rawptr) -> i32 ---

	// Parses an expression.
	expr_parse :: proc(expr: ^^types.Expr, s: cstring, const_names: ^^cstring, func1_names: ^^cstring, funcs1: ^^proc(opaque: rawptr, arg1:f64) -> f64, func2_names: ^^cstring, funcs2: ^^proc(opaque: rawptr, arg1:f64, arg2:f64) -> f64, log_offset: i32, log_ctx: rawptr) -> i32 ---

	// Evaluates a previously parsed expression.
	expr_eval :: proc(e: ^types.Expr, const_values: ^f64, opaque: rawptr) -> f64 ---

	// Tracks the presence of variables and their number of occurrences in a parsed expression.
	expr_count_vars :: proc(e: ^types.Expr, counter: ^u32, size: i32) -> i32 ---

	// Tracks the presence of user provided functions and their number of occurrences in a parsed expression.
	expr_count_func :: proc(e: ^types.Expr, counter: ^u32, size: i32, arg: i32) -> i32 ---

	// Frees a parsed expression previously created with expr_parse().
	expr_free :: proc(e: ^types.Expr) ---

	// Parses the string in numstr and returns its value as a double.
	strtod :: proc(numstr: cstring, tail: ^cstring) -> f64 ---


	//===executor.h===
	executor_alloc :: proc(callbacks:^types.Task_Callbacks,thread_count:i32)->^types.Executor ---
	executor_free :: proc(e:^^types.Executor) ---
	executor_execute :: proc(e:^types.Executor,t:^types.Task) ---

	//===fifo.h===

	// Allocates and initializes an AVFifo with a given element size
	fifo_alloc2 :: proc(elems: uintptr, elem_size: uintptr, flags: uint) -> ^types.Fifo ---

	// Returns Element size for FIFO operations
	fifo_elem_size :: proc(f: ^types.Fifo) -> uintptr ---

	// Sets the maximum size (in elements) to which the FIFO can be resized automatically
	fifo_auto_grow_limit :: proc(f: ^types.Fifo, max_elems: uintptr) ---

	// Checks how much data can be read from the FIFO
	fifo_can_read :: proc(f: ^types.Fifo) -> uintptr ---

	// Checks how much data can be written into the FIFO
	fifo_can_write :: proc(f: ^types.Fifo) -> uintptr ---

	// Enlarges an AVFifo
	fifo_grow2 :: proc(f: ^types.Fifo, inc: uintptr) -> i32 ---

	// Writes data into a FIFO
	fifo_write :: proc(f: ^types.Fifo, buf: rawptr, nb_elems: uintptr) -> i32 ---

	// Writes data from a user-provided callback into a FIFO
	fifo_write_from_cb :: proc(f: ^types.Fifo, read_cb: types.fifo_cb, opaque: rawptr, nb_elems: ^uintptr) -> i32 ---

	// Reads data from a FIFO
	fifo_read :: proc(f: ^types.Fifo, buf: rawptr, nb_elems: uintptr) -> i32 ---

	// Feeds data from a FIFO into a user-provided callback
	fifo_read_to_cb :: proc(f: ^types.Fifo, write_cb: types.fifo_cb, opaque: rawptr, nb_elems: ^uintptr) -> i32 ---

	// Reads data from a FIFO without modifying FIFO state
	fifo_peek :: proc(f: ^types.Fifo, buf: rawptr, nb_elems: uintptr, offset: uintptr) -> i32 ---

	// Feeds data from a FIFO into a user-provided callback
	fifo_peek_to_cb :: proc(f: ^types.Fifo, write_cb: types.fifo_cb, opaque: rawptr, nb_elems: ^uintptr, offset: uintptr) -> i32 ---

	// Discards the specified amount of data from an AVFifo
	fifo_drain2 :: proc(f: ^types.Fifo, size: uintptr) ---

	// Empties the AVFifo
	fifo_reset2 :: proc(f: ^types.Fifo) ---

	// Frees an AVFifo and resets pointer to NULL
	fifo_freep2 :: proc(f: ^^types.Fifo) ---


	//===file.h===
	// Reads the file with name filename, and puts its content in a newly allocated buffer or map it with mmap() when available.
	file_map :: proc(filename: cstring, bufptr: ^[^]u8, size: ^uintptr, log_offset: i32, log_ctx: rawptr) -> i32 ---

	// Unmaps or frees the buffer bufptr created by file_map().
	file_unmap :: proc(bufptr: [^]u8, size: uintptr) ---


	//===film_grain_params.h===
	// Allocates a Film_Grain_Params structure and sets its fields to default values.
	film_grain_params_alloc :: proc(size: ^uintptr) -> ^types.Film_Grain_Params ---

	// Allocates a complete Film_Grain_Params and adds it to the frame.
	film_grain_params_create_side_data :: proc(frame: ^types.Frame) -> ^types.Film_Grain_Params ---


	//===frame.h===
	// Allocates a Frame and sets its fields to default values.
	frame_alloc :: proc() -> ^types.Frame ---

	// Frees the frame and any dynamically allocated objects in it.
	frame_free :: proc(frame: ^^types.Frame) ---

	// Sets up a new reference to the data described by the source frame.
	frame_ref :: proc(dst: ^types.Frame, src: ^types.Frame) -> i32 ---

	// Creates a new frame that references the same data as src.
	frame_clone :: proc(src: ^types.Frame) -> ^types.Frame ---

	// Unreferences all the buffers referenced by frame and resets the frame fields.
	frame_unref :: proc(frame: ^types.Frame) ---

	// Moves everything contained in src to dst and resets src.
	frame_move_ref :: proc(dst: ^types.Frame, src: ^types.Frame) ---

	// Allocates new buffer(s) for audio or video data.
	frame_get_buffer :: proc(frame: ^types.Frame, align: i32) -> i32 ---

	// Checks if the frame data is writable.
	frame_is_writable :: proc(frame: ^types.Frame) -> i32 ---

	// Ensures that the frame data is writable, avoiding data copy if possible.
	frame_make_writable :: proc(frame: ^types.Frame) -> i32 ---

	// Copies the frame data from src to dst.
	frame_copy :: proc(dst: ^types.Frame, src: ^types.Frame) -> i32 ---

	// Copies only "metadata" fields from src to dst.
	frame_copy_props :: proc(dst: ^types.Frame, src: ^types.Frame) -> i32 ---

	// Gets the buffer reference a given data plane is stored in.
	frame_get_plane_buffer :: proc(frame: ^types.Frame, plane: i32) -> ^types.Buffer_Ref ---

	// Adds a new side data to a frame.
	frame_new_side_data :: proc(frame: ^types.Frame, type: types.Frame_Side_Data_Type, size: uintptr) -> ^types.Frame_Side_Data ---

	// Adds a new side data to a frame from an existing Buffer_Ref.
	frame_new_side_data_from_buf :: proc(frame: ^types.Frame, type: types.Frame_Side_Data_Type, buf: ^types.Buffer_Ref) -> ^types.Frame_Side_Data ---

	// Returns a pointer to the side data of a given type on success, NULL if there is no side data with such type in this frame.
	frame_get_side_data :: proc(frame: ^types.Frame, type: types.Frame_Side_Data_Type) -> ^types.Frame_Side_Data ---

	// Removes and frees all side data instances of the given type.
	frame_remove_side_data :: proc(frame: ^types.Frame, type: types.Frame_Side_Data_Type) ---

	// Crops the given video Frame according to its crop_left/crop_top/crop_right/crop_bottom fields.
	frame_apply_cropping :: proc(frame: ^types.Frame, flags: types.Frame_Crop_Flags) -> i32 ---

	// Returns a string identifying the side data type.
	frame_side_data_name :: proc(type: types.Frame_Side_Data_Type) -> cstring ---



	//===hash.h===
	// Allocates a hash context for the algorithm specified by name.
	hash_alloc :: proc(ctx: ^^types.Hash_Context, name: cstring) -> i32 ---

	// Gets the names of available hash algorithms.
	hash_names :: proc(i: i32) -> cstring ---

	// Gets the name of the algorithm corresponding to the given hash context.
	hash_get_name :: proc(ctx: ^types.Hash_Context) -> cstring ---

	// Gets the size of the resulting hash value in bytes.
	hash_get_size :: proc(ctx: ^types.Hash_Context) -> i32 ---

	// Initializes or resets a hash context.
	hash_init :: proc(ctx: ^types.Hash_Context) ---

	// Updates a hash context with additional data.
	hash_update :: proc(ctx: ^types.Hash_Context, src: [^]u8, len: uintptr) ---

	// Finalizes a hash context and computes the actual hash value.
	hash_final :: proc(ctx: ^types.Hash_Context, dst: [^]u8) ---

	// Finalizes a hash context and stores the actual hash value in a buffer.
	hash_final_bin :: proc(ctx: ^types.Hash_Context, dst: [^]u8, size: i32) ---

	// Finalizes a hash context and stores the hexadecimal representation of the actual hash value as a string.
	hash_final_hex :: proc(ctx: ^types.Hash_Context, dst: [^]u8, size: i32) ---

	// Finalizes a hash context and stores the Base64 representation of the actual hash value as a string.
	hash_final_b64 :: proc(ctx: ^types.Hash_Context, dst: [^]u8, size: i32) ---

	// Frees hash context and sets hash context pointer to `NULL`.
	hash_freep :: proc(ctx: ^^types.Hash_Context) ---

	//===hdr_dynamic_metadata.h===
	// Allocates a Dynamic_HDR_Plus structure and sets its fields to default values.
	dynamic_hdr_plus_alloc :: proc(size: ^uintptr) -> ^types.Dynamic_HDR_Plus ---

	// Allocates a complete Dynamic_HDR_Plus and adds it to the frame.
	dynamic_hdr_plus_create_side_data :: proc(frame: ^types.Frame) -> ^types.Dynamic_HDR_Plus ---

	dynamic_hdr_plus_from_t35 :: proc(s:^types.Dynamic_HDR_Plus, data:[^]u8, size:uintptr)->i32 ---
	dynamic_hdr_plus_to_t35 :: proc(s:^types.Dynamic_HDR_Plus, data:^[^]u8, size:^uintptr)->i32 ---

	//===hdr_dynamic_vivid_metadata.h===
	dynamic_hdr_vivid_alloc :: proc(size:^uintptr)->^types.Dynamic_HDR_Vivid ---
	dynamic_hdr_vivid_create_side_data :: proc(frame:^types.Frame)->^types.Dynamic_HDR_Vivid ---



	// Allocates an HMAC context.
	hmac_alloc :: proc(type: types.HMAC_Type) -> ^types.HMAC ---

	// Frees an HMAC context.
	hmac_free :: proc(ctx: ^types.HMAC) ---

	// Initializes an HMAC context with an authentication key.
	hmac_init :: proc(ctx: ^types.HMAC, key: [^]u8, keylen: u32) ---

	// Hashes data with the HMAC.
	hmac_update :: proc(ctx: ^types.HMAC, data: [^]u8, len: u32) ---

	// Finishes hashing and outputs the HMAC digest.
	hmac_final :: proc(ctx: ^types.HMAC, out: [^]u8, outlen: u32) -> i32 ---

	// Hashes an array of data with a key.
	hmac_calc :: proc(ctx: ^types.HMAC, data: [^]u8, len: u32, key: [^]u8, keylen: u32, out: [^]u8, outlen: u32) -> i32 ---


	//TODO: MANY HWCONTEXT HEADERS WOULD GO HERE
	//They involve structs in further specific entries.
	// can't declare structs without knowing how big they are.
	// hope I can ignore for now.

	//VideoToolbox and Vk depend on other types beyond FFMPEG.
/*
	// Converts a Video_Toolbox (actually CoreVideo) format to Pixel_Format.
	map_videotoolbox_format_to_pixfmt :: proc(cv_fmt: u32) -> types.Pixel_Format ---

	// Converts a Pixel_Format to a Video_Toolbox (actually CoreVideo) format.
	map_videotoolbox_format_from_pixfmt :: proc(pix_fmt: types.Pixel_Format) -> u32 ---

	// Same as map_videotoolbox_format_from_pixfmt function, but can map and return full range pixel formats via a flag.
	map_videotoolbox_format_from_pixfmt2 :: proc(pix_fmt: types.Pixel_Format, full_range: bool) -> u32 ---

	// Allocates a single VkFrame and initializes everything as 0.
	vk_frame_alloc :: proc() -> ^types.VkFrame ---
	
	// Returns the format of each image up to the number of planes for a given sw_format.
	vkfmt_from_pixfmt :: proc(p: types.Pixel_Format) -> ^types.VkFormat ---
*/

	//===hwcontext.h===
	// Looks up an Hardware_Device_Type by name.
	hwdevice_find_type_by_name :: proc(name: cstring) -> types.Hardware_Device_Type ---

	// Gets the string name of an Hardware_Device_Type.
	hwdevice_get_type_name :: proc(type: types.Hardware_Device_Type) -> cstring ---

	// Iterates over supported device types.
	hwdevice_iterate_types :: proc(prev: types.Hardware_Device_Type) -> types.Hardware_Device_Type ---

	// Allocates an HWDeviceContext for a given hardware type.
	hwdevice_ctx_alloc :: proc(type: types.Hardware_Device_Type) -> ^types.Buffer_Ref ---

	// Finalizes the device context before use.
	hwdevice_ctx_init :: proc(ref: ^types.Buffer_Ref) -> i32 ---

	// Opens a device of the specified type and creates an HWDeviceContext for it.
	hwdevice_ctx_create :: proc(device_ctx: ^^types.Buffer_Ref, type: types.Hardware_Device_Type, device: cstring, opts: ^types.Dictionary, flags: i32) -> i32 ---

	// Creates a new device of the specified type from an existing device.
	hwdevice_ctx_create_derived :: proc(dst_ctx: ^^types.Buffer_Ref, type: types.Hardware_Device_Type, src_ctx: ^types.Buffer_Ref, flags: i32) -> i32 ---

	// Creates a new device of the specified type from an existing device.
	hwdevice_ctx_create_derived_opts :: proc(dst_ctx: ^^types.Buffer_Ref, type: types.Hardware_Device_Type, src_ctx: ^types.Buffer_Ref, options: ^types.Dictionary, flags: i32) -> i32 ---

	// Allocates an HWFramesContext tied to a given device context.
	hwframe_ctx_alloc :: proc(device_ctx: ^types.Buffer_Ref) -> ^types.Buffer_Ref ---

	// Finalizes the context before use.
	hwframe_ctx_init :: proc(ref: ^types.Buffer_Ref) -> i32 ---

	// Allocates a new frame attached to the given HWFramesContext.
	hwframe_get_buffer :: proc(hwframe_ctx: ^types.Buffer_Ref, frame: ^types.Frame, flags: i32) -> i32 ---

	// Copies data to or from a hw surface.
	hwframe_transfer_data :: proc(dst: ^types.Frame, src: ^types.Frame, flags: i32) -> i32 ---

	// Gets a list of possible source or target formats usable in hwframe_transfer_data().
	hwframe_transfer_get_formats :: proc(hwframe_ctx: ^types.Buffer_Ref, dir: types.Hardware_Frame_Transfer_Direction, formats: ^^types.Pixel_Format, flags: i32) -> i32 ---

	// Allocates a HW-specific configuration structure for a given HW device.
	hwdevice_hwconfig_alloc :: proc(device_ctx: ^types.Buffer_Ref) -> rawptr ---

	// Gets the constraints on HW frames given a device and the HW-specific configuration to be used with that device.
	hwdevice_get_hwframe_constraints :: proc(ref: ^types.Buffer_Ref, hwconfig: rawptr) -> ^types.Hardware_Frames_Constraints ---

	// Frees an HWFrameConstraints structure.
	hwframe_constraints_free :: proc(constraints: ^^types.Hardware_Frames_Constraints) ---

	// Maps a hardware frame.
	hwframe_map :: proc(dst: ^types.Frame, src: ^types.Frame, flags: types.Hardware_Frame_Map_Flags) -> i32 ---

	// Creates and initializes an HWFramesContext as a mapping of another existing HWFramesContext on a different device.
	hwframe_ctx_create_derived :: proc(derived_frame_ctx: ^^types.Buffer_Ref, format: types.Pixel_Format,
		 derived_device_ctx: ^types.Buffer_Ref, source_frame_ctx: ^types.Buffer_Ref, flags: types.Hardware_Frame_Map_Flags) -> i32 ---


	//===imgutils.h===
	// Computes the max pixel step for each plane of an image with a given format.
	image_fill_max_pixsteps :: proc(max_pixsteps: [4]i32, max_pixstep_comps: [4]i32, pixdesc: ^types.Pix_Fmt_Descriptor) ---

	// Computes the size of an image line with a given format and width for a specific plane.
	image_get_linesize :: proc(pix_fmt: types.Pixel_Format, width: i32, plane: i32) -> i32 ---

	// Fills plane linesizes for an image with a given pixel format and width.
	image_fill_linesizes :: proc(linesizes: [4]i32, pix_fmt: types.Pixel_Format, width: i32) -> i32 ---

	// Fills plane sizes for an image with a given pixel format and height.
	image_fill_plane_sizes :: proc(size: [4]uintptr, pix_fmt: types.Pixel_Format, height: i32, linesizes: ^ptrdiff_t) -> i32 ---

	// Fills plane data pointers for an image with a given pixel format and height.
	image_fill_pointers :: proc(data: [4][^]u8, pix_fmt: types.Pixel_Format, height: i32, ptr: [^]u8, linesizes: [4]i32) -> i32 ---

	// Allocates an image with a given size and pixel format, and fills pointers and linesizes accordingly.
	image_alloc :: proc(pointers: [4][^]u8, linesizes: [4]i32, w: i32, h: i32, pix_fmt: types.Pixel_Format, align: i32) -> i32 ---

	// Copies image plane from src to dst. That is, copies "height" number of lines of "bytewidth" bytes each.
	image_copy_plane :: proc(dst: [^]u8, dst_linesize: i32, src: [^]u8, src_linesize: i32, bytewidth: i32, height: i32) ---

	// Copies image data located in uncacheable (e.g. GPU mapped) memory.
	image_copy_plane_uc_from :: proc(dst: [^]u8, dst_linesize: ptrdiff_t, src: [^]u8, src_linesize: ptrdiff_t, bytewidth: ptrdiff_t, height: i32) ---

	// Copies image in src_data to dst_data.
	image_copy :: proc(dst_data: [4][^]u8, dst_linesizes: [4]i32, src_data: [4][^]u8, src_linesizes: [4]i32, pix_fmt: types.Pixel_Format, width: i32, height: i32) ---
		// WARNING: dst_data, dst_linesizes, src_data, and src_linesizes might be arrays

	// Copies image data located in uncacheable (e.g. GPU mapped) memory.
	image_copy_uc_from :: proc(dst_data: [4][^]u8, dst_linesizes: [4]ptrdiff_t, src_data: [4][^]u8, src_linesizes: [4]ptrdiff_t, pix_fmt: types.Pixel_Format, width: i32, height: i32) ---
		// WARNING: dst_data, dst_linesizes, src_data, and src_linesizes might be arrays

	// Sets up the data pointers and linesizes based on the specified image parameters and the provided array.
	image_fill_arrays :: proc(dst_data: [4][^]u8, dst_linesize: [4]i32, src: [^]u8, pix_fmt: types.Pixel_Format, width: i32, height: i32, align: i32) -> i32 ---
		// WARNING: dst_data and dst_linesize might be arrays

	// Returns the size in bytes of the amount of data required to store an image with the given parameters.
	image_get_buffer_size :: proc(pix_fmt: types.Pixel_Format, width: i32, height: i32, align: i32) -> i32 ---

	// Copies image data from an image into a buffer.
	image_copy_to_buffer :: proc(dst: [^]u8, dst_size: i32, src_data: [4][^]u8, src_linesize: [4]i32, pix_fmt: types.Pixel_Format, width: i32, height: i32, align: i32) -> i32 ---
	// WARNING: src_data and src_linesize might be arrays

	// Checks if the given dimension of an image is valid.
	image_check_size :: proc(w: u32, h: u32, log_offset: i32, log_ctx: rawptr) -> i32 ---

	// Checks if the given dimension of an image is valid for a specified pixel format.
	image_check_size2 :: proc(w: u32, h: u32, max_pixels: i64, pix_fmt: types.Pixel_Format, log_offset: i32, log_ctx: rawptr) -> i32 ---

	// Checks if the given sample aspect ratio of an image is valid.
	image_check_sar :: proc(w: u32, h: u32, sar: types.Rational) -> i32 ---

	// Overwrites the image data with black.
	image_fill_black :: proc(dst_data: [4][^]u8, dst_linesize: [4]ptrdiff_t, pix_fmt: types.Pixel_Format, range: types.Color_Range, width: i32, height: i32) -> i32 ---
	// WARNING: dst_data and dst_linesize might be arrays


	//===lfg.h===
	// Initializes the ALFG with a seed.
	lfg_init :: proc(c: ^types.LFG, seed: u32) ---

	// Seeds the state of the ALFG using binary data.
	lfg_init_from_data :: proc(c: ^types.LFG, data: [^]u8, length: u32) -> i32 ---

	// Gets the next two numbers generated by a Box-Muller Gaussian generator.
	bmg_get :: proc(lfg: ^types.LFG, out: [2]f64) ---


	//===log.h===
	// Sends the specified message to the log if the level is less than or equal to the current log level.
	log :: proc(avcl: rawptr, level: i32, fmt: cstring, varargs: ..any) ---

	// Sends the specified message to the log once with the initial_level and then with the subsequent_level.
	log_once :: proc(avcl: rawptr, initial_level: i32, subsequent_level: i32, state: ^i32, fmt: cstring, varargs: ..any) ---

	// Sends the specified message to the log if the level is less than or equal to the current log level.
	vlog :: proc(avcl: rawptr, level: i32, fmt: cstring, vl: types.va_list) ---

	// Gets the current log level.
	log_get_level :: proc() -> types.Log_Level ---

	// Sets the log level.
	log_set_level :: proc(level: types.Log_Level) ---

	// Sets the logging callback.
	log_set_callback :: proc(callback: proc(avcl: rawptr, level:types.Log_Level, fmt:cstring, vl:types.va_list)) ---

	// Default logging callback that prints the message to stderr, optionally colorizing it.
	log_default_callback :: proc(avcl: rawptr, level: types.Log_Level, fmt: cstring, vl: types.va_list) ---

	// Returns the context name.
	default_item_name :: proc(ctx: rawptr) -> cstring ---
	default_get_category :: proc(ptr: rawptr) -> types.Class_Category ---

	// Formats a line of log the same way as the default callback.
	log_format_line :: proc(ptr: rawptr, level: i32, fmt: cstring, vl: types.va_list, line: cstring, line_size: i32, print_prefix: ^i32) ---
	log_format_line2 :: proc(ptr: rawptr, level: i32, fmt: cstring, vl: types.va_list, line: cstring, line_size: i32, print_prefix: ^i32) -> i32 ---

	//TODO: two defines before this in the .h file. Are these the argument flags?
	// seems implied, but flag prefix not listed.
	log_set_flags :: proc(arg: i32) ---
	log_get_flags :: proc() -> i32 ---


	//===lzo.h===
	// Decodes LZO 1x compressed data.
	lzo1x_decode :: proc(out: rawptr, outlen: ^i32, ptr_in: rawptr, inlen: ^i32) -> types.LZO_Decode_Flags ---

	//===mastering_display_metadata.h===
	// Allocates an AVMasteringDisplayMetadata structure and sets its fields to default values.
	mastering_display_metadata_alloc :: proc() -> ^types.Mastering_Display_Metadata ---
	mastering_display_metadata_create_side_data :: proc(frame: ^types.Frame) -> ^types.Mastering_Display_Metadata ---

	// Allocates an AVContentLightMetadata structure and sets its fields to default values.
	content_light_metadata_alloc :: proc(size: ^uintptr) -> ^types.Content_Light_Metadata ---
	content_light_metadata_create_side_data :: proc(frame: ^types.Frame) -> ^types.Content_Light_Metadata ---



	//===mathematics.h===
	// Computes the greatest common divisor of two integer operands.
	gcd :: proc(a: i64, b: i64) -> i64 ---

	// Rescales a 64-bit integer with rounding to nearest.
	rescale :: proc(a: i64, b: i64, c: i64) -> i64  ---
	rescale_rnd :: proc(a: i64, b: i64, c: i64, rnd: types.Rounding) -> i64  ---
	rescale_q :: proc(a: i64, bq: types.Rational, cq: types.Rational) -> i64  ---
	rescale_q_rnd :: proc(a: i64, bq: types.Rational, cq: types.Rational, rnd: types.Rounding) -> i64  ---

	// Compares two timestamps each in its own time base.
	compare_ts :: proc(ts_a: i64, tb_a: types.Rational, ts_b: i64, tb_b: types.Rational) -> i32 ---

	// Compares the remainders of two integer operands divided by a common divisor.
	compare_mod :: proc(a: u64, b: u64, mod: u64) -> i64 ---

	// Rescales a timestamp while preserving known durations.
	rescale_delta :: proc(in_tb: types.Rational, in_ts: i64, fs_tb: types.Rational, duration: i32, last: ^i64, out_tb: types.Rational) -> i64 ---

	// Adds a value to a timestamp.
	add_stable :: proc(ts_tb: types.Rational, ts: i64, inc_tb: types.Rational, inc: i64) -> i64 ---

	// 0th order modified bessel function of the first kind.
	bessel_i0 :: proc(x:f64)->f64 ---



	//===md5.h===
	// Allocates an AVMD5 context.
	md5_alloc :: proc() -> ^types.MD5 ---

	// Initializes MD5 hashing.
	md5_init :: proc(ctx: ^types.MD5) ---

	// Updates hash value.
	md5_update :: proc(ctx: ^types.MD5, src: [^]u8, len: uintptr) ---

	// Finishes hashing and outputs digest value.
	md5_final :: proc(ctx: ^types.MD5, dst: [^]u8) ---

	// Hashes an array of data.
	md5_sum :: proc(dst: [^]u8, src: [^]u8, len: uintptr) ---


	//===mem.h===
	// Allocates a memory block with alignment suitable for all memory accesses.
	malloc :: proc(size: uintptr) -> rawptr ---

	// Allocates a memory block with alignment suitable for all memory accesses and zeroes all the bytes of the block.
	mallocz :: proc(size: uintptr) -> rawptr ---

	// Allocates a memory block for an array with malloc.
	malloc_array :: proc(nmemb: uintptr, size: uintptr) -> rawptr ---

	// Allocates a memory block for an array with mallocz.
	calloc :: proc(nmemb: uintptr, size: uintptr) -> rawptr ---

	// Allocates, reallocates, or frees a block of memory.
	realloc :: proc(ptr: rawptr, size: uintptr) -> rawptr ---

	// Allocates, reallocates, or frees a block of memory through a pointer to a pointer.
	reallocp :: proc(ptr: rawptr, size: uintptr) -> i32 ---

	// Allocates, reallocates, or frees a block of memory.
	realloc_f :: proc(ptr: rawptr, nelem: uintptr, elsize: uintptr) -> rawptr ---

	// Allocates, reallocates, or frees an array.
	realloc_array :: proc(ptr: rawptr, nmemb: uintptr, size: uintptr) -> rawptr ---

	// Allocates, reallocates, or frees an array through a pointer to a pointer.
	reallocp_array :: proc(ptr: rawptr, nmemb: uintptr, size: uintptr) -> i32 ---


	// Allocate a buffer, reusing the given one if large enough.
	fast_malloc :: proc(ptr: rawptr, size: ^u32, min_size: uintptr) --- 

	// Allocate and clear a buffer, reusing the given one if large enough.
	fast_mallocz :: proc(ptr: rawptr, size: ^u32, min_size: uintptr) --- 

	// Free a memory block which has been allocated with a function of av_malloc()
	// or av_realloc() family.
	free :: proc(ptr: rawptr) --- 

	// Free a memory block which has been allocated with a function of av_malloc()
	// or av_realloc() family, and set the pointer pointing to it to `NULL`.
	freep :: proc(ptr: rawptr) --- 

	// Duplicate a string.
	//??? output is a pointer to a cstring or NULL if not allocated.
	//C code just has char*, not char**.
	strdup :: proc(s: cstring) -> cstring --- 

	// Duplicate a substring of a string.
	strndup :: proc(s: cstring, len: uintptr) -> cstring --- 

	// Duplicate a buffer with av_malloc().
	memdup :: proc(p: rawptr, size: uintptr) -> rawptr --- 

	// Overlapping memcpy() implementation.
	memcpy_backptr :: proc(dst: [^]u8, back: i32, cnt: i32) --- 

	// Add the pointer to an element to a dynamic array.
	dynarray_add :: proc(tab_ptr: rawptr, nb_ptr: ^i32, elem: rawptr) --- 

	// Add an element to a dynamic array.
	dynarray_add_nofree :: proc(tab_ptr: rawptr, nb_ptr: ^i32, elem: rawptr) -> i32 --- 

	// Add an element of size `elem_size` to a dynamic array.
	dynarray2_add :: proc(tab_ptr: ^rawptr, nb_ptr: ^i32, elem_size: uintptr,
				elem_data: [^]u8) -> rawptr --- 
	//Multiply two `size_t` values checking for overflow.
	size_mult :: proc(a:uintptr,b:uintptr,r:^uintptr)-> i32 ---

	//Set the maximum size that may be allocated in one block.
	max_alloc :: proc(max:uintptr) ---

	//===murmur3.h===
	// Allocate an AVMurMur3 hash context.
	murmur3_alloc :: proc() -> ^types.MurMur3 ---

	// Initialize or reinitialize an AVMurMur3 hash context with a seed.
	murmur3_init_seeded :: proc(c: ^types.MurMur3, seed: u64) ---

	// Initialize or reinitialize an AVMurMur3 hash context.
	murmur3_init :: proc(c: ^types.MurMur3) ---

	// Updates hash context with new data
	murmur3_update :: proc(c: ^types.MurMur3, src: [^]u8, len: uintptr) ---

	// Finishes hashing and outputs digest value
	murmur3_final :: proc(c: ^types.MurMur3, dst: [16]u8) ---



	//===opt.h===
	//Show options
	opt_show2 :: proc(obj:rawptr, log_obj:rawptr, req_flags:i32, rej_flags:i32)->i32 ---

	// Sets Option fields to default values
	opt_set_defaults :: proc(s: rawptr) ---

	// Sets Option fields to default values based on mask and flags
	opt_set_defaults2 :: proc(s: rawptr, mask: i32, flags: i32) ---

	// Parses key/value pairs in opts
	set_options_string :: proc(ctx: rawptr, opts: cstring, key_val_sep: cstring, pairs_sep: cstring) -> i32 ---

	// Sets option values from a string
	opt_set_from_string :: proc(ctx: rawptr, opts: cstring, shorthand: ^cstring, key_val_sep: cstring, pairs_sep: cstring) -> i32 ---

	// Frees all allocated objects in obj
	opt_free :: proc(obj: rawptr) ---

	// Checks if a flag is set in a flags field
	opt_flag_is_set :: proc(obj: rawptr, field_name: cstring, flag_name: cstring) -> i32 ---

	// Sets options from a dictionary on an object
	opt_set_dict :: proc(obj: rawptr, options: ^types.Dictionary) -> i32 ---

	// Sets options from a dictionary on an object with search flags
	opt_set_dict2 :: proc(obj: rawptr, options: ^types.Dictionary, search_flags: i32) -> i32 ---

	// Extracts a key-value pair from the beginning of a string
	opt_get_key_value :: proc(ropts: ^cstring, key_val_sep: cstring, pairs_sep: cstring, flags: u32, rkey: ^cstring, rval: ^cstring) -> i32 ---

	// Evaluates option strings and gets numbers out of them
	opt_eval_flags  :: proc(obj: rawptr, o: ^types.Option, val: cstring, flags_out: ^i32) -> i32 ---
	opt_eval_int    :: proc(obj: rawptr, o: ^types.Option, val: cstring, int_out: ^i32) -> i32 ---
	opt_eval_int64  :: proc(obj: rawptr, o: ^types.Option, val: cstring, int64_out: ^i64) -> i32 ---
	opt_eval_float  :: proc(obj: rawptr, o: ^types.Option, val: cstring, float_out: ^f32) -> i32 ---
	opt_eval_double :: proc(obj: rawptr, o: ^types.Option, val: cstring, double_out: ^f64) -> i32 ---
	opt_eval_q      :: proc(obj: rawptr, o: ^types.Option, val: cstring, q_out: ^types.Rational) -> i32 ---

	// Looks for an option in an object
	opt_find :: proc(obj: rawptr, name: cstring, unit: cstring, opt_flags: types.Option_Flags, search_flags: i32) -> ^types.Option ---

	// Looks for an option in an object and returns target object
	opt_find2 :: proc(obj: rawptr, name: cstring, unit: cstring, opt_flags: types.Option_Flags, search_flags: i32, target_obj: ^rawptr) -> ^types.Option ---

	// Iterates over all Options belonging to obj
	opt_next :: proc(obj: rawptr, prev: ^types.Option) -> ^types.Option ---

	// Iterates over AVOptions-enabled children of obj
	opt_child_next :: proc(obj: rawptr, prev: rawptr) -> rawptr ---

	// Iterates over potential AVOptions-enabled children of parent
	opt_child_class_iterate :: proc(parent: ^types.Class, iter: ^rawptr) -> ^types.Class ---

	// Sets the field of obj with the given name to value
	opt_set :: proc(obj: rawptr, name: cstring, val: cstring, search_flags: i32) -> i32 ---
	opt_set_int :: proc(obj: rawptr, name: cstring, val: i64, search_flags: i32) -> i32 ---
	opt_set_double :: proc(obj: rawptr, name: cstring, val: f64, search_flags: i32) -> i32 ---
	opt_set_q :: proc(obj: rawptr, name: cstring, val: types.Rational, search_flags: i32) -> i32 ---
	opt_set_bin :: proc(obj: rawptr, name: cstring, val: [^]u8, size: i32, search_flags: i32) -> i32 ---
	opt_set_image_size :: proc(obj: rawptr, name: cstring, w: i32, h: i32, search_flags: i32) -> i32 ---
	opt_set_pixel_fmt :: proc(obj: rawptr, name: cstring, fmt: types.Pixel_Format, search_flags: i32) -> i32 ---
	opt_set_sample_fmt :: proc(obj: rawptr, name: cstring, fmt: types.Sample_Format, search_flags: i32) -> i32 ---
	opt_set_video_rate :: proc(obj: rawptr, name: cstring, val: types.Rational, search_flags: i32) -> i32 ---
	opt_set_chlayout :: proc(obj: rawptr, name: cstring, ch_layout: ^types.Channel_Layout, search_flags: i32) -> i32 ---
	opt_set_dict_val :: proc(obj: rawptr, name: cstring, val: ^types.Dictionary, search_flags: i32) -> i32 ---

	// Gets a value of the option with the given name from an object
	opt_get :: proc(obj: rawptr, name: cstring, search_flags: i32, out_val: ^^u8) -> i32 ---
	opt_get_int :: proc(obj: rawptr, name: cstring, search_flags: i32, out_val: ^i64) -> i32 ---
	opt_get_double :: proc(obj: rawptr, name: cstring, search_flags: i32, out_val: ^f64) -> i32 ---
	opt_get_q :: proc(obj: rawptr, name: cstring, search_flags: i32, out_val: ^types.Rational) -> i32 ---
	opt_get_image_size :: proc(obj: rawptr, name: cstring, search_flags: i32, w_out: ^i32, h_out: ^i32) -> i32 ---
	opt_get_pixel_fmt :: proc(obj: rawptr, name: cstring, search_flags: i32, out_fmt: ^types.Pixel_Format) -> i32 ---
	opt_get_sample_fmt :: proc(obj: rawptr, name: cstring, search_flags: i32, out_fmt: ^types.Sample_Format) -> i32 ---
	opt_get_video_rate :: proc(obj: rawptr, name: cstring, search_flags: i32, out_val: ^types.Rational) -> i32 ---
	opt_get_chlayout :: proc(obj: rawptr, name: cstring, search_flags: i32, ch_layout: ^types.Channel_Layout) -> i32 ---
	opt_get_dict_val :: proc(obj: rawptr, name: cstring, search_flags: i32, out_val: ^^types.Dictionary) -> i32 ---

	// Gets a pointer to the requested field in a struct
	opt_ptr :: proc(avclass: ^types.Class, obj: rawptr, name: cstring) -> rawptr ---

	// Frees an OptionRanges struct and sets it to NULL
	opt_freep_ranges :: proc(ranges: ^^types.Option_Ranges) ---

	// Gets a list of allowed ranges for the given option
	opt_query_ranges :: proc(ranges: ^^types.Option_Ranges, obj: rawptr, key: cstring, flags: i32) -> i32 ---

	// Copies options from src object into dest object
	opt_copy :: proc(dest: rawptr, src: rawptr) -> i32 ---

	// Gets a default list of allowed ranges for the given option
	opt_query_ranges_default :: proc(ranges: ^^types.Option_Ranges, obj: rawptr, key: cstring, flags: i32) -> i32 ---

	// Checks if given option is set to its default value
	opt_is_set_to_default :: proc(obj: rawptr, o: ^types.Option) -> i32 ---

	// Checks if given option is set to its default value by name
	opt_is_set_to_default_by_name :: proc(obj: rawptr, name: cstring, search_flags: i32) -> i32 ---

	// Serializes object's options
	opt_serialize :: proc(obj: rawptr, opt_flags: i32, flags: i32, buffer: ^^cstring, key_val_sep: byte, pairs_sep: byte) -> i32 ---


	//===parseutils.h===
	// Parses str and stores the parsed ratio in q
	parse_ratio :: proc(q: ^types.Rational, str: cstring, max: i32, log_offset: i32, log_ctx: rawptr) -> i32 ---

	// Parses str and puts in width_ptr and height_ptr the detected values
	parse_video_size :: proc(width_ptr: ^i32, height_ptr: ^i32, str: cstring) -> i32 ---

	// Parses str and stores the detected values in *rate
	parse_video_rate :: proc(rate: ^types.Rational, str: cstring) -> i32 ---

	// Puts the RGBA values that correspond to color_string in rgba_color
	parse_color :: proc(rgba_color: ^u8, color_string: cstring, slen: i32, log_ctx: rawptr) -> i32 ---

	// Gets the name of a color from the internal table of hard-coded named colors
	get_known_color_name :: proc(color_idx: i32, rgb: ^^u8) -> cstring ---

	// Parses timestr and returns in *time a corresponding number of microseconds
	parse_time :: proc(timeval: ^i64, timestr: cstring, duration: i32) -> i32 ---

	// Attempts to find a specific tag in a URL
	find_info_tag :: proc(arg: cstring, arg_size: i32, tag1: cstring, info: cstring) -> i32 ---

	// Simplified version of strptime
	small_strptime :: proc(p: cstring, fmt: cstring, dt: ^types.Tm) -> cstring ---

	// Converts the decomposed UTC time in tm to a time_t value
	timegm :: proc(tm: ^types.Tm) -> time_t ---


	//===pixdesc.h===
	// Returns the number of bits per pixel used by the pixel format described by pixdesc
	get_bits_per_pixel :: proc(pixdesc: ^types.Pix_Fmt_Descriptor) -> i32 ---

	// Returns the number of bits per pixel for the pixel format described by pixdesc, including any padding or unused bits
	get_padded_bits_per_pixel :: proc(pixdesc: ^types.Pix_Fmt_Descriptor) -> i32 ---

	// Returns a pixel format descriptor for provided pixel format or NULL if this pixel format is unknown
	pix_fmt_desc_get :: proc(pix_fmt: types.Pixel_Format) -> ^types.Pix_Fmt_Descriptor ---

	// Iterates over all pixel format descriptors known to libavutil
	pix_fmt_desc_next :: proc(prev: ^types.Pix_Fmt_Descriptor) -> ^types.Pix_Fmt_Descriptor ---

	// Returns an AVPixel_Format id described by desc, or AV_PIX_FMT_NONE if desc is not a valid pointer to a pixel format descriptor
	pix_fmt_desc_get_id :: proc(desc: ^types.Pix_Fmt_Descriptor) -> types.Pixel_Format ---

	// Utility function to access log2_chroma_w log2_chroma_h from the pixel format AVPix_Fmt_Descriptor
	pix_fmt_get_chroma_sub_sample :: proc(pix_fmt: types.Pixel_Format, h_shift: ^i32, v_shift: ^i32) -> i32 ---

	// Returns number of planes in pix_fmt, a negative AVERROR if pix_fmt is not a valid pixel format
	pix_fmt_count_planes :: proc(pix_fmt: types.Pixel_Format) -> i32 ---

	// Returns the name for provided color range or NULL if unknown
	color_range_name :: proc(range: types.Color_Range) -> cstring ---

	// Returns the AVColorRange value for name or an AVError if not found
	color_range_from_name :: proc(name: cstring) -> i32 ---

	// Returns the name for provided color primaries or NULL if unknown
	color_primaries_name :: proc(primaries: types.Color_Primaries) -> cstring ---

	// Returns the AVColorPrimaries value for name or an AVError if not found
	color_primaries_from_name :: proc(name: cstring) -> i32 ---

	// Returns the name for provided color transfer or NULL if unknown
	color_transfer_name :: proc(transfer: types.Color_Transfer_Characteristic) -> cstring ---

	// Returns the AVColorTransferCharacteristic value for name or an AVError if not found
	color_transfer_from_name :: proc(name: cstring) -> i32 ---

	// Returns the name for provided color space or NULL if unknown
	color_space_name :: proc(space: types.Color_Space) -> cstring ---

	// Returns the AVColorSpace value for name or an AVError if not found
	color_space_from_name :: proc(name: cstring) -> i32 ---

	// Returns the name for provided chroma location or NULL if unknown
	chroma_location_name :: proc(location: types.Chroma_Location) -> cstring ---

	// Returns the AVChromaLocation value for name or an AVError if not found
	chroma_location_from_name :: proc(name: cstring) -> i32 ---

	//Converts AVChromaLocation to swscale x/y chroma position.
	chroma_location_enum_to_pos :: proc(xpos:^i32, ypos:^i32, pos:types.Chroma_Location)-> i32 ---

	//Converts swscale x/y chroma position to AVChromaLocation.
	chroma_location_pos_to_enum :: proc(xpos:i32, ypos:i32)-> types.Chroma_Location ---

	// Returns the pixel format corresponding to name
	get_pix_fmt :: proc(name: cstring) -> types.Pixel_Format ---

	// Returns the short name for a pixel format, NULL in case pix_fmt is unknown
	get_pix_fmt_name :: proc(pix_fmt: types.Pixel_Format) -> cstring ---

	// Prints in buf the string corresponding to the pixel format with number pix_fmt, or a header if pix_fmt is negative
	get_pix_fmt_string :: proc(buf: cstring, buf_size: i32, pix_fmt: types.Pixel_Format) -> cstring ---

	// Reads a line from an image, and writes the values of the pixel format component c to dst
	read_image_line2 :: proc(dst: rawptr, data: [4][^]u8, linesize: [4]i32, desc: ^types.Pix_Fmt_Descriptor, x: i32, y: i32, c: i32, w: i32, read_pal_component: i32, dst_element_size: i32) ---
	read_image_line :: proc(dst: [^]u16, data: [4][^]u8, linesize: [4]i32, desc: ^types.Pix_Fmt_Descriptor, x: i32, y: i32, c: i32, w: i32, read_pal_component: i32) ---

	// Writes the values from src to the pixel format component c of an image line
	write_image_line2 :: proc(src: rawptr, data: [4][^]u8, linesize: [4]i32, desc: ^types.Pix_Fmt_Descriptor, x: i32, y: i32, c: i32, w: i32, src_element_size: i32) ---
	write_image_line :: proc(src: [^]u16, data: [4][^]u8, linesize: [4]i32, desc: ^types.Pix_Fmt_Descriptor, x: i32, y: i32, c: i32, w: i32) ---

	// Utility function to swap the endianness of a pixel format
	pix_fmt_swap_endianness :: proc(pix_fmt: types.Pixel_Format) -> types.Pixel_Format ---

	// Computes what kind of losses will occur when converting from one specific pixel format to another
	get_pix_fmt_loss :: proc(dst_pix_fmt: types.Pixel_Format, src_pix_fmt: types.Pixel_Format, has_alpha: i32) -> types.Conversion_Loss_Flags ---

	// Computes what kind of losses will occur when converting from one specific pixel format to another
	find_best_pix_fmt_of_2 :: proc(dst_pix_fmt1: types.Pixel_Format, dst_pix_fmt2: types.Pixel_Format, src_pix_fmt: types.Pixel_Format, has_alpha: i32, loss_ptr: ^i32) -> types.Pixel_Format ---


	//===pixelutils.h===
	pixelutils_get_sad_fn :: proc(w_bits:i32, h_bits:i32, aligned:i32, log_ctx:rawptr)-> types.av_pixelutils_sad_fn ---

	//===random_seed.h===
	get_random_seed :: proc()-> u32 ---
	random_bytes :: proc(buf:[^]u8, len:uintptr)->i32 ---

	//===rational.h===
	// Reduces a fraction
	reduce :: proc(dst_num: ^i32, dst_den: ^i32, num: i64, den: i64, max: i64) -> i32 ---

	// Multiplies two rationals
	mul_q :: proc(b: types.Rational, c: types.Rational) -> types.Rational ---

	// Divides one rational by another
	div_q :: proc(b: types.Rational, c: types.Rational) -> types.Rational ---

	// Adds two rationals
	add_q :: proc(b: types.Rational, c: types.Rational) -> types.Rational ---

	// Subtracts one rational from another
	sub_q :: proc(b: types.Rational, c: types.Rational) -> types.Rational ---

	// Converts a double precision floating point number to a rational
	d2q :: proc(d: f64, max: i32) -> types.Rational ---

	// Finds which of the two rationals is closer to another rational
	nearer_q :: proc(q: types.Rational, q1: types.Rational, q2: types.Rational) -> i32 ---

	// Finds the value in a list of rationals nearest a given reference rational
	find_nearest_q_idx :: proc(q: types.Rational, q_list: ^types.Rational) -> i32 ---

	// Converts an AVRational to a IEEE 32-bit `float` expressed in fixed-point format
	q2intfloat :: proc(q: types.Rational) -> u32 ---

	// Returns the best rational so that a and b are multiple of it
	gcd_q :: proc(a: types.Rational, b: types.Rational, max_den: i32, def: types.Rational) -> types.Rational ---


	//===rc4.h===
	// Allocates an AVRC4 context
	rc4_alloc :: proc() -> ^types.RC4 ---

	// Initializes an AVRC4 context
	rc4_init :: proc(d: ^types.RC4, key: [^]u8, key_bits: i32, decrypt: b32) -> i32 ---

	// Encrypts / decrypts using the RC4 algorithm
	rc4_crypt :: proc(d: ^types.RC4, dst: [^]u8, src: [^]u8, count: i32, iv: [^]u8, decrypt: b32) ---

	//===ripemd.h===
	// Allocates an AVRIPEMD context
	ripemd_alloc :: proc() -> ^types.RIPEMD ---

	// Initializes RIPEMD hashing
	ripemd_init :: proc(ctx: ^types.RIPEMD, bits: i32) -> i32 ---

	// Updates hash value
	ripemd_update :: proc(ctx: ^types.RIPEMD, data: [^]u8, len: uintptr) ---

	// Finishes hashing and outputs digest value
	ripemd_final :: proc(ctx: ^types.RIPEMD, digest: [^]u8) ---


	//===samplefmt.h===
	// Returns the name of sample_fmt
	get_sample_fmt_name :: proc(sample_fmt: types.Sample_Format) -> cstring ---

	// Returns a sample format corresponding to name
	get_sample_fmt :: proc(name: cstring) -> types.Sample_Format ---

	// Returns the planar<->packed alternative form of the given sample format
	get_alt_sample_fmt :: proc(sample_fmt: types.Sample_Format, planar: i32) -> types.Sample_Format ---

	// Gets the packed alternative form of the given sample format
	get_packed_sample_fmt :: proc(sample_fmt: types.Sample_Format) -> types.Sample_Format ---

	// Gets the planar alternative form of the given sample format
	get_planar_sample_fmt :: proc(sample_fmt: types.Sample_Format) -> types.Sample_Format ---

	//Generate a string corresponding to the sample format with sample_fmt, or a header if sample_fmt is negative.
	get_sample_fmt_string :: proc(buf:[^]byte, buf_size:i32, sample_fmt: types.Sample_Format)->cstring ---

	//Return number of bytes per sample.
	get_bytes_per_sample :: proc(sample_fmt: types.Sample_Format)->i32 ---

	//Check if the sample format is planar.
	sample_fmt_is_planar :: proc(sample_fmt: types.Sample_Format)->i32 ---

	//Get the required buffer size for the given audio parameters.
	samples_get_buffer_size :: proc(linesize:^i32, nb_channels:i32, nb_samples:i32, sample_fmt: types.Sample_Format, align:i32)->i32 ---

	// Fills plane data pointers and linesize for samples with sample format sample_fmt
	samples_fill_arrays :: proc(audio_data: [^]^u8, linesize: ^i32, buf: [^]u8, nb_channels: i32, nb_samples: i32, sample_fmt: types.Sample_Format, align: i32) -> i32 ---

	// Allocates a samples buffer for nb_samples samples, and fills data pointers and linesize accordingly
	samples_alloc :: proc(audio_data: [^]^u8, linesize: ^i32, nb_channels: i32, nb_samples: i32, sample_fmt: types.Sample_Format, align: i32) -> i32 ---

	// Allocates a data pointers array, samples buffer for nb_samples samples, and fills data pointers and linesize accordingly
	samples_alloc_array_and_samples :: proc(audio_data: ^[^]^u8, linesize: ^i32, nb_channels: i32, nb_samples: i32, sample_fmt: types.Sample_Format, align: i32) -> i32 ---

	// Copies samples from src to dst
	samples_copy :: proc(dst: [^]^u8, src: [^]^u8, dst_offset: i32, src_offset: i32, nb_samples: i32, nb_channels: i32, sample_fmt: types.Sample_Format) -> i32 ---

	// Fills an audio buffer with silence
	samples_set_silence :: proc(audio_data: [^]^u8, offset: i32, nb_samples: i32, nb_channels: i32, sample_fmt: types.Sample_Format) -> i32 ---

	//===sha.h===
	// Allocates an AVSHA context
	sha_alloc :: proc() -> ^types.SHA ---

	// Initializes SHA-1 or SHA-2 hashing
	sha_init :: proc(ctx: ^types.SHA, bits: i32) -> i32 ---

	// Updates hash value
	sha_update :: proc(ctx: ^types.SHA, data: [^]u8, len: uintptr) ---

	// Finishes hashing and outputs digest value
	sha_final :: proc(ctx: ^types.SHA, digest: [^]u8) ---

	//===sha512.h===
	// Allocates an AVSHA512 context
	sha512_alloc :: proc() -> ^types.SHA512 ---

	// Initializes SHA-2 512 hashing
	sha512_init :: proc(ctx: ^types.SHA512, bits: i32) -> i32 ---

	// Updates hash value
	sha512_update :: proc(ctx: ^types.SHA512, data: [^]u8, len: uintptr) ---

	// Finishes hashing and outputs digest value
	sha512_final :: proc(ctx: ^types.SHA512, digest: [^]u8) ---

	//===spherical.h===
	// Allocates a AVSphericalVideo structure and initializes its fields to default values
	spherical_alloc :: proc(size: ^uintptr) -> ^types.Spherical_Mapping ---

	// Converts the bounding fields from an AVSphericalVideo from 0.32 fixed point to pixels
	spherical_tile_bounds :: proc(sphere_map: ^types.Spherical_Mapping, width: uintptr, height: uintptr, left: ^uintptr, top: ^uintptr, right: ^uintptr, bottom: ^uintptr) ---

	// Provides a human-readable name of a given AVSphericalProjection
	spherical_projection_name :: proc(projection: types.Spherical_Projection) -> cstring ---

	// Gets the AVSphericalProjection form a human-readable name
	spherical_from_name :: proc(name: cstring) -> i32 ---


	//===stereo3d.h===
	// Allocates an AVStereo3D structure and sets its fields to default values
	stereo3d_alloc :: proc() -> ^types.Stereo_3D ---

	// Allocates a complete AVFrameSideData and adds it to the frame
	stereo3d_create_side_data :: proc(frame: ^types.Frame) -> ^types.Stereo_3D ---

	// Provides a human-readable name of a given stereo3d type
	stereo3d_type_name :: proc(type: u32) -> cstring ---

	// Gets the AVStereo3DType form a human-readable name
	stereo3d_from_name :: proc(name: cstring) -> i32 ---


	//===tea.h===
	// Allocates an AVTEA context
	tea_alloc :: proc() -> ^types.TEA ---

	// Initializes an AVTEA context
	tea_init :: proc(ctx: ^types.TEA, key: [16]u8, rounds: i32) ---

	// Encrypts or decrypts a buffer using a previously initialized context
	tea_crypt :: proc(ctx: ^types.TEA, dst: [^]u8, src: [^]u8, count: i32, iv: [^]u8, decrypt: b32) ---


	//===threadmessage.h===
	// Allocates a new message queue
	thread_message_queue_alloc :: proc(mq: ^[^]types.Thread_Message_Queue, nelem: u32, elsize: u32) -> i32 ---

	// Frees a message queue
	thread_message_queue_free :: proc(mq: ^[^]types.Thread_Message_Queue) ---

	// Sends a message on the queue
	thread_message_queue_send :: proc(mq: ^types.Thread_Message_Queue, msg: rawptr, flags: u32) -> i32 ---

	// Receives a message from the queue
	thread_message_queue_recv :: proc(mq: ^types.Thread_Message_Queue, msg: rawptr, flags: u32) -> i32 ---

	// Sets the sending error code
	thread_message_queue_set_err_send :: proc(mq: ^types.Thread_Message_Queue, err: i32) ---

	// Sets the receiving error code
	thread_message_queue_set_err_recv :: proc(mq: ^types.Thread_Message_Queue, err: i32) ---

	// Sets the optional free message callback function which will be called if an operation is removing messages from the queue
	thread_message_queue_set_free_func :: proc(mq: ^types.Thread_Message_Queue, free_func: proc(^rawptr)) ---

	// Returns the current number of messages in the queue
	thread_message_queue_nb_elems :: proc(mq: ^types.Thread_Message_Queue) -> i32 ---

	// Flushes the message queue
	thread_message_flush :: proc(mq: ^types.Thread_Message_Queue) ---


	//===time.h===
	// Gets the current time in microseconds
	gettime :: proc() -> i64 ---

	// Gets the current time in microseconds since some unspecified starting point
	gettime_relative :: proc() -> i64 ---

	// Indicates with a boolean result if the av_gettime_relative() time source is monotonic
	gettime_relative_is_monotonic :: proc() -> i32 ---

	// Sleeps for a period of time
	usleep :: proc(usec: u32) -> i32 ---


	//===timecode.h===
	// Adjusts frame number for NTSC drop frame time code
	timecode_adjust_ntsc_framenum2 :: proc(framenum: i32, fps: i32) -> i32 ---

	// Converts frame number to SMPTE 12M binary representation
	timecode_get_smpte_from_framenum :: proc(tc: ^types.Timecode, framenum: i32) -> u32 ---

	// Converts sei info to SMPTE 12M binary representation
	timecode_get_smpte :: proc(rate: types.Rational, drop: i32, hh: i32, mm: i32, ss: i32, ff: i32) -> u32 ---

	// Loads timecode string in buf
	timecode_make_string :: proc(tc: ^types.Timecode, buf: cstring, framenum: i32) -> cstring ---

	// Gets the timecode string from the SMPTE timecode format
	timecode_make_smpte_tc_string2 :: proc(buf: cstring, rate: types.Rational, tcsmpte: u32, prevent_df: i32, skip_field: i32) -> cstring ---

	// Gets the timecode string from the SMPTE timecode format
	timecode_make_smpte_tc_string :: proc(buf: cstring, tcsmpte: u32, prevent_df: i32) -> cstring ---

	// Gets the timecode string from the 25-bit timecode format (MPEG GOP format)
	timecode_make_mpeg_tc_string :: proc(buf: cstring, tc25bit: u32) -> cstring ---

	// Inits a timecode struct with the passed parameters
	timecode_init :: proc(tc: ^types.Timecode, rate: types.Rational, flags: types.Timecode_Flags, frame_start: i32, log_ctx: rawptr) -> i32 ---

	// Inits a timecode struct from the passed timecode components
	timecode_init_from_components :: proc(tc: ^types.Timecode, rate: types.Rational, flags: types.Timecode_Flags, hh: i32, mm: i32, ss: i32, ff: i32, log_ctx: rawptr) -> i32 ---

	// Parses timecode representation (hh:mm:ss[:;.]ff)
	timecode_init_from_string :: proc(tc: ^types.Timecode, rate: types.Rational, str: cstring, log_ctx: rawptr) -> i32 ---

	// Checks if the timecode feature is available for the given frame rate
	timecode_check_frame_rate :: proc(rate: types.Rational) -> i32 ---


	//===tree.h===
	// Allocates an AVTree_Node
	tree_node_alloc :: proc() -> ^types.Tree_Node ---

	// Finds an element
	tree_find :: proc(root: ^types.Tree_Node, key: rawptr, cmp: proc(^rawptr, ^rawptr) -> i32, next: [2]rawptr) -> rawptr ---

	// Inserts or removes an element
	tree_insert :: proc(rootp: ^^types.Tree_Node, key: rawptr, cmp: proc(^rawptr, ^rawptr) -> i32, next: ^types.Tree_Node) -> rawptr ---

	// Destroys a tree
	tree_destroy :: proc(t: ^types.Tree_Node) ---

	// Applies enu(opaque, &elem) to all the elements in the tree in a given range
	tree_enumerate :: proc(t: ^types.Tree_Node, opaque: rawptr, cmp: proc(rawptr, rawptr) -> i32, enu: proc(rawptr, rawptr) -> i32) ---

	//===twofish.h===
	// Allocates an AVTWOFISH context
	twofish_alloc :: proc() -> ^types.TWOFISH ---

	// Initializes an AVTWOFISH context
	twofish_init :: proc(ctx: ^types.TWOFISH, key: [16]u8, key_bits: i32) -> i32 ---

	// Encrypts or decrypts a buffer using a previously initialized context
	twofish_crypt :: proc(ctx: ^types.TWOFISH, dst: [^]u8, src: [^]u8, count: i32, iv: [^]u8, decrypt: b32) ---


	//===tx.h===
	// Initializes a transform context with the given configuration
	tx_init :: proc(ctx: ^^types.TX_Context, tx: ^types.tx_fn, type: types.TX_Type, inv: i32, len: i32, scale: rawptr, flags: types.TX_Flags) -> i32 ---

	// Frees a context and sets ctx to NULL, does nothing when ctx == NULL
	tx_uninit :: proc(ctx: ^^types.TX_Context) ---


	//===uuid.h===
	uuid_parse :: proc(str_in:cstring, uu:types.UUID)-> i32 ---
	uuid_urn_parse :: proc(str_in:cstring, uu:types.UUID)-> i32 ---
	uuid_parse_range :: proc(in_start:cstring, in_end:^byte, uu:types.UUID)-> i32 ---
	uuid_unparse :: proc(uu:types.UUID,out:cstring) ---

	//===video_enc_params.h===
	// Allocates memory for AVVideo_Enc_Params of the given type, plus an array of
	video_enc_params_alloc :: proc(type: types.Video_Enc_Params_Type, nb_blocks: u32, out_size: ^uintptr) -> ^types.Video_Enc_Params ---

	// Allocates memory for AVEncodeInfoFrame plus an array of
	video_enc_params_create_side_data :: proc(frame: ^types.Frame, type: types.Video_Enc_Params_Type, nb_blocks: u32) -> ^types.Video_Enc_Params ---

	//===video_hint.h===
	video_hint_alloc :: proc(nb_rects:uintptr,out_size:^uintptr)->^types.Video_Hint ---
	video_hint_create_size_data :: proc(frame:^types.Frame,nb_rects:uintptr)->^types.Video_Hint ---

	//===xtea.h===
	// Allocates an AVXTEA context
	xtea_alloc :: proc() -> ^types.XTEA ---

	// Initializes an AVXTEA context
	xtea_init :: proc(ctx: ^types.XTEA, key: [16]u8) ---

	// Initializes an AVXTEA context
	xtea_le_init :: proc(ctx: ^types.XTEA, key: [16]u8) ---

	// Encrypts or decrypts a buffer using a previously initialized context, in big endian format
	xtea_crypt :: proc(ctx: ^types.XTEA, dst: [^]u8, src: [^]u8, count: i32, iv: [^]u8, decrypt: b32) ---

	// Encrypts or decrypts a buffer using a previously initialized context, in little endian format
	xtea_le_crypt :: proc(ctx: ^types.XTEA, dst: [^]u8, src: [^]u8, count: i32, iv: [^]u8, decrypt: b32) ---

}
/*
	av_add_i
	av_add_q
	av_add_stable
	av_adler32_update
	av_aes_alloc
	av_aes_crypt
	av_aes_ctr_alloc
	av_aes_ctr_crypt
	av_aes_ctr_free
	av_aes_ctr_get_iv
	av_aes_ctr_increment_iv
	av_aes_ctr_init
	av_aes_ctr_set_full_iv
	av_aes_ctr_set_iv
	av_aes_ctr_set_random_iv
	av_aes_init
	av_aes_size
	av_append_path_component
	av_asprintf
	av_assert0_fpu
	av_audio_fifo_alloc
	av_audio_fifo_drain
	av_audio_fifo_free
	av_audio_fifo_peek
	av_audio_fifo_peek_at
	av_audio_fifo_read
	av_audio_fifo_realloc
	av_audio_fifo_reset
	av_audio_fifo_size
	av_audio_fifo_space
	av_audio_fifo_write
	av_base64_decode
	av_base64_encode
	av_basename
	av_blowfish_alloc
	av_blowfish_crypt
	av_blowfish_crypt_ecb
	av_blowfish_init
	av_bmg_get
	av_bprint_append_data
	av_bprint_channel_layout
	av_bprint_chars
	av_bprint_clear
	av_bprint_escape
	av_bprint_finalize
	av_bprint_get_buffer
	av_bprint_init
	av_bprint_init_for_buffer
	av_bprint_strftime
	av_bprintf
	av_buffer_alloc
	av_buffer_allocz
	av_buffer_create
	av_buffer_default_free
	av_buffer_get_opaque
	av_buffer_get_ref_count
	av_buffer_is_writable
	av_buffer_make_writable
	av_buffer_pool_buffer_get_opaque
	av_buffer_pool_get
	av_buffer_pool_init
	av_buffer_pool_init2
	av_buffer_pool_uninit
	av_buffer_realloc
	av_buffer_ref
	av_buffer_replace
	av_buffer_unref
	av_calloc
	av_camellia_alloc
	av_camellia_crypt
	av_camellia_init
	av_camellia_size
	av_cast5_alloc
	av_cast5_crypt
	av_cast5_crypt2
	av_cast5_init
	av_cast5_size
	av_channel_layout_extract_channel
	av_chroma_location_from_name
	av_chroma_location_name
	av_cmp_i
	av_color_primaries_from_name
	av_color_primaries_name
	av_color_range_from_name
	av_color_range_name
	av_color_space_from_name
	av_color_space_name
	av_color_transfer_from_name
	av_color_transfer_name
	av_compare_mod
	av_compare_ts
	av_content_light_metadata_alloc
	av_content_light_metadata_create_side_data
	av_cpu_count
	av_cpu_max_align
	av_crc
	av_crc_get_table
	av_crc_init
	av_d2q
	av_d2str
	av_default_get_category
	av_default_item_name
	av_des_alloc
	av_des_crypt
	av_des_init
	av_des_mac
	av_dict_copy
	av_dict_count
	av_dict_free
	av_dict_get
	av_dict_get_string
	av_dict_parse_string
	av_dict_set
	av_dict_set_int
	av_dirname
	av_display_matrix_flip
	av_display_rotation_get
	av_display_rotation_set
	av_div_i
	av_div_q
	av_dovi_alloc
	av_downmix_info_update_side_data
	av_dynamic_hdr_plus_alloc
	av_dynamic_hdr_plus_create_side_data
	av_dynarray2_add
	av_dynarray_add
	av_dynarray_add_nofree
	av_encryption_info_add_side_data
	av_encryption_info_alloc
	av_encryption_info_clone
	av_encryption_info_free
	av_encryption_info_get_side_data
	av_encryption_init_info_add_side_data
	av_encryption_init_info_alloc
	av_encryption_init_info_free
	av_encryption_init_info_get_side_data
	av_escape
	av_expr_count_func
	av_expr_count_vars
	av_expr_eval
	av_expr_free
	av_expr_parse
	av_expr_parse_and_eval
	av_fast_malloc
	av_fast_mallocz
	av_fast_realloc
	av_fifo_alloc
	av_fifo_alloc_array
	av_fifo_drain
	av_fifo_free
	av_fifo_freep
	av_fifo_generic_peek
	av_fifo_generic_peek_at
	av_fifo_generic_read
	av_fifo_generic_write
	av_fifo_grow
	av_fifo_realloc2
	av_fifo_reset
	av_fifo_size
	av_fifo_space
	av_file_map
	av_file_unmap
	av_film_grain_params_alloc
	av_film_grain_params_create_side_data
	av_find_best_pix_fmt_of_2
	av_find_info_tag
	av_find_nearest_q_idx
	av_fopen_utf8
	av_force_cpu_flags
	av_fourcc_make_string
	av_frame_alloc
	av_frame_apply_cropping
	av_frame_clone
	av_frame_copy
	av_frame_copy_props
	av_frame_free
	av_frame_get_best_effort_timestamp
	av_frame_get_buffer
	av_frame_get_channel_layout
	av_frame_get_channels
	av_frame_get_color_range
	av_frame_get_colorspace
	av_frame_get_decode_error_flags
	av_frame_get_metadata
	av_frame_get_pkt_duration
	av_frame_get_pkt_pos
	av_frame_get_pkt_size
	av_frame_get_plane_buffer
	av_frame_get_qp_table
	av_frame_get_sample_rate
	av_frame_get_side_data
	av_frame_is_writable
	av_frame_make_writable
	av_frame_move_ref
	av_frame_new_side_data
	av_frame_new_side_data_from_buf
	av_frame_ref
	av_frame_remove_side_data
	av_frame_set_best_effort_timestamp
	av_frame_set_channel_layout
	av_frame_set_channels
	av_frame_set_color_range
	av_frame_set_colorspace
	av_frame_set_decode_error_flags
	av_frame_set_metadata
	av_frame_set_pkt_duration
	av_frame_set_pkt_pos
	av_frame_set_pkt_size
	av_frame_set_qp_table
	av_frame_set_sample_rate
	av_frame_side_data_name
	av_frame_unref
	av_free
	av_freep
	av_gcd
	av_gcd_q
	av_get_alt_sample_fmt
	av_get_bits_per_pixel
	av_get_bytes_per_sample
	av_get_channel_description
	av_get_channel_layout
	av_get_channel_layout_channel_index
	av_get_channel_layout_nb_channels
	av_get_channel_layout_string
	av_get_channel_name
	av_get_colorspace_name
	av_get_cpu_flags
	av_get_default_channel_layout
	av_get_extended_channel_layout
	av_get_known_color_name
	av_get_media_type_string
	av_get_packed_sample_fmt
	av_get_padded_bits_per_pixel
	av_get_picture_type_char
	av_get_pix_fmt
	av_get_pix_fmt_loss
	av_get_pix_fmt_name
	av_get_pix_fmt_string
	av_get_planar_sample_fmt
	av_get_random_seed
	av_get_sample_fmt
	av_get_sample_fmt_name
	av_get_sample_fmt_string
	av_get_standard_channel_layout
	av_get_time_base_q
	av_get_token
	av_gettime
	av_gettime_relative
	av_gettime_relative_is_monotonic
	av_hash_alloc
	av_hash_final
	av_hash_final_b64
	av_hash_final_bin
	av_hash_final_hex
	av_hash_freep
	av_hash_get_name
	av_hash_get_size
	av_hash_init
	av_hash_names
	av_hash_update
	av_hmac_alloc
	av_hmac_calc
	av_hmac_final
	av_hmac_free
	av_hmac_init
	av_hmac_update
	av_hwdevice_ctx_alloc
	av_hwdevice_ctx_create
	av_hwdevice_ctx_create_derived
	av_hwdevice_ctx_create_derived_opts
	av_hwdevice_ctx_init
	av_hwdevice_find_type_by_name
	av_hwdevice_get_hwframe_constraints
	av_hwdevice_get_type_name
	av_hwdevice_hwconfig_alloc
	av_hwdevice_iterate_types
	av_hwframe_constraints_free
	av_hwframe_ctx_alloc
	av_hwframe_ctx_create_derived
	av_hwframe_ctx_init
	av_hwframe_get_buffer
	av_hwframe_map
	av_hwframe_transfer_data
	av_hwframe_transfer_get_formats
	av_i2int
	av_image_alloc
	av_image_check_sar
	av_image_check_size
	av_image_check_size2
	av_image_copy
	av_image_copy_plane
	av_image_copy_to_buffer
	av_image_copy_uc_from
	av_image_fill_arrays
	av_image_fill_black
	av_image_fill_linesizes
	av_image_fill_max_pixsteps
	av_image_fill_plane_sizes
	av_image_fill_pointers
	av_image_get_buffer_size
	av_image_get_linesize
	av_int2i
	av_int_list_length_for_size
	av_lfg_init
	av_lfg_init_from_data
	av_log
	av_log2
	av_log2_16bit
	av_log2_i
	av_log_default_callback
	av_log_format_line
	av_log_format_line2
	av_log_get_flags
	av_log_get_level
	av_log_once
	av_log_set_callback
	av_log_set_flags
	av_log_set_level
	av_lzo1x_decode
	av_malloc
	av_malloc_array
	av_mallocz
	av_mallocz_array
	av_mastering_display_metadata_alloc
	av_mastering_display_metadata_create_side_data
	av_match_list
	av_match_name
	av_max_alloc
	av_md5_alloc
	av_md5_final
	av_md5_init
	av_md5_size
	av_md5_sum
	av_md5_update
	av_memcpy_backptr
	av_memdup
	av_mod_i
	av_mul_i
	av_mul_q
	av_murmur3_alloc
	av_murmur3_final
	av_murmur3_init
	av_murmur3_init_seeded
	av_murmur3_update
	av_nearer_q
	av_opt_child_class_iterate
	av_opt_child_class_next
	av_opt_child_next
	av_opt_copy
	av_opt_eval_double
	av_opt_eval_flags
	av_opt_eval_float
	av_opt_eval_int
	av_opt_eval_i64
	av_opt_eval_q
	av_opt_find
	av_opt_find2
	av_opt_flag_is_set
	av_opt_free
	av_opt_freep_ranges
	av_opt_get
	av_opt_get_channel_layout
	av_opt_get_dict_val
	av_opt_get_double
	av_opt_get_image_size
	av_opt_get_int
	av_opt_get_key_value
	av_opt_get_pixel_fmt
	av_opt_get_q
	av_opt_get_sample_fmt
	av_opt_get_video_rate
	av_opt_is_set_to_default
	av_opt_is_set_to_default_by_name
	av_opt_next
	av_opt_ptr
	av_opt_query_ranges
	av_opt_query_ranges_default
	av_opt_serialize
	av_opt_set
	av_opt_set_bin
	av_opt_set_channel_layout
	av_opt_set_defaults
	av_opt_set_defaults2
	av_opt_set_dict
	av_opt_set_dict2
	av_opt_set_dict_val
	av_opt_set_double
	av_opt_set_from_string
	av_opt_set_image_size
	av_opt_set_int
	av_opt_set_pixel_fmt
	av_opt_set_q
	av_opt_set_sample_fmt
	av_opt_set_video_rate
	av_opt_show2
	av_parse_color
	av_parse_cpu_caps
	av_parse_cpu_flags
	av_parse_ratio
	av_parse_time
	av_parse_video_rate
	av_parse_video_size
	av_pix_fmt_count_planes
	av_pix_fmt_desc_get
	av_pix_fmt_desc_get_id
	av_pix_fmt_desc_next
	av_pix_fmt_get_chroma_sub_sample
	av_pix_fmt_swap_endianness
	av_pixelutils_get_sad_fn
	av_q2intfloat
	av_rc4_alloc
	av_rc4_crypt
	av_rc4_init
	av_read_image_line
	av_read_image_line2
	av_realloc
	av_realloc_array
	av_realloc_f
	av_reallocp
	av_reallocp_array
	av_reduce
	av_rescale
	av_rescale_delta
	av_rescale_q
	av_rescale_q_rnd
	av_rescale_rnd
	av_ripemd_alloc
	av_ripemd_final
	av_ripemd_init
	av_ripemd_size
	av_ripemd_update
	av_sample_fmt_is_planar
	av_samples_alloc
	av_samples_alloc_array_and_samples
	av_samples_copy
	av_samples_fill_arrays
	av_samples_get_buffer_size
	av_samples_set_silence
	av_set_cpu_flags_mask
	av_set_options_string
	av_sha512_alloc
	av_sha512_final
	av_sha512_init
	av_sha512_size
	av_sha512_update
	av_sha_alloc
	av_sha_final
	av_sha_init
	av_sha_size
	av_sha_update
	av_shr_i
	av_small_strptime
	av_spherical_alloc
	av_spherical_from_name
	av_spherical_projection_name
	av_spherical_tile_bounds
	av_sscanf
	av_stereo3d_alloc
	av_stereo3d_create_side_data
	av_stereo3d_from_name
	av_stereo3d_type_name
	av_strcasecmp
	av_strdup
	av_strerror
	av_strireplace
	av_stristart
	av_stristr
	av_strlcat
	av_strlcatf
	av_strlcpy
	av_strncasecmp
	av_strndup
	av_strnstr
	av_strstart
	av_strtod
	av_strtok
	av_sub_i
	av_sub_q
	av_tea_alloc
	av_tea_crypt
	av_tea_init
	av_tea_size
	av_tempfile
	av_thread_message_flush
	av_thread_message_queue_alloc
	av_thread_message_queue_free
	av_thread_message_queue_nb_elems
	av_thread_message_queue_recv
	av_thread_message_queue_send
	av_thread_message_queue_set_err_recv
	av_thread_message_queue_set_err_send
	av_thread_message_queue_set_free_func
	av_timecode_adjust_ntsc_framenum2
	av_timecode_check_frame_rate
	av_timecode_get_smpte
	av_timecode_get_smpte_from_framenum
	av_timecode_init
	av_timecode_init_from_components
	av_timecode_init_from_string
	av_timecode_make_mpeg_tc_string
	av_timecode_make_smpte_tc_string
	av_timecode_make_smpte_tc_string2
	av_timecode_make_string
	av_timegm
	av_tree_destroy
	av_tree_enumerate
	av_tree_find
	av_tree_insert
	av_tree_node_alloc
	av_tree_node_size
	av_twofish_alloc
	av_twofish_crypt
	av_twofish_init
	av_twofish_size
	av_tx_init
	av_tx_uninit
	av_usleep
	av_utf8_decode
	av_vbprintf
	av_version_info
	av_video_enc_params_alloc
	av_video_enc_params_create_side_data
	av_vk_frame_alloc
	av_vkfmt_from_pixfmt
	av_vlog
	av_write_image_line
	av_write_image_line2
	av_xtea_alloc
	av_xtea_crypt
	av_xtea_init
	av_xtea_le_crypt
	av_xtea_le_init
	avpriv_alloc_fixed_dsp
	avpriv_cga_font
	avpriv_dict_set_timestamp
	avpriv_float_dsp_alloc
	avpriv_get_gamma_from_trc
	avpriv_get_trc_function_from_trc
	avpriv_init_lls
	avpriv_open
	avpriv_report_missing_feature
	avpriv_request_sample
	avpriv_scalarproduct_float_c
	avpriv_set_systematic_pal2
	avpriv_slicethread_create
	avpriv_slicethread_execute
	avpriv_slicethread_free
	avpriv_solve_lls
	avpriv_tempfile
	avpriv_vga16_font
*/