local mainMod = "SUPER"

local terminal = "ghostty"
local browser  = "firefox"

local arrows = {"left", "right", "up", "down"}

hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(browser))

hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))
hl.bind(mainMod .. " + W", hl.dsp.window.close())
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }))
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))

-- Move focus ( mainMod + arrows )
-- Swap window ( mainMod + SHIFT + arrows )
for i = 1, #arrows do
	local arrow = arrows[i]
	hl.bind(mainMod .. " + " .. arrow,  hl.dsp.focus({ direction = arrow }))
	hl.bind(mainMod .. " + SHIFT + " .. arrow,  hl.dsp.window.swap({ direction = arrow }))
end

-- Switch workspaces ( mainMod + [0-9] )
-- Move window to workspace ( mainMod + SHIFT + [0-9] )
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key,             hl.dsp.focus({ workspace = i}))
    hl.bind(mainMod .. " + SHIFT + " .. key,     hl.dsp.window.move({ workspace = i }))
end

-- Move/resize window (mainMod + LMB/RMB)
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

