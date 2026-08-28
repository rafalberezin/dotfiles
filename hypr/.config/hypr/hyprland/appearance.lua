hl.config({
	general = {
		border_size = 1,
		gaps_in     = 0,
		gaps_out    = 0,

		-- temp colors
		col = {
			active_border   = "rgba(0000ffff)",
			inactive_border = "rgba(444444ff)",
		},
	},
})

hl.window_rule({
	name = "change maximized border",
	match = {
		fullscreen_state_internal = 1,
	},

	border_color = "rgba(ff0000ff)",
})

