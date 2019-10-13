
REGISTER_DBG_GOAL_PARAM(GOAL_COMMON_ComboAttack, 0, "EzStateID", 0)
REGISTER_DBG_GOAL_PARAM(GOAL_COMMON_ComboAttack, 1, "çUåÇëŒè€", 0)
REGISTER_DBG_GOAL_PARAM(GOAL_COMMON_ComboAttack, 2, "ê¨å˜ãóó£", 0)
REGISTER_DBG_GOAL_PARAM(GOAL_COMMON_ComboAttack, 3, "è„çUåÇäpìx", 0)
REGISTER_DBG_GOAL_PARAM(GOAL_COMMON_ComboAttack, 4, "â∫çUåÇäpìx", 0)
REGISTER_DBG_GOAL_PARAM(GOAL_COMMON_ComboAttack, 5, "ê¨å˜äpìx", 0)

function ComboAttack_Activate(ai, goal)

	local life = goal:GetLife()
	local ezStateId = goal:GetParam(0)
	local target = goal:GetParam(1)
	local successDist = goal:GetParam(2)
	local successAngle = goal:GetParam(5)
	if goal:GetParam(5) == nil then
		successAngle = 90
	end
	local turnTime = 1.5
	local frontJgAngle = 20
	local animCancel = true
	local arg10 = true
	local forceFail = false
	local noSpin = false
	local upAtkAngle = goal:GetParam(3)
	local downAtkAngle = goal:GetParam(4)
	goal:AddSubGoal(GOAL_COMMON_CommonAttack, life, ezStateId, target, successDist,
		successAngle, turnTime, frontJgAngle, animCancel, arg10, forceFail, noSpin, upAtkAngle, downAtkAngle)
		
end

function ComboAttack_Update(ai, goal)
	return GOAL_RESULT_Continue
end

function ComboAttack_Terminate(ai, goal)
end

REGISTER_GOAL_NO_INTERUPT(GOAL_COMMON_ComboAttack, true)
function ComboAttack_Interupt(ai, goal)
	return false
end


