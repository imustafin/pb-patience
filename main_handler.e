class
	MAIN_HANDLER

inherit

	INKVIEW_FUNCTIONS_API

	PANEL_FLAGS_ENUM_API

	INKVIEW_EVT

	COLORS

create
	init

feature {NONE}

	game: FREE_CELL_GAME

	init
		do
			set_orientation (1)
			set_panel_type (Panel_disabled)
			create game.make (0, 0, since_epoch)
		end

feature

	handle (type, par1, par2: INTEGER): INTEGER
		do
			inspect type
			when Evt_keypress then
				close_app
			when Evt_show then
				relayout
				draw
				full_update
				Result := 1
			when Evt_pointerdown then
				Result := game.do_on_pointer_down (par1, par2).to_integer
			when Evt_pointerup then
				Result := game.do_on_pointer_up (par1, par2).to_integer
			else
			end
		end

	relayout
		do
			if screen_width /= game.width or screen_height /= game.height then
				game.set_wh (screen_width, screen_height)
			end
		end

	draw
		do
			game.layout
			game.draw
		end

	since_epoch: INTEGER
		local
			epoch, now: DATE_TIME
		do
			create epoch.make_from_epoch (0)
			create now.make_now
			Result := (now.definite_duration (epoch)).seconds_count.as_integer_32
		end

	card_font: detachable IFONT_S_STRUCT_API
		local
			p: POINTER
		once
			p := open_font ((create {C_STRING}.make ("LiberationSans")).item, 42, 1)
			if not p.is_default_pointer then
				create Result.make_by_pointer (p)
			end
		ensure
			class
		end

end
