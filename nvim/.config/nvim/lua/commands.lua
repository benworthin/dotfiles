-- Singlequotes: Wraps each line with single quotes and adds a comma
vim.api.nvim_create_user_command("Singlequotes", [[:%s/^\(.\+\)$/'\1',/g]], {})

-- Doublequotes: Wraps each line with double quotes and adds a comma
vim.api.nvim_create_user_command("Doublequotes", [[:%s/^\(.\+\)$/"\1",/g]], {})

-- Minify: Pipe the whole file through jq -c
vim.api.nvim_create_user_command("Minify", [[:%!jq -c]], {})

-- Pretty: Pipe the whole file through jq for pretty output
vim.api.nvim_create_user_command("Pretty", [[:%!jq]], {})
