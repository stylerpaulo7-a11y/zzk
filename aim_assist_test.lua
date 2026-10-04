-- Aim Assist de teste para o seu próprio jogo
-- Não altera a câmera; move apenas o retículo visual.

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera
local FOV = 150

local gui = Instance.new("ScreenGui")
gui.Name = "AimAssistTest"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local crosshair = Instance.new("Frame")
crosshair.Name = "Crosshair"
crosshair.Size = UDim2.fromOffset(6, 6)
crosshair.AnchorPoint = Vector2.new(0.5, 0.5)
crosshair.BorderSizePixel = 0
crosshair.BackgroundColor3 = Color3.new(1, 1, 1)
crosshair.Parent = gui

local function getTarget()
    local center = camera.ViewportSize / 2
    local best, bestDistance = nil, FOV

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character then
            local head = plr.Character:FindFirstChild("Head")
            local humanoid = plr.Character:FindFirstChildOfClass("Humanoid")

            if head and humanoid and humanoid.Health > 0 then
                local pos, visible = camera:WorldToViewportPoint(head.Position)

                if visible then
                    local distance = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                    if distance < bestDistance then
                        best, bestDistance = Vector2.new(pos.X, pos.Y), distance
                    end
                end
            end
        end
    end

    return best
end

RunService.RenderStepped:Connect(function()
    local target = getTarget()

    if target then
        crosshair.Position = UDim2.fromOffset(target.X, target.Y)
    else
        crosshair.Position = UDim2.fromScale(0.5, 0.5)
    end
end)
