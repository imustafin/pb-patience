class
	FOUNDATION_COMPONENT

inherit

	INKVIEW_FUNCTIONS_API

	CARD_HOLDER
		rename
			is_drop_xy as has_point
		end

	COLORS

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

	extend (card: CARD_COMPONENT)
		do
			extend_deal (card)
		end

	extend_deal (card: CARD_COMPONENT)
			-- Only for initial dealing
		do
			cards.extend (card)
			card.set_xy (x, y + (cards.count - 1) * Offset)
		end

	item: CARD_COMPONENT
		do
			Result := cards.last
		end

	remove
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
			Result := screen_height - y
		end

	has_point (a_x, a_y: INTEGER): BOOLEAN
		do
			Result := x <= a_x and a_x <= (x + width) and y <= a_y and a_y <= (y + height)
		ensure then
			Result = across cards is card some card.has_point (a_x, a_y) end
		end

	draw
		do
			fill_area (x, y, width, height, White)
			across
				cards is c
			loop
				c.draw
			end
			if highlight then
				item.invert
			end
		end

	is_valid_item (card: CARD_COMPONENT): BOOLEAN
		do
			Result := is_empty or else (item.is_other_color (card))
		end

	is_empty: BOOLEAN
		do
			Result := cards.is_empty
		end

	is_pick_xy (a_x, a_y: INTEGER): BOOLEAN
		do
			if is_empty then
				Result := False
			else
				Result := item.has_point (a_x, a_y)
			end
		end

end
