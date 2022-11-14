# r-term

# Building the project.

Install rojo 7+ and run `rojo build -o CLI.exe`

# Running the project.

To run the project you can use this script
```lua
local rbxmSuite = loadstring(game:HttpGetAsync("https://github.com/richie0866/rbxm-suite/releases/latest/download/rbxm-suite.lua"))()

rbxmSuite.launch("path/to.rbxm", {
	runscripts = true,
	deferred = true,
	nocache = false,
	nocirculardeps = true,
	debug = false,
	verbose = false,
})
```
