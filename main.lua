---@diagnostic disable: undefined-global
local f = CreateFrame("Frame", "FreemiumFrame", UIParent)
f:RegisterEvent("ADDON_LOADED")
f:RegisterEvent("UPDATE_PENDING_MAIL")
f:RegisterEvent("PLAYER_LEVEL_UP")

local function FreemiumCoreFrame_OnEvent(self, event, ...)
	if event == "ADDON_LOADED" or "UPDATE_PENDING_MAIL" or "PLAYER_LEVEL_UP" then
		if GameLimitedMode_IsActive() then
			C_Timer.After(0.5, ADFrameClose)
			MiniMapMailIcon:Hide()
			TrialAccountCapReached_Inform()
		end
	end
end

function FreemiumCoreFrame_OnUpdate()
	if ExpansionTrialCheckPointDialog ~= nil then
		if ExpansionTrialCheckPointDialog:IsVisible() then
			ExpansionTrialCheckPointDialog.CloseButton:Click()
		end
	else
		return;
	end
end

function ADFrameClose()
	if SubscriptionInterstitialFrame then
		SubscriptionInterstitialFrame.CloseButton:Click()
	end
end

f:SetScript("OnEvent", FreemiumCoreFrame_OnEvent)
f:SetScript("OnUpdate", FreemiumCoreFrame_OnUpdate)