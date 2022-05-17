class
	CONTEXT

feature

	font: detachable IFONT_S_STRUCT_API assign set_font

	set_font (a_font: like font)
		do
			font := a_font
		end

end
