--// Unreal's Key System
--// Open source, fast, portable, and free to use.
--// Keep real key validation on your own server.

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer

local CONFIG = {
    KeySystemLink = "https://scriptkey.rooterunreal.workers.dev/",
    VerifyEndpoint = "",

    Description =
        "Unreal's Key System is an open-source key system built to be easy, fast, and portable. " ..
        "The source is available to everyone, so you can use it, customize it, and adapt it to your own project.",

    OnVerified = function(data)
        -- Your code goes here after a valid key is returned.
    end,
}

local COLORS = {
    Background = Color3.fromRGB(9, 9, 12),
    Panel = Color3.fromRGB(16, 16, 21),
    Panel2 = Color3.fromRGB(21, 21, 27),
    Panel3 = Color3.fromRGB(27, 27, 34),

    Red = Color3.fromRGB(244, 47, 67),
    RedBright = Color3.fromRGB(255, 69, 84),
    RedDark = Color3.fromRGB(104, 18, 29),
    RedSoft = Color3.fromRGB(154, 31, 45),

    White = Color3.fromRGB(248, 248, 250),
    Gray = Color3.fromRGB(156, 156, 168),
    DarkGray = Color3.fromRGB(92, 92, 104),

    Green = Color3.fromRGB(83, 224, 137),
    Yellow = Color3.fromRGB(255, 185, 79),
}

local function trim(value)
    return tostring(value or ""):match("^%s*(.-)%s*$")
end

local function make(instanceType, properties, parent)
    local object = Instance.new(instanceType)

    for property, value in pairs(properties) do
        object[property] = value
    end

    object.Parent = parent
    return object
end

local function corner(object, radius)
    return make("UICorner", {
        CornerRadius = UDim.new(0, radius or 10),
    }, object)
end

local function outline(object, color, transparency, thickness)
    return make("UIStroke", {
        Color = color,
        Transparency = transparency or 0,
        Thickness = thickness or 1,
    }, object)
end

local function tween(object, properties, duration, style, direction)
    local info = TweenInfo.new(
        duration or 0.2,
        style or Enum.EasingStyle.Quart,
        direction or Enum.EasingDirection.Out
    )

    return TweenService:Create(object, info, properties)
end

local function playTween(object, properties, duration, style, direction)
    local animation = tween(object, properties, duration, style, direction)
    animation:Play()
    return animation
end

local function getClipboard()
    if type(setclipboard) == "function" then
        return setclipboard
    end

    if type(toclipboard) == "function" then
        return toclipboard
    end

    return nil
end

local function copyText(value)
    local clipboard = getClipboard()
    if not clipboard then
        return false
    end

    return pcall(clipboard, value)
end

local function getRequest()
    if type(request) == "function" then
        return request
    end

    if type(http_request) == "function" then
        return http_request
    end

    if syn and type(syn.request) == "function" then
        return syn.request
    end

    if http and type(http.request) == "function" then
        return http.request
    end

    return nil
end

local function getParent()
    local ok, hui = pcall(function()
        return gethui and gethui()
    end)

    if ok and hui then
        return hui
    end

    return game:GetService("CoreGui")
end

local Parent = getParent()
local Existing = Parent:FindFirstChild("UnrealsKeySystem")

if Existing then
    Existing:Destroy()
end

local Gui = make("ScreenGui", {
    Name = "UnrealsKeySystem",
    ResetOnSpawn = false,
    IgnoreGuiInset = true,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    DisplayOrder = 100,
}, Parent)

local UIScale = make("UIScale", {
    Scale = 1,
}, Gui)

local Camera = workspace.CurrentCamera

local function updateScale()
    Camera = workspace.CurrentCamera
    if not Camera then
        return
    end

    local width = Camera.ViewportSize.X
    UIScale.Scale = math.clamp(width / 520, 0.74, 1)
end

updateScale()

if Camera then
    Camera:GetPropertyChangedSignal("ViewportSize"):Connect(updateScale)
end

--// Background glow

local Glow = make("Frame", {
    Name = "Glow",
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.5),
    Size = UDim2.fromOffset(545, 405),
    BackgroundColor3 = COLORS.Red,
    BackgroundTransparency = 0.93,
    BorderSizePixel = 0,
}, Gui)

corner(Glow, 28)

local GlowGradient = make("UIGradient", {
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, COLORS.RedDark),
        ColorSequenceKeypoint.new(0.5, COLORS.Red),
        ColorSequenceKeypoint.new(1, COLORS.RedDark),
    }),
    Rotation = 90,
}, Glow)

--// Main panel

local Shadow = make("Frame", {
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.5) + UDim2.fromOffset(0, 8),
    Size = UDim2.fromOffset(486, 378),
    BackgroundColor3 = Color3.new(0, 0, 0),
    BackgroundTransparency = 0.48,
    BorderSizePixel = 0,
}, Gui)

corner(Shadow, 22)

local Main = make("Frame", {
    Name = "Main",
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.53),
    Size = UDim2.fromOffset(486, 378),
    BackgroundColor3 = COLORS.Background,
    BorderSizePixel = 0,
    ClipsDescendants = true,
}, Gui)

corner(Main, 22)
outline(Main, COLORS.RedSoft, 0.55, 1)

local MainGradient = make("UIGradient", {
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(13, 13, 18)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 8, 11)),
    }),
    Rotation = 90,
}, Main)

--// Neon edge

local EdgeGlow = make("Frame", {
    Position = UDim2.new(0, 18, 0, 76),
    Size = UDim2.new(1, -36, 0, 1),
    BackgroundColor3 = COLORS.Red,
    BorderSizePixel = 0,
}, Main)

local EdgeGradient = make("UIGradient", {
    Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.85),
        NumberSequenceKeypoint.new(0.5, 0),
        NumberSequenceKeypoint.new(1, 0.85),
    }),
}, EdgeGlow)

--// Top bar

local Top = make("Frame", {
    Name = "Top",
    Size = UDim2.new(1, 0, 0, 77),
    BackgroundTransparency = 1,
    Active = true,
}, Main)

local LogoGlow = make("Frame", {
    Size = UDim2.fromOffset(43, 43),
    Position = UDim2.fromOffset(19, 16),
    BackgroundColor3 = COLORS.Red,
    BackgroundTransparency = 0.8,
    BorderSizePixel = 0,
}, Top)

corner(LogoGlow, 13)

local Logo = make("Frame", {
    Size = UDim2.fromOffset(39, 39),
    Position = UDim2.fromOffset(21, 18),
    BackgroundColor3 = COLORS.RedDark,
    BorderSizePixel = 0,
}, Top)

corner(Logo, 12)
outline(Logo, COLORS.Red, 0.32, 1)

local LogoGradient = make("UIGradient", {
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, COLORS.Red),
        ColorSequenceKeypoint.new(1, COLORS.RedDark),
    }),
    Rotation = 45,
}, Logo)

local LogoText = make("TextLabel", {
    BackgroundTransparency = 1,
    Size = UDim2.fromScale(1, 1),
    Text = "U",
    TextColor3 = COLORS.White,
    Font = Enum.Font.GothamBlack,
    TextSize = 21,
}, Logo)

local Title = make("TextLabel", {
    BackgroundTransparency = 1,
    Position = UDim2.fromOffset(74, 15),
    Size = UDim2.new(1, -140, 0, 26),
    Text = "UNREAL'S KEY SYSTEM",
    TextColor3 = COLORS.White,
    TextXAlignment = Enum.TextXAlignment.Left,
    Font = Enum.Font.GothamBold,
    TextSize = 16,
}, Top)

local Subtitle = make("TextLabel", {
    BackgroundTransparency = 1,
    Position = UDim2.fromOffset(75, 40),
    Size = UDim2.new(1, -150, 0, 18),
    Text = "OPEN SOURCE  •  FAST  •  PORTABLE",
    TextColor3 = COLORS.RedBright,
    TextXAlignment = Enum.TextXAlignment.Left,
    Font = Enum.Font.GothamMedium,
    TextSize = 9,
}, Top)

local Close = make("TextButton", {
    AutoButtonColor = false,
    Size = UDim2.fromOffset(31, 31),
    Position = UDim2.new(1, -48, 0, 20),
    BackgroundColor3 = COLORS.Panel2,
    Text = "×",
    TextColor3 = COLORS.Gray,
    Font = Enum.Font.GothamBold,
    TextSize = 18,
}, Top)

corner(Close, 9)
outline(Close, COLORS.RedSoft, 0.65, 1)

Close.MouseEnter:Connect(function()
    playTween(Close, {
        BackgroundColor3 = Color3.fromRGB(66, 20, 29),
        TextColor3 = COLORS.White,
    }, 0.14)
end)

Close.MouseLeave:Connect(function()
    playTween(Close, {
        BackgroundColor3 = COLORS.Panel2,
        TextColor3 = COLORS.Gray,
    }, 0.14)
end)

Close.MouseButton1Click:Connect(function()
    playTween(Main, {
        Size = UDim2.fromOffset(486, 330),
        Position = UDim2.fromScale(0.5, 0.56),
    }, 0.18)

    playTween(Glow, {
        Size = UDim2.fromOffset(520, 355),
        BackgroundTransparency = 1,
    }, 0.2)

    playTween(Shadow, {
        BackgroundTransparency = 1,
    }, 0.2)

    task.delay(0.2, function()
        if Gui then
            Gui:Destroy()
        end
    end)
end)

--// Tabs

local TabBar = make("Frame", {
    Position = UDim2.new(0, 19, 0, 91),
    Size = UDim2.new(1, -38, 0, 34),
    BackgroundColor3 = COLORS.Panel,
    BorderSizePixel = 0,
}, Main)

corner(TabBar, 10)
outline(TabBar, COLORS.Panel3, 0.2, 1)

local KeyTab = make("TextButton", {
    AutoButtonColor = false,
    Size = UDim2.new(0.5, -3, 1, 0),
    Position = UDim2.fromOffset(2, 0),
    BackgroundColor3 = COLORS.RedDark,
    Text = "KEY SYSTEM",
    TextColor3 = COLORS.White,
    Font = Enum.Font.GothamBold,
    TextSize = 10,
}, TabBar)

corner(KeyTab, 9)

local InfoTab = make("TextButton", {
    AutoButtonColor = false,
    Size = UDim2.new(0.5, -3, 1, 0),
    Position = UDim2.new(0.5, 1, 0, 0),
    BackgroundTransparency = 1,
    Text = "DESCRIPTION",
    TextColor3 = COLORS.Gray,
    Font = Enum.Font.GothamBold,
    TextSize = 10,
}, TabBar)

corner(InfoTab, 9)

local TabIndicator = make("Frame", {
    Position = UDim2.fromOffset(8, 32),
    Size = UDim2.new(0.5, -16, 0, 2),
    BackgroundColor3 = COLORS.RedBright,
    BorderSizePixel = 0,
}, TabBar)

corner(TabIndicator, 2)

local Pages = make("Frame", {
    Position = UDim2.fromOffset(19, 136),
    Size = UDim2.new(1, -38, 1, -151),
    BackgroundTransparency = 1,
    ClipsDescendants = true,
}, Main)

local KeyPage = make("Frame", {
    Size = UDim2.fromScale(1, 1),
    BackgroundTransparency = 1,
}, Pages)

local InfoPage = make("Frame", {
    Size = UDim2.fromScale(1, 1),
    Position = UDim2.fromScale(1.02, 0),
    BackgroundTransparency = 1,
}, Pages)

--// Shared labels

local Intro = make("TextLabel", {
    BackgroundTransparency = 1,
    Size = UDim2.new(1, 0, 0, 23),
    Text = "ENTER YOUR ACCESS KEY",
    TextColor3 = COLORS.White,
    TextXAlignment = Enum.TextXAlignment.Left,
    Font = Enum.Font.GothamBold,
    TextSize = 12,
}, KeyPage)

local IntroSub = make("TextLabel", {
    BackgroundTransparency = 1,
    Position = UDim2.fromOffset(0, 23),
    Size = UDim2.new(1, 0, 0, 20),
    Text = "Verify your key to unlock access.",
    TextColor3 = COLORS.Gray,
    TextXAlignment = Enum.TextXAlignment.Left,
    Font = Enum.Font.Gotham,
    TextSize = 10,
}, KeyPage)

local KeyBox = make("Frame", {
    Position = UDim2.fromOffset(0, 52),
    Size = UDim2.new(1, 0, 0, 52),
    BackgroundColor3 = COLORS.Panel,
    BorderSizePixel = 0,
}, KeyPage)

corner(KeyBox, 12)
local KeyStroke = outline(KeyBox, COLORS.Panel3, 0.12, 1)

local Input = make("TextBox", {
    BackgroundTransparency = 1,
    ClearTextOnFocus = false,
    Position = UDim2.fromOffset(13, 0),
    Size = UDim2.new(1, -26, 1, 0),
    PlaceholderText = "Paste your key here...",
    PlaceholderColor3 = COLORS.DarkGray,
    Text = "",
    TextColor3 = COLORS.White,
    Font = Enum.Font.Code,
    TextSize = 12,
    TextXAlignment = Enum.TextXAlignment.Left,
}, KeyBox)

Input.Focused:Connect(function()
    playTween(KeyStroke, {
        Color = COLORS.Red,
        Transparency = 0.18,
    }, 0.16)
end)

Input.FocusLost:Connect(function()
    playTween(KeyStroke, {
        Color = COLORS.Panel3,
        Transparency = 0.12,
    }, 0.16)
end)

local Status = make("TextLabel", {
    BackgroundTransparency = 1,
    Position = UDim2.fromOffset(0, 110),
    Size = UDim2.new(1, 0, 0, 20),
    Text = "●  READY  •  Enter your key to continue",
    TextColor3 = COLORS.Gray,
    TextXAlignment = Enum.TextXAlignment.Left,
    Font = Enum.Font.GothamMedium,
    TextSize = 9,
}, KeyPage)

local function setStatus(message, color)
    Status.Text = "●  " .. message
    playTween(Status, {
        TextColor3 = color or COLORS.Gray,
    }, 0.15)
end

local GetKey = make("TextButton", {
    AutoButtonColor = false,
    Position = UDim2.fromOffset(0, 139),
    Size = UDim2.new(0.34, -5, 0, 43),
    BackgroundColor3 = COLORS.Panel2,
    Text = "GET KEY",
    TextColor3 = COLORS.White,
    Font = Enum.Font.GothamBold,
    TextSize = 10,
}, KeyPage)

corner(GetKey, 10)
outline(GetKey, COLORS.Panel3, 0.1, 1)

local Verify = make("TextButton", {
    AutoButtonColor = false,
    Position = UDim2.new(0.34, 5, 0, 139),
    Size = UDim2.new(0.66, -5, 0, 43),
    BackgroundColor3 = COLORS.Red,
    Text = "VERIFY KEY",
    TextColor3 = COLORS.White,
    Font = Enum.Font.GothamBold,
    TextSize = 10,
}, KeyPage)

corner(Verify, 10)
outline(Verify, COLORS.RedBright, 0.28, 1)

local Tip = make("TextLabel", {
    BackgroundTransparency = 1,
    Position = UDim2.fromOffset(0, 192),
    Size = UDim2.new(1, 0, 0, 28),
    Text = "Keys are checked by your configured verification server.",
    TextColor3 = COLORS.DarkGray,
    TextXAlignment = Enum.TextXAlignment.Left,
    Font = Enum.Font.Gotham,
    TextSize = 9,
}, KeyPage)

local function hoverButton(button, normal, hover)
    button.MouseEnter:Connect(function()
        playTween(button, {
            BackgroundColor3 = hover,
        }, 0.14)
    end)

    button.MouseLeave:Connect(function()
        playTween(button, {
            BackgroundColor3 = normal,
        }, 0.14)
    end)
end

hoverButton(GetKey, COLORS.Panel2, COLORS.Panel3)
hoverButton(Verify, COLORS.Red, COLORS.RedBright)

GetKey.MouseButton1Click:Connect(function()
    if copyText(CONFIG.KeySystemLink) then
        setStatus("KEY LINK COPIED  •  Open it in your browser", COLORS.RedBright)
    else
        setStatus("COPY UNAVAILABLE  •  " .. CONFIG.KeySystemLink, COLORS.Yellow)
    end
end)

local verifying = false

Verify.MouseButton1Click:Connect(function()
    if verifying then
        return
    end

    local key = trim(Input.Text)

    if key == "" then
        setStatus("MISSING KEY  •  Paste a key first", COLORS.Yellow)
        return
    end

    if CONFIG.VerifyEndpoint == "" then
        setStatus("SETUP REQUIRED  •  VerifyEndpoint is empty", COLORS.Yellow)
        return
    end

    local send = getRequest()

    if not send then
        setStatus("REQUEST API NOT FOUND  •  HTTP executor support required", COLORS.RedBright)
        return
    end

    verifying = true
    Verify.Text = "VERIFYING..."
    setStatus("CHECKING KEY  •  Contacting server...", COLORS.Gray)

    local ok, response = pcall(function()
        return send({
            Url = CONFIG.VerifyEndpoint,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json",
            },
            Body = HttpService:JSONEncode({
                key = key,
                userId = Player.UserId,
            }),
        })
    end)

    verifying = false
    Verify.Text = "VERIFY KEY"

    if not ok or type(response) ~= "table" then
        setStatus("REQUEST FAILED  •  Check the endpoint or connection", COLORS.RedBright)
        return
    end

    local statusCode = tonumber(response.StatusCode)

    if statusCode and (statusCode < 200 or statusCode >= 300) then
        setStatus("SERVER ERROR  •  HTTP " .. statusCode, COLORS.RedBright)
        return
    end

    local decodedOk, data = pcall(function()
        return HttpService:JSONDecode(response.Body or "")
    end)

    if not decodedOk or type(data) ~= "table" then
        setStatus("BAD RESPONSE  •  Server must return JSON", COLORS.RedBright)
        return
    end

    if data.valid == true then
        setStatus(
            "ACCESS GRANTED  •  " .. tostring(data.message or "Key accepted"),
            COLORS.Green
        )

        task.spawn(function()
            local callbackOk, callbackError = pcall(CONFIG.OnVerified, data)

            if not callbackOk then
                warn("[Unreal's Key System] OnVerified error:", callbackError)
            end
        end)
    else
        setStatus(
            "ACCESS DENIED  •  " .. tostring(data.message or "Invalid or expired key"),
            COLORS.RedBright
        )
    end
end)

--// Description page

local InfoTitle = make("TextLabel", {
    BackgroundTransparency = 1,
    Size = UDim2.new(1, 0, 0, 24),
    Text = "ABOUT UNREAL'S KEY SYSTEM",
    TextColor3 = COLORS.White,
    TextXAlignment = Enum.TextXAlignment.Left,
    Font = Enum.Font.GothamBold,
    TextSize = 12,
}, InfoPage)

local InfoText = make("TextLabel", {
    BackgroundTransparency = 1,
    Position = UDim2.fromOffset(0, 30),
    Size = UDim2.new(1, 0, 0, 91),
    Text = CONFIG.Description,
    TextColor3 = COLORS.Gray,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextYAlignment = Enum.TextYAlignment.Top,
    TextWrapped = true,
    Font = Enum.Font.Gotham,
    TextSize = 10,
}, InfoPage)

local FeatureCard = make("Frame", {
    Position = UDim2.fromOffset(0, 132),
    Size = UDim2.new(1, 0, 0, 82),
    BackgroundColor3 = COLORS.Panel,
    BorderSizePixel = 0,
}, InfoPage)

corner(FeatureCard, 12)
outline(FeatureCard, COLORS.Panel3, 0.1, 1)

local FeatureTitle = make("TextLabel", {
    BackgroundTransparency = 1,
    Position = UDim2.fromOffset(13, 10),
    Size = UDim2.new(1, -26, 0, 18),
    Text = "WHY IT'S DIFFERENT",
    TextColor3 = COLORS.RedBright,
    TextXAlignment = Enum.TextXAlignment.Left,
    Font = Enum.Font.GothamBold,
    TextSize = 9,
}, FeatureCard)

local FeatureText = make("TextLabel", {
    BackgroundTransparency = 1,
    Position = UDim2.fromOffset(13, 30),
    Size = UDim2.new(1, -26, 0, 42),
    Text = "Open source • easy to edit • fast to load • portable across projects • available to everyone.",
    TextColor3 = COLORS.Gray,
    TextWrapped = true,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextYAlignment = Enum.TextYAlignment.Top,
    Font = Enum.Font.Gotham,
    TextSize = 9,
}, FeatureCard)

local SourceNote = make("TextLabel", {
    BackgroundTransparency = 1,
    Position = UDim2.fromOffset(0, 228),
    Size = UDim2.new(1, 0, 0, 22),
    Text = "The client does not store a master key.",
    TextColor3 = COLORS.DarkGray,
    TextXAlignment = Enum.TextXAlignment.Left,
    Font = Enum.Font.Gotham,
    TextSize = 9,
}, InfoPage)

local activeTab = "key"

local function switchTab(tab)
    if tab == activeTab then
        return
    end

    activeTab = tab

    if tab == "info" then
        playTween(KeyTab, {
            BackgroundColor3 = COLORS.Panel,
            TextColor3 = COLORS.Gray,
        }, 0.16)

        playTween(InfoTab, {
            BackgroundTransparency = 0,
            BackgroundColor3 = COLORS.RedDark,
            TextColor3 = COLORS.White,
        }, 0.16)

        playTween(TabIndicator, {
            Position = UDim2.new(0.5, 8, 0, 32),
        }, 0.2)

        playTween(KeyPage, {
            Position = UDim2.fromScale(-1.02, 0),
        }, 0.22)

        playTween(InfoPage, {
            Position = UDim2.fromScale(0, 0),
        }, 0.22)
    else
        playTween(KeyTab, {
            BackgroundColor3 = COLORS.RedDark,
            TextColor3 = COLORS.White,
        }, 0.16)

        playTween(InfoTab, {
            BackgroundTransparency = 1,
            BackgroundColor3 = COLORS.Panel,
            TextColor3 = COLORS.Gray,
        }, 0.16)

        playTween(TabIndicator, {
            Position = UDim2.fromOffset(8, 32),
        }, 0.2)

        playTween(KeyPage, {
            Position = UDim2.fromScale(0, 0),
        }, 0.22)

        playTween(InfoPage, {
            Position = UDim2.fromScale(1.02, 0),
        }, 0.22)
    end
end

KeyTab.MouseButton1Click:Connect(function()
    switchTab("key")
end)

InfoTab.MouseButton1Click:Connect(function()
    switchTab("info")
end)

--// Sparkles

local sparkleRunning = true

local function spawnSparkle(index)
    local sparkle = make("TextLabel", {
        Name = "Sparkle_" .. index,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(
            math.random(7, 93) / 100,
            math.random(7, 93) / 100
        ),
        Size = UDim2.fromOffset(math.random(8, 13), math.random(8, 13)),
        BackgroundTransparency = 1,
        Text = "✦",
        TextColor3 = COLORS.RedBright,
        TextTransparency = 0.2,
        Font = Enum.Font.GothamBold,
        TextSize = math.random(8, 13),
        ZIndex = 0,
    }, Main)

    task.spawn(function()
        local startPosition = sparkle.Position

        while sparkleRunning and sparkle.Parent do
            sparkle.Rotation = math.random(-20, 20)

            playTween(sparkle, {
                TextTransparency = 0.78,
                Position = startPosition + UDim2.fromOffset(
                    math.random(-5, 5),
                    math.random(-8, 8)
                ),
            }, math.random(7, 12) / 10, Enum.EasingStyle.Sine)

            task.wait(math.random(7, 12) / 10)

            playTween(sparkle, {
                TextTransparency = 0.18,
                Position = startPosition,
            }, math.random(7, 12) / 10, Enum.EasingStyle.Sine)

            task.wait(math.random(5, 10) / 10)
        end
    end)
end

for i = 1, 9 do
    spawnSparkle(i)
end

--// Animated glow

task.spawn(function()
    local direction = 1

    while sparkleRunning and Gui.Parent do
        local target = direction == 1 and 0.89 or 0.94

        playTween(Glow, {
            BackgroundTransparency = target,
        }, 1.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)

        direction = -direction
        task.wait(1.8)
    end
end)

task.spawn(function()
    while sparkleRunning and Gui.Parent do
        playTween(EdgeGlow, {
            BackgroundTransparency = 0.15,
        }, 1.1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)

        playTween(EdgeGlow, {
            BackgroundTransparency = 0.7,
        }, 1.1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)

        task.wait(2.2)
    end
end)

--// Dragging

do
    local dragging = false
    local dragStart
    local startMainPosition

    local function updateDrag(input)
        local delta = input.Position - dragStart

        Main.Position = UDim2.new(
            startMainPosition.X.Scale,
            startMainPosition.X.Offset + delta.X,
            startMainPosition.Y.Scale,
            startMainPosition.Y.Offset + delta.Y
        )

        Shadow.Position = Main.Position + UDim2.fromOffset(0, 8)
        Glow.Position = Main.Position
    end

    Top.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then

            dragging = true
            dragStart = input.Position
            startMainPosition = Main.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (
            input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch
        ) then
            updateDrag(input)
        end
    end)
end

--// Entrance animation

Main.Size = UDim2.fromOffset(450, 340)
Main.Position = UDim2.fromScale(0.5, 0.58)
Shadow.Size = UDim2.fromOffset(450, 340)
Shadow.Position = UDim2.fromScale(0.5, 0.61)
Glow.Size = UDim2.fromOffset(510, 350)
Glow.BackgroundTransparency = 1

playTween(Glow, {
    Size = UDim2.fromOffset(545, 405),
    BackgroundTransparency = 0.93,
}, 0.65, Enum.EasingStyle.Quart)

playTween(Shadow, {
    Size = UDim2.fromOffset(486, 378),
    Position = UDim2.fromScale(0.5, 0.53) + UDim2.fromOffset(0, 8),
    BackgroundTransparency = 0.48,
}, 0.55, Enum.EasingStyle.Quart)

playTween(Main, {
    Size = UDim2.fromOffset(486, 378),
    Position = UDim2.fromScale(0.5, 0.53),
}, 0.55, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

KeyTab.BackgroundTransparency = 1

task.delay(0.12, function()
    playTween(KeyTab, {
        BackgroundTransparency = 0,
        BackgroundColor3 = COLORS.RedDark,
    }, 0.18)
end)

Gui.Destroying:Connect(function()
    sparkleRunning = false
end)
