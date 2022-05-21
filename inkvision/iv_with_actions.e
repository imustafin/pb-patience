deferred class
	IV_WITH_ACTIONS

feature

	on_pointer_down: detachable FUNCTION [TUPLE [INTEGER, INTEGER], BOOLEAN] assign set_on_pointer_down

	set_on_pointer_down (a_agent: like on_pointer_down)
		do
			on_pointer_down := a_agent
		end

	do_on_pointer_down (a_x, a_y: INTEGER): BOOLEAN
		do
			if attached on_pointer_down as a then
				Result := a.item (a_x, a_y)
			end
		end

	on_pointer_up: detachable FUNCTION [TUPLE [INTEGER, INTEGER], BOOLEAN] assign set_on_pointer_up

	set_on_pointer_up (a_agent: like on_pointer_up)
		do
			on_pointer_up := a_agent
		end

	do_on_pointer_up (a_x, a_y: INTEGER): BOOLEAN
		do
			if attached on_pointer_up as a then
				Result := a.item (a_x, a_y)
			end
		end

end
