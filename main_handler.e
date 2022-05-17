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
			set_panel_type (Panel_disabled)
			liberation_sans
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
				foundations [ff] := create {FOUNDATION_COMPONENT}.make (120 + (ff - 1) * ({FOUNDATION_COMPONENT}.width + 30), {CARD_COMPONENT}.height + 50, context)
			end
			f := 1
			across
				deck is card
			loop
				foundations [f].extend (create {CARD_COMPONENT}.make (foundations [f], card))
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
				if not foundation.cards.is_empty and then foundation.last_card.has_point (x, y) then
					foundation.highlight := True
					foundation.draw
					soft_update
					active_foundation := foundation
					handled := true
				end
			end
		end

	pointerup (x, y: INTEGER)
		local
			c: CARD_COMPONENT
		do
			if attached active_foundation as f then
				f.highlight := False


				active_foundation := Void
				if attached foundation_at (x, y) as drop_at then
					if drop_at /= f then
						c := f.last_card
						f.remove
						drop_at.extend (c)
						clear_screen
						draw_game
					end
				end
				f.draw
				soft_update
			end
		end

	foundation_at (x, y: INTEGER): detachable FOUNDATION_COMPONENT
		do
			across
				foundations is f
			until
				Result /= Void
			loop
				if f.x <= x and x <= f.x + f.width then
					Result := f
				end
			end
		end

feature

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
