note
	description: "Component for a HomeCell"

class
	FREE_CELL_COMPONENT

inherit

	CARD_HOLDER
		rename
			is_pick_xy as has_point,
			is_drop_xy as has_point
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

feature {NONE}

	inner_item: detachable CARD_COMPONENT

feature

	is_layout_fresh: BOOLEAN = True

	item: CARD_COMPONENT
		do
			check attached inner_item as i then
				Result := i
			end
		end

	is_valid_item (c: CARD_COMPONENT): BOOLEAN
		do
			Result := is_empty
		end

	is_empty: BOOLEAN
		do
			Result := inner_item = Void
		ensure then
			Result = (inner_item = Void)
		end

	extend (card: CARD_COMPONENT)
		do
			inner_item := card
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
					old_inverted := i.inverted
					i.inverted := highlight
					item.draw
					i.inverted := old_inverted
				end
			end
		end

	has_point (a_x, a_y: INTEGER): BOOLEAN
		do
			Result := x <= a_x and a_x <= (x + width) and y <= a_y and a_y <= (y + height)
		end

	remove
		do
			inner_item := Void
		end

invariant
	exactly_card_width: width = {CARD_COMPONENT}.Const_width
	exactly_card_height: height = {CARD_COMPONENT}.Const_height

end
