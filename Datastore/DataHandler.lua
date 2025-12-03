local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")

local DataStore = DataStoreService:GetDataStore("PlayerData_V1")

local DEFAULT_DATA = {
	Coins = 100,
	Gems = 0
}

local SessionData = {}

local function LoadData(player)
	local success, data = pcall(function()
		return DataStore:GetAsync(player.UserId)
	end)

	if not success or not data then
		data = table.clone(DEFAULT_DATA)
	end

	SessionData[player.UserId] = data

	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = player

	local coins = Instance.new("IntValue")
	coins.Name = "Coins"
	coins.Value = data.Coins
	coins.Parent = leaderstats

	local gems = Instance.new("IntValue")
	gems.Name = "Gems"
	gems.Value = data.Gems
	gems.Parent = leaderstats

	coins:GetPropertyChangedSignal("Value"):Connect(function()
		SessionData[player.UserId].Coins = coins.Value
	end)

	gems:GetPropertyChangedSignal("Value"):Connect(function()
		SessionData[player.UserId].Gems = gems.Value
	end)
end

local function SaveData(player)
	local data = SessionData[player.UserId]
	if not data then return end

	pcall(function()
		DataStore:SetAsync(player.UserId, data)
	end)
end

Players.PlayerAdded:Connect(LoadData)
Players.PlayerRemoving:Connect(SaveData)

game:BindToClose(function()
	for _, player in ipairs(Players:GetPlayers()) do
		SaveData(player)
	end
end)
