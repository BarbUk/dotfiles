-- Display & search
yay.opt.bottom_up = true
yay.opt.sort_by = "votes"
yay.opt.search_by = "name-desc"
yay.opt.single_line_results = false
yay.opt.separate_sources = true

-- Build behavior
yay.opt.clean_after = true
yay.opt.clean_menu = false
yay.opt.diff_menu = true
yay.opt.edit_menu = false
yay.opt.remove_make = "yes"
yay.opt.batch_install = true
yay.opt.devel = true
yay.opt.provides = true
yay.opt.combined_upgrade = true

-- Performance
yay.opt.max_concurrent_downloads = 5
yay.opt.request_split_n = 150

-- Editor
yay.opt.editor = os.getenv("EDITOR") or "vim"
