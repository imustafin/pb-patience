class
	MEMORY_ARRAY [G -> MEMORY_STRUCTURE create make, make_by_pointer end]

create
	make

feature {NONE}

	make (a_count, a_item_size: INTEGER)
		local
			structure_size: INTEGER
			zeroes: ARRAY [NATURAL_8]
		do
			count := a_count
			item_size := a_item_size
				-- Add one for the last NULL item
			structure_size := (count + 1) * a_item_size
			create representation.make (structure_size)
				-- Fill with zero
			create zeroes.make_filled (0, 1, structure_size)
			representation.put_array (zeroes, 0)
				-- Create instances
			create instances.make_filled (create {G}.make, 1, count)
			across
				1 |..| count is i
			loop
				instances [i] := create {G}.make_by_pointer (representation.item + (i - 1) * a_item_size)
			end
		ensure
			count = a_count
			representation.count = (count + 1) * a_item_size
		end

	representation: MANAGED_POINTER

	instances: ARRAY [G]

	item_size: INTEGER

feature

	count: INTEGER

	item alias "[]" (a_index: INTEGER): G
		require
			a_index >= 1
			a_index <= count
		do
			Result := instances [a_index]
		end

	pointer: POINTER
		do
			Result := representation.item
		end

invariant
	across instances is i all i.structure_size = item_size end

end
