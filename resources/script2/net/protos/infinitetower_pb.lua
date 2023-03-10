local protobuf = protobuf
autoImport("xCmd_pb")
local xCmd_pb = xCmd_pb
module("InfiniteTower_pb")
TOWERPARAM = protobuf.EnumDescriptor()
TOWERPARAM_ETOWERPARAM_TEAMTOWERINFO_ENUM = protobuf.EnumValueDescriptor()
TOWERPARAM_ETOWERPARAM_TEAMTOWERSUMMARY_ENUM = protobuf.EnumValueDescriptor()
TOWERPARAM_ETOWERPARAM_INVITE_ENUM = protobuf.EnumValueDescriptor()
TOWERPARAM_ETOWERPARAM_REPLY_ENUM = protobuf.EnumValueDescriptor()
TOWERPARAM_ETOWERPARAM_ENTERTOWER_ENUM = protobuf.EnumValueDescriptor()
TOWERPARAM_ETOWERPARAM_USERTOWERINFO_ENUM = protobuf.EnumValueDescriptor()
TOWERPARAM_ETOWERPARAM_LAYER_SYNC_ENUM = protobuf.EnumValueDescriptor()
TOWERPARAM_ETOWERPARAM_NEW_EVERLAYER_ENUM = protobuf.EnumValueDescriptor()
TOWERPARAM_ETOWERPARAM_TOWERINFO_ENUM = protobuf.EnumValueDescriptor()
ETOWERREPLY = protobuf.EnumDescriptor()
ETOWERREPLY_ETOWERREPLY_AGREE_ENUM = protobuf.EnumValueDescriptor()
ETOWERREPLY_ETOWERREPLY_DISAGREE_ENUM = protobuf.EnumValueDescriptor()
USERTOWERLAYER = protobuf.Descriptor()
USERTOWERLAYER_LAYER_FIELD = protobuf.FieldDescriptor()
USERTOWERLAYER_UTIME_FIELD = protobuf.FieldDescriptor()
USERTOWERLAYER_REWARDED_FIELD = protobuf.FieldDescriptor()
USERTOWERINFO = protobuf.Descriptor()
USERTOWERINFO_OLDMAXLAYER_FIELD = protobuf.FieldDescriptor()
USERTOWERINFO_CURMAXLAYER_FIELD = protobuf.FieldDescriptor()
USERTOWERINFO_LAYERS_FIELD = protobuf.FieldDescriptor()
USERTOWERINFO_MAXLAYER_FIELD = protobuf.FieldDescriptor()
USERTOWERINFO_RECORD_LAYER_FIELD = protobuf.FieldDescriptor()
USERTOWERINFO_EVERPASSLAYERS_FIELD = protobuf.FieldDescriptor()
TEAMTOWERSUMMARY = protobuf.Descriptor()
TEAMTOWERSUMMARY_TEAMID_FIELD = protobuf.FieldDescriptor()
TEAMTOWERSUMMARY_LAYER_FIELD = protobuf.FieldDescriptor()
TEAMTOWERSUMMARY_LEADERTOWER_FIELD = protobuf.FieldDescriptor()
TEAMTOWERSUMMARY_MEMBERS_FIELD = protobuf.FieldDescriptor()
TEAMTOWERINFOCMD = protobuf.Descriptor()
TEAMTOWERINFOCMD_CMD_FIELD = protobuf.FieldDescriptor()
TEAMTOWERINFOCMD_PARAM_FIELD = protobuf.FieldDescriptor()
TEAMTOWERINFOCMD_TEAMID_FIELD = protobuf.FieldDescriptor()
TEAMTOWERSUMMARYCMD = protobuf.Descriptor()
TEAMTOWERSUMMARYCMD_CMD_FIELD = protobuf.FieldDescriptor()
TEAMTOWERSUMMARYCMD_PARAM_FIELD = protobuf.FieldDescriptor()
TEAMTOWERSUMMARYCMD_TEAMTOWER_FIELD = protobuf.FieldDescriptor()
TEAMTOWERSUMMARYCMD_MAXLAYER_FIELD = protobuf.FieldDescriptor()
TEAMTOWERSUMMARYCMD_REFRESHTIME_FIELD = protobuf.FieldDescriptor()
TEAMTOWERINVITECMD = protobuf.Descriptor()
TEAMTOWERINVITECMD_CMD_FIELD = protobuf.FieldDescriptor()
TEAMTOWERINVITECMD_PARAM_FIELD = protobuf.FieldDescriptor()
TEAMTOWERINVITECMD_ISCANCEL_FIELD = protobuf.FieldDescriptor()
TEAMTOWERINVITECMD_LAYER_FIELD = protobuf.FieldDescriptor()
TEAMTOWERINVITECMD_ENTRANCEID_FIELD = protobuf.FieldDescriptor()
TEAMTOWERINVITECMD_LEFTTIME_FIELD = protobuf.FieldDescriptor()
TEAMTOWERREPLYCMD = protobuf.Descriptor()
TEAMTOWERREPLYCMD_CMD_FIELD = protobuf.FieldDescriptor()
TEAMTOWERREPLYCMD_PARAM_FIELD = protobuf.FieldDescriptor()
TEAMTOWERREPLYCMD_EREPLY_FIELD = protobuf.FieldDescriptor()
TEAMTOWERREPLYCMD_USERID_FIELD = protobuf.FieldDescriptor()
ENTERTOWER = protobuf.Descriptor()
ENTERTOWER_CMD_FIELD = protobuf.FieldDescriptor()
ENTERTOWER_PARAM_FIELD = protobuf.FieldDescriptor()
ENTERTOWER_LAYER_FIELD = protobuf.FieldDescriptor()
ENTERTOWER_USERID_FIELD = protobuf.FieldDescriptor()
ENTERTOWER_ZONEID_FIELD = protobuf.FieldDescriptor()
ENTERTOWER_TIME_FIELD = protobuf.FieldDescriptor()
ENTERTOWER_SIGN_FIELD = protobuf.FieldDescriptor()
ENTERTOWER_GOMAPTYPE_FIELD = protobuf.FieldDescriptor()
USERTOWERINFOCMD = protobuf.Descriptor()
USERTOWERINFOCMD_CMD_FIELD = protobuf.FieldDescriptor()
USERTOWERINFOCMD_PARAM_FIELD = protobuf.FieldDescriptor()
USERTOWERINFOCMD_USERTOWER_FIELD = protobuf.FieldDescriptor()
TOWERLAYERSYNCTOWERCMD = protobuf.Descriptor()
TOWERLAYERSYNCTOWERCMD_CMD_FIELD = protobuf.FieldDescriptor()
TOWERLAYERSYNCTOWERCMD_PARAM_FIELD = protobuf.FieldDescriptor()
TOWERLAYERSYNCTOWERCMD_LAYER_FIELD = protobuf.FieldDescriptor()
TOWERINFOCMD = protobuf.Descriptor()
TOWERINFOCMD_CMD_FIELD = protobuf.FieldDescriptor()
TOWERINFOCMD_PARAM_FIELD = protobuf.FieldDescriptor()
TOWERINFOCMD_MAXLAYER_FIELD = protobuf.FieldDescriptor()
TOWERINFOCMD_REFRESHTIME_FIELD = protobuf.FieldDescriptor()
NEWEVERLAYERTOWERCMD = protobuf.Descriptor()
NEWEVERLAYERTOWERCMD_CMD_FIELD = protobuf.FieldDescriptor()
NEWEVERLAYERTOWERCMD_PARAM_FIELD = protobuf.FieldDescriptor()
NEWEVERLAYERTOWERCMD_LAYERS_FIELD = protobuf.FieldDescriptor()
TOWERPARAM_ETOWERPARAM_TEAMTOWERINFO_ENUM.name = "ETOWERPARAM_TEAMTOWERINFO"
TOWERPARAM_ETOWERPARAM_TEAMTOWERINFO_ENUM.index = 0
TOWERPARAM_ETOWERPARAM_TEAMTOWERINFO_ENUM.number = 1
TOWERPARAM_ETOWERPARAM_TEAMTOWERSUMMARY_ENUM.name = "ETOWERPARAM_TEAMTOWERSUMMARY"
TOWERPARAM_ETOWERPARAM_TEAMTOWERSUMMARY_ENUM.index = 1
TOWERPARAM_ETOWERPARAM_TEAMTOWERSUMMARY_ENUM.number = 2
TOWERPARAM_ETOWERPARAM_INVITE_ENUM.name = "ETOWERPARAM_INVITE"
TOWERPARAM_ETOWERPARAM_INVITE_ENUM.index = 2
TOWERPARAM_ETOWERPARAM_INVITE_ENUM.number = 3
TOWERPARAM_ETOWERPARAM_REPLY_ENUM.name = "ETOWERPARAM_REPLY"
TOWERPARAM_ETOWERPARAM_REPLY_ENUM.index = 3
TOWERPARAM_ETOWERPARAM_REPLY_ENUM.number = 4
TOWERPARAM_ETOWERPARAM_ENTERTOWER_ENUM.name = "ETOWERPARAM_ENTERTOWER"
TOWERPARAM_ETOWERPARAM_ENTERTOWER_ENUM.index = 4
TOWERPARAM_ETOWERPARAM_ENTERTOWER_ENUM.number = 5
TOWERPARAM_ETOWERPARAM_USERTOWERINFO_ENUM.name = "ETOWERPARAM_USERTOWERINFO"
TOWERPARAM_ETOWERPARAM_USERTOWERINFO_ENUM.index = 5
TOWERPARAM_ETOWERPARAM_USERTOWERINFO_ENUM.number = 7
TOWERPARAM_ETOWERPARAM_LAYER_SYNC_ENUM.name = "ETOWERPARAM_LAYER_SYNC"
TOWERPARAM_ETOWERPARAM_LAYER_SYNC_ENUM.index = 6
TOWERPARAM_ETOWERPARAM_LAYER_SYNC_ENUM.number = 8
TOWERPARAM_ETOWERPARAM_NEW_EVERLAYER_ENUM.name = "ETOWERPARAM_NEW_EVERLAYER"
TOWERPARAM_ETOWERPARAM_NEW_EVERLAYER_ENUM.index = 7
TOWERPARAM_ETOWERPARAM_NEW_EVERLAYER_ENUM.number = 9
TOWERPARAM_ETOWERPARAM_TOWERINFO_ENUM.name = "ETOWERPARAM_TOWERINFO"
TOWERPARAM_ETOWERPARAM_TOWERINFO_ENUM.index = 8
TOWERPARAM_ETOWERPARAM_TOWERINFO_ENUM.number = 10
TOWERPARAM.name = "TowerParam"
TOWERPARAM.full_name = ".Cmd.TowerParam"
TOWERPARAM.values = {
  TOWERPARAM_ETOWERPARAM_TEAMTOWERINFO_ENUM,
  TOWERPARAM_ETOWERPARAM_TEAMTOWERSUMMARY_ENUM,
  TOWERPARAM_ETOWERPARAM_INVITE_ENUM,
  TOWERPARAM_ETOWERPARAM_REPLY_ENUM,
  TOWERPARAM_ETOWERPARAM_ENTERTOWER_ENUM,
  TOWERPARAM_ETOWERPARAM_USERTOWERINFO_ENUM,
  TOWERPARAM_ETOWERPARAM_LAYER_SYNC_ENUM,
  TOWERPARAM_ETOWERPARAM_NEW_EVERLAYER_ENUM,
  TOWERPARAM_ETOWERPARAM_TOWERINFO_ENUM
}
ETOWERREPLY_ETOWERREPLY_AGREE_ENUM.name = "ETOWERREPLY_AGREE"
ETOWERREPLY_ETOWERREPLY_AGREE_ENUM.index = 0
ETOWERREPLY_ETOWERREPLY_AGREE_ENUM.number = 1
ETOWERREPLY_ETOWERREPLY_DISAGREE_ENUM.name = "ETOWERREPLY_DISAGREE"
ETOWERREPLY_ETOWERREPLY_DISAGREE_ENUM.index = 1
ETOWERREPLY_ETOWERREPLY_DISAGREE_ENUM.number = 2
ETOWERREPLY.name = "ETowerReply"
ETOWERREPLY.full_name = ".Cmd.ETowerReply"
ETOWERREPLY.values = {
  ETOWERREPLY_ETOWERREPLY_AGREE_ENUM,
  ETOWERREPLY_ETOWERREPLY_DISAGREE_ENUM
}
USERTOWERLAYER_LAYER_FIELD.name = "layer"
USERTOWERLAYER_LAYER_FIELD.full_name = ".Cmd.UserTowerLayer.layer"
USERTOWERLAYER_LAYER_FIELD.number = 1
USERTOWERLAYER_LAYER_FIELD.index = 0
USERTOWERLAYER_LAYER_FIELD.label = 1
USERTOWERLAYER_LAYER_FIELD.has_default_value = true
USERTOWERLAYER_LAYER_FIELD.default_value = 0
USERTOWERLAYER_LAYER_FIELD.type = 13
USERTOWERLAYER_LAYER_FIELD.cpp_type = 3
USERTOWERLAYER_UTIME_FIELD.name = "utime"
USERTOWERLAYER_UTIME_FIELD.full_name = ".Cmd.UserTowerLayer.utime"
USERTOWERLAYER_UTIME_FIELD.number = 2
USERTOWERLAYER_UTIME_FIELD.index = 1
USERTOWERLAYER_UTIME_FIELD.label = 1
USERTOWERLAYER_UTIME_FIELD.has_default_value = true
USERTOWERLAYER_UTIME_FIELD.default_value = 0
USERTOWERLAYER_UTIME_FIELD.type = 13
USERTOWERLAYER_UTIME_FIELD.cpp_type = 3
USERTOWERLAYER_REWARDED_FIELD.name = "rewarded"
USERTOWERLAYER_REWARDED_FIELD.full_name = ".Cmd.UserTowerLayer.rewarded"
USERTOWERLAYER_REWARDED_FIELD.number = 3
USERTOWERLAYER_REWARDED_FIELD.index = 2
USERTOWERLAYER_REWARDED_FIELD.label = 1
USERTOWERLAYER_REWARDED_FIELD.has_default_value = true
USERTOWERLAYER_REWARDED_FIELD.default_value = false
USERTOWERLAYER_REWARDED_FIELD.type = 8
USERTOWERLAYER_REWARDED_FIELD.cpp_type = 7
USERTOWERLAYER.name = "UserTowerLayer"
USERTOWERLAYER.full_name = ".Cmd.UserTowerLayer"
USERTOWERLAYER.nested_types = {}
USERTOWERLAYER.enum_types = {}
USERTOWERLAYER.fields = {
  USERTOWERLAYER_LAYER_FIELD,
  USERTOWERLAYER_UTIME_FIELD,
  USERTOWERLAYER_REWARDED_FIELD
}
USERTOWERLAYER.is_extendable = false
USERTOWERLAYER.extensions = {}
USERTOWERINFO_OLDMAXLAYER_FIELD.name = "oldmaxlayer"
USERTOWERINFO_OLDMAXLAYER_FIELD.full_name = ".Cmd.UserTowerInfo.oldmaxlayer"
USERTOWERINFO_OLDMAXLAYER_FIELD.number = 1
USERTOWERINFO_OLDMAXLAYER_FIELD.index = 0
USERTOWERINFO_OLDMAXLAYER_FIELD.label = 1
USERTOWERINFO_OLDMAXLAYER_FIELD.has_default_value = true
USERTOWERINFO_OLDMAXLAYER_FIELD.default_value = 0
USERTOWERINFO_OLDMAXLAYER_FIELD.type = 13
USERTOWERINFO_OLDMAXLAYER_FIELD.cpp_type = 3
USERTOWERINFO_CURMAXLAYER_FIELD.name = "curmaxlayer"
USERTOWERINFO_CURMAXLAYER_FIELD.full_name = ".Cmd.UserTowerInfo.curmaxlayer"
USERTOWERINFO_CURMAXLAYER_FIELD.number = 2
USERTOWERINFO_CURMAXLAYER_FIELD.index = 1
USERTOWERINFO_CURMAXLAYER_FIELD.label = 1
USERTOWERINFO_CURMAXLAYER_FIELD.has_default_value = true
USERTOWERINFO_CURMAXLAYER_FIELD.default_value = 0
USERTOWERINFO_CURMAXLAYER_FIELD.type = 13
USERTOWERINFO_CURMAXLAYER_FIELD.cpp_type = 3
USERTOWERINFO_LAYERS_FIELD.name = "layers"
USERTOWERINFO_LAYERS_FIELD.full_name = ".Cmd.UserTowerInfo.layers"
USERTOWERINFO_LAYERS_FIELD.number = 3
USERTOWERINFO_LAYERS_FIELD.index = 2
USERTOWERINFO_LAYERS_FIELD.label = 3
USERTOWERINFO_LAYERS_FIELD.has_default_value = false
USERTOWERINFO_LAYERS_FIELD.default_value = {}
USERTOWERINFO_LAYERS_FIELD.message_type = USERTOWERLAYER
USERTOWERINFO_LAYERS_FIELD.type = 11
USERTOWERINFO_LAYERS_FIELD.cpp_type = 10
USERTOWERINFO_MAXLAYER_FIELD.name = "maxlayer"
USERTOWERINFO_MAXLAYER_FIELD.full_name = ".Cmd.UserTowerInfo.maxlayer"
USERTOWERINFO_MAXLAYER_FIELD.number = 4
USERTOWERINFO_MAXLAYER_FIELD.index = 3
USERTOWERINFO_MAXLAYER_FIELD.label = 1
USERTOWERINFO_MAXLAYER_FIELD.has_default_value = true
USERTOWERINFO_MAXLAYER_FIELD.default_value = 0
USERTOWERINFO_MAXLAYER_FIELD.type = 13
USERTOWERINFO_MAXLAYER_FIELD.cpp_type = 3
USERTOWERINFO_RECORD_LAYER_FIELD.name = "record_layer"
USERTOWERINFO_RECORD_LAYER_FIELD.full_name = ".Cmd.UserTowerInfo.record_layer"
USERTOWERINFO_RECORD_LAYER_FIELD.number = 5
USERTOWERINFO_RECORD_LAYER_FIELD.index = 4
USERTOWERINFO_RECORD_LAYER_FIELD.label = 1
USERTOWERINFO_RECORD_LAYER_FIELD.has_default_value = true
USERTOWERINFO_RECORD_LAYER_FIELD.default_value = 0
USERTOWERINFO_RECORD_LAYER_FIELD.type = 13
USERTOWERINFO_RECORD_LAYER_FIELD.cpp_type = 3
USERTOWERINFO_EVERPASSLAYERS_FIELD.name = "everpasslayers"
USERTOWERINFO_EVERPASSLAYERS_FIELD.full_name = ".Cmd.UserTowerInfo.everpasslayers"
USERTOWERINFO_EVERPASSLAYERS_FIELD.number = 6
USERTOWERINFO_EVERPASSLAYERS_FIELD.index = 5
USERTOWERINFO_EVERPASSLAYERS_FIELD.label = 3
USERTOWERINFO_EVERPASSLAYERS_FIELD.has_default_value = false
USERTOWERINFO_EVERPASSLAYERS_FIELD.default_value = {}
USERTOWERINFO_EVERPASSLAYERS_FIELD.message_type = USERTOWERLAYER
USERTOWERINFO_EVERPASSLAYERS_FIELD.type = 11
USERTOWERINFO_EVERPASSLAYERS_FIELD.cpp_type = 10
USERTOWERINFO.name = "UserTowerInfo"
USERTOWERINFO.full_name = ".Cmd.UserTowerInfo"
USERTOWERINFO.nested_types = {}
USERTOWERINFO.enum_types = {}
USERTOWERINFO.fields = {
  USERTOWERINFO_OLDMAXLAYER_FIELD,
  USERTOWERINFO_CURMAXLAYER_FIELD,
  USERTOWERINFO_LAYERS_FIELD,
  USERTOWERINFO_MAXLAYER_FIELD,
  USERTOWERINFO_RECORD_LAYER_FIELD,
  USERTOWERINFO_EVERPASSLAYERS_FIELD
}
USERTOWERINFO.is_extendable = false
USERTOWERINFO.extensions = {}
TEAMTOWERSUMMARY_TEAMID_FIELD.name = "teamid"
TEAMTOWERSUMMARY_TEAMID_FIELD.full_name = ".Cmd.TeamTowerSummary.teamid"
TEAMTOWERSUMMARY_TEAMID_FIELD.number = 1
TEAMTOWERSUMMARY_TEAMID_FIELD.index = 0
TEAMTOWERSUMMARY_TEAMID_FIELD.label = 1
TEAMTOWERSUMMARY_TEAMID_FIELD.has_default_value = true
TEAMTOWERSUMMARY_TEAMID_FIELD.default_value = 0
TEAMTOWERSUMMARY_TEAMID_FIELD.type = 4
TEAMTOWERSUMMARY_TEAMID_FIELD.cpp_type = 4
TEAMTOWERSUMMARY_LAYER_FIELD.name = "layer"
TEAMTOWERSUMMARY_LAYER_FIELD.full_name = ".Cmd.TeamTowerSummary.layer"
TEAMTOWERSUMMARY_LAYER_FIELD.number = 2
TEAMTOWERSUMMARY_LAYER_FIELD.index = 1
TEAMTOWERSUMMARY_LAYER_FIELD.label = 1
TEAMTOWERSUMMARY_LAYER_FIELD.has_default_value = true
TEAMTOWERSUMMARY_LAYER_FIELD.default_value = 0
TEAMTOWERSUMMARY_LAYER_FIELD.type = 13
TEAMTOWERSUMMARY_LAYER_FIELD.cpp_type = 3
TEAMTOWERSUMMARY_LEADERTOWER_FIELD.name = "leadertower"
TEAMTOWERSUMMARY_LEADERTOWER_FIELD.full_name = ".Cmd.TeamTowerSummary.leadertower"
TEAMTOWERSUMMARY_LEADERTOWER_FIELD.number = 4
TEAMTOWERSUMMARY_LEADERTOWER_FIELD.index = 2
TEAMTOWERSUMMARY_LEADERTOWER_FIELD.label = 1
TEAMTOWERSUMMARY_LEADERTOWER_FIELD.has_default_value = false
TEAMTOWERSUMMARY_LEADERTOWER_FIELD.default_value = nil
TEAMTOWERSUMMARY_LEADERTOWER_FIELD.message_type = USERTOWERINFO
TEAMTOWERSUMMARY_LEADERTOWER_FIELD.type = 11
TEAMTOWERSUMMARY_LEADERTOWER_FIELD.cpp_type = 10
TEAMTOWERSUMMARY_MEMBERS_FIELD.name = "members"
TEAMTOWERSUMMARY_MEMBERS_FIELD.full_name = ".Cmd.TeamTowerSummary.members"
TEAMTOWERSUMMARY_MEMBERS_FIELD.number = 3
TEAMTOWERSUMMARY_MEMBERS_FIELD.index = 3
TEAMTOWERSUMMARY_MEMBERS_FIELD.label = 3
TEAMTOWERSUMMARY_MEMBERS_FIELD.has_default_value = false
TEAMTOWERSUMMARY_MEMBERS_FIELD.default_value = {}
TEAMTOWERSUMMARY_MEMBERS_FIELD.type = 4
TEAMTOWERSUMMARY_MEMBERS_FIELD.cpp_type = 4
TEAMTOWERSUMMARY.name = "TeamTowerSummary"
TEAMTOWERSUMMARY.full_name = ".Cmd.TeamTowerSummary"
TEAMTOWERSUMMARY.nested_types = {}
TEAMTOWERSUMMARY.enum_types = {}
TEAMTOWERSUMMARY.fields = {
  TEAMTOWERSUMMARY_TEAMID_FIELD,
  TEAMTOWERSUMMARY_LAYER_FIELD,
  TEAMTOWERSUMMARY_LEADERTOWER_FIELD,
  TEAMTOWERSUMMARY_MEMBERS_FIELD
}
TEAMTOWERSUMMARY.is_extendable = false
TEAMTOWERSUMMARY.extensions = {}
TEAMTOWERINFOCMD_CMD_FIELD.name = "cmd"
TEAMTOWERINFOCMD_CMD_FIELD.full_name = ".Cmd.TeamTowerInfoCmd.cmd"
TEAMTOWERINFOCMD_CMD_FIELD.number = 1
TEAMTOWERINFOCMD_CMD_FIELD.index = 0
TEAMTOWERINFOCMD_CMD_FIELD.label = 1
TEAMTOWERINFOCMD_CMD_FIELD.has_default_value = true
TEAMTOWERINFOCMD_CMD_FIELD.default_value = 20
TEAMTOWERINFOCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
TEAMTOWERINFOCMD_CMD_FIELD.type = 14
TEAMTOWERINFOCMD_CMD_FIELD.cpp_type = 8
TEAMTOWERINFOCMD_PARAM_FIELD.name = "param"
TEAMTOWERINFOCMD_PARAM_FIELD.full_name = ".Cmd.TeamTowerInfoCmd.param"
TEAMTOWERINFOCMD_PARAM_FIELD.number = 2
TEAMTOWERINFOCMD_PARAM_FIELD.index = 1
TEAMTOWERINFOCMD_PARAM_FIELD.label = 1
TEAMTOWERINFOCMD_PARAM_FIELD.has_default_value = true
TEAMTOWERINFOCMD_PARAM_FIELD.default_value = 1
TEAMTOWERINFOCMD_PARAM_FIELD.enum_type = TOWERPARAM
TEAMTOWERINFOCMD_PARAM_FIELD.type = 14
TEAMTOWERINFOCMD_PARAM_FIELD.cpp_type = 8
TEAMTOWERINFOCMD_TEAMID_FIELD.name = "teamid"
TEAMTOWERINFOCMD_TEAMID_FIELD.full_name = ".Cmd.TeamTowerInfoCmd.teamid"
TEAMTOWERINFOCMD_TEAMID_FIELD.number = 3
TEAMTOWERINFOCMD_TEAMID_FIELD.index = 2
TEAMTOWERINFOCMD_TEAMID_FIELD.label = 1
TEAMTOWERINFOCMD_TEAMID_FIELD.has_default_value = true
TEAMTOWERINFOCMD_TEAMID_FIELD.default_value = 0
TEAMTOWERINFOCMD_TEAMID_FIELD.type = 4
TEAMTOWERINFOCMD_TEAMID_FIELD.cpp_type = 4
TEAMTOWERINFOCMD.name = "TeamTowerInfoCmd"
TEAMTOWERINFOCMD.full_name = ".Cmd.TeamTowerInfoCmd"
TEAMTOWERINFOCMD.nested_types = {}
TEAMTOWERINFOCMD.enum_types = {}
TEAMTOWERINFOCMD.fields = {
  TEAMTOWERINFOCMD_CMD_FIELD,
  TEAMTOWERINFOCMD_PARAM_FIELD,
  TEAMTOWERINFOCMD_TEAMID_FIELD
}
TEAMTOWERINFOCMD.is_extendable = false
TEAMTOWERINFOCMD.extensions = {}
TEAMTOWERSUMMARYCMD_CMD_FIELD.name = "cmd"
TEAMTOWERSUMMARYCMD_CMD_FIELD.full_name = ".Cmd.TeamTowerSummaryCmd.cmd"
TEAMTOWERSUMMARYCMD_CMD_FIELD.number = 1
TEAMTOWERSUMMARYCMD_CMD_FIELD.index = 0
TEAMTOWERSUMMARYCMD_CMD_FIELD.label = 1
TEAMTOWERSUMMARYCMD_CMD_FIELD.has_default_value = true
TEAMTOWERSUMMARYCMD_CMD_FIELD.default_value = 20
TEAMTOWERSUMMARYCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
TEAMTOWERSUMMARYCMD_CMD_FIELD.type = 14
TEAMTOWERSUMMARYCMD_CMD_FIELD.cpp_type = 8
TEAMTOWERSUMMARYCMD_PARAM_FIELD.name = "param"
TEAMTOWERSUMMARYCMD_PARAM_FIELD.full_name = ".Cmd.TeamTowerSummaryCmd.param"
TEAMTOWERSUMMARYCMD_PARAM_FIELD.number = 2
TEAMTOWERSUMMARYCMD_PARAM_FIELD.index = 1
TEAMTOWERSUMMARYCMD_PARAM_FIELD.label = 1
TEAMTOWERSUMMARYCMD_PARAM_FIELD.has_default_value = true
TEAMTOWERSUMMARYCMD_PARAM_FIELD.default_value = 2
TEAMTOWERSUMMARYCMD_PARAM_FIELD.enum_type = TOWERPARAM
TEAMTOWERSUMMARYCMD_PARAM_FIELD.type = 14
TEAMTOWERSUMMARYCMD_PARAM_FIELD.cpp_type = 8
TEAMTOWERSUMMARYCMD_TEAMTOWER_FIELD.name = "teamtower"
TEAMTOWERSUMMARYCMD_TEAMTOWER_FIELD.full_name = ".Cmd.TeamTowerSummaryCmd.teamtower"
TEAMTOWERSUMMARYCMD_TEAMTOWER_FIELD.number = 3
TEAMTOWERSUMMARYCMD_TEAMTOWER_FIELD.index = 2
TEAMTOWERSUMMARYCMD_TEAMTOWER_FIELD.label = 1
TEAMTOWERSUMMARYCMD_TEAMTOWER_FIELD.has_default_value = false
TEAMTOWERSUMMARYCMD_TEAMTOWER_FIELD.default_value = nil
TEAMTOWERSUMMARYCMD_TEAMTOWER_FIELD.message_type = TEAMTOWERSUMMARY
TEAMTOWERSUMMARYCMD_TEAMTOWER_FIELD.type = 11
TEAMTOWERSUMMARYCMD_TEAMTOWER_FIELD.cpp_type = 10
TEAMTOWERSUMMARYCMD_MAXLAYER_FIELD.name = "maxlayer"
TEAMTOWERSUMMARYCMD_MAXLAYER_FIELD.full_name = ".Cmd.TeamTowerSummaryCmd.maxlayer"
TEAMTOWERSUMMARYCMD_MAXLAYER_FIELD.number = 4
TEAMTOWERSUMMARYCMD_MAXLAYER_FIELD.index = 3
TEAMTOWERSUMMARYCMD_MAXLAYER_FIELD.label = 1
TEAMTOWERSUMMARYCMD_MAXLAYER_FIELD.has_default_value = true
TEAMTOWERSUMMARYCMD_MAXLAYER_FIELD.default_value = 0
TEAMTOWERSUMMARYCMD_MAXLAYER_FIELD.type = 13
TEAMTOWERSUMMARYCMD_MAXLAYER_FIELD.cpp_type = 3
TEAMTOWERSUMMARYCMD_REFRESHTIME_FIELD.name = "refreshtime"
TEAMTOWERSUMMARYCMD_REFRESHTIME_FIELD.full_name = ".Cmd.TeamTowerSummaryCmd.refreshtime"
TEAMTOWERSUMMARYCMD_REFRESHTIME_FIELD.number = 5
TEAMTOWERSUMMARYCMD_REFRESHTIME_FIELD.index = 4
TEAMTOWERSUMMARYCMD_REFRESHTIME_FIELD.label = 1
TEAMTOWERSUMMARYCMD_REFRESHTIME_FIELD.has_default_value = true
TEAMTOWERSUMMARYCMD_REFRESHTIME_FIELD.default_value = 0
TEAMTOWERSUMMARYCMD_REFRESHTIME_FIELD.type = 13
TEAMTOWERSUMMARYCMD_REFRESHTIME_FIELD.cpp_type = 3
TEAMTOWERSUMMARYCMD.name = "TeamTowerSummaryCmd"
TEAMTOWERSUMMARYCMD.full_name = ".Cmd.TeamTowerSummaryCmd"
TEAMTOWERSUMMARYCMD.nested_types = {}
TEAMTOWERSUMMARYCMD.enum_types = {}
TEAMTOWERSUMMARYCMD.fields = {
  TEAMTOWERSUMMARYCMD_CMD_FIELD,
  TEAMTOWERSUMMARYCMD_PARAM_FIELD,
  TEAMTOWERSUMMARYCMD_TEAMTOWER_FIELD,
  TEAMTOWERSUMMARYCMD_MAXLAYER_FIELD,
  TEAMTOWERSUMMARYCMD_REFRESHTIME_FIELD
}
TEAMTOWERSUMMARYCMD.is_extendable = false
TEAMTOWERSUMMARYCMD.extensions = {}
TEAMTOWERINVITECMD_CMD_FIELD.name = "cmd"
TEAMTOWERINVITECMD_CMD_FIELD.full_name = ".Cmd.TeamTowerInviteCmd.cmd"
TEAMTOWERINVITECMD_CMD_FIELD.number = 1
TEAMTOWERINVITECMD_CMD_FIELD.index = 0
TEAMTOWERINVITECMD_CMD_FIELD.label = 1
TEAMTOWERINVITECMD_CMD_FIELD.has_default_value = true
TEAMTOWERINVITECMD_CMD_FIELD.default_value = 20
TEAMTOWERINVITECMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
TEAMTOWERINVITECMD_CMD_FIELD.type = 14
TEAMTOWERINVITECMD_CMD_FIELD.cpp_type = 8
TEAMTOWERINVITECMD_PARAM_FIELD.name = "param"
TEAMTOWERINVITECMD_PARAM_FIELD.full_name = ".Cmd.TeamTowerInviteCmd.param"
TEAMTOWERINVITECMD_PARAM_FIELD.number = 2
TEAMTOWERINVITECMD_PARAM_FIELD.index = 1
TEAMTOWERINVITECMD_PARAM_FIELD.label = 1
TEAMTOWERINVITECMD_PARAM_FIELD.has_default_value = true
TEAMTOWERINVITECMD_PARAM_FIELD.default_value = 3
TEAMTOWERINVITECMD_PARAM_FIELD.enum_type = TOWERPARAM
TEAMTOWERINVITECMD_PARAM_FIELD.type = 14
TEAMTOWERINVITECMD_PARAM_FIELD.cpp_type = 8
TEAMTOWERINVITECMD_ISCANCEL_FIELD.name = "iscancel"
TEAMTOWERINVITECMD_ISCANCEL_FIELD.full_name = ".Cmd.TeamTowerInviteCmd.iscancel"
TEAMTOWERINVITECMD_ISCANCEL_FIELD.number = 3
TEAMTOWERINVITECMD_ISCANCEL_FIELD.index = 2
TEAMTOWERINVITECMD_ISCANCEL_FIELD.label = 1
TEAMTOWERINVITECMD_ISCANCEL_FIELD.has_default_value = true
TEAMTOWERINVITECMD_ISCANCEL_FIELD.default_value = false
TEAMTOWERINVITECMD_ISCANCEL_FIELD.type = 8
TEAMTOWERINVITECMD_ISCANCEL_FIELD.cpp_type = 7
TEAMTOWERINVITECMD_LAYER_FIELD.name = "layer"
TEAMTOWERINVITECMD_LAYER_FIELD.full_name = ".Cmd.TeamTowerInviteCmd.layer"
TEAMTOWERINVITECMD_LAYER_FIELD.number = 4
TEAMTOWERINVITECMD_LAYER_FIELD.index = 3
TEAMTOWERINVITECMD_LAYER_FIELD.label = 1
TEAMTOWERINVITECMD_LAYER_FIELD.has_default_value = false
TEAMTOWERINVITECMD_LAYER_FIELD.default_value = 0
TEAMTOWERINVITECMD_LAYER_FIELD.type = 13
TEAMTOWERINVITECMD_LAYER_FIELD.cpp_type = 3
TEAMTOWERINVITECMD_ENTRANCEID_FIELD.name = "entranceid"
TEAMTOWERINVITECMD_ENTRANCEID_FIELD.full_name = ".Cmd.TeamTowerInviteCmd.entranceid"
TEAMTOWERINVITECMD_ENTRANCEID_FIELD.number = 5
TEAMTOWERINVITECMD_ENTRANCEID_FIELD.index = 4
TEAMTOWERINVITECMD_ENTRANCEID_FIELD.label = 1
TEAMTOWERINVITECMD_ENTRANCEID_FIELD.has_default_value = false
TEAMTOWERINVITECMD_ENTRANCEID_FIELD.default_value = 0
TEAMTOWERINVITECMD_ENTRANCEID_FIELD.type = 13
TEAMTOWERINVITECMD_ENTRANCEID_FIELD.cpp_type = 3
TEAMTOWERINVITECMD_LEFTTIME_FIELD.name = "lefttime"
TEAMTOWERINVITECMD_LEFTTIME_FIELD.full_name = ".Cmd.TeamTowerInviteCmd.lefttime"
TEAMTOWERINVITECMD_LEFTTIME_FIELD.number = 6
TEAMTOWERINVITECMD_LEFTTIME_FIELD.index = 5
TEAMTOWERINVITECMD_LEFTTIME_FIELD.label = 1
TEAMTOWERINVITECMD_LEFTTIME_FIELD.has_default_value = false
TEAMTOWERINVITECMD_LEFTTIME_FIELD.default_value = 0
TEAMTOWERINVITECMD_LEFTTIME_FIELD.type = 13
TEAMTOWERINVITECMD_LEFTTIME_FIELD.cpp_type = 3
TEAMTOWERINVITECMD.name = "TeamTowerInviteCmd"
TEAMTOWERINVITECMD.full_name = ".Cmd.TeamTowerInviteCmd"
TEAMTOWERINVITECMD.nested_types = {}
TEAMTOWERINVITECMD.enum_types = {}
TEAMTOWERINVITECMD.fields = {
  TEAMTOWERINVITECMD_CMD_FIELD,
  TEAMTOWERINVITECMD_PARAM_FIELD,
  TEAMTOWERINVITECMD_ISCANCEL_FIELD,
  TEAMTOWERINVITECMD_LAYER_FIELD,
  TEAMTOWERINVITECMD_ENTRANCEID_FIELD,
  TEAMTOWERINVITECMD_LEFTTIME_FIELD
}
TEAMTOWERINVITECMD.is_extendable = false
TEAMTOWERINVITECMD.extensions = {}
TEAMTOWERREPLYCMD_CMD_FIELD.name = "cmd"
TEAMTOWERREPLYCMD_CMD_FIELD.full_name = ".Cmd.TeamTowerReplyCmd.cmd"
TEAMTOWERREPLYCMD_CMD_FIELD.number = 1
TEAMTOWERREPLYCMD_CMD_FIELD.index = 0
TEAMTOWERREPLYCMD_CMD_FIELD.label = 1
TEAMTOWERREPLYCMD_CMD_FIELD.has_default_value = true
TEAMTOWERREPLYCMD_CMD_FIELD.default_value = 20
TEAMTOWERREPLYCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
TEAMTOWERREPLYCMD_CMD_FIELD.type = 14
TEAMTOWERREPLYCMD_CMD_FIELD.cpp_type = 8
TEAMTOWERREPLYCMD_PARAM_FIELD.name = "param"
TEAMTOWERREPLYCMD_PARAM_FIELD.full_name = ".Cmd.TeamTowerReplyCmd.param"
TEAMTOWERREPLYCMD_PARAM_FIELD.number = 2
TEAMTOWERREPLYCMD_PARAM_FIELD.index = 1
TEAMTOWERREPLYCMD_PARAM_FIELD.label = 1
TEAMTOWERREPLYCMD_PARAM_FIELD.has_default_value = true
TEAMTOWERREPLYCMD_PARAM_FIELD.default_value = 4
TEAMTOWERREPLYCMD_PARAM_FIELD.enum_type = TOWERPARAM
TEAMTOWERREPLYCMD_PARAM_FIELD.type = 14
TEAMTOWERREPLYCMD_PARAM_FIELD.cpp_type = 8
TEAMTOWERREPLYCMD_EREPLY_FIELD.name = "eReply"
TEAMTOWERREPLYCMD_EREPLY_FIELD.full_name = ".Cmd.TeamTowerReplyCmd.eReply"
TEAMTOWERREPLYCMD_EREPLY_FIELD.number = 3
TEAMTOWERREPLYCMD_EREPLY_FIELD.index = 2
TEAMTOWERREPLYCMD_EREPLY_FIELD.label = 1
TEAMTOWERREPLYCMD_EREPLY_FIELD.has_default_value = true
TEAMTOWERREPLYCMD_EREPLY_FIELD.default_value = 2
TEAMTOWERREPLYCMD_EREPLY_FIELD.enum_type = ETOWERREPLY
TEAMTOWERREPLYCMD_EREPLY_FIELD.type = 14
TEAMTOWERREPLYCMD_EREPLY_FIELD.cpp_type = 8
TEAMTOWERREPLYCMD_USERID_FIELD.name = "userid"
TEAMTOWERREPLYCMD_USERID_FIELD.full_name = ".Cmd.TeamTowerReplyCmd.userid"
TEAMTOWERREPLYCMD_USERID_FIELD.number = 4
TEAMTOWERREPLYCMD_USERID_FIELD.index = 3
TEAMTOWERREPLYCMD_USERID_FIELD.label = 1
TEAMTOWERREPLYCMD_USERID_FIELD.has_default_value = true
TEAMTOWERREPLYCMD_USERID_FIELD.default_value = 0
TEAMTOWERREPLYCMD_USERID_FIELD.type = 4
TEAMTOWERREPLYCMD_USERID_FIELD.cpp_type = 4
TEAMTOWERREPLYCMD.name = "TeamTowerReplyCmd"
TEAMTOWERREPLYCMD.full_name = ".Cmd.TeamTowerReplyCmd"
TEAMTOWERREPLYCMD.nested_types = {}
TEAMTOWERREPLYCMD.enum_types = {}
TEAMTOWERREPLYCMD.fields = {
  TEAMTOWERREPLYCMD_CMD_FIELD,
  TEAMTOWERREPLYCMD_PARAM_FIELD,
  TEAMTOWERREPLYCMD_EREPLY_FIELD,
  TEAMTOWERREPLYCMD_USERID_FIELD
}
TEAMTOWERREPLYCMD.is_extendable = false
TEAMTOWERREPLYCMD.extensions = {}
ENTERTOWER_CMD_FIELD.name = "cmd"
ENTERTOWER_CMD_FIELD.full_name = ".Cmd.EnterTower.cmd"
ENTERTOWER_CMD_FIELD.number = 1
ENTERTOWER_CMD_FIELD.index = 0
ENTERTOWER_CMD_FIELD.label = 1
ENTERTOWER_CMD_FIELD.has_default_value = true
ENTERTOWER_CMD_FIELD.default_value = 20
ENTERTOWER_CMD_FIELD.enum_type = XCMD_PB_COMMAND
ENTERTOWER_CMD_FIELD.type = 14
ENTERTOWER_CMD_FIELD.cpp_type = 8
ENTERTOWER_PARAM_FIELD.name = "param"
ENTERTOWER_PARAM_FIELD.full_name = ".Cmd.EnterTower.param"
ENTERTOWER_PARAM_FIELD.number = 2
ENTERTOWER_PARAM_FIELD.index = 1
ENTERTOWER_PARAM_FIELD.label = 1
ENTERTOWER_PARAM_FIELD.has_default_value = true
ENTERTOWER_PARAM_FIELD.default_value = 5
ENTERTOWER_PARAM_FIELD.enum_type = TOWERPARAM
ENTERTOWER_PARAM_FIELD.type = 14
ENTERTOWER_PARAM_FIELD.cpp_type = 8
ENTERTOWER_LAYER_FIELD.name = "layer"
ENTERTOWER_LAYER_FIELD.full_name = ".Cmd.EnterTower.layer"
ENTERTOWER_LAYER_FIELD.number = 3
ENTERTOWER_LAYER_FIELD.index = 2
ENTERTOWER_LAYER_FIELD.label = 1
ENTERTOWER_LAYER_FIELD.has_default_value = true
ENTERTOWER_LAYER_FIELD.default_value = 0
ENTERTOWER_LAYER_FIELD.type = 13
ENTERTOWER_LAYER_FIELD.cpp_type = 3
ENTERTOWER_USERID_FIELD.name = "userid"
ENTERTOWER_USERID_FIELD.full_name = ".Cmd.EnterTower.userid"
ENTERTOWER_USERID_FIELD.number = 4
ENTERTOWER_USERID_FIELD.index = 3
ENTERTOWER_USERID_FIELD.label = 1
ENTERTOWER_USERID_FIELD.has_default_value = true
ENTERTOWER_USERID_FIELD.default_value = 0
ENTERTOWER_USERID_FIELD.type = 4
ENTERTOWER_USERID_FIELD.cpp_type = 4
ENTERTOWER_ZONEID_FIELD.name = "zoneid"
ENTERTOWER_ZONEID_FIELD.full_name = ".Cmd.EnterTower.zoneid"
ENTERTOWER_ZONEID_FIELD.number = 5
ENTERTOWER_ZONEID_FIELD.index = 4
ENTERTOWER_ZONEID_FIELD.label = 1
ENTERTOWER_ZONEID_FIELD.has_default_value = true
ENTERTOWER_ZONEID_FIELD.default_value = 0
ENTERTOWER_ZONEID_FIELD.type = 13
ENTERTOWER_ZONEID_FIELD.cpp_type = 3
ENTERTOWER_TIME_FIELD.name = "time"
ENTERTOWER_TIME_FIELD.full_name = ".Cmd.EnterTower.time"
ENTERTOWER_TIME_FIELD.number = 6
ENTERTOWER_TIME_FIELD.index = 5
ENTERTOWER_TIME_FIELD.label = 1
ENTERTOWER_TIME_FIELD.has_default_value = true
ENTERTOWER_TIME_FIELD.default_value = 0
ENTERTOWER_TIME_FIELD.type = 13
ENTERTOWER_TIME_FIELD.cpp_type = 3
ENTERTOWER_SIGN_FIELD.name = "sign"
ENTERTOWER_SIGN_FIELD.full_name = ".Cmd.EnterTower.sign"
ENTERTOWER_SIGN_FIELD.number = 7
ENTERTOWER_SIGN_FIELD.index = 6
ENTERTOWER_SIGN_FIELD.label = 1
ENTERTOWER_SIGN_FIELD.has_default_value = false
ENTERTOWER_SIGN_FIELD.default_value = ""
ENTERTOWER_SIGN_FIELD.type = 9
ENTERTOWER_SIGN_FIELD.cpp_type = 9
ENTERTOWER_GOMAPTYPE_FIELD.name = "gomaptype"
ENTERTOWER_GOMAPTYPE_FIELD.full_name = ".Cmd.EnterTower.gomaptype"
ENTERTOWER_GOMAPTYPE_FIELD.number = 8
ENTERTOWER_GOMAPTYPE_FIELD.index = 7
ENTERTOWER_GOMAPTYPE_FIELD.label = 1
ENTERTOWER_GOMAPTYPE_FIELD.has_default_value = true
ENTERTOWER_GOMAPTYPE_FIELD.default_value = 0
ENTERTOWER_GOMAPTYPE_FIELD.type = 13
ENTERTOWER_GOMAPTYPE_FIELD.cpp_type = 3
ENTERTOWER.name = "EnterTower"
ENTERTOWER.full_name = ".Cmd.EnterTower"
ENTERTOWER.nested_types = {}
ENTERTOWER.enum_types = {}
ENTERTOWER.fields = {
  ENTERTOWER_CMD_FIELD,
  ENTERTOWER_PARAM_FIELD,
  ENTERTOWER_LAYER_FIELD,
  ENTERTOWER_USERID_FIELD,
  ENTERTOWER_ZONEID_FIELD,
  ENTERTOWER_TIME_FIELD,
  ENTERTOWER_SIGN_FIELD,
  ENTERTOWER_GOMAPTYPE_FIELD
}
ENTERTOWER.is_extendable = false
ENTERTOWER.extensions = {}
USERTOWERINFOCMD_CMD_FIELD.name = "cmd"
USERTOWERINFOCMD_CMD_FIELD.full_name = ".Cmd.UserTowerInfoCmd.cmd"
USERTOWERINFOCMD_CMD_FIELD.number = 1
USERTOWERINFOCMD_CMD_FIELD.index = 0
USERTOWERINFOCMD_CMD_FIELD.label = 1
USERTOWERINFOCMD_CMD_FIELD.has_default_value = true
USERTOWERINFOCMD_CMD_FIELD.default_value = 20
USERTOWERINFOCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
USERTOWERINFOCMD_CMD_FIELD.type = 14
USERTOWERINFOCMD_CMD_FIELD.cpp_type = 8
USERTOWERINFOCMD_PARAM_FIELD.name = "param"
USERTOWERINFOCMD_PARAM_FIELD.full_name = ".Cmd.UserTowerInfoCmd.param"
USERTOWERINFOCMD_PARAM_FIELD.number = 2
USERTOWERINFOCMD_PARAM_FIELD.index = 1
USERTOWERINFOCMD_PARAM_FIELD.label = 1
USERTOWERINFOCMD_PARAM_FIELD.has_default_value = true
USERTOWERINFOCMD_PARAM_FIELD.default_value = 7
USERTOWERINFOCMD_PARAM_FIELD.enum_type = TOWERPARAM
USERTOWERINFOCMD_PARAM_FIELD.type = 14
USERTOWERINFOCMD_PARAM_FIELD.cpp_type = 8
USERTOWERINFOCMD_USERTOWER_FIELD.name = "usertower"
USERTOWERINFOCMD_USERTOWER_FIELD.full_name = ".Cmd.UserTowerInfoCmd.usertower"
USERTOWERINFOCMD_USERTOWER_FIELD.number = 3
USERTOWERINFOCMD_USERTOWER_FIELD.index = 2
USERTOWERINFOCMD_USERTOWER_FIELD.label = 1
USERTOWERINFOCMD_USERTOWER_FIELD.has_default_value = false
USERTOWERINFOCMD_USERTOWER_FIELD.default_value = nil
USERTOWERINFOCMD_USERTOWER_FIELD.message_type = USERTOWERINFO
USERTOWERINFOCMD_USERTOWER_FIELD.type = 11
USERTOWERINFOCMD_USERTOWER_FIELD.cpp_type = 10
USERTOWERINFOCMD.name = "UserTowerInfoCmd"
USERTOWERINFOCMD.full_name = ".Cmd.UserTowerInfoCmd"
USERTOWERINFOCMD.nested_types = {}
USERTOWERINFOCMD.enum_types = {}
USERTOWERINFOCMD.fields = {
  USERTOWERINFOCMD_CMD_FIELD,
  USERTOWERINFOCMD_PARAM_FIELD,
  USERTOWERINFOCMD_USERTOWER_FIELD
}
USERTOWERINFOCMD.is_extendable = false
USERTOWERINFOCMD.extensions = {}
TOWERLAYERSYNCTOWERCMD_CMD_FIELD.name = "cmd"
TOWERLAYERSYNCTOWERCMD_CMD_FIELD.full_name = ".Cmd.TowerLayerSyncTowerCmd.cmd"
TOWERLAYERSYNCTOWERCMD_CMD_FIELD.number = 1
TOWERLAYERSYNCTOWERCMD_CMD_FIELD.index = 0
TOWERLAYERSYNCTOWERCMD_CMD_FIELD.label = 1
TOWERLAYERSYNCTOWERCMD_CMD_FIELD.has_default_value = true
TOWERLAYERSYNCTOWERCMD_CMD_FIELD.default_value = 20
TOWERLAYERSYNCTOWERCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
TOWERLAYERSYNCTOWERCMD_CMD_FIELD.type = 14
TOWERLAYERSYNCTOWERCMD_CMD_FIELD.cpp_type = 8
TOWERLAYERSYNCTOWERCMD_PARAM_FIELD.name = "param"
TOWERLAYERSYNCTOWERCMD_PARAM_FIELD.full_name = ".Cmd.TowerLayerSyncTowerCmd.param"
TOWERLAYERSYNCTOWERCMD_PARAM_FIELD.number = 2
TOWERLAYERSYNCTOWERCMD_PARAM_FIELD.index = 1
TOWERLAYERSYNCTOWERCMD_PARAM_FIELD.label = 1
TOWERLAYERSYNCTOWERCMD_PARAM_FIELD.has_default_value = true
TOWERLAYERSYNCTOWERCMD_PARAM_FIELD.default_value = 8
TOWERLAYERSYNCTOWERCMD_PARAM_FIELD.enum_type = TOWERPARAM
TOWERLAYERSYNCTOWERCMD_PARAM_FIELD.type = 14
TOWERLAYERSYNCTOWERCMD_PARAM_FIELD.cpp_type = 8
TOWERLAYERSYNCTOWERCMD_LAYER_FIELD.name = "layer"
TOWERLAYERSYNCTOWERCMD_LAYER_FIELD.full_name = ".Cmd.TowerLayerSyncTowerCmd.layer"
TOWERLAYERSYNCTOWERCMD_LAYER_FIELD.number = 3
TOWERLAYERSYNCTOWERCMD_LAYER_FIELD.index = 2
TOWERLAYERSYNCTOWERCMD_LAYER_FIELD.label = 1
TOWERLAYERSYNCTOWERCMD_LAYER_FIELD.has_default_value = true
TOWERLAYERSYNCTOWERCMD_LAYER_FIELD.default_value = 0
TOWERLAYERSYNCTOWERCMD_LAYER_FIELD.type = 13
TOWERLAYERSYNCTOWERCMD_LAYER_FIELD.cpp_type = 3
TOWERLAYERSYNCTOWERCMD.name = "TowerLayerSyncTowerCmd"
TOWERLAYERSYNCTOWERCMD.full_name = ".Cmd.TowerLayerSyncTowerCmd"
TOWERLAYERSYNCTOWERCMD.nested_types = {}
TOWERLAYERSYNCTOWERCMD.enum_types = {}
TOWERLAYERSYNCTOWERCMD.fields = {
  TOWERLAYERSYNCTOWERCMD_CMD_FIELD,
  TOWERLAYERSYNCTOWERCMD_PARAM_FIELD,
  TOWERLAYERSYNCTOWERCMD_LAYER_FIELD
}
TOWERLAYERSYNCTOWERCMD.is_extendable = false
TOWERLAYERSYNCTOWERCMD.extensions = {}
TOWERINFOCMD_CMD_FIELD.name = "cmd"
TOWERINFOCMD_CMD_FIELD.full_name = ".Cmd.TowerInfoCmd.cmd"
TOWERINFOCMD_CMD_FIELD.number = 1
TOWERINFOCMD_CMD_FIELD.index = 0
TOWERINFOCMD_CMD_FIELD.label = 1
TOWERINFOCMD_CMD_FIELD.has_default_value = true
TOWERINFOCMD_CMD_FIELD.default_value = 20
TOWERINFOCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
TOWERINFOCMD_CMD_FIELD.type = 14
TOWERINFOCMD_CMD_FIELD.cpp_type = 8
TOWERINFOCMD_PARAM_FIELD.name = "param"
TOWERINFOCMD_PARAM_FIELD.full_name = ".Cmd.TowerInfoCmd.param"
TOWERINFOCMD_PARAM_FIELD.number = 2
TOWERINFOCMD_PARAM_FIELD.index = 1
TOWERINFOCMD_PARAM_FIELD.label = 1
TOWERINFOCMD_PARAM_FIELD.has_default_value = true
TOWERINFOCMD_PARAM_FIELD.default_value = 10
TOWERINFOCMD_PARAM_FIELD.enum_type = TOWERPARAM
TOWERINFOCMD_PARAM_FIELD.type = 14
TOWERINFOCMD_PARAM_FIELD.cpp_type = 8
TOWERINFOCMD_MAXLAYER_FIELD.name = "maxlayer"
TOWERINFOCMD_MAXLAYER_FIELD.full_name = ".Cmd.TowerInfoCmd.maxlayer"
TOWERINFOCMD_MAXLAYER_FIELD.number = 3
TOWERINFOCMD_MAXLAYER_FIELD.index = 2
TOWERINFOCMD_MAXLAYER_FIELD.label = 1
TOWERINFOCMD_MAXLAYER_FIELD.has_default_value = true
TOWERINFOCMD_MAXLAYER_FIELD.default_value = 0
TOWERINFOCMD_MAXLAYER_FIELD.type = 13
TOWERINFOCMD_MAXLAYER_FIELD.cpp_type = 3
TOWERINFOCMD_REFRESHTIME_FIELD.name = "refreshtime"
TOWERINFOCMD_REFRESHTIME_FIELD.full_name = ".Cmd.TowerInfoCmd.refreshtime"
TOWERINFOCMD_REFRESHTIME_FIELD.number = 4
TOWERINFOCMD_REFRESHTIME_FIELD.index = 3
TOWERINFOCMD_REFRESHTIME_FIELD.label = 1
TOWERINFOCMD_REFRESHTIME_FIELD.has_default_value = true
TOWERINFOCMD_REFRESHTIME_FIELD.default_value = 0
TOWERINFOCMD_REFRESHTIME_FIELD.type = 13
TOWERINFOCMD_REFRESHTIME_FIELD.cpp_type = 3
TOWERINFOCMD.name = "TowerInfoCmd"
TOWERINFOCMD.full_name = ".Cmd.TowerInfoCmd"
TOWERINFOCMD.nested_types = {}
TOWERINFOCMD.enum_types = {}
TOWERINFOCMD.fields = {
  TOWERINFOCMD_CMD_FIELD,
  TOWERINFOCMD_PARAM_FIELD,
  TOWERINFOCMD_MAXLAYER_FIELD,
  TOWERINFOCMD_REFRESHTIME_FIELD
}
TOWERINFOCMD.is_extendable = false
TOWERINFOCMD.extensions = {}
NEWEVERLAYERTOWERCMD_CMD_FIELD.name = "cmd"
NEWEVERLAYERTOWERCMD_CMD_FIELD.full_name = ".Cmd.NewEverLayerTowerCmd.cmd"
NEWEVERLAYERTOWERCMD_CMD_FIELD.number = 1
NEWEVERLAYERTOWERCMD_CMD_FIELD.index = 0
NEWEVERLAYERTOWERCMD_CMD_FIELD.label = 1
NEWEVERLAYERTOWERCMD_CMD_FIELD.has_default_value = true
NEWEVERLAYERTOWERCMD_CMD_FIELD.default_value = 20
NEWEVERLAYERTOWERCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
NEWEVERLAYERTOWERCMD_CMD_FIELD.type = 14
NEWEVERLAYERTOWERCMD_CMD_FIELD.cpp_type = 8
NEWEVERLAYERTOWERCMD_PARAM_FIELD.name = "param"
NEWEVERLAYERTOWERCMD_PARAM_FIELD.full_name = ".Cmd.NewEverLayerTowerCmd.param"
NEWEVERLAYERTOWERCMD_PARAM_FIELD.number = 2
NEWEVERLAYERTOWERCMD_PARAM_FIELD.index = 1
NEWEVERLAYERTOWERCMD_PARAM_FIELD.label = 1
NEWEVERLAYERTOWERCMD_PARAM_FIELD.has_default_value = true
NEWEVERLAYERTOWERCMD_PARAM_FIELD.default_value = 9
NEWEVERLAYERTOWERCMD_PARAM_FIELD.enum_type = TOWERPARAM
NEWEVERLAYERTOWERCMD_PARAM_FIELD.type = 14
NEWEVERLAYERTOWERCMD_PARAM_FIELD.cpp_type = 8
NEWEVERLAYERTOWERCMD_LAYERS_FIELD.name = "layers"
NEWEVERLAYERTOWERCMD_LAYERS_FIELD.full_name = ".Cmd.NewEverLayerTowerCmd.layers"
NEWEVERLAYERTOWERCMD_LAYERS_FIELD.number = 3
NEWEVERLAYERTOWERCMD_LAYERS_FIELD.index = 2
NEWEVERLAYERTOWERCMD_LAYERS_FIELD.label = 3
NEWEVERLAYERTOWERCMD_LAYERS_FIELD.has_default_value = false
NEWEVERLAYERTOWERCMD_LAYERS_FIELD.default_value = {}
NEWEVERLAYERTOWERCMD_LAYERS_FIELD.message_type = USERTOWERLAYER
NEWEVERLAYERTOWERCMD_LAYERS_FIELD.type = 11
NEWEVERLAYERTOWERCMD_LAYERS_FIELD.cpp_type = 10
NEWEVERLAYERTOWERCMD.name = "NewEverLayerTowerCmd"
NEWEVERLAYERTOWERCMD.full_name = ".Cmd.NewEverLayerTowerCmd"
NEWEVERLAYERTOWERCMD.nested_types = {}
NEWEVERLAYERTOWERCMD.enum_types = {}
NEWEVERLAYERTOWERCMD.fields = {
  NEWEVERLAYERTOWERCMD_CMD_FIELD,
  NEWEVERLAYERTOWERCMD_PARAM_FIELD,
  NEWEVERLAYERTOWERCMD_LAYERS_FIELD
}
NEWEVERLAYERTOWERCMD.is_extendable = false
NEWEVERLAYERTOWERCMD.extensions = {}
ETOWERPARAM_ENTERTOWER = 5
ETOWERPARAM_INVITE = 3
ETOWERPARAM_LAYER_SYNC = 8
ETOWERPARAM_NEW_EVERLAYER = 9
ETOWERPARAM_REPLY = 4
ETOWERPARAM_TEAMTOWERINFO = 1
ETOWERPARAM_TEAMTOWERSUMMARY = 2
ETOWERPARAM_TOWERINFO = 10
ETOWERPARAM_USERTOWERINFO = 7
ETOWERREPLY_AGREE = 1
ETOWERREPLY_DISAGREE = 2
EnterTower = protobuf.Message(ENTERTOWER)
NewEverLayerTowerCmd = protobuf.Message(NEWEVERLAYERTOWERCMD)
TeamTowerInfoCmd = protobuf.Message(TEAMTOWERINFOCMD)
TeamTowerInviteCmd = protobuf.Message(TEAMTOWERINVITECMD)
TeamTowerReplyCmd = protobuf.Message(TEAMTOWERREPLYCMD)
TeamTowerSummary = protobuf.Message(TEAMTOWERSUMMARY)
TeamTowerSummaryCmd = protobuf.Message(TEAMTOWERSUMMARYCMD)
TowerInfoCmd = protobuf.Message(TOWERINFOCMD)
TowerLayerSyncTowerCmd = protobuf.Message(TOWERLAYERSYNCTOWERCMD)
UserTowerInfo = protobuf.Message(USERTOWERINFO)
UserTowerInfoCmd = protobuf.Message(USERTOWERINFOCMD)
UserTowerLayer = protobuf.Message(USERTOWERLAYER)
