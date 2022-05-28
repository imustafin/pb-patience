class
	MAIN_HANDLER

inherit

	INKVIEW_FUNCTIONS_API

	PANEL_FLAGS_ENUM_API

	INKVIEW_EVT

	COLORS

	INKVIEW_ITEM

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
		local
		do
			set_orientation (1)
			set_panel_type (Panel_disabled)

				-- Init menu
			create cmenu.make_by_pointer (create_context_menu ((create {C_STRING}.make (cmenu_id)).item))

				-- Components
			make_vertical (0, 0, 0, 0)
			create game.make (0, 0, since_epoch)
			create topbar.make (0, 0, game.title, cmenu)
			set_game (game)

				-- Init menu
			register_cmenu
			fill_menu_items
		end

	set_game (a_game: FREE_CELL_GAME)
		do
			game := a_game
			implementation.wipe_out
			implementation.extend (topbar)
			implementation.extend (game)
			topbar.title := game.title
			expire_layout
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
				show
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

	show
		do
			clear_screen
			set_wh (screen_width, screen_height)
			layout
			draw
			full_update
		end

feature -- Menu

	menu_callback (a_index: INTEGER)
		do
			inspect a_index
			when I_new_game then
				set_game (create {FREE_CELL_GAME}.make (0, 0, since_epoch))
				show
			when I_exit then
				close_app
			else
			end
		end

	I_exit: INTEGER = 100

	I_new_game: INTEGER = 200

	cmenu: ICONTEXT_MENU_S_STRUCT_API

	cmenu_id: STRING = "topbar_menu"

	register_cmenu
		local
			menu_dispatcher: IV_MENUHANDLER_DISPATCHER
		do
			create menu_dispatcher.make
			menu_dispatcher.register_callback_1 (agent menu_callback)
			cmenu.set_update_after_close (0)
			cmenu.set_hproc (menu_dispatcher.c_dispatcher_1)
		end

	fill_menu_items
		local
			menu: MEMORY_ARRAY [IMENU_S_STRUCT_API]
		do
			create menu.make (5, {IMENU_S_STRUCT_API}.structure_size)
			check attached menu as m then
				m [1].set_type (Item_active)
				m [1].set_text (create {C_STRING}.make ("New game"))
				m [1].set_index (I_new_game)
				m [2].set_type (Item_separator)
				m [3].set_type (Item_active)
				m [3].set_text (create {C_STRING}.make ("Exit"))
				m [3].set_index (I_exit)
				cmenu.set_menu (m [1])
			end
		end

end
