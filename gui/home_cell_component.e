class
	HOME_CELL_COMPONENT

inherit

	CARD_HOLDER

	INKVIEW_FUNCTIONS_API

	COLORS

create
	make

feature

	make (a_x, a_y: INTEGER)
		do
			x := a_x
			y := a_y
		end

feature

	x, y: INTEGER

	Width: INTEGER
		once
			Result := {CARD_COMPONENT}.width
		ensure
			class
		end

	Height: INTEGER
		once
			Result := {CARD_COMPONENT}.height
		ensure
			class
		end

feature

	is_valid_item (card: CARD_COMPONENT): BOOLEAN
		do
			if is_empty then
				Result := card.card.is_ace
			else
				Result := card.card.is_next_rank_after (item.card) and card.card.same_type (item.card)
			end
		end

	is_empty: BOOLEAN
		do
			Result := inner_item = Void
		end

	item: CARD_COMPONENT
		do
			check attached inner_item as i then
				Result := i
			end
		end

	remove
		do
				-- Can't remove
		ensure then
			False
		end

	extend (a_card: CARD_COMPONENT)
		do
			inner_item := a_card
			item.set_xy (x, y)
		end

	draw
		do
			if is_empty then
				fill_area (x, y, Width, Height, White)
				draw_rect (x, y, Width, Height, Black)
			else
				check attached item as i then
					item.draw(highlight)
				end
			end
		end

	is_pick_xy (a_x, a_y: INTEGER): BOOLEAN
		do
		ensure then
			cant_take_from_home: Result = False
		end

	is_drop_xy (a_x, a_y: INTEGER): BOOLEAN
		do
			Result := x <= a_x and a_x <= (x + width) and y <= a_y and a_y <= (y + height)
		end

feature {NONE}

	inner_item: detachable CARD_COMPONENT

end
