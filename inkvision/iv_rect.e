deferred class
	IV_RECT

feature

	x: INTEGER

	y: INTEGER

	width: INTEGER

	height: INTEGER

	set_xy (a_x, a_y: INTEGER)
		do
			x := a_x
			y := a_y
		ensure
			x_set: x = a_x
			y_set: y = a_y
		end

	set_wh (a_width, a_height: INTEGER)
		do
			width := a_width
			height := a_height
		ensure
			width_set: width = a_width
			height_set: height = a_height
		end

feature

	is_rect_inside (a_other: IV_RECT): BOOLEAN
			-- Is `a_other` residing fully inside `Current`?
		do
			Result := is_point_inside (a_other.x, a_other.y) and is_point_inside (a_other.x + a_other.width, a_other.height + a_other.y)
		end

	is_point_inside (a_x, a_y: INTEGER): BOOLEAN
			-- Is the given point inside `Current`?
		do
			Result := x <= a_x and a_x <= x + width and y <= a_y and a_y <= y + height
		end

end
