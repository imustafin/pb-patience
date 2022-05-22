deferred class
	IV_BOX

inherit

	IV_COMPONENT
		redefine
			draw,
			do_on_pointer_up,
			do_on_pointer_down,
			set_xy,
			set_wh
		end

feature {NONE}

	implementation: LINKED_LIST [IV_COMPONENT]

feature

	extend (a_component: IV_COMPONENT)
		do
			implementation.extend (a_component)
			relayout
		end

	append (a_components: SEQUENCE [IV_COMPONENT])
		do
			implementation.append (a_components)
			relayout
		end

	draw
		do
			across
				implementation is c
			loop
				c.draw
			end
		end

	set_xy (a_x, a_y: INTEGER)
		do
			if x /= a_x or y /= a_y then
				Precursor (a_x, a_y)
				relayout
			end
		end

	set_wh (a_width, a_height: INTEGER)
		do
			if width /= a_width or height /= a_height then
				Precursor (a_width, a_height)
				relayout
			end
		end

feature {NONE}

	relayout
			-- Assign `x` and `y` for all in `implementation`
		require
			enough_width: width >= content_width
			enough_height: height >= content_height
		deferred
		ensure
			all_inside: across implementation is c all is_rect_inside (c) end
		end

feature

	content_width: INTEGER
		deferred
		end

	content_height: INTEGER
		deferred
		end

feature

	do_on_pointer_up (a_x, a_y: INTEGER): BOOLEAN
		do
			across
				implementation.new_cursor.reversed is c
			until
				Result
			loop
				if c.is_point_inside (a_x, a_y) then
					Result := c.do_on_pointer_up (a_x, a_y)
				end
			end
		end

	do_on_pointer_down (a_x, a_y: INTEGER): BOOLEAN
		do
			across
				implementation.new_cursor.reversed is c
			until
				Result
			loop
				if c.is_point_inside (a_x, a_y) then
					Result := c.do_on_pointer_down (a_x, a_y)
				end
			end
		end

invariant
	enough_width: width >= content_width
	enough_height: height >= content_height
	all_inside: across implementation is c all is_rect_inside (c) end

end
