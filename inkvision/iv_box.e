deferred class
	IV_BOX

inherit

	IV_COMPONENT
		undefine
			layout
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
			expire_layout
		end

	append (a_components: SEQUENCE [IV_COMPONENT])
		do
			implementation.append (a_components)
			expire_layout
		end

	is_layout_fresh: BOOLEAN

	expire_layout
		do
			is_layout_fresh := False
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
				expire_layout
			end
		ensure then
			a_x /= old x or a_y /= old y implies not is_layout_fresh
		end

	set_wh (a_width, a_height: INTEGER)
		do
			if width /= a_width or height /= a_height then
				Precursor (a_width, a_height)
				expire_layout
			end
		ensure then
			a_width /= old width or a_height /= old height implies not is_layout_fresh
		end

feature

	layout
			-- Assign `x` and `y` for all in `implementation`
		deferred
		ensure then
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
	enough_width: is_layout_fresh implies width >= content_width
	enough_height: is_layout_fresh implies height >= content_height
	all_inside: is_layout_fresh implies across implementation is c all is_rect_inside (c) end

end
