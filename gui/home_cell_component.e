class
	HOME_CELL_COMPONENT

inherit

	CARD_HOLDER
		redefine
			draw
		end

	INKVIEW_FUNCTIONS_API

	COLORS

create
	make

feature {NONE}

	make
		do
			width := {CARD_COMPONENT}.Const_width
			height := {CARD_COMPONENT}.Const_height
		end

feature

	is_layout_fresh: BOOLEAN = True

	is_valid_item (card: CARD_COMPONENT): BOOLEAN
		do
			if is_empty then
				Result := card.is_ace
			else
				Result := card.is_next_rank_after (item) and card.is_same_suit (item)
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
		local
			old_inverted: BOOLEAN
		do
			if is_empty then
				fill_area (x, y, Width, Height, White)
				draw_rect (x, y, Width, Height, Black)
			else
				check attached item as i then
					old_inverted := item.inverted
					item.inverted := highlight
					item.draw
					item.inverted := old_inverted
				end
			end
		end

	is_pick_xy (a_x, a_y: INTEGER): BOOLEAN
		do
		ensure then
			cant_take_from_home: not Result
		end

	is_drop_xy (a_x, a_y: INTEGER): BOOLEAN
		do
			Result := x <= a_x and a_x <= (x + width) and y <= a_y and a_y <= (y + height)
		end

feature {NONE}

	inner_item: detachable CARD_COMPONENT

invariant
	exactly_card_width: width = {CARD_COMPONENT}.Const_width
	exactly_card_height: height = {CARD_COMPONENT}.Const_height

end
