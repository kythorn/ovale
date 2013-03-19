--[[--------------------------------------------------------------------
    Ovale Spell Priority
    Copyright (C) 2012 Sidoine

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License in the LICENSE
    file accompanying this program.
----------------------------------------------------------------------]]

-- This addon translates a GUID to a target name
-- Usage: OvaleGUID:GetUnitId(guid)

local _, Ovale = ...
local OvaleGUID = Ovale:NewModule("OvaleGUID", "AceEvent-3.0", "AceConsole-3.0")
Ovale.OvaleGUID = OvaleGUID

--<private-static-properties>
local strfind = string.find
local strsub = string.sub
local API_GetNumGroupMembers = GetNumGroupMembers
local API_UnitGUID = UnitGUID
local API_UnitName = UnitName
--</private-static-properties>

--<public-static-properties>
OvaleGUID.unitId = {}
OvaleGUID.guid = {}
OvaleGUID.player = nil
OvaleGUID.nameToGUID = {}
OvaleGUID.nameToUnit = {}
--</public-static-properties>

--<public-static-methods>
function OvaleGUID:OnEnable()
	self:Update("player")
	self:RegisterEvent("PLAYER_LOGIN")
	self:RegisterEvent("UNIT_TARGET")
	self:RegisterEvent("GROUP_ROSTER_UPDATE")
	self:RegisterEvent("UNIT_PET")
	self:RegisterEvent("ARENA_OPPONENT_UPDATE")
	self:RegisterEvent("PLAYER_FOCUS_CHANGED")
	self:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT")
end

function OvaleGUID:OnDisable()
	self:UnregisterEvent("PLAYER_LOGIN")
	self:UnregisterEvent("UNIT_TARGET")
	self:UnregisterEvent("GROUP_ROSTER_UPDATE")
	self:UnregisterEvent("UNIT_PET")
	self:UnregisterEvent("ARENA_OPPONENT_UPDATE")
	self:UnregisterEvent("PLAYER_FOCUS_CHANGED")
	self:UnregisterEvent("UPDATE_MOUSEOVER_UNIT")
	self:UnregisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT")
end

function OvaleGUID:Update(unitId)
	--self:Print("Update " .. unitId)
	local guid = API_UnitGUID(unitId)
	local previousGuid = self.guid[unitId]
	if unitId == "player" then
		self.player = guid
	end
	if previousGuid ~= guid then
		if previousGuid then
			self.unitId[previousGuid][unitId] = nil
			if not next(self.unitId[previousGuid]) then
				self.unitId[previousGuid] = nil
			end
		end
		self.guid[unitId] = guid
		if guid then
			if not self.unitId[guid] then
				self.unitId[guid] = {}
			end
			Ovale:DebugPrint("guid", "GUID "..guid.." is ".. unitId)
			self.unitId[guid][unitId] = true
		end
	end
	local name = API_UnitName(unitId)
	if name and (not self.nameToGUID[name] or unitId == "target" 
			or self.nameToUnit[name] == "mouseover") then
		self.nameToGUID[name] = guid
		self.nameToUnit[name] = unitId
	end
end

function OvaleGUID:GetUnitId(guid)
	local unitIdTable = self.unitId[guid]
	if not unitIdTable then return nil end
	return next(unitIdTable)
end

function OvaleGUID:UpdateWithTarget(unitId)
	self:Update(unitId)
	self:Update(unitId.."target")
end

function OvaleGUID:PLAYER_LOGIN(event)
	self:Update("player")
end

function OvaleGUID:UNIT_TARGET(event, unitId)
	self:Update(unitId .. "target")
	if unitId == "player" then
		self:Update("target")
	end
end

function OvaleGUID:GROUP_ROSTER_UPDATE(event)
	for i=1, API_GetNumGroupMembers() do
		self:UpdateWithTarget("raid"..i)
		self:UpdateWithTarget("raidpet"..i)
	end
	self:SendMessage("Ovale_GroupChanged")
end

function OvaleGUID:UNIT_PET(event, unitId)
	if strfind(unitId, "party") == 0 then
		local petId = "partypet" .. strsub(unitId, 6)
		self:UpdateWithTarget(petId)
	elseif strfind(unitId, "raid") == 0 then
		local petId = "raidpet" .. strsub(unitId, 5)
		self:UpdateWithTarget(petId)
	elseif unitId == "player" then
		self:UpdateWithTarget("pet")
	end
	self:SendMessage("Ovale_GroupChanged")
end

function OvaleGUID:ARENA_OPPONENT_UPDATE(event)
	for i=1, 5 do
		self:UpdateWithTarget("arena"..i)
	end
end

function OvaleGUID:PLAYER_FOCUS_CHANGED(event)
	self:UpdateWithTarget("focus")
end

function OvaleGUID:UPDATE_MOUSEOVER_UNIT(event)
	self:UpdateWithTarget("mouseover")
end

function OvaleGUID:INSTANCE_ENCOUNTER_ENGAGE_UNIT(event)
	for i=1, 4 do
		self:UpdateWithTarget("boss"..i)
	end
end
--</public-static-methods>
