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

	bottom: IV_LINEAR_BOX

	suits: INTEGER

	make_with_seed (a_suits, a_seed: INTEGER)
		local
			deck: LINKED_LIST [CARD_COMPONENT]
			col: SPIDER_COLUMN
			cards: ARRAY [CARD_COMPONENT]
			n: INTEGER
			deck_image: DECK_IMAGE
		do
			suits := a_suits
			title := "Spider #" + a_seed.out + " " + suits.out + "-suit"

				-- Components
			make_vertical (0, 0, 0, 0)
			set_align_center
			create tableau.make_horizontal (0, 0, 0, 0)
			create bottom.make_horizontal (0, 0, 0, 0)
			tableau.set_space_evenly
			create columns.make
			deck := make_deck (a_suits, a_seed)
			across
				1 |..| 10 is i
			loop
				create col.make
				columns.extend (col)
				tableau.extend (col)
				register_callbacks (col)
			end
			deal_cards (deck)
			extend (tableau)

				-- Bottom bar with fundations and deck

			bottom.set_space_evenly
			create deck_image.make (deck)
			deck_image.set_on_pointer_down (agent  (d: DECK_IMAGE; a_x, a_y: INTEGER): BOOLEAN
				local
					c: CARD_COMPONENT
				do
					if not d.cards.is_empty then
						if across columns is l_col all not l_col.is_empty end then
							d.cards.start
							across
								columns is l_col
							until
								d.cards.is_empty
							loop
								c := d.cards.item
								d.cards.remove
								c.flip_face_up
								l_col.extend (c)
								l_col.layout
							end
							draw
							soft_update
						end
					end
				end (deck_image, ?, ?))
			bottom.extend (deck_image)
			extend (bottom)
		end

	deal_cards (a_deck: LINKED_LIST [CARD_COMPONENT])
		local
			n: INTEGER
			c: CARD_COMPONENT
		do
			n := 1
			across
				1 |..| 44 is i
			loop
				a_deck.finish
				c := a_deck.item
				a_deck.remove
				columns.i_th (n).extend (c)
				if i <= 34 then
					c.flip_face_down
				end
				n := n + 1
				if n > 10 then
					n := 1
				end
			end
		end

	make_deck (a_suits, a_seed: INTEGER): LINKED_LIST [CARD_COMPONENT]
		require
			a_suits = 1 or a_suits = 2 or a_suits = 4
		local
			ar: ARRAY [CARD_COMPONENT]
			gen_suits: ARRAY [INTEGER]
			i: INTEGER
		do
			create ar.make_filled (create {CARD_COMPONENT}.make (1, 1), 1, 2 * 52)
			inspect a_suits
			when 1 then
				gen_suits := <<{CARD_COMPONENT}.Spades, {CARD_COMPONENT}.Spades, {CARD_COMPONENT}.Spades, {CARD_COMPONENT}.Spades>>
			when 2 then
				gen_suits := <<{CARD_COMPONENT}.Spades, {CARD_COMPONENT}.Spades, {CARD_COMPONENT}.Hearts, {CARD_COMPONENT}.Hearts>>
			else
				gen_suits := <<{CARD_COMPONENT}.Hearts, {CARD_COMPONENT}.Spades, {CARD_COMPONENT}.Diamonds, {CARD_COMPONENT}.Clubs>>
			end
			i := 1
			across
				gen_suits is suit
			loop
				across
					1 |..| {CARD_COMPONENT}.ranks.count is rank
				loop
						-- Add two same cards
					ar [i] := create {CARD_COMPONENT}.make (suit, rank)
					i := i + 1
					ar [i] := create {CARD_COMPONENT}.make (suit, rank)
					i := i + 1
				end
			end
			{UTILS}.shuffle_deck (ar, a_seed)
			create Result.make_from_iterable (ar)
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
			bottom.set_wh (a_width, {CARD_COMPONENT}.const_height)
			tableau.set_wh (a_width, a_height - bottom.height)
			tableau.propagate_height
			Precursor {IV_LINEAR_BOX} (a_width, a_height)
		end

feature

	title: STRING_32

	new_with_seed (a_seed: INTEGER): SPIDER_GAME
		do
			create Result.make_with_seed (suits, a_seed)
		end

end
