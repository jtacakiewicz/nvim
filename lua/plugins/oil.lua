local status, oil = pcall(require, "oil")
if not status then return end
oil.setup({
	columns = {
		"icon",
		"permissions",
		"size",
	},
	keymaps = {
		["g?"] = "actions.show_help",
		["<CR>"] = "actions.select",
		["<C-]>"] = "actions.select_vsplit",
		-- ["<C-0>"] = "actions.select_split",
		-- ["<C-0>"] = "actions.select_tab",
		["<C-p>"] = "actions.preview",
		["_"] = "actions.close",
		["<C-c>"] = { "actions.close", mode = "n" },
		["<C-0>"] = "actions.refresh",
		["-"] = "actions.parent",
		["gd"] = "actions.open_cwd",
		["`"] = "actions.cd",
		["~"] = "actions.tcd",
		["gs"] = "actions.change_sort",
		["gx"] = "actions.open_external",
		["g."] = "actions.toggle_hidden",
		["g\\"] = "actions.toggle_trash",
	},
	use_default_keymaps = false,
	watch_for_changes = true,
	preview_split = "right",
	skip_confirm_for_simple_edits = true,
})
