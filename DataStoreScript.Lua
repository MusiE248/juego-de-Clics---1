---Este es el Script "DataStoreScript" y va dentro de "ServerScriptService"-----


local Players = game:GetService("Players")
local Debris = game:GetService("Debris")

local bolitasFolder = workspace:WaitForChild("PartBolitas")

local bolitaConfig = {
	BolitaAzul = 0.5,
	BolitaRoja = 1.0,
}

for _, bolita in pairs(bolitasFolder:GetChildren()) do
	if bolita:IsA("BasePart") then
		-- Movimiento suave personalizado
		task.spawn(function()
			local originalPos = bolita.Position
			local offset = math.random() * math.pi * 2
			while true do
				if bolita.Parent ~= nil then
					local y = math.sin(tick() + offset) * 0.5
					bolita.Position = originalPos + Vector3.new(0, y, 0)
				end
				wait(0.05)
			end
		end)
	end
end

local function setupBolita(bolita)
	if not bolita:IsA("BasePart") then return end

	bolita.Touched:Connect(function(hit)
		local character = hit:FindFirstAncestorOfClass("Model")
		if character and Players:GetPlayerFromCharacter(character) then
			local player = Players:GetPlayerFromCharacter(character)
			local stats = player:FindFirstChild("leaderstats")
			if not stats then return end

			local velocidad = stats:FindFirstChild("Velocidad")
			if not velocidad then return end

			local bonus = bolitaConfig[bolita.Name] or 0.1
			velocidad.Value = math.round((velocidad.Value + bonus) * 10) / 10

			local originalCF = bolita.CFrame
			bolita.Transparency = 1
			bolita.CanTouch = false

			task.delay(10, function()
				bolita.CFrame = originalCF
				bolita.Transparency = 0
				bolita.CanTouch = true
			end)
		end
	end)
end

for _, bolita in pairs(bolitasFolder:GetChildren()) do
	setupBolita(bolita)
end

bolitasFolder.ChildAdded:Connect(function(child)
	setupBolita(child)
end)
