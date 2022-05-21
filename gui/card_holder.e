note
	description: "Stacks and other places where cards can reside"

deferred class
	CARD_HOLDER

inherit

	IV_COMPONENT
		undefine
			do_on_pointer_up,
			do_on_pointer_down
		end

	IV_WITH_ACTIONS

feature

	is_valid_item (card: CARD_COMPONENT): BOOLEAN
		deferred
		end

	is_empty: BOOLEAN
		deferred
		end

	item: CARD_COMPONENT
		require
			not is_empty
		deferred
		end

	remove
		require
			not is_empty
		deferred
		end

	extend (card: CARD_COMPONENT)
		require
			is_valid_item (card)
		deferred
		end

	is_pick_xy (a_x, a_y: INTEGER): BOOLEAN
		deferred
		end

	is_drop_xy (a_x, a_y: INTEGER): BOOLEAN
		deferred
		end

	highlight: BOOLEAN assign set_highlight

	set_highlight (a_highlight: BOOLEAN)
		do
			highlight := a_highlight
		end

end
