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

	handle_application (type, par1, par2: INTEGER): INTEGER
		require
			no_handler_before_init: type = Evt_init implies handler = Void
			handler_after_init: type /= Evt_init implies handler /= Void
		do
			inspect type
			when Evt_init then
				create handler.init
				Result := 1
			else
				check attached handler as h then
					Result := h.handle (type, par1, par2)
				end
			end
		ensure
			handler_after_init: type = Evt_init implies handler /= Void
		end

end
