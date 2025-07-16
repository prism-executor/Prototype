--! json library and SHA256 digest library (unchanged)
local a = 2^32; local b = a - 1;

local function c(d, e)
    local f, g = 0, 1;
    while d ~= 0 or e ~= 0 do
        local h, i = d % 2, e % 2;
        local j = (h + i) % 2;
        f = f + j * g;
        d = math.floor(d / 2)
        e = math.floor(e / 2)
        g = g * 2
    end
    return f % a
end

local function k(d, e, l, ...)
    local m;
    if e then
        d = d % a;
        e = e % a;
        m = c(d, e);
        if l then m = k(m, l, ...) end;
        return m
    elseif d then
        return d % a
    else
        return 0
    end
end

local function n(d, e, l, ...)
    local m;
    if e then
        d = d % a;
        e = e % a;
        m = (d + e - c(d, e)) / 2;
        if l then m = n(m, l, ...) end;
        return m
    elseif d then
        return d % a
    else
        return b
    end
end

local function o(p)
    return b - p
end

local function q(d, r)
    if r < 0 then
        return lshift(d, -r)
    end
    return math.floor(d % 2^32 / 2^r)
end

local function s(p, r)
    if r > 31 or r < -31 then return 0 end
    return q(p % a, r)
end

local function lshift(d, r)
    if r < 0 then return s(d, -r) end
    return d * 2^r % 2^32
end

local function t(p, r)
    p = p % a;
    r = r % 32;
    local u = n(p, 2^r - 1)
    return s(p, r) + lshift(u, 32 - r)
end

local v = {
    0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5,
    0x3956c25b, 0x59f111f1, 0x923f82a4, 0xab1c5ed5,
    0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3,
    0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174,
    0xe49b69c1, 0xefbe4786, 0x0fc19dc6, 0x240ca1cc,
    0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da,
    0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7,
    0xc6e00bf3, 0xd5a79147, 0x06ca6351, 0x14292967,
    0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13,
    0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85,
    0xa2bfe8a1, 0xa81a664b, 0xc24b8b70, 0xc76c51a3,
    0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070,
    0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5,
    0x391c0cb3, 0x4ed8aa4a, 0x5b9cca4f, 0x682e6ff3,
    0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208,
    0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2
}

local function w(x)
    return string.gsub(x, ".", function(l) return string.format("%02x", string.byte(l)) end)
end

local function y(z, A)
    local x = ""
    for B = 1, A do
        local C = z % 256;
        x = string.char(C) .. x;
        z = (z - C) / 256;
    end
    return x
end

local function D(x, B)
    local A = 0
    for B = B, B + 3 do
        A = A * 256 + string.byte(x, B)
    end
    return A
end

local function E(F, G)
    local H = 64 - (G + 9) % 64
    G = y(8 * G, 8)
    F = F .. "\128" .. string.rep("\0", H) .. G
    assert(#F % 64 == 0)
    return F
end

local function I(J)
    J[1] = 0x6a09e667; J[2] = 0xbb67ae85; J[3] = 0x3c6ef372; J[4] = 0xa54ff53a;
    J[5] = 0x510e527f; J[6] = 0x9b05688c; J[7] = 0x1f83d9ab; J[8] = 0x5be0cd19;
    return J
end

local function K(F, B, J)
    local L = {}
    for M = 1, 16 do
        L[M] = D(F, B + (M - 1) * 4)
    end
    for M = 17, 64 do
        local N = L[M - 15]
        local O = k(t(N, 7), t(N, 18), s(N, 3))
        N = L[M - 2]
        L[M] = (L[M - 16] + O + L[M - 7] + k(t(N, 17), t(N, 19), s(N, 10))) % a
    end

    local d, e, l, P, Q, R, S, T = J[1], J[2], J[3], J[4], J[5], J[6], J[7], J[8]

    for B = 1, 64 do
        local O = k(t(d, 2), t(d, 13), t(d, 22))
        local U = k(n(d, e), n(d, l), n(e, l))
        local V = (O + U) % a
        local W = k(t(Q, 6), t(Q, 11), t(Q, 25))
        local X = k(n(Q, R), n(o(Q), S))
        local Y = (T + W + X + v[B] + L[B]) % a
        T = S; S = R; R = Q; Q = (P + Y) % a; P = l; l = e; e = d;
        d = (Y + V) % a
    end

    J[1] = (J[1] + d) % a
    J[2] = (J[2] + e) % a
    J[3] = (J[3] + l) % a
    J[4] = (J[4] + P) % a
    J[5] = (J[5] + Q) % a
    J[6] = (J[6] + R) % a
    J[7] = (J[7] + S) % a
    J[8] = (J[8] + T) % a
end

local function Z(F)
    F = E(F, #F)
    local J = I({})
    for B = 1, #F, 64 do
        K(F, B, J)
    end
    return w(y(J[1], 4) .. y(J[2], 4) .. y(J[3], 4) .. y(J[4], 4) .. y(J[5], 4) .. y(J[6], 4) .. y(J[7], 4) .. y(J[8], 4))
end

-- JSON Encode / Decode
local e; local lEncode, lDecode

do
    local l = {
        ["\\"] = "\\", ["\""] = "\"", ["\b"] = "b", ["\f"] = "f", ["\n"] = "n", ["\r"] = "r", ["\t"] = "t"
    }
    local P = { ["/"] = "/" }
    for Q, R in pairs(l) do P[R] = Q end

    local function S(T)
        return "\\" .. (l[T] or string.format("u%04x", T:byte()))
    end

    local function B(M) return "null" end

    local function v(M, z)
        local _ = {}
        z = z or {}
        if z[M] then error("circular reference") end
        z[M] = true

        if rawget(M, 1) ~= nil or next(M) == nil then
            local A = 0
            for Q in pairs(M) do
                if type(Q) ~= "number" then error("invalid table: mixed or invalid key types") end
                A = A + 1
            end
            if A ~= #M then error("invalid table: sparse array") end
            for a0, R in ipairs(M) do
                table.insert(_, e(R, z))
            end
            z[M] = nil
            return "[" .. table.concat(_, ",") .. "]"
        else
            for Q, R in pairs(M) do
                if type(Q) ~= "string" then error("invalid table: mixed or invalid key types") end
                table.insert(_, e(Q, z) .. ":" .. e(R, z))
            end
            z[M] = nil
            return "{" .. table.concat(_, ",") .. "}"
        end
    end

    local function g(M) return '"' .. M:gsub('[%z\1-\31\\"]', S) .. '"' end
    local function a1(M)
        if M ~= M or M <= -math.huge or M >= math.huge then
            error("unexpected number value '" .. tostring(M) .. "'")
        end
        return string.format("%.14g", M)
    end

    local j = { ["nil"] = B, ["table"] = v, ["string"] = g, ["number"] = a1, ["boolean"] = tostring }

    e = function(M, z)
        local x = type(M)
        local a2 = j[x]
        if a2 then return a2(M, z) end
        error("unexpected type '" .. x .. "'")
    end

    lEncode = function(M) return e(M) end

    -- JSON Decode below
    local function N(...)
        local _ = {}
        for a0 = 1, select("#", ...) do
            _[select(a0, ...)] = true
        end
        return _
    end

    local L = N(" ", "\t", "\r", "\n")
    local p = N(" ", "\t", "\r", "\n", "]", "}", ",")
    local a5 = N("\\", "/", '"', "b", "f", "n", "r", "t", "u")
    local m = N("true", "false", "null")
    local a6 = { ["true"] = true, ["false"] = false, ["null"] = nil }

    local function ac(a8, a9, J)
        local ad = 1
        local ae = 1
        for a0 = 1, a9 - 1 do
            ae = ae + 1
            if a8:sub(a0, a0) == "\n" then
                ad = ad + 1
                ae = 1
            end
        end
        error(string.format("%s at line %d col %d", J, ad, ae))
    end

    local function af(A)
        local a2 = math.floor
        if A <= 0x7f then
            return string.char(A)
        elseif A <= 0x7ff then
            return string.char(a2(A / 64) + 192, A % 64 + 128)
        elseif A <= 0xffff then
            return string.char(a2(A / 4096) + 224, a2(A % 4096 / 64) + 128, A % 64 + 128)
        elseif A <= 0x10ffff then
            return string.char(
                a2(A / 262144) + 240,
                a2(A % 262144 / 4096) + 128,
                a2(A % 4096 / 64) + 128,
                A % 64 + 128
            )
        end
        error(string.format("invalid unicode codepoint '%x'", A))
    end

    local function ag(ah)
        local ai = tonumber(ah:sub(1, 4), 16)
        local aj = tonumber(ah:sub(7, 10), 16)
        if aj then
            return af((ai - 0xd800) * 0x400 + aj - 0xdc00 + 0x10000)
        else
            return af(ai)
        end
    end

    local function ak(a8, a0)
        local _ = ""
        local al = a0 + 1
        local Q = al
        while al <= #a8 do
            local am = a8:byte(al)
            if am < 32 then ac(a8, al, "control character in string")
            elseif am == 92 then
                _ = _ .. a8:sub(Q, al - 1)
                al = al + 1
                local T = a8:sub(al, al)
                if T == "u" then
                    local an = a8:match("^[dD][89aAbB]%x%x\\u%x%x%x%x", al + 1) or a8:match("^%x%x%x%x", al + 1) or ac(a8, al - 1, "invalid unicode escape in string")
                    _ = _ .. ag(an)
                    al = al + #an
                else
                    if not a5[T] then ac(a8, al - 1, "invalid escape char '" .. T .. "' in string") end
                    _ = _ .. P[T]
                end
                Q = al + 1
            elseif am == 34 then
                _ = _ .. a8:sub(Q, al - 1)
                return _, al + 1
            end
            al = al + 1
        end
        ac(a8, a0, "expected closing quote for string")
    end

    local function ao(a8, a0)
        local am = a7(a8, a0, p)
        local ah = a8:sub(a0, am - 1)
        local A = tonumber(ah)
        if not A then ac(a8, a0, "invalid number '" .. ah .. "'") end
        return A, am
    end

    local function ap(a8, a0)
        local am = a7(a8, a0, p)
        local aq = a8:sub(a0, am - 1)
        if not m[aq] then ac(a8, a0, "invalid literal '" .. aq .. "'") end
        return a6[aq], am
    end

    local function ar(a8, a0)
        local _ = {}
        local A = 1
        a0 = a0 + 1
        while true do
            local am
            a0 = a7(a8, a0, L, true)
            if a8:sub(a0, a0) == "]" then
                a0 = a0 + 1
                break
            end
            am, a0 = a4(a8, a0)
            _[A] = am
            A = A + 1
            a0 = a7(a8, a0, L, true)
            local as = a8:sub(a0, a0)
            a0 = a0 + 1
            if as == "]" then break end
            if as ~= "," then ac(a8, a0, "expected ']' or ','") end
        end
        return _, a0
    end

    local function at(a8, a0)
        local _ = {}
        a0 = a0 + 1
        while true do
            local au, M
            a0 = a7(a8, a0, L, true)
            if a8:sub(a0, a0) == "}" then
                a0 = a0 + 1
                break
            end
            if a8:sub(a0, a0) ~= '"' then ac(a8, a0, "expected string for key") end
            au, a0 = a4(a8, a0)
            a0 = a7(a8, a0, L, true)
            if a8:sub(a0, a0) ~= ":" then ac(a8, a0, "expected ':' after key") end
            a0 = a0 + 1
            M, a0 = a4(a8, a0)
            _[au] = M
            a0 = a7(a8, a0, L, true)
            local as = a8:sub(a0, a0)
            a0 = a0 + 1
            if as == "}" then break end
            if as ~= "," then ac(a8, a0, "expected '}' or ','") end
        end
        return _, a0
    end

    function a4(a8, a0)
        a0 = a7(a8, a0, L, true)
        local am = a8:sub(a0, a0)
        if am == "{" then
            return at(a8, a0)
        elseif am == "[" then
            return ar(a8, a0)
        elseif am == '"' then
            return ak(a8, a0 + 1)
        elseif am == "-" or am:match("%d") then
            return ao(a8, a0)
        else
            return ap(a8, a0)
        end
    end

    function lDecode(a8)
        local _, a0 = a4(a8, 1)
        a0 = a7(a8, a0, L, true)
        if a0 <= #a8 then
            error("trailing garbage")
        end
        return _
    end
end

-- Platoboost API client script

local httpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")

local host = "https://platoboost.xyz"
local service = "prism"
local secret = "" -- put your secret here if needed
local useNonce = true

local requestSending = false

local function onMessage(message)
    game:GetService("StarterGui"):SetCore("ChatMakeSystemMessage", {Text = message})
end

local function generateNonce()
    local nonce = ""
    for _ = 1, 10 do
        nonce = nonce .. string.char(math.random(65, 90))
    end
    return nonce
end

local function hashNonce(nonce)
    return Z(secret .. nonce)
end

local function cacheLink()
    if requestSending then
        onMessage("Request already in progress.")
        return false, nil
    end
    requestSending = true
    local ok, response = pcall(function()
        return httpService:GetAsync(host .. "/public/cache?service=" .. service)
    end)
    requestSending = false
    if not ok or not response then
        onMessage("Failed to contact cache server.")
        return false, nil
    end
    local decoded = nil
    local success, err = pcall(function()
        decoded = lDecode(response)
    end)
    if not success then
        onMessage("Failed to parse cache response.")
        return false, nil
    end
    if decoded and decoded.success and decoded.link then
        return true, decoded.link
    else
        onMessage("Failed to retrieve cache link.")
        return false, nil
    end
end

local function verifyKey(key)
    if requestSending then
        onMessage("A request is already being sent, please wait.")
        return false
    end
    requestSending = true

    local nonce = ""
    if useNonce then
        nonce = generateNonce()
    end

    local url = host .. "/public/verify?service=" .. service .. "&key=" .. key
    if useNonce then
        url = url .. "&nonce=" .. nonce .. "&hash=" .. hashNonce(nonce)
    end

    local response, body
    local success, err = pcall(function()
        body = httpService:GetAsync(url)
    end)

    requestSending = false

    if not success or not body then
        onMessage("Failed to contact verification server.")
        return false
    end

    local decoded = nil
    local ok, parseErr = pcall(function()
        decoded = lDecode(body)
    end)

    if not ok or not decoded then
        onMessage("Failed to parse verification response.")
        return false
    end

    if decoded.success == true then
        if useNonce then
            if not decoded.nonce or not decoded.hash then
                onMessage("Missing nonce or hash in response.")
                return false
            end
            local expectedHash = hashNonce(decoded.nonce)
            if expectedHash ~= decoded.hash then
                onMessage("Response hash verification failed.")
                return false
            end
        end
        onMessage("Key verified successfully.")
        return true
    elseif decoded.message then
        onMessage(decoded.message)
        return false
    else
        onMessage("Verification failed.")
        return false
    end
end

local function redeemKey(key)
    if requestSending then
        onMessage("A request is already being sent, please wait.")
        return false
    end
    requestSending = true

    local nonce = ""
    if useNonce then
        nonce = generateNonce()
    end

    local url = host .. "/public/redeem?service=" .. service .. "&key=" .. key
    if useNonce then
        url = url .. "&nonce=" .. nonce .. "&hash=" .. hashNonce(nonce)
    end

    local response, body
    local success, err = pcall(function()
        body = httpService:GetAsync(url)
    end)

    requestSending = false

    if not success or not body then
        onMessage("Failed to contact redemption server.")
        return false
    end

    local decoded = nil
    local ok, parseErr = pcall(function()
        decoded = lDecode(body)
    end)

    if not ok or not decoded then
        onMessage("Failed to parse redemption response.")
        return false
    end

    if decoded.success == true then
        if useNonce then
            if not decoded.nonce or not decoded.hash then
                onMessage("Missing nonce or hash in response.")
                return false
            end
            local expectedHash = hashNonce(decoded.nonce)
            if expectedHash ~= decoded.hash then
                onMessage("Response hash verification failed.")
                return false
            end
        end
        onMessage("Key redeemed successfully.")
        return true
    elseif decoded.message then
        onMessage(decoded.message)
        return false
    else
        onMessage("Redemption failed.")
        return false
    end
end

-- Example usage:
task.spawn(function()
    local ok, link = cacheLink()
    if ok then
        onMessage("Cached link: " .. link)
    end
end)

return {
    verifyKey = verifyKey,
    redeemKey = redeemKey,
    cacheLink = cacheLink
}

local success, result = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/refs/heads/main/Library.lua"))
end)

if not success or type(result) ~= "function" then
    warn("Failed to load Library. Check the URL or GitHub status.")
    return
end

local Library = result()
local player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local character = player.Character or player.CharacterAdded:Wait()
local hum = character:FindFirstChildOfClass("Humanoid")
local Options = Library.Options

local savedWalkSpeed = 16
local currentJumpPower = 50
local jumpPowerBoostEnabled = false
local walkSpeedBoostEnabled = false
local supportedGames = {
    [6516141723] = {maxWalkSpeed = 30, maxJumpPower = 75},
}

local currentPlaceId = game.PlaceId
local settings = supportedGames[currentPlaceId] or {maxWalkSpeed = 100, maxJumpPower = 200}

local jumpBoostConnection
local infiniteJumpConnection

Library:Notify({
    Title = "Success",
    Description = "Prism loaded successfully",
    Time = 5,
})

local Window = Library:CreateWindow({
    Title = "Prism Script Hub",
    Footer = "v0.0.1",
    ToggleKeybind = Enum.KeyCode.RightControl,
    Center = true,
    AutoShow = true
}) 

local KeySystemTab = Window:AddTab("Key System", "key-round")

local LeftKeySystem = KeySystemTab:AddLeftGroupbox("Key System")

local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

local infiniteJumpConnection, noclipRunning, flyConnection, autoGrabConnection

local function Doors()
    local DoorsTab = Window:AddTab("Doors", "door-closed")
    local DoorsGroup = DoorsTab:AddLeftGroupbox("Main")

    DoorsGroup:AddLabel("Thanks For Using Prism!")

    DoorsGroup:AddDropdown("EspTarget", {
        Text = "ESP Target",
        Values = {"Entities", "Players", "Keys", "Gold", "Loot", "Doors"},
        Multi = true,
        Default = nil,
        Callback = function(values)
            for _, v in pairs(values) do
                print("ESP toggled for:", v)
                -- Add ESP implementation here if needed
            end
        end
    })

    local EntityBox = DoorsTab:AddLeftGroupbox("Entity Features")
    local NoScreechToggle = EntityBox:AddToggle("NoScreech", { Text = "No Screech", Default = false })
    local NoEyesToggle = EntityBox:AddToggle("NoEyesDamage", { Text = "No Eyes Damage", Default = false })
    local AutoUnlockToggle = EntityBox:AddToggle("AutoUnlockDoors", { Text = "Auto Unlock Doors", Default = false })
    local AutoCrucifixToggle = EntityBox:AddToggle("AutoUseCrucifix", { Text = "Auto-Use Crucifix", Default = false })
    local AutoWinToggle = EntityBox:AddToggle("AutoWin", { Text = "Auto Win", Default = false })
    local AutoEscapeToggle = EntityBox:AddToggle("AutoEscape", { Text = "Auto Escape", Default = false })

    local MovementBox = DoorsTab:AddRightGroupbox("Movement")
    local InfiniteJumpToggle = MovementBox:AddToggle("InfiniteJump", { Text = "Infinite Jump", Default = false })
    local NoclipToggle = MovementBox:AddToggle("Noclip", { Text = "Noclip", Default = false })
    local FlyToggle = MovementBox:AddToggle("Fly", { Text = "Fly", Default = false })

    local VisualBox = DoorsTab:AddRightGroupbox("Visuals")
    VisualBox:AddToggle("EntityESP", { Text = "Entity ESP", Default = false })
    VisualBox:AddToggle("PlayerESP", { Text = "Player ESP", Default = false })
    VisualBox:AddToggle("ItemESP", { Text = "Item ESP", Default = false })
    VisualBox:AddToggle("DoorNumberESP", { Text = "Door Number ESP", Default = false })

    local AutoBox = DoorsTab:AddLeftGroupbox("Automation")
    local AutoGrabToggle = AutoBox:AddToggle("AutoGrab", { Text = "Auto Grab", Default = false })

    local MiscBox = DoorsTab:AddLeftGroupbox("Misc")
    local GhostModeToggle = MiscBox:AddToggle("GhostMode", { Text = "Ghost Mode", Default = false })

    NoScreechToggle:OnChanged(function(value)
        if value then
            print("NoScreech enabled")
            Workspace.DescendantAdded:Connect(function(desc)
                if desc.Name == "Screech" then
                    desc:Destroy()
                end
            end)
        else
            print("NoScreech disabled")
        end
    end)

    NoEyesToggle:OnChanged(function(value)
        if value then
            print("NoEyesDamage enabled")
            Workspace.DescendantAdded:Connect(function(desc)
                if desc.Name == "Eyes" then
                    desc:Destroy()
                end
            end)
        else
            print("NoEyesDamage disabled")
        end
    end)

    AutoUnlockToggle:OnChanged(function(value)
        if value then
            print("AutoUnlockDoors enabled")
            RunService.Heartbeat:Connect(function()
                for _, door in ipairs(Workspace:GetDescendants()) do
                    if door.Name == "KeyObtainPrompt" and door:IsA("ProximityPrompt") then
                        fireproximityprompt(door)
                    end
                end
            end)
        else
            print("AutoUnlockDoors disabled")
        end
    end)

    AutoCrucifixToggle:OnChanged(function(value)
        if value then
            print("AutoUseCrucifix enabled")
            RunService.Heartbeat:Connect(function()
                for _, ent in pairs(Workspace:GetChildren()) do
                    if ent.Name == "RushMoving" or ent.Name == "AmbushMoving" then
                        local crucifix = player.Backpack:FindFirstChild("Crucifix") or character:FindFirstChild("Crucifix")
                        if crucifix then
                            crucifix.Parent = character
                            crucifix:Activate()
                        end
                    end
                end
            end)
        else
            print("AutoUseCrucifix disabled")
        end
    end)

    AutoWinToggle:OnChanged(function(value)
        if value then
            print("AutoWin enabled")
            local exitRoom = Workspace:FindFirstChild("Rooms") and Workspace.Rooms:FindFirstChild("100")
            if exitRoom then
                local exitPart = exitRoom:FindFirstChildWhichIsA("BasePart")
                if exitPart then
                    character:MoveTo(exitPart.Position + Vector3.new(0, 5, 0))
                end
            end
        else
            print("AutoWin disabled")
        end
    end)

    AutoEscapeToggle:OnChanged(function(value)
        if value then
            print("AutoEscape enabled")
            local exit = Workspace:FindFirstChild("Lift") or Workspace:FindFirstChild("FinalDoor")
            if exit and exit:FindFirstChildWhichIsA("BasePart") then
                character:MoveTo(exit.Position + Vector3.new(0, 5, 0))
            end
        else
            print("AutoEscape disabled")
        end
    end)

    InfiniteJumpToggle:OnChanged(function(value)
        if value then
            print("InfiniteJump enabled")
            infiniteJumpConnection = UIS.JumpRequest:Connect(function()
                local hum = character:FindFirstChildOfClass("Humanoid")
                if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
            end)
        else
            print("InfiniteJump disabled")
            if infiniteJumpConnection then
                infiniteJumpConnection:Disconnect()
                infiniteJumpConnection = nil
            end
        end
    end)

    noclipRunning = false
    NoclipToggle:OnChanged(function(value)
        noclipRunning = value
        if value then
            print("Noclip enabled")
            task.spawn(function()
                while noclipRunning do
                    for _, part in pairs(character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                    task.wait()
                end
            end)
        else
            print("Noclip disabled")
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end)

    FlyToggle:OnChanged(function(value)
        if value then
            print("Fly enabled")
            local hrp = character:FindFirstChild("HumanoidRootPart")
            local bv = Instance.new("BodyVelocity")
            bv.Velocity = Vector3.zero
            bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
            bv.Parent = hrp
            flyConnection = RunService.RenderStepped:Connect(function()
                bv.Velocity = Workspace.CurrentCamera.CFrame.LookVector * 75
            end)
        else
            print("Fly disabled")
            if flyConnection then flyConnection:Disconnect() flyConnection = nil end
            local hrp = character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local bv = hrp:FindFirstChildOfClass("BodyVelocity")
                if bv then bv:Destroy() end
            end
        end
    end)

    AutoGrabToggle:OnChanged(function(value)
        if value then
            print("AutoGrab enabled")
            autoGrabConnection = RunService.RenderStepped:Connect(function()
                for _, v in pairs(Workspace:GetDescendants()) do
                    if v:IsA("TouchTransmitter") and v.Parent:IsA("BasePart") then
                        firetouchinterest(character.HumanoidRootPart, v.Parent, 0)
                        firetouchinterest(character.HumanoidRootPart, v.Parent, 1)
                    end
                end
            end)
        else
            print("AutoGrab disabled")
            if autoGrabConnection then autoGrabConnection:Disconnect() autoGrabConnection = nil end
        end
    end)

    GhostModeToggle:OnChanged(function(value)
        print("GhostMode", value and "enabled" or "disabled")
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Transparency = value and 0.6 or 0
                part.CanCollide = not value
            end
        end
    end)
end
end

local keyInputBox = LeftKeySystem:AddInput("keyInput", {
    Placeholder = "Enter Key...",
    Finished = true
})

local function CreateUIAfterkey()
local LocalPlayerTab = Window:AddTab("Local Player", "user")
local LeftGroupbox = LocalPlayerTab:AddLeftGroupbox("Movement")

local currentPlaceId = game.PlaceId

if currentPlaceId == 6516141723 then
    Doors()
    else
    print("Game ID: "..currentPlaceId)
end

LeftGroupbox:AddToggle("WalkSpeedBoost", {
    Text = "Walk Speed Boost",
    Default = false,
    Tooltip = "Enables Walk Speed Control",
    Callback = function(Value)
        walkSpeedBoostEnabled = Value
        local char = player.Character or player.CharacterAdded:Wait()
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.WalkSpeed = Value and savedWalkSpeed or 16
        end
    end
})

LeftGroupbox:AddSlider("WalkspeedSlider", {
    Text = "Walk Speed",
    Default = savedWalkSpeed,
    Min = 1,
    Max = 100,
    Rounding = 1,
    Compact = false,
    Callback = function(Value)
        savedWalkSpeed = Value
        local char = player.Character or player.CharacterAdded:Wait()
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum and walkSpeedBoostEnabled then
            hum.WalkSpeed = Value
            Library:Notify({
                Title = "Success",
                Description = "Set Walk Speed To " .. Value,
                Time = 5,
            })
        end
    end
})

LeftGroupbox:AddToggle("ToggleJumpBoost", {
    Text = "Jump Power Boost",
    Default = false,
    Tooltip = "Lets jump power be controlled",
    Callback = function(Value)
        jumpPowerBoostEnabled = Value

        if jumpBoostConnection then
            jumpBoostConnection:Disconnect()
            jumpBoostConnection = nil
        end

        local char = player.Character or player.CharacterAdded:Wait()
        local hum = char:FindFirstChildOfClass("Humanoid")

        if Value then
            if hum then
                hum.UseJumpPower = true
                hum.JumpPower = currentJumpPower
            end
            jumpBoostConnection = UIS.JumpRequest:Connect(function()
                if not jumpPowerBoostEnabled then return end
                local char = player.Character or player.CharacterAdded:Wait()
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then
                    hum.JumpPower = currentJumpPower
                    task.wait(0.25)
                    hum.JumpPower = currentJumpPower
                end
            end)
            Library:Notify({
                Title = "Jump Power Boost",
                Description = "Enabled. Slider will work now.",
                Time = 4
            })
        else
            if hum then
                hum.UseJumpPower = true
                hum.JumpPower = 50
            end
            Library:Notify({
                Title = "Jump Power Boost",
                Description = "Disabled. Slider won’t apply.",
                Time = 4
            })
        end
    end
})

LeftGroupbox:AddSlider("JumpPowerSlider", {
    Text = "Jump Power",
    Default = currentJumpPower,
    Min = 10,
    Max = 200,
    Rounding = 1,
    Compact = false,
    Callback = function(Value)
        currentJumpPower = Value
        local char = player.Character or player.CharacterAdded:Wait()
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not jumpPowerBoostEnabled then
            Library:Notify({
                Title = "Nuh Uh",
                Description = "Jump Power Boost is off",
                Time = 3
            })
            return
        end
        if hum then
            hum.UseJumpPower = true
            hum.JumpPower = Value
            Library:Notify({
                Title = "Success",
                Description = "Set Jump Power To " .. Value,
                Time = 5,
            })
        end
    end
})

LeftGroupbox:AddToggle("InfiniteJump", {
    Text = "Infinite Jump",
    Default = false,
    Tooltip = "Enables Infinite Jump",
    Callback = function(Value)
        if infiniteJumpConnection then
            infiniteJumpConnection:Disconnect()
            infiniteJumpConnection = nil
        end

        if Value then
            infiniteJumpConnection = UIS.JumpRequest:Connect(function()
                local char = player.Character or player.CharacterAdded:Wait()
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then
                    hum:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end)
        end
    end
})
end

local function CheckKey()

    local key = Options.keyInput.Value

    if key and key ~= "" then
        local success, result = pcall(verifyKey, key)

        if success and result == true then
            Library:Notify({
                Title = "Success",
                Description = "Key verified successfully!",
                Time = 5,
            })
        CreateUIAfterkey()
        elseif success then
            Library:Notify({
                Title = "Error",
                Description = "An error occurred while verifying your key.",
                Time = 5,
            })
        else
            Library:Notify({
                Title = "Error",
                Description = "An error occurred while verifying your key.",
                Time = 5,
            })
        end
      else
        Library:Notify({
            Title = "Warning",
            Description = "Enter a key first. If you have press enter then try again",
            Time = 5,
        })
    end
end

LeftKeySystem:AddButton({
  Text = "Check Key",
  Func = CheckKey
})

player.CharacterAdded:Connect(function(char)
    local hum = char:WaitForChild("Humanoid")
    task.wait(0.1)

    if walkSpeedBoostEnabled then
        hum.WalkSpeed = savedWalkSpeed
    end

    if jumpPowerBoostEnabled then
        hum.UseJumpPower = true
        hum.JumpPower = currentJumpPower
    end
end)
