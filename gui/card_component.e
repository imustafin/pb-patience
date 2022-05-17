class
	CARD_COMPONENT

inherit

	INKVIEW_FUNCTIONS_API

create
	make

feature

	make (a_owner: FOUNDATION_COMPONENT; a_card: CARD)
		do
			owner := a_owner
			card := a_card
		end

feature

	x: INTEGER

	y: INTEGER

	card: CARD

	owner: FOUNDATION_COMPONENT

feature

	has_point (a_x, a_y: INTEGER): BOOLEAN
		do
			Result := x <= a_x and a_x <= (x + width) and y <= a_y and a_y <= (y + height)
		end

feature {FOUNDATION_COMPONENT}

	set_xy (a_x, a_y: INTEGER)
		do
			x := a_x
			y := a_y
		end

feature

	Black: INTEGER = 0x000000

	Dgrey: INTEGER = 0x555555

	Lgrey: INTEGER = 0xaaaaaa

	White: INTEGER = 0xffffff

	Width: INTEGER = 175

	Height: INTEGER
		once
			Result := (3.5 / 2.25 * Width).floor
		ensure
			class
		end

	draw
		local
			c_str: C_STRING
			pad: INTEGER
		do
			pad := 10
			create c_str.make ({UTF_CONVERTER}.string_32_to_utf_8_string_8 (card.out_32))
			if attached owner.context.font as f then
				if card.suit_is_red then
					set_font (f, Dgrey)
				else
					set_font (f, Black)
				end
			end
			fill_area (x, y, width, height, White)
			draw_rect (x, y, width, height, Black)
			draw_text_rect (x + pad, y + pad, width - pad * 2, height - pad * 2, c_str.item, 0).do_nothing
		end

end
