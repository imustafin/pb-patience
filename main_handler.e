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
			top_row: IV_H_BOX
			tableau: IV_H_BOX
			game_stack: IV_V_BOX
		do
			create components.make
			deck := {CARD_COMPONENT}.new_deck
			shuffle_deck (deck)
			create game_stack.make (0, 0, 1872, 3000)
			game_stack.set_h_align_center
			components.extend (game_stack)

				-- Make top row with cells
			create top_row.make (0, 0, 1872 - 100, {CARD_COMPONENT}.height)
			top_row.set_space_evenly
			top_row.append (new_home_cells)
			top_row.extend (create {IV_SPACE}.make (60, 0))
			top_row.append (new_free_cells)
			game_stack.extend (top_row)

				-- Space between top row and tableau
			game_stack.extend (create {IV_SPACE}.make (0, 25))

				-- Make columns
			create tableau.make (0, 0, 1872 - 200, 2000)
			tableau.set_space_evenly
			tableau.append (make_columns_with_cards_dealt (deck))
			game_stack.extend (tableau)

				-- Components created, do screen configuration
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

	make_columns_with_cards_dealt (deck: ARRAY [CARD_COMPONENT]): LINKED_LIST [COLUMN_COMPONENT]
		local
			column: COLUMN_COMPONENT
			d: INTEGER
			col_len: INTEGER
		do
			create Result.make
			d := 1
			across
				1 |..| 8 is i
			loop
				create column.make
				add_holder (column)
				Result.extend (column)
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

	new_free_cells: LINKED_LIST [IV_COMPONENT]
		local
			free_cell: FREE_CELL_COMPONENT
		do
			create Result.make
			across
				1 |..| 4 is i
			loop
				create free_cell
				add_holder (free_cell)
				Result.extend (free_cell)
			end
		end

	add_holder (a_holder: CARD_HOLDER)
		do
			add_holder_on_pointer_down (a_holder)
			add_holder_on_pointer_up (a_holder)
		end

	new_home_cells: LINKED_LIST [IV_COMPONENT]
		local
			home_cell: HOME_CELL_COMPONENT
		do
			create Result.make
			across
				1 |..| 4 is i
			loop
				create home_cell
				add_holder (home_cell)
				Result.extend (home_cell)
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
				components is component
			until
				handled
			loop
				handled := component.do_on_pointer_down (x, y)
			end
		end

	add_holder_on_pointer_down (a_holder: CARD_HOLDER)
		do
			a_holder.set_on_pointer_down (agent  (h: CARD_HOLDER; x, y: INTEGER): BOOLEAN
				do
					if not h.is_empty and then h.is_pick_xy (x, y) then
						h.highlight := True
						h.draw
						soft_update
						active_holder := h
						Result := True
					end
				end (a_holder, ?, ?))
		end

	components: LINKED_LIST [IV_COMPONENT]

	pointerup (x, y: INTEGER)
		local
			handled: BOOLEAN
		do
			across
				components is component
			until
				handled
			loop
				handled := component.do_on_pointer_up (x, y)
			end
			if attached active_holder as ah then
				ah.highlight := False
				ah.draw
				active_holder := Void
				soft_update
			elseif handled then
				soft_update
			end
		end

	add_holder_on_pointer_up (a_holder: CARD_HOLDER)
		do
			a_holder.set_on_pointer_up (agent  (h: CARD_HOLDER; x, y: INTEGER): BOOLEAN
				do
					if attached active_holder as ah and then (h.is_drop_xy (x, y) and h.is_valid_item (ah.item)) then
						h.extend (ah.item)
						ah.remove
						h.draw
						Result := True
					end
				end (a_holder, ?, ?))
		end

feature

	draw_game
		do
			across
				components is component
			loop
				component.draw
			end
		end

end
