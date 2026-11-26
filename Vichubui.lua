--[[
    ================================================================
      VICHUB  |  WindUI Edition  |  Welcome-only build
    ================================================================
    Stripped down to just:
      - the WindUI window
      - the welcome dialog with your profile
        (display name, username, user ID, avatar)
    ================================================================
]]

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

--==================================================================
--  WINDUI (safe load)
--==================================================================
local ok, WindUI = pcall(function()
    return loadstring(game:HttpGet(
        "https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"
    ))()
end)

if not ok or not WindUI then
    warn("[Vichub] Failed to load WindUI. Check your executor / internet.")
    return
end

pcall(function() WindUI:SetTheme("Dark") end)

local Window = WindUI:CreateWindow({
    Title        = "Vichub",
    Icon         = "zap",
    Author       = "vichub",
    Folder       = "Vichub",
    Size         = UDim2.fromOffset(560, 460),
    Transparent  = true,
    Theme        = "Dark",
    SideBarWidth = 160,
    HasOutline   = false,
    User = {
        Enabled   = true,
        Anonymous = true,
        Callback  = function() end,
    },
})

pcall(function()
    Window:Tag({
        Title  = "v2.0.0",
        Icon   = "github",
        Color  = Color3.fromHex("#1c1c1c"),
        Border = true,
    })
end)

--==================================================================
--  WELCOME DIALOG (profile popup)
--==================================================================
local userId      = LocalPlayer.UserId
local userName    = LocalPlayer.Name
local displayName = LocalPlayer.DisplayName

local avatarUrl = "rbxthumb://type=AvatarHeadShot&id=" .. tostring(userId) .. "&w=150&h=150"
pcall(function()
    local url = Players:GetUserThumbnailAsync(
        userId,
        Enum.ThumbnailType.HeadShot,
        Enum.ThumbnailSize.Size150x150
    )
    if url and url ~= "" then avatarUrl = url end
end)

local welcomeContent = string.format(
    "Welcome to Vichub, %s!\n\nUsername: @%s\nDisplay Name: %s\nUser ID: %s\n\nClick below to continue.",
    displayName, userName, displayName, tostring(userId)
)

task.delay(0.6, function()
    local dlgOk = pcall(function()
        Window:Dialog({
            Title   = "Welcome to Vichub",
            Content = welcomeContent,
            Icon    = avatarUrl,
            Buttons = {
                {
                    Title    = "Ok got it",
                    Variant  = "Primary",
                    Callback = function() end,
                },
            },
        })
    end)

    if not dlgOk then
        WindUI:Notify({
            Title    = "Welcome to Vichub",
            Content  = welcomeContent,
            Icon     = avatarUrl,
            Duration = 10,
        })
    end
end)

-- flip to the real user AFTER the window is fully built
pcall(function()
    Window.User:SetAnonymous(false)
end)

print(string.format(
    "[Vichub] Loaded welcome-only build for %s (@%s).",
    displayName, userName
))
