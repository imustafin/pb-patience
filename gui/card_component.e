class
	CARD_COMPONENT

inherit

	INKVIEW_FUNCTIONS_API

feature

	Black: INTEGER = 0x000000

	Dgrey: INTEGER = 0x555555

	Lgrey: INTEGER = 0xaaaaaa

	White: INTEGER = 0xffffff

	Width: INTEGER = 225

	Height: INTEGER = 350

	draw (card: CARD; x, y: INTEGER; context: CONTEXT)
		local
			c_str: C_STRING
			pad: INTEGER
		do
			pad := 10
			create c_str.make ({UTF_CONVERTER}.string_32_to_utf_8_string_8 (card.out_32))
			if attached context.font as f then
				if card.suit_is_red then
					set_font (f, Lgrey)
				else
					set_font (f, Black)
				end
			end
			fill_area (x, y, width, height, White)
			draw_rect (x, y, width, height, Black)
			draw_text_rect (x + pad, y + pad, width - pad * 2, height - pad * 2, c_str.item, 0).do_nothing
		ensure
			class
		end

end
