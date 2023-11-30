/*
	Odin bindings for FFmpeg's `avdevice` library.
	Bindings available under FFmpeg's license (GNU LGPL, v2.1+). See `LICENSE.md` in the package's top directory.

	Copyright (c) 2021 Jeroen van Rijn. All rights reserved.

	Libraries copyright their respective owner, available under their own licenses.
*/
package ffmpeg_avdevice

import "ffmpeg:types"

when ODIN_OS == .Windows { foreign import avdevice "avdevice.lib"       }
when ODIN_OS == .Linux { foreign import avdevice "system:libavdevice" }

/*
	`avdevice_*` functions.
*/
@(default_calling_convention="c", link_prefix="avdevice_")
foreign avdevice {
	//===avdevice.h===

	// Return the LIBAVDEVICE_VERSION_INT constant
	// major, minor, micro := version >> 16, (version >> 8) & 255, version & 255
	version :: proc() -> (version: u32) ---

	// Return the libavcodec build-time configuration.
	configuration :: proc() -> (build_time_configuration: cstring) ---

	// Return the libavcodec license.
	license :: proc() -> (license: cstring) ---

	register_all :: proc() ---

	/**
	* Send control message between application and device.
	data type depends on message type.
	* @return >= 0 on success, negative on error.
	*         AVERROR(ENOSYS) when device doesn't implement handler of the message.
	*/
	app_to_dev_control_message :: proc(s:^types.Format_Context, type:types.Dev_To_App_Message_Type, data:rawptr, data_size:uintptr)->types.AVError_Int ---
	dev_to_app_control_message :: proc(s:^types.Format_Context, type:types.Dev_To_App_Message_Type, data:rawptr, data_size:uintptr)->types.AVError_Int ---

	/**
	* List devices.
	*
	* Returns available device names and their parameters.
	*
	* @param[out] device_list list of autodetected devices.
	* @return count of autodetected devices, negative on error.
	*/
	list_devices :: proc(s:^types.Format_Context, device_list:^^types.Device_Info_List)->types.AVError_Int ---
	free_list_devices :: proc(device_list:^^types.Device_Info_List) ---
	
	/**
	* List devices.
	*
	* Returns available device names and their parameters.
	* These are convinient wrappers for avdevice_list_devices().
	* Device context is allocated and deallocated internally.
	*
	* @param device           device format. May be NULL if device name is set.
	* @param device_name      device name. May be NULL if device format is set.
	* @param device_options   An AVDictionary filled with device-private options. May be NULL.
	*                         The same options must be passed later to avformat_write_header() for output
	*                         devices or avformat_open_input() for input devices, or at any other place
	*                         that affects device-private options.
	* @param[out] device_list list of autodetected devices
	* @return count of autodetected devices, negative on error.
	* @note device argument takes precedence over device_name when both are set.
	*/
	
	list_input_sources :: proc(device:^types.Input_Format, device_name:cstring, device_options:^types.Dictionary, device_list:^^types.Device_Info_List)->types.AVError_Int ---
	list_output_sinks :: proc(device:^types.Output_Format, device_name:cstring, device_options:^types.Dictionary, device_list:^^types.Device_Info_List)->types.AVError_Int ---

}

@(default_calling_convention="c", link_prefix="av_")
foreign avdevice {
	//===avdevice.h===
	/**
	* Audio/Video input/output device iterators.
	*
	* If d is NULL, returns the first registered input audio/video device,
	* if d is non-NULL, returns the next registered input device or NULL if none left.
	*/
	input_audio_device_next :: proc(d:^types.Input_Format)->^types.Input_Format ---
	input_video_device_next :: proc(d:^types.Input_Format)->^types.Input_Format ---
	output_audio_device_next :: proc(d:^types.Output_Format)->^types.Output_Format ---
	output_video_device_next :: proc(d:^types.Output_Format)->^types.Output_Format ---
}


/*
	av_device_capabilities
	av_device_ffversion
	av_input_audio_device_next
	av_input_video_device_next
	av_output_audio_device_next
	av_output_video_device_next
	avdevice_app_to_dev_control_message
	avdevice_capabilities_create
	avdevice_capabilities_free
	avdevice_dev_to_app_control_message
	avdevice_free_list_devices
	avdevice_list_devices
	avdevice_list_input_sources
	avdevice_list_output_sinks
	avdevice_register_all
*/