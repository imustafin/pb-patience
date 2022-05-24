class
	COLUMN_COMPONENT

inherit

	INKVIEW_FUNCTIONS_API

	CARD_HOLDER
		rename
			is_drop_xy as has_point
		redefine
			draw,
			set_xy,
			layout
		end

	COLORS

create
	make

feature {NONE}

	make (a_height: INTEGER)
		do
			create cards.make
			width := {CARD_COMPONENT}.Const_width
			height := a_height
		end

feature

	is_layout_fresh: BOOLEAN = True

	cards: LINKED_LIST [CARD_COMPONENT]

	layout
		do
			across
				cards as c
			loop
				c.item.set_xy (x, y + (c.cursor_index - 1) * offset)
			end
		end

	set_xy (a_x, a_y: INTEGER)
		do
			Precursor (a_x, a_y)
			layout
		end

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

	has_point (a_x, a_y: INTEGER): BOOLEAN
		do
			Result := x <= a_x and a_x <= (x + width) and y <= a_y and a_y <= (y + height)
		end

	draw
		local
			old_inverted: BOOLEAN
		do
			fill_area (x, y, width, height, White)
			across
				cards is c
			loop
				old_inverted := c.inverted
				c.inverted := False
				c.draw
				c.inverted := old_inverted
			end
			if highlight and not is_empty then
				old_inverted := item.inverted
				item.inverted := True
				item.draw
				item.inverted := old_inverted
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

invariant
	exactly_card_width: width = {CARD_COMPONENT}.Const_width

end
