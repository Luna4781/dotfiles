Name = "wallpapers"
NamePretty = "Wallpapers"
HideFromProviderlist = true
Cache = false

function SetWallpaper(value)
	os.execute("ln -nsf '" .. value .. "' ~/.local/share/dotfiles/current/background")
	os.execute("swww img '" .. value .. "' --transition-type fade --transition-duration 1")
end

function GetEntries()
	local entries = {}
	local home = os.getenv("HOME") or ""
	local wallpapers_dir = home .. "/.local/share/dotfiles/current/theme/backgrounds"

	local handle = io.popen(
		"find '"
			.. wallpapers_dir
			.. "' -maxdepth 1 -type f \\( -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.webp' -o -iname '*.gif' \\) | sort"
	)

	if handle then
		for line in handle:lines() do
			local filename = line:match("([^/]+)$")

			if filename then
				table.insert(entries, {
					Text = filename:gsub("%.[^.]+$", ""),
					Value = line,
					Preview = line,
					PreviewType = "file",
					Actions = {
						apply = "lua:SetWallpaper",
					},
				})
			end
		end
		handle:close()
	end

	return entries
end
