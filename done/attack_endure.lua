
REGISTER_DBG_GOAL_PARAM(GOAL_COMMON_EndureAttack, 0, "EzStateID", 0) -- ezStateId
REGISTER_DBG_GOAL_PARAM(GOAL_COMMON_EndureAttack, 1, "çUåÇëŒè€", 0) -- Target
REGISTER_DBG_GOAL_PARAM(GOAL_COMMON_EndureAttack, 2, "ê¨å˜ãóó£", 0) -- Success distance
REGISTER_DBG_GOAL_PARAM(GOAL_COMMON_EndureAttack, 3, "çUåÇëOê˘âÒéûä‘", 0) -- Turn time
REGISTER_DBG_GOAL_PARAM(GOAL_COMMON_EndureAttack, 4, "ê≥ñ îªíËäpìx", 0) -- Front Judgement Angle
REGISTER_DBG_GOAL_PARAM(GOAL_COMMON_EndureAttack, 5, "è„çUåÇäpìx", 0) -- Up attack angle
REGISTER_DBG_GOAL_PARAM(GOAL_COMMON_EndureAttack, 6, "â∫çUåÇäpìx", 0) -- Down attack angle

function EndureAttack_Activate(ai, goal)

	local life = goal:GetLife()
	local ezStateId = goal:GetParam(0)
	local targetType = goal:GetParam(1)
	local successDist = goal:GetParam(2)
	local successAngle = 180
	local turnTime = goal:GetParam(3)
	local frontJgAngle = goal:GetParam(4)
	
	if ( turnTime < 0 ) then
		turnTime = 1.5
	end
	if ( frontJgAngle < 0 ) then
		frontJgAngle = 20
	end
	
	local bAnimCancel = false
	local arg10 = true
	local forceFail = false
	local noSpin = false
	local upperAtkAngle = goal:GetParam(5)
	local downAtkAngle = goal:GetParam(6)
	
	goal:AddSubGoal( GOAL_COMMON_CommonAttack, life, ezStateId, targetType, successDist,
		successAngle, turnTime, frontJgAngle, bAnimCancel, arg10, forceFail, noSpin, upperAtkAngle, downAtkAngle )
	ai:SetEnableEndureCancel_forGoal()

end

function EndureAttack_Update(ai, goal)
	return GOAL_RESULT_Continue
end

function EndureAttack_Terminate(ai, goal)
	ai:ClearEnableEndureCancel_forGoal()
end

REGISTER_GOAL_NO_INTERUPT(GOAL_COMMON_EndureAttack, true)
function EndureAttack_Interupt(ai, goal)
	return false
end


