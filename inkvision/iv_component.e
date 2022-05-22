deferred class
	IV_COMPONENT

inherit

	INKVIEW_EVT

	IV_RECT

feature -- Events

	do_on_pointer_down (a_x, a_y: INTEGER): BOOLEAN
		require
			is_point_inside (a_x, a_y)
		do
		end

	do_on_pointer_up (a_x, a_y: INTEGER): BOOLEAN
		require
			is_point_inside (a_x, a_y)
		do
		end

feature

	draw
		do
		end

end
