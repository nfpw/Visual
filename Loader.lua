if not game:IsLoaded() then
	repeat
		game.Loaded:Wait()
	until game:IsLoaded()
end

local request = (syn and syn.request) or (http and http.request) or http_request
local queueteleport = (syn and syn.queue_on_teleport) or queue_on_teleport or (fluxus and fluxus.queue_on_teleport)

function ScriptExists(url)
    local success, response = pcall(function()
        return request({
            Url = url,
            Method = "GET"
        })
    end)
    if success and response and response.StatusCode == 200 then
        return true
    else
        return false
    end
end

function LoadScript(url)
    local success, result = pcall(function()
        return loadstring(game:HttpGet(url))()
    end)
    if not success then
        warn("Failed to load script: " .. result)
    end
end

local GithubUrl = "https://raw.githubusercontent.com/nfpw/Visual/refs/heads/main/Games/"
local PlaceIdd = GithubUrl .. tonumber(game.PlaceId) .. ".lua"
local Universall = GithubUrl .. "Universal.lua"
if ScriptExists(PlaceIdd) then
    LoadScript(PlaceIdd)
else
    LoadScript(Universall)
end
