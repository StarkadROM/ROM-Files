local protobuf = protobuf
autoImport("xCmd_pb")
local xCmd_pb = xCmd_pb
module("AstrolabeCmd_pb")
ASTROLABEPARAM = protobuf.EnumDescriptor()
ASTROLABEPARAM_ASTROLABEPARAM_QUERY_ENUM = protobuf.EnumValueDescriptor()
ASTROLABEPARAM_ASTROLABEPARAM_ACTIVATE_STAR_ENUM = protobuf.EnumValueDescriptor()
ASTROLABEPARAM_ASTROLABEPARAM_QUERY_RESET_ENUM = protobuf.EnumValueDescriptor()
ASTROLABEPARAM_ASTROLABEPARAM_RESET_ENUM = protobuf.EnumValueDescriptor()
ASTROLABEPARAM_ASTROLABEPARAM_PLAN_SAVE_ENUM = protobuf.EnumValueDescriptor()
EASTROLABETYPE = protobuf.EnumDescriptor()
EASTROLABETYPE_EASTROLABETYPE_MIN_ENUM = protobuf.EnumValueDescriptor()
EASTROLABETYPE_EASTROLABETYPE_PROFESSION_ENUM = protobuf.EnumValueDescriptor()
EASTROLABETYPE_EASTROLABETYPE_PLAN_ENUM = protobuf.EnumValueDescriptor()
EASTROLABETYPE_EASTROLABETYPE_MAX_ENUM = protobuf.EnumValueDescriptor()
ASTROLABECOSTDATA = protobuf.Descriptor()
ASTROLABECOSTDATA_ID_FIELD = protobuf.FieldDescriptor()
ASTROLABECOSTDATA_COUNT_FIELD = protobuf.FieldDescriptor()
ASTROLABEQUERYCMD = protobuf.Descriptor()
ASTROLABEQUERYCMD_CMD_FIELD = protobuf.FieldDescriptor()
ASTROLABEQUERYCMD_PARAM_FIELD = protobuf.FieldDescriptor()
ASTROLABEQUERYCMD_STARS_FIELD = protobuf.FieldDescriptor()
ASTROLABEQUERYCMD_ASTROLABETYPE_FIELD = protobuf.FieldDescriptor()
ASTROLABEACTIVATESTARCMD = protobuf.Descriptor()
ASTROLABEACTIVATESTARCMD_CMD_FIELD = protobuf.FieldDescriptor()
ASTROLABEACTIVATESTARCMD_PARAM_FIELD = protobuf.FieldDescriptor()
ASTROLABEACTIVATESTARCMD_STARS_FIELD = protobuf.FieldDescriptor()
ASTROLABEACTIVATESTARCMD_SUCCESS_FIELD = protobuf.FieldDescriptor()
ASTROLABEQUERYRESETCMD = protobuf.Descriptor()
ASTROLABEQUERYRESETCMD_CMD_FIELD = protobuf.FieldDescriptor()
ASTROLABEQUERYRESETCMD_PARAM_FIELD = protobuf.FieldDescriptor()
ASTROLABEQUERYRESETCMD_TYPE_FIELD = protobuf.FieldDescriptor()
ASTROLABEQUERYRESETCMD_ITEMS_FIELD = protobuf.FieldDescriptor()
ASTROLABERESETCMD = protobuf.Descriptor()
ASTROLABERESETCMD_CMD_FIELD = protobuf.FieldDescriptor()
ASTROLABERESETCMD_PARAM_FIELD = protobuf.FieldDescriptor()
ASTROLABERESETCMD_STARS_FIELD = protobuf.FieldDescriptor()
ASTROLABERESETCMD_SUCCESS_FIELD = protobuf.FieldDescriptor()
ASTROLABEPLANSAVECMD = protobuf.Descriptor()
ASTROLABEPLANSAVECMD_CMD_FIELD = protobuf.FieldDescriptor()
ASTROLABEPLANSAVECMD_PARAM_FIELD = protobuf.FieldDescriptor()
ASTROLABEPLANSAVECMD_STARS_FIELD = protobuf.FieldDescriptor()
ASTROLABEPARAM_ASTROLABEPARAM_QUERY_ENUM.name = "ASTROLABEPARAM_QUERY"
ASTROLABEPARAM_ASTROLABEPARAM_QUERY_ENUM.index = 0
ASTROLABEPARAM_ASTROLABEPARAM_QUERY_ENUM.number = 1
ASTROLABEPARAM_ASTROLABEPARAM_ACTIVATE_STAR_ENUM.name = "ASTROLABEPARAM_ACTIVATE_STAR"
ASTROLABEPARAM_ASTROLABEPARAM_ACTIVATE_STAR_ENUM.index = 1
ASTROLABEPARAM_ASTROLABEPARAM_ACTIVATE_STAR_ENUM.number = 2
ASTROLABEPARAM_ASTROLABEPARAM_QUERY_RESET_ENUM.name = "ASTROLABEPARAM_QUERY_RESET"
ASTROLABEPARAM_ASTROLABEPARAM_QUERY_RESET_ENUM.index = 2
ASTROLABEPARAM_ASTROLABEPARAM_QUERY_RESET_ENUM.number = 3
ASTROLABEPARAM_ASTROLABEPARAM_RESET_ENUM.name = "ASTROLABEPARAM_RESET"
ASTROLABEPARAM_ASTROLABEPARAM_RESET_ENUM.index = 3
ASTROLABEPARAM_ASTROLABEPARAM_RESET_ENUM.number = 4
ASTROLABEPARAM_ASTROLABEPARAM_PLAN_SAVE_ENUM.name = "ASTROLABEPARAM_PLAN_SAVE"
ASTROLABEPARAM_ASTROLABEPARAM_PLAN_SAVE_ENUM.index = 4
ASTROLABEPARAM_ASTROLABEPARAM_PLAN_SAVE_ENUM.number = 5
ASTROLABEPARAM.name = "AstrolabeParam"
ASTROLABEPARAM.full_name = ".Cmd.AstrolabeParam"
ASTROLABEPARAM.values = {
  ASTROLABEPARAM_ASTROLABEPARAM_QUERY_ENUM,
  ASTROLABEPARAM_ASTROLABEPARAM_ACTIVATE_STAR_ENUM,
  ASTROLABEPARAM_ASTROLABEPARAM_QUERY_RESET_ENUM,
  ASTROLABEPARAM_ASTROLABEPARAM_RESET_ENUM,
  ASTROLABEPARAM_ASTROLABEPARAM_PLAN_SAVE_ENUM
}
EASTROLABETYPE_EASTROLABETYPE_MIN_ENUM.name = "EASTROLABETYPE_MIN"
EASTROLABETYPE_EASTROLABETYPE_MIN_ENUM.index = 0
EASTROLABETYPE_EASTROLABETYPE_MIN_ENUM.number = 0
EASTROLABETYPE_EASTROLABETYPE_PROFESSION_ENUM.name = "EASTROLABETYPE_PROFESSION"
EASTROLABETYPE_EASTROLABETYPE_PROFESSION_ENUM.index = 1
EASTROLABETYPE_EASTROLABETYPE_PROFESSION_ENUM.number = 1
EASTROLABETYPE_EASTROLABETYPE_PLAN_ENUM.name = "EASTROLABETYPE_PLAN"
EASTROLABETYPE_EASTROLABETYPE_PLAN_ENUM.index = 2
EASTROLABETYPE_EASTROLABETYPE_PLAN_ENUM.number = 100
EASTROLABETYPE_EASTROLABETYPE_MAX_ENUM.name = "EASTROLABETYPE_MAX"
EASTROLABETYPE_EASTROLABETYPE_MAX_ENUM.index = 3
EASTROLABETYPE_EASTROLABETYPE_MAX_ENUM.number = 101
EASTROLABETYPE.name = "EAstrolabeType"
EASTROLABETYPE.full_name = ".Cmd.EAstrolabeType"
EASTROLABETYPE.values = {
  EASTROLABETYPE_EASTROLABETYPE_MIN_ENUM,
  EASTROLABETYPE_EASTROLABETYPE_PROFESSION_ENUM,
  EASTROLABETYPE_EASTROLABETYPE_PLAN_ENUM,
  EASTROLABETYPE_EASTROLABETYPE_MAX_ENUM
}
ASTROLABECOSTDATA_ID_FIELD.name = "id"
ASTROLABECOSTDATA_ID_FIELD.full_name = ".Cmd.AstrolabeCostData.id"
ASTROLABECOSTDATA_ID_FIELD.number = 1
ASTROLABECOSTDATA_ID_FIELD.index = 0
ASTROLABECOSTDATA_ID_FIELD.label = 1
ASTROLABECOSTDATA_ID_FIELD.has_default_value = true
ASTROLABECOSTDATA_ID_FIELD.default_value = 0
ASTROLABECOSTDATA_ID_FIELD.type = 13
ASTROLABECOSTDATA_ID_FIELD.cpp_type = 3
ASTROLABECOSTDATA_COUNT_FIELD.name = "count"
ASTROLABECOSTDATA_COUNT_FIELD.full_name = ".Cmd.AstrolabeCostData.count"
ASTROLABECOSTDATA_COUNT_FIELD.number = 2
ASTROLABECOSTDATA_COUNT_FIELD.index = 1
ASTROLABECOSTDATA_COUNT_FIELD.label = 1
ASTROLABECOSTDATA_COUNT_FIELD.has_default_value = true
ASTROLABECOSTDATA_COUNT_FIELD.default_value = 0
ASTROLABECOSTDATA_COUNT_FIELD.type = 13
ASTROLABECOSTDATA_COUNT_FIELD.cpp_type = 3
ASTROLABECOSTDATA.name = "AstrolabeCostData"
ASTROLABECOSTDATA.full_name = ".Cmd.AstrolabeCostData"
ASTROLABECOSTDATA.nested_types = {}
ASTROLABECOSTDATA.enum_types = {}
ASTROLABECOSTDATA.fields = {
  ASTROLABECOSTDATA_ID_FIELD,
  ASTROLABECOSTDATA_COUNT_FIELD
}
ASTROLABECOSTDATA.is_extendable = false
ASTROLABECOSTDATA.extensions = {}
ASTROLABEQUERYCMD_CMD_FIELD.name = "cmd"
ASTROLABEQUERYCMD_CMD_FIELD.full_name = ".Cmd.AstrolabeQueryCmd.cmd"
ASTROLABEQUERYCMD_CMD_FIELD.number = 1
ASTROLABEQUERYCMD_CMD_FIELD.index = 0
ASTROLABEQUERYCMD_CMD_FIELD.label = 1
ASTROLABEQUERYCMD_CMD_FIELD.has_default_value = true
ASTROLABEQUERYCMD_CMD_FIELD.default_value = 28
ASTROLABEQUERYCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
ASTROLABEQUERYCMD_CMD_FIELD.type = 14
ASTROLABEQUERYCMD_CMD_FIELD.cpp_type = 8
ASTROLABEQUERYCMD_PARAM_FIELD.name = "param"
ASTROLABEQUERYCMD_PARAM_FIELD.full_name = ".Cmd.AstrolabeQueryCmd.param"
ASTROLABEQUERYCMD_PARAM_FIELD.number = 2
ASTROLABEQUERYCMD_PARAM_FIELD.index = 1
ASTROLABEQUERYCMD_PARAM_FIELD.label = 1
ASTROLABEQUERYCMD_PARAM_FIELD.has_default_value = true
ASTROLABEQUERYCMD_PARAM_FIELD.default_value = 1
ASTROLABEQUERYCMD_PARAM_FIELD.enum_type = ASTROLABEPARAM
ASTROLABEQUERYCMD_PARAM_FIELD.type = 14
ASTROLABEQUERYCMD_PARAM_FIELD.cpp_type = 8
ASTROLABEQUERYCMD_STARS_FIELD.name = "stars"
ASTROLABEQUERYCMD_STARS_FIELD.full_name = ".Cmd.AstrolabeQueryCmd.stars"
ASTROLABEQUERYCMD_STARS_FIELD.number = 3
ASTROLABEQUERYCMD_STARS_FIELD.index = 2
ASTROLABEQUERYCMD_STARS_FIELD.label = 3
ASTROLABEQUERYCMD_STARS_FIELD.has_default_value = false
ASTROLABEQUERYCMD_STARS_FIELD.default_value = {}
ASTROLABEQUERYCMD_STARS_FIELD.type = 13
ASTROLABEQUERYCMD_STARS_FIELD.cpp_type = 3
ASTROLABEQUERYCMD_ASTROLABETYPE_FIELD.name = "astrolabetype"
ASTROLABEQUERYCMD_ASTROLABETYPE_FIELD.full_name = ".Cmd.AstrolabeQueryCmd.astrolabetype"
ASTROLABEQUERYCMD_ASTROLABETYPE_FIELD.number = 4
ASTROLABEQUERYCMD_ASTROLABETYPE_FIELD.index = 3
ASTROLABEQUERYCMD_ASTROLABETYPE_FIELD.label = 1
ASTROLABEQUERYCMD_ASTROLABETYPE_FIELD.has_default_value = true
ASTROLABEQUERYCMD_ASTROLABETYPE_FIELD.default_value = 0
ASTROLABEQUERYCMD_ASTROLABETYPE_FIELD.enum_type = EASTROLABETYPE
ASTROLABEQUERYCMD_ASTROLABETYPE_FIELD.type = 14
ASTROLABEQUERYCMD_ASTROLABETYPE_FIELD.cpp_type = 8
ASTROLABEQUERYCMD.name = "AstrolabeQueryCmd"
ASTROLABEQUERYCMD.full_name = ".Cmd.AstrolabeQueryCmd"
ASTROLABEQUERYCMD.nested_types = {}
ASTROLABEQUERYCMD.enum_types = {}
ASTROLABEQUERYCMD.fields = {
  ASTROLABEQUERYCMD_CMD_FIELD,
  ASTROLABEQUERYCMD_PARAM_FIELD,
  ASTROLABEQUERYCMD_STARS_FIELD,
  ASTROLABEQUERYCMD_ASTROLABETYPE_FIELD
}
ASTROLABEQUERYCMD.is_extendable = false
ASTROLABEQUERYCMD.extensions = {}
ASTROLABEACTIVATESTARCMD_CMD_FIELD.name = "cmd"
ASTROLABEACTIVATESTARCMD_CMD_FIELD.full_name = ".Cmd.AstrolabeActivateStarCmd.cmd"
ASTROLABEACTIVATESTARCMD_CMD_FIELD.number = 1
ASTROLABEACTIVATESTARCMD_CMD_FIELD.index = 0
ASTROLABEACTIVATESTARCMD_CMD_FIELD.label = 1
ASTROLABEACTIVATESTARCMD_CMD_FIELD.has_default_value = true
ASTROLABEACTIVATESTARCMD_CMD_FIELD.default_value = 28
ASTROLABEACTIVATESTARCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
ASTROLABEACTIVATESTARCMD_CMD_FIELD.type = 14
ASTROLABEACTIVATESTARCMD_CMD_FIELD.cpp_type = 8
ASTROLABEACTIVATESTARCMD_PARAM_FIELD.name = "param"
ASTROLABEACTIVATESTARCMD_PARAM_FIELD.full_name = ".Cmd.AstrolabeActivateStarCmd.param"
ASTROLABEACTIVATESTARCMD_PARAM_FIELD.number = 2
ASTROLABEACTIVATESTARCMD_PARAM_FIELD.index = 1
ASTROLABEACTIVATESTARCMD_PARAM_FIELD.label = 1
ASTROLABEACTIVATESTARCMD_PARAM_FIELD.has_default_value = true
ASTROLABEACTIVATESTARCMD_PARAM_FIELD.default_value = 2
ASTROLABEACTIVATESTARCMD_PARAM_FIELD.enum_type = ASTROLABEPARAM
ASTROLABEACTIVATESTARCMD_PARAM_FIELD.type = 14
ASTROLABEACTIVATESTARCMD_PARAM_FIELD.cpp_type = 8
ASTROLABEACTIVATESTARCMD_STARS_FIELD.name = "stars"
ASTROLABEACTIVATESTARCMD_STARS_FIELD.full_name = ".Cmd.AstrolabeActivateStarCmd.stars"
ASTROLABEACTIVATESTARCMD_STARS_FIELD.number = 3
ASTROLABEACTIVATESTARCMD_STARS_FIELD.index = 2
ASTROLABEACTIVATESTARCMD_STARS_FIELD.label = 3
ASTROLABEACTIVATESTARCMD_STARS_FIELD.has_default_value = false
ASTROLABEACTIVATESTARCMD_STARS_FIELD.default_value = {}
ASTROLABEACTIVATESTARCMD_STARS_FIELD.type = 13
ASTROLABEACTIVATESTARCMD_STARS_FIELD.cpp_type = 3
ASTROLABEACTIVATESTARCMD_SUCCESS_FIELD.name = "success"
ASTROLABEACTIVATESTARCMD_SUCCESS_FIELD.full_name = ".Cmd.AstrolabeActivateStarCmd.success"
ASTROLABEACTIVATESTARCMD_SUCCESS_FIELD.number = 5
ASTROLABEACTIVATESTARCMD_SUCCESS_FIELD.index = 3
ASTROLABEACTIVATESTARCMD_SUCCESS_FIELD.label = 1
ASTROLABEACTIVATESTARCMD_SUCCESS_FIELD.has_default_value = false
ASTROLABEACTIVATESTARCMD_SUCCESS_FIELD.default_value = false
ASTROLABEACTIVATESTARCMD_SUCCESS_FIELD.type = 8
ASTROLABEACTIVATESTARCMD_SUCCESS_FIELD.cpp_type = 7
ASTROLABEACTIVATESTARCMD.name = "AstrolabeActivateStarCmd"
ASTROLABEACTIVATESTARCMD.full_name = ".Cmd.AstrolabeActivateStarCmd"
ASTROLABEACTIVATESTARCMD.nested_types = {}
ASTROLABEACTIVATESTARCMD.enum_types = {}
ASTROLABEACTIVATESTARCMD.fields = {
  ASTROLABEACTIVATESTARCMD_CMD_FIELD,
  ASTROLABEACTIVATESTARCMD_PARAM_FIELD,
  ASTROLABEACTIVATESTARCMD_STARS_FIELD,
  ASTROLABEACTIVATESTARCMD_SUCCESS_FIELD
}
ASTROLABEACTIVATESTARCMD.is_extendable = false
ASTROLABEACTIVATESTARCMD.extensions = {}
ASTROLABEQUERYRESETCMD_CMD_FIELD.name = "cmd"
ASTROLABEQUERYRESETCMD_CMD_FIELD.full_name = ".Cmd.AstrolabeQueryResetCmd.cmd"
ASTROLABEQUERYRESETCMD_CMD_FIELD.number = 1
ASTROLABEQUERYRESETCMD_CMD_FIELD.index = 0
ASTROLABEQUERYRESETCMD_CMD_FIELD.label = 1
ASTROLABEQUERYRESETCMD_CMD_FIELD.has_default_value = true
ASTROLABEQUERYRESETCMD_CMD_FIELD.default_value = 28
ASTROLABEQUERYRESETCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
ASTROLABEQUERYRESETCMD_CMD_FIELD.type = 14
ASTROLABEQUERYRESETCMD_CMD_FIELD.cpp_type = 8
ASTROLABEQUERYRESETCMD_PARAM_FIELD.name = "param"
ASTROLABEQUERYRESETCMD_PARAM_FIELD.full_name = ".Cmd.AstrolabeQueryResetCmd.param"
ASTROLABEQUERYRESETCMD_PARAM_FIELD.number = 2
ASTROLABEQUERYRESETCMD_PARAM_FIELD.index = 1
ASTROLABEQUERYRESETCMD_PARAM_FIELD.label = 1
ASTROLABEQUERYRESETCMD_PARAM_FIELD.has_default_value = true
ASTROLABEQUERYRESETCMD_PARAM_FIELD.default_value = 3
ASTROLABEQUERYRESETCMD_PARAM_FIELD.enum_type = ASTROLABEPARAM
ASTROLABEQUERYRESETCMD_PARAM_FIELD.type = 14
ASTROLABEQUERYRESETCMD_PARAM_FIELD.cpp_type = 8
ASTROLABEQUERYRESETCMD_TYPE_FIELD.name = "type"
ASTROLABEQUERYRESETCMD_TYPE_FIELD.full_name = ".Cmd.AstrolabeQueryResetCmd.type"
ASTROLABEQUERYRESETCMD_TYPE_FIELD.number = 3
ASTROLABEQUERYRESETCMD_TYPE_FIELD.index = 2
ASTROLABEQUERYRESETCMD_TYPE_FIELD.label = 1
ASTROLABEQUERYRESETCMD_TYPE_FIELD.has_default_value = false
ASTROLABEQUERYRESETCMD_TYPE_FIELD.default_value = nil
ASTROLABEQUERYRESETCMD_TYPE_FIELD.enum_type = EASTROLABETYPE
ASTROLABEQUERYRESETCMD_TYPE_FIELD.type = 14
ASTROLABEQUERYRESETCMD_TYPE_FIELD.cpp_type = 8
ASTROLABEQUERYRESETCMD_ITEMS_FIELD.name = "items"
ASTROLABEQUERYRESETCMD_ITEMS_FIELD.full_name = ".Cmd.AstrolabeQueryResetCmd.items"
ASTROLABEQUERYRESETCMD_ITEMS_FIELD.number = 4
ASTROLABEQUERYRESETCMD_ITEMS_FIELD.index = 3
ASTROLABEQUERYRESETCMD_ITEMS_FIELD.label = 3
ASTROLABEQUERYRESETCMD_ITEMS_FIELD.has_default_value = false
ASTROLABEQUERYRESETCMD_ITEMS_FIELD.default_value = {}
ASTROLABEQUERYRESETCMD_ITEMS_FIELD.message_type = ASTROLABECOSTDATA
ASTROLABEQUERYRESETCMD_ITEMS_FIELD.type = 11
ASTROLABEQUERYRESETCMD_ITEMS_FIELD.cpp_type = 10
ASTROLABEQUERYRESETCMD.name = "AstrolabeQueryResetCmd"
ASTROLABEQUERYRESETCMD.full_name = ".Cmd.AstrolabeQueryResetCmd"
ASTROLABEQUERYRESETCMD.nested_types = {}
ASTROLABEQUERYRESETCMD.enum_types = {}
ASTROLABEQUERYRESETCMD.fields = {
  ASTROLABEQUERYRESETCMD_CMD_FIELD,
  ASTROLABEQUERYRESETCMD_PARAM_FIELD,
  ASTROLABEQUERYRESETCMD_TYPE_FIELD,
  ASTROLABEQUERYRESETCMD_ITEMS_FIELD
}
ASTROLABEQUERYRESETCMD.is_extendable = false
ASTROLABEQUERYRESETCMD.extensions = {}
ASTROLABERESETCMD_CMD_FIELD.name = "cmd"
ASTROLABERESETCMD_CMD_FIELD.full_name = ".Cmd.AstrolabeResetCmd.cmd"
ASTROLABERESETCMD_CMD_FIELD.number = 1
ASTROLABERESETCMD_CMD_FIELD.index = 0
ASTROLABERESETCMD_CMD_FIELD.label = 1
ASTROLABERESETCMD_CMD_FIELD.has_default_value = true
ASTROLABERESETCMD_CMD_FIELD.default_value = 28
ASTROLABERESETCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
ASTROLABERESETCMD_CMD_FIELD.type = 14
ASTROLABERESETCMD_CMD_FIELD.cpp_type = 8
ASTROLABERESETCMD_PARAM_FIELD.name = "param"
ASTROLABERESETCMD_PARAM_FIELD.full_name = ".Cmd.AstrolabeResetCmd.param"
ASTROLABERESETCMD_PARAM_FIELD.number = 2
ASTROLABERESETCMD_PARAM_FIELD.index = 1
ASTROLABERESETCMD_PARAM_FIELD.label = 1
ASTROLABERESETCMD_PARAM_FIELD.has_default_value = true
ASTROLABERESETCMD_PARAM_FIELD.default_value = 4
ASTROLABERESETCMD_PARAM_FIELD.enum_type = ASTROLABEPARAM
ASTROLABERESETCMD_PARAM_FIELD.type = 14
ASTROLABERESETCMD_PARAM_FIELD.cpp_type = 8
ASTROLABERESETCMD_STARS_FIELD.name = "stars"
ASTROLABERESETCMD_STARS_FIELD.full_name = ".Cmd.AstrolabeResetCmd.stars"
ASTROLABERESETCMD_STARS_FIELD.number = 3
ASTROLABERESETCMD_STARS_FIELD.index = 2
ASTROLABERESETCMD_STARS_FIELD.label = 3
ASTROLABERESETCMD_STARS_FIELD.has_default_value = false
ASTROLABERESETCMD_STARS_FIELD.default_value = {}
ASTROLABERESETCMD_STARS_FIELD.type = 13
ASTROLABERESETCMD_STARS_FIELD.cpp_type = 3
ASTROLABERESETCMD_SUCCESS_FIELD.name = "success"
ASTROLABERESETCMD_SUCCESS_FIELD.full_name = ".Cmd.AstrolabeResetCmd.success"
ASTROLABERESETCMD_SUCCESS_FIELD.number = 4
ASTROLABERESETCMD_SUCCESS_FIELD.index = 3
ASTROLABERESETCMD_SUCCESS_FIELD.label = 1
ASTROLABERESETCMD_SUCCESS_FIELD.has_default_value = false
ASTROLABERESETCMD_SUCCESS_FIELD.default_value = false
ASTROLABERESETCMD_SUCCESS_FIELD.type = 8
ASTROLABERESETCMD_SUCCESS_FIELD.cpp_type = 7
ASTROLABERESETCMD.name = "AstrolabeResetCmd"
ASTROLABERESETCMD.full_name = ".Cmd.AstrolabeResetCmd"
ASTROLABERESETCMD.nested_types = {}
ASTROLABERESETCMD.enum_types = {}
ASTROLABERESETCMD.fields = {
  ASTROLABERESETCMD_CMD_FIELD,
  ASTROLABERESETCMD_PARAM_FIELD,
  ASTROLABERESETCMD_STARS_FIELD,
  ASTROLABERESETCMD_SUCCESS_FIELD
}
ASTROLABERESETCMD.is_extendable = false
ASTROLABERESETCMD.extensions = {}
ASTROLABEPLANSAVECMD_CMD_FIELD.name = "cmd"
ASTROLABEPLANSAVECMD_CMD_FIELD.full_name = ".Cmd.AstrolabePlanSaveCmd.cmd"
ASTROLABEPLANSAVECMD_CMD_FIELD.number = 1
ASTROLABEPLANSAVECMD_CMD_FIELD.index = 0
ASTROLABEPLANSAVECMD_CMD_FIELD.label = 1
ASTROLABEPLANSAVECMD_CMD_FIELD.has_default_value = true
ASTROLABEPLANSAVECMD_CMD_FIELD.default_value = 28
ASTROLABEPLANSAVECMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
ASTROLABEPLANSAVECMD_CMD_FIELD.type = 14
ASTROLABEPLANSAVECMD_CMD_FIELD.cpp_type = 8
ASTROLABEPLANSAVECMD_PARAM_FIELD.name = "param"
ASTROLABEPLANSAVECMD_PARAM_FIELD.full_name = ".Cmd.AstrolabePlanSaveCmd.param"
ASTROLABEPLANSAVECMD_PARAM_FIELD.number = 2
ASTROLABEPLANSAVECMD_PARAM_FIELD.index = 1
ASTROLABEPLANSAVECMD_PARAM_FIELD.label = 1
ASTROLABEPLANSAVECMD_PARAM_FIELD.has_default_value = true
ASTROLABEPLANSAVECMD_PARAM_FIELD.default_value = 5
ASTROLABEPLANSAVECMD_PARAM_FIELD.enum_type = ASTROLABEPARAM
ASTROLABEPLANSAVECMD_PARAM_FIELD.type = 14
ASTROLABEPLANSAVECMD_PARAM_FIELD.cpp_type = 8
ASTROLABEPLANSAVECMD_STARS_FIELD.name = "stars"
ASTROLABEPLANSAVECMD_STARS_FIELD.full_name = ".Cmd.AstrolabePlanSaveCmd.stars"
ASTROLABEPLANSAVECMD_STARS_FIELD.number = 3
ASTROLABEPLANSAVECMD_STARS_FIELD.index = 2
ASTROLABEPLANSAVECMD_STARS_FIELD.label = 3
ASTROLABEPLANSAVECMD_STARS_FIELD.has_default_value = false
ASTROLABEPLANSAVECMD_STARS_FIELD.default_value = {}
ASTROLABEPLANSAVECMD_STARS_FIELD.type = 13
ASTROLABEPLANSAVECMD_STARS_FIELD.cpp_type = 3
ASTROLABEPLANSAVECMD.name = "AstrolabePlanSaveCmd"
ASTROLABEPLANSAVECMD.full_name = ".Cmd.AstrolabePlanSaveCmd"
ASTROLABEPLANSAVECMD.nested_types = {}
ASTROLABEPLANSAVECMD.enum_types = {}
ASTROLABEPLANSAVECMD.fields = {
  ASTROLABEPLANSAVECMD_CMD_FIELD,
  ASTROLABEPLANSAVECMD_PARAM_FIELD,
  ASTROLABEPLANSAVECMD_STARS_FIELD
}
ASTROLABEPLANSAVECMD.is_extendable = false
ASTROLABEPLANSAVECMD.extensions = {}
ASTROLABEPARAM_ACTIVATE_STAR = 2
ASTROLABEPARAM_PLAN_SAVE = 5
ASTROLABEPARAM_QUERY = 1
ASTROLABEPARAM_QUERY_RESET = 3
ASTROLABEPARAM_RESET = 4
AstrolabeActivateStarCmd = protobuf.Message(ASTROLABEACTIVATESTARCMD)
AstrolabeCostData = protobuf.Message(ASTROLABECOSTDATA)
AstrolabePlanSaveCmd = protobuf.Message(ASTROLABEPLANSAVECMD)
AstrolabeQueryCmd = protobuf.Message(ASTROLABEQUERYCMD)
AstrolabeQueryResetCmd = protobuf.Message(ASTROLABEQUERYRESETCMD)
AstrolabeResetCmd = protobuf.Message(ASTROLABERESETCMD)
EASTROLABETYPE_MAX = 101
EASTROLABETYPE_MIN = 0
EASTROLABETYPE_PLAN = 100
EASTROLABETYPE_PROFESSION = 1
