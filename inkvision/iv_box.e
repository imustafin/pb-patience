deferred class
	IV_BOX

inherit

	IV_COMPONENT
		redefine
			draw,
			do_on_pointer_up,
			do_on_pointer_down,
			set_xy
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
			Precursor (a_x, a_y)
			relayout
		end

feature

feature {NONE}

	relayout
			-- Assign `x` and `y` for all in `implementation`
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
			Result := handle_one (agent {IV_COMPONENT}.do_on_pointer_up(a_x, a_y))
		end

	do_on_pointer_down (a_x, a_y: INTEGER): BOOLEAN
		do
			Result := handle_one (agent {IV_COMPONENT}.do_on_pointer_down(a_x, a_y))
		end

	handle_one (a_agent: FUNCTION [IV_COMPONENT, BOOLEAN]): BOOLEAN
		do
			across
				implementation.new_cursor.reversed is c
			until
				Result
			loop
				Result := a_agent.item (c)
			end
		end

invariant
	enough_width: width >= content_width
	enough_height: height >= content_height
	all_inside: across implementation is c all is_rect_inside (c) end

end
