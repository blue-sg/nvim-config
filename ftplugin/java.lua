local config = {
	cmd = {vim.fn.expand('~/.local/share/nvim/mason/bin/jdtls')},
	root_dir = vim.fs.dirname(vim.fs.find({'gradlew','.git','mvnw'},{upward = true})[1]),
}
require('jdtls').start_or_attach(config)-- Enable DAP for Java
jdtls.setup_dap()  -- this sets dap.adapters.java and dap.configurations.java automatically

-- Optional: set a default main class to avoid being prompted

