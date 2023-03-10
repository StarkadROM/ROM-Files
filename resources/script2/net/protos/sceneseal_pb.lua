local protobuf = protobuf
autoImport("xCmd_pb")
local xCmd_pb = xCmd_pb
autoImport("ProtoCommon_pb")
local ProtoCommon_pb = ProtoCommon_pb
module("SceneSeal_pb")
SEALPARAM = protobuf.EnumDescriptor()
SEALPARAM_SEALPARAM_QUERYSEAL_ENUM = protobuf.EnumValueDescriptor()
SEALPARAM_SEALPARAM_UPDATESEAL_ENUM = protobuf.EnumValueDescriptor()
SEALPARAM_SEALPARAM_SEALTIMER_ENUM = protobuf.EnumValueDescriptor()
SEALPARAM_SEALPARAM_BEGINSEAL_ENUM = protobuf.EnumValueDescriptor()
SEALPARAM_SEALPARAM_ENDSEAL_ENUM = protobuf.EnumValueDescriptor()
SEALPARAM_SEALPARAM_USERLEAVE_ENUM = protobuf.EnumValueDescriptor()
SEALPARAM_SEALPARAM_QUERYLIST_ENUM = protobuf.EnumValueDescriptor()
SEALPARAM_SEALPARAM_ACCEPTSEAL_ENUM = protobuf.EnumValueDescriptor()
ESEALTYPE = protobuf.EnumDescriptor()
ESEALTYPE_ESEALTYPE_MIN_ENUM = protobuf.EnumValueDescriptor()
ESEALTYPE_ESEALTYPE_NORMAL_ENUM = protobuf.EnumValueDescriptor()
ESEALTYPE_ESEALTYPE_PERSONAL_ENUM = protobuf.EnumValueDescriptor()
ESEALTYPE_ESEALTYPE_ACTIVITY_ENUM = protobuf.EnumValueDescriptor()
ESEALTYPE_ESEALTYPE_FADEJOB_ENUM = protobuf.EnumValueDescriptor()
ESEALTYPE_ESEALTYPE_MAX_ENUM = protobuf.EnumValueDescriptor()
EFINISHTYPE = protobuf.EnumDescriptor()
EFINISHTYPE_EFINISHTYPE_MIN_ENUM = protobuf.EnumValueDescriptor()
EFINISHTYPE_EFINISHTYPE_NORMAL_ENUM = protobuf.EnumValueDescriptor()
EFINISHTYPE_EFINISHTYPE_QUICK_ENUM = protobuf.EnumValueDescriptor()
EFINISHTYPE_EFINISHTYPE_QUICK_NOPROCESS_ENUM = protobuf.EnumValueDescriptor()
EFINISHTYPE_EFINISHTYPE_MAX_ENUM = protobuf.EnumValueDescriptor()
SEALITEM = protobuf.Descriptor()
SEALITEM_CONFIG_FIELD = protobuf.FieldDescriptor()
SEALITEM_REFRESHTIME_FIELD = protobuf.FieldDescriptor()
SEALITEM_OWNSEAL_FIELD = protobuf.FieldDescriptor()
SEALITEM_POS_FIELD = protobuf.FieldDescriptor()
SEALITEM_SEALID_FIELD = protobuf.FieldDescriptor()
SEALITEM_ISSEALING_FIELD = protobuf.FieldDescriptor()
SEALITEM_ETYPE_FIELD = protobuf.FieldDescriptor()
SEALITEM_QUESTID_FIELD = protobuf.FieldDescriptor()
SEALDATA = protobuf.Descriptor()
SEALDATA_MAPID_FIELD = protobuf.FieldDescriptor()
SEALDATA_ITEMS_FIELD = protobuf.FieldDescriptor()
QUERYSEAL = protobuf.Descriptor()
QUERYSEAL_CMD_FIELD = protobuf.FieldDescriptor()
QUERYSEAL_PARAM_FIELD = protobuf.FieldDescriptor()
QUERYSEAL_DATAS_FIELD = protobuf.FieldDescriptor()
UPDATESEAL = protobuf.Descriptor()
UPDATESEAL_CMD_FIELD = protobuf.FieldDescriptor()
UPDATESEAL_PARAM_FIELD = protobuf.FieldDescriptor()
UPDATESEAL_NEWDATA_FIELD = protobuf.FieldDescriptor()
UPDATESEAL_DELDATA_FIELD = protobuf.FieldDescriptor()
SEALTIMER = protobuf.Descriptor()
SEALTIMER_CMD_FIELD = protobuf.FieldDescriptor()
SEALTIMER_PARAM_FIELD = protobuf.FieldDescriptor()
SEALTIMER_SPEED_FIELD = protobuf.FieldDescriptor()
SEALTIMER_CURVALUE_FIELD = protobuf.FieldDescriptor()
SEALTIMER_MAXVALUE_FIELD = protobuf.FieldDescriptor()
SEALTIMER_STOPTIME_FIELD = protobuf.FieldDescriptor()
SEALTIMER_MAXTIME_FIELD = protobuf.FieldDescriptor()
BEGINSEAL = protobuf.Descriptor()
BEGINSEAL_CMD_FIELD = protobuf.FieldDescriptor()
BEGINSEAL_PARAM_FIELD = protobuf.FieldDescriptor()
BEGINSEAL_SEALID_FIELD = protobuf.FieldDescriptor()
BEGINSEAL_ETYPE_FIELD = protobuf.FieldDescriptor()
BEGINSEAL_FINISHALL_FIELD = protobuf.FieldDescriptor()
ENDSEAL = protobuf.Descriptor()
ENDSEAL_CMD_FIELD = protobuf.FieldDescriptor()
ENDSEAL_PARAM_FIELD = protobuf.FieldDescriptor()
ENDSEAL_SUCCESS_FIELD = protobuf.FieldDescriptor()
ENDSEAL_SEALID_FIELD = protobuf.FieldDescriptor()
SEALUSERLEAVE = protobuf.Descriptor()
SEALUSERLEAVE_CMD_FIELD = protobuf.FieldDescriptor()
SEALUSERLEAVE_PARAM_FIELD = protobuf.FieldDescriptor()
SEALCONFIGPART = protobuf.Descriptor()
SEALCONFIGPART_CONFIGID_FIELD = protobuf.FieldDescriptor()
SEALCONFIGPART_PASSFLAG_FIELD = protobuf.FieldDescriptor()
SEALQUERYLIST = protobuf.Descriptor()
SEALQUERYLIST_CMD_FIELD = protobuf.FieldDescriptor()
SEALQUERYLIST_PARAM_FIELD = protobuf.FieldDescriptor()
SEALQUERYLIST_CONFIGID_FIELD = protobuf.FieldDescriptor()
SEALQUERYLIST_DONETIMES_FIELD = protobuf.FieldDescriptor()
SEALQUERYLIST_MAXTIMES_FIELD = protobuf.FieldDescriptor()
SEALQUERYLIST_CONFIGPARTS_FIELD = protobuf.FieldDescriptor()
SEALACCEPTCMD = protobuf.Descriptor()
SEALACCEPTCMD_CMD_FIELD = protobuf.FieldDescriptor()
SEALACCEPTCMD_PARAM_FIELD = protobuf.FieldDescriptor()
SEALACCEPTCMD_SEAL_FIELD = protobuf.FieldDescriptor()
SEALACCEPTCMD_POS_FIELD = protobuf.FieldDescriptor()
SEALACCEPTCMD_ABANDON_FIELD = protobuf.FieldDescriptor()
SEALPARAM_SEALPARAM_QUERYSEAL_ENUM.name = "SEALPARAM_QUERYSEAL"
SEALPARAM_SEALPARAM_QUERYSEAL_ENUM.index = 0
SEALPARAM_SEALPARAM_QUERYSEAL_ENUM.number = 1
SEALPARAM_SEALPARAM_UPDATESEAL_ENUM.name = "SEALPARAM_UPDATESEAL"
SEALPARAM_SEALPARAM_UPDATESEAL_ENUM.index = 1
SEALPARAM_SEALPARAM_UPDATESEAL_ENUM.number = 2
SEALPARAM_SEALPARAM_SEALTIMER_ENUM.name = "SEALPARAM_SEALTIMER"
SEALPARAM_SEALPARAM_SEALTIMER_ENUM.index = 2
SEALPARAM_SEALPARAM_SEALTIMER_ENUM.number = 3
SEALPARAM_SEALPARAM_BEGINSEAL_ENUM.name = "SEALPARAM_BEGINSEAL"
SEALPARAM_SEALPARAM_BEGINSEAL_ENUM.index = 3
SEALPARAM_SEALPARAM_BEGINSEAL_ENUM.number = 4
SEALPARAM_SEALPARAM_ENDSEAL_ENUM.name = "SEALPARAM_ENDSEAL"
SEALPARAM_SEALPARAM_ENDSEAL_ENUM.index = 4
SEALPARAM_SEALPARAM_ENDSEAL_ENUM.number = 5
SEALPARAM_SEALPARAM_USERLEAVE_ENUM.name = "SEALPARAM_USERLEAVE"
SEALPARAM_SEALPARAM_USERLEAVE_ENUM.index = 5
SEALPARAM_SEALPARAM_USERLEAVE_ENUM.number = 6
SEALPARAM_SEALPARAM_QUERYLIST_ENUM.name = "SEALPARAM_QUERYLIST"
SEALPARAM_SEALPARAM_QUERYLIST_ENUM.index = 6
SEALPARAM_SEALPARAM_QUERYLIST_ENUM.number = 7
SEALPARAM_SEALPARAM_ACCEPTSEAL_ENUM.name = "SEALPARAM_ACCEPTSEAL"
SEALPARAM_SEALPARAM_ACCEPTSEAL_ENUM.index = 7
SEALPARAM_SEALPARAM_ACCEPTSEAL_ENUM.number = 8
SEALPARAM.name = "SealParam"
SEALPARAM.full_name = ".Cmd.SealParam"
SEALPARAM.values = {
  SEALPARAM_SEALPARAM_QUERYSEAL_ENUM,
  SEALPARAM_SEALPARAM_UPDATESEAL_ENUM,
  SEALPARAM_SEALPARAM_SEALTIMER_ENUM,
  SEALPARAM_SEALPARAM_BEGINSEAL_ENUM,
  SEALPARAM_SEALPARAM_ENDSEAL_ENUM,
  SEALPARAM_SEALPARAM_USERLEAVE_ENUM,
  SEALPARAM_SEALPARAM_QUERYLIST_ENUM,
  SEALPARAM_SEALPARAM_ACCEPTSEAL_ENUM
}
ESEALTYPE_ESEALTYPE_MIN_ENUM.name = "ESEALTYPE_MIN"
ESEALTYPE_ESEALTYPE_MIN_ENUM.index = 0
ESEALTYPE_ESEALTYPE_MIN_ENUM.number = 0
ESEALTYPE_ESEALTYPE_NORMAL_ENUM.name = "ESEALTYPE_NORMAL"
ESEALTYPE_ESEALTYPE_NORMAL_ENUM.index = 1
ESEALTYPE_ESEALTYPE_NORMAL_ENUM.number = 1
ESEALTYPE_ESEALTYPE_PERSONAL_ENUM.name = "ESEALTYPE_PERSONAL"
ESEALTYPE_ESEALTYPE_PERSONAL_ENUM.index = 2
ESEALTYPE_ESEALTYPE_PERSONAL_ENUM.number = 2
ESEALTYPE_ESEALTYPE_ACTIVITY_ENUM.name = "ESEALTYPE_ACTIVITY"
ESEALTYPE_ESEALTYPE_ACTIVITY_ENUM.index = 3
ESEALTYPE_ESEALTYPE_ACTIVITY_ENUM.number = 3
ESEALTYPE_ESEALTYPE_FADEJOB_ENUM.name = "ESEALTYPE_FADEJOB"
ESEALTYPE_ESEALTYPE_FADEJOB_ENUM.index = 4
ESEALTYPE_ESEALTYPE_FADEJOB_ENUM.number = 4
ESEALTYPE_ESEALTYPE_MAX_ENUM.name = "ESEALTYPE_MAX"
ESEALTYPE_ESEALTYPE_MAX_ENUM.index = 5
ESEALTYPE_ESEALTYPE_MAX_ENUM.number = 5
ESEALTYPE.name = "ESealType"
ESEALTYPE.full_name = ".Cmd.ESealType"
ESEALTYPE.values = {
  ESEALTYPE_ESEALTYPE_MIN_ENUM,
  ESEALTYPE_ESEALTYPE_NORMAL_ENUM,
  ESEALTYPE_ESEALTYPE_PERSONAL_ENUM,
  ESEALTYPE_ESEALTYPE_ACTIVITY_ENUM,
  ESEALTYPE_ESEALTYPE_FADEJOB_ENUM,
  ESEALTYPE_ESEALTYPE_MAX_ENUM
}
EFINISHTYPE_EFINISHTYPE_MIN_ENUM.name = "EFINISHTYPE_MIN"
EFINISHTYPE_EFINISHTYPE_MIN_ENUM.index = 0
EFINISHTYPE_EFINISHTYPE_MIN_ENUM.number = 0
EFINISHTYPE_EFINISHTYPE_NORMAL_ENUM.name = "EFINISHTYPE_NORMAL"
EFINISHTYPE_EFINISHTYPE_NORMAL_ENUM.index = 1
EFINISHTYPE_EFINISHTYPE_NORMAL_ENUM.number = 1
EFINISHTYPE_EFINISHTYPE_QUICK_ENUM.name = "EFINISHTYPE_QUICK"
EFINISHTYPE_EFINISHTYPE_QUICK_ENUM.index = 2
EFINISHTYPE_EFINISHTYPE_QUICK_ENUM.number = 2
EFINISHTYPE_EFINISHTYPE_QUICK_NOPROCESS_ENUM.name = "EFINISHTYPE_QUICK_NOPROCESS"
EFINISHTYPE_EFINISHTYPE_QUICK_NOPROCESS_ENUM.index = 3
EFINISHTYPE_EFINISHTYPE_QUICK_NOPROCESS_ENUM.number = 3
EFINISHTYPE_EFINISHTYPE_MAX_ENUM.name = "EFINISHTYPE_MAX"
EFINISHTYPE_EFINISHTYPE_MAX_ENUM.index = 4
EFINISHTYPE_EFINISHTYPE_MAX_ENUM.number = 4
EFINISHTYPE.name = "EFinishType"
EFINISHTYPE.full_name = ".Cmd.EFinishType"
EFINISHTYPE.values = {
  EFINISHTYPE_EFINISHTYPE_MIN_ENUM,
  EFINISHTYPE_EFINISHTYPE_NORMAL_ENUM,
  EFINISHTYPE_EFINISHTYPE_QUICK_ENUM,
  EFINISHTYPE_EFINISHTYPE_QUICK_NOPROCESS_ENUM,
  EFINISHTYPE_EFINISHTYPE_MAX_ENUM
}
SEALITEM_CONFIG_FIELD.name = "config"
SEALITEM_CONFIG_FIELD.full_name = ".Cmd.SealItem.config"
SEALITEM_CONFIG_FIELD.number = 1
SEALITEM_CONFIG_FIELD.index = 0
SEALITEM_CONFIG_FIELD.label = 1
SEALITEM_CONFIG_FIELD.has_default_value = true
SEALITEM_CONFIG_FIELD.default_value = 0
SEALITEM_CONFIG_FIELD.type = 13
SEALITEM_CONFIG_FIELD.cpp_type = 3
SEALITEM_REFRESHTIME_FIELD.name = "refreshtime"
SEALITEM_REFRESHTIME_FIELD.full_name = ".Cmd.SealItem.refreshtime"
SEALITEM_REFRESHTIME_FIELD.number = 2
SEALITEM_REFRESHTIME_FIELD.index = 1
SEALITEM_REFRESHTIME_FIELD.label = 1
SEALITEM_REFRESHTIME_FIELD.has_default_value = true
SEALITEM_REFRESHTIME_FIELD.default_value = 0
SEALITEM_REFRESHTIME_FIELD.type = 13
SEALITEM_REFRESHTIME_FIELD.cpp_type = 3
SEALITEM_OWNSEAL_FIELD.name = "ownseal"
SEALITEM_OWNSEAL_FIELD.full_name = ".Cmd.SealItem.ownseal"
SEALITEM_OWNSEAL_FIELD.number = 3
SEALITEM_OWNSEAL_FIELD.index = 2
SEALITEM_OWNSEAL_FIELD.label = 1
SEALITEM_OWNSEAL_FIELD.has_default_value = true
SEALITEM_OWNSEAL_FIELD.default_value = false
SEALITEM_OWNSEAL_FIELD.type = 8
SEALITEM_OWNSEAL_FIELD.cpp_type = 7
SEALITEM_POS_FIELD.name = "pos"
SEALITEM_POS_FIELD.full_name = ".Cmd.SealItem.pos"
SEALITEM_POS_FIELD.number = 4
SEALITEM_POS_FIELD.index = 3
SEALITEM_POS_FIELD.label = 1
SEALITEM_POS_FIELD.has_default_value = false
SEALITEM_POS_FIELD.default_value = nil
SEALITEM_POS_FIELD.message_type = ProtoCommon_pb.SCENEPOS
SEALITEM_POS_FIELD.type = 11
SEALITEM_POS_FIELD.cpp_type = 10
SEALITEM_SEALID_FIELD.name = "sealid"
SEALITEM_SEALID_FIELD.full_name = ".Cmd.SealItem.sealid"
SEALITEM_SEALID_FIELD.number = 5
SEALITEM_SEALID_FIELD.index = 4
SEALITEM_SEALID_FIELD.label = 1
SEALITEM_SEALID_FIELD.has_default_value = true
SEALITEM_SEALID_FIELD.default_value = 0
SEALITEM_SEALID_FIELD.type = 4
SEALITEM_SEALID_FIELD.cpp_type = 4
SEALITEM_ISSEALING_FIELD.name = "issealing"
SEALITEM_ISSEALING_FIELD.full_name = ".Cmd.SealItem.issealing"
SEALITEM_ISSEALING_FIELD.number = 6
SEALITEM_ISSEALING_FIELD.index = 5
SEALITEM_ISSEALING_FIELD.label = 1
SEALITEM_ISSEALING_FIELD.has_default_value = true
SEALITEM_ISSEALING_FIELD.default_value = false
SEALITEM_ISSEALING_FIELD.type = 8
SEALITEM_ISSEALING_FIELD.cpp_type = 7
SEALITEM_ETYPE_FIELD.name = "etype"
SEALITEM_ETYPE_FIELD.full_name = ".Cmd.SealItem.etype"
SEALITEM_ETYPE_FIELD.number = 7
SEALITEM_ETYPE_FIELD.index = 6
SEALITEM_ETYPE_FIELD.label = 1
SEALITEM_ETYPE_FIELD.has_default_value = true
SEALITEM_ETYPE_FIELD.default_value = 1
SEALITEM_ETYPE_FIELD.enum_type = ESEALTYPE
SEALITEM_ETYPE_FIELD.type = 14
SEALITEM_ETYPE_FIELD.cpp_type = 8
SEALITEM_QUESTID_FIELD.name = "questid"
SEALITEM_QUESTID_FIELD.full_name = ".Cmd.SealItem.questid"
SEALITEM_QUESTID_FIELD.number = 8
SEALITEM_QUESTID_FIELD.index = 7
SEALITEM_QUESTID_FIELD.label = 1
SEALITEM_QUESTID_FIELD.has_default_value = true
SEALITEM_QUESTID_FIELD.default_value = 0
SEALITEM_QUESTID_FIELD.type = 13
SEALITEM_QUESTID_FIELD.cpp_type = 3
SEALITEM.name = "SealItem"
SEALITEM.full_name = ".Cmd.SealItem"
SEALITEM.nested_types = {}
SEALITEM.enum_types = {}
SEALITEM.fields = {
  SEALITEM_CONFIG_FIELD,
  SEALITEM_REFRESHTIME_FIELD,
  SEALITEM_OWNSEAL_FIELD,
  SEALITEM_POS_FIELD,
  SEALITEM_SEALID_FIELD,
  SEALITEM_ISSEALING_FIELD,
  SEALITEM_ETYPE_FIELD,
  SEALITEM_QUESTID_FIELD
}
SEALITEM.is_extendable = false
SEALITEM.extensions = {}
SEALDATA_MAPID_FIELD.name = "mapid"
SEALDATA_MAPID_FIELD.full_name = ".Cmd.SealData.mapid"
SEALDATA_MAPID_FIELD.number = 1
SEALDATA_MAPID_FIELD.index = 0
SEALDATA_MAPID_FIELD.label = 1
SEALDATA_MAPID_FIELD.has_default_value = true
SEALDATA_MAPID_FIELD.default_value = 0
SEALDATA_MAPID_FIELD.type = 13
SEALDATA_MAPID_FIELD.cpp_type = 3
SEALDATA_ITEMS_FIELD.name = "items"
SEALDATA_ITEMS_FIELD.full_name = ".Cmd.SealData.items"
SEALDATA_ITEMS_FIELD.number = 2
SEALDATA_ITEMS_FIELD.index = 1
SEALDATA_ITEMS_FIELD.label = 3
SEALDATA_ITEMS_FIELD.has_default_value = false
SEALDATA_ITEMS_FIELD.default_value = {}
SEALDATA_ITEMS_FIELD.message_type = SEALITEM
SEALDATA_ITEMS_FIELD.type = 11
SEALDATA_ITEMS_FIELD.cpp_type = 10
SEALDATA.name = "SealData"
SEALDATA.full_name = ".Cmd.SealData"
SEALDATA.nested_types = {}
SEALDATA.enum_types = {}
SEALDATA.fields = {
  SEALDATA_MAPID_FIELD,
  SEALDATA_ITEMS_FIELD
}
SEALDATA.is_extendable = false
SEALDATA.extensions = {}
QUERYSEAL_CMD_FIELD.name = "cmd"
QUERYSEAL_CMD_FIELD.full_name = ".Cmd.QuerySeal.cmd"
QUERYSEAL_CMD_FIELD.number = 1
QUERYSEAL_CMD_FIELD.index = 0
QUERYSEAL_CMD_FIELD.label = 1
QUERYSEAL_CMD_FIELD.has_default_value = true
QUERYSEAL_CMD_FIELD.default_value = 21
QUERYSEAL_CMD_FIELD.enum_type = XCMD_PB_COMMAND
QUERYSEAL_CMD_FIELD.type = 14
QUERYSEAL_CMD_FIELD.cpp_type = 8
QUERYSEAL_PARAM_FIELD.name = "param"
QUERYSEAL_PARAM_FIELD.full_name = ".Cmd.QuerySeal.param"
QUERYSEAL_PARAM_FIELD.number = 2
QUERYSEAL_PARAM_FIELD.index = 1
QUERYSEAL_PARAM_FIELD.label = 1
QUERYSEAL_PARAM_FIELD.has_default_value = true
QUERYSEAL_PARAM_FIELD.default_value = 1
QUERYSEAL_PARAM_FIELD.enum_type = SEALPARAM
QUERYSEAL_PARAM_FIELD.type = 14
QUERYSEAL_PARAM_FIELD.cpp_type = 8
QUERYSEAL_DATAS_FIELD.name = "datas"
QUERYSEAL_DATAS_FIELD.full_name = ".Cmd.QuerySeal.datas"
QUERYSEAL_DATAS_FIELD.number = 3
QUERYSEAL_DATAS_FIELD.index = 2
QUERYSEAL_DATAS_FIELD.label = 3
QUERYSEAL_DATAS_FIELD.has_default_value = false
QUERYSEAL_DATAS_FIELD.default_value = {}
QUERYSEAL_DATAS_FIELD.message_type = SEALDATA
QUERYSEAL_DATAS_FIELD.type = 11
QUERYSEAL_DATAS_FIELD.cpp_type = 10
QUERYSEAL.name = "QuerySeal"
QUERYSEAL.full_name = ".Cmd.QuerySeal"
QUERYSEAL.nested_types = {}
QUERYSEAL.enum_types = {}
QUERYSEAL.fields = {
  QUERYSEAL_CMD_FIELD,
  QUERYSEAL_PARAM_FIELD,
  QUERYSEAL_DATAS_FIELD
}
QUERYSEAL.is_extendable = false
QUERYSEAL.extensions = {}
UPDATESEAL_CMD_FIELD.name = "cmd"
UPDATESEAL_CMD_FIELD.full_name = ".Cmd.UpdateSeal.cmd"
UPDATESEAL_CMD_FIELD.number = 1
UPDATESEAL_CMD_FIELD.index = 0
UPDATESEAL_CMD_FIELD.label = 1
UPDATESEAL_CMD_FIELD.has_default_value = true
UPDATESEAL_CMD_FIELD.default_value = 21
UPDATESEAL_CMD_FIELD.enum_type = XCMD_PB_COMMAND
UPDATESEAL_CMD_FIELD.type = 14
UPDATESEAL_CMD_FIELD.cpp_type = 8
UPDATESEAL_PARAM_FIELD.name = "param"
UPDATESEAL_PARAM_FIELD.full_name = ".Cmd.UpdateSeal.param"
UPDATESEAL_PARAM_FIELD.number = 2
UPDATESEAL_PARAM_FIELD.index = 1
UPDATESEAL_PARAM_FIELD.label = 1
UPDATESEAL_PARAM_FIELD.has_default_value = true
UPDATESEAL_PARAM_FIELD.default_value = 2
UPDATESEAL_PARAM_FIELD.enum_type = SEALPARAM
UPDATESEAL_PARAM_FIELD.type = 14
UPDATESEAL_PARAM_FIELD.cpp_type = 8
UPDATESEAL_NEWDATA_FIELD.name = "newdata"
UPDATESEAL_NEWDATA_FIELD.full_name = ".Cmd.UpdateSeal.newdata"
UPDATESEAL_NEWDATA_FIELD.number = 3
UPDATESEAL_NEWDATA_FIELD.index = 2
UPDATESEAL_NEWDATA_FIELD.label = 3
UPDATESEAL_NEWDATA_FIELD.has_default_value = false
UPDATESEAL_NEWDATA_FIELD.default_value = {}
UPDATESEAL_NEWDATA_FIELD.message_type = SEALDATA
UPDATESEAL_NEWDATA_FIELD.type = 11
UPDATESEAL_NEWDATA_FIELD.cpp_type = 10
UPDATESEAL_DELDATA_FIELD.name = "deldata"
UPDATESEAL_DELDATA_FIELD.full_name = ".Cmd.UpdateSeal.deldata"
UPDATESEAL_DELDATA_FIELD.number = 4
UPDATESEAL_DELDATA_FIELD.index = 3
UPDATESEAL_DELDATA_FIELD.label = 3
UPDATESEAL_DELDATA_FIELD.has_default_value = false
UPDATESEAL_DELDATA_FIELD.default_value = {}
UPDATESEAL_DELDATA_FIELD.message_type = SEALDATA
UPDATESEAL_DELDATA_FIELD.type = 11
UPDATESEAL_DELDATA_FIELD.cpp_type = 10
UPDATESEAL.name = "UpdateSeal"
UPDATESEAL.full_name = ".Cmd.UpdateSeal"
UPDATESEAL.nested_types = {}
UPDATESEAL.enum_types = {}
UPDATESEAL.fields = {
  UPDATESEAL_CMD_FIELD,
  UPDATESEAL_PARAM_FIELD,
  UPDATESEAL_NEWDATA_FIELD,
  UPDATESEAL_DELDATA_FIELD
}
UPDATESEAL.is_extendable = false
UPDATESEAL.extensions = {}
SEALTIMER_CMD_FIELD.name = "cmd"
SEALTIMER_CMD_FIELD.full_name = ".Cmd.SealTimer.cmd"
SEALTIMER_CMD_FIELD.number = 1
SEALTIMER_CMD_FIELD.index = 0
SEALTIMER_CMD_FIELD.label = 1
SEALTIMER_CMD_FIELD.has_default_value = true
SEALTIMER_CMD_FIELD.default_value = 21
SEALTIMER_CMD_FIELD.enum_type = XCMD_PB_COMMAND
SEALTIMER_CMD_FIELD.type = 14
SEALTIMER_CMD_FIELD.cpp_type = 8
SEALTIMER_PARAM_FIELD.name = "param"
SEALTIMER_PARAM_FIELD.full_name = ".Cmd.SealTimer.param"
SEALTIMER_PARAM_FIELD.number = 2
SEALTIMER_PARAM_FIELD.index = 1
SEALTIMER_PARAM_FIELD.label = 1
SEALTIMER_PARAM_FIELD.has_default_value = true
SEALTIMER_PARAM_FIELD.default_value = 3
SEALTIMER_PARAM_FIELD.enum_type = SEALPARAM
SEALTIMER_PARAM_FIELD.type = 14
SEALTIMER_PARAM_FIELD.cpp_type = 8
SEALTIMER_SPEED_FIELD.name = "speed"
SEALTIMER_SPEED_FIELD.full_name = ".Cmd.SealTimer.speed"
SEALTIMER_SPEED_FIELD.number = 3
SEALTIMER_SPEED_FIELD.index = 2
SEALTIMER_SPEED_FIELD.label = 1
SEALTIMER_SPEED_FIELD.has_default_value = true
SEALTIMER_SPEED_FIELD.default_value = 0
SEALTIMER_SPEED_FIELD.type = 5
SEALTIMER_SPEED_FIELD.cpp_type = 1
SEALTIMER_CURVALUE_FIELD.name = "curvalue"
SEALTIMER_CURVALUE_FIELD.full_name = ".Cmd.SealTimer.curvalue"
SEALTIMER_CURVALUE_FIELD.number = 4
SEALTIMER_CURVALUE_FIELD.index = 3
SEALTIMER_CURVALUE_FIELD.label = 1
SEALTIMER_CURVALUE_FIELD.has_default_value = true
SEALTIMER_CURVALUE_FIELD.default_value = 0
SEALTIMER_CURVALUE_FIELD.type = 13
SEALTIMER_CURVALUE_FIELD.cpp_type = 3
SEALTIMER_MAXVALUE_FIELD.name = "maxvalue"
SEALTIMER_MAXVALUE_FIELD.full_name = ".Cmd.SealTimer.maxvalue"
SEALTIMER_MAXVALUE_FIELD.number = 5
SEALTIMER_MAXVALUE_FIELD.index = 4
SEALTIMER_MAXVALUE_FIELD.label = 1
SEALTIMER_MAXVALUE_FIELD.has_default_value = true
SEALTIMER_MAXVALUE_FIELD.default_value = 0
SEALTIMER_MAXVALUE_FIELD.type = 13
SEALTIMER_MAXVALUE_FIELD.cpp_type = 3
SEALTIMER_STOPTIME_FIELD.name = "stoptime"
SEALTIMER_STOPTIME_FIELD.full_name = ".Cmd.SealTimer.stoptime"
SEALTIMER_STOPTIME_FIELD.number = 6
SEALTIMER_STOPTIME_FIELD.index = 5
SEALTIMER_STOPTIME_FIELD.label = 1
SEALTIMER_STOPTIME_FIELD.has_default_value = true
SEALTIMER_STOPTIME_FIELD.default_value = 0
SEALTIMER_STOPTIME_FIELD.type = 13
SEALTIMER_STOPTIME_FIELD.cpp_type = 3
SEALTIMER_MAXTIME_FIELD.name = "maxtime"
SEALTIMER_MAXTIME_FIELD.full_name = ".Cmd.SealTimer.maxtime"
SEALTIMER_MAXTIME_FIELD.number = 7
SEALTIMER_MAXTIME_FIELD.index = 6
SEALTIMER_MAXTIME_FIELD.label = 1
SEALTIMER_MAXTIME_FIELD.has_default_value = true
SEALTIMER_MAXTIME_FIELD.default_value = 0
SEALTIMER_MAXTIME_FIELD.type = 13
SEALTIMER_MAXTIME_FIELD.cpp_type = 3
SEALTIMER.name = "SealTimer"
SEALTIMER.full_name = ".Cmd.SealTimer"
SEALTIMER.nested_types = {}
SEALTIMER.enum_types = {}
SEALTIMER.fields = {
  SEALTIMER_CMD_FIELD,
  SEALTIMER_PARAM_FIELD,
  SEALTIMER_SPEED_FIELD,
  SEALTIMER_CURVALUE_FIELD,
  SEALTIMER_MAXVALUE_FIELD,
  SEALTIMER_STOPTIME_FIELD,
  SEALTIMER_MAXTIME_FIELD
}
SEALTIMER.is_extendable = false
SEALTIMER.extensions = {}
BEGINSEAL_CMD_FIELD.name = "cmd"
BEGINSEAL_CMD_FIELD.full_name = ".Cmd.BeginSeal.cmd"
BEGINSEAL_CMD_FIELD.number = 1
BEGINSEAL_CMD_FIELD.index = 0
BEGINSEAL_CMD_FIELD.label = 1
BEGINSEAL_CMD_FIELD.has_default_value = true
BEGINSEAL_CMD_FIELD.default_value = 21
BEGINSEAL_CMD_FIELD.enum_type = XCMD_PB_COMMAND
BEGINSEAL_CMD_FIELD.type = 14
BEGINSEAL_CMD_FIELD.cpp_type = 8
BEGINSEAL_PARAM_FIELD.name = "param"
BEGINSEAL_PARAM_FIELD.full_name = ".Cmd.BeginSeal.param"
BEGINSEAL_PARAM_FIELD.number = 2
BEGINSEAL_PARAM_FIELD.index = 1
BEGINSEAL_PARAM_FIELD.label = 1
BEGINSEAL_PARAM_FIELD.has_default_value = true
BEGINSEAL_PARAM_FIELD.default_value = 4
BEGINSEAL_PARAM_FIELD.enum_type = SEALPARAM
BEGINSEAL_PARAM_FIELD.type = 14
BEGINSEAL_PARAM_FIELD.cpp_type = 8
BEGINSEAL_SEALID_FIELD.name = "sealid"
BEGINSEAL_SEALID_FIELD.full_name = ".Cmd.BeginSeal.sealid"
BEGINSEAL_SEALID_FIELD.number = 3
BEGINSEAL_SEALID_FIELD.index = 2
BEGINSEAL_SEALID_FIELD.label = 1
BEGINSEAL_SEALID_FIELD.has_default_value = true
BEGINSEAL_SEALID_FIELD.default_value = 0
BEGINSEAL_SEALID_FIELD.type = 4
BEGINSEAL_SEALID_FIELD.cpp_type = 4
BEGINSEAL_ETYPE_FIELD.name = "etype"
BEGINSEAL_ETYPE_FIELD.full_name = ".Cmd.BeginSeal.etype"
BEGINSEAL_ETYPE_FIELD.number = 4
BEGINSEAL_ETYPE_FIELD.index = 3
BEGINSEAL_ETYPE_FIELD.label = 1
BEGINSEAL_ETYPE_FIELD.has_default_value = true
BEGINSEAL_ETYPE_FIELD.default_value = 1
BEGINSEAL_ETYPE_FIELD.enum_type = EFINISHTYPE
BEGINSEAL_ETYPE_FIELD.type = 14
BEGINSEAL_ETYPE_FIELD.cpp_type = 8
BEGINSEAL_FINISHALL_FIELD.name = "finishall"
BEGINSEAL_FINISHALL_FIELD.full_name = ".Cmd.BeginSeal.finishall"
BEGINSEAL_FINISHALL_FIELD.number = 5
BEGINSEAL_FINISHALL_FIELD.index = 4
BEGINSEAL_FINISHALL_FIELD.label = 1
BEGINSEAL_FINISHALL_FIELD.has_default_value = true
BEGINSEAL_FINISHALL_FIELD.default_value = false
BEGINSEAL_FINISHALL_FIELD.type = 8
BEGINSEAL_FINISHALL_FIELD.cpp_type = 7
BEGINSEAL.name = "BeginSeal"
BEGINSEAL.full_name = ".Cmd.BeginSeal"
BEGINSEAL.nested_types = {}
BEGINSEAL.enum_types = {}
BEGINSEAL.fields = {
  BEGINSEAL_CMD_FIELD,
  BEGINSEAL_PARAM_FIELD,
  BEGINSEAL_SEALID_FIELD,
  BEGINSEAL_ETYPE_FIELD,
  BEGINSEAL_FINISHALL_FIELD
}
BEGINSEAL.is_extendable = false
BEGINSEAL.extensions = {}
ENDSEAL_CMD_FIELD.name = "cmd"
ENDSEAL_CMD_FIELD.full_name = ".Cmd.EndSeal.cmd"
ENDSEAL_CMD_FIELD.number = 1
ENDSEAL_CMD_FIELD.index = 0
ENDSEAL_CMD_FIELD.label = 1
ENDSEAL_CMD_FIELD.has_default_value = true
ENDSEAL_CMD_FIELD.default_value = 21
ENDSEAL_CMD_FIELD.enum_type = XCMD_PB_COMMAND
ENDSEAL_CMD_FIELD.type = 14
ENDSEAL_CMD_FIELD.cpp_type = 8
ENDSEAL_PARAM_FIELD.name = "param"
ENDSEAL_PARAM_FIELD.full_name = ".Cmd.EndSeal.param"
ENDSEAL_PARAM_FIELD.number = 2
ENDSEAL_PARAM_FIELD.index = 1
ENDSEAL_PARAM_FIELD.label = 1
ENDSEAL_PARAM_FIELD.has_default_value = true
ENDSEAL_PARAM_FIELD.default_value = 5
ENDSEAL_PARAM_FIELD.enum_type = SEALPARAM
ENDSEAL_PARAM_FIELD.type = 14
ENDSEAL_PARAM_FIELD.cpp_type = 8
ENDSEAL_SUCCESS_FIELD.name = "success"
ENDSEAL_SUCCESS_FIELD.full_name = ".Cmd.EndSeal.success"
ENDSEAL_SUCCESS_FIELD.number = 3
ENDSEAL_SUCCESS_FIELD.index = 2
ENDSEAL_SUCCESS_FIELD.label = 1
ENDSEAL_SUCCESS_FIELD.has_default_value = true
ENDSEAL_SUCCESS_FIELD.default_value = false
ENDSEAL_SUCCESS_FIELD.type = 8
ENDSEAL_SUCCESS_FIELD.cpp_type = 7
ENDSEAL_SEALID_FIELD.name = "sealid"
ENDSEAL_SEALID_FIELD.full_name = ".Cmd.EndSeal.sealid"
ENDSEAL_SEALID_FIELD.number = 4
ENDSEAL_SEALID_FIELD.index = 3
ENDSEAL_SEALID_FIELD.label = 1
ENDSEAL_SEALID_FIELD.has_default_value = true
ENDSEAL_SEALID_FIELD.default_value = 0
ENDSEAL_SEALID_FIELD.type = 13
ENDSEAL_SEALID_FIELD.cpp_type = 3
ENDSEAL.name = "EndSeal"
ENDSEAL.full_name = ".Cmd.EndSeal"
ENDSEAL.nested_types = {}
ENDSEAL.enum_types = {}
ENDSEAL.fields = {
  ENDSEAL_CMD_FIELD,
  ENDSEAL_PARAM_FIELD,
  ENDSEAL_SUCCESS_FIELD,
  ENDSEAL_SEALID_FIELD
}
ENDSEAL.is_extendable = false
ENDSEAL.extensions = {}
SEALUSERLEAVE_CMD_FIELD.name = "cmd"
SEALUSERLEAVE_CMD_FIELD.full_name = ".Cmd.SealUserLeave.cmd"
SEALUSERLEAVE_CMD_FIELD.number = 1
SEALUSERLEAVE_CMD_FIELD.index = 0
SEALUSERLEAVE_CMD_FIELD.label = 1
SEALUSERLEAVE_CMD_FIELD.has_default_value = true
SEALUSERLEAVE_CMD_FIELD.default_value = 21
SEALUSERLEAVE_CMD_FIELD.enum_type = XCMD_PB_COMMAND
SEALUSERLEAVE_CMD_FIELD.type = 14
SEALUSERLEAVE_CMD_FIELD.cpp_type = 8
SEALUSERLEAVE_PARAM_FIELD.name = "param"
SEALUSERLEAVE_PARAM_FIELD.full_name = ".Cmd.SealUserLeave.param"
SEALUSERLEAVE_PARAM_FIELD.number = 2
SEALUSERLEAVE_PARAM_FIELD.index = 1
SEALUSERLEAVE_PARAM_FIELD.label = 1
SEALUSERLEAVE_PARAM_FIELD.has_default_value = true
SEALUSERLEAVE_PARAM_FIELD.default_value = 6
SEALUSERLEAVE_PARAM_FIELD.enum_type = SEALPARAM
SEALUSERLEAVE_PARAM_FIELD.type = 14
SEALUSERLEAVE_PARAM_FIELD.cpp_type = 8
SEALUSERLEAVE.name = "SealUserLeave"
SEALUSERLEAVE.full_name = ".Cmd.SealUserLeave"
SEALUSERLEAVE.nested_types = {}
SEALUSERLEAVE.enum_types = {}
SEALUSERLEAVE.fields = {
  SEALUSERLEAVE_CMD_FIELD,
  SEALUSERLEAVE_PARAM_FIELD
}
SEALUSERLEAVE.is_extendable = false
SEALUSERLEAVE.extensions = {}
SEALCONFIGPART_CONFIGID_FIELD.name = "configid"
SEALCONFIGPART_CONFIGID_FIELD.full_name = ".Cmd.SealConfigPart.configid"
SEALCONFIGPART_CONFIGID_FIELD.number = 1
SEALCONFIGPART_CONFIGID_FIELD.index = 0
SEALCONFIGPART_CONFIGID_FIELD.label = 1
SEALCONFIGPART_CONFIGID_FIELD.has_default_value = false
SEALCONFIGPART_CONFIGID_FIELD.default_value = 0
SEALCONFIGPART_CONFIGID_FIELD.type = 13
SEALCONFIGPART_CONFIGID_FIELD.cpp_type = 3
SEALCONFIGPART_PASSFLAG_FIELD.name = "passflag"
SEALCONFIGPART_PASSFLAG_FIELD.full_name = ".Cmd.SealConfigPart.passflag"
SEALCONFIGPART_PASSFLAG_FIELD.number = 2
SEALCONFIGPART_PASSFLAG_FIELD.index = 1
SEALCONFIGPART_PASSFLAG_FIELD.label = 1
SEALCONFIGPART_PASSFLAG_FIELD.has_default_value = false
SEALCONFIGPART_PASSFLAG_FIELD.default_value = false
SEALCONFIGPART_PASSFLAG_FIELD.type = 8
SEALCONFIGPART_PASSFLAG_FIELD.cpp_type = 7
SEALCONFIGPART.name = "SealConfigPart"
SEALCONFIGPART.full_name = ".Cmd.SealConfigPart"
SEALCONFIGPART.nested_types = {}
SEALCONFIGPART.enum_types = {}
SEALCONFIGPART.fields = {
  SEALCONFIGPART_CONFIGID_FIELD,
  SEALCONFIGPART_PASSFLAG_FIELD
}
SEALCONFIGPART.is_extendable = false
SEALCONFIGPART.extensions = {}
SEALQUERYLIST_CMD_FIELD.name = "cmd"
SEALQUERYLIST_CMD_FIELD.full_name = ".Cmd.SealQueryList.cmd"
SEALQUERYLIST_CMD_FIELD.number = 1
SEALQUERYLIST_CMD_FIELD.index = 0
SEALQUERYLIST_CMD_FIELD.label = 1
SEALQUERYLIST_CMD_FIELD.has_default_value = true
SEALQUERYLIST_CMD_FIELD.default_value = 21
SEALQUERYLIST_CMD_FIELD.enum_type = XCMD_PB_COMMAND
SEALQUERYLIST_CMD_FIELD.type = 14
SEALQUERYLIST_CMD_FIELD.cpp_type = 8
SEALQUERYLIST_PARAM_FIELD.name = "param"
SEALQUERYLIST_PARAM_FIELD.full_name = ".Cmd.SealQueryList.param"
SEALQUERYLIST_PARAM_FIELD.number = 2
SEALQUERYLIST_PARAM_FIELD.index = 1
SEALQUERYLIST_PARAM_FIELD.label = 1
SEALQUERYLIST_PARAM_FIELD.has_default_value = true
SEALQUERYLIST_PARAM_FIELD.default_value = 7
SEALQUERYLIST_PARAM_FIELD.enum_type = SEALPARAM
SEALQUERYLIST_PARAM_FIELD.type = 14
SEALQUERYLIST_PARAM_FIELD.cpp_type = 8
SEALQUERYLIST_CONFIGID_FIELD.name = "configid"
SEALQUERYLIST_CONFIGID_FIELD.full_name = ".Cmd.SealQueryList.configid"
SEALQUERYLIST_CONFIGID_FIELD.number = 3
SEALQUERYLIST_CONFIGID_FIELD.index = 2
SEALQUERYLIST_CONFIGID_FIELD.label = 3
SEALQUERYLIST_CONFIGID_FIELD.has_default_value = false
SEALQUERYLIST_CONFIGID_FIELD.default_value = {}
SEALQUERYLIST_CONFIGID_FIELD.type = 13
SEALQUERYLIST_CONFIGID_FIELD.cpp_type = 3
SEALQUERYLIST_DONETIMES_FIELD.name = "donetimes"
SEALQUERYLIST_DONETIMES_FIELD.full_name = ".Cmd.SealQueryList.donetimes"
SEALQUERYLIST_DONETIMES_FIELD.number = 4
SEALQUERYLIST_DONETIMES_FIELD.index = 3
SEALQUERYLIST_DONETIMES_FIELD.label = 1
SEALQUERYLIST_DONETIMES_FIELD.has_default_value = true
SEALQUERYLIST_DONETIMES_FIELD.default_value = 0
SEALQUERYLIST_DONETIMES_FIELD.type = 13
SEALQUERYLIST_DONETIMES_FIELD.cpp_type = 3
SEALQUERYLIST_MAXTIMES_FIELD.name = "maxtimes"
SEALQUERYLIST_MAXTIMES_FIELD.full_name = ".Cmd.SealQueryList.maxtimes"
SEALQUERYLIST_MAXTIMES_FIELD.number = 5
SEALQUERYLIST_MAXTIMES_FIELD.index = 4
SEALQUERYLIST_MAXTIMES_FIELD.label = 1
SEALQUERYLIST_MAXTIMES_FIELD.has_default_value = true
SEALQUERYLIST_MAXTIMES_FIELD.default_value = 0
SEALQUERYLIST_MAXTIMES_FIELD.type = 13
SEALQUERYLIST_MAXTIMES_FIELD.cpp_type = 3
SEALQUERYLIST_CONFIGPARTS_FIELD.name = "configparts"
SEALQUERYLIST_CONFIGPARTS_FIELD.full_name = ".Cmd.SealQueryList.configparts"
SEALQUERYLIST_CONFIGPARTS_FIELD.number = 6
SEALQUERYLIST_CONFIGPARTS_FIELD.index = 5
SEALQUERYLIST_CONFIGPARTS_FIELD.label = 3
SEALQUERYLIST_CONFIGPARTS_FIELD.has_default_value = false
SEALQUERYLIST_CONFIGPARTS_FIELD.default_value = {}
SEALQUERYLIST_CONFIGPARTS_FIELD.message_type = SEALCONFIGPART
SEALQUERYLIST_CONFIGPARTS_FIELD.type = 11
SEALQUERYLIST_CONFIGPARTS_FIELD.cpp_type = 10
SEALQUERYLIST.name = "SealQueryList"
SEALQUERYLIST.full_name = ".Cmd.SealQueryList"
SEALQUERYLIST.nested_types = {}
SEALQUERYLIST.enum_types = {}
SEALQUERYLIST.fields = {
  SEALQUERYLIST_CMD_FIELD,
  SEALQUERYLIST_PARAM_FIELD,
  SEALQUERYLIST_CONFIGID_FIELD,
  SEALQUERYLIST_DONETIMES_FIELD,
  SEALQUERYLIST_MAXTIMES_FIELD,
  SEALQUERYLIST_CONFIGPARTS_FIELD
}
SEALQUERYLIST.is_extendable = false
SEALQUERYLIST.extensions = {}
SEALACCEPTCMD_CMD_FIELD.name = "cmd"
SEALACCEPTCMD_CMD_FIELD.full_name = ".Cmd.SealAcceptCmd.cmd"
SEALACCEPTCMD_CMD_FIELD.number = 1
SEALACCEPTCMD_CMD_FIELD.index = 0
SEALACCEPTCMD_CMD_FIELD.label = 1
SEALACCEPTCMD_CMD_FIELD.has_default_value = true
SEALACCEPTCMD_CMD_FIELD.default_value = 21
SEALACCEPTCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
SEALACCEPTCMD_CMD_FIELD.type = 14
SEALACCEPTCMD_CMD_FIELD.cpp_type = 8
SEALACCEPTCMD_PARAM_FIELD.name = "param"
SEALACCEPTCMD_PARAM_FIELD.full_name = ".Cmd.SealAcceptCmd.param"
SEALACCEPTCMD_PARAM_FIELD.number = 2
SEALACCEPTCMD_PARAM_FIELD.index = 1
SEALACCEPTCMD_PARAM_FIELD.label = 1
SEALACCEPTCMD_PARAM_FIELD.has_default_value = true
SEALACCEPTCMD_PARAM_FIELD.default_value = 8
SEALACCEPTCMD_PARAM_FIELD.enum_type = SEALPARAM
SEALACCEPTCMD_PARAM_FIELD.type = 14
SEALACCEPTCMD_PARAM_FIELD.cpp_type = 8
SEALACCEPTCMD_SEAL_FIELD.name = "seal"
SEALACCEPTCMD_SEAL_FIELD.full_name = ".Cmd.SealAcceptCmd.seal"
SEALACCEPTCMD_SEAL_FIELD.number = 3
SEALACCEPTCMD_SEAL_FIELD.index = 2
SEALACCEPTCMD_SEAL_FIELD.label = 1
SEALACCEPTCMD_SEAL_FIELD.has_default_value = true
SEALACCEPTCMD_SEAL_FIELD.default_value = 0
SEALACCEPTCMD_SEAL_FIELD.type = 13
SEALACCEPTCMD_SEAL_FIELD.cpp_type = 3
SEALACCEPTCMD_POS_FIELD.name = "pos"
SEALACCEPTCMD_POS_FIELD.full_name = ".Cmd.SealAcceptCmd.pos"
SEALACCEPTCMD_POS_FIELD.number = 4
SEALACCEPTCMD_POS_FIELD.index = 3
SEALACCEPTCMD_POS_FIELD.label = 1
SEALACCEPTCMD_POS_FIELD.has_default_value = false
SEALACCEPTCMD_POS_FIELD.default_value = nil
SEALACCEPTCMD_POS_FIELD.message_type = ProtoCommon_pb.SCENEPOS
SEALACCEPTCMD_POS_FIELD.type = 11
SEALACCEPTCMD_POS_FIELD.cpp_type = 10
SEALACCEPTCMD_ABANDON_FIELD.name = "abandon"
SEALACCEPTCMD_ABANDON_FIELD.full_name = ".Cmd.SealAcceptCmd.abandon"
SEALACCEPTCMD_ABANDON_FIELD.number = 5
SEALACCEPTCMD_ABANDON_FIELD.index = 4
SEALACCEPTCMD_ABANDON_FIELD.label = 1
SEALACCEPTCMD_ABANDON_FIELD.has_default_value = true
SEALACCEPTCMD_ABANDON_FIELD.default_value = false
SEALACCEPTCMD_ABANDON_FIELD.type = 8
SEALACCEPTCMD_ABANDON_FIELD.cpp_type = 7
SEALACCEPTCMD.name = "SealAcceptCmd"
SEALACCEPTCMD.full_name = ".Cmd.SealAcceptCmd"
SEALACCEPTCMD.nested_types = {}
SEALACCEPTCMD.enum_types = {}
SEALACCEPTCMD.fields = {
  SEALACCEPTCMD_CMD_FIELD,
  SEALACCEPTCMD_PARAM_FIELD,
  SEALACCEPTCMD_SEAL_FIELD,
  SEALACCEPTCMD_POS_FIELD,
  SEALACCEPTCMD_ABANDON_FIELD
}
SEALACCEPTCMD.is_extendable = false
SEALACCEPTCMD.extensions = {}
BeginSeal = protobuf.Message(BEGINSEAL)
EFINISHTYPE_MAX = 4
EFINISHTYPE_MIN = 0
EFINISHTYPE_NORMAL = 1
EFINISHTYPE_QUICK = 2
EFINISHTYPE_QUICK_NOPROCESS = 3
ESEALTYPE_ACTIVITY = 3
ESEALTYPE_FADEJOB = 4
ESEALTYPE_MAX = 5
ESEALTYPE_MIN = 0
ESEALTYPE_NORMAL = 1
ESEALTYPE_PERSONAL = 2
EndSeal = protobuf.Message(ENDSEAL)
QuerySeal = protobuf.Message(QUERYSEAL)
SEALPARAM_ACCEPTSEAL = 8
SEALPARAM_BEGINSEAL = 4
SEALPARAM_ENDSEAL = 5
SEALPARAM_QUERYLIST = 7
SEALPARAM_QUERYSEAL = 1
SEALPARAM_SEALTIMER = 3
SEALPARAM_UPDATESEAL = 2
SEALPARAM_USERLEAVE = 6
SealAcceptCmd = protobuf.Message(SEALACCEPTCMD)
SealConfigPart = protobuf.Message(SEALCONFIGPART)
SealData = protobuf.Message(SEALDATA)
SealItem = protobuf.Message(SEALITEM)
SealQueryList = protobuf.Message(SEALQUERYLIST)
SealTimer = protobuf.Message(SEALTIMER)
SealUserLeave = protobuf.Message(SEALUSERLEAVE)
UpdateSeal = protobuf.Message(UPDATESEAL)
