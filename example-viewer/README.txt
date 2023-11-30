To run the viewer

1. copy the FFMPEG DLLs in /shared into this folder.
2. Change the fourcc codes in vendor:sdl2/sdl_pixels.odin to their correct values. In particular 

	IYUV =      /**< Planar mode: Y + U + V  (3 planes) */
		'I'<<24 | 'Y'<<16 | 'U'<<8 | 'V'<<0,

   must be changed to

	IYUV =      /**< Planar mode: Y + U + V  (3 planes) */
		'I'<<0 | 'Y'<<8 | 'U'<<16 | 'V'<<24,

   this bug report has not been fixed yet.
3. Change the file name in viewer.odin (in the open_video_file call in main) to the hardcoded path of the desired input video.
	This has not been well-tested, but the video stream in the sample file works.