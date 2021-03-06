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

	game: GAME

	init
		local
		do
			set_orientation (1)
			set_panel_type (Panel_disabled)

				-- Init menu
			create cmenu.make_by_pointer (create_context_menu ((create {C_STRING}.make (cmenu_id)).item))

				-- Components
			make_vertical (0, 0, 0, 0)
			create {SPIDER_GAME} game.make_with_seed (1, since_epoch)
			create topbar.make (0, 0, game.title, cmenu)
			set_game (game)

				-- Init menu
			register_cmenu
			fill_menu_items
		end

	set_game (a_game: GAME)
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
				set_game (game.new_with_seed (since_epoch))
				show
			when I_play_free_cell then
				set_game (create {FREE_CELL_GAME}.make_with_seed (since_epoch))
				show
			when I_play_spider_1 then
				set_game (create {SPIDER_GAME}.make_with_seed (1, since_epoch))
				show
			when I_play_spider_2 then
				set_game (create {SPIDER_GAME}.make_with_seed (2, since_epoch))
				show
			when I_play_spider_4 then
				set_game (create {SPIDER_GAME}.make_with_seed (4, since_epoch))
				show
			when I_exit then
				close_app
			when I_about then
				about_dialog
			else
				full_update
			end
		end

	about_dialog
		local
			text: STRING_32
		do
			text := "pb-patience%NPocketBook Patience Collection%NVersion: " + {VERSION}.version + "%N%N"
			text := text + "[
				Written in Eiffel by Ilgiz Mustafin
				
				Released under GPL2
				
				For new releases and bug reports visit
				https://github.com/imustafin/pb-patience
			]"
			{IV_UTILS}.dialog_32 (0, "About", text, "Close", Void, {POINTER}.default_pointer)
		end

	I_exit: INTEGER = 100

	I_new_game: INTEGER = 200

	I_play_free_cell: INTEGER = 300

	I_play_spider_1: INTEGER = 400

	I_play_spider_2: INTEGER = 500

	I_play_spider_4: INTEGER = 600

	I_about: INTEGER = 700

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
			menu, games, spider: MEMORY_ARRAY [IMENU_S_STRUCT_API]
		do
			create menu.make (6, {IMENU_S_STRUCT_API}.structure_size)
				-- New Game
			menu [1].set_type (Item_active)
			menu [1].set_text (create {C_STRING}.make ("New game"))
			menu [1].set_index (I_new_game)

				-- Switch game
			menu [2].set_type (Item_submenu)
			menu [2].set_text (create {C_STRING}.make ("Switch game"))
			create games.make (2, {IMENU_S_STRUCT_API}.structure_size)
			games [1].set_type (Item_active)
			games [1].set_text (create {C_STRING}.make ("FreeCell"))
			games [1].set_index (I_play_free_cell)

				-- Spider submenu
			create spider.make (3, {IMENU_S_STRUCT_API}.structure_size)
			spider [1].set_type (Item_active)
			spider [1].set_text (create {C_STRING}.make ("1 Suit"))
			spider [1].set_index (I_play_spider_1)
			spider [2].set_type (Item_active)
			spider [2].set_text (create {C_STRING}.make ("2 Suits"))
			spider [2].set_index (I_play_spider_2)
			spider [3].set_type (Item_active)
			spider [3].set_text (create {C_STRING}.make ("4 Suits"))
			spider [3].set_index (I_play_spider_4)
			games [2].set_type (Item_submenu)
			games [2].set_text (create {C_STRING}.make ("Spider"))
			games [2].set_submenu (spider [1])
			menu [2].set_submenu (games [1])

				-- About button
			menu [3].set_type (Item_active)
			menu [3].set_text (create {C_STRING}.make ("About"))
			menu [3].set_index (I_about)

				-- Exit button
			menu [4].set_type (Item_active)
			menu [4].set_text (create {C_STRING}.make ("Exit"))
			menu [4].set_index (I_exit)
			cmenu.set_menu (menu [1])
		end

end
