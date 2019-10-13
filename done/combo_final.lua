REGISTER_DBG_GOAL_PARAM(GOAL_COMMON_ComboFinal, 0, "EzStateID", 0)
REGISTER_DBG_GOAL_PARAM(GOAL_COMMON_ComboFinal, 1, "çUåÇëŒè€", 0)
REGISTER_DBG_GOAL_PARAM(GOAL_COMMON_ComboFinal, 2, "ê¨å˜ãóó£", 0)
REGISTER_DBG_GOAL_PARAM(GOAL_COMMON_ComboFinal, 3, "è„çUåÇäpìx", 0)
REGISTER_DBG_GOAL_PARAM(GOAL_COMMON_ComboFinal, 4, "â∫çUåÇäpìx", 0)
ENABLE_COMBO_ATK_CANCEL(GOAL_COMMON_ComboFinal)

ComboFinal_Activate = function(ai, goal)

	local life = goal:GetLife()
	local ezStateId = goal:GetParam(0)
	local target = goal:GetParam(1)
	local successDist = goal:GetParam(2)
	local successAngle = 180
	local turnTime = 0
	local frontJgAngle = 90
	local animCancel = false
	local arg10 = true
	local forceFail = false
	local noSpin = false
	local upAtkAngle = goal:GetParam(3)
	local downAtkAngle = goal:GetParam(4)
	
	goal:AddSubGoal(GOAL_COMMON_CommonAttack, life, ezStateId, target, successDist, successAngle, turnTime,
		frontJgAngle, animCancel, arg10, forceFail, noSpin, upAtkAngle, downAtkAngle)
	
end

ComboFinal_Update = function(ai, goal)
	return GOAL_RESULT_Continue
end

ComboFinal_Terminate = function(ai, goal)
end

REGISTER_GOAL_NO_INTERUPT(GOAL_COMMON_ComboFinal, true)
ComboFinal_Interupt = function(ai, goal)
	return false
end


