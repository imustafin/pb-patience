class
	MAIN_HANDLER

inherit

	INKVIEW_FUNCTIONS_API

	PANEL_FLAGS_ENUM_API

	INKVIEW_EVT

create
	init

feature {NONE}

	init
		local
			deck: ARRAY [CARD_COMPONENT]
		do
			create all_holders.make
			deck := {CARD_COMPONENT}.new_deck
			shuffle_deck (deck)
			deal_to_tableau (deck)
			create_free_cells
			create_home_cells
			clear_screen
			set_orientation (1)
			set_panel_type (Panel_disabled)
			draw_game
			full_update
		end

feature

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

	deal_to_tableau (deck: ARRAY [CARD_COMPONENT])
		local
			column: COLUMN_COMPONENT
			d: INTEGER
			col_len: INTEGER
		do
			d := 1
			across
				1 |..| 8 is i
			loop
				create column.make (col_x (i), {CARD_COMPONENT}.height + 50)
				all_holders.extend (column)
				if i <= 4 then
					col_len := 7
				else
					col_len := 6
				end
				across
					1 |..| col_len is j
				loop
					column.extend_deal (deck [d])
					d := d + 1
				end
			end
		end

	create_free_cells
		do
			across
				1 |..| 4 is i
			loop
				all_holders.extend (create {FREE_CELL_COMPONENT}.make (col_x (i + 4) + 25, 25))
			end
		end

	create_home_cells
		do
			across
				1 |..| 4 is i
			loop
				all_holders.extend (create {HOME_CELL_COMPONENT}.make (col_x (i) - 25, 25))
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

	shuffle_deck (deck: ARRAY [CARD_COMPONENT])
		local
			j: INTEGER
			r: RANDOM
			t: CARD_COMPONENT
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

	card_font: detachable IFONT_S_STRUCT_API
		local
			p: POINTER
		once
			p := open_font ((create {C_STRING}.make ("LiberationSans")).item, 42, 1)
			if not p.is_default_pointer then
				create Result.make_by_pointer (p)
			end
		ensure
			class
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
				all_holders is holder
			loop
				holder.draw
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
