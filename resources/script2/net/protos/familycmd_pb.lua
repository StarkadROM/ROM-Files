local protobuf = protobuf
autoImport("xCmd_pb")
local xCmd_pb = xCmd_pb
module("FamilyCmd_pb")
FAMILYPARAM = protobuf.EnumDescriptor()
FAMILYPARAM_FAMILYPARAM_CLUE_DATA_NTF_ENUM = protobuf.EnumValueDescriptor()
FAMILYPARAM_FAMILYPARAM_CLUE_UNLOCK_ENUM = protobuf.EnumValueDescriptor()
FAMILYPARAM_FAMILYPARAM_CLUE_REWARD_ENUM = protobuf.EnumValueDescriptor()
EFAMILYCLUESTATE = protobuf.EnumDescriptor()
EFAMILYCLUESTATE_EFAMILYCLUE_STATE_INIT_ENUM = protobuf.EnumValueDescriptor()
EFAMILYCLUESTATE_EFAMILYCLUE_STATE_UNLOCK_ENUM = protobuf.EnumValueDescriptor()
EFAMILYCLUESTATE_EFAMILYCLUE_STATE_REWARD_ENUM = protobuf.EnumValueDescriptor()
FAMILYCLUEDATA = protobuf.Descriptor()
FAMILYCLUEDATA_ID_FIELD = protobuf.FieldDescriptor()
FAMILYCLUEDATA_STATE_FIELD = protobuf.FieldDescriptor()
CLUEDATANTFFAMILYCMD = protobuf.Descriptor()
CLUEDATANTFFAMILYCMD_CMD_FIELD = protobuf.FieldDescriptor()
CLUEDATANTFFAMILYCMD_PARAM_FIELD = protobuf.FieldDescriptor()
CLUEDATANTFFAMILYCMD_DATAS_FIELD = protobuf.FieldDescriptor()
CLUEUNLOCKFAMILYCMD = protobuf.Descriptor()
CLUEUNLOCKFAMILYCMD_CMD_FIELD = protobuf.FieldDescriptor()
CLUEUNLOCKFAMILYCMD_PARAM_FIELD = protobuf.FieldDescriptor()
CLUEUNLOCKFAMILYCMD_ID_FIELD = protobuf.FieldDescriptor()
CLUEUNLOCKFAMILYCMD_DATA_FIELD = protobuf.FieldDescriptor()
CLUEREWARDFAMILYCMD = protobuf.Descriptor()
CLUEREWARDFAMILYCMD_CMD_FIELD = protobuf.FieldDescriptor()
CLUEREWARDFAMILYCMD_PARAM_FIELD = protobuf.FieldDescriptor()
CLUEREWARDFAMILYCMD_ID_FIELD = protobuf.FieldDescriptor()
CLUEREWARDFAMILYCMD_DATA_FIELD = protobuf.FieldDescriptor()
FAMILYPARAM_FAMILYPARAM_CLUE_DATA_NTF_ENUM.name = "FAMILYPARAM_CLUE_DATA_NTF"
FAMILYPARAM_FAMILYPARAM_CLUE_DATA_NTF_ENUM.index = 0
FAMILYPARAM_FAMILYPARAM_CLUE_DATA_NTF_ENUM.number = 1
FAMILYPARAM_FAMILYPARAM_CLUE_UNLOCK_ENUM.name = "FAMILYPARAM_CLUE_UNLOCK"
FAMILYPARAM_FAMILYPARAM_CLUE_UNLOCK_ENUM.index = 1
FAMILYPARAM_FAMILYPARAM_CLUE_UNLOCK_ENUM.number = 2
FAMILYPARAM_FAMILYPARAM_CLUE_REWARD_ENUM.name = "FAMILYPARAM_CLUE_REWARD"
FAMILYPARAM_FAMILYPARAM_CLUE_REWARD_ENUM.index = 2
FAMILYPARAM_FAMILYPARAM_CLUE_REWARD_ENUM.number = 3
FAMILYPARAM.name = "FamilyParam"
FAMILYPARAM.full_name = ".Cmd.FamilyParam"
FAMILYPARAM.values = {
  FAMILYPARAM_FAMILYPARAM_CLUE_DATA_NTF_ENUM,
  FAMILYPARAM_FAMILYPARAM_CLUE_UNLOCK_ENUM,
  FAMILYPARAM_FAMILYPARAM_CLUE_REWARD_ENUM
}
EFAMILYCLUESTATE_EFAMILYCLUE_STATE_INIT_ENUM.name = "EFAMILYCLUE_STATE_INIT"
EFAMILYCLUESTATE_EFAMILYCLUE_STATE_INIT_ENUM.index = 0
EFAMILYCLUESTATE_EFAMILYCLUE_STATE_INIT_ENUM.number = 0
EFAMILYCLUESTATE_EFAMILYCLUE_STATE_UNLOCK_ENUM.name = "EFAMILYCLUE_STATE_UNLOCK"
EFAMILYCLUESTATE_EFAMILYCLUE_STATE_UNLOCK_ENUM.index = 1
EFAMILYCLUESTATE_EFAMILYCLUE_STATE_UNLOCK_ENUM.number = 1
EFAMILYCLUESTATE_EFAMILYCLUE_STATE_REWARD_ENUM.name = "EFAMILYCLUE_STATE_REWARD"
EFAMILYCLUESTATE_EFAMILYCLUE_STATE_REWARD_ENUM.index = 2
EFAMILYCLUESTATE_EFAMILYCLUE_STATE_REWARD_ENUM.number = 2
EFAMILYCLUESTATE.name = "EFamilyClueState"
EFAMILYCLUESTATE.full_name = ".Cmd.EFamilyClueState"
EFAMILYCLUESTATE.values = {
  EFAMILYCLUESTATE_EFAMILYCLUE_STATE_INIT_ENUM,
  EFAMILYCLUESTATE_EFAMILYCLUE_STATE_UNLOCK_ENUM,
  EFAMILYCLUESTATE_EFAMILYCLUE_STATE_REWARD_ENUM
}
FAMILYCLUEDATA_ID_FIELD.name = "id"
FAMILYCLUEDATA_ID_FIELD.full_name = ".Cmd.FamilyClueData.id"
FAMILYCLUEDATA_ID_FIELD.number = 1
FAMILYCLUEDATA_ID_FIELD.index = 0
FAMILYCLUEDATA_ID_FIELD.label = 1
FAMILYCLUEDATA_ID_FIELD.has_default_value = false
FAMILYCLUEDATA_ID_FIELD.default_value = 0
FAMILYCLUEDATA_ID_FIELD.type = 13
FAMILYCLUEDATA_ID_FIELD.cpp_type = 3
FAMILYCLUEDATA_STATE_FIELD.name = "state"
FAMILYCLUEDATA_STATE_FIELD.full_name = ".Cmd.FamilyClueData.state"
FAMILYCLUEDATA_STATE_FIELD.number = 2
FAMILYCLUEDATA_STATE_FIELD.index = 1
FAMILYCLUEDATA_STATE_FIELD.label = 1
FAMILYCLUEDATA_STATE_FIELD.has_default_value = false
FAMILYCLUEDATA_STATE_FIELD.default_value = nil
FAMILYCLUEDATA_STATE_FIELD.enum_type = EFAMILYCLUESTATE
FAMILYCLUEDATA_STATE_FIELD.type = 14
FAMILYCLUEDATA_STATE_FIELD.cpp_type = 8
FAMILYCLUEDATA.name = "FamilyClueData"
FAMILYCLUEDATA.full_name = ".Cmd.FamilyClueData"
FAMILYCLUEDATA.nested_types = {}
FAMILYCLUEDATA.enum_types = {}
FAMILYCLUEDATA.fields = {
  FAMILYCLUEDATA_ID_FIELD,
  FAMILYCLUEDATA_STATE_FIELD
}
FAMILYCLUEDATA.is_extendable = false
FAMILYCLUEDATA.extensions = {}
CLUEDATANTFFAMILYCMD_CMD_FIELD.name = "cmd"
CLUEDATANTFFAMILYCMD_CMD_FIELD.full_name = ".Cmd.ClueDataNtfFamilyCmd.cmd"
CLUEDATANTFFAMILYCMD_CMD_FIELD.number = 1
CLUEDATANTFFAMILYCMD_CMD_FIELD.index = 0
CLUEDATANTFFAMILYCMD_CMD_FIELD.label = 1
CLUEDATANTFFAMILYCMD_CMD_FIELD.has_default_value = true
CLUEDATANTFFAMILYCMD_CMD_FIELD.default_value = 234
CLUEDATANTFFAMILYCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
CLUEDATANTFFAMILYCMD_CMD_FIELD.type = 14
CLUEDATANTFFAMILYCMD_CMD_FIELD.cpp_type = 8
CLUEDATANTFFAMILYCMD_PARAM_FIELD.name = "param"
CLUEDATANTFFAMILYCMD_PARAM_FIELD.full_name = ".Cmd.ClueDataNtfFamilyCmd.param"
CLUEDATANTFFAMILYCMD_PARAM_FIELD.number = 2
CLUEDATANTFFAMILYCMD_PARAM_FIELD.index = 1
CLUEDATANTFFAMILYCMD_PARAM_FIELD.label = 1
CLUEDATANTFFAMILYCMD_PARAM_FIELD.has_default_value = true
CLUEDATANTFFAMILYCMD_PARAM_FIELD.default_value = 1
CLUEDATANTFFAMILYCMD_PARAM_FIELD.enum_type = FAMILYPARAM
CLUEDATANTFFAMILYCMD_PARAM_FIELD.type = 14
CLUEDATANTFFAMILYCMD_PARAM_FIELD.cpp_type = 8
CLUEDATANTFFAMILYCMD_DATAS_FIELD.name = "datas"
CLUEDATANTFFAMILYCMD_DATAS_FIELD.full_name = ".Cmd.ClueDataNtfFamilyCmd.datas"
CLUEDATANTFFAMILYCMD_DATAS_FIELD.number = 3
CLUEDATANTFFAMILYCMD_DATAS_FIELD.index = 2
CLUEDATANTFFAMILYCMD_DATAS_FIELD.label = 3
CLUEDATANTFFAMILYCMD_DATAS_FIELD.has_default_value = false
CLUEDATANTFFAMILYCMD_DATAS_FIELD.default_value = {}
CLUEDATANTFFAMILYCMD_DATAS_FIELD.message_type = FAMILYCLUEDATA
CLUEDATANTFFAMILYCMD_DATAS_FIELD.type = 11
CLUEDATANTFFAMILYCMD_DATAS_FIELD.cpp_type = 10
CLUEDATANTFFAMILYCMD.name = "ClueDataNtfFamilyCmd"
CLUEDATANTFFAMILYCMD.full_name = ".Cmd.ClueDataNtfFamilyCmd"
CLUEDATANTFFAMILYCMD.nested_types = {}
CLUEDATANTFFAMILYCMD.enum_types = {}
CLUEDATANTFFAMILYCMD.fields = {
  CLUEDATANTFFAMILYCMD_CMD_FIELD,
  CLUEDATANTFFAMILYCMD_PARAM_FIELD,
  CLUEDATANTFFAMILYCMD_DATAS_FIELD
}
CLUEDATANTFFAMILYCMD.is_extendable = false
CLUEDATANTFFAMILYCMD.extensions = {}
CLUEUNLOCKFAMILYCMD_CMD_FIELD.name = "cmd"
CLUEUNLOCKFAMILYCMD_CMD_FIELD.full_name = ".Cmd.ClueUnlockFamilyCmd.cmd"
CLUEUNLOCKFAMILYCMD_CMD_FIELD.number = 1
CLUEUNLOCKFAMILYCMD_CMD_FIELD.index = 0
CLUEUNLOCKFAMILYCMD_CMD_FIELD.label = 1
CLUEUNLOCKFAMILYCMD_CMD_FIELD.has_default_value = true
CLUEUNLOCKFAMILYCMD_CMD_FIELD.default_value = 234
CLUEUNLOCKFAMILYCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
CLUEUNLOCKFAMILYCMD_CMD_FIELD.type = 14
CLUEUNLOCKFAMILYCMD_CMD_FIELD.cpp_type = 8
CLUEUNLOCKFAMILYCMD_PARAM_FIELD.name = "param"
CLUEUNLOCKFAMILYCMD_PARAM_FIELD.full_name = ".Cmd.ClueUnlockFamilyCmd.param"
CLUEUNLOCKFAMILYCMD_PARAM_FIELD.number = 2
CLUEUNLOCKFAMILYCMD_PARAM_FIELD.index = 1
CLUEUNLOCKFAMILYCMD_PARAM_FIELD.label = 1
CLUEUNLOCKFAMILYCMD_PARAM_FIELD.has_default_value = true
CLUEUNLOCKFAMILYCMD_PARAM_FIELD.default_value = 2
CLUEUNLOCKFAMILYCMD_PARAM_FIELD.enum_type = FAMILYPARAM
CLUEUNLOCKFAMILYCMD_PARAM_FIELD.type = 14
CLUEUNLOCKFAMILYCMD_PARAM_FIELD.cpp_type = 8
CLUEUNLOCKFAMILYCMD_ID_FIELD.name = "id"
CLUEUNLOCKFAMILYCMD_ID_FIELD.full_name = ".Cmd.ClueUnlockFamilyCmd.id"
CLUEUNLOCKFAMILYCMD_ID_FIELD.number = 3
CLUEUNLOCKFAMILYCMD_ID_FIELD.index = 2
CLUEUNLOCKFAMILYCMD_ID_FIELD.label = 1
CLUEUNLOCKFAMILYCMD_ID_FIELD.has_default_value = false
CLUEUNLOCKFAMILYCMD_ID_FIELD.default_value = 0
CLUEUNLOCKFAMILYCMD_ID_FIELD.type = 13
CLUEUNLOCKFAMILYCMD_ID_FIELD.cpp_type = 3
CLUEUNLOCKFAMILYCMD_DATA_FIELD.name = "data"
CLUEUNLOCKFAMILYCMD_DATA_FIELD.full_name = ".Cmd.ClueUnlockFamilyCmd.data"
CLUEUNLOCKFAMILYCMD_DATA_FIELD.number = 4
CLUEUNLOCKFAMILYCMD_DATA_FIELD.index = 3
CLUEUNLOCKFAMILYCMD_DATA_FIELD.label = 1
CLUEUNLOCKFAMILYCMD_DATA_FIELD.has_default_value = false
CLUEUNLOCKFAMILYCMD_DATA_FIELD.default_value = nil
CLUEUNLOCKFAMILYCMD_DATA_FIELD.message_type = FAMILYCLUEDATA
CLUEUNLOCKFAMILYCMD_DATA_FIELD.type = 11
CLUEUNLOCKFAMILYCMD_DATA_FIELD.cpp_type = 10
CLUEUNLOCKFAMILYCMD.name = "ClueUnlockFamilyCmd"
CLUEUNLOCKFAMILYCMD.full_name = ".Cmd.ClueUnlockFamilyCmd"
CLUEUNLOCKFAMILYCMD.nested_types = {}
CLUEUNLOCKFAMILYCMD.enum_types = {}
CLUEUNLOCKFAMILYCMD.fields = {
  CLUEUNLOCKFAMILYCMD_CMD_FIELD,
  CLUEUNLOCKFAMILYCMD_PARAM_FIELD,
  CLUEUNLOCKFAMILYCMD_ID_FIELD,
  CLUEUNLOCKFAMILYCMD_DATA_FIELD
}
CLUEUNLOCKFAMILYCMD.is_extendable = false
CLUEUNLOCKFAMILYCMD.extensions = {}
CLUEREWARDFAMILYCMD_CMD_FIELD.name = "cmd"
CLUEREWARDFAMILYCMD_CMD_FIELD.full_name = ".Cmd.ClueRewardFamilyCmd.cmd"
CLUEREWARDFAMILYCMD_CMD_FIELD.number = 1
CLUEREWARDFAMILYCMD_CMD_FIELD.index = 0
CLUEREWARDFAMILYCMD_CMD_FIELD.label = 1
CLUEREWARDFAMILYCMD_CMD_FIELD.has_default_value = true
CLUEREWARDFAMILYCMD_CMD_FIELD.default_value = 234
CLUEREWARDFAMILYCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
CLUEREWARDFAMILYCMD_CMD_FIELD.type = 14
CLUEREWARDFAMILYCMD_CMD_FIELD.cpp_type = 8
CLUEREWARDFAMILYCMD_PARAM_FIELD.name = "param"
CLUEREWARDFAMILYCMD_PARAM_FIELD.full_name = ".Cmd.ClueRewardFamilyCmd.param"
CLUEREWARDFAMILYCMD_PARAM_FIELD.number = 2
CLUEREWARDFAMILYCMD_PARAM_FIELD.index = 1
CLUEREWARDFAMILYCMD_PARAM_FIELD.label = 1
CLUEREWARDFAMILYCMD_PARAM_FIELD.has_default_value = true
CLUEREWARDFAMILYCMD_PARAM_FIELD.default_value = 3
CLUEREWARDFAMILYCMD_PARAM_FIELD.enum_type = FAMILYPARAM
CLUEREWARDFAMILYCMD_PARAM_FIELD.type = 14
CLUEREWARDFAMILYCMD_PARAM_FIELD.cpp_type = 8
CLUEREWARDFAMILYCMD_ID_FIELD.name = "id"
CLUEREWARDFAMILYCMD_ID_FIELD.full_name = ".Cmd.ClueRewardFamilyCmd.id"
CLUEREWARDFAMILYCMD_ID_FIELD.number = 3
CLUEREWARDFAMILYCMD_ID_FIELD.index = 2
CLUEREWARDFAMILYCMD_ID_FIELD.label = 1
CLUEREWARDFAMILYCMD_ID_FIELD.has_default_value = false
CLUEREWARDFAMILYCMD_ID_FIELD.default_value = 0
CLUEREWARDFAMILYCMD_ID_FIELD.type = 13
CLUEREWARDFAMILYCMD_ID_FIELD.cpp_type = 3
CLUEREWARDFAMILYCMD_DATA_FIELD.name = "data"
CLUEREWARDFAMILYCMD_DATA_FIELD.full_name = ".Cmd.ClueRewardFamilyCmd.data"
CLUEREWARDFAMILYCMD_DATA_FIELD.number = 4
CLUEREWARDFAMILYCMD_DATA_FIELD.index = 3
CLUEREWARDFAMILYCMD_DATA_FIELD.label = 1
CLUEREWARDFAMILYCMD_DATA_FIELD.has_default_value = false
CLUEREWARDFAMILYCMD_DATA_FIELD.default_value = nil
CLUEREWARDFAMILYCMD_DATA_FIELD.message_type = FAMILYCLUEDATA
CLUEREWARDFAMILYCMD_DATA_FIELD.type = 11
CLUEREWARDFAMILYCMD_DATA_FIELD.cpp_type = 10
CLUEREWARDFAMILYCMD.name = "ClueRewardFamilyCmd"
CLUEREWARDFAMILYCMD.full_name = ".Cmd.ClueRewardFamilyCmd"
CLUEREWARDFAMILYCMD.nested_types = {}
CLUEREWARDFAMILYCMD.enum_types = {}
CLUEREWARDFAMILYCMD.fields = {
  CLUEREWARDFAMILYCMD_CMD_FIELD,
  CLUEREWARDFAMILYCMD_PARAM_FIELD,
  CLUEREWARDFAMILYCMD_ID_FIELD,
  CLUEREWARDFAMILYCMD_DATA_FIELD
}
CLUEREWARDFAMILYCMD.is_extendable = false
CLUEREWARDFAMILYCMD.extensions = {}
ClueDataNtfFamilyCmd = protobuf.Message(CLUEDATANTFFAMILYCMD)
ClueRewardFamilyCmd = protobuf.Message(CLUEREWARDFAMILYCMD)
ClueUnlockFamilyCmd = protobuf.Message(CLUEUNLOCKFAMILYCMD)
EFAMILYCLUE_STATE_INIT = 0
EFAMILYCLUE_STATE_REWARD = 2
EFAMILYCLUE_STATE_UNLOCK = 1
FAMILYPARAM_CLUE_DATA_NTF = 1
FAMILYPARAM_CLUE_REWARD = 3
FAMILYPARAM_CLUE_UNLOCK = 2
FamilyClueData = protobuf.Message(FAMILYCLUEDATA)