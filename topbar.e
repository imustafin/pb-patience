class
	TOPBAR

inherit

	IV_COMPONENT
		redefine
			draw,
			set_wh,
			do_on_pointer_down
		end

	COLORS

	INKVIEW_FUNCTIONS_API

create
	make

feature

	make (a_x, a_y: INTEGER; a_title: STRING_32; a_menu: ICONTEXT_MENU_S_STRUCT_API)
		do
			x := a_x
			y := a_y
			title := a_title
			cmenu := a_menu
		end

	title: STRING_32 assign set_title

	set_title (a_title: STRING_32)
		do
			title := a_title
		end

	is_layout_fresh: BOOLEAN = True

	Align_center: INTEGER = 2

	Valign_middle: INTEGER = 32

	draw
		do
			if attached title_font as f then
				set_font (f, Black)
				{IV_UTILS}.draw_text_rect (x + menu_width, y, width - 2 * menu_width, height, title, Align_center | Valign_middle)
			end
			if attached menu_font as f then
				set_font (f, Black)
				{IV_UTILS}.draw_text_rect (x + width - menu_width, y, menu_width, height, {STRING_32} "≡", Align_center | Valign_middle)
			end
			draw_line (x + width - menu_width, y + height, x + width - menu_width, y, Black)
			draw_line (x, y + height, x + width, y + height, Black)
		end

	menu_width: INTEGER

	set_wh (a_width, a_height: INTEGER)
		do
				-- Assuming `height` much less than `width`
			menu_width := a_height
			Precursor (a_width, a_height)
		end

	do_on_pointer_down (a_x, a_y: INTEGER): BOOLEAN
		do
			if a_x >= x + width - menu_width then
				on_menu_tap
				Result := True
			end
		end

	on_menu_tap
		local
			pos_menu: IRECT_S_STRUCT_API
		do
			create pos_menu.make_by_pointer (cmenu.pos_menu)
			pos_menu.set_x (x + width)
			pos_menu.set_y (y + height)
			open_context_menu (cmenu)
		end

	cmenu: ICONTEXT_MENU_S_STRUCT_API

feature {NONE}

	title_font: detachable IFONT_S_STRUCT_API
		once
			Result := {IV_UTILS}.open_font ("LiberationSans", 42, True)
		ensure
			class
		end

	menu_font: detachable IFONT_S_STRUCT_API
		once
			Result := {IV_UTILS}.open_font ("LiberationSans", 12, True)
		ensure
			class
		end

end
