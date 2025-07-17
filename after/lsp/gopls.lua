return {
  settings = {
    telemetry = {
      enable = false,
    },
    gopls = {
      hints = {
        rangeVariableTypes = true,
        parameterNames = true,
        constantValues = true,
        assignVariableTypes = true,
        compositeLiteralFields = true,
        compositeLiteralTypes = true,
        functionTypeParameters = true,
      },
      analyses = {
        unusedparams = true,
        shadow = false, -- Detects variable shadowing
        nilness = true, -- Detects issues with nil checks
        unusedwrite = true, -- Detects assignments to unused variables
        undeclaredname = true, -- Detects undeclared variables
        copylocks = true,
        loopclosure = true,
        nilfunc = true,
        printf = true,
      },
      -- codelenses = {
      -- 	gc_details = true, -- Display the garbage collector choices
      -- 	generate = true, -- Show the "go generate" lens for generating code
      -- 	regenerate_cgo = true, -- Show the "regenerate cgo" lens
      -- 	tidy = true, -- Show the "go mod tidy" lens
      -- 	upgrade_dependency = true, -- Upgrade dependencies
      -- 	test = true, -- Run tests directly in the editor
      -- },
      staticcheck = true,
      directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
      diagnosticsDelay = "500ms", -- Reduces the delay for diagnostics to appear
      usePlaceholders = true,
      completeUnimported = true,
    },
  },
}
