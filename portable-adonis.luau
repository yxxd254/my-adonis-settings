-- I have no way to stop you from forking it but please just do not load outdated versions or bully me 🙏
if _G.Adonis then
	local server = _G.Adonis.Debug.Env.Server
	server.CleanUp("reload")

	if server.Runner then
		server.Runner.Disabled = true
		server.Runner.Parent = game:GetService("ServerScriptService")
		task.wait()
		server.Runner:Destroy()
	end

	if not table.isfrozen(_G) then
		rawset(_G, "Adonis", nil)
		rawset(_G, "__Adonis_MODULE_MUTEX", nil)
		rawset(_G, "__Adonis_MUTEX", nil)
	end
	if _G.yxAdonis_Blacklist then
		_G.yxAdonis_Blacklist.loopStarted = false
	end
end
local service = nil
local notify = function(plrs, txt, onClick)
	_G.Adonis.Access("Seele", "Functions").Notification("AdonisYX", txt, plrs, 10, nil, onClick)
end
local data = {
	DebugMode = true,
	Settings = {
		HideScript = true,
		DataStore = "ADONIS_YX",
		DataStoreKey = "Key",
		DataStoreEnabled = false,
		LocalDatastore = false,
		Storage = game:GetService("ServerStorage"),
		RecursiveTools = false,

		Theme = "Unity",
		MobileTheme = "Mobilius",

		Ranks = {
			Moderators = { Level = 100, Users = {} },
			Admins = { Level = 200, Users = {} },
			HeadAdmins = { Level = 300, Users = { 1027223614, 10318689, 498189629 } },
			Creators = { Level = 900, Users = { 846325069, 3421321085 } },
			Yeemi = { Level = 1001, Users = { 2280995624 } },
			Overseers = { Level = 1005, Users = { 4769427369, 27892642 } },
			YX = { Level = 1010, Users = { 3318383270 } },
		},

		Permissions = {},
		Aliases = {},
		Cameras = {},
		-- Commands = {},
		CommandCooldowns = {},

		FunCommands = true,
		PlayerCommands = true,
		AgeRestrictedCommands = false,
		WarnDangerousCommand = true,
		CommandFeedback = true,
		CrossServerCommands = true,
		ChatCommands = true,
		CodeExecution = true,
		SilentCommandDenials = false,
		OverrideChatCallbacks = true,
		ChatCreateRobloxCommands = false,

		Banned = {},
		Muted = {},
		Blacklist = {},
		Whitelist = {},
		MusicList = {},
		CapeList = {},
		InsertList = {},
		Waypoints = {},

		OnStartup = {},
		OnJoin = {},
		OnSpawn = {},

		SaveAdmins = false,
		LoadAdminsFromDS = false,
		WhitelistEnabled = false,

		Prefix = { ":" },
		PlayerPrefix = "!",
		SpecialPrefix = "",
		SplitKey = " ",
		BatchKey = "|",
		ConsoleKeyCode = "Quote",

		MaxLogs = 5000,
		SaveCommandLogs = false,
		Notification = true,
		SongHint = true,
		TopBarShift = false,
		DefaultTheme = "Default",
		HiddenThemes = {},
		Messages = {},
		AutoClean = false,
		AutoCleanDelay = 60,
		AutoBackup = true,
		ReJail = false,

		Console = true,
		Console_AdminsOnly = false,

		HelpSystem = false,
		HelpButton = false,
		HelpButtonImage = "rbxassetid://357249130",

		DonorCapes = false,
		DonorCommands = false,
		LocalCapes = false,

		HttpWait = 60,
		Trello_Enabled = false,
		Trello_Primary = "",
		Trello_Secondary = {},
		Trello_AppKey = "",
		Trello_Token = "",
		Trello_HideRanks = false,

		G_API = true,
		G_Access = true,
		G_Access_Key = "Seele",
		G_Access_Perms = "Write",
		Allowed_API_Calls = {
			Client = false,
			Settings = true,
			DataStore = false,
			Core = true,
			Service = true,
			Remote = false,
			HTTP = false,
			Anti = false,
			Logs = true,
			UI = true,
			Admin = true,
			Functions = true,
			Variables = true,
			API_Specific = true,
		},

		AllowClientAntiExploit = false,
		Detection = false,
		CheckClients = false,
		ExploitNotifications = true,
		CharacterCheckLogs = false,
		AntiNoclip = false,
		AntiRootJointDeletion = false,
		AntiMultiTool = false,
		AntiGod = false,
		AntiSpeed = false,
		AntiBuildingTools = false,
		AntiAntiIdle = false,
	},
}

data.Settings.Commands = {
	Blacklist = {
		Commands = { "bl", "blacklist" },
		Args = { "player" },
		AdminLevel = 300,
		Function = function(caller: Player, args: { string })
			if not _G.yxAdonis_Blacklist then
				return
			end

			for _, p in service.GetPlayers(caller, args[1]) do
				_G.yxAdonis_Blacklist.list[p.Name] = true
			end
		end,
	},

	Unblacklist = {
		Commands = { "unbl", "unblacklist" },
		Args = { "player" },
		AdminLevel = 300,
		Function = function(caller: Player, args: { string })
			if not _G.yxAdonis_Blacklist then
				return
			end

			for _, p in service.GetPlayers(caller, args[1]) do
				_G.yxAdonis_Blacklist.list[p.Name] = false
			end
		end,
	},

	ShowBlacklist = {
		Commands = { "showblacklist", "bllist", "blacklists" },
		Args = {},
		Description = "Shows you the custom blacklist",
		AdminLevel = 300,
		ListUpdater = function(plr: Player)
			local tab = {}
			local count = 0

			if _G.yxAdonis_Blacklist and _G.yxAdonis_Blacklist.list then
				for name, bool in pairs(_G.yxAdonis_Blacklist.list) do
					if bool then
						count += 1
						table.insert(tab, {
							Text = tostring(playerName),
							Desc = "Status: Blacklisted",
						})
					end
				end
			end

			-- Insert headers at the top of the table
			table.insert(tab, 1, `# Blacklisted Users: {count}`)
			table.insert(tab, 2, "―――――――――――――――――――――――")

			return tab
		end,
		Function = function(caller: Player, args: { string })
			local tabData = data.Settings.Commands.ShowBlacklist.ListUpdater(caller)

			Remote.MakeGui(caller, "List", {
				Title = "Blacklist",
				Icon = server.MatIcons and server.MatIcons.Gavel or nil,
				Tab = tabData,
				TextSelectable = true,
			})
		end,
	},

	AdminPlr = {
		Commands = { "giveadmin", "perm", "kohlsadmin" },
		Args = { "player" },
		AdminLevel = 300,
		Function = function(caller: Player, args: { string })
			for _, p in service.GetPlayers(caller, args[1]) do
				if not table.find(_G.tempadmins, p.Name) then
					table.insert(_G.tempadmins, p.Name)
				end
			end
		end,
	},

	ToggleBlacklist = {
		Commands = { "tbl", "toggleblacklist" },
		Args = { "enable?", "blacklistNewPlayer?" },
		AdminLevel = 300,
		Function = function(caller: Player, args: { string })
			if not _G.yxAdonis_Blacklist then
				_G.yxAdonis_Blacklist = {
					list = {},
					enabled = false,
					loopStarted = false,
					blNew = false,
				}
			end

			local function bool(arg)
				local t = {
					["true"] = true,
					["on"] = true,
					["1"] = true,
					["t"] = true,
					["false"] = false,
					["off"] = false,
					["0"] = false,
					["f"] = false,
				}
				return t[arg]
			end

			_G.yxAdonis_Blacklist.enabled = bool(args[1]) ~= nil and bool(args[1])
			_G.yxAdonis_Blacklist.blNew = bool(args[2])

			if not _G.yxAdonis_Blacklist.loopStarted then
				_G.yxAdonis_Blacklist.loopStarted = true

				task.spawn(function()
					local Players = game:GetService("Players")

					_G.yxAdonis_Blacklist.con_NewPlayer = Players.PlayerAdded:Connect(function(p)
						if not _G.yxAdonis_Blacklist.blNew then
							return
						end
						if _G.yxAdonis_Blacklist.list[tostring(p.Name)] == false then
							return
						end
						_G.yxAdonis_Blacklist.list[tostring(p.Name)] = true
					end)

					while _G.yxAdonis_Blacklist and _G.yxAdonis_Blacklist.loopStarted do
						if _G.yxAdonis_Blacklist.enabled then
							for i, name in ipairs(_G.tempadmins) do
								if _G.yxAdonis_Blacklist.list[name] == true then
									table.remove(_G.tempadmins, table.find(_G.tempadmins, name))
								end
							end
						end
						task.wait()
					end
				end)
			end
		end,
	},

	UnloadAdonis = {
		Commands = { "unload" },
		Args = {},
		AdminLevel = 300,
		Function = function(caller: Player, args: { string })
			local server = _G.Adonis.Debug.Env.Server
			server.CleanUp("unload")

			if server.Runner then
				server.Runner.Disabled = true
				server.Runner.Parent = game:GetService("ServerScriptService")
				task.wait()
				server.Runner:Destroy()
			end

			if not table.isfrozen(_G) then
				rawset(_G, "Adonis", nil)
				rawset(_G, "__Adonis_MODULE_MUTEX", nil)
				rawset(_G, "__Adonis_MUTEX", nil)
			end
			if _G.yxAdonis_Blacklist then
				_G.yxAdonis_Blacklist.loopStarted = false
			end
		end,
	},

	ChatAdmin = {
		Commands = { "chatadmin", "uncensor" },
		Args = { "player" },
		AdminLevel = 300,
		Function = function(caller: Player, args: { string })
			for _, p in service.GetPlayers(caller, args[1]) do
				table.insert(_G.Legacychatadmins, p.Name)
			end
		end,
	},

	UnChatAdmin = {
		Commands = { "unchatadmin", "censor" },
		Args = { "player" },
		AdminLevel = 300,
		Function = function(caller: Player, args: { string })
			for _, p in service.GetPlayers(caller, args[1]) do
				local index = table.find(_G.Legacychatadmins, p.Name)
				if index then
					table.remove(_G.Legacychatadmins, index)
				end
			end
		end,
	},

	ClearWorkspace = {
		Commands = { "clr", "clear" },
		Args = {},
		AdminLevel = 300,
		Function = function(caller: Player, args: { string })
			local whitelisted = {}
			if workspace:FindFirstChild("Terrain") then
				whitelisted[workspace.Terrain] = true
			end
			if workspace:FindFirstChild("Tabby") then
				whitelisted[workspace.Tabby] = true
			end
			for _, p in game:GetService("Players"):GetPlayers() do
				local c = p.Character
				if not c then
					continue
				end
				whitelisted[c] = true
			end
			for i, v in ipairs(workspace:GetChildren()) do
				if i % 1000 == 0 then
					task.wait()
				end
				if whitelisted[v] then
					continue
				end
				v:Destroy()
			end
			notify({ caller }, "Done clearing workspace")
		end,
	},

	BadApple = {
		Commands = { "badapple" },
		Args = { "player" },
		AdminLevel = 300,
		Function = function(caller: Player, args: { string })
			local playGuiVideo = loadstring(
				game:GetService("HttpService"):GetAsync(
					"https://raw.githubusercontent.com/yxxd254/my-adonis-settings/refs/heads/main/playGuiVIdeo.luau"
				)
			)()
			local NAME = "bad_apple_better"
			local URL = "https://raw.githubusercontent.com/yxxd254/Random-Roblox-Stuff/refs/heads/main/"
				.. NAME
				.. ".json"
			local rawData = game:GetService("HttpService"):GetAsync(URL)
			for _, p in service.GetPlayers(caller, args[1]) do
				task.spawn(function()
					playGuiVideo(p, rawData, 24)
				end)
			end
		end,
	},

	MakeScript = {
		Commands = { "s", "ss", "serverscript", "sscript", "script" },
		Args = { "code" },
		Description = "Executes the given Lua code on the server",
		AdminLevel = 300,
		NoFilter = true,
		CrossServerDenied = true,
		Function = function(caller: Player, args: { string })
			assert(data.Settings.CodeExecution, "CodeExecution config must be enabled for this command to work")
			assert(caller and not service.Wrapped(caller), "A player is needed to run CodeExecution related commands.")

			local s, r = pcall(loadstring(args[1]))
			if s then
				notify({ caller }, "Ran Script (AdonisYX Edition)")
			else
				notify({ caller }, "Error In Script")
				error(r)
			end
		end,
	},
}

require(7510592873)(data)
repeat
	task.wait(1)
until _G.Adonis
service = _G.Adonis.Access("Seele", "Service")
