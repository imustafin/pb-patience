﻿note
	description: "Playing card"

expanded class
	CARD

inherit

	ANY
		redefine
			default_create
		end

create
	default_create, make

feature {CARD} -- Definitions

	Suits: ARRAY [TUPLE [symbol: CHARACTER_32; is_red: BOOLEAN]]
		once
			Result := <<['♥', True], ['♦', True], ['♣', False], ['♠', False]>>
		ensure
			class
		end

	Ranks: ARRAY [STRING]
		once
			Result := <<"A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K">>
		ensure
			class
		end

	default_create
		do
			make (1, 1)
		end

	make (a_suit, a_rank: INTEGER)
		require
			valid_suit: Suits.valid_index (a_suit)
			valid_rank: Ranks.valid_index (a_rank)
		do
			suit := a_suit
			rank := a_rank
		ensure
			suit_set: suit = a_suit
			rank_set: rank = a_rank
		end

	suit: INTEGER
			-- Index in `Suits`

	rank: INTEGER
			-- Index in `Ranks`

feature

	new_deck: ARRAY [CARD]
		local
			i: INTEGER
		do
			create Result.make_filled (create {CARD}.make (1, 1), 1, Suits.count * Ranks.count)
			i := 1
			across
				1 |..| Suits.count is s
			loop
				across
					1 |..| Ranks.count is r
				loop
					Result [i] := create {CARD}.make (s, r)
					i := i + 1
				end
			end
		ensure
			class
		end

feature

	suit_is_red: BOOLEAN
		do
			Result := Suits [suit].is_red
		end

	is_same_color (a_other: CARD): BOOLEAN
		do
			Result := Suits [suit].is_red = Suits [a_other.suit].is_red
		end

	is_next_rank_after (a_other: CARD): BOOLEAN
			-- Is Current's rank greater by 1 than `a_other`'s
		do
			Result := (a_other.rank + 1) = rank
		end

	is_ace: BOOLEAN
		do
			Result := rank = 1
		end

	is_same_suit (a_other: CARD): BOOLEAN
		do
			Result := suit = a_other.suit
		end

	out_32: STRING_32
		do
			create Result.make_empty
			Result.append_string (Ranks [rank])
			Result.append_character (Suits [suit].symbol)
		end

invariant
	existing_suit: Suits.valid_index (suit)
	existing_rank: Ranks.valid_index (rank)

end
