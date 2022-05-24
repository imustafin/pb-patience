class
	FREE_CELL_GAME

inherit

	INKVIEW_FUNCTIONS_API

	IV_LINEAR_BOX
		rename
			make as iv_linear_box_make
		redefine
			do_on_pointer_up,
			set_wh
		end

create
	make

feature {NONE}

	deal_number: INTEGER

	top_space: IV_SPACE

	top_row: IV_LINEAR_BOX

	top_tableau_space: IV_SPACE

	tableau: FREE_CELL_TABLEAU

	make (a_x, a_y, a_deal_number: INTEGER)
		local
			deck: ARRAY [CARD_COMPONENT]
		do
			deal_number := a_deal_number

				-- Components
			make_vertical (a_x, a_y, 0, 0)
			set_align_center
			create top_space.make (0, 0)
			create top_row.make_horizontal (0, 0, 0, 0)
			top_row.set_space_evenly
			create tableau.make
			tableau.set_space_evenly
			create top_tableau_space.make (0, 0)
			extend (top_space)
			extend (top_row)
			extend (top_tableau_space) -- Space between top row and tableau
			extend (tableau)

				-- Top row with cells
			top_row.append (new_home_cells)
			top_row.extend (create {IV_SPACE}.make (60, 0))
			top_row.append (new_free_cells)

				-- Tableau
			deck := {CARD_COMPONENT}.new_deck
			shuffle_deck (deck)
			tableau.append (make_columns_with_cards_dealt (deck, tableau.height))
		end

	new_home_cells: LINKED_LIST [IV_COMPONENT]
		local
			home_cell: HOME_CELL_COMPONENT
		do
			create Result.make
			across
				1 |..| 4 is i
			loop
				create home_cell.make
				add_holder (home_cell)
				Result.extend (home_cell)
			end
		end

	shuffle_deck (deck: ARRAY [CARD_COMPONENT])
		local
			j: INTEGER
			r: RANDOM
			t: CARD_COMPONENT
		do
			create r.set_seed (deal_number)
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

	make_columns_with_cards_dealt (deck: ARRAY [CARD_COMPONENT]; a_height: INTEGER): LINKED_LIST [COLUMN_COMPONENT]
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
				create column.make (a_height)
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
				create free_cell.make
				add_holder (free_cell)
				Result.extend (free_cell)
			end
		end

	add_holder (a_holder: CARD_HOLDER)
		do
			add_holder_on_pointer_down (a_holder)
			add_holder_on_pointer_up (a_holder)
		end

	add_holder_on_pointer_down (a_holder: CARD_HOLDER)
		do
			a_holder.set_on_pointer_down (agent  (h: CARD_HOLDER; a_x, a_y: INTEGER): BOOLEAN
				do
					if not h.is_empty and then h.is_pick_xy (a_x, a_y) then
						h.highlight := True
						h.draw
						soft_update
						active_holder := h
						Result := True
					end
				end (a_holder, ?, ?))
		end

	add_holder_on_pointer_up (a_holder: CARD_HOLDER)
		do
			a_holder.set_on_pointer_up (agent  (h: CARD_HOLDER; a_x, a_y: INTEGER): BOOLEAN
				do
					if attached active_holder as ah and then (h.is_drop_xy (a_x, a_y) and h.is_valid_item (ah.item)) then
						h.extend (ah.item)
						ah.remove
						h.draw
						Result := True
					end
				end (a_holder, ?, ?))
		end

feature

	set_wh (a_width, a_height: INTEGER)
		do
			top_space.set_wh (0, 25)
			top_row.set_wh (a_width - 100, {CARD_COMPONENT}.Const_height)
			top_tableau_space.set_wh (0, 25)
			tableau.set_wh (a_width - 200, a_height - top_space.height - top_row.height - top_tableau_space.height)
			Precursor (a_width, a_height)
		end

feature -- Events

	do_on_pointer_up (a_x, a_y: INTEGER): BOOLEAN
		do
			Result := Precursor (a_x, a_y)
			if attached active_holder as ah then
				active_holder := Void
				ah.highlight := False
				ah.draw
				soft_update
			elseif Result then
				soft_update
			end
		end

feature -- Game state

	active_holder: detachable CARD_HOLDER

end
