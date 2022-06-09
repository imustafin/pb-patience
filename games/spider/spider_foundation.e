class
	SPIDER_FOUNDATION

inherit

	INKVIEW_FUNCTIONS_API

	COLORS

	IV_COMPONENT
		redefine
			draw
		end

create
	make

feature

	make
		do
			width := {CARD_COMPONENT}.const_width
			height := {CARD_COMPONENT}.const_height
		end

	is_layout_fresh: BOOLEAN = True

	card: detachable CARD_COMPONENT

	set_card (a_card: CARD_COMPONENT)
		do
			card := a_card
			a_card.set_xy (x, y)
		end

	is_empty: BOOLEAN
		do
			Result := card = Void
		ensure
			Result = (card = Void)
		end

	draw
		do
			if is_empty then
				fill_area (x, y, width, height, White)
				draw_rect(x, y, width, height, Black)
			else
				check attached card as c then
					c.draw
				end
			end
		end

end
