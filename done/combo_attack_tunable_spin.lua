REGISTER_DBG_GOAL_PARAM(GOAL_COMMON_ComboAttackTunableSpin, 0, "StateID", 0)
REGISTER_DBG_GOAL_PARAM(GOAL_COMMON_ComboAttackTunableSpin, 1, "ëŒè€", 0)
REGISTER_DBG_GOAL_PARAM(GOAL_COMMON_ComboAttackTunableSpin, 2, "ê¨å˜ãóó£", 0)
REGISTER_DBG_GOAL_PARAM(GOAL_COMMON_ComboAttackTunableSpin, 3, "çUåÇëOê˘âÒéûä‘", 0)
REGISTER_DBG_GOAL_PARAM(GOAL_COMMON_ComboAttackTunableSpin, 4, "ê≥ñ îªíËäpìx", 0)
REGISTER_DBG_GOAL_PARAM(GOAL_COMMON_ComboAttackTunableSpin, 5, "è„çUåÇäpìx", 0)
REGISTER_DBG_GOAL_PARAM(GOAL_COMMON_ComboAttackTunableSpin, 6, "â∫çUåÇäpìx", 0)

function ComboAttackTunableSpin_Activate(ai, goal)

	local life = goal:GetLife()
	local ezStateId = goal:GetParam(0)
	local target = goal:GetParam(1)
	local successDist = goal:GetParam(2)
	local turnTime = goal:GetParam(3)
	local frontJgAngle = goal:GetParam(4)
	if turnTime < 0 then
		turnTime = 1.5
	end
	if frontJgAngle < 0 then
		frontJgAngle = 20
	end
	local successAngle = 90
	local animCancel = true
	local arg10 = true
	local forceFail = false
	local noSpin = false
	local upAtkAngle = goal:GetParam(5)
	local downAtkAngle = goal:GetParam(6)
	
	goal:AddSubGoal( GOAL_COMMON_CommonAttack, life, ezStateId, target, successDist, successAngle, turnTime,
		frontJgAngle, animCancel, arg10, forceFail, noSpin, upAtkAngle, downAtkAngle )
	
end

function ComboAttackTunableSpin_Update(ai, goal)
	return GOAL_RESULT_Continue
end

function ComboAttackTunableSpin_Terminate(ai, goal)
end

REGISTER_GOAL_NO_INTERUPT(GOAL_COMMON_ComboAttackTunableSpin, true)
function ComboAttackTunableSpin_Interupt(ai, goal)
	return false
end


