class
	IV_V_BOX

inherit

	IV_BOX

create
	make

feature {NONE}

	make (a_x, a_y, a_width, a_height: INTEGER)
		do
			create implementation.make
			x := a_x
			y := a_y
			width := a_width
			height := a_height
		end

feature

	space: INTEGER

	Space_begin: INTEGER = 0

	Space_evenly: INTEGER = 1

	set_space_evenly
		do
			space := Space_evenly
			relayout
		end

	h_align: INTEGER

	H_align_center: INTEGER = 1

	set_h_align_center
		do
			h_align := H_align_center
		end

feature

	width: INTEGER

	height: INTEGER

feature

	relayout
		local
			xx, yy: INTEGER
			free_space: INTEGER
			pad: INTEGER
		do
			if space = Space_evenly then
				free_space := height - content_height
				pad := free_space // (implementation.count + 1)
			end
			xx := x
			yy := y + pad
			across
				implementation is c
			loop
				if h_align = H_align_center then
					xx := x + ((width - c.width) // 2)
				end
				c.set_xy (xx, yy)
				yy := yy + c.height + pad
			end
		end

	content_height: INTEGER
		do
			across
				implementation is c
			loop
				Result := Result + c.height
			end
		end

	content_width: INTEGER
		do
			across
				implementation is c
			loop
				Result := Result.max (c.width)
			end
		end

end
