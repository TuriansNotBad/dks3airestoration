REGISTER_DBG_GOAL_PARAM(GOAL_COMMON_ComboAttack_SuccessAngle180, 0, "EzStateID", 0) -- ezStateId
REGISTER_DBG_GOAL_PARAM(GOAL_COMMON_ComboAttack_SuccessAngle180, 1, "çUåÇëŒè€", 0) -- target
REGISTER_DBG_GOAL_PARAM(GOAL_COMMON_ComboAttack_SuccessAngle180, 2, "ê¨å˜ãóó£", 0) -- success distance
REGISTER_DBG_GOAL_PARAM(GOAL_COMMON_ComboAttack_SuccessAngle180, 3, "è„çUåÇäpìx", 0) -- up atk angle
REGISTER_DBG_GOAL_PARAM(GOAL_COMMON_ComboAttack_SuccessAngle180, 4, "â∫çUåÇäpìx", 0) -- down atk angle

function ComboAttack180_Activate(ai, goal)

	local life = goal:GetLife()
	local ezStateId = goal:GetParam(0)
	local target = goal:GetParam(1)
	local successDistance = goal:GetParam(2)
	local successAngle = 180
	local turnTime = 1.5
	local frontJgAngle = 20
	local animCancel = true
	local arg10 = true
	local forceFail = false
	local noSpin = false
	local upAtkAngle = goal:GetParam(3)
	local downAtkAngle = goal:GetParam(4)
	
	goal:AddSubGoal(GOAL_COMMON_CommonAttack, life, ezStateId, target, successDistance, successAngle,
		turnTime, frontJgAngle, animCancel, arg10, forceFail, noSpin, upAtkAngle, downAtkAngle)
	
end

function ComboAttack180_Update(ai, goal)
	return GOAL_RESULT_Continue
end

function ComboAttack180_Terminate(ai, goal)
end

REGISTER_GOAL_NO_INTERUPT(GOAL_COMMON_ComboAttack_SuccessAngle180, true)
function ComboAttack180_Interupt(ai, goal)
	return false
end


