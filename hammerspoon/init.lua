PaperWM = hs.loadSpoon("PaperWM")

PaperWM.window_filter:rejectApp("Finder")
PaperWM.window_filter:rejectApp("qemu-system-aarch64")
PaperWM.window_gap = 14
PaperWM.window_ratios = { 0.38195, 0.5, 0.61804 }

PaperWM:bindHotkeys(PaperWM.default_hotkeys)

hs.hotkey.bind({ "alt", "cmd" }, ",", PaperWM.actions.focus_left)
hs.hotkey.bind({ "alt", "cmd" }, ".", PaperWM.actions.focus_right)
hs.hotkey.bind({ "alt", "cmd", "shift" }, ",", PaperWM.actions.swap_left)
hs.hotkey.bind({ "alt", "cmd", "shift" }, ".", PaperWM.actions.swap_right)

PaperWM:start()
