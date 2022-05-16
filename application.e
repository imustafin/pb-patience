note
	description: "pb-patience application root class"
	date: "$Date$"
	revision: "$Revision$"

class
	APPLICATION

inherit

	ARGUMENTS_32

	INKVIEW_EVT

	INKVIEW_FUNCTIONS_API

	PANEL_FLAGS_ENUM_API

create
	make

feature {NONE} -- Initialization

	deck: ARRAY [CARD]

	make
			-- Run application.
		local
			main_handler_dispatcher: IV_HANDLER_DISPATCHER
		do
				--| Add your code here
			print ("Hello Eiffel World!%N")
			deck := {CARD}.new_deck
			shuffle_deck
			create main_handler_dispatcher.make
			main_handler_dispatcher.register_callback_1 (agent main)
			ink_view_main (main_handler_dispatcher.c_dispatcher_1)
		end

	shuffle_deck
		local
			j: INTEGER
			r: RANDOM
			t: CARD
		do
			create r.make
			across
				1 |..| deck.count is c
			loop
				j := r.item \\ c + 1
				t := deck [c]
				deck [c] := deck [j]
				deck [j] := t
			end
		ensure
			deck.count = (old deck).count and across (old deck) is d all deck.has (d) end
		end

	font: detachable IFONT_S_STRUCT_API

	liberation_sans
		local
			p: POINTER
			c_name: C_STRING
			cc: C_STRING
			f: like font
		do
			create c_name.make ("LiberationSans")
			p := open_font (c_name.item, 38, 1)
			if not p.is_default_pointer then
				create f.make_by_pointer (p)
				set_font (f, 0)
				font := f
			else
				draw_text_rect (200, 200, 200, 200, (create {C_STRING}.make ("NULL open font")).item, 0).do_nothing
			end
		end

	main (type, x, y: INTEGER): INTEGER
		do
			inspect type
			when Evt_init then
				clear_screen
				set_orientation (1)
				set_panel_type (Panel_enabled)
				liberation_sans
				draw_panel_no_icon ("", "", 0)
				draw_deck
				full_update
			when Evt_keypress then
				close_app
			else
			end
		end

feature

	draw_panel_no_icon (text, title: STRING; percent: INTEGER)
		local
			c_text: C_STRING
			c_title: C_STRING
		do
			create c_text.make (text)
			create c_title.make (title)
			c_draw_panel (Default_pointer, c_text.item, c_title.item, percent).do_nothing
		end

	inner_height: INTEGER
		do
			Result := screen_height - panel_height
		end

	draw_deck
		local
			x, y: INTEGER
		do
			x := 1
			y := 1
			across
				1 |..| deck.count is i
			loop
				draw_card (deck [i], x * 100, y * 100)
				x := x + 1
				if x >= 8 then
					x := 1
					y := y + 1
				end
			end
		end

	draw_card (c: CARD; x, y: INTEGER)
		local
			c_str: C_STRING
		do
			create c_str.make ({UTF_CONVERTER}.string_32_to_utf_8_string_8 (c.out_32))
			if attached font as f then
				if c.suit_is_red then
					set_font(f, 0x00666666)
				else
					set_font(f, 0x00000000)
				end
			end
			draw_text_rect (x, y, 100, 100, c_str.item, 0).do_nothing
		end

end
