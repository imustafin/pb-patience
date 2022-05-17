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
			create_homes
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

	H_offset: INTEGER = 30
			-- Horizontal offset between rows

	deal_to_foundations (deck: ARRAY [CARD])
		local
			f: INTEGER
		do
			create foundations.make_filled (create {FOUNDATION_COMPONENT}.make (0, 0, context), 1, 8)
			across
				1 |..| 8 is ff
			loop
				foundations [ff] := create {FOUNDATION_COMPONENT}.make (120 + (ff - 1) * ({FOUNDATION_COMPONENT}.width + H_offset), {CARD_COMPONENT}.height + 50, context)
			end
			f := 1
			across
				deck is card
			loop
				foundations [f].extend_deal (create {CARD_COMPONENT}.make (foundations [f], card))
				f := f + 1
				if f > foundations.count then
					f := 1
				end
			end
		end

	context: CONTEXT

	foundations: ARRAY [FOUNDATION_COMPONENT]

	homes: ARRAY [HOME_COMPONENT]

	create_homes
		do
			create homes.make_filled (create {HOME_COMPONENT}.make (0, 0), 1, 4)
			across
				1 |..| 4 is i
			loop
				homes [i] := create {HOME_COMPONENT}.make (500 + (i - 1) * ({HOME_COMPONENT}.width + H_offset), 25)
			end
		end

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

	active_holder: detachable CARD_HOLDER

	pointerdown (x, y: INTEGER)
		local
			handled: BOOLEAN
		do
			across
				all_holders is holder
			until
				handled
			loop
				if not holder.is_empty and then holder.is_pick_xy (x, y) then
					holder.highlight := True
					holder.draw
					soft_update
					active_holder := holder
					handled := true
				end
			end
		end

	all_holders: LINKED_LIST[CARD_HOLDER]
		do
			create Result.make
			across
				foundations is f
			loop
				Result.extend(f)
			end
			across
				homes is h
			loop
				Result.extend(h)
			end
		end

	pointerup (x, y: INTEGER)
		local
			c: CARD_COMPONENT
		do
			if attached active_holder as holder then
				holder.highlight := False
				active_holder := Void
				if attached drop_holder_at (x, y) as drop_at then
					if drop_at /= holder and drop_at.is_valid_item(holder.item) then
						c := holder.item
						holder.remove
						drop_at.extend (c)
						drop_at.draw
					end
				end
				holder.draw
				soft_update
			end
		end

	drop_holder_at (x, y: INTEGER): detachable CARD_HOLDER
		do
			across
				all_holders is holder
			until
				Result /= Void
			loop
				if holder.is_drop_xy(x, y) then
					Result := holder
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
				foundations is foundation
			loop
				foundation.draw
			end
			across
				homes is home
			loop
				home.draw
			end
		end

end
