deferred class
	IV_RECT

feature

	x: INTEGER

	y: INTEGER

	width: INTEGER
		deferred
		end

	height: INTEGER
		deferred
		end

	set_xy (a_x, a_y: INTEGER)
		do
			x := a_x
			y := a_y
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
