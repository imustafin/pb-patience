class
	DECK_IMAGE

inherit

	INKVIEW_FUNCTIONS_API

	COLORS

	IV_COMPONENT
		undefine
			do_on_pointer_down,
			do_on_pointer_up
		redefine
			draw
		end

	IV_WITH_ACTIONS

create
	make

feature

	make (a_cards: ITERABLE [CARD_COMPONENT])
		do
			create cards.make_from_iterable (a_cards)
			width := {CARD_COMPONENT}.const_width
			height := {CARD_COMPONENT}.const_height
		end

feature

	is_layout_fresh: BOOLEAN = True

	cards: LINKED_LIST [CARD_COMPONENT]

feature

	draw
		local
			card: CARD_COMPONENT
		do
			fill_area (x, y, width, height, White)
			if cards.is_empty then
					-- Leave white space
			else
				create card.make (1, 1)
				card.flip_face_down
				card.set_xy (x, y)
				card.draw
			end
		end

invariant
	width = {CARD_COMPONENT}.const_width
	height = {CARD_COMPONENT}.const_height

end
