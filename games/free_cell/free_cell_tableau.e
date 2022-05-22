class
	FREE_CELL_TABLEAU

inherit

	IV_LINEAR_BOX
		rename
			make as make_iv_linear_box
		redefine
			set_wh
		end

create
	make

feature {NONE}

	make
		do
			make_horizontal (0, 0, 0, 0)
		end

feature

	set_wh (a_width, a_height: INTEGER)
		do
			across
				implementation is c
			loop
				c.set_wh (c.width, a_height)
			end
			Precursor (a_width, a_height)
		end

end
