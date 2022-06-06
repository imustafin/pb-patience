class
	SPIDER_GAME

inherit

	GAME
		undefine
			set_xy,
			set_wh,
			do_on_pointer_down,
			do_on_pointer_up,
			layout,
			draw
		end

	IV_LINEAR_BOX
		redefine
			set_wh,
			do_on_pointer_up
		end

	INKVIEW_FUNCTIONS_API

	COLORS

create
	make_with_seed

feature {NONE}

	tableau: IV_LINEAR_BOX

	columns: LINKED_LIST [SPIDER_COLUMN]

	make_with_seed (a_seed: INTEGER)
		local
			col: SPIDER_COLUMN
			cards: ARRAY [CARD_COMPONENT]
			n: INTEGER
		do
			title := "Spider #" + a_seed.out

				-- Components
			make_vertical (0, 0, 0, 0)
			set_align_center
			create tableau.make_horizontal (0, 0, 0, 0)
			tableau.set_space_evenly

				-- Deal cards
			create columns.make
			cards := new_deck (a_seed)
			across
				1 |..| 10 is i
			loop
				create col.make
				columns.extend (col)
				tableau.extend (col)
				register_callbacks (col)
			end
				-- Deal cards
			n := 1
			across
				cards.subarray (1, 44) is card
			loop
				columns.i_th (n).extend (card)
				n := n + 1
				if n > 10 then
					n := 1
				end
			end
			extend (tableau)
		end

	new_deck (a_seed: INTEGER): ARRAY [CARD_COMPONENT]
		local
			a, b: ARRAY [CARD_COMPONENT]
		do
			a := {CARD_COMPONENT}.new_deck
			b := {CARD_COMPONENT}.new_deck
			create Result.make_filled (create {CARD_COMPONENT}.make (1, 1), 1, a.count * 2)
			across
				1 |..| a.count is i
			loop
				Result [i] := a [i]
			end
			across
				1 |..| b.count is i
			loop
				Result [a.count + i] := b [i]
			end
			{UTILS}.shuffle_deck (Result, a_seed)
		end

feature

	active_column: detachable SPIDER_COLUMN

	active_index: INTEGER

	register_callbacks (a_column: SPIDER_COLUMN)
		do
				-- Column pointer down
			a_column.set_on_pointer_down (agent  (c: SPIDER_COLUMN; a_x, a_y: INTEGER): BOOLEAN
				local
					i: INTEGER
				do
					i := c.movable_stack_at (a_x, a_y)
					if i /= 0 then
						active_column := c
						active_index := i
						c.highlight_from := i
						c.draw
						soft_update
						c.highlight_from := 0
					end
					Result := True
				end (a_column, ?, ?))

				-- Column pointer up
			a_column.set_on_pointer_up (agent  (c: SPIDER_COLUMN; a_x, a_y: INTEGER): BOOLEAN
				do
					if attached active_column as ac and then (ac /= c and c.is_valid_card (ac.i_th (active_index))) then
						ac.transfer_to (active_index, c)
						c.layout
						ac.draw
						c.draw
						soft_update
						active_column := Void
					end
					Result := True
				end (a_column, ?, ?))
		end

	do_on_pointer_up (a_x, a_y: INTEGER_32): BOOLEAN
		do
			Precursor {IV_LINEAR_BOX} (a_x, a_y).do_nothing
			if attached active_column as ac then
				ac.draw
				soft_update
				active_column := Void
				Result := True
			end
		end

feature

	set_wh (a_width, a_height: INTEGER)
		do
			tableau.set_wh (a_width, a_height)
			tableau.propagate_height
			Precursor {IV_LINEAR_BOX} (a_width, a_height)
		end

feature

	title: STRING_32

	new_with_seed (a_seed: INTEGER): SPIDER_GAME
		do
			create Result.make_with_seed (a_seed)
		end

end
