deferred class
	GAME

inherit

	IV_COMPONENT

feature

	title: STRING_32
		deferred
		end

	make_with_seed (a_seed: INTEGER)
		deferred
		end

	new_with_seed (a_seed: INTEGER): like Current
		deferred
		ensure
			class
		end

end
