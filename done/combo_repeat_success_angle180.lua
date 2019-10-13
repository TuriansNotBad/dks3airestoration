
REGISTER_DBG_GOAL_PARAM(GOAL_COMMON_ComboRepeat_SuccessAngle180, 0, "EzStateID", 0)
REGISTER_DBG_GOAL_PARAM(GOAL_COMMON_ComboRepeat_SuccessAngle180, 1, "çUåÇëŒè€", 0)
REGISTER_DBG_GOAL_PARAM(GOAL_COMMON_ComboRepeat_SuccessAngle180, 2, "ê¨å˜ãóó£", 0)
REGISTER_DBG_GOAL_PARAM(GOAL_COMMON_ComboRepeat_SuccessAngle180, 3, "è„çUåÇäpìx", 0)
REGISTER_DBG_GOAL_PARAM(GOAL_COMMON_ComboRepeat_SuccessAngle180, 4, "â∫çUåÇäpìx", 0)
ENABLE_COMBO_ATK_CANCEL(GOAL_COMMON_ComboRepeat_SuccessAngle180)

function ComboRepeat_SuccessAngle180_Activate(ai, goal)
	local life = goal:Getgoal()
	local ezStateId = goal:GetParam(0)
	local target = goal:GetParam(1)
	local successDist = goal:GetParam(2)
	local successAngle = 180
	local turnTime = 0
	local frontJgAngle = 90
	local animCancel = true
	local arg10 = true
	local forceFail = false
	local dontTurn = false
	local upAtkAngle = goal:GetParam(3)
	local downAtkAngle = goal:GetParam(4)
	goal:AddSubGoal(GOAL_COMMON_CommonAttack, life, ezStateId, target, successDist,
		successAngle, turnTime, frontJgAngle, animCancel, arg10, forceFail, dontTurn, upAtkAngle, downAtkAngle)
end

function ComboRepeat_SuccessAngle180_Update(ai, goal)
	return GOAL_RESULT_Continue
end

function ComboRepeat_SuccessAngle180_Terminate(ai, goal)
end

REGISTER_GOAL_NO_INTERUPT(GOAL_COMMON_ComboRepeat_SuccessAngle180, true)
function ComboRepeat_SuccessAngle180_Interupt(ai, goal)
	return false
end
