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

	cards: LINKED_LIST [CARD_COMPONENT]

	x, y: INTEGER

	context: CONTEXT

	highlight: BOOLEAN assign set_highlight

	set_highlight (a_highlight: BOOLEAN)
		do
			highlight := a_highlight
		end

	extend (card: CARD_COMPONENT)
		do
			cards.extend (card)
			card.set_xy (x, y + (cards.count - 1) * Offset)
		end

	last_card: CARD_COMPONENT
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

	Offset: INTEGER = 75

	Width: INTEGER
		once
			Result := {CARD_COMPONENT}.width
		ensure
			class
		end

	Height: INTEGER
		do
			if cards.is_empty then
				Result := 0
			else
				Result := Offset * (cards.count - 1) + {CARD_COMPONENT}.height
			end
		end

	has_point (a_x, a_y: INTEGER): BOOLEAN
		do
			Result := x <= a_x and a_x <= (x + width) and y <= a_y and a_y <= (y + height)
		ensure
			Result = across cards is card some card.has_point (a_x, a_y) end
		end

	draw
		do
			across
				cards is c
			loop
				c.draw
			end
			if highlight then
				invert_area (last_card.x, last_card.y, last_card.width, last_card.height)
			end
		end

end
