--- 
-- Handles table goals and table logic.
-- @module TableAI

g_LogicTable = {} -- table that holds all logic tables
g_GoalTable = {} -- table that holds all goal tables
Logic = nil -- global table that will be accessible by callers of Register functions
Goal = nil -- global table that will be accessible by callers of Register functions

---
-- Handles all logic registration and creates a global Logic table. I'm not sure this actually works.
-- Global Logic variable is overridden upon each call of this function
-- @function RegisterTableLogic
-- @tparam number logicId Unique identifier for this logic.
function RegisterTableLogic( logicId )
	REGISTER_LOGIC_FUNC(logicId, "TableLogic_" .. logicId, "TableLogic_" .. logicId .. "_Interrupt")
	-- this table will be accessible from the logic files and should be used.
	Logic = {}
	-- save this table in our list of them all
	g_LogicTable[logicId] = Logic
end

---
-- Handles all goal registration and creates a global Goal table. After its called all your goal functionality must go to the Goal table.
-- Global Goal variable is overridden upon each call of this function.
-- @function RegisterTableGoal
-- @tparam number goalId Unique identifier for this goal.
-- @tparam string goalNumber Name for this goal. (Goal table doesn't store this information)
function RegisterTableGoal( goalId, goalName )
	REGISTER_GOAL(goalId, goalName)
	-- this table will be accessible from the goal files and should be used for Activate/Update/Terminate/Initalize functions.
	Goal = {}
	-- save this table in our list of them all
	g_GoalTable[goalId] = Goal
end

---
-- Sets up the logic as either table logic or normal logic.
-- @function SetupScriptLogicInfo
-- @tparam number logicId Id of the logic
-- @tparam userdata logicInfo logic info object
function SetupScriptLogicInfo(logicId, logicInfo)

	local logicTable = g_LogicTable[logicId] -- logic table
	
	if logicTable ~= nil then
	
		local interruptInfoTbl = _CreateInterruptTypeInfoTable(logicTable)
		local shouldUpdate = logicTable.Update ~= nil
		-- set this as table logic
		logicInfo:SetTableLogic(shouldUpdate, _IsInterruptFuncExist(interruptInfoTbl, logicTable))
		logicTable.InterruptInfoTable = interruptInfoTbl -- assign interrupt table to the logic table
		
	else
		-- this logic is not table logic
		logicInfo:SetNormalLogic()
	end
	
end

---
-- Sets up the goal as either table goal or normal goal.
-- @function SetupScriptGoalInfo
-- @tparam number goalId Id of the goal
-- @tparam userdata goalInfo goal info object
function SetupScriptGoalInfo(goalId, goalInfo)

	local goalTbl = g_GoalTable[goalId] -- goal table
	
	if goalTbl ~= nil then
	
		local interruptInfoTbl = _CreateInterruptTypeInfoTable(goalTbl)
		local shouldUpdate = goalTbl.Update ~= nil
		-- set this as table goal
		goalInfo:SetTableGoal(shouldUpdate, goalTbl.Terminate ~= nil, _IsInterruptFuncExist(interruptInfoTbl, goalTbl), goalTbl.Initialize ~= nil)
		goalTbl.InterruptInfoTable = interruptInfoTbl -- assign interrupt table to the goal table
		
	else
		-- this goal is not table goal
		goalInfo:SetNormalGoal()
	end
	
end

---
-- Common table logic execute function. Will attempt to call table logic's Main function, does nothing if it doesn't exist.
-- @function ExecTableLogic
-- @tparam userdata ai AI object.
-- @tparam number logicId Id of the logic.
function ExecTableLogic(ai, logicId)

	local logicTbl = g_LogicTable[logicId] -- logic table
	-- check if logic table with this id exists
	if logicTbl ~= nil then
		if logicTbl.Main ~= nil then
			-- if Main function is defined - call it
			logicTbl.Main(logicTbl, ai)
		end
	end
	
end

---
-- Common table logic update function. Will attempt to call table logic's Update function, does nothing if it doesn't exist.
-- @function UpdateTableLogic
-- @tparam userdata ai AI object.
-- @tparam number logicId Id of the logic.
function UpdateTableLogic(ai, logicId)
	
	local logicTbl = g_LogicTable[logicId] -- logic table
	-- check if logic table with this id exists
	if logicTbl ~= nil then
		if logicTbl.Update ~= nil then
			-- if Update function is defined - call it
			logicTbl.Update(logicTbl, ai)
		end
	end
	
end

---
-- Common table goal initialize function. Will attempt to call the goal table's initialize function and return it's result.
-- @function InitializeTableGoal
-- @tparam userdata ai AI object.
-- @tparam userdata goal Goal object.
-- @tparam number goalId Goal id.
-- @return Returns true if it calls the table goal's Initialize function or false if none exist.
function InitializeTableGoal(ai, goal, goalId)

	-- have we initialized
	local bInitalized = false
	-- goal table
	local goalTbl = g_GoalTable[goalId]
	
	if goalTbl ~= nil then
		if goalTbl.Initialize ~= nil then
			-- calls the Initialize function for this table goal
			goalTbl.Initialize(goalTbl, ai, goal, ai:GetChangeBattleStateCount())
			bInitalized = true
		end
	end
	
	return bInitalized
	
end

---
-- Common table goal activate function. Will attempt to call the goal table's activate function and return it's result.
-- @function ActivateTableGoal
-- @tparam userdata ai AI object.
-- @tparam userdata goal Goal object.
-- @tparam number goalId Goal id.
-- @return Returns the result of the table goal's Activate function (usually nil) or false if none exist.
function ActivateTableGoal(ai, goal, goalId)

	-- have we activated
	local bActivated = false
	-- goal table
	local goalTbl = g_GoalTable[goalId]
	
	if goalTbl ~= nil then
		if goalTbl.Activate ~= nil then
			-- calls the Activate function for this table goal
			bActivated = goalTbl.Activate(goalTbl, ai, goal)
		end
	end
	
	return bActivated
	
end

---
-- Common table goal update function. Will attempt to call the goal table's update function and return it's result.
-- @function UpdateTableGoal
-- @tparam userdata ai AI object.
-- @tparam userdata goal Goal object.
-- @tparam number goalId Goal id.
-- @return Returns the result of the table goal's Update function or GOAL_RESULT_Continue if none exist.
function UpdateTableGoal(ai, goal, goalId)

	-- update result
	local goalResult = GOAL_RESULT_Continue
	-- goal table
	local goalTbl = g_GoalTable[goalId]
	
	if goalTbl ~= nil then
		if goalTbl.Update ~= nil then
			-- calls the Update function for this table goal
			goalResult = goalTbl.Update(goalTbl, ai, goal)
		end
	end
	
	return goalResult
	
end

---
-- Common table goal terminate function. Will attempt to call the goal table's terminate function and return it's result.
-- @function TerminateTableGoal
-- @tparam userdata ai AI object.
-- @tparam userdata goal Goal object.
-- @tparam number goalId Goal id.
-- @return Returns the result of the table goal's Terminate function (usually nil) or false if none exist.
function TerminateTableGoal(ai, goal, goalId)

	-- have we terminated
	local bTerminated = false
	-- goal table
	local goalTbl = g_GoalTable[goalId]
	
	if goalTbl ~= nil then
		if goalTbl.Terminate ~= nil then
			-- calls the Terminate function for this table goal
			bTerminated = goalTbl.Terminate(goalTbl, ai, goal)
		end
	end
	
	return bTerminated
	
end

---
-- Common table logic interrupt handler (typed). Checks if a custom interrupt function is assigned to the table logic for the specified interrupt type
-- and tries to run it.
-- @function InterruptTableLogic
-- @tparam userdata ai AI object.
-- @tparam userdata goal Goal object.
-- @tparam number logicId Logic id.
-- @return Returns true if the custom interrupt function returns true or if the subgoal is changed at any point in the interrupt.
function InterruptTableLogic(ai, goal, logicId, interruptId)
	-- have we processed the interrupt
	local bInterruptHandled = false
	-- logic table
	local tbl = g_LogicTable[logicId]
	if tbl ~= nil then
		-- calls the interrupt function for this interrupt type
		bInterruptHandled = _InterruptTableGoal_TypeCall(ai, goal, tbl, interruptId)
	end
	return bInterruptHandled
end

---
-- Common table goal interrupt handler (typed). Checks if a custom interrupt function is assigned to the table goal for the specified interrupt type
-- and tries to run it.
-- @function InterruptTableGoal
-- @tparam userdata ai AI object.
-- @tparam userdata goal Goal object.
-- @tparam number goalId Goal id.
-- @return Returns true if the custom interrupt function returns true or if the subgoal is changed at any point in the interrupt.
function InterruptTableGoal(ai, goal, goalId, interruptId)
	-- have we processed the interrupt
	local bInterruptHandled = false
	-- goal table
	local tbl = g_GoalTable[goalId]
	if tbl ~= nil then
		-- calls the interrupt function for this interrupt type
		bInterruptHandled = _InterruptTableGoal_TypeCall(ai, goal, tbl, interruptId)
	end
	return bInterruptHandled
end

---
-- Common table goal interrupt handler (untyped). Checks if a custom interrupt function is assigned to the table goal/logic and tries to run it.
-- @function InterruptTableGoal_Common
-- @tparam userdata ai AI object.
-- @tparam userdata goal Goal object.
-- @tparam number goalId Goal id.
-- @return Returns true if the custom interrupt function returns true or if the subgoal is changed at any point in the interrupt.
function InterruptTableGoal_Common(ai, goal, goalId)
	
	-- have we processed the interrupt
	local bInterruptHandled = false
	-- goal table
	local tbl = g_GoalTable[goalId]
	-- check if custom interrupt function is defined
	if tbl ~= nil and tbl.Interrupt ~= nil then
		-- check if the function handles this
		if tbl.Interrupt(tbl, ai, goal) then
			bInterruptHandled = true
		end
		-- check if the function changed the subgoal.
		if goal:IsInterruptSubGoalChanged() then
			bInterruptHandled = true
		end
		
	end
	
	return bInterruptHandled
	
end

---
-- Checks the interrupt info table to see if any of its entries have a function assigned by the designer.
-- @function _IsInterruptFuncExist
-- @tparam table interruptInfoTbl Interrupt info table as generated by the _CreateInterruptTypeInfoTable.
-- @param arg1 Unknown. Unused.
-- @return Returns true if it finds any custom interrupt functions.
function _IsInterruptFuncExist(interruptInfoTbl, arg1)
	-- iterate over all possible interrupts
	for interruptId = INTERUPT_First, INTERUPT_Last do
		-- if any interrupt info entry has bEmpty flag set to false then we've found it.
		if not interruptInfoTbl[interruptId].bEmpty then
			return true
		end
	end
	return false
end

---
-- General handler for type interrupts for table goal/logic. Calls the interrupt function from the table for the specified interrupt id.
-- @function _InterruptTableGoal_TypeCall
-- @tparam userdata ai AI object.
-- @tparam userdata goal Goal object.
-- @tparam table tbl Goal/logic table.
-- @tparam number interruptId Id of the interrupt.
-- @return Returns true if successfully processed the interrupt.
function _InterruptTableGoal_TypeCall(ai, goal, tbl, interruptId)
	-- call the interrupt function from the table's interruptInfoTbl
	if tbl.InterruptInfoTable[interruptId].func(ai, goal, tbl) then
		return true
	end
	-- interrupt function didn't handle this interrupt
	return false
end

---
-- Creates interrupt type info table. Table has an entry for each recognized interrupt by the game, each entry is a table of its own with 2 keys:
-- func - containing the function that processes the interrupt (this is a boiler plate function, it tries to retrieve the real interrupt function from
-- the table provided to it and calls it. If that fails it will call the default function which simply returns false). Interrupt is considered processed
-- if either the user defined interrupt function returns true or the subgoal is changed in the interrupt. ai_define.lua contains all interrupt constants that can be used.
-- You can consult this function definition found in table_ai_common.lua for how you should name your interrupt functions.
-- @function _CreateInterruptTypeInfoTable
-- @tparam table tbl Logic/Goal table.
-- @return Table with the interrupt type info.
function _CreateInterruptTypeInfoTable( tbl )

	local interruptInfoTbl = {}
	
	interruptInfoTbl[INTERUPT_FindEnemy] = {
		-- interrupt function that will be called on this type of interrupt
		func = function(ai, goal, tbl)
			-- if the goal/logic table defines a function for this type of interrupt - call it
			-- if it doesn't the default is called
			if _GetInterruptFunc(tbl.Interrupt_FindEnemy)(tbl, ai, goal) then
				-- if found function returned true then we successfully processed the interrupt
				-- default function never returns true
				return true
			end
			-- if at any point in the interrupt call the subgoal was changed
			-- then we consider interrupt successfully processed
			if goal:IsInterruptSubGoalChanged() then
				return true
			end
			-- did not process
			return false
		end,
		-- indicates whether the Goal/Logic table defined the interrupt function for this type
		bEmpty = tbl.Interrupt_FindEnemy == nil
	}
	
	interruptInfoTbl[INTERUPT_FindAttack] = {
		func = function(ai, goal, tbl)
			if _GetInterruptFunc(tbl.Interrupt_FindAttack)(tbl, ai, goal) then
				return true
			end
			if goal:IsInterruptSubGoalChanged() then
				return true
			end
			return false
		end,
		bEmpty = tbl.Interrupt_FindAttack == nil
	}
	
	interruptInfoTbl[INTERUPT_Damaged] = {
		func = function(ai, goal, tbl)
			if _GetInterruptFunc(tbl.Interrupt_Damaged)(tbl, ai, goal) then
				return true
			end
			if goal:IsInterruptSubGoalChanged() then
				return true
			end
			return false
		end,
		bEmpty = tbl.Interrupt_Damaged == nil
	}
	
	interruptInfoTbl[INTERUPT_Damaged_Stranger] = {
		func = function(ai, goal, tbl)
			if _GetInterruptFunc(tbl.Interrupt_Damaged_Stranger)(tbl, ai, goal) then
				return true
			end
			if goal:IsInterruptSubGoalChanged() then
				return true
			end
			return false
		end,
		bEmpty = tbl.Interrupt_Damaged_Stranger == nil
	}
	
	interruptInfoTbl[INTERUPT_FindMissile] = {
		func = function(ai, goal, tbl)
			if _GetInterruptFunc(tbl.Interrupt_FindMissile)(tbl, ai, goal) then
				return true
			end
			if goal:IsInterruptSubGoalChanged() then
				return true
			end
			return false
		end,
		bEmpty = tbl.Interrupt_FindMissile == nil
	}
	
	interruptInfoTbl[INTERUPT_SuccessGuard] = {
		func = function(ai, goal, tbl)
			if _GetInterruptFunc(tbl.Interrupt_SuccessGuard)(tbl, ai, goal) then
				return true
			end
			if goal:IsInterruptSubGoalChanged() then
				return true
			end
			return false
		end,
		bEmpty = tbl.Interrupt_SuccessGuard == nil
	}
	
	interruptInfoTbl[INTERUPT_MissSwing] = {
		func = function(ai, goal, tbl)
			if _GetInterruptFunc(tbl.Interrupt_MissSwing)(tbl, ai, goal) then
				return true
			end
			if goal:IsInterruptSubGoalChanged() then
				return true
			end
			return false
		end,
		bEmpty = tbl.Interrupt_MissSwing == nil
	}
	
	interruptInfoTbl[INTERUPT_GuardBegin] = {
		func = function(ai, goal, tbl)
			if _GetInterruptFunc(tbl.Interrupt_GuardBegin)(tbl, ai, goal) then
				return true
			end
			if goal:IsInterruptSubGoalChanged() then
				return true
			end
			return false
		end,
		bEmpty = tbl.Interrupt_GuardBegin == nil
	}
	
	interruptInfoTbl[INTERUPT_GuardFinish] = {
		func = function(ai, goal, tbl)
			if _GetInterruptFunc(tbl.Interrupt_GuardFinish)(tbl, ai, goal) then
				return true
			end
			if goal:IsInterruptSubGoalChanged() then
				return true
			end
			return false
		end,
		bEmpty = tbl.Interrupt_GuardFinish == nil
	}
	
	interruptInfoTbl[INTERUPT_GuardBreak] = {
		func = function(ai, goal, tbl)
			if _GetInterruptFunc(tbl.Interrupt_GuardBreak)(tbl, ai, goal) then
				return true
			end
			if goal:IsInterruptSubGoalChanged() then
				return true
			end
			return false
		end,
		bEmpty = tbl.Interrupt_GuardBreak == nil
	}
	
	interruptInfoTbl[INTERUPT_Shoot] = {
		func = function(ai, goal, tbl)
			if _GetInterruptFunc(tbl.Interrupt_Shoot)(tbl, ai, goal) then
				return true
			end
			if goal:IsInterruptSubGoalChanged() then
				return true
			end
			return false
		end,
		bEmpty = tbl.Interrupt_Shoot == nil
	}
	
	interruptInfoTbl[INTERUPT_ShootReady] = {
		func = function(ai, goal, tbl)
			if _GetInterruptFunc(tbl.Interrupt_ShootReady)(tbl, ai, goal) then
				return true
			end
			if goal:IsInterruptSubGoalChanged() then
				return true
			end
			return false
		end,
		bEmpty = tbl.Interrupt_ShootReady == nil
	}
	
	interruptInfoTbl[INTERUPT_UseItem] = {
		func = function(ai, goal, tbl)
			if _GetInterruptFunc(tbl.Interrupt_UseItem)(tbl, ai, goal) then
				return true
			end
			if goal:IsInterruptSubGoalChanged() then
				return true
			end
			return false
		end,
		bEmpty = tbl.Interrupt_UseItem == nil
	}
	
	interruptInfoTbl[INTERUPT_EnterBattleArea] = {
		func = function(ai, goal, tbl)
			if _GetInterruptFunc(tbl.Interrupt_EnterBattleArea)(tbl, ai, goal) then
				return true
			end
			if goal:IsInterruptSubGoalChanged() then
				return true
			end
			return false
		end,
		bEmpty = tbl.Interrupt_EnterBattleArea == nil
	}
	
	interruptInfoTbl[INTERUPT_LeaveBattleArea] = {
		func = function(ai, goal, tbl)
			if _GetInterruptFunc(tbl.Interrupt_LeaveBattleArea)(tbl, ai, goal) then
				return true
			end
			if goal:IsInterruptSubGoalChanged() then
				return true
			end
			return false
		end,
		bEmpty = tbl.Interrupt_LeaveBattleArea == nil
	}
	
	interruptInfoTbl[INTERUPT_CANNOT_MOVE] = {
		func = function(ai, goal, tbl)
			if _GetInterruptFunc(tbl.Interrupt_CANNOT_MOVE)(tbl, ai, goal) then
				return true
			end
			if goal:IsInterruptSubGoalChanged() then
				return true
			end
			return false
		end,
		bEmpty = tbl.Interrupt_CANNOT_MOVE == nil
	}
	
	-- this kind of interrupt takes an extra argument - Area Observe Slot
	-- likely indicating which area has triggered the interurpt
	interruptInfoTbl[INTERUPT_Inside_ObserveArea] = {
		func = function(ai, goal, tbl)
			-- this iterates over all area observe slots for the inside type
			-- and calles the interrupt function for each. If any return true then the whole thing returns true.
			if _InterruptTableGoal_Inside_ObserveArea(tbl, ai, goal) then
				return true
			end
			if goal:IsInterruptSubGoalChanged() then
				return true
			end
			return false
		end,
		bEmpty = tbl.Interrupt_Inside_ObserveArea == nil
	}
	
	interruptInfoTbl[INTERUPT_ReboundByOpponentGuard] = {
		func = function(ai, goal, tbl)
			if _GetInterruptFunc(tbl.Interrupt_ReboundByOpponentGuard)(tbl, ai, goal) then
				return true
			end
			if goal:IsInterruptSubGoalChanged() then
				return true
			end
			return false
		end,
		bEmpty = tbl.Interrupt_ReboundByOpponentGuard == nil
	}
	
	interruptInfoTbl[INTERUPT_ForgetTarget] = {
		func = function(ai, goal, tbl)
			if _GetInterruptFunc(tbl.Interrupt_ForgetTarget)(tbl, ai, goal) then
				return true
			end
			if goal:IsInterruptSubGoalChanged() then
				return true
			end
			return false
		end,
		bEmpty = tbl.Interrupt_ForgetTarget == nil
	}
	
	interruptInfoTbl[INTERUPT_FriendRequestSupport] = {
		func = function(ai, goal, tbl)
			if _GetInterruptFunc(tbl.Interrupt_FriendRequestSupport)(tbl, ai, goal) then
				return true
			end
			if goal:IsInterruptSubGoalChanged() then
				return true
			end
			return false
		end,
		bEmpty = tbl.Interrupt_FriendRequestSupport == nil
	}
	
	interruptInfoTbl[INTERUPT_TargetIsGuard] = {
		func = function(ai, goal, tbl)
			if _GetInterruptFunc(tbl.Interrupt_TargetIsGuard)(tbl, ai, goal) then
				return true
			end
			if goal:IsInterruptSubGoalChanged() then
				return true
			end
			return false
		end,
		bEmpty = tbl.Interrupt_TargetIsGuard == nil
	}
	
	interruptInfoTbl[INTERUPT_HitEnemyWall] = {
		func = function(ai, goal, tbl)
			if _GetInterruptFunc(tbl.Interrupt_HitEnemyWall)(tbl, ai, goal) then
				return true
			end
			if goal:IsInterruptSubGoalChanged() then
				return true
			end
			return false
		end,
		bEmpty = tbl.Interrupt_HitEnemyWall == nil
	}
	
	interruptInfoTbl[INTERUPT_SuccessParry] = {
		func = function(ai, goal, tbl)
			if _GetInterruptFunc(tbl.Interrupt_SuccessParry)(tbl, ai, goal) then
				return true
			end
			if goal:IsInterruptSubGoalChanged() then
				return true
			end
			return false
		end,
		bEmpty = tbl.Interrupt_SuccessParry == nil
	}
	
	interruptInfoTbl[INTERUPT_CANNOT_MOVE_DisableInterupt] = {
		func = function(ai, goal, tbl)
			if _GetInterruptFunc(tbl.Interrupt_CANNOT_MOVE_DisableInterupt)(tbl, ai, goal) then
				return true
			end
			if goal:IsInterruptSubGoalChanged() then
				return true
			end
			return false
		end,
		bEmpty = tbl.Interrupt_CANNOT_MOVE_DisableInterupt == nil
	}
	
	interruptInfoTbl[INTERUPT_ParryTiming] = {
		func = function(ai, goal, tbl)
			if _GetInterruptFunc(tbl.Interrupt_ParryTiming)(tbl, ai, goal) then
				return true
			end
			if goal:IsInterruptSubGoalChanged() then
				return true
			end
			return false
		end,
		bEmpty = tbl.Interrupt_ParryTiming == nil
	}
	
	interruptInfoTbl[INTERUPT_RideNode_LadderBottom] = {
		func = function(ai, goal, tbl)
			if _GetInterruptFunc(tbl.Interrupt_RideNode_LadderBottom)(tbl, ai, goal) then
				return true
			end
			if goal:IsInterruptSubGoalChanged() then
				return true
			end
			return false
		end,
		bEmpty = tbl.Interrupt_RideNode_LadderBottom == nil
	}
	
	interruptInfoTbl[INTERUPT_FLAG_RideNode_Door] = {
		func = function(ai, goal, tbl)
			if _GetInterruptFunc(tbl.Interrupt_FLAG_RideNode_Door)(tbl, ai, goal) then
				return true
			end
			if goal:IsInterruptSubGoalChanged() then
				return true
			end
			return false
		end,
		bEmpty = tbl.Interrupt_FLAG_RideNode_Door == nil
	}
	
	interruptInfoTbl[INTERUPT_StraightByPath] = {
		func = function(ai, goal, tbl)
			if _GetInterruptFunc(tbl.Interrupt_StraightByPath)(tbl, ai, goal) then
				return true
			end
			if goal:IsInterruptSubGoalChanged() then
				return true
			end
			return false
		end,
		bEmpty = tbl.Interrupt_StraightByPath == nil
	}
	
	interruptInfoTbl[INTERUPT_ChangedAnimIdOffset] = {
		func = function(ai, goal, tbl)
			if _GetInterruptFunc(tbl.Interrupt_ChangedAnimIdOffset)(tbl, ai, goal) then
				return true
			end
			if goal:IsInterruptSubGoalChanged() then
				return true
			end
			return false
		end,
		bEmpty = tbl.Interrupt_ChangedAnimIdOffset == nil
	}
	
	interruptInfoTbl[INTERUPT_SuccessThrow] = {
		func = function(ai, goal, tbl)
			if _GetInterruptFunc(tbl.Interrupt_SuccessThrow)(tbl, ai, goal) then
				return true
			end
			if goal:IsInterruptSubGoalChanged() then
				return true
			end
			return false
		end,
		bEmpty = tbl.Interrupt_SuccessThrow == nil
	}
	
	interruptInfoTbl[INTERUPT_LookedTarget] = {
		func = function(ai, goal, tbl)
			if _GetInterruptFunc(tbl.Interrupt_LookedTarget)(tbl, ai, goal) then
				return true
			end
			if goal:IsInterruptSubGoalChanged() then
				return true
			end
			return false
		end,
		bEmpty = tbl.Interrupt_LookedTarget == nil
	}
	
	interruptInfoTbl[INTERUPT_LoseSightTarget] = {
		func = function(ai, goal, tbl)
			if _GetInterruptFunc(tbl.Interrupt_LoseSightTarget)(tbl, ai, goal) then
				return true
			end
			if goal:IsInterruptSubGoalChanged() then
				return true
			end
			return false
		end,
		bEmpty = tbl.Interrupt_LoseSightTarget == nil
	}
	
	interruptInfoTbl[INTERUPT_RideNode_InsideWall] = {
		func = function(ai, goal, tbl)
			if _GetInterruptFunc(tbl.Interrupt_RideNode_InsideWall)(tbl, ai, goal) then
				return true
			end
			if goal:IsInterruptSubGoalChanged() then
				return true
			end
			return false
		end,
		bEmpty = tbl.Interrupt_RideNode_InsideWall == nil
	}
	
	interruptInfoTbl[INTERUPT_MissSwingSelf] = {
		func = function(ai, goal, tbl)
			if _GetInterruptFunc(tbl.Interrupt_MissSwingSelf)(tbl, ai, goal) then
				return true
			end
			if goal:IsInterruptSubGoalChanged() then
				return true
			end
			return false
		end,
		bEmpty = tbl.Interrupt_MissSwingSelf == nil
	}
	
	interruptInfoTbl[INTERUPT_GuardBreakBlow] = {
		func = function(ai, goal, tbl)
			if _GetInterruptFunc(tbl.Interrupt_GuardBreakBlow)(tbl, ai, goal) then
				return true
			end
			if goal:IsInterruptSubGoalChanged() then
				return true
			end
			return false
		end,
		bEmpty = tbl.Interrupt_GuardBreakBlow == nil
	}
	
	-- this type of interrupt recieves additional argument - the target out of range slot.
	interruptInfoTbl[INTERUPT_TargetOutOfRange] = {
		func = function(ai, goal, tbl)
			-- This will iterate over all target out of range interrupt slots and run our function against each of them until it gets a positive result
			if _InterruptTableGoal_TargetOutOfRange(tbl, ai, goal) then
				return true
			end
			if goal:IsInterruptSubGoalChanged() then
				return true
			end
			return false
		end,
		bEmpty = tbl.Interrupt_TargetOutOfRange == nil
	}
	
	interruptInfoTbl[INTERUPT_UnstableFloor] = {
		func = function(ai, goal, tbl)
			if _GetInterruptFunc(tbl.Interrupt_UnstableFloor)(tbl, ai, goal) then
				return true
			end
			if goal:IsInterruptSubGoalChanged() then
				return true
			end
			return false
		end,
		bEmpty = tbl.Interrupt_UnstableFloor == nil
	}
	
	interruptInfoTbl[INTERUPT_BreakFloor] = {
		func = function(ai, goal, tbl)
			if _GetInterruptFunc(tbl.Interrupt_BreakFloor)(tbl, ai, goal) then
				return true
			end
			if goal:IsInterruptSubGoalChanged() then
				return true
			end
			return false
		end,
		bEmpty = tbl.Interrupt_BreakFloor == nil
	}
	
	interruptInfoTbl[INTERUPT_BreakObserveObj] = {
		func = function(ai, goal, tbl)
			if _GetInterruptFunc(tbl.Interrupt_BreakObserveObj)(tbl, ai, goal) then
				return true
			end
			if goal:IsInterruptSubGoalChanged() then
				return true
			end
			return false
		end,
		bEmpty = tbl.Interrupt_BreakObserveObj == nil
	}
	
	interruptInfoTbl[INTERUPT_EventRequest] = {
		func = function(ai, goal, tbl)
			if _GetInterruptFunc(tbl.Interrupt_EventRequest)(tbl, ai, goal) then
				return true
			end
			if goal:IsInterruptSubGoalChanged() then
				return true
			end
			return false
		end,
		bEmpty = tbl.Interrupt_EventRequest == nil
	}
	
	-- this kind of interrupt takes an extra argument - Area Observe Slot
	-- likely indicating which area has triggered the interurpt
	interruptInfoTbl[INTERUPT_Outside_ObserveArea] = {
		func = function(ai, goal, tbl)
			-- this iterates over all area observe slots for the inside type
			-- and calles the interrupt function for each. If any return true then the whole thing returns true.
			if _InterruptTableGoal_Outside_ObserveArea(tbl, ai, goal) then
				return true
			end
			if goal:IsInterruptSubGoalChanged() then
				return true
			end
			return false
		end,
		bEmpty = tbl.Interrupt_Outside_ObserveArea == nil
	}
	
	-- this type of interrupt recieves additional argument - the target out of angle slot.
	interruptInfoTbl[INTERUPT_TargetOutOfAngle] = {
		func = function(ai, goal, tbl)
			-- This will iterate over all target out of angle interrupt slots and run our function against each of them until it gets a positive result
			if _InterruptTableGoal_TargetOutOfAngle(tbl, ai, goal) then
				return true
			end
			if goal:IsInterruptSubGoalChanged() then
				return true
			end
			return false
		end,
		bEmpty = tbl.Interrupt_TargetOutOfAngle == nil
	}
	
	interruptInfoTbl[INTERUPT_PlatoonAiOrder] = {
		func = function(ai, goal, tbl)
			if _GetInterruptFunc(tbl.Interrupt_PlatoonAiOrder)(tbl, ai, goal) then
				return true
			end
			if goal:IsInterruptSubGoalChanged() then
				return true
			end
			return false
		end,
		bEmpty = tbl.Interrupt_PlatoonAiOrder == nil
	}
	
	-- this type of interrupt gets an extra argument - special effect type
	interruptInfoTbl[INTERUPT_ActivateSpecialEffect] = {
		func = function(ai, goal, tbl)
			-- this will iterate over all effects and run the table interrupt function against each one till it gets a positive
			if _InterruptTableGoal_ActivateSpecialEffect(tbl, ai, goal) then
				return true
			end
			if goal:IsInterruptSubGoalChanged() then
				return true
			end
			return false
		end,
		bEmpty = tbl.Interrupt_ActivateSpecialEffect == nil
	}
	
	-- this type of interrupt gets an extra argument - special effect type
	interruptInfoTbl[INTERUPT_InactivateSpecialEffect] = {
		func = function(ai, goal, tbl)
			-- this will iterate over all effects and run the table interrupt function against each one till it gets a positive
			if _InterruptTableGoal_InactivateSpecialEffect(tbl, ai, goal) then
				return true
			end
			if goal:IsInterruptSubGoalChanged() then
				return true
			end
			return false
		end,
		bEmpty = tbl.Interrupt_InactivateSpecialEffect == nil
	}
	
	interruptInfoTbl[INTERUPT_MovedEnd_OnFailedPath] = {
		func = function(ai, goal, tbl)
			if _GetInterruptFunc(tbl.Interrupt_MovedEnd_OnFailedPath)(tbl, ai, goal) then
				return true
			end
			if goal:IsInterruptSubGoalChanged() then
				return true
			end
			return false
		end,
		bEmpty = tbl.Interrupt_MovedEnd_OnFailedPath == nil
	}
	
	interruptInfoTbl[INTERUPT_ChangeSoundTarget] = {
		func = function(ai, goal, tbl)
			if _GetInterruptFunc(tbl.Interrupt_ChangeSoundTarget)(tbl, ai, goal) then
				return true
			end
			if goal:IsInterruptSubGoalChanged() then
				return true
			end
			return false
		end,
		bEmpty = tbl.Interrupt_ChangeSoundTarget == nil
	}
	
	interruptInfoTbl[INTERUPT_OnCreateDamage] = {
		func = function(ai, goal, tbl)
			if _GetInterruptFunc(tbl.Interrupt_OnCreateDamage)(tbl, ai, goal) then
				return true
			end
			if goal:IsInterruptSubGoalChanged() then
				return true
			end
			return false
		end,
		bEmpty = tbl.Interrupt_OnCreateDamage == nil
	}
	
	-- this kind of interrupt gets an extra argument - trigger region category
	interruptInfoTbl[INTERUPT_InvadeTriggerRegion] = {
		func = function(ai, goal, tbl)
			-- this will iterate over all region categories and run the table interrupt function against each one till it gets a positive
			if _InterruptTableGoal_InvadeTriggerRegion(tbl, ai, goal) then
				return true
			end
			if goal:IsInterruptSubGoalChanged() then
				return true
			end
			return false
		end,
		bEmpty = tbl.Interrupt_InvadeTriggerRegion == nil
	}
	
	-- this kind of interrupt gets an extra argument - trigger region category
	interruptInfoTbl[INTERUPT_LeaveTriggerRegion] = {
		func = function(ai, goal, tbl)
			-- this will iterate over all region categories and run the table interrupt function against each one till it gets a positive
			if _InterruptTableGoal_LeaveTriggerRegion(tbl, ai, goal) then
				return true
			end
			if goal:IsInterruptSubGoalChanged() then
				return true
			end
			return false
		end,
		bEmpty = tbl.Interrupt_LeaveTriggerRegion == nil
	}
	
	interruptInfoTbl[INTERUPT_AIGuardBroken] = {
		func = function(ai, goal, tbl)
			if _GetInterruptFunc(tbl.Interrupt_AIGuardBroken)(tbl, ai, goal) then
				return true
			end
			if goal:IsInterruptSubGoalChanged() then
				return true
			end
			return false
		end,
		bEmpty = tbl.Interrupt_AIGuardBroken == nil
	}
	
	interruptInfoTbl[INTERUPT_AIReboundByOpponentGuard] = {
		func = function(ai, goal, tbl)
			if _GetInterruptFunc(tbl.Interrupt_AIReboundByOpponentGuard)(tbl, ai, goal) then
				return true
			end
			if goal:IsInterruptSubGoalChanged() then
				return true
			end
			return false
		end,
		bEmpty = tbl.Interrupt_AIReboundByOpponentGuard == nil
	}
	
	interruptInfoTbl[INTERUPT_BackstabRisk] = {
		func = function(ai, goal, tbl)
			if _GetInterruptFunc(tbl.Interrupt_BackstabRisk)(tbl, ai, goal) then
				return true
			end
			if goal:IsInterruptSubGoalChanged() then
				return true
			end
			return false
		end,
		bEmpty = tbl.Interrupt_BackstabRisk == nil
	}
	
	return interruptInfoTbl
	
end

---
-- Checks if the provided table interrupt function is nil. Returns its argument if it isn't nil, otherwise returns the dummy function.
-- @function _GetInterruptFunc
-- @tparam function tblInterruptFunc Goal/Logic table interrupt function.
-- @return Goal/Logic table interrupt function or the dummy function.
function _GetInterruptFunc( tblInterruptFunc )
	if tblInterruptFunc ~= nil then
		return tblInterruptFunc
	end
	return _InterruptTableGoal_TypeCall_Dummy
end

---
-- Dummy function used when Goal/Logic table don't provide a handler for the interrupts.
-- @function _InterruptTableGoal_TypeCall_Dummy
-- @return Returns false.
function _InterruptTableGoal_TypeCall_Dummy()
	return false
end

---
-- Handles the interrupt calls for target out of range/angle interrupts. Will iterate over all slots, checking if target is out of range/angle with the 
-- provided fIsOutOfRange function and run the tblInterruptFunc to handle it if it is. If any targets out of range/angle are found and tblInterruptFunc didn't handle it
-- returns false.
-- @function _InterruptTableGoal_TargetOutOfRange_Common
-- @tparam table tbl Goal/Logic table.
-- @tparam userdata ai AI object.
-- @tparam userdata goal Goal object.
-- @tparam function fIsOutOfRange Function that checks whether target is out of range/angle. This function receives slot index as its only argument.
-- @tparam function tblInterruptFunc Goal/Logic table interrupt function. Its result is the result of the entire function.
--It recieves tbl, ai, goal, and slot index as its arguments.
-- @return Returns true if successfully processed the interrupt.
function _InterruptTableGoal_TargetOutOfRange_Common( tbl, ai, goal, fIsOutOfRange, tblInterruptFunc )
	
	-- keeps track if we found anything out of range
	local bSlotEnable = false
	
	for slot = 0, 31 do
		-- check if target is out of range at this slot
		if fIsOutOfRange(slot) then
			-- set the flag that we've found at least 1 thing
			bSlotEnable = true
			-- check with the table interrupt function
			if tblInterruptFunc(tbl, ai, goal, slot) then
				return true
			end
			
		end
		
	end
	
	-- if any target was out of range and we didn't successfully process it, we return false
	if bSlotEnable then
		return false
	end
	
	-- there wasn't any targets out of range in the slots we checked, give it unknown slot if it wants to work with it
	return tblInterruptFunc(tbl, ai, goal, -1)
	
end

---
-- Handles the interrupt calls for target out of range interrupts. Will iterate over all slots checking if target is out of range and ran
-- the Goal/Logic table interrupt function (if present). If at any point interrupt function returns a positive result it will stop iterating and return.
-- If any targets out of range are found and the interrupt function didn't handle it it returns false. Table interrupt funciton gets an extra argument -
-- slot index.
-- @function _InterruptTableGoal_TargetOutOfRange
-- @tparam table tbl Goal/Logic table.
-- @tparam userdata ai AI object.
-- @tparam userdata goal Goal object.
-- @return Returns true if successfully processed the interrupt.
function _InterruptTableGoal_TargetOutOfRange( tbl, ai, goal )
	
	-- check if the target is out of range on this interrupt slot
	-- saves this ai reference in an upvalue
	local f = function( slot )
		return ai:IsTargetOutOfRangeInterruptSlot( slot )
	end
	
	-- runs the interrupt function for each slot
	return _InterruptTableGoal_TargetOutOfRange_Common( tbl, ai, goal, f, _GetInterruptFunc( tbl.Interrupt_TargetOutOfRange ) )
	
end

---
-- Handles the interrupt calls for target out of angle interrupts. Will iterate over all slots checking if target is out of angle and ran
-- the Goal/Logic table interrupt function (if present). If at any point interrupt function returns a positive result it will stop iterating and return.
-- If any targets out of angle are found and the interrupt function didn't handle it it returns false. Table interrupt funciton gets an extra argument -
-- slot index.
-- @function _InterruptTableGoal_TargetOutOfAngle
-- @tparam table tbl Goal/Logic table.
-- @tparam userdata ai AI object.
-- @tparam userdata goal Goal object.
-- @return Returns true if successfully processed the interrupt.
function _InterruptTableGoal_TargetOutOfAngle( tbl, ai, goal )

	-- check if the target is out of angle on this interrupt slot
	-- saves this ai reference in an upvalue
	local f = function( slot )
		return ai:IsTargetOutOfAngleInterruptSlot( slot )
	end
	
	-- runs the interrupt function for each slot
	return _InterruptTableGoal_TargetOutOfRange_Common( tbl, ai, goal, f, _GetInterruptFunc( tbl.Interrupt_TargetOutOfAngle ) )
	
end

---
-- Handles the interrupt calls for inside observearea interrupts. Will iterate over all slots and run the table interrupt function against each one till it gets a
-- positive. Table interrupt function gets an extra argument - area observe slot.
-- @function _InterruptTableGoal_Inside_ObserveArea
-- @tparam table tbl Goal/Logic table.
-- @tparam userdata ai AI object.
-- @tparam userdata goal Goal object.
-- @return Returns true if successfully processed the interrupt.
function _InterruptTableGoal_Inside_ObserveArea( tbl, ai, goal )
	-- get amount of slots
	local slotNum = ai:GetAreaObserveSlotNum(AI_AREAOBSERVE_INTERRUPT__INSIDE)
	for slot = 0, slotNum - 1 do
		-- run the interrupt check for each slot till we get a positive
		if _GetInterruptFunc(tbl.Interrupt_Inside_ObserveArea)(tbl, ai, goal, ai:GetAreaObserveSlot(AI_AREAOBSERVE_INTERRUPT__INSIDE, slot)) then
			return true
		end
	end
end

---
-- Handles the interrupt calls for outside observearea interrupts. Will iterate over all slots and run the table interrupt function against each one till it gets a
-- positive. Table interrupt function gets an extra argument - area observe slot.
-- @function _InterruptTableGoal_Outside_ObserveArea
-- @tparam table tbl Goal/Logic table.
-- @tparam userdata ai AI object.
-- @tparam userdata goal Goal object.
-- @return Returns true if successfully processed the interrupt.
function _InterruptTableGoal_Outside_ObserveArea( tbl, ai, goal )
	-- get amount of slots
	local slotNum = ai:GetAreaObserveSlotNum(AI_AREAOBSERVE_INTERRUPT__OUTSIDE)
	for slot = 0, slotNum - 1 do
		-- run the interrupt check for each slot till we get a positive
		if _GetInterruptFunc(tbl.Interrupt_Outside_ObserveArea)(tbl, ai, goal, ai:GetAreaObserveSlot(AI_AREAOBSERVE_INTERRUPT__OUTSIDE, slot)) then
			return true
		end
	end
end

---
-- Handles the interrupt calls for activate special effect interrupts. Will iterate over all effects and run the table interrupt function against each one till it gets a
-- positive. Table interrupt function gets an extra argument - special effect type
-- @function _InterruptTableGoal_ActivateSpecialEffect
-- @tparam table tbl Goal/Logic table.
-- @tparam userdata ai AI object.
-- @tparam userdata goal Goal object.
-- @return Returns true if successfully processed the interrupt.
function _InterruptTableGoal_ActivateSpecialEffect(tbl, ai, goal)
	-- get amount of effects
	local effectNum = ai:GetSpecialEffectActivateInterruptNum()
	for effectIndex = 0, effectNum - 1 do
		-- run the interrupt check for each effect
		if _GetInterruptFunc(tbl.Interrupt_ActivateSpecialEffect)(tbl, ai, goal, ai:GetSpecialEffectActivateInterruptType(effectIndex)) then
			return true
		end
	end
end

---
-- Handles the interrupt calls for deactivate special effect interrupts. Will iterate over all effects and run the table interrupt function against
-- each one till it gets a positive. Table interrupt function gets an extra argument - special effect type
-- @function _InterruptTableGoal_InactivateSpecialEffect
-- @tparam table tbl Goal/Logic table.
-- @tparam userdata ai AI object.
-- @tparam userdata goal Goal object.
-- @return Returns true if successfully processed the interrupt.
function _InterruptTableGoal_InactivateSpecialEffect(tbl, ai, goal)
	-- get amount of effects
	local effectNum = ai:GetSpecialEffectInactivateInterruptNum()
	for effectIndex = 0, effectNum - 1 do
		-- run the interrupt check for each effect
		if _GetInterruptFunc(tbl.Interrupt_InactivateSpecialEffect)(tbl, ai, goal, ai:GetSpecialEffectInactivateInterruptType(effectIndex)) then
			return true
		end
	end
end

---
-- Handles the interrupt calls for invade trigger region interrupts. Will iterate over all region categories and run the table interrupt function against
-- each one till it gets a positive. Table interrupt function gets an extra argument - trigger region category.
-- @function _InterruptTableGoal_InvadeTriggerRegion
-- @tparam table tbl Goal/Logic table.
-- @tparam userdata ai AI object.
-- @tparam userdata goal Goal object.
-- @return Returns true if successfully processed the interrupt.
function _InterruptTableGoal_InvadeTriggerRegion(tbl, ai, goal)
	-- get amount of categories
	local categoryNum = ai:GetInvadeTriggerRegionCategoryNum()
	for categoryIndex = 0, categoryNum - 1 do
		-- run the interrupt check for each category
		if _GetInterruptFunc(tbl.Interrupt_InvadeTriggerRegion)(tbl, ai, goal, ai:GetInvadeTriggerRegionCategory(categoryIndex)) then
			return true
		end
	end
end

---
-- Handles the interrupt calls for leave trigger region interrupts. Will iterate over all region categories and run the table interrupt function against
-- each one till it gets a positive. Table interrupt function gets an extra argument - trigger region category.
-- @function _InterruptTableGoal_LeaveTriggerRegion
-- @tparam table tbl Goal/Logic table.
-- @tparam userdata ai AI object.
-- @tparam userdata goal Goal object.
-- @return Returns true if successfully processed the interrupt.
function _InterruptTableGoal_LeaveTriggerRegion(tbl, ai, goal)
	-- get amount of categories
	local categoryNum = ai:GetLeaveTriggerRegionCategoryNum()
	for categoryIndex = 0, categoryNum - 1 do
		-- run the interrupt check for each category
		if _GetInterruptFunc(tbl.Interrupt_InvadeTriggerRegion)(tbl, ai, goal, ai:GetLeaveTriggerRegionCategory(categoryIndex)) then
			return true
		end
	end
end


