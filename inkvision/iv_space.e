class
	IV_SPACE

inherit

	IV_COMPONENT

create
	make

feature {NONE}

	make (a_width, a_height: INTEGER)
		do
			width := a_width
			height := a_height
		end

end
