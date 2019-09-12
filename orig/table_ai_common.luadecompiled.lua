g_LogicTable = {}
g_GoalTable = {}
Logic = nil
Goal = nil
RegisterTableLogic = function(l_1_arg0)
   REGISTER_LOGIC_FUNC(l_1_arg0, "TableLogic_" .. l_1_arg0, "TableLogic_" .. l_1_arg0 .. "_Interrupt")
   Logic = {}
   g_LogicTable[l_1_arg0] = Logic
end

RegisterTableGoal = function(l_2_arg0, l_2_arg1)
   REGISTER_GOAL(l_2_arg0, l_2_arg1)
   Goal = {}
   g_GoalTable[l_2_arg0] = Goal
end

SetupScriptLogicInfo = function(l_3_arg0, l_3_arg1)
   local l_3_2 = g_LogicTable[l_3_arg0]
   if l_3_2 ~= nil then
      local l_3_3 = _CreateInterruptTypeInfoTable(l_3_2)
      local l_3_5 = l_3_2.Update ~= nil
      l_3_arg1:SetTableLogic(l_3_5, _IsInterruptFuncExist(l_3_3, l_3_2))
      l_3_2.InterruptInfoTable = l_3_3
   else
      l_3_arg1:SetNormalLogic()
   end
end

SetupScriptGoalInfo = function(l_4_arg0, l_4_arg1)
   local l_4_2 = g_GoalTable[l_4_arg0]
   if l_4_2 ~= nil then
      local l_4_3 = _CreateInterruptTypeInfoTable(l_4_2)
      local l_4_6 = l_4_2.Update ~= nil
      l_4_arg1:SetTableGoal(l_4_6, l_4_2.Terminate ~= nil, _IsInterruptFuncExist(l_4_3, l_4_2), l_4_2.Initialize ~= nil)
      l_4_2.InterruptInfoTable = l_4_3
   else
      l_4_arg1:SetNormalGoal()
   end
end

ExecTableLogic = function(l_5_arg0, l_5_arg1)
   local l_5_2 = g_LogicTable[l_5_arg1]
   if l_5_2 ~= nil then
      local l_5_3 = l_5_2.Main
      if l_5_3 ~= nil then
         l_5_3(l_5_2, l_5_arg0)
      end
   end
end

UpdateTableLogic = function(l_6_arg0, l_6_arg1)
   local l_6_2 = g_LogicTable[l_6_arg1]
   if l_6_2 ~= nil then
      local l_6_3 = l_6_2.Update
      if l_6_3 ~= nil then
         l_6_3(l_6_2, l_6_arg0)
      end
   end
end

InitializeTableGoal = function(l_7_arg0, l_7_arg1, l_7_arg2)
   local l_7_3 = false
   local l_7_4 = g_GoalTable[l_7_arg2]
   if l_7_4 ~= nil then
      local l_7_5 = l_7_4.Initialize
      if l_7_5 ~= nil then
         l_7_5(l_7_4, l_7_arg0, l_7_arg1, l_7_arg0:GetChangeBattleStateCount())
         l_7_3 = true
      end
   end
   return l_7_3
end

ActivateTableGoal = function(l_8_arg0, l_8_arg1, l_8_arg2)
   local l_8_3 = false
   local l_8_4 = g_GoalTable[l_8_arg2]
   if l_8_4 ~= nil then
      local l_8_5 = l_8_4.Activate
      if l_8_5 ~= nil then
         l_8_3 = l_8_5(l_8_4, l_8_arg0, l_8_arg1)
      end
   end
   return l_8_3
end

UpdateTableGoal = function(l_9_arg0, l_9_arg1, l_9_arg2)
   local l_9_3 = GOAL_RESULT_Continue
   local l_9_4 = g_GoalTable[l_9_arg2]
   if l_9_4 ~= nil then
      local l_9_5 = l_9_4.Update
      if l_9_5 ~= nil then
         l_9_3 = l_9_5(l_9_4, l_9_arg0, l_9_arg1)
      end
   end
   return l_9_3
end

TerminateTableGoal = function(l_10_arg0, l_10_arg1, l_10_arg2)
   local l_10_3 = false
   local l_10_4 = g_GoalTable[l_10_arg2]
   if l_10_4 ~= nil then
      local l_10_5 = l_10_4.Terminate
      if l_10_5 ~= nil then
         l_10_3 = l_10_5(l_10_4, l_10_arg0, l_10_arg1)
      end
   end
   return l_10_3
end

InterruptTableLogic = function(l_11_arg0, l_11_arg1, l_11_arg2, l_11_arg3)
   local l_11_4 = false
   local l_11_5 = g_LogicTable[l_11_arg2]
   if l_11_5 ~= nil then
      l_11_4 = _InterruptTableGoal_TypeCall(l_11_arg0, l_11_arg1, l_11_5, l_11_arg3)
   end
   return l_11_4
end

InterruptTableGoal = function(l_12_arg0, l_12_arg1, l_12_arg2, l_12_arg3)
   local l_12_4 = false
   local l_12_5 = g_GoalTable[l_12_arg2]
   if l_12_5 ~= nil then
      l_12_4 = _InterruptTableGoal_TypeCall(l_12_arg0, l_12_arg1, l_12_5, l_12_arg3)
   end
   return l_12_4
end

InterruptTableGoal_Common = function(l_13_arg0, l_13_arg1, l_13_arg2)
   local l_13_3 = false
   local l_13_4 = g_GoalTable[l_13_arg2]
   if l_13_4 ~= nil and l_13_4.Interrupt ~= nil then
      if l_13_4.Interrupt(l_13_4, l_13_arg0, l_13_arg1) then
         l_13_3 = true
         -- Tried to add an 'end' here but it's incorrect
         if l_13_arg1:IsInterruptSubGoalChanged() then
            l_13_3 = true
         end
         -- Tried to add an 'end' here but it's incorrect
         return l_13_3
end

_IsInterruptFuncExist = function(l_14_arg0, l_14_arg1)
   for l_14_2 = INTERUPT_First, INTERUPT_Last do
      if not l_14_arg0[l_14_2].bEmpty then
         return true
      end
   end
   return false
end

_InterruptTableGoal_TypeCall = function(l_15_arg0, l_15_arg1, l_15_arg2, l_15_arg3)
   if l_15_arg2.InterruptInfoTable[l_15_arg3].func(l_15_arg0, l_15_arg1, l_15_arg2) then
      return true
   end
   return false
end

_CreateInterruptTypeInfoTable = function(l_16_arg0)
   local l_16_1 = {}
   local l_16_2 = INTERUPT_FindEnemy
   local l_16_3
   l_16_1[l_16_2], l_16_3 = l_16_3, {func = function(l_17_arg0, l_17_arg1, l_17_arg2)
      if _GetInterruptFunc(l_17_arg2.Interrupt_FindEnemy)(l_17_arg2, l_17_arg0, l_17_arg1) then
         return true
      end
      if l_17_arg1:IsInterruptSubGoalChanged() then
         return true
      end
      return false
   end, bEmpty = l_16_arg0.Interrupt_FindEnemy == nil}
   l_16_2 = INTERUPT_FindAttack
   l_16_1[l_16_2], l_16_3 = l_16_3, {func = function(l_18_arg0, l_18_arg1, l_18_arg2)
      if _GetInterruptFunc(l_18_arg2.Interrupt_FindAttack)(l_18_arg2, l_18_arg0, l_18_arg1) then
         return true
      end
      if l_18_arg1:IsInterruptSubGoalChanged() then
         return true
      end
      return false
   end, bEmpty = l_16_arg0.Interrupt_FindAttack == nil}
   l_16_2 = INTERUPT_Damaged
   l_16_1[l_16_2], l_16_3 = l_16_3, {func = function(l_19_arg0, l_19_arg1, l_19_arg2)
      if _GetInterruptFunc(l_19_arg2.Interrupt_Damaged)(l_19_arg2, l_19_arg0, l_19_arg1) then
         return true
      end
      if l_19_arg1:IsInterruptSubGoalChanged() then
         return true
      end
      return false
   end, bEmpty = l_16_arg0.Interrupt_Damaged == nil}
   l_16_2 = INTERUPT_Damaged_Stranger
   l_16_1[l_16_2], l_16_3 = l_16_3, {func = function(l_20_arg0, l_20_arg1, l_20_arg2)
      if _GetInterruptFunc(l_20_arg2.Interrupt_Damaged_Stranger)(l_20_arg2, l_20_arg0, l_20_arg1) then
         return true
      end
      if l_20_arg1:IsInterruptSubGoalChanged() then
         return true
      end
      return false
   end, bEmpty = l_16_arg0.Interrupt_Damaged_Stranger == nil}
   l_16_2 = INTERUPT_FindMissile
   l_16_1[l_16_2], l_16_3 = l_16_3, {func = function(l_21_arg0, l_21_arg1, l_21_arg2)
      if _GetInterruptFunc(l_21_arg2.Interrupt_FindMissile)(l_21_arg2, l_21_arg0, l_21_arg1) then
         return true
      end
      if l_21_arg1:IsInterruptSubGoalChanged() then
         return true
      end
      return false
   end, bEmpty = l_16_arg0.Interrupt_FindMissile == nil}
   l_16_2 = INTERUPT_SuccessGuard
   l_16_1[l_16_2], l_16_3 = l_16_3, {func = function(l_22_arg0, l_22_arg1, l_22_arg2)
      if _GetInterruptFunc(l_22_arg2.Interrupt_SuccessGuard)(l_22_arg2, l_22_arg0, l_22_arg1) then
         return true
      end
      if l_22_arg1:IsInterruptSubGoalChanged() then
         return true
      end
      return false
   end, bEmpty = l_16_arg0.Interrupt_SuccessGuard == nil}
   l_16_2 = INTERUPT_MissSwing
   l_16_1[l_16_2], l_16_3 = l_16_3, {func = function(l_23_arg0, l_23_arg1, l_23_arg2)
      if _GetInterruptFunc(l_23_arg2.Interrupt_MissSwing)(l_23_arg2, l_23_arg0, l_23_arg1) then
         return true
      end
      if l_23_arg1:IsInterruptSubGoalChanged() then
         return true
      end
      return false
   end, bEmpty = l_16_arg0.Interrupt_MissSwing == nil}
   l_16_2 = INTERUPT_GuardBegin
   l_16_1[l_16_2], l_16_3 = l_16_3, {func = function(l_24_arg0, l_24_arg1, l_24_arg2)
      if _GetInterruptFunc(l_24_arg2.Interrupt_GuardBegin)(l_24_arg2, l_24_arg0, l_24_arg1) then
         return true
      end
      if l_24_arg1:IsInterruptSubGoalChanged() then
         return true
      end
      return false
   end, bEmpty = l_16_arg0.Interrupt_GuardBegin == nil}
   l_16_2 = INTERUPT_GuardFinish
   l_16_1[l_16_2], l_16_3 = l_16_3, {func = function(l_25_arg0, l_25_arg1, l_25_arg2)
      if _GetInterruptFunc(l_25_arg2.Interrupt_GuardFinish)(l_25_arg2, l_25_arg0, l_25_arg1) then
         return true
      end
      if l_25_arg1:IsInterruptSubGoalChanged() then
         return true
      end
      return false
   end, bEmpty = l_16_arg0.Interrupt_GuardFinish == nil}
   l_16_2 = INTERUPT_GuardBreak
   l_16_1[l_16_2], l_16_3 = l_16_3, {func = function(l_26_arg0, l_26_arg1, l_26_arg2)
      if _GetInterruptFunc(l_26_arg2.Interrupt_GuardBreak)(l_26_arg2, l_26_arg0, l_26_arg1) then
         return true
      end
      if l_26_arg1:IsInterruptSubGoalChanged() then
         return true
      end
      return false
   end, bEmpty = l_16_arg0.Interrupt_GuardBreak == nil}
   l_16_2 = INTERUPT_Shoot
   l_16_1[l_16_2], l_16_3 = l_16_3, {func = function(l_27_arg0, l_27_arg1, l_27_arg2)
      if _GetInterruptFunc(l_27_arg2.Interrupt_Shoot)(l_27_arg2, l_27_arg0, l_27_arg1) then
         return true
      end
      if l_27_arg1:IsInterruptSubGoalChanged() then
         return true
      end
      return false
   end, bEmpty = l_16_arg0.Interrupt_Shoot == nil}
   l_16_2 = INTERUPT_ShootReady
   l_16_1[l_16_2], l_16_3 = l_16_3, {func = function(l_28_arg0, l_28_arg1, l_28_arg2)
      if _GetInterruptFunc(l_28_arg2.Interrupt_ShootReady)(l_28_arg2, l_28_arg0, l_28_arg1) then
         return true
      end
      if l_28_arg1:IsInterruptSubGoalChanged() then
         return true
      end
      return false
   end, bEmpty = l_16_arg0.Interrupt_ShootReady == nil}
   l_16_2 = INTERUPT_UseItem
   l_16_1[l_16_2], l_16_3 = l_16_3, {func = function(l_29_arg0, l_29_arg1, l_29_arg2)
      if _GetInterruptFunc(l_29_arg2.Interrupt_UseItem)(l_29_arg2, l_29_arg0, l_29_arg1) then
         return true
      end
      if l_29_arg1:IsInterruptSubGoalChanged() then
         return true
      end
      return false
   end, bEmpty = l_16_arg0.Interrupt_UseItem == nil}
   l_16_2 = INTERUPT_EnterBattleArea
   l_16_1[l_16_2], l_16_3 = l_16_3, {func = function(l_30_arg0, l_30_arg1, l_30_arg2)
      if _GetInterruptFunc(l_30_arg2.Interrupt_EnterBattleArea)(l_30_arg2, l_30_arg0, l_30_arg1) then
         return true
      end
      if l_30_arg1:IsInterruptSubGoalChanged() then
         return true
      end
      return false
   end, bEmpty = l_16_arg0.Interrupt_EnterBattleArea == nil}
   l_16_2 = INTERUPT_LeaveBattleArea
   l_16_1[l_16_2], l_16_3 = l_16_3, {func = function(l_31_arg0, l_31_arg1, l_31_arg2)
      if _GetInterruptFunc(l_31_arg2.Interrupt_LeaveBattleArea)(l_31_arg2, l_31_arg0, l_31_arg1) then
         return true
      end
      if l_31_arg1:IsInterruptSubGoalChanged() then
         return true
      end
      return false
   end, bEmpty = l_16_arg0.Interrupt_LeaveBattleArea == nil}
   l_16_2 = INTERUPT_CANNOT_MOVE
   l_16_1[l_16_2], l_16_3 = l_16_3, {func = function(l_32_arg0, l_32_arg1, l_32_arg2)
      if _GetInterruptFunc(l_32_arg2.Interrupt_CANNOT_MOVE)(l_32_arg2, l_32_arg0, l_32_arg1) then
         return true
      end
      if l_32_arg1:IsInterruptSubGoalChanged() then
         return true
      end
      return false
   end, bEmpty = l_16_arg0.Interrupt_CANNOT_MOVE == nil}
   l_16_2 = INTERUPT_Inside_ObserveArea
   l_16_1[l_16_2], l_16_3 = l_16_3, {func = function(l_33_arg0, l_33_arg1, l_33_arg2)
      if _InterruptTableGoal_Inside_ObserveArea(l_33_arg2, l_33_arg0, l_33_arg1) then
         return true
      end
      if l_33_arg1:IsInterruptSubGoalChanged() then
         return true
      end
      return false
   end, bEmpty = l_16_arg0.Interrupt_Inside_ObserveArea == nil}
   l_16_2 = INTERUPT_ReboundByOpponentGuard
   l_16_1[l_16_2], l_16_3 = l_16_3, {func = function(l_34_arg0, l_34_arg1, l_34_arg2)
      if _GetInterruptFunc(l_34_arg2.Interrupt_ReboundByOpponentGuard)(l_34_arg2, l_34_arg0, l_34_arg1) then
         return true
      end
      if l_34_arg1:IsInterruptSubGoalChanged() then
         return true
      end
      return false
   end, bEmpty = l_16_arg0.Interrupt_ReboundByOpponentGuard == nil}
   l_16_2 = INTERUPT_ForgetTarget
   l_16_1[l_16_2], l_16_3 = l_16_3, {func = function(l_35_arg0, l_35_arg1, l_35_arg2)
      if _GetInterruptFunc(l_35_arg2.Interrupt_ForgetTarget)(l_35_arg2, l_35_arg0, l_35_arg1) then
         return true
      end
      if l_35_arg1:IsInterruptSubGoalChanged() then
         return true
      end
      return false
   end, bEmpty = l_16_arg0.Interrupt_ForgetTarget == nil}
   l_16_2 = INTERUPT_FriendRequestSupport
   l_16_1[l_16_2], l_16_3 = l_16_3, {func = function(l_36_arg0, l_36_arg1, l_36_arg2)
      if _GetInterruptFunc(l_36_arg2.Interrupt_FriendRequestSupport)(l_36_arg2, l_36_arg0, l_36_arg1) then
         return true
      end
      if l_36_arg1:IsInterruptSubGoalChanged() then
         return true
      end
      return false
   end, bEmpty = l_16_arg0.Interrupt_FriendRequestSupport == nil}
   l_16_2 = INTERUPT_TargetIsGuard
   l_16_1[l_16_2], l_16_3 = l_16_3, {func = function(l_37_arg0, l_37_arg1, l_37_arg2)
      if _GetInterruptFunc(l_37_arg2.Interrupt_TargetIsGuard)(l_37_arg2, l_37_arg0, l_37_arg1) then
         return true
      end
      if l_37_arg1:IsInterruptSubGoalChanged() then
         return true
      end
      return false
   end, bEmpty = l_16_arg0.Interrupt_TargetIsGuard == nil}
   l_16_2 = INTERUPT_HitEnemyWall
   l_16_1[l_16_2], l_16_3 = l_16_3, {func = function(l_38_arg0, l_38_arg1, l_38_arg2)
      if _GetInterruptFunc(l_38_arg2.Interrupt_HitEnemyWall)(l_38_arg2, l_38_arg0, l_38_arg1) then
         return true
      end
      if l_38_arg1:IsInterruptSubGoalChanged() then
         return true
      end
      return false
   end, bEmpty = l_16_arg0.Interrupt_HitEnemyWall == nil}
   l_16_2 = INTERUPT_SuccessParry
   l_16_1[l_16_2], l_16_3 = l_16_3, {func = function(l_39_arg0, l_39_arg1, l_39_arg2)
      if _GetInterruptFunc(l_39_arg2.Interrupt_SuccessParry)(l_39_arg2, l_39_arg0, l_39_arg1) then
         return true
      end
      if l_39_arg1:IsInterruptSubGoalChanged() then
         return true
      end
      return false
   end, bEmpty = l_16_arg0.Interrupt_SuccessParry == nil}
   l_16_2 = INTERUPT_CANNOT_MOVE_DisableInterupt
   l_16_1[l_16_2], l_16_3 = l_16_3, {func = function(l_40_arg0, l_40_arg1, l_40_arg2)
      if _GetInterruptFunc(l_40_arg2.Interrupt_CANNOT_MOVE_DisableInterupt)(l_40_arg2, l_40_arg0, l_40_arg1) then
         return true
      end
      if l_40_arg1:IsInterruptSubGoalChanged() then
         return true
      end
      return false
   end, bEmpty = l_16_arg0.Interrupt_CANNOT_MOVE_DisableInterupt == nil}
   l_16_2 = INTERUPT_ParryTiming
   l_16_1[l_16_2], l_16_3 = l_16_3, {func = function(l_41_arg0, l_41_arg1, l_41_arg2)
      if _GetInterruptFunc(l_41_arg2.Interrupt_ParryTiming)(l_41_arg2, l_41_arg0, l_41_arg1) then
         return true
      end
      if l_41_arg1:IsInterruptSubGoalChanged() then
         return true
      end
      return false
   end, bEmpty = l_16_arg0.Interrupt_ParryTiming == nil}
   l_16_2 = INTERUPT_RideNode_LadderBottom
   l_16_1[l_16_2], l_16_3 = l_16_3, {func = function(l_42_arg0, l_42_arg1, l_42_arg2)
      if _GetInterruptFunc(l_42_arg2.Interrupt_RideNode_LadderBottom)(l_42_arg2, l_42_arg0, l_42_arg1) then
         return true
      end
      if l_42_arg1:IsInterruptSubGoalChanged() then
         return true
      end
      return false
   end, bEmpty = l_16_arg0.Interrupt_RideNode_LadderBottom == nil}
   l_16_2 = INTERUPT_FLAG_RideNode_Door
   l_16_1[l_16_2], l_16_3 = l_16_3, {func = function(l_43_arg0, l_43_arg1, l_43_arg2)
      if _GetInterruptFunc(l_43_arg2.Interrupt_FLAG_RideNode_Door)(l_43_arg2, l_43_arg0, l_43_arg1) then
         return true
      end
      if l_43_arg1:IsInterruptSubGoalChanged() then
         return true
      end
      return false
   end, bEmpty = l_16_arg0.Interrupt_FLAG_RideNode_Door == nil}
   l_16_2 = INTERUPT_StraightByPath
   l_16_1[l_16_2], l_16_3 = l_16_3, {func = function(l_44_arg0, l_44_arg1, l_44_arg2)
      if _GetInterruptFunc(l_44_arg2.Interrupt_StraightByPath)(l_44_arg2, l_44_arg0, l_44_arg1) then
         return true
      end
      if l_44_arg1:IsInterruptSubGoalChanged() then
         return true
      end
      return false
   end, bEmpty = l_16_arg0.Interrupt_StraightByPath == nil}
   l_16_2 = INTERUPT_ChangedAnimIdOffset
   l_16_1[l_16_2], l_16_3 = l_16_3, {func = function(l_45_arg0, l_45_arg1, l_45_arg2)
      if _GetInterruptFunc(l_45_arg2.Interrupt_ChangedAnimIdOffset)(l_45_arg2, l_45_arg0, l_45_arg1) then
         return true
      end
      if l_45_arg1:IsInterruptSubGoalChanged() then
         return true
      end
      return false
   end, bEmpty = l_16_arg0.Interrupt_ChangedAnimIdOffset == nil}
   l_16_2 = INTERUPT_SuccessThrow
   l_16_1[l_16_2], l_16_3 = l_16_3, {func = function(l_46_arg0, l_46_arg1, l_46_arg2)
      if _GetInterruptFunc(l_46_arg2.Interrupt_SuccessThrow)(l_46_arg2, l_46_arg0, l_46_arg1) then
         return true
      end
      if l_46_arg1:IsInterruptSubGoalChanged() then
         return true
      end
      return false
   end, bEmpty = l_16_arg0.Interrupt_SuccessThrow == nil}
   l_16_2 = INTERUPT_LookedTarget
   l_16_1[l_16_2], l_16_3 = l_16_3, {func = function(l_47_arg0, l_47_arg1, l_47_arg2)
      if _GetInterruptFunc(l_47_arg2.Interrupt_LookedTarget)(l_47_arg2, l_47_arg0, l_47_arg1) then
         return true
      end
      if l_47_arg1:IsInterruptSubGoalChanged() then
         return true
      end
      return false
   end, bEmpty = l_16_arg0.Interrupt_LookedTarget == nil}
   l_16_2 = INTERUPT_LoseSightTarget
   l_16_1[l_16_2], l_16_3 = l_16_3, {func = function(l_48_arg0, l_48_arg1, l_48_arg2)
      if _GetInterruptFunc(l_48_arg2.Interrupt_LoseSightTarget)(l_48_arg2, l_48_arg0, l_48_arg1) then
         return true
      end
      if l_48_arg1:IsInterruptSubGoalChanged() then
         return true
      end
      return false
   end, bEmpty = l_16_arg0.Interrupt_LoseSightTarget == nil}
   l_16_2 = INTERUPT_RideNode_InsideWall
   l_16_1[l_16_2], l_16_3 = l_16_3, {func = function(l_49_arg0, l_49_arg1, l_49_arg2)
      if _GetInterruptFunc(l_49_arg2.Interrupt_RideNode_InsideWall)(l_49_arg2, l_49_arg0, l_49_arg1) then
         return true
      end
      if l_49_arg1:IsInterruptSubGoalChanged() then
         return true
      end
      return false
   end, bEmpty = l_16_arg0.Interrupt_RideNode_InsideWall == nil}
   l_16_2 = INTERUPT_MissSwingSelf
   l_16_1[l_16_2], l_16_3 = l_16_3, {func = function(l_50_arg0, l_50_arg1, l_50_arg2)
      if _GetInterruptFunc(l_50_arg2.Interrupt_MissSwingSelf)(l_50_arg2, l_50_arg0, l_50_arg1) then
         return true
      end
      if l_50_arg1:IsInterruptSubGoalChanged() then
         return true
      end
      return false
   end, bEmpty = l_16_arg0.Interrupt_MissSwingSelf == nil}
   l_16_2 = INTERUPT_GuardBreakBlow
   l_16_1[l_16_2], l_16_3 = l_16_3, {func = function(l_51_arg0, l_51_arg1, l_51_arg2)
      if _GetInterruptFunc(l_51_arg2.Interrupt_GuardBreakBlow)(l_51_arg2, l_51_arg0, l_51_arg1) then
         return true
      end
      if l_51_arg1:IsInterruptSubGoalChanged() then
         return true
      end
      return false
   end, bEmpty = l_16_arg0.Interrupt_GuardBreakBlow == nil}
   l_16_2 = INTERUPT_TargetOutOfRange
   l_16_1[l_16_2], l_16_3 = l_16_3, {func = function(l_52_arg0, l_52_arg1, l_52_arg2)
      if _InterruptTableGoal_TargetOutOfRange(l_52_arg2, l_52_arg0, l_52_arg1) then
         return true
      end
      if l_52_arg1:IsInterruptSubGoalChanged() then
         return true
      end
      return false
   end, bEmpty = l_16_arg0.Interrupt_TargetOutOfRange == nil}
   l_16_2 = INTERUPT_UnstableFloor
   l_16_1[l_16_2], l_16_3 = l_16_3, {func = function(l_53_arg0, l_53_arg1, l_53_arg2)
      if _GetInterruptFunc(l_53_arg2.Interrupt_UnstableFloor)(l_53_arg2, l_53_arg0, l_53_arg1) then
         return true
      end
      if l_53_arg1:IsInterruptSubGoalChanged() then
         return true
      end
      return false
   end, bEmpty = l_16_arg0.Interrupt_UnstableFloor == nil}
   l_16_2 = INTERUPT_BreakFloor
   l_16_1[l_16_2], l_16_3 = l_16_3, {func = function(l_54_arg0, l_54_arg1, l_54_arg2)
      if _GetInterruptFunc(l_54_arg2.Interrupt_BreakFloor)(l_54_arg2, l_54_arg0, l_54_arg1) then
         return true
      end
      if l_54_arg1:IsInterruptSubGoalChanged() then
         return true
      end
      return false
   end, bEmpty = l_16_arg0.Interrupt_BreakFloor == nil}
   l_16_2 = INTERUPT_BreakObserveObj
   l_16_1[l_16_2], l_16_3 = l_16_3, {func = function(l_55_arg0, l_55_arg1, l_55_arg2)
      if _GetInterruptFunc(l_55_arg2.Interrupt_BreakObserveObj)(l_55_arg2, l_55_arg0, l_55_arg1) then
         return true
      end
      if l_55_arg1:IsInterruptSubGoalChanged() then
         return true
      end
      return false
   end, bEmpty = l_16_arg0.Interrupt_BreakObserveObj == nil}
   l_16_2 = INTERUPT_EventRequest
   l_16_1[l_16_2], l_16_3 = l_16_3, {func = function(l_56_arg0, l_56_arg1, l_56_arg2)
      if _GetInterruptFunc(l_56_arg2.Interrupt_EventRequest)(l_56_arg2, l_56_arg0, l_56_arg1) then
         return true
      end
      if l_56_arg1:IsInterruptSubGoalChanged() then
         return true
      end
      return false
   end, bEmpty = l_16_arg0.Interrupt_EventRequest == nil}
   l_16_2 = INTERUPT_Outside_ObserveArea
   l_16_1[l_16_2], l_16_3 = l_16_3, {func = function(l_57_arg0, l_57_arg1, l_57_arg2)
      if _InterruptTableGoal_Outside_ObserveArea(l_57_arg2, l_57_arg0, l_57_arg1) then
         return true
      end
      if l_57_arg1:IsInterruptSubGoalChanged() then
         return true
      end
      return false
   end, bEmpty = l_16_arg0.Interrupt_Outside_ObserveArea == nil}
   l_16_2 = INTERUPT_TargetOutOfAngle
   l_16_1[l_16_2], l_16_3 = l_16_3, {func = function(l_58_arg0, l_58_arg1, l_58_arg2)
      if _InterruptTableGoal_TargetOutOfAngle(l_58_arg2, l_58_arg0, l_58_arg1) then
         return true
      end
      if l_58_arg1:IsInterruptSubGoalChanged() then
         return true
      end
      return false
   end, bEmpty = l_16_arg0.Interrupt_TargetOutOfAngle == nil}
   l_16_2 = INTERUPT_PlatoonAiOrder
   l_16_1[l_16_2], l_16_3 = l_16_3, {func = function(l_59_arg0, l_59_arg1, l_59_arg2)
      if _GetInterruptFunc(l_59_arg2.Interrupt_PlatoonAiOrder)(l_59_arg2, l_59_arg0, l_59_arg1) then
         return true
      end
      if l_59_arg1:IsInterruptSubGoalChanged() then
         return true
      end
      return false
   end, bEmpty = l_16_arg0.Interrupt_PlatoonAiOrder == nil}
   l_16_2 = INTERUPT_ActivateSpecialEffect
   l_16_1[l_16_2], l_16_3 = l_16_3, {func = function(l_60_arg0, l_60_arg1, l_60_arg2)
      if _InterruptTableGoal_ActivateSpecialEffect(l_60_arg2, l_60_arg0, l_60_arg1) then
         return true
      end
      if l_60_arg1:IsInterruptSubGoalChanged() then
         return true
      end
      return false
   end, bEmpty = l_16_arg0.Interrupt_ActivateSpecialEffect == nil}
   l_16_2 = INTERUPT_InactivateSpecialEffect
   l_16_1[l_16_2], l_16_3 = l_16_3, {func = function(l_61_arg0, l_61_arg1, l_61_arg2)
      if _InterruptTableGoal_InactivateSpecialEffect(l_61_arg2, l_61_arg0, l_61_arg1) then
         return true
      end
      if l_61_arg1:IsInterruptSubGoalChanged() then
         return true
      end
      return false
   end, bEmpty = l_16_arg0.Interrupt_InactivateSpecialEffect == nil}
   l_16_2 = INTERUPT_MovedEnd_OnFailedPath
   l_16_1[l_16_2], l_16_3 = l_16_3, {func = function(l_62_arg0, l_62_arg1, l_62_arg2)
      if _GetInterruptFunc(l_62_arg2.Interrupt_MovedEnd_OnFailedPath)(l_62_arg2, l_62_arg0, l_62_arg1) then
         return true
      end
      if l_62_arg1:IsInterruptSubGoalChanged() then
         return true
      end
      return false
   end, bEmpty = l_16_arg0.Interrupt_MovedEnd_OnFailedPath == nil}
   l_16_2 = INTERUPT_ChangeSoundTarget
   l_16_1[l_16_2], l_16_3 = l_16_3, {func = function(l_63_arg0, l_63_arg1, l_63_arg2)
      if _GetInterruptFunc(l_63_arg2.Interrupt_ChangeSoundTarget)(l_63_arg2, l_63_arg0, l_63_arg1) then
         return true
      end
      if l_63_arg1:IsInterruptSubGoalChanged() then
         return true
      end
      return false
   end, bEmpty = l_16_arg0.Interrupt_ChangeSoundTarget == nil}
   l_16_2 = INTERUPT_OnCreateDamage
   l_16_1[l_16_2], l_16_3 = l_16_3, {func = function(l_64_arg0, l_64_arg1, l_64_arg2)
      if _GetInterruptFunc(l_64_arg2.Interrupt_OnCreateDamage)(l_64_arg2, l_64_arg0, l_64_arg1) then
         return true
      end
      if l_64_arg1:IsInterruptSubGoalChanged() then
         return true
      end
      return false
   end, bEmpty = l_16_arg0.Interrupt_OnCreateDamage == nil}
   l_16_2 = INTERUPT_InvadeTriggerRegion
   l_16_1[l_16_2], l_16_3 = l_16_3, {func = function(l_65_arg0, l_65_arg1, l_65_arg2)
      if _InterruptTableGoal_InvadeTriggerRegion(l_65_arg2, l_65_arg0, l_65_arg1) then
         return true
      end
      if l_65_arg1:IsInterruptSubGoalChanged() then
         return true
      end
      return false
   end, bEmpty = l_16_arg0.Interrupt_InvadeTriggerRegion == nil}
   l_16_2 = INTERUPT_LeaveTriggerRegion
   l_16_1[l_16_2], l_16_3 = l_16_3, {func = function(l_66_arg0, l_66_arg1, l_66_arg2)
      if _InterruptTableGoal_LeaveTriggerRegion(l_66_arg2, l_66_arg0, l_66_arg1) then
         return true
      end
      if l_66_arg1:IsInterruptSubGoalChanged() then
         return true
      end
      return false
   end, bEmpty = l_16_arg0.Interrupt_LeaveTriggerRegion == nil}
   l_16_2 = INTERUPT_AIGuardBroken
   l_16_1[l_16_2], l_16_3 = l_16_3, {func = function(l_67_arg0, l_67_arg1, l_67_arg2)
      if _GetInterruptFunc(l_67_arg2.Interrupt_AIGuardBroken)(l_67_arg2, l_67_arg0, l_67_arg1) then
         return true
      end
      if l_67_arg1:IsInterruptSubGoalChanged() then
         return true
      end
      return false
   end, bEmpty = l_16_arg0.Interrupt_AIGuardBroken == nil}
   l_16_2 = INTERUPT_AIReboundByOpponentGuard
   l_16_1[l_16_2], l_16_3 = l_16_3, {func = function(l_68_arg0, l_68_arg1, l_68_arg2)
      if _GetInterruptFunc(l_68_arg2.Interrupt_AIReboundByOpponentGuard)(l_68_arg2, l_68_arg0, l_68_arg1) then
         return true
      end
      if l_68_arg1:IsInterruptSubGoalChanged() then
         return true
      end
      return false
   end, bEmpty = l_16_arg0.Interrupt_AIReboundByOpponentGuard == nil}
   l_16_2 = INTERUPT_BackstabRisk
   l_16_1[l_16_2], l_16_3 = l_16_3, {func = function(l_69_arg0, l_69_arg1, l_69_arg2)
      if _GetInterruptFunc(l_69_arg2.Interrupt_BackstabRisk)(l_69_arg2, l_69_arg0, l_69_arg1) then
         return true
      end
      if l_69_arg1:IsInterruptSubGoalChanged() then
         return true
      end
      return false
   end, bEmpty = l_16_arg0.Interrupt_BackstabRisk == nil}
   return l_16_1
end

_GetInterruptFunc = function(l_17_arg0)
   if l_17_arg0 ~= nil then
      return l_17_arg0
   end
   return _InterruptTableGoal_TypeCall_Dummy
end

_InterruptTableGoal_TypeCall_Dummy = function()
   return false
end

_InterruptTableGoal_TargetOutOfRange_Common = function(l_19_arg0, l_19_arg1, l_19_arg2, l_19_arg3, l_19_arg4)
   local l_19_5 = false
   for l_19_6 = 0, 31 do
      if l_19_arg3(l_19_6) then
         l_19_5 = true
         if l_19_arg4(l_19_arg0, l_19_arg1, l_19_arg2, l_19_6) then
            return true
         end
      end
   end
   if bSlotEnable then
      return false
   end
   return l_19_arg4(l_19_arg0, l_19_arg1, l_19_arg2, -1)
end

_InterruptTableGoal_TargetOutOfRange = function(l_20_arg0, l_20_arg1, l_20_arg2)
   local l_20_3 = _InterruptTableGoal_TargetOutOfRange_Common
   local l_20_4 = l_20_arg0
   local l_20_5 = l_20_arg1
   local l_20_6 = l_20_arg2
   local l_20_8, l_20_9 = function(l_21_arg0)
      return l_20_arg1:IsTargetOutOfRangeInterruptSlot(l_21_arg0)
   end, _GetInterruptFunc(l_20_arg0.Interrupt_TargetOutOfRange)
   return l_20_3(l_20_4, l_20_5, l_20_6, l_20_8, l_20_9)
   --[[ DECOMPILER ERROR 1029: Confused about usage of registers for local variables ]]
end

_InterruptTableGoal_TargetOutOfAngle = function(l_21_arg0, l_21_arg1, l_21_arg2)
   local l_21_3 = _InterruptTableGoal_TargetOutOfRange_Common
   local l_21_4 = l_21_arg0
   local l_21_5 = l_21_arg1
   local l_21_6 = l_21_arg2
   local l_21_8, l_21_9 = function(l_22_arg0)
      return l_21_arg1:IsTargetOutOfAngleInterruptSlot(l_22_arg0)
   end, _GetInterruptFunc(l_21_arg0.Interrupt_TargetOutOfAngle)
   return l_21_3(l_21_4, l_21_5, l_21_6, l_21_8, l_21_9)
   --[[ DECOMPILER ERROR 1029: Confused about usage of registers for local variables ]]
end

_InterruptTableGoal_Inside_ObserveArea = function(l_22_arg0, l_22_arg1, l_22_arg2)
   local l_22_3 = l_22_arg1:GetAreaObserveSlotNum(AI_AREAOBSERVE_INTERRUPT__INSIDE)
   for l_22_4 = 0, l_22_3 - 1 do
      if _GetInterruptFunc(l_22_arg0.Interrupt_Inside_ObserveArea)(l_22_arg0, l_22_arg1, l_22_arg2, l_22_arg1:GetAreaObserveSlot(AI_AREAOBSERVE_INTERRUPT__INSIDE, l_22_4)) then
         return true
      end
   end
end

_InterruptTableGoal_Outside_ObserveArea = function(l_23_arg0, l_23_arg1, l_23_arg2)
   local l_23_3 = l_23_arg1:GetAreaObserveSlotNum(AI_AREAOBSERVE_INTERRUPT__OUTSIDE)
   for l_23_4 = 0, l_23_3 - 1 do
      if _GetInterruptFunc(l_23_arg0.Interrupt_Outside_ObserveArea)(l_23_arg0, l_23_arg1, l_23_arg2, l_23_arg1:GetAreaObserveSlot(AI_AREAOBSERVE_INTERRUPT__OUTSIDE, l_23_4)) then
         return true
      end
   end
end

_InterruptTableGoal_ActivateSpecialEffect = function(l_24_arg0, l_24_arg1, l_24_arg2)
   local l_24_3 = l_24_arg1:GetSpecialEffectActivateInterruptNum()
   for l_24_4 = 0, l_24_3 - 1 do
      if _GetInterruptFunc(l_24_arg0.Interrupt_ActivateSpecialEffect)(l_24_arg0, l_24_arg1, l_24_arg2, l_24_arg1:GetSpecialEffectActivateInterruptType(l_24_4)) then
         return true
      end
   end
end

_InterruptTableGoal_InactivateSpecialEffect = function(l_25_arg0, l_25_arg1, l_25_arg2)
   local l_25_3 = l_25_arg1:GetSpecialEffectInactivateInterruptNum()
   for l_25_4 = 0, l_25_3 - 1 do
      if _GetInterruptFunc(l_25_arg0.Interrupt_InactivateSpecialEffect)(l_25_arg0, l_25_arg1, l_25_arg2, l_25_arg1:GetSpecialEffectInactivateInterruptType(l_25_4)) then
         return true
      end
   end
end

_InterruptTableGoal_InvadeTriggerRegion = function(l_26_arg0, l_26_arg1, l_26_arg2)
   local l_26_3 = l_26_arg1:GetInvadeTriggerRegionCategoryNum()
   for l_26_4 = 0, l_26_3 - 1 do
      if _GetInterruptFunc(l_26_arg0.Interrupt_InvadeTriggerRegion)(l_26_arg0, l_26_arg1, l_26_arg2, l_26_arg1:GetInvadeTriggerRegionCategory(l_26_4)) then
         return true
      end
   end
end

_InterruptTableGoal_LeaveTriggerRegion = function(l_27_arg0, l_27_arg1, l_27_arg2)
   local l_27_3 = l_27_arg1:GetLeaveTriggerRegionCategoryNum()
   for l_27_4 = 0, l_27_3 - 1 do
      if _GetInterruptFunc(l_27_arg0.Interrupt_InvadeTriggerRegion)(l_27_arg0, l_27_arg1, l_27_arg2, l_27_arg1:GetLeaveTriggerRegionCategory(l_27_4)) then
         return true
      end
   end
end


