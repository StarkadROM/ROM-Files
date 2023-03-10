local protobuf = protobuf
autoImport("xCmd_pb")
local xCmd_pb = xCmd_pb
module("SceneAugury_pb")
AUGURYPARAM = protobuf.EnumDescriptor()
AUGURYPARAM_AUGURYPARAM_INVITE_ENUM = protobuf.EnumValueDescriptor()
AUGURYPARAM_AUGURYPARAM_INVITE_REPLY_ENUM = protobuf.EnumValueDescriptor()
AUGURYPARAM_AUGURYPARAM_CHAT_ENUM = protobuf.EnumValueDescriptor()
AUGURYPARAM_AUGURYPARAM_TITLE_ENUM = protobuf.EnumValueDescriptor()
AUGURYPARAM_AUGURYPARAM_ANSWER_ENUM = protobuf.EnumValueDescriptor()
AUGURYPARAM_AUGURYPARAM_QUIT_ENUM = protobuf.EnumValueDescriptor()
AUGURYPARAM_AUGURYPARAM_ASTROLOGY_DRAW_CARD_ENUM = protobuf.EnumValueDescriptor()
AUGURYPARAM_AUGURYPARAM_ASTROLOGY_INFO_ENUM = protobuf.EnumValueDescriptor()
EAUGURYTYPE = protobuf.EnumDescriptor()
EAUGURYTYPE_EAUGURYTYPE_LOVE_SEASON_ENUM = protobuf.EnumValueDescriptor()
EAUGURYTYPE_EAUGURYTYPE_STAR_GUIDE_ENUM = protobuf.EnumValueDescriptor()
EAUGURYTYPE_EAUGURYTYPE_ADVENTURE_ENUM = protobuf.EnumValueDescriptor()
EAUGURYTYPE_EAUGURYTYPE_VALENTINE_ENUM = protobuf.EnumValueDescriptor()
EAUGURYTYPE_EAUGURYTYPE_ACTIVITY_ENUM = protobuf.EnumValueDescriptor()
EASTROLOGYTYPE = protobuf.EnumDescriptor()
EASTROLOGYTYPE_EASTROLOGYTYPE_CONSTELLATION_ENUM = protobuf.EnumValueDescriptor()
EASTROLOGYTYPE_EASTROLOGYTYPE_ACTIVITY_ENUM = protobuf.EnumValueDescriptor()
EREPLYTYPE = protobuf.EnumDescriptor()
EREPLYTYPE_EREPLYTYPE_AGREE_ENUM = protobuf.EnumValueDescriptor()
EREPLYTYPE_EREPLYTYPE_REFUSE_ENUM = protobuf.EnumValueDescriptor()
AUGURYINVITE = protobuf.Descriptor()
AUGURYINVITE_CMD_FIELD = protobuf.FieldDescriptor()
AUGURYINVITE_PARAM_FIELD = protobuf.FieldDescriptor()
AUGURYINVITE_INVITERID_FIELD = protobuf.FieldDescriptor()
AUGURYINVITE_INVITERNAME_FIELD = protobuf.FieldDescriptor()
AUGURYINVITE_NPCGUID_FIELD = protobuf.FieldDescriptor()
AUGURYINVITE_TYPE_FIELD = protobuf.FieldDescriptor()
AUGURYINVITE_ISEXTRA_FIELD = protobuf.FieldDescriptor()
AUGURYINVITEREPLY = protobuf.Descriptor()
AUGURYINVITEREPLY_CMD_FIELD = protobuf.FieldDescriptor()
AUGURYINVITEREPLY_PARAM_FIELD = protobuf.FieldDescriptor()
AUGURYINVITEREPLY_TYPE_FIELD = protobuf.FieldDescriptor()
AUGURYINVITEREPLY_INVITERID_FIELD = protobuf.FieldDescriptor()
AUGURYINVITEREPLY_NPCGUID_FIELD = protobuf.FieldDescriptor()
AUGURYINVITEREPLY_AUGURYTYPE_FIELD = protobuf.FieldDescriptor()
AUGURYINVITEREPLY_ISEXTRA_FIELD = protobuf.FieldDescriptor()
AUGURYCHAT = protobuf.Descriptor()
AUGURYCHAT_CMD_FIELD = protobuf.FieldDescriptor()
AUGURYCHAT_PARAM_FIELD = protobuf.FieldDescriptor()
AUGURYCHAT_CONTENT_FIELD = protobuf.FieldDescriptor()
AUGURYCHAT_SENDER_FIELD = protobuf.FieldDescriptor()
AUGURYTITLE = protobuf.Descriptor()
AUGURYTITLE_CMD_FIELD = protobuf.FieldDescriptor()
AUGURYTITLE_PARAM_FIELD = protobuf.FieldDescriptor()
AUGURYTITLE_TITLEID_FIELD = protobuf.FieldDescriptor()
AUGURYTITLE_TYPE_FIELD = protobuf.FieldDescriptor()
AUGURYTITLE_SUBTABLEID_FIELD = protobuf.FieldDescriptor()
AUGURYANSWER = protobuf.Descriptor()
AUGURYANSWER_CMD_FIELD = protobuf.FieldDescriptor()
AUGURYANSWER_PARAM_FIELD = protobuf.FieldDescriptor()
AUGURYANSWER_TITLEID_FIELD = protobuf.FieldDescriptor()
AUGURYANSWER_ANSWER_FIELD = protobuf.FieldDescriptor()
AUGURYANSWER_ANSWERID_FIELD = protobuf.FieldDescriptor()
AUGURYQUIT = protobuf.Descriptor()
AUGURYQUIT_CMD_FIELD = protobuf.FieldDescriptor()
AUGURYQUIT_PARAM_FIELD = protobuf.FieldDescriptor()
AUGURYASTROLOGYDRAWCARD = protobuf.Descriptor()
AUGURYASTROLOGYDRAWCARD_CMD_FIELD = protobuf.FieldDescriptor()
AUGURYASTROLOGYDRAWCARD_PARAM_FIELD = protobuf.FieldDescriptor()
AUGURYASTROLOGYDRAWCARD_TYPE_FIELD = protobuf.FieldDescriptor()
AUGURYASTROLOGYDRAWCARD_GROUP_FIELD = protobuf.FieldDescriptor()
AUGURYASTROLOGYINFO = protobuf.Descriptor()
AUGURYASTROLOGYINFO_CMD_FIELD = protobuf.FieldDescriptor()
AUGURYASTROLOGYINFO_PARAM_FIELD = protobuf.FieldDescriptor()
AUGURYASTROLOGYINFO_ID_FIELD = protobuf.FieldDescriptor()
AUGURYASTROLOGYINFO_BUFFID_FIELD = protobuf.FieldDescriptor()
AUGURYPARAM_AUGURYPARAM_INVITE_ENUM.name = "AUGURYPARAM_INVITE"
AUGURYPARAM_AUGURYPARAM_INVITE_ENUM.index = 0
AUGURYPARAM_AUGURYPARAM_INVITE_ENUM.number = 1
AUGURYPARAM_AUGURYPARAM_INVITE_REPLY_ENUM.name = "AUGURYPARAM_INVITE_REPLY"
AUGURYPARAM_AUGURYPARAM_INVITE_REPLY_ENUM.index = 1
AUGURYPARAM_AUGURYPARAM_INVITE_REPLY_ENUM.number = 2
AUGURYPARAM_AUGURYPARAM_CHAT_ENUM.name = "AUGURYPARAM_CHAT"
AUGURYPARAM_AUGURYPARAM_CHAT_ENUM.index = 2
AUGURYPARAM_AUGURYPARAM_CHAT_ENUM.number = 3
AUGURYPARAM_AUGURYPARAM_TITLE_ENUM.name = "AUGURYPARAM_TITLE"
AUGURYPARAM_AUGURYPARAM_TITLE_ENUM.index = 3
AUGURYPARAM_AUGURYPARAM_TITLE_ENUM.number = 4
AUGURYPARAM_AUGURYPARAM_ANSWER_ENUM.name = "AUGURYPARAM_ANSWER"
AUGURYPARAM_AUGURYPARAM_ANSWER_ENUM.index = 4
AUGURYPARAM_AUGURYPARAM_ANSWER_ENUM.number = 5
AUGURYPARAM_AUGURYPARAM_QUIT_ENUM.name = "AUGURYPARAM_QUIT"
AUGURYPARAM_AUGURYPARAM_QUIT_ENUM.index = 5
AUGURYPARAM_AUGURYPARAM_QUIT_ENUM.number = 6
AUGURYPARAM_AUGURYPARAM_ASTROLOGY_DRAW_CARD_ENUM.name = "AUGURYPARAM_ASTROLOGY_DRAW_CARD"
AUGURYPARAM_AUGURYPARAM_ASTROLOGY_DRAW_CARD_ENUM.index = 6
AUGURYPARAM_AUGURYPARAM_ASTROLOGY_DRAW_CARD_ENUM.number = 7
AUGURYPARAM_AUGURYPARAM_ASTROLOGY_INFO_ENUM.name = "AUGURYPARAM_ASTROLOGY_INFO"
AUGURYPARAM_AUGURYPARAM_ASTROLOGY_INFO_ENUM.index = 7
AUGURYPARAM_AUGURYPARAM_ASTROLOGY_INFO_ENUM.number = 8
AUGURYPARAM.name = "AuguryParam"
AUGURYPARAM.full_name = ".Cmd.AuguryParam"
AUGURYPARAM.values = {
  AUGURYPARAM_AUGURYPARAM_INVITE_ENUM,
  AUGURYPARAM_AUGURYPARAM_INVITE_REPLY_ENUM,
  AUGURYPARAM_AUGURYPARAM_CHAT_ENUM,
  AUGURYPARAM_AUGURYPARAM_TITLE_ENUM,
  AUGURYPARAM_AUGURYPARAM_ANSWER_ENUM,
  AUGURYPARAM_AUGURYPARAM_QUIT_ENUM,
  AUGURYPARAM_AUGURYPARAM_ASTROLOGY_DRAW_CARD_ENUM,
  AUGURYPARAM_AUGURYPARAM_ASTROLOGY_INFO_ENUM
}
EAUGURYTYPE_EAUGURYTYPE_LOVE_SEASON_ENUM.name = "EAUGURYTYPE_LOVE_SEASON"
EAUGURYTYPE_EAUGURYTYPE_LOVE_SEASON_ENUM.index = 0
EAUGURYTYPE_EAUGURYTYPE_LOVE_SEASON_ENUM.number = 1
EAUGURYTYPE_EAUGURYTYPE_STAR_GUIDE_ENUM.name = "EAUGURYTYPE_STAR_GUIDE"
EAUGURYTYPE_EAUGURYTYPE_STAR_GUIDE_ENUM.index = 1
EAUGURYTYPE_EAUGURYTYPE_STAR_GUIDE_ENUM.number = 2
EAUGURYTYPE_EAUGURYTYPE_ADVENTURE_ENUM.name = "EAUGURYTYPE_ADVENTURE"
EAUGURYTYPE_EAUGURYTYPE_ADVENTURE_ENUM.index = 2
EAUGURYTYPE_EAUGURYTYPE_ADVENTURE_ENUM.number = 3
EAUGURYTYPE_EAUGURYTYPE_VALENTINE_ENUM.name = "EAUGURYTYPE_VALENTINE"
EAUGURYTYPE_EAUGURYTYPE_VALENTINE_ENUM.index = 3
EAUGURYTYPE_EAUGURYTYPE_VALENTINE_ENUM.number = 4
EAUGURYTYPE_EAUGURYTYPE_ACTIVITY_ENUM.name = "EAUGURYTYPE_ACTIVITY"
EAUGURYTYPE_EAUGURYTYPE_ACTIVITY_ENUM.index = 4
EAUGURYTYPE_EAUGURYTYPE_ACTIVITY_ENUM.number = 5
EAUGURYTYPE.name = "EAuguryType"
EAUGURYTYPE.full_name = ".Cmd.EAuguryType"
EAUGURYTYPE.values = {
  EAUGURYTYPE_EAUGURYTYPE_LOVE_SEASON_ENUM,
  EAUGURYTYPE_EAUGURYTYPE_STAR_GUIDE_ENUM,
  EAUGURYTYPE_EAUGURYTYPE_ADVENTURE_ENUM,
  EAUGURYTYPE_EAUGURYTYPE_VALENTINE_ENUM,
  EAUGURYTYPE_EAUGURYTYPE_ACTIVITY_ENUM
}
EASTROLOGYTYPE_EASTROLOGYTYPE_CONSTELLATION_ENUM.name = "EASTROLOGYTYPE_CONSTELLATION"
EASTROLOGYTYPE_EASTROLOGYTYPE_CONSTELLATION_ENUM.index = 0
EASTROLOGYTYPE_EASTROLOGYTYPE_CONSTELLATION_ENUM.number = 1
EASTROLOGYTYPE_EASTROLOGYTYPE_ACTIVITY_ENUM.name = "EASTROLOGYTYPE_ACTIVITY"
EASTROLOGYTYPE_EASTROLOGYTYPE_ACTIVITY_ENUM.index = 1
EASTROLOGYTYPE_EASTROLOGYTYPE_ACTIVITY_ENUM.number = 2
EASTROLOGYTYPE.name = "EAstrologyType"
EASTROLOGYTYPE.full_name = ".Cmd.EAstrologyType"
EASTROLOGYTYPE.values = {
  EASTROLOGYTYPE_EASTROLOGYTYPE_CONSTELLATION_ENUM,
  EASTROLOGYTYPE_EASTROLOGYTYPE_ACTIVITY_ENUM
}
EREPLYTYPE_EREPLYTYPE_AGREE_ENUM.name = "EReplyType_Agree"
EREPLYTYPE_EREPLYTYPE_AGREE_ENUM.index = 0
EREPLYTYPE_EREPLYTYPE_AGREE_ENUM.number = 1
EREPLYTYPE_EREPLYTYPE_REFUSE_ENUM.name = "EReplyType_Refuse"
EREPLYTYPE_EREPLYTYPE_REFUSE_ENUM.index = 1
EREPLYTYPE_EREPLYTYPE_REFUSE_ENUM.number = 2
EREPLYTYPE.name = "EReplyType"
EREPLYTYPE.full_name = ".Cmd.EReplyType"
EREPLYTYPE.values = {
  EREPLYTYPE_EREPLYTYPE_AGREE_ENUM,
  EREPLYTYPE_EREPLYTYPE_REFUSE_ENUM
}
AUGURYINVITE_CMD_FIELD.name = "cmd"
AUGURYINVITE_CMD_FIELD.full_name = ".Cmd.AuguryInvite.cmd"
AUGURYINVITE_CMD_FIELD.number = 1
AUGURYINVITE_CMD_FIELD.index = 0
AUGURYINVITE_CMD_FIELD.label = 1
AUGURYINVITE_CMD_FIELD.has_default_value = true
AUGURYINVITE_CMD_FIELD.default_value = 27
AUGURYINVITE_CMD_FIELD.enum_type = XCMD_PB_COMMAND
AUGURYINVITE_CMD_FIELD.type = 14
AUGURYINVITE_CMD_FIELD.cpp_type = 8
AUGURYINVITE_PARAM_FIELD.name = "param"
AUGURYINVITE_PARAM_FIELD.full_name = ".Cmd.AuguryInvite.param"
AUGURYINVITE_PARAM_FIELD.number = 2
AUGURYINVITE_PARAM_FIELD.index = 1
AUGURYINVITE_PARAM_FIELD.label = 1
AUGURYINVITE_PARAM_FIELD.has_default_value = true
AUGURYINVITE_PARAM_FIELD.default_value = 1
AUGURYINVITE_PARAM_FIELD.enum_type = AUGURYPARAM
AUGURYINVITE_PARAM_FIELD.type = 14
AUGURYINVITE_PARAM_FIELD.cpp_type = 8
AUGURYINVITE_INVITERID_FIELD.name = "inviterid"
AUGURYINVITE_INVITERID_FIELD.full_name = ".Cmd.AuguryInvite.inviterid"
AUGURYINVITE_INVITERID_FIELD.number = 3
AUGURYINVITE_INVITERID_FIELD.index = 2
AUGURYINVITE_INVITERID_FIELD.label = 1
AUGURYINVITE_INVITERID_FIELD.has_default_value = false
AUGURYINVITE_INVITERID_FIELD.default_value = 0
AUGURYINVITE_INVITERID_FIELD.type = 4
AUGURYINVITE_INVITERID_FIELD.cpp_type = 4
AUGURYINVITE_INVITERNAME_FIELD.name = "invitername"
AUGURYINVITE_INVITERNAME_FIELD.full_name = ".Cmd.AuguryInvite.invitername"
AUGURYINVITE_INVITERNAME_FIELD.number = 4
AUGURYINVITE_INVITERNAME_FIELD.index = 3
AUGURYINVITE_INVITERNAME_FIELD.label = 1
AUGURYINVITE_INVITERNAME_FIELD.has_default_value = false
AUGURYINVITE_INVITERNAME_FIELD.default_value = ""
AUGURYINVITE_INVITERNAME_FIELD.type = 9
AUGURYINVITE_INVITERNAME_FIELD.cpp_type = 9
AUGURYINVITE_NPCGUID_FIELD.name = "npcguid"
AUGURYINVITE_NPCGUID_FIELD.full_name = ".Cmd.AuguryInvite.npcguid"
AUGURYINVITE_NPCGUID_FIELD.number = 5
AUGURYINVITE_NPCGUID_FIELD.index = 4
AUGURYINVITE_NPCGUID_FIELD.label = 1
AUGURYINVITE_NPCGUID_FIELD.has_default_value = false
AUGURYINVITE_NPCGUID_FIELD.default_value = 0
AUGURYINVITE_NPCGUID_FIELD.type = 4
AUGURYINVITE_NPCGUID_FIELD.cpp_type = 4
AUGURYINVITE_TYPE_FIELD.name = "type"
AUGURYINVITE_TYPE_FIELD.full_name = ".Cmd.AuguryInvite.type"
AUGURYINVITE_TYPE_FIELD.number = 6
AUGURYINVITE_TYPE_FIELD.index = 5
AUGURYINVITE_TYPE_FIELD.label = 1
AUGURYINVITE_TYPE_FIELD.has_default_value = false
AUGURYINVITE_TYPE_FIELD.default_value = nil
AUGURYINVITE_TYPE_FIELD.enum_type = EAUGURYTYPE
AUGURYINVITE_TYPE_FIELD.type = 14
AUGURYINVITE_TYPE_FIELD.cpp_type = 8
AUGURYINVITE_ISEXTRA_FIELD.name = "isextra"
AUGURYINVITE_ISEXTRA_FIELD.full_name = ".Cmd.AuguryInvite.isextra"
AUGURYINVITE_ISEXTRA_FIELD.number = 7
AUGURYINVITE_ISEXTRA_FIELD.index = 6
AUGURYINVITE_ISEXTRA_FIELD.label = 1
AUGURYINVITE_ISEXTRA_FIELD.has_default_value = false
AUGURYINVITE_ISEXTRA_FIELD.default_value = false
AUGURYINVITE_ISEXTRA_FIELD.type = 8
AUGURYINVITE_ISEXTRA_FIELD.cpp_type = 7
AUGURYINVITE.name = "AuguryInvite"
AUGURYINVITE.full_name = ".Cmd.AuguryInvite"
AUGURYINVITE.nested_types = {}
AUGURYINVITE.enum_types = {}
AUGURYINVITE.fields = {
  AUGURYINVITE_CMD_FIELD,
  AUGURYINVITE_PARAM_FIELD,
  AUGURYINVITE_INVITERID_FIELD,
  AUGURYINVITE_INVITERNAME_FIELD,
  AUGURYINVITE_NPCGUID_FIELD,
  AUGURYINVITE_TYPE_FIELD,
  AUGURYINVITE_ISEXTRA_FIELD
}
AUGURYINVITE.is_extendable = false
AUGURYINVITE.extensions = {}
AUGURYINVITEREPLY_CMD_FIELD.name = "cmd"
AUGURYINVITEREPLY_CMD_FIELD.full_name = ".Cmd.AuguryInviteReply.cmd"
AUGURYINVITEREPLY_CMD_FIELD.number = 1
AUGURYINVITEREPLY_CMD_FIELD.index = 0
AUGURYINVITEREPLY_CMD_FIELD.label = 1
AUGURYINVITEREPLY_CMD_FIELD.has_default_value = true
AUGURYINVITEREPLY_CMD_FIELD.default_value = 27
AUGURYINVITEREPLY_CMD_FIELD.enum_type = XCMD_PB_COMMAND
AUGURYINVITEREPLY_CMD_FIELD.type = 14
AUGURYINVITEREPLY_CMD_FIELD.cpp_type = 8
AUGURYINVITEREPLY_PARAM_FIELD.name = "param"
AUGURYINVITEREPLY_PARAM_FIELD.full_name = ".Cmd.AuguryInviteReply.param"
AUGURYINVITEREPLY_PARAM_FIELD.number = 2
AUGURYINVITEREPLY_PARAM_FIELD.index = 1
AUGURYINVITEREPLY_PARAM_FIELD.label = 1
AUGURYINVITEREPLY_PARAM_FIELD.has_default_value = true
AUGURYINVITEREPLY_PARAM_FIELD.default_value = 2
AUGURYINVITEREPLY_PARAM_FIELD.enum_type = AUGURYPARAM
AUGURYINVITEREPLY_PARAM_FIELD.type = 14
AUGURYINVITEREPLY_PARAM_FIELD.cpp_type = 8
AUGURYINVITEREPLY_TYPE_FIELD.name = "type"
AUGURYINVITEREPLY_TYPE_FIELD.full_name = ".Cmd.AuguryInviteReply.type"
AUGURYINVITEREPLY_TYPE_FIELD.number = 3
AUGURYINVITEREPLY_TYPE_FIELD.index = 2
AUGURYINVITEREPLY_TYPE_FIELD.label = 1
AUGURYINVITEREPLY_TYPE_FIELD.has_default_value = true
AUGURYINVITEREPLY_TYPE_FIELD.default_value = 2
AUGURYINVITEREPLY_TYPE_FIELD.enum_type = EREPLYTYPE
AUGURYINVITEREPLY_TYPE_FIELD.type = 14
AUGURYINVITEREPLY_TYPE_FIELD.cpp_type = 8
AUGURYINVITEREPLY_INVITERID_FIELD.name = "inviterid"
AUGURYINVITEREPLY_INVITERID_FIELD.full_name = ".Cmd.AuguryInviteReply.inviterid"
AUGURYINVITEREPLY_INVITERID_FIELD.number = 4
AUGURYINVITEREPLY_INVITERID_FIELD.index = 3
AUGURYINVITEREPLY_INVITERID_FIELD.label = 1
AUGURYINVITEREPLY_INVITERID_FIELD.has_default_value = false
AUGURYINVITEREPLY_INVITERID_FIELD.default_value = 0
AUGURYINVITEREPLY_INVITERID_FIELD.type = 4
AUGURYINVITEREPLY_INVITERID_FIELD.cpp_type = 4
AUGURYINVITEREPLY_NPCGUID_FIELD.name = "npcguid"
AUGURYINVITEREPLY_NPCGUID_FIELD.full_name = ".Cmd.AuguryInviteReply.npcguid"
AUGURYINVITEREPLY_NPCGUID_FIELD.number = 5
AUGURYINVITEREPLY_NPCGUID_FIELD.index = 4
AUGURYINVITEREPLY_NPCGUID_FIELD.label = 1
AUGURYINVITEREPLY_NPCGUID_FIELD.has_default_value = false
AUGURYINVITEREPLY_NPCGUID_FIELD.default_value = 0
AUGURYINVITEREPLY_NPCGUID_FIELD.type = 4
AUGURYINVITEREPLY_NPCGUID_FIELD.cpp_type = 4
AUGURYINVITEREPLY_AUGURYTYPE_FIELD.name = "augurytype"
AUGURYINVITEREPLY_AUGURYTYPE_FIELD.full_name = ".Cmd.AuguryInviteReply.augurytype"
AUGURYINVITEREPLY_AUGURYTYPE_FIELD.number = 6
AUGURYINVITEREPLY_AUGURYTYPE_FIELD.index = 5
AUGURYINVITEREPLY_AUGURYTYPE_FIELD.label = 1
AUGURYINVITEREPLY_AUGURYTYPE_FIELD.has_default_value = false
AUGURYINVITEREPLY_AUGURYTYPE_FIELD.default_value = nil
AUGURYINVITEREPLY_AUGURYTYPE_FIELD.enum_type = EAUGURYTYPE
AUGURYINVITEREPLY_AUGURYTYPE_FIELD.type = 14
AUGURYINVITEREPLY_AUGURYTYPE_FIELD.cpp_type = 8
AUGURYINVITEREPLY_ISEXTRA_FIELD.name = "isextra"
AUGURYINVITEREPLY_ISEXTRA_FIELD.full_name = ".Cmd.AuguryInviteReply.isextra"
AUGURYINVITEREPLY_ISEXTRA_FIELD.number = 7
AUGURYINVITEREPLY_ISEXTRA_FIELD.index = 6
AUGURYINVITEREPLY_ISEXTRA_FIELD.label = 1
AUGURYINVITEREPLY_ISEXTRA_FIELD.has_default_value = false
AUGURYINVITEREPLY_ISEXTRA_FIELD.default_value = false
AUGURYINVITEREPLY_ISEXTRA_FIELD.type = 8
AUGURYINVITEREPLY_ISEXTRA_FIELD.cpp_type = 7
AUGURYINVITEREPLY.name = "AuguryInviteReply"
AUGURYINVITEREPLY.full_name = ".Cmd.AuguryInviteReply"
AUGURYINVITEREPLY.nested_types = {}
AUGURYINVITEREPLY.enum_types = {}
AUGURYINVITEREPLY.fields = {
  AUGURYINVITEREPLY_CMD_FIELD,
  AUGURYINVITEREPLY_PARAM_FIELD,
  AUGURYINVITEREPLY_TYPE_FIELD,
  AUGURYINVITEREPLY_INVITERID_FIELD,
  AUGURYINVITEREPLY_NPCGUID_FIELD,
  AUGURYINVITEREPLY_AUGURYTYPE_FIELD,
  AUGURYINVITEREPLY_ISEXTRA_FIELD
}
AUGURYINVITEREPLY.is_extendable = false
AUGURYINVITEREPLY.extensions = {}
AUGURYCHAT_CMD_FIELD.name = "cmd"
AUGURYCHAT_CMD_FIELD.full_name = ".Cmd.AuguryChat.cmd"
AUGURYCHAT_CMD_FIELD.number = 1
AUGURYCHAT_CMD_FIELD.index = 0
AUGURYCHAT_CMD_FIELD.label = 1
AUGURYCHAT_CMD_FIELD.has_default_value = true
AUGURYCHAT_CMD_FIELD.default_value = 27
AUGURYCHAT_CMD_FIELD.enum_type = XCMD_PB_COMMAND
AUGURYCHAT_CMD_FIELD.type = 14
AUGURYCHAT_CMD_FIELD.cpp_type = 8
AUGURYCHAT_PARAM_FIELD.name = "param"
AUGURYCHAT_PARAM_FIELD.full_name = ".Cmd.AuguryChat.param"
AUGURYCHAT_PARAM_FIELD.number = 2
AUGURYCHAT_PARAM_FIELD.index = 1
AUGURYCHAT_PARAM_FIELD.label = 1
AUGURYCHAT_PARAM_FIELD.has_default_value = true
AUGURYCHAT_PARAM_FIELD.default_value = 3
AUGURYCHAT_PARAM_FIELD.enum_type = AUGURYPARAM
AUGURYCHAT_PARAM_FIELD.type = 14
AUGURYCHAT_PARAM_FIELD.cpp_type = 8
AUGURYCHAT_CONTENT_FIELD.name = "content"
AUGURYCHAT_CONTENT_FIELD.full_name = ".Cmd.AuguryChat.content"
AUGURYCHAT_CONTENT_FIELD.number = 3
AUGURYCHAT_CONTENT_FIELD.index = 2
AUGURYCHAT_CONTENT_FIELD.label = 1
AUGURYCHAT_CONTENT_FIELD.has_default_value = false
AUGURYCHAT_CONTENT_FIELD.default_value = ""
AUGURYCHAT_CONTENT_FIELD.type = 9
AUGURYCHAT_CONTENT_FIELD.cpp_type = 9
AUGURYCHAT_SENDER_FIELD.name = "sender"
AUGURYCHAT_SENDER_FIELD.full_name = ".Cmd.AuguryChat.sender"
AUGURYCHAT_SENDER_FIELD.number = 4
AUGURYCHAT_SENDER_FIELD.index = 3
AUGURYCHAT_SENDER_FIELD.label = 1
AUGURYCHAT_SENDER_FIELD.has_default_value = false
AUGURYCHAT_SENDER_FIELD.default_value = ""
AUGURYCHAT_SENDER_FIELD.type = 9
AUGURYCHAT_SENDER_FIELD.cpp_type = 9
AUGURYCHAT.name = "AuguryChat"
AUGURYCHAT.full_name = ".Cmd.AuguryChat"
AUGURYCHAT.nested_types = {}
AUGURYCHAT.enum_types = {}
AUGURYCHAT.fields = {
  AUGURYCHAT_CMD_FIELD,
  AUGURYCHAT_PARAM_FIELD,
  AUGURYCHAT_CONTENT_FIELD,
  AUGURYCHAT_SENDER_FIELD
}
AUGURYCHAT.is_extendable = false
AUGURYCHAT.extensions = {}
AUGURYTITLE_CMD_FIELD.name = "cmd"
AUGURYTITLE_CMD_FIELD.full_name = ".Cmd.AuguryTitle.cmd"
AUGURYTITLE_CMD_FIELD.number = 1
AUGURYTITLE_CMD_FIELD.index = 0
AUGURYTITLE_CMD_FIELD.label = 1
AUGURYTITLE_CMD_FIELD.has_default_value = true
AUGURYTITLE_CMD_FIELD.default_value = 27
AUGURYTITLE_CMD_FIELD.enum_type = XCMD_PB_COMMAND
AUGURYTITLE_CMD_FIELD.type = 14
AUGURYTITLE_CMD_FIELD.cpp_type = 8
AUGURYTITLE_PARAM_FIELD.name = "param"
AUGURYTITLE_PARAM_FIELD.full_name = ".Cmd.AuguryTitle.param"
AUGURYTITLE_PARAM_FIELD.number = 2
AUGURYTITLE_PARAM_FIELD.index = 1
AUGURYTITLE_PARAM_FIELD.label = 1
AUGURYTITLE_PARAM_FIELD.has_default_value = true
AUGURYTITLE_PARAM_FIELD.default_value = 4
AUGURYTITLE_PARAM_FIELD.enum_type = AUGURYPARAM
AUGURYTITLE_PARAM_FIELD.type = 14
AUGURYTITLE_PARAM_FIELD.cpp_type = 8
AUGURYTITLE_TITLEID_FIELD.name = "titleid"
AUGURYTITLE_TITLEID_FIELD.full_name = ".Cmd.AuguryTitle.titleid"
AUGURYTITLE_TITLEID_FIELD.number = 3
AUGURYTITLE_TITLEID_FIELD.index = 2
AUGURYTITLE_TITLEID_FIELD.label = 1
AUGURYTITLE_TITLEID_FIELD.has_default_value = false
AUGURYTITLE_TITLEID_FIELD.default_value = 0
AUGURYTITLE_TITLEID_FIELD.type = 13
AUGURYTITLE_TITLEID_FIELD.cpp_type = 3
AUGURYTITLE_TYPE_FIELD.name = "type"
AUGURYTITLE_TYPE_FIELD.full_name = ".Cmd.AuguryTitle.type"
AUGURYTITLE_TYPE_FIELD.number = 4
AUGURYTITLE_TYPE_FIELD.index = 3
AUGURYTITLE_TYPE_FIELD.label = 1
AUGURYTITLE_TYPE_FIELD.has_default_value = false
AUGURYTITLE_TYPE_FIELD.default_value = nil
AUGURYTITLE_TYPE_FIELD.enum_type = EAUGURYTYPE
AUGURYTITLE_TYPE_FIELD.type = 14
AUGURYTITLE_TYPE_FIELD.cpp_type = 8
AUGURYTITLE_SUBTABLEID_FIELD.name = "subtableid"
AUGURYTITLE_SUBTABLEID_FIELD.full_name = ".Cmd.AuguryTitle.subtableid"
AUGURYTITLE_SUBTABLEID_FIELD.number = 5
AUGURYTITLE_SUBTABLEID_FIELD.index = 4
AUGURYTITLE_SUBTABLEID_FIELD.label = 1
AUGURYTITLE_SUBTABLEID_FIELD.has_default_value = false
AUGURYTITLE_SUBTABLEID_FIELD.default_value = 0
AUGURYTITLE_SUBTABLEID_FIELD.type = 13
AUGURYTITLE_SUBTABLEID_FIELD.cpp_type = 3
AUGURYTITLE.name = "AuguryTitle"
AUGURYTITLE.full_name = ".Cmd.AuguryTitle"
AUGURYTITLE.nested_types = {}
AUGURYTITLE.enum_types = {}
AUGURYTITLE.fields = {
  AUGURYTITLE_CMD_FIELD,
  AUGURYTITLE_PARAM_FIELD,
  AUGURYTITLE_TITLEID_FIELD,
  AUGURYTITLE_TYPE_FIELD,
  AUGURYTITLE_SUBTABLEID_FIELD
}
AUGURYTITLE.is_extendable = false
AUGURYTITLE.extensions = {}
AUGURYANSWER_CMD_FIELD.name = "cmd"
AUGURYANSWER_CMD_FIELD.full_name = ".Cmd.AuguryAnswer.cmd"
AUGURYANSWER_CMD_FIELD.number = 1
AUGURYANSWER_CMD_FIELD.index = 0
AUGURYANSWER_CMD_FIELD.label = 1
AUGURYANSWER_CMD_FIELD.has_default_value = true
AUGURYANSWER_CMD_FIELD.default_value = 27
AUGURYANSWER_CMD_FIELD.enum_type = XCMD_PB_COMMAND
AUGURYANSWER_CMD_FIELD.type = 14
AUGURYANSWER_CMD_FIELD.cpp_type = 8
AUGURYANSWER_PARAM_FIELD.name = "param"
AUGURYANSWER_PARAM_FIELD.full_name = ".Cmd.AuguryAnswer.param"
AUGURYANSWER_PARAM_FIELD.number = 2
AUGURYANSWER_PARAM_FIELD.index = 1
AUGURYANSWER_PARAM_FIELD.label = 1
AUGURYANSWER_PARAM_FIELD.has_default_value = true
AUGURYANSWER_PARAM_FIELD.default_value = 5
AUGURYANSWER_PARAM_FIELD.enum_type = AUGURYPARAM
AUGURYANSWER_PARAM_FIELD.type = 14
AUGURYANSWER_PARAM_FIELD.cpp_type = 8
AUGURYANSWER_TITLEID_FIELD.name = "titleid"
AUGURYANSWER_TITLEID_FIELD.full_name = ".Cmd.AuguryAnswer.titleid"
AUGURYANSWER_TITLEID_FIELD.number = 3
AUGURYANSWER_TITLEID_FIELD.index = 2
AUGURYANSWER_TITLEID_FIELD.label = 1
AUGURYANSWER_TITLEID_FIELD.has_default_value = false
AUGURYANSWER_TITLEID_FIELD.default_value = 0
AUGURYANSWER_TITLEID_FIELD.type = 13
AUGURYANSWER_TITLEID_FIELD.cpp_type = 3
AUGURYANSWER_ANSWER_FIELD.name = "answer"
AUGURYANSWER_ANSWER_FIELD.full_name = ".Cmd.AuguryAnswer.answer"
AUGURYANSWER_ANSWER_FIELD.number = 4
AUGURYANSWER_ANSWER_FIELD.index = 3
AUGURYANSWER_ANSWER_FIELD.label = 1
AUGURYANSWER_ANSWER_FIELD.has_default_value = false
AUGURYANSWER_ANSWER_FIELD.default_value = 0
AUGURYANSWER_ANSWER_FIELD.type = 13
AUGURYANSWER_ANSWER_FIELD.cpp_type = 3
AUGURYANSWER_ANSWERID_FIELD.name = "answerid"
AUGURYANSWER_ANSWERID_FIELD.full_name = ".Cmd.AuguryAnswer.answerid"
AUGURYANSWER_ANSWERID_FIELD.number = 5
AUGURYANSWER_ANSWERID_FIELD.index = 4
AUGURYANSWER_ANSWERID_FIELD.label = 1
AUGURYANSWER_ANSWERID_FIELD.has_default_value = false
AUGURYANSWER_ANSWERID_FIELD.default_value = 0
AUGURYANSWER_ANSWERID_FIELD.type = 4
AUGURYANSWER_ANSWERID_FIELD.cpp_type = 4
AUGURYANSWER.name = "AuguryAnswer"
AUGURYANSWER.full_name = ".Cmd.AuguryAnswer"
AUGURYANSWER.nested_types = {}
AUGURYANSWER.enum_types = {}
AUGURYANSWER.fields = {
  AUGURYANSWER_CMD_FIELD,
  AUGURYANSWER_PARAM_FIELD,
  AUGURYANSWER_TITLEID_FIELD,
  AUGURYANSWER_ANSWER_FIELD,
  AUGURYANSWER_ANSWERID_FIELD
}
AUGURYANSWER.is_extendable = false
AUGURYANSWER.extensions = {}
AUGURYQUIT_CMD_FIELD.name = "cmd"
AUGURYQUIT_CMD_FIELD.full_name = ".Cmd.AuguryQuit.cmd"
AUGURYQUIT_CMD_FIELD.number = 1
AUGURYQUIT_CMD_FIELD.index = 0
AUGURYQUIT_CMD_FIELD.label = 1
AUGURYQUIT_CMD_FIELD.has_default_value = true
AUGURYQUIT_CMD_FIELD.default_value = 27
AUGURYQUIT_CMD_FIELD.enum_type = XCMD_PB_COMMAND
AUGURYQUIT_CMD_FIELD.type = 14
AUGURYQUIT_CMD_FIELD.cpp_type = 8
AUGURYQUIT_PARAM_FIELD.name = "param"
AUGURYQUIT_PARAM_FIELD.full_name = ".Cmd.AuguryQuit.param"
AUGURYQUIT_PARAM_FIELD.number = 2
AUGURYQUIT_PARAM_FIELD.index = 1
AUGURYQUIT_PARAM_FIELD.label = 1
AUGURYQUIT_PARAM_FIELD.has_default_value = true
AUGURYQUIT_PARAM_FIELD.default_value = 6
AUGURYQUIT_PARAM_FIELD.enum_type = AUGURYPARAM
AUGURYQUIT_PARAM_FIELD.type = 14
AUGURYQUIT_PARAM_FIELD.cpp_type = 8
AUGURYQUIT.name = "AuguryQuit"
AUGURYQUIT.full_name = ".Cmd.AuguryQuit"
AUGURYQUIT.nested_types = {}
AUGURYQUIT.enum_types = {}
AUGURYQUIT.fields = {
  AUGURYQUIT_CMD_FIELD,
  AUGURYQUIT_PARAM_FIELD
}
AUGURYQUIT.is_extendable = false
AUGURYQUIT.extensions = {}
AUGURYASTROLOGYDRAWCARD_CMD_FIELD.name = "cmd"
AUGURYASTROLOGYDRAWCARD_CMD_FIELD.full_name = ".Cmd.AuguryAstrologyDrawCard.cmd"
AUGURYASTROLOGYDRAWCARD_CMD_FIELD.number = 1
AUGURYASTROLOGYDRAWCARD_CMD_FIELD.index = 0
AUGURYASTROLOGYDRAWCARD_CMD_FIELD.label = 1
AUGURYASTROLOGYDRAWCARD_CMD_FIELD.has_default_value = true
AUGURYASTROLOGYDRAWCARD_CMD_FIELD.default_value = 27
AUGURYASTROLOGYDRAWCARD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
AUGURYASTROLOGYDRAWCARD_CMD_FIELD.type = 14
AUGURYASTROLOGYDRAWCARD_CMD_FIELD.cpp_type = 8
AUGURYASTROLOGYDRAWCARD_PARAM_FIELD.name = "param"
AUGURYASTROLOGYDRAWCARD_PARAM_FIELD.full_name = ".Cmd.AuguryAstrologyDrawCard.param"
AUGURYASTROLOGYDRAWCARD_PARAM_FIELD.number = 2
AUGURYASTROLOGYDRAWCARD_PARAM_FIELD.index = 1
AUGURYASTROLOGYDRAWCARD_PARAM_FIELD.label = 1
AUGURYASTROLOGYDRAWCARD_PARAM_FIELD.has_default_value = true
AUGURYASTROLOGYDRAWCARD_PARAM_FIELD.default_value = 7
AUGURYASTROLOGYDRAWCARD_PARAM_FIELD.enum_type = AUGURYPARAM
AUGURYASTROLOGYDRAWCARD_PARAM_FIELD.type = 14
AUGURYASTROLOGYDRAWCARD_PARAM_FIELD.cpp_type = 8
AUGURYASTROLOGYDRAWCARD_TYPE_FIELD.name = "type"
AUGURYASTROLOGYDRAWCARD_TYPE_FIELD.full_name = ".Cmd.AuguryAstrologyDrawCard.type"
AUGURYASTROLOGYDRAWCARD_TYPE_FIELD.number = 3
AUGURYASTROLOGYDRAWCARD_TYPE_FIELD.index = 2
AUGURYASTROLOGYDRAWCARD_TYPE_FIELD.label = 1
AUGURYASTROLOGYDRAWCARD_TYPE_FIELD.has_default_value = true
AUGURYASTROLOGYDRAWCARD_TYPE_FIELD.default_value = 1
AUGURYASTROLOGYDRAWCARD_TYPE_FIELD.enum_type = EASTROLOGYTYPE
AUGURYASTROLOGYDRAWCARD_TYPE_FIELD.type = 14
AUGURYASTROLOGYDRAWCARD_TYPE_FIELD.cpp_type = 8
AUGURYASTROLOGYDRAWCARD_GROUP_FIELD.name = "group"
AUGURYASTROLOGYDRAWCARD_GROUP_FIELD.full_name = ".Cmd.AuguryAstrologyDrawCard.group"
AUGURYASTROLOGYDRAWCARD_GROUP_FIELD.number = 4
AUGURYASTROLOGYDRAWCARD_GROUP_FIELD.index = 3
AUGURYASTROLOGYDRAWCARD_GROUP_FIELD.label = 1
AUGURYASTROLOGYDRAWCARD_GROUP_FIELD.has_default_value = true
AUGURYASTROLOGYDRAWCARD_GROUP_FIELD.default_value = 0
AUGURYASTROLOGYDRAWCARD_GROUP_FIELD.type = 13
AUGURYASTROLOGYDRAWCARD_GROUP_FIELD.cpp_type = 3
AUGURYASTROLOGYDRAWCARD.name = "AuguryAstrologyDrawCard"
AUGURYASTROLOGYDRAWCARD.full_name = ".Cmd.AuguryAstrologyDrawCard"
AUGURYASTROLOGYDRAWCARD.nested_types = {}
AUGURYASTROLOGYDRAWCARD.enum_types = {}
AUGURYASTROLOGYDRAWCARD.fields = {
  AUGURYASTROLOGYDRAWCARD_CMD_FIELD,
  AUGURYASTROLOGYDRAWCARD_PARAM_FIELD,
  AUGURYASTROLOGYDRAWCARD_TYPE_FIELD,
  AUGURYASTROLOGYDRAWCARD_GROUP_FIELD
}
AUGURYASTROLOGYDRAWCARD.is_extendable = false
AUGURYASTROLOGYDRAWCARD.extensions = {}
AUGURYASTROLOGYINFO_CMD_FIELD.name = "cmd"
AUGURYASTROLOGYINFO_CMD_FIELD.full_name = ".Cmd.AuguryAstrologyInfo.cmd"
AUGURYASTROLOGYINFO_CMD_FIELD.number = 1
AUGURYASTROLOGYINFO_CMD_FIELD.index = 0
AUGURYASTROLOGYINFO_CMD_FIELD.label = 1
AUGURYASTROLOGYINFO_CMD_FIELD.has_default_value = true
AUGURYASTROLOGYINFO_CMD_FIELD.default_value = 27
AUGURYASTROLOGYINFO_CMD_FIELD.enum_type = XCMD_PB_COMMAND
AUGURYASTROLOGYINFO_CMD_FIELD.type = 14
AUGURYASTROLOGYINFO_CMD_FIELD.cpp_type = 8
AUGURYASTROLOGYINFO_PARAM_FIELD.name = "param"
AUGURYASTROLOGYINFO_PARAM_FIELD.full_name = ".Cmd.AuguryAstrologyInfo.param"
AUGURYASTROLOGYINFO_PARAM_FIELD.number = 2
AUGURYASTROLOGYINFO_PARAM_FIELD.index = 1
AUGURYASTROLOGYINFO_PARAM_FIELD.label = 1
AUGURYASTROLOGYINFO_PARAM_FIELD.has_default_value = true
AUGURYASTROLOGYINFO_PARAM_FIELD.default_value = 8
AUGURYASTROLOGYINFO_PARAM_FIELD.enum_type = AUGURYPARAM
AUGURYASTROLOGYINFO_PARAM_FIELD.type = 14
AUGURYASTROLOGYINFO_PARAM_FIELD.cpp_type = 8
AUGURYASTROLOGYINFO_ID_FIELD.name = "id"
AUGURYASTROLOGYINFO_ID_FIELD.full_name = ".Cmd.AuguryAstrologyInfo.id"
AUGURYASTROLOGYINFO_ID_FIELD.number = 3
AUGURYASTROLOGYINFO_ID_FIELD.index = 2
AUGURYASTROLOGYINFO_ID_FIELD.label = 1
AUGURYASTROLOGYINFO_ID_FIELD.has_default_value = true
AUGURYASTROLOGYINFO_ID_FIELD.default_value = 0
AUGURYASTROLOGYINFO_ID_FIELD.type = 13
AUGURYASTROLOGYINFO_ID_FIELD.cpp_type = 3
AUGURYASTROLOGYINFO_BUFFID_FIELD.name = "buffid"
AUGURYASTROLOGYINFO_BUFFID_FIELD.full_name = ".Cmd.AuguryAstrologyInfo.buffid"
AUGURYASTROLOGYINFO_BUFFID_FIELD.number = 4
AUGURYASTROLOGYINFO_BUFFID_FIELD.index = 3
AUGURYASTROLOGYINFO_BUFFID_FIELD.label = 1
AUGURYASTROLOGYINFO_BUFFID_FIELD.has_default_value = true
AUGURYASTROLOGYINFO_BUFFID_FIELD.default_value = 0
AUGURYASTROLOGYINFO_BUFFID_FIELD.type = 13
AUGURYASTROLOGYINFO_BUFFID_FIELD.cpp_type = 3
AUGURYASTROLOGYINFO.name = "AuguryAstrologyInfo"
AUGURYASTROLOGYINFO.full_name = ".Cmd.AuguryAstrologyInfo"
AUGURYASTROLOGYINFO.nested_types = {}
AUGURYASTROLOGYINFO.enum_types = {}
AUGURYASTROLOGYINFO.fields = {
  AUGURYASTROLOGYINFO_CMD_FIELD,
  AUGURYASTROLOGYINFO_PARAM_FIELD,
  AUGURYASTROLOGYINFO_ID_FIELD,
  AUGURYASTROLOGYINFO_BUFFID_FIELD
}
AUGURYASTROLOGYINFO.is_extendable = false
AUGURYASTROLOGYINFO.extensions = {}
AUGURYPARAM_ANSWER = 5
AUGURYPARAM_ASTROLOGY_DRAW_CARD = 7
AUGURYPARAM_ASTROLOGY_INFO = 8
AUGURYPARAM_CHAT = 3
AUGURYPARAM_INVITE = 1
AUGURYPARAM_INVITE_REPLY = 2
AUGURYPARAM_QUIT = 6
AUGURYPARAM_TITLE = 4
AuguryAnswer = protobuf.Message(AUGURYANSWER)
AuguryAstrologyDrawCard = protobuf.Message(AUGURYASTROLOGYDRAWCARD)
AuguryAstrologyInfo = protobuf.Message(AUGURYASTROLOGYINFO)
AuguryChat = protobuf.Message(AUGURYCHAT)
AuguryInvite = protobuf.Message(AUGURYINVITE)
AuguryInviteReply = protobuf.Message(AUGURYINVITEREPLY)
AuguryQuit = protobuf.Message(AUGURYQUIT)
AuguryTitle = protobuf.Message(AUGURYTITLE)
EASTROLOGYTYPE_ACTIVITY = 2
EASTROLOGYTYPE_CONSTELLATION = 1
EAUGURYTYPE_ACTIVITY = 5
EAUGURYTYPE_ADVENTURE = 3
EAUGURYTYPE_LOVE_SEASON = 1
EAUGURYTYPE_STAR_GUIDE = 2
EAUGURYTYPE_VALENTINE = 4
EReplyType_Agree = 1
EReplyType_Refuse = 2
