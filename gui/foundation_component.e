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

	highlight: BOOLEAN assign set_highlight

	set_highlight (a_highlight: BOOLEAN)
		do
			highlight := a_highlight
		end

	add_card (card: CARD)
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

	Offset: INTEGER = 100

	Width: INTEGER = 225

	Height: INTEGER
		do
			if cards.is_empty then
				Result := 0
			else
				Result := Offset * (cards.count - 1) + {CARD_COMPONENT}.height
			end
		end

	has_point(a_x, a_y: INTEGER): BOOLEAN
		do
			Result := x <= a_x and a_x <= (x + width) and y <= a_y and a_y <= (y + height)
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
				yy := yy + Offset
			end
			if highlight then
				invert_area (x, y, width, height)
			end
		end

end
