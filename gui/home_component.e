note
	description: "Component for a HomeCell"

class
	HOME_COMPONENT

inherit

	CARD_HOLDER
		rename
			is_pick_xy as has_point,
			is_drop_xy as has_point
		end

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

feature {NONE}

	inner_item: detachable CARD_COMPONENT

feature

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
		do
			if is_empty then
				fill_area(x, y, Width, Height, White)
				draw_rect (x, y, Width, Height, Black)
			else
				check attached item as i then
					item.draw
				end
				if highlight then
					item.invert
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

end
