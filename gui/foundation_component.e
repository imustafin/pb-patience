class
	FOUNDATION_COMPONENT

inherit

	INKVIEW_FUNCTIONS_API

create
	make

feature

	make (a_x, a_y: INTEGER; a_context: CONTEXT)
		do
			create cards.make
			x := a_x
			y := a_y
			context := a_context
		end

	cards: LINKED_LIST [CARD]

	x, y: INTEGER

	context: CONTEXT

	add_card(card: CARD)
		do
			cards.extend (card)
		end

	top_card: CARD
		do
			Result := cards.last
		end

	remove
		require
			not cards.is_empty
		do
			cards.finish
			cards.remove
		end

	draw
		local
			yy: INTEGER
		do
			yy := y
			across
				cards is c
			loop
				{CARD_COMPONENT}.draw (c, x, yy, context)
				yy := yy + 100
			end

		end

end
