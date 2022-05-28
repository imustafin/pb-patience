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

	INKVIEW_ITEM

create
	make

feature

	make (a_x, a_y: INTEGER; a_title: STRING_32)
		do
			x := a_x
			y := a_y
			title := a_title
			create_menu
		end

	create_menu
		do
			create menu_dispatcher.make
			create menu.make (5, {IMENU_S_STRUCT_API}.structure_size)
			check attached menu as m then
				m [1].set_type (Item_active)
				m [1].set_text (create {C_STRING}.make ("Exit"))
				m [1].set_index (I_exit)
				m [2].set_type (Item_separator)
				create cmenu.make_by_pointer (create_context_menu ((create {C_STRING}.make (cmenu_id)).item))
				cmenu.set_menu (m [1])
				cmenu.set_update_after_close (0)
			end
			menu_dispatcher.register_callback_1 (agent menu_callback)
		end

	I_exit: INTEGER = 100

	title: STRING_32

	is_layout_fresh: BOOLEAN = True

	Align_center: INTEGER = 2

	Valign_middle: INTEGER = 32

	draw
		do
			if attached title_font as f then
				set_font (f, Black)
				{IV_UTILS}.draw_text_rect (x, y, width - menu_width, height, title, Align_center | Valign_middle)
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
			cmenu.set_hproc (menu_dispatcher.c_dispatcher_1)
			open_context_menu (cmenu)
		end

	cmenu_id: STRING = "topbar_menu"

	cmenu: ICONTEXT_MENU_S_STRUCT_API

	menu: detachable MEMORY_ARRAY [IMENU_S_STRUCT_API]

	menu_dispatcher: IV_MENUHANDLER_DISPATCHER

	menu_callback (a_index: INTEGER)
		do
			inspect a_index
			when I_exit then
				close_app
			else
			end
		end

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
