note
	description: "Summary description for {UTILS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	UTILS

feature

	shuffle_deck (deck: ARRAY [CARD_COMPONENT]; a_deal_number: INTEGER)
		local
			j: INTEGER
			r: RANDOM
			t: CARD_COMPONENT
		do
			create r.set_seed (a_deal_number)
			across
				1 |..| deck.count is c
			loop
				r.forth
				j := r.item \\ c + 1
				t := deck [c]
				deck [c] := deck [j]
				deck [j] := t
			end
		ensure
			deck.count = (old deck).count and across (old deck) is d all deck.has (d) end
			class
		end

end
