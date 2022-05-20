class
	COLUMN_COMPONENT

inherit

	INKVIEW_FUNCTIONS_API

	CARD_HOLDER
		rename
			is_drop_xy as has_point
		end

	COLORS

	COMPONENT

create
	make

feature {NONE}

	make (a_x, a_y: INTEGER)
		do
			create cards.make
			x := a_x
			y := a_y
		end

feature

	cards: LINKED_LIST [CARD_COMPONENT]

	x, y: INTEGER

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

	Offset: INTEGER = 60

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
		end

	draw
		do
			fill_area (x, y, width, height, White)
			across
				cards is c
			loop
				c.draw (False)
			end
			if highlight and not is_empty then
				item.draw (True)
			end
		end

	is_valid_item (card: CARD_COMPONENT): BOOLEAN
		do
			Result := is_empty or else (item.is_other_color (card) and item.is_next_rank_after (card))
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
