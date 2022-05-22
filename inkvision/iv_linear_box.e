class
	IV_LINEAR_BOX

inherit

	IV_BOX

create {NONE}
	make

create
	make_vertical, make_horizontal

feature {NONE}

	make_vertical (a_x, a_y, a_width, a_height: INTEGER)
		do
			make (a_x, a_y, a_width, a_height, True)
		ensure
			is_vertical
		end

	make_horizontal (a_x, a_y, a_width, a_height: INTEGER)
		do
			make (a_x, a_y, a_width, a_height, False)
		ensure
			not is_vertical
		end

	make (a_x, a_y, a_width, a_height: INTEGER; a_is_vertical: BOOLEAN)
		do
			create implementation.make
			x := a_x
			y := a_y
			width := a_width
			height := a_height
			is_vertical := a_is_vertical
		end

feature -- Spacing (main axis)

	space: INTEGER
			-- Gaps on main axis

	Space_compact: INTEGER = 0
			-- No gaps

	Space_evenly: INTEGER = 1
			-- Add gaps around each item
			-- to fill whole main axis

	set_space_evenly
		do
			if space /= space_evenly then
				space := space_evenly
				relayout
			end
		end

feature -- Alignment (cross axis)

	align: INTEGER
			-- Where to put items on cross axis

	Align_center: INTEGER = 1

	set_align_center
		do
			if align /= Align_center then
				align := Align_center
				relayout
			end
		end

feature

	is_vertical: BOOLEAN

feature {NONE}

	relayout
		local
			pad: INTEGER
			main, cross: INTEGER
		do
			if space = Space_evenly then
				pad := (main_size - main_component_size) // (implementation.count + 1)
			end
			main := main_coordinate + pad
			across
				implementation is c
			loop
				if align = Align_center then
					cross := cross_coordinate + ((cross_size - other_cross_size (c)) // 2)
				else
					cross := cross_coordinate
				end
				adjust_child_xy (c, main, cross)
				main := main + other_main_size (c) + pad
			end
		end

	main_size: INTEGER
		do
			if is_vertical then
				Result := height
			else
				Result := width
			end
		end

	cross_size: INTEGER
		do
			if is_vertical then
				Result := width
			else
				Result := height
			end
		end

	main_component_size: INTEGER
		do
			if is_vertical then
				Result := content_height
			else
				Result := content_width
			end
		end

	main_coordinate: INTEGER
		do
			if is_vertical then
				Result := y
			else
				Result := x
			end
		end

	cross_coordinate: INTEGER
		do
			if is_vertical then
				Result := x
			else
				Result := y
			end
		end

	other_main_size (a_component: IV_COMPONENT): INTEGER
		do
			if is_vertical then
				Result := a_component.height
			else
				Result := a_component.width
			end
		end

	other_cross_size (a_component: IV_COMPONENT): INTEGER
		do
			if is_vertical then
				Result := a_component.width
			else
				Result := a_component.height
			end
		end

	adjust_child_xy (c: IV_COMPONENT; a_main, a_cross: INTEGER)
		do
			if is_vertical then
				c.set_xy (a_cross, a_main)
			else
				c.set_xy (a_main, a_cross)
			end
		end

feature

	content_width: INTEGER
		do
			across
				implementation is c
			loop
				if is_vertical then
					Result := Result.max (c.width)
				else
					Result := Result + c.width
				end
			end
		end

	content_height: INTEGER
		do
			across
				implementation is c
			loop
				if is_vertical then
					Result := Result + c.height
				else
					Result := Result.max (c.height)
				end
			end
		end

end
