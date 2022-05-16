note
	description: "pb-patience application root class"
	date: "$Date$"
	revision: "$Revision$"

class
	APPLICATION

inherit

	ARGUMENTS_32

	INKVIEW_EVT

	INKVIEW_FUNCTIONS_API

create
	make

feature {NONE} -- Initialization

	make
			-- Run application.
		local
			main_handler_dispatcher: IV_HANDLER_DISPATCHER
		do
				--| Add your code here
			print ("Hello Eiffel World!%N")
			create main_handler_dispatcher.make
			main_handler_dispatcher.register_callback_1 (agent main)
			ink_view_main (main_handler_dispatcher.c_dispatcher_1)
		end

	main (type, x, y: INTEGER): INTEGER
		do
			inspect type
			when Evt_init then
				clear_screen
				fill_area (100, 200, 300, 400, 0xAABBCCDD)
				fill_area (10, 20, 30, 40, 0xAABBCCDD)
				full_update
			when Evt_keypress then
				close_app
			else
			end
		end

end
