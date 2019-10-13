REGISTER_DBG_GOAL_PARAM(GOAL_COMMON_ComboRepeat, 0, "StateID", 0)
REGISTER_DBG_GOAL_PARAM(GOAL_COMMON_ComboRepeat, 1, "ëŒè€", 0)
REGISTER_DBG_GOAL_PARAM(GOAL_COMMON_ComboRepeat, 2, "ê¨å˜ãóó£", 0)
REGISTER_DBG_GOAL_PARAM(GOAL_COMMON_ComboRepeat, 3, "è„çUåÇäpìx", 0)
REGISTER_DBG_GOAL_PARAM(GOAL_COMMON_ComboRepeat, 4, "â∫çUåÇäpìx", 0)
REGISTER_DBG_GOAL_PARAM(GOAL_COMMON_ComboRepeat, 5, "ê¨å˜äpìx", 0)
ENABLE_COMBO_ATK_CANCEL(GOAL_COMMON_ComboRepeat)

ComboRepeat_Activate = function(ai, goal)

	local life = goal:GetLife()
	local ezStateId = goal:GetParam(0)
	local target = goal:GetParam(1)
	local successDist = goal:GetParam(2)
	local successAngle = 90
	local turnTime = 0
	local frontJgAngle = 90
	local animCancel = true
	local arg10 = true
	local forceFail = false
	local noSpin = false
	local upAtkAngle = goal:GetParam(3)
	local downAtkAngle = goal:GetParam(4)
	
	goal:AddSubGoal(GOAL_COMMON_CommonAttack, life, ezStateId, target, successDist, successAngle, turnTime,
		frontJgAngle, animCancel, arg10, forceFail, noSpin, upAtkAngle, downAtkAngle)
	
end

ComboRepeat_Update = function(ai, goal)
	return GOAL_RESULT_Continue
end

ComboRepeat_Terminate = function(ai, goal)
end

REGISTER_GOAL_NO_INTERUPT(GOAL_COMMON_ComboRepeat, true)
ComboRepeat_Interupt = function(ai, goal)
	return false
end


