--[[Special thanks:
	Treesus-Anetheron, Beta Tester!
	Allcoast for Bug reporting!
]]--

local RRQ_PopOnlyAfterDungeon = true
local rrq_pvp_test = false


local f = CreateFrame("Frame", "ReQueueFrame", UIParent)
f:RegisterEvent("UPDATE_INSTANCE_INFO")
f:RegisterEvent("GROUP_LEFT")
f:RegisterEvent("LFG_COMPLETION_REWARD")
f:RegisterEvent("LFG_QUEUE_STATUS_UPDATE")
f:RegisterEvent("PLAYER_DEAD")

local function ReQueueFrame_OnEvent(self, event, ...)
	if event == "GROUP_LEFT" then
		--[[This is for only showing after an instance finishes and you leave.]]
		if RRQ_PopOnlyAfterDungeon then
			Random_ReQueue_OnceRun_Frame_LocVar = 1
			RRQ_GroupFrameShow()
			RRQOnUpdateFilter_Timer = true
		else
			Random_ReQueue_OnceRun_Frame_LocVar = nil
		end
	end
	if event == "UPDATE_INSTANCE_INFO" then
		if not RRQ_PopOnlyAfterDungeon then
			if not IsInInstance() then
				RRQ_GroupFrameShow()
			end
		end
	end
	if event == "LFG_COMPLETION_REWARD" then
		RR_OptionsFrame:Show()
		RRQ_PVEFrameCloseButton_NoInstanceLock = nil
	end
	if event == "LFG_QUEUE_STATUS_UPDATE" then
		if not IsInInstance() and RRQ_PVEFrameCloseButton_NoInstanceLock == nil and PVEFrame then
			PVEFrameCloseButton:Click()
			RRQ_PVEFrameCloseButton_NoInstanceLock = 1
		end
	end
	--Used in PvP only.
	if event == "PLAYER_DEAD" then
		if rrq_pvp_test then
			RepopMe()
		end
	end
end

function RRQ_ClickFrame()
	LFDQueueFrameFindGroupButton:Click()
end

function ReQueueFrame_OnUpdate()
	if RRQOnUpdateFilter_Timer and not IsInInstance() then
		if LFDParentFrame:IsShown() then
			C_Timer.After(3, RRQOnUpdateFilter_Timer_function)
			RRQOnUpdateFilter_Timer = nil
		end
	end
	if rrq_pvp_test then
		if GetBattlefieldInstanceExpiration() > 0 and GetBattlefieldInstanceExpiration() < 119400 then
			LeaveBattlefield()
			--Screenshot()
		end
	end
end

function RRQ_GroupFrameShow()

	if not UnitOnTaxi("player") then
		-- The following allows the frame to inherit the proper frame attributes upon login.
		if Random_ReQueue_OnceRun_Frame_LocVar == nil then
			PVEFrame_ShowFrame("GroupFinderFrame", LFDParentFrame)
			Random_ReQueue_OnceRun_Frame_LocVar = 1
		end
		if IsInInstance() then
			-- This toggles the frame on and back off, to set positioning, then shows a persistent frame. The final line fixes any graphical errors.
			PVEFrame_ShowFrame("GroupFinderFrame", LFDParentFrame)
			PVEFrame_ToggleFrame("GroupFinderFrame", LFDParentFrame)
			PVEFrame:Show()
			PVEFrameTab1:Click()
		end
		-- Adventure Guide is such a pain.
		if EncounterJournal then 
			return nil;
		end
		-- the whole function below is so this addon doesn't step on the toes of other Group Finder addons.
		if not (GroupFinderFrameGroupButton2:IsShown() or GroupFinderFrameGroupButton3:IsShown()) then
			LFDParentFrame:Show()
		end
		RRQ_PVEFrameCloseButton_NoInstanceLock = nil
	end
end

function RRQOnUpdateFilter_Timer_function()
	PVEFrame_ToggleFrame("GroupFinderFrame", LFDParentFrame)
	PVEFrame_ShowFrame("GroupFinderFrame", LFDParentFrame)
end

function RRQ_SlashCommand()
	if RR_OptionsFrame:IsShown() then
		RR_OptionsFrame:Hide()
	else
		RR_OptionsFrame:Show()
	end
end

SLASH_RR1 = "/rr"
SlashCmdList["RR"] = RRQ_SlashCommand;
SLASH_RR2 = "/rapidrequeue"
SlashCmdList["RAPIDREQUEUE"] = RRQ_SlashCommand;
SLASH_RR3 = "/requeue"
SlashCmdList["REQUEUE"] = RRQ_SlashCommand;

f:SetScript("OnEvent", ReQueueFrame_OnEvent)
f:SetScript("OnUpdate", ReQueueFrame_OnUpdate)