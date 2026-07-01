-- Script de convoyeur simple pour Roblox
-- Place ce script dans une part qui sera le convoyeur

local conveyorSpeed = 50 -- Vitesse du convoyeur (en studs par seconde)

while true do
	local touchingParts = workspace:FindPartBoundsInRadius(script.Parent.Position, 10)
	
	for _, part in ipairs(touchingParts) do
		if part ~= script.Parent and not part.Parent:FindFirstChildOfClass("Humanoid") then
			-- Déplace les objets
			part.AssemblyLinearVelocity = part.AssemblyLinearVelocity + Vector3.new(conveyorSpeed, 0, 0)
		else
			local humanoidRootPart = part.Parent:FindFirstChild("HumanoidRootPart")
			
			if humanoidRootPart then
				-- Déplace les joueurs (même s'ils ne marchent pas)
				humanoidRootPart.AssemblyLinearVelocity = Vector3.new(conveyorSpeed, humanoidRootPart.AssemblyLinearVelocity.Y, humanoidRootPart.AssemblyLinearVelocity.Z)
			end
		end
	end
	
	wait(0.1) -- Rafraîchit chaque 0.1 secondes
end
