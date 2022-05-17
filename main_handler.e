class
	MAIN_HANDLER

inherit

	INKVIEW_FUNCTIONS_API

	PANEL_FLAGS_ENUM_API

	INKVIEW_EVT

create
	init

feature

	init
		local
			deck: ARRAY [CARD]
		do
			create context
			deck := {CARD}.new_deck
			shuffle_deck (deck)
			deal_to_foundations (deck)
			clear_screen
			set_orientation (1)
			set_panel_type (Panel_enabled)
			liberation_sans
			draw_panel_no_icon ("", "", 0)
			draw_game
			full_update
		end

	handle (type, par1, par2: INTEGER): INTEGER
		do
			inspect type
			when Evt_keypress then
				close_app
			when Evt_pointerdown then
				pointerdown (par1, par2)
			when Evt_pointerup then
				pointerup (par1, par2)
			else
			end
		end

	deal_to_foundations (deck: ARRAY [CARD])
		local
			f: INTEGER
		do
			create foundations.make_filled (create {FOUNDATION_COMPONENT}.make (0, 0, context), 1, 8)
			across
				1 |..| 8 is ff
			loop
				foundations [ff] := create {FOUNDATION_COMPONENT}.make (70 + (ff - 1) * 245, 100, context)
			end
			f := 1
			across
				deck is card
			loop
				foundations [f].add_card (card)
				f := f + 1
				if f > foundations.count then
					f := 1
				end
			end
		end

	context: CONTEXT

	foundations: ARRAY [FOUNDATION_COMPONENT]

	shuffle_deck (deck: ARRAY [CARD])
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

	active_foundation: detachable FOUNDATION_COMPONENT

	pointerdown (x, y: INTEGER)
		local
			handled: BOOLEAN
		do
			across
				foundations is foundation
			until
				handled
			loop
				if foundation.has_point (x, y) then
					foundation.highlight := True
					foundation.draw
					soft_update
					active_foundation := foundation
					handled := true
				end
			end
		end

	pointerup (x, y: INTEGER)
		do
			if attached active_foundation as f then
				f.highlight := False
				f.draw
				soft_update
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

	draw_game
		do
			across
				foundations is f
			loop
				f.draw
			end
		end

end
