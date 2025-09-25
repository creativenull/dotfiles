PaperWM = hs.loadSpoon("PaperWM")

PaperWM.window_filter:rejectApp("Finder")
PaperWM.window_filter:rejectApp("Picture in Picture")
PaperWM.window_filter:rejectApp("qemu-system-aarch64")
PaperWM.window_filter:setScreens({ "Built%-in Retina Display" })

PaperWM.window_gap = 10
PaperWM.window_ratios = { 0.38195, 0.5, 0.61804 }

PaperWM:bindHotkeys(PaperWM.default_hotkeys)

local actions = PaperWM.actions.actions()
hs.hotkey.bind({ "alt", "cmd" }, ",", actions.focus_left)
hs.hotkey.bind({ "alt", "cmd" }, ".", actions.focus_right)
hs.hotkey.bind({ "alt", "cmd", "shift" }, ",", actions.swap_left)
hs.hotkey.bind({ "alt", "cmd", "shift" }, ".", actions.swap_right)

PaperWM:start()
