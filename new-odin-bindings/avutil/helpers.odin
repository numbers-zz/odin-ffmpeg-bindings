package ffmpeg_avutil

import "core:fmt"
import "ffmpeg:types"


q2d :: proc(r:types.Rational)->f64{
	return cast(f64)r.numerator/cast(f64)r.denominator
}

errbytes_to_int :: proc(bytes:[4]byte)->i32{
	return -transmute(i32)[4]byte{bytes[3],bytes[2],bytes[1],bytes[0]}
}
av_error :: proc(err_code:i32)->types.AVError {
	/*
	handle conversion from AVERROR codes to enum.
	in C this is done through macros, so the code can be written more readably compared to the raw int.
	here we can't do the compile-time bit-wrangling (I think?), so we do it at runtime.
	integer codes could be written in for the enum directly, but this is error-prone for transcribing.
	If we can reliably generate all error codes, we could switch to hardcoding this safely.
	*/
	if err_code == 0 {
		return nil
	}
	err_enum:types.AVError
	switch err_code {
		case errbytes_to_int({0xF8,'B','S','F'}):
			err_enum = types.AVError.BSF_NOT_FOUND  
		case errbytes_to_int({'B','U','G','!'}):
			err_enum = types.AVError.BUG
		case errbytes_to_int({'B','U','F','S'}):
			err_enum = types.AVError.BUFFER_TOO_SMALL
		case errbytes_to_int({0xF8,'D','E','C'}):
			err_enum = types.AVError.DECODER_NOT_FOUND  
		case errbytes_to_int({0xF8,'D','E','M'}):
			err_enum = types.AVError.DEMUXER_NOT_FOUND
		case errbytes_to_int({0xF8,'E','N','C'}):
			err_enum = types.AVError.ENCODER_NOT_FOUND
		case errbytes_to_int({ 'E','O','F',' '}):
			err_enum = types.AVError.EOF  
		case errbytes_to_int({'E','X','I','T'}):
			err_enum = types.AVError.EXIT
		case errbytes_to_int({ 'E','X','T',' '}):
			err_enum = types.AVError.EXTERNAL
		case errbytes_to_int({0xF8,'F','I','L'}):
			err_enum = types.AVError.FILTER_NOT_FOUND  
		case errbytes_to_int({'I','N','D','A'}):
			err_enum = types.AVError.INVALIDDATA
		case errbytes_to_int({0xF8,'M','U','X'}):
			err_enum = types.AVError.MUXER_NOT_FOUND
		case errbytes_to_int({0xF8,'O','P','T'}):
			err_enum = types.AVError.OPTION_NOT_FOUND  
		case errbytes_to_int({'P','A','W','E'}):
			err_enum = types.AVError.PATCHWELCOME
		case errbytes_to_int({0xF8,'P','R','O'}):
			err_enum = types.AVError.PROTOCOL_NOT_FOUND
		case errbytes_to_int({0xF8,'S','T','R'}):
			err_enum = types.AVError.STREAM_NOT_FOUND  
		case errbytes_to_int({'B','U','G',' '}):
			err_enum = types.AVError.BUG2
		case errbytes_to_int({ 'U','N','K','N'}):
			err_enum = types.AVError.UNKNOWN

		case -0x2bb2afa8:
			err_enum = types.AVError.EXPERIMENTAL
		case -0x636e6701:
			err_enum = types.AVError.INPUT_CHANGED  
		case -0x636e6702:
			err_enum = types.AVError.OUTPUT_CHANGED
		case errbytes_to_int({0xF8,'4','0','0'}):
			err_enum = types.AVError.HTTP_BAD_REQUEST
		case errbytes_to_int({0xF8,'4','0','1'}):
			err_enum = types.AVError.HTTP_UNAUTHORIZED  
		case errbytes_to_int({0xF8,'4','0','3'}):
			err_enum = types.AVError.HTTP_FORBIDDEN
		case errbytes_to_int({0xF8,'4','0','4'}):
			err_enum = types.AVError.HTTP_NOT_FOUND
		case errbytes_to_int({0xF8,'4','X','X'}):
			err_enum = types.AVError.HTTP_OTHER_4XX
		case errbytes_to_int({0xF8,'5','X','X'}):
			err_enum = types.AVError.HTTP_SERVER_ERROR

        //not in AVERROR enum for some reason, but still FFMPEG error codes.
        case -11:
            err_enum = types.AVError.EAGAIN
        case -12:
            err_enum = types.AVError.ENOMEM
        case -22:
            err_enum = types.AVError.EINVAL
	}
    //this shouldn't be an assert, we may want to pass through underlying codec errors.
	assert(err_enum!=nil,fmt.aprintf("Unrecognized Error Code: %d",err_code))
	return err_enum
}