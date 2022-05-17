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
		local
			main_handler_dispatcher: IV_HANDLER_DISPATCHER
		do
			create context
			deck := {CARD}.new_deck
			shuffle_deck
			create main_handler_dispatcher.make
			main_handler_dispatcher.register_callback_1 (agent main)
			ink_view_main (main_handler_dispatcher.c_dispatcher_1)
		end

	context: CONTEXT

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

	liberation_sans
		local
			p: POINTER
			c_name: C_STRING
			f: IFONT_S_STRUCT_API
		do
			create c_name.make ("LiberationSans")
			p := open_font (c_name.item, 38, 1)
			if not p.is_default_pointer then
				create f.make_by_pointer (p)
				context.font := f
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
				draw_card (deck [i], 70 + (x - 1) * ({CARD_COMPONENT}.width + 20), y * 75)
				x := x + 1
				if x >= 8 then
					x := 1
					y := y + 1
				end
			end
		end

	draw_card (c: CARD; x, y: INTEGER)
		local
			cmp: CARD_COMPONENT
		do
			create cmp.make (c, x, y, context)
			cmp.draw
		end

end
