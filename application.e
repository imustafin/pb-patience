class
	APPLICATION

inherit

	ARGUMENTS_32

	INKVIEW_EVT

	INKVIEW_FUNCTIONS_API

	PANEL_FLAGS_ENUM_API

create
	make

feature {NONE} -- Initialization

	handler: detachable MAIN_HANDLER

	make
		local
			main_handler_dispatcher: IV_HANDLER_DISPATCHER
		do
			create main_handler_dispatcher.make
			main_handler_dispatcher.register_callback_1 (agent handle_application)
			ink_view_main (main_handler_dispatcher.c_dispatcher_1)
		end

	can_show_exceptions: BOOLEAN

	show_exception_dialog
		local
			c1, body, exit, next, prev: C_STRING
			erout: STRING
			a, b: INTEGER
			res: INTEGER
			n: INTEGER
		do
			n := 300
			if attached {EXCEPTIONS}.meaning ({EXCEPTIONS}.exception) as meaning then
				create c1.make (meaning)
			else
				create c1.make ("NO MEANING exception " + {EXCEPTIONS}.exception.out)
			end
			if attached {EXCEPTION_MANAGER}.last_exception as e then
				erout := e.out
			else
				erout := "No exception (???)"
			end
			across
				1 |..| 20 as i
			loop
				erout.replace_substring_all ("  ", " ")
			end
			a := 1
			b := erout.count.min (n)
			create exit.make ("exit")
			create next.make ("next")
			create prev.make ("prev")
			from
				res := -10
			until
				res = 1
			loop
				create body.make (erout.substring (a, b))
				res := dialog_synchro (0, c1.item, body.item, exit.item, prev.item, next.item)
				if res = 3 then
					b := (b + n).min (erout.count)
					a := (b - n).max (1)
				elseif res = 2 then
					a := (a - n).max (1)
					b := (a + n).min (erout.count)
				end
			end
		end

	handle_application (type, par1, par2: INTEGER): INTEGER
		require
			no_handler_before_init: type = Evt_init implies handler = Void
			handler_after_init: type /= Evt_init implies handler /= Void
		do
			inspect type
			when Evt_init then
				can_show_exceptions := True
				create handler.init
				Result := 1
			else
				check attached handler as h then
					Result := h.handle (type, par1, par2)
				end
			end
		ensure
			handler_after_init: type = Evt_init implies handler /= Void
--		rescue
--			if can_show_exceptions then
--				show_exception_dialog
--			end
		end

end
