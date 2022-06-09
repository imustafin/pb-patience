class
	SPIDER_COLUMN

inherit

	INKVIEW_FUNCTIONS_API

	IV_COMPONENT
		undefine
			do_on_pointer_up,
			do_on_pointer_down
		redefine
			draw,
			layout
		end

	IV_WITH_ACTIONS

	COLORS

create
	make

feature {NONE}

	make
		do
			create cards.make
			width := {CARD_COMPONENT}.const_width
		end

	cards: LINKED_LIST [CARD_COMPONENT]

feature

	is_layout_fresh: BOOLEAN

	expire_layout
		do
			is_layout_fresh := False
		end

	extend (a_card: CARD_COMPONENT)
		do
			cards.extend (a_card)
			expire_layout
		end

	append (a_cards: ARRAY [CARD_COMPONENT])
		do
			across
				a_cards is c
			loop
				extend (c)
			end
			expire_layout
		end

	highlight_from: INTEGER assign set_highlight_from

	set_highlight_from (a_highlight_from: INTEGER)
		do
			highlight_from := a_highlight_from
		end

	draw
		do
			fill_area (x, y, width, height, White)
			across
				cards as c
			loop
				if highlight_from /= 0 and c.cursor_index >= highlight_from then
					c.item.inverted := True
					c.item.draw
					c.item.inverted := False
				else
					c.item.draw
				end
			end
		end

	layout
		local
			offset: INTEGER
			yy: INTEGER
		do
			if cards.count > 1 then
				offset := ((height - {CARD_COMPONENT}.const_height) // (cards.count - 1)).min (60)
			end
			yy := y
			across
				cards is c
			loop
				c.set_xy (x, yy)
				yy := yy + offset
			end
			is_layout_fresh := True
		end

feature

	is_full_stack_in_the_end: BOOLEAN
		local
			finish: BOOLEAN
			last_card, c: CARD_COMPONENT
		do
			across
				cards.new_cursor.reversed as i
			until
				finish
			loop
				if last_card = Void then
					last_card := i.item
				else
					c := i.item
					if not c.is_face_up then
						finish := True
					elseif not (c.is_next_rank_after (last_card) and c.is_same_suit (last_card)) then
						finish := True
					elseif i.cursor_index = {CARD_COMPONENT}.ranks.count then
						Result := True
						finish := True
					else
						last_card := c
					end
				end
			end
		end

	last: CARD_COMPONENT
		require
			not is_empty
		do
			Result := cards.last
		end

	remove_full_stack
		require
			is_full_stack_in_the_end
		do
			cards.finish
			across
				1 |..| {CARD_COMPONENT}.ranks.count is i
			loop
				cards.remove
				cards.back
			end
			if not cards.is_empty then
				cards.last.flip_face_up
			end
		ensure
			cards.count = old cards.count - {CARD_COMPONENT}.ranks.count
		end

	movable_stack_at (a_x, a_y: INTEGER_32): INTEGER
			-- `0` for failed tap or
			-- lowest index of the tapped movable stack
		do
			Result := find_card_by_xy (a_x, a_y)
			if Result /= 0 then
				if not good_stack_from (Result) then
					Result := 0
				end
			end
		end

	good_stack_from (a_from: INTEGER): BOOLEAN
		local
			prev_card, c: CARD_COMPONENT
		do
			Result := True
			across
				a_from |..| cards.count is i
			until
				not Result
			loop
				c := cards.i_th (i)
				if not c.is_face_up then
					Result := False
				elseif prev_card = Void then
					prev_card := c
				else
					Result := c.is_same_suit (prev_card) and prev_card.is_next_rank_after (c)
					prev_card := c
				end
			end
		end

	find_card_by_xy (a_x, a_y: INTEGER): INTEGER
		do
			from
				Result := cards.count
			until
				Result = 0 or else cards.i_th (Result).is_point_inside (a_x, a_y)
			loop
				Result := Result - 1
			end
		ensure
			(Result = 0) = (across cards is i all not i.is_point_inside (a_x, a_y) end)
			(Result /= 0) implies cards.i_th (Result).is_point_inside (a_x, a_y)
		end

feature

	is_valid_card (a_card: CARD_COMPONENT): BOOLEAN
		do
			Result := cards.is_empty or else (cards.last.is_next_rank_after (a_card))
		end

	i_th (a_i: INTEGER): CARD_COMPONENT
		require
			1 <= a_i and a_i <= count
		do
			Result := cards.i_th (a_i)
		end

	is_empty: BOOLEAN
		do
			Result := cards.is_empty
		end

	count: INTEGER
		do
			Result := cards.count
		end

	transfer_to (a_from: INTEGER; a_other: SPIDER_COLUMN)
		require
			1 <= a_from and a_from <= count
		do
			from
				cards.go_i_th (a_from)
			until
				cards.exhausted
			loop
				a_other.extend (cards.item)
				cards.remove
			end
			if not cards.is_empty and then not cards.last.is_face_up then
				cards.last.flip_face_up
			end
		end

invariant
	width = {CARD_COMPONENT}.const_width

end
