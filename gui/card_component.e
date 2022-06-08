class
	CARD_COMPONENT

inherit

	INKVIEW_FUNCTIONS_API

	COLORS

	IV_COMPONENT
		redefine
			draw
		end

create
	make

feature {NONE}

	make (a_suit, a_rank: INTEGER)
		require
			existing_suit: Suits.valid_index (a_suit)
			existing_rank: Ranks.valid_index (a_rank)
		do
			suit := a_suit
			rank := a_rank
			width := Const_width
			height := Const_height
			is_face_up := True
		ensure
			suit_set: suit = a_suit
			rank_set: rank = a_rank
		end

feature {CARD_COMPONENT}

	suit: INTEGER
			-- Index in `Suits`

	rank: INTEGER
			-- Index in `Ranks`

feature

	is_face_up: BOOLEAN
			-- Should this card be drawn with face up?

	flip_face_up
		do
			is_face_up := True
		end

	flip_face_down
		do
			is_face_up := False
		end

feature

	Suits: ARRAY [TUPLE [symbol: CHARACTER_32; is_red: BOOLEAN]]
		once
			Result := <<['♥', True], ['♦', True], ['♣', False], ['♠', False]>>
		ensure
			class
		end

	Hearts: INTEGER = 1

	Diamonds: INTEGER = 2

	Clubs: INTEGER = 3

	Spades: INTEGER = 4

	Ranks: ARRAY [STRING]
		once
			Result := <<"A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K">>
		ensure
			class
		end

feature

	has_point (a_x, a_y: INTEGER): BOOLEAN
		do
			Result := x <= a_x and a_x <= (x + width) and y <= a_y and a_y <= (y + height)
		end

	is_other_color (a_other: CARD_COMPONENT): BOOLEAN
		do
			Result := Suits [suit].is_red /= Suits [a_other.suit].is_red
		end

feature

	is_layout_fresh: BOOLEAN = True

	inverted: BOOLEAN assign set_inverted

	set_inverted (a_inverted: BOOLEAN)
		do
			inverted := a_inverted
		end

	card_font: detachable IFONT_S_STRUCT_API
		once
			Result := {IV_UTILS}.open_font ("LiberationSans", 42, True)
		ensure
			class
		end

	draw
		local
			pad: INTEGER
		do
			pad := 5
			if attached card_font as f then
				if Suits [suit].is_red then
					set_font (f, Dgrey)
				else
					if not inverted then
						set_font (f, Black)
					else
						set_font (f, White)
					end
				end
			end
			if not inverted then
				fill_area (x, y, width, height, White)
			else
				fill_area (x, y, width, height, Black)
			end
			draw_rect (x, y, width, height, Black)
			if is_face_up then
				{IV_UTILS}.draw_text_rect (x + pad, y + pad, width - pad * 2, height - pad * 2, card_title, 0)
			else
				fill_area (x + 10, y + 10, width - 20, height - 20, Dgrey)
			end
		end

	invert
		do
			invert_area (x, y, width, height)
		end

	card_title: STRING_32
		do
			create Result.make_empty
			Result.append_string (Ranks [rank])
			Result.append_character (Suits [suit].symbol)
		end

	is_same_color (a_other: CARD_COMPONENT): BOOLEAN
		do
			Result := Suits [suit].is_red = Suits [a_other.suit].is_red
		end

	is_next_rank_after (a_other: CARD_COMPONENT): BOOLEAN
			-- Is Current's rank greater by 1 than `a_other`'s
		do
			Result := (a_other.rank + 1) = rank
		end

	new_deck: ARRAY [CARD_COMPONENT]
		local
			i: INTEGER
		do
			create Result.make_filled (create {CARD_COMPONENT}.make (1, 1), 1, Suits.count * Ranks.count)
			i := 1
			across
				1 |..| Suits.count is s
			loop
				across
					1 |..| Ranks.count is r
				loop
					Result [i] := create {CARD_COMPONENT}.make (s, r)
					i := i + 1
				end
			end
		ensure
			class
		end

	is_ace: BOOLEAN
		do
			Result := rank = 1
		end

	is_same_suit (a_other: CARD_COMPONENT): BOOLEAN
		do
			Result := suit = a_other.suit
		end

feature

	Const_width: INTEGER = 175

	Const_height: INTEGER
		once
			Result := (3.5 / 2.25 * Const_width).floor
		ensure
			class
		end

invariant
	existing_suit: Suits.valid_index (suit)
	existing_rank: Ranks.valid_index (rank)
	width_constant: width = Const_width
	height_in_ratio: height = Const_height

end
