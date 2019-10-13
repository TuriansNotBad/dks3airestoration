
REGISTER_DBG_GOAL_PARAM(GOAL_COMMON_ComboTunable_SuccessAngle180, 0, "EzStateID", 0)
REGISTER_DBG_GOAL_PARAM(GOAL_COMMON_ComboTunable_SuccessAngle180, 1, "çUåÇëŒè€", 0)
REGISTER_DBG_GOAL_PARAM(GOAL_COMMON_ComboTunable_SuccessAngle180, 2, "ê¨å˜ãóó£", 0)
REGISTER_DBG_GOAL_PARAM(GOAL_COMMON_ComboTunable_SuccessAngle180, 3, "çUåÇëOê˘âÒéûä‘ÅyïbÅz", 0)
REGISTER_DBG_GOAL_PARAM(GOAL_COMMON_ComboTunable_SuccessAngle180, 4, "ê≥ñ îªíËäpìxÅyìxÅz", 0)
REGISTER_DBG_GOAL_PARAM(GOAL_COMMON_ComboTunable_SuccessAngle180, 5, "è„çUåÇäpìx", 0)
REGISTER_DBG_GOAL_PARAM(GOAL_COMMON_ComboTunable_SuccessAngle180, 6, "â∫çUåÇäpìx", 0)

function ComboTunableSuccessAngle180_Activate(ai, goal)

	local life = goal:GetLife()
	local ezStateId = goal:GetParam(0)
	local target = goal:GetParam(1)
	local successDist = goal:GetParam(2)
	local successAngle = 180
	local turnTime = goal:GetParam(3)
	local frongJgAngle = goal:GetParam(4)
	if turnTime < 0 then
		turnTime = 1.5
	end
	if frongJgAngle < 0 then
		frongJgAngle = 20
	end
	animCancel = true
	arg10 = true
	forceFail = false
	noSpin = false
	local upAtkAngle = goal:GetParam(5)
	local downAtkAngle = goal:GetParam(6)
	
	goal:AddSubGoal( GOAL_COMMON_CommonAttack, life, ezStateId, target, successDist, successAngle,
		turnTime, frongJgAngle, animCancel, arg10, forceFail, noSpin, upAtkAngle, downAtkAngle )
	
end

function ComboTunableSuccessAngle180_Update(ai, goal)
	return GOAL_RESULT_Continue
end

function ComboTunableSuccessAngle180_Terminate(ai, goal)
end

REGISTER_GOAL_NO_INTERUPT(GOAL_COMMON_ComboTunable_SuccessAngle180, true)
function ComboTunableSuccessAngle180_Interupt(ai, goal)
	return false
end


