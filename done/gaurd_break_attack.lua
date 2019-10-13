REGISTER_DBG_GOAL_PARAM(GOAL_COMMON_GuardBreakAttack, 0, "EzStateID", 0)
REGISTER_DBG_GOAL_PARAM(GOAL_COMMON_GuardBreakAttack, 1, "çUåÇëŒè€", 0)
REGISTER_DBG_GOAL_PARAM(GOAL_COMMON_GuardBreakAttack, 2, "ê¨å˜ãóó£", 0)
REGISTER_DBG_GOAL_PARAM(GOAL_COMMON_GuardBreakAttack, 3, "è„çUåÇäpìx", 0)
REGISTER_DBG_GOAL_PARAM(GOAL_COMMON_GuardBreakAttack, 4, "â∫çUåÇäpìx", 0)

GuardBreakAttack_Activate = function(ai, goal)

	local life = goal:GetLife()
	local ezStateId = goal:GetParam(0)
	local target = goal:GetParam(1)
	local successDist = goal:GetParam(2)
	local successAngle = 90
	local turnTime = 1.5
	local frongJgAngle = 20
	local animCancel = true
	local arg10 = true
	local forceFail = true
	local noSpin = false
	local upAtkAngle = goal:GetParam(3)
	local downAtkAngle = goal:GetParam(4)
	
	goal:AddSubGoal(GOAL_COMMON_CommonAttack, life, ezStateId, target, successDist, successAngle, turnTime,
		frongJgAngle, animCancel, arg10, forceFail, noSpin, upAtkAngle, downAtkAngle)
	
end

GuardBreakAttack_Update = function(ai, goal)
	return GOAL_RESULT_Continue
end

GuardBreakAttack_Terminate = function(ai, goal)
end

REGISTER_GOAL_NO_INTERUPT(GOAL_COMMON_GuardBreakAttack, true)
GuardBreakAttack_Interupt = function(ai, goal)
	return false
end


