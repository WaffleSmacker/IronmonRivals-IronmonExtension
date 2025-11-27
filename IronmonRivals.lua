local function IronmonRivals()
	local self = {
		version = "1.2",
		name = "Ironmon Rivals",
		author = "WaffleSmacker",
		description = "Created for Ironmon Rivals. Used to send data to the website.",
		github = "WaffleSmacker/IronmonRivals-IronmonExtension",
	}

	self.url = string.format("https://github.com/%s", self.github)

	-- Data output file path
	self.DATA_OUTPUT_FILE = "ironmon_data.json"

	self.Paths = {
		DataOutput = "",
	}

	-- Milestone order from lowest to highest
	self.MILESTONE_ORDER = {
		"lab",
		"brock",
		"misty", 
		"surge",
		"erika",
		"koga",
		"sabrina",
		"blaine",
		"giovanni",
		"lorelei",
		"bruno",
		"agatha",
		"lance",
		"champ"
	}

	self.MILESTONE_NAMES = {
		lab = "Lab",
		brock = "Brock",
		misty = "Misty",
		surge = "Lt. Surge", 
		erika = "Erika",
		koga = "Koga",
		sabrina = "Sabrina",
		blaine = "Blaine",
		giovanni = "Giovanni",
		lorelei = "Lorelei",
		bruno = "Bruno",
		agatha = "Agatha",
		lance = "Lance",
		champ = "Champion"
	}

	-- Function to escape JSON strings
	local function escapeJson(str)
		if not str then return "" end
		str = tostring(str)
		str = string.gsub(str, "\\", "\\\\")
		str = string.gsub(str, '"', '\\"')
		str = string.gsub(str, "\n", "\\n")
		str = string.gsub(str, "\r", "\\r")
		str = string.gsub(str, "\t", "\\t")
		return str
	end

	-- Function to write data to JSON file
	local function writeDataToFile(data)
		local file = io.open(self.Paths.DataOutput, "w")
		if not file then
			return false, "Failed to open data file for writing"
		end
		
		-- Build JSON object
		local jsonContent = "{\n"
		jsonContent = jsonContent .. '  "seedNumber": ' .. tostring(data.seedNumber) .. ",\n"
		jsonContent = jsonContent .. '  "playTime": "' .. escapeJson(data.playTime) .. '",\n'
		jsonContent = jsonContent .. '  "currentDate": "' .. escapeJson(data.currentDate) .. '",\n'
		jsonContent = jsonContent .. '  "pokemonName": "' .. escapeJson(data.pokemonName) .. '",\n'
		jsonContent = jsonContent .. '  "pokemonID": ' .. tostring(data.pokemonID) .. ",\n"
		jsonContent = jsonContent .. '  "nickname": "' .. escapeJson(data.nickname or "") .. '",\n'
		jsonContent = jsonContent .. '  "type_1": "' .. escapeJson(data.type_1) .. '",\n'
		jsonContent = jsonContent .. '  "type_2": "' .. escapeJson(data.type_2) .. '",\n'
		jsonContent = jsonContent .. '  "level": ' .. tostring(data.level) .. ",\n"
		jsonContent = jsonContent .. '  "hp": ' .. tostring(data.hp) .. ",\n"
		jsonContent = jsonContent .. '  "atk": ' .. tostring(data.atk) .. ",\n"
		jsonContent = jsonContent .. '  "def": ' .. tostring(data.def) .. ",\n"
		jsonContent = jsonContent .. '  "spa": ' .. tostring(data.spa) .. ",\n"
		jsonContent = jsonContent .. '  "spd": ' .. tostring(data.spd) .. ",\n"
		jsonContent = jsonContent .. '  "spe": ' .. tostring(data.spe) .. ",\n"
		jsonContent = jsonContent .. '  "abilityName": "' .. escapeJson(data.abilityName) .. '",\n'
		jsonContent = jsonContent .. '  "move_1": "' .. escapeJson(data.move_1) .. '",\n'
		jsonContent = jsonContent .. '  "move_2": "' .. escapeJson(data.move_2) .. '",\n'
		jsonContent = jsonContent .. '  "move_3": "' .. escapeJson(data.move_3) .. '",\n'
		jsonContent = jsonContent .. '  "move_4": "' .. escapeJson(data.move_4) .. '",\n'
		jsonContent = jsonContent .. '  "milestone": "' .. escapeJson(data.milestone or "none") .. '",\n'
		jsonContent = jsonContent .. '  "isOngoingRun": ' .. tostring(data.isOngoingRun) .. ",\n"
		jsonContent = jsonContent .. '  "favoritePokemon": "' .. escapeJson(data.favoritePokemon or "None") .. '",\n'
		jsonContent = jsonContent .. '  "trainersDefeated": ' .. tostring(data.trainerCount or 0) .. ",\n"
		jsonContent = jsonContent .. '  "beat_lab": ' .. tostring(data.beat_lab) .. ",\n"
		jsonContent = jsonContent .. '  "beat_brock": ' .. tostring(data.beat_brock) .. ",\n"
		jsonContent = jsonContent .. '  "beat_misty": ' .. tostring(data.beat_misty) .. ",\n"
		jsonContent = jsonContent .. '  "beat_surge": ' .. tostring(data.beat_surge) .. ",\n"
		jsonContent = jsonContent .. '  "beat_erika": ' .. tostring(data.beat_erika) .. ",\n"
		jsonContent = jsonContent .. '  "beat_koga": ' .. tostring(data.beat_koga) .. ",\n"
		jsonContent = jsonContent .. '  "beat_sabrina": ' .. tostring(data.beat_sabrina) .. ",\n"
		jsonContent = jsonContent .. '  "beat_blaine": ' .. tostring(data.beat_blaine) .. ",\n"
		jsonContent = jsonContent .. '  "beat_giovanni": ' .. tostring(data.beat_giovanni) .. ",\n"
		jsonContent = jsonContent .. '  "beat_lorelei": ' .. tostring(data.beat_lorelei) .. ",\n"
		jsonContent = jsonContent .. '  "beat_bruno": ' .. tostring(data.beat_bruno) .. ",\n"
		jsonContent = jsonContent .. '  "beat_agatha": ' .. tostring(data.beat_agatha) .. ",\n"
		jsonContent = jsonContent .. '  "beat_lance": ' .. tostring(data.beat_lance) .. ",\n"
		jsonContent = jsonContent .. '  "beat_champ": ' .. tostring(data.beat_champ) .. ",\n"
		jsonContent = jsonContent .. '  "trainerCount": ' .. tostring(data.trainerCount or 0) .. ",\n"
		jsonContent = jsonContent .. '  "badgeCount": ' .. tostring(data.badgeCount or 0) .. ",\n"
		jsonContent = jsonContent .. '  "routeName": "' .. escapeJson(data.routeName or "Unknown Area") .. '"\n'
		jsonContent = jsonContent .. "}"
		
		file:write(jsonContent)
		file:close()
		return true, ""
	end

	------------------------------------ Data Tracking Section ------------------------------------
	local function getTotalDefeatedTrainers(includeSevii)
		includeSevii = includeSevii or false
		local saveBlock1Addr = Utils.getSaveBlock1Addr()
		local totalDefeated = 0

		for mapId, route in pairs(RouteData.Info or {}) do
			if mapId and (mapId < 230 or includeSevii) then
				if route.trainers and #route.trainers > 0 then
					local defeatedTrainers = Program.getDefeatedTrainersByLocation(mapId, saveBlock1Addr)
					if type(defeatedTrainers) == "table" then
						totalDefeated = totalDefeated + #defeatedTrainers
					end
				end
			end
		end

		return totalDefeated
	end
	local function getPokemonOrDefault(input)
		local id
		if not Utils.isNilOrEmpty(input, true) then
			id = DataHelper.findPokemonId(input)
		else
			local pokemon = Tracker.getPokemon(1, true) or {}
			id = pokemon.pokemonID
		end
		return PokemonData.Pokemon[id or false]
	end

	-- Get favorite Pokemon name from StreamerScreen button (first favorite only)
	local function getFavoritePokemonName()
		local faveButton = StreamerScreen.Buttons.PokemonFavorite1
		
		if faveButton and faveButton.pokemonID and PokemonData.isValid(faveButton.pokemonID) then
			return PokemonData.Pokemon[faveButton.pokemonID].name
		else
			return "None"
		end
	end

	-- Get the highest milestone achieved
	local function getHighestMilestone()
		local beat_lab = Program.hasDefeatedTrainer(326) or Program.hasDefeatedTrainer(327) or Program.hasDefeatedTrainer(328)
		local beat_brock = Program.hasDefeatedTrainer(414)
		local beat_misty = Program.hasDefeatedTrainer(415)
		local beat_surge = Program.hasDefeatedTrainer(416)
		local beat_erika = Program.hasDefeatedTrainer(417)
		local beat_koga = Program.hasDefeatedTrainer(418)
		local beat_sabrina = Program.hasDefeatedTrainer(420)
		local beat_blaine = Program.hasDefeatedTrainer(419)
		local beat_giovanni = Program.hasDefeatedTrainer(350)
		local beat_lorelei = Program.hasDefeatedTrainer(410)
		local beat_bruno = Program.hasDefeatedTrainer(411)
		local beat_agatha = Program.hasDefeatedTrainer(412)
		local beat_lance = Program.hasDefeatedTrainer(413)
		local beat_champ = Program.hasDefeatedTrainer(438) or Program.hasDefeatedTrainer(439) or Program.hasDefeatedTrainer(440)

		local milestones = {
			lab = beat_lab,
			brock = beat_brock,
			misty = beat_misty,
			surge = beat_surge,
			erika = beat_erika,
			koga = beat_koga,
			sabrina = beat_sabrina,
			blaine = beat_blaine,
			giovanni = beat_giovanni,
			lorelei = beat_lorelei,
			bruno = beat_bruno,
			agatha = beat_agatha,
			lance = beat_lance,
			champ = beat_champ
		}

		-- Find the highest milestone achieved
		local highestMilestone = nil
		for i = #self.MILESTONE_ORDER, 1, -1 do
			local milestone = self.MILESTONE_ORDER[i]
			if milestones[milestone] then
				highestMilestone = milestone
				break
			end
		end

		return highestMilestone, milestones
	end

	-- Simplified data collection function
	local function collectSimplifiedData(pokemon)
		local info = {}
		if not PokemonData.isValid(pokemon.pokemonID) then
			return info
		end

		local seedNumber = Main.currentSeed
		local playTime = Program.GameTimer:getText()
		local currentDate = os.date("%Y-%m-%d")
		local pokemonName = PokemonData.Pokemon[pokemon.pokemonID].name or "Unknown Pokemon"
		local abilityName = AbilityData.Abilities[PokemonData.getAbilityId(pokemon.pokemonID, pokemon.abilityNum)].name
		local type_1 = getPokemonOrDefault(pokemon.PokemonId).types[1]
		local type_2 = getPokemonOrDefault(pokemon.PokemonId).types[2]
		local move_1 = MoveData.Moves[pokemon.moves[1].id].name
		local move_2 = MoveData.Moves[pokemon.moves[2].id].name
		local move_3 = MoveData.Moves[pokemon.moves[3].id].name
		local move_4 = MoveData.Moves[pokemon.moves[4].id].name

		local highestMilestone, allMilestones = getHighestMilestone()
		local favoritePokemon = getFavoritePokemonName()
		local trainerCount = getTotalDefeatedTrainers(false)
		
		-- Get current route name
		local routeName = RouteData.Info[TrackerAPI.getMapId()].name or "Unknown Area"

		-- Calculate badge count (badges are earned from brock through giovanni)
		local badgeCount = 0
		if allMilestones.brock then badgeCount = badgeCount + 1 end
		if allMilestones.misty then badgeCount = badgeCount + 1 end
		if allMilestones.surge then badgeCount = badgeCount + 1 end
		if allMilestones.erika then badgeCount = badgeCount + 1 end
		if allMilestones.koga then badgeCount = badgeCount + 1 end
		if allMilestones.sabrina then badgeCount = badgeCount + 1 end
		if allMilestones.blaine then badgeCount = badgeCount + 1 end
		if allMilestones.giovanni then badgeCount = badgeCount + 1 end

		-- Determine if run is ongoing: True if Pokemon is alive AND champ is not beaten
		local hpPercentage = (pokemon.curHP or 0) / (pokemon.stats.hp or 100)
		local isPokemonAlive = hpPercentage > 0
		local champBeaten = allMilestones.champ or false
		local isOngoingRun = isPokemonAlive and not champBeaten

		-- Build data structure
		info.seedNumber = seedNumber
		info.playTime = playTime
		info.currentDate = currentDate
		info.pokemonName = pokemonName
		info.pokemonID = pokemon.pokemonID
		info.nickname = pokemon.nickname or ""
		info.type_1 = type_1
		info.type_2 = type_2
		info.level = pokemon.level
		info.hp = pokemon.stats.hp or 0
		info.atk = pokemon.stats.atk or 0
		info.def = pokemon.stats.def or 0
		info.spa = pokemon.stats.spa or 0
		info.spd = pokemon.stats.spd or 0
		info.spe = pokemon.stats.spe or 0
		info.abilityName = abilityName
		info.move_1 = move_1
		info.move_2 = move_2
		info.move_3 = move_3
		info.move_4 = move_4
		info.milestone = highestMilestone
		info.isOngoingRun = isOngoingRun
		info.favoritePokemon = favoritePokemon

		-- Add all milestone data
		info.beat_lab = allMilestones.lab
		info.beat_brock = allMilestones.brock
		info.beat_misty = allMilestones.misty
		info.beat_surge = allMilestones.surge
		info.beat_erika = allMilestones.erika
		info.beat_koga = allMilestones.koga
		info.beat_sabrina = allMilestones.sabrina
		info.beat_blaine = allMilestones.blaine
		info.beat_giovanni = allMilestones.giovanni
		info.beat_lorelei = allMilestones.lorelei
		info.beat_bruno = allMilestones.bruno
		info.beat_agatha = allMilestones.agatha
		info.beat_lance = allMilestones.lance
		info.beat_champ = allMilestones.champ
		info.trainerCount = trainerCount
		info.badgeCount = badgeCount
		info.routeName = routeName

		return info
	end

	self.PerSeedVars = {
		PokemonDead = false,
		LastMilestone = nil,
		FirstPokemonChosen = false,
		LastTrainerCount = 0,
		BeatTrainer102 = false,
		BeatTrainer329 = false,
	}

	function self.getHpPercent()
		local leadPokemon = Tracker.getPokemon(1, true) or Tracker.getDefaultPokemon()
		if PokemonData.isValid(leadPokemon.pokemonID) then
			return (leadPokemon.curHP or 0) / (leadPokemon.stats.hp or 100)
		end
	end
	
	function self.resetSeedVars()
		local V = self.PerSeedVars
		V.PokemonDead = false
		V.LastMilestone = nil
		V.FirstPokemonChosen = false
		V.LastTrainerCount = 0
		V.BeatTrainer102 = false
		V.BeatTrainer329 = false
	end

	local loadedVarsThisSeed
	local function isPlayingFRLG() return GameSettings.game == 3 end

	-- Check for first pokemon choice and write data to file
	local function checkForFirstPokemonChoice()
		if not Program.isValidMapLocation() then
			return
		end
		
		local leadPokemon = Tracker.getPokemon(1, true) or Tracker.getDefaultPokemon()
		if not PokemonData.isValid(leadPokemon.pokemonID) then
			return
		end

		local V = self.PerSeedVars

		-- Check if this is the first pokemon chosen (only trigger once)
		if not V.FirstPokemonChosen then
			local data = collectSimplifiedData(leadPokemon)
			writeDataToFile(data)
			V.FirstPokemonChosen = true
		end
	end

	-- Check for milestone changes and write data to file
	local function checkForMilestoneUpdate()
		if not Program.isValidMapLocation() then
			return
		end
		
		local leadPokemon = Tracker.getPokemon(1, true) or Tracker.getDefaultPokemon()
		if not PokemonData.isValid(leadPokemon.pokemonID) then
			return
		end

		local V = self.PerSeedVars
		
		-- Don't send updates if the Pokemon has died
		if V.PokemonDead then
			return
		end

		local currentMilestone = getHighestMilestone()

		-- If milestone changed, send notification
		if currentMilestone and currentMilestone ~= V.LastMilestone then
			local data = collectSimplifiedData(leadPokemon)
			writeDataToFile(data)
			V.LastMilestone = currentMilestone
			-- Update trainer count when milestone changes
			V.LastTrainerCount = data.trainerCount or 0
		end
	end

	-- Check for trainer count updates (every 5 trainers after Brock milestone)
	local function checkForTrainerCountUpdate()
		if not Program.isValidMapLocation() then
			return
		end
		
		local leadPokemon = Tracker.getPokemon(1, true) or Tracker.getDefaultPokemon()
		if not PokemonData.isValid(leadPokemon.pokemonID) then
			return
		end

		local V = self.PerSeedVars
		
		-- Don't send updates if the Pokemon has died
		if V.PokemonDead then
			return
		end

		-- Only track trainer count updates after Brock milestone
		local currentMilestone = getHighestMilestone()
		if not currentMilestone then
			return
		end

		-- Check if milestone is past Brock (brock is at index 2, so we need index > 2)
		local milestoneIndex = nil
		for i, milestone in ipairs(self.MILESTONE_ORDER) do
			if milestone == currentMilestone then
				milestoneIndex = i
				break
			end
		end

		-- Only update if milestone is past Brock (index > 2, since lab=1, brock=2)
		if not milestoneIndex or milestoneIndex <= 1 then
			return
		end

		-- Get current trainer count
		local currentTrainerCount = getTotalDefeatedTrainers(false)
		
		-- Check if we've crossed a multiple of 5 trainers
		local lastMultiple = math.floor(V.LastTrainerCount / 5)
		local currentMultiple = math.floor(currentTrainerCount / 5)
		
		if currentMultiple > lastMultiple then
			-- Trainer count crossed a multiple of 5, send update
			local data = collectSimplifiedData(leadPokemon)
			writeDataToFile(data)
			V.LastTrainerCount = currentTrainerCount
		elseif currentTrainerCount > V.LastTrainerCount then
			-- Update last trainer count even if we don't send update
			V.LastTrainerCount = currentTrainerCount
		end
	end

	-- Check for trainer 102 defeat and send update
	local function checkForTrainer102Update()
		if not Program.isValidMapLocation() then
			return
		end
		
		local leadPokemon = Tracker.getPokemon(1, true) or Tracker.getDefaultPokemon()
		if not PokemonData.isValid(leadPokemon.pokemonID) then
			return
		end

		local V = self.PerSeedVars
		
		-- Don't send updates if the Pokemon has died
		if V.PokemonDead then
			return
		end

		-- Check if trainer 102 has been defeated
		local beatTrainer102 = Program.hasDefeatedTrainer(102)
		
		if beatTrainer102 and not V.BeatTrainer102 then
			-- Trainer 102 just defeated, send update
			local data = collectSimplifiedData(leadPokemon)
			writeDataToFile(data)
			V.BeatTrainer102 = true
		end
	end

	-- Check for trainer 329, 330, or 331 defeat and send update
	local function checkForTrainer329Update()
		if not Program.isValidMapLocation() then
			return
		end
		
		local leadPokemon = Tracker.getPokemon(1, true) or Tracker.getDefaultPokemon()
		if not PokemonData.isValid(leadPokemon.pokemonID) then
			return
		end

		local V = self.PerSeedVars
		
		-- Don't send updates if the Pokemon has died
		if V.PokemonDead then
			return
		end

		-- Check if trainer 329, 330, or 331 has been defeated
		local beatTrainer329 = Program.hasDefeatedTrainer(329) or Program.hasDefeatedTrainer(330) or Program.hasDefeatedTrainer(331)
		
		if beatTrainer329 and not V.BeatTrainer329 then
			-- Trainer 329/330/331 just defeated, send update
			local data = collectSimplifiedData(leadPokemon)
			writeDataToFile(data)
			V.BeatTrainer329 = true
		end
	end

	-- Executed once every 30 frames, after most data from game memory is read in
	function self.afterProgramDataUpdate()
		-- Once per seed, when the player is able to move their character, initialize the seed variables
		if not isPlayingFRLG() or not Program.isValidMapLocation() then
			return
		elseif not loadedVarsThisSeed then
			self.resetSeedVars()
			loadedVarsThisSeed = true
			
			-- Check if player has milestone progress to set LastMilestone and LastTrainerCount
			local leadPokemon = Tracker.getPokemon(1, true) or Tracker.getDefaultPokemon()
			if PokemonData.isValid(leadPokemon.pokemonID) then
				local currentMilestone = getHighestMilestone()
				local V = self.PerSeedVars
				if currentMilestone then
					V.LastMilestone = currentMilestone
					-- Initialize trainer count
					V.LastTrainerCount = getTotalDefeatedTrainers(false)
				end
				-- Initialize trainer defeat tracking
				V.BeatTrainer102 = Program.hasDefeatedTrainer(102)
				V.BeatTrainer329 = Program.hasDefeatedTrainer(329) or Program.hasDefeatedTrainer(330) or Program.hasDefeatedTrainer(331)
			end
		end

		local V = self.PerSeedVars
		local leadPokemon = Tracker.getPokemon(1, true) or Tracker.getDefaultPokemon()

		-- Check for first pokemon choice
		checkForFirstPokemonChoice()

		-- Check for milestone updates
		checkForMilestoneUpdate()

		-- Check for trainer count updates (every 5 trainers after Brock)
		checkForTrainerCountUpdate()

		-- Check for trainer 102 defeat
		checkForTrainer102Update()

		-- Check for trainer 329/330/331 defeat
		checkForTrainer329Update()

		-- Lead Pokemon Died - send final data
		if Program.isValidMapLocation() then
			local hpPercentage = self.getHpPercent()
			if hpPercentage ~= nil and hpPercentage == 0 and V.PokemonDead == false then
				V.PokemonDead = true
				local data = collectSimplifiedData(leadPokemon)
				writeDataToFile(data)
			end
		end
	end

	-- Executed only once: When the extension is enabled by the user, and/or when the Tracker first starts up, after it loads all other required files and code
	function self.startup()
		-- Build out paths to files within the extension folder
		local extFolderPath = FileManager.getCustomFolderPath() .. "IronmonRivals" .. FileManager.slash
		self.Paths.DataOutput = extFolderPath .. self.DATA_OUTPUT_FILE
		
		-- Create extension folder if it doesn't exist
		os.execute("mkdir \"" .. extFolderPath .. "\" 2>nul")
		
		-- Initialize data file with empty JSON object
		local file = io.open(self.Paths.DataOutput, "w")
		if file then
			file:write("{}")
			file:close()
		end
	end

	-- Executed only once: When the extension is disabled by the user, necessary to undo any customizations, if able
	function self.unload()
		-- Nothing to clean up
	end

	return self
end
return IronmonRivals
