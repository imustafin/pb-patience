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
			deal_to_tableau (deck)
			create_free_cells
			create_home_cells
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

	deal_to_tableau (deck: ARRAY [CARD])
		local
			f: INTEGER
		do
			create tableau.make_filled (create {COLUMN_COMPONENT}.make (0, 0, context), 1, 8)
			across
				1 |..| 8 is ff
			loop
				tableau [ff] := create {COLUMN_COMPONENT}.make (col_x (ff), {CARD_COMPONENT}.height + 50, context)
			end
			f := 1
			across
				deck is card
			loop
				tableau [f].extend_deal (create {CARD_COMPONENT}.make (tableau [f], card))
				f := f + 1
				if f > tableau.count then
					f := 1
				end
			end
		end

	context: CONTEXT

	tableau: ARRAY [COLUMN_COMPONENT]

	free_cells: ARRAY [FREE_CELL_COMPONENT]

	home_cells: ARRAY [HOME_CELL_COMPONENT]

	create_free_cells
		do
			create free_cells.make_filled (create {FREE_CELL_COMPONENT}.make (0, 0), 1, 4)
			across
				1 |..| 4 is i
			loop
				free_cells [i] := create {FREE_CELL_COMPONENT}.make (col_x (i + 4) + 25, 25)
			end
		end

	create_home_cells
		do
			create home_cells.make_filled (create {HOME_CELL_COMPONENT}.make (0, 0), 1, 4)
			across
				1 |..| 4 is i
			loop
				home_cells [i] := create {HOME_CELL_COMPONENT}.make (col_x (i) - 25, 25)
			end
		end

	since_epoch: INTEGER
		local
			epoch, now: DATE_TIME
		do
			create epoch.make_from_epoch (0)
			create now.make_now
			Result := (now.definite_duration (epoch)).seconds_count.as_integer_32
		end

	shuffle_deck (deck: ARRAY [CARD])
		local
			j: INTEGER
			r: RANDOM
			t: CARD
		do
			create r.set_seed (since_epoch)
			across
				1 |..| deck.count is c
			loop
				r.forth
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

	all_holders: LINKED_LIST [CARD_HOLDER]
		do
			create Result.make
			across
				tableau is c
			loop
				Result.extend (c)
			end
			across
				free_cells is f
			loop
				Result.extend (f)
			end
			across
				home_cells is h
			loop
				Result.extend (h)
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
					if drop_at /= holder and drop_at.is_valid_item (holder.item) then
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
				if holder.is_drop_xy (x, y) then
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
				tableau is foundation
			loop
				foundation.draw
			end
			across
				free_cells is free_cell
			loop
				free_cell.draw
			end
			across
				home_cells is home_cell
			loop
				home_cell.draw
			end
		end

feature

	col_x (col: INTEGER): INTEGER
			-- `x` for the `col`-th column on screen
		require
			col >= 1
		do
			Result := 130 + ((col - 1) * (30 + {CARD_COMPONENT}.width))
		end

end
