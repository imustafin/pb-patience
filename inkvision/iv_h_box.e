class
	IV_H_BOX

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
				free_space := width - children_own_width
				pad := free_space // (implementation.count + 1)
			end
			xx := x + pad
			yy := y
			across
				implementation.new_cursor is c
			loop
				c.set_xy (xx, yy)
				xx := xx + c.width + pad
			end
		end

	children_own_width: INTEGER
		do
			across
				implementation is c
			loop
				Result := Result + c.width
			end
		end

	content_height: INTEGER
		do
			across
				implementation is c
			loop
				Result := Result.max (c.height)
			end
		end

	content_width: INTEGER
		do
			across
				implementation is c
			loop
				Result := Result + c.width
			end
		end

end
