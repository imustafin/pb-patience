class
	MAIN_HANDLER

inherit

	INKVIEW_FUNCTIONS_API

	PANEL_FLAGS_ENUM_API

	INKVIEW_EVT

	COLORS

	IV_LINEAR_BOX
		redefine
			set_wh
		end

create
	init

feature {NONE}

	topbar: TOPBAR

	game: FREE_CELL_GAME

	init
		do
			set_orientation (1)
			set_panel_type (Panel_disabled)

				-- Components
			make_vertical (0, 0, 0, 0)
			create topbar.make (0, 0, {FREE_CELL_GAME}.title)
			create game.make (0, 0, since_epoch)
			implementation.extend (topbar)
			implementation.extend (game)
		end

	set_wh (a_width, a_height: INTEGER)
		do
			topbar.set_wh (a_width, 100)
			game.set_wh (a_width, a_height - topbar.height)
			Precursor (a_width, a_height)
		end

feature

	handle (type, par1, par2: INTEGER): INTEGER
		do
			inspect type
			when Evt_keypress then
				close_app
			when Evt_show then
				clear_screen
				set_wh (screen_width, screen_height)
				layout
				draw
				full_update
				Result := 1
			when Evt_pointerdown then
				Result := do_on_pointer_down (par1, par2).to_integer
			when Evt_pointerup then
				Result := do_on_pointer_up (par1, par2).to_integer
			else
			end
		end

	since_epoch: INTEGER
		local
			epoch, now: DATE_TIME
		do
			create epoch.make_from_epoch (0)
			create now.make_now
			Result := (now.definite_duration (epoch)).seconds_count.as_integer_32
		end

end
