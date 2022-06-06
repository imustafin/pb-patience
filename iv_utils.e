class
	IV_UTILS

inherit

	INKVIEW_FUNCTIONS_API
		rename
			draw_text_rect as draw_text_rect_raw,
			open_font as open_font_raw,
			draw_string as draw_string_raw
		export
			{NONE} open_font_raw
		end

feature

	printable_string_32_pointer (a_string: STRING_32): POINTER
		do
			Result := (create {C_STRING}.make ({UTF_CONVERTER}.string_32_to_utf_8_string_8 (a_string))).item
		ensure
			class
		end

	draw_text_rect (a_x, a_y, a_width, a_height: INTEGER; a_string: STRING_32; a_flags: INTEGER)
		do
			draw_text_rect_raw (a_x, a_y, a_width, a_height, printable_string_32_pointer (a_string), a_flags).do_nothing
		ensure
			class
		end

	draw_string (a_x, a_y: INTEGER; a_string: STRING_32)
		do
			draw_string_raw (a_x, a_y, printable_string_32_pointer (a_string))
		ensure
			class
		end

	open_font (a_name: STRING; a_size: INTEGER; a_antialiasing: BOOLEAN): detachable IFONT_S_STRUCT_API
		local
			p: POINTER
		once
			p := open_font_raw ((create {C_STRING}.make (a_name)).item, a_size, a_antialiasing.to_integer)
			if not p.is_default_pointer then
				create Result.make_by_pointer (p)
			end
		ensure
			class
		end

end
