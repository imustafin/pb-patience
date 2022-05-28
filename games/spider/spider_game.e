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
			set_wh
		end

	INKVIEW_FUNCTIONS_API

	COLORS

create
	make_with_seed

feature {NONE}

	tableau: IV_LINEAR_BOX

	make_with_seed (a_seed: INTEGER)
		do
			title := "Spider #" + a_seed.out

				-- Components
			make_vertical (0, 0, 0, 0)
			set_align_center
			create tableau.make_horizontal (0, 0, 0, 0)
			tableau.set_space_evenly
			across
				{CARD_COMPONENT}.new_deck.subarray (1, 10) is c
			loop
				tableau.extend (c)
			end
			extend (tableau)
		end

feature

	set_wh (a_width, a_height: INTEGER)
		do
			tableau.set_wh (a_width, a_height)
			Precursor {IV_LINEAR_BOX} (a_width, a_height)
		end

feature

	title: STRING_32

	new_with_seed (a_seed: INTEGER): SPIDER_GAME
		do
			create Result.make_with_seed (a_seed)
		end

end
