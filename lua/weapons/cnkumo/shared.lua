if SERVER then
    AddCSLuaFile("shared.lua")
end

if CLIENT then
    SWEP.PrintName = "Carte d'identité Kumo"
    SWEP.Slot = 2
    SWEP.SlotPos = 2
    SWEP.DrawAmmo = false
    SWEP.DrawCrosshair = false
end

SWEP.Author = "Aykiiro"
SWEP.Instructions = "Gardez cette carte en main pour la montrer aux autres joueurs."
SWEP.Contact = ""
SWEP.Purpose = ""
SWEP.HoldType = "pistol"
SWEP.WorldModel = ""
SWEP.AnimPrefix = "pistol"
SWEP.Category = "SL"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""

function SWEP:Initialize()
    self:SetHoldType("pistol")
end

function SWEP:CanPrimaryAttack()
    return false
end

function SWEP:CanSecondaryAttack()
    return false
end

function SWEP:DrawWorldModel()
end

function SWEP:PreDrawViewModel(vm)
    return true
end

if CLIENT then
    surface.CreateFont("prisel_font", {
        font = "Roboto",
        size = 24,
        weight = 1500,
        antialias = true
    })

    surface.CreateFont("prisel_font_bis", {
        font = "Roboto",
        size = 20,
        weight = 1500,
        antialias = true
    })

    surface.CreateFont("prisel_font_yn", {
        font = "Roboto",
        size = 28,
        weight = 1500,
        antialias = true
    })

    local VUMat = Material("kumo.png")

    function SWEP:DrawHUD()
        local LW, LH = 500, 250
        local W, H = ScrW() - LW - 5, ScrH() - LH - 5
        local LP = LocalPlayer()

        LP.PIcon = LP.PIcon or vgui.Create("ModelImage")
        LP.PIcon:SetSize(146, 144)
        LP.PIcon:SetModel(LP:GetModel())
        surface.SetMaterial(VUMat)
        surface.SetDrawColor(255, 255, 255, 255)
        surface.DrawTexturedRect(W, H, LW, LH)
        LP.PIcon:SetPos(W + 25, H + 71)
        LP.PIcon:SetPaintedManually(false)
        LP.PIcon:PaintManual()
        LP.PIcon:SetPaintedManually(true)

        local TextW, TextH = W + 175, H + 75
        draw.SimpleText(LP:Nick(), "prisel_font", TextW, TextH + 30, Color(0, 0, 0, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        draw.SimpleText(LP:SteamID(), "prisel_font", TextW, TextH + 60, Color(0, 0, 0, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

        local DIS = 0
        local CS = 5
        local LicenseW, LicenseH = W + 325, H + 90
    end

    local lastCheck = CurTime()
    hook.Add("PreDrawTranslucentRenderables", "DrawDICardsKumo", function()
        if lastCheck > CurTime() then return end
        lastCheck = lastCheck + .5
        local LPlayer = LocalPlayer()

        for k, v in pairs(player.GetAll()) do
            local CurWep = v:GetActiveWeapon()

            if v ~= LPlayer and IsValid(CurWep) and v:GetActiveWeapon():GetClass() == "cnkumo" and v:HasWeapon("cnkumo") then
                if LPlayer:GetPos():Distance(v:GetPos()) > 400 then return end
                lastCheck = 0
                v.PIcon = v.PIcon or vgui.Create("ModelImage")
                v.PIcon:SetSize(90, 93)
                v.PIcon:SetModel(v:GetModel())
                local boneindex = v:LookupBone("ValveBiped.Bip01_R_Hand")

                if boneindex then
                    local HPos, HAng = v:GetBonePosition(boneindex)
                    HAng:RotateAroundAxis(HAng:Forward(), -90)
                    HAng:RotateAroundAxis(HAng:Right(), -90)
                    HAng:RotateAroundAxis(HAng:Up(), 5)
                    HPos = HPos + HAng:Up() * 4 + HAng:Right() * -5 + HAng:Forward() * 1
                    cam.Start3D2D(HPos, HAng, 1)
                    surface.SetMaterial(VUMat)
                    surface.SetDrawColor(255, 255, 255, 255)
                    surface.DrawTexturedRect(0, 0, 15, 8)
                    cam.End3D2D()
                    cam.Start3D2D(HPos, HAng, .05)
                    v.PIcon:SetPos(12, 45)
                    v.PIcon:SetPaintedManually(false)
                    v.PIcon:PaintManual()
                    v.PIcon:SetPaintedManually(true)
                    local TextW = 105
                    draw.SimpleText(v:Nick(), "prisel_font_bis", TextW, 70, Color(0, 0, 0, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                    draw.SimpleText(v:SteamID(), "prisel_font_bis", TextW, 90, Color(0, 0, 0, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

                    local LicenseW = 225
                    local DIS = 35
                    local CS = 40
                    cam.End3D2D()
                end
            end
        end
    end)
end