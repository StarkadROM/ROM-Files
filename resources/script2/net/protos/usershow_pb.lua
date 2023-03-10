local protobuf = protobuf
autoImport("xCmd_pb")
local xCmd_pb = xCmd_pb
module("UserShow_pb")
EUSERSHOWPARAM = protobuf.EnumDescriptor()
EUSERSHOWPARAM_EUSERSHOW_NEW_PHOTO_FRAME_ENUM = protobuf.EnumValueDescriptor()
EUSERSHOWPARAM_EUSERSHOW_SYNC_PHOTO_FRAME_ENUM = protobuf.EnumValueDescriptor()
EUSERSHOWPARAM_EUSERSHOW_NEW_BACKGROUND_FRAME_ENUM = protobuf.EnumValueDescriptor()
EUSERSHOWPARAM_EUSERSHOW_SYNC_BACKGROUND_FRAME_ENUM = protobuf.EnumValueDescriptor()
EUSERSHOWPARAM_EUSERSHOW_USE_PHOTO_FRAME_ENUM = protobuf.EnumValueDescriptor()
EUSERSHOWPARAM_EUSERSHOW_USE_BACKGROUND_FRAME_ENUM = protobuf.EnumValueDescriptor()
EUSERSHOWPARAM_EUSERSHOW_SYNC_CHAT_FRAME_ENUM = protobuf.EnumValueDescriptor()
EUSERSHOWPARAM_EUSERSHOW_USE_CHAT_FRAME_ENUM = protobuf.EnumValueDescriptor()
UNLOCKPHOTOFRAME = protobuf.Descriptor()
UNLOCKPHOTOFRAME_CMD_FIELD = protobuf.FieldDescriptor()
UNLOCKPHOTOFRAME_PARAM_FIELD = protobuf.FieldDescriptor()
UNLOCKPHOTOFRAME_ID_FIELD = protobuf.FieldDescriptor()
UNLOCKPHOTOFRAME_DEL_FIELD = protobuf.FieldDescriptor()
SYNCALLPHOTOFRAME = protobuf.Descriptor()
SYNCALLPHOTOFRAME_CMD_FIELD = protobuf.FieldDescriptor()
SYNCALLPHOTOFRAME_PARAM_FIELD = protobuf.FieldDescriptor()
SYNCALLPHOTOFRAME_IDS_FIELD = protobuf.FieldDescriptor()
SELECTPHOTOFRAME = protobuf.Descriptor()
SELECTPHOTOFRAME_CMD_FIELD = protobuf.FieldDescriptor()
SELECTPHOTOFRAME_PARAM_FIELD = protobuf.FieldDescriptor()
SELECTPHOTOFRAME_ID_FIELD = protobuf.FieldDescriptor()
UNLOCKBACKGROUNDFRAME = protobuf.Descriptor()
UNLOCKBACKGROUNDFRAME_CMD_FIELD = protobuf.FieldDescriptor()
UNLOCKBACKGROUNDFRAME_PARAM_FIELD = protobuf.FieldDescriptor()
UNLOCKBACKGROUNDFRAME_ID_FIELD = protobuf.FieldDescriptor()
UNLOCKBACKGROUNDFRAME_DEL_FIELD = protobuf.FieldDescriptor()
SYNCALLBACKGROUNDFRAME = protobuf.Descriptor()
SYNCALLBACKGROUNDFRAME_CMD_FIELD = protobuf.FieldDescriptor()
SYNCALLBACKGROUNDFRAME_PARAM_FIELD = protobuf.FieldDescriptor()
SYNCALLBACKGROUNDFRAME_IDS_FIELD = protobuf.FieldDescriptor()
SELECTBACKGROUNDFRAME = protobuf.Descriptor()
SELECTBACKGROUNDFRAME_CMD_FIELD = protobuf.FieldDescriptor()
SELECTBACKGROUNDFRAME_PARAM_FIELD = protobuf.FieldDescriptor()
SELECTBACKGROUNDFRAME_ID_FIELD = protobuf.FieldDescriptor()
SYNCUNLOCKCHATFRAME = protobuf.Descriptor()
SYNCUNLOCKCHATFRAME_CMD_FIELD = protobuf.FieldDescriptor()
SYNCUNLOCKCHATFRAME_PARAM_FIELD = protobuf.FieldDescriptor()
SYNCUNLOCKCHATFRAME_IDS_FIELD = protobuf.FieldDescriptor()
SELECTCHATFRAME = protobuf.Descriptor()
SELECTCHATFRAME_CMD_FIELD = protobuf.FieldDescriptor()
SELECTCHATFRAME_PARAM_FIELD = protobuf.FieldDescriptor()
SELECTCHATFRAME_ID_FIELD = protobuf.FieldDescriptor()
EUSERSHOWPARAM_EUSERSHOW_NEW_PHOTO_FRAME_ENUM.name = "EUSERSHOW_NEW_PHOTO_FRAME"
EUSERSHOWPARAM_EUSERSHOW_NEW_PHOTO_FRAME_ENUM.index = 0
EUSERSHOWPARAM_EUSERSHOW_NEW_PHOTO_FRAME_ENUM.number = 1
EUSERSHOWPARAM_EUSERSHOW_SYNC_PHOTO_FRAME_ENUM.name = "EUSERSHOW_SYNC_PHOTO_FRAME"
EUSERSHOWPARAM_EUSERSHOW_SYNC_PHOTO_FRAME_ENUM.index = 1
EUSERSHOWPARAM_EUSERSHOW_SYNC_PHOTO_FRAME_ENUM.number = 2
EUSERSHOWPARAM_EUSERSHOW_NEW_BACKGROUND_FRAME_ENUM.name = "EUSERSHOW_NEW_BACKGROUND_FRAME"
EUSERSHOWPARAM_EUSERSHOW_NEW_BACKGROUND_FRAME_ENUM.index = 2
EUSERSHOWPARAM_EUSERSHOW_NEW_BACKGROUND_FRAME_ENUM.number = 3
EUSERSHOWPARAM_EUSERSHOW_SYNC_BACKGROUND_FRAME_ENUM.name = "EUSERSHOW_SYNC_BACKGROUND_FRAME"
EUSERSHOWPARAM_EUSERSHOW_SYNC_BACKGROUND_FRAME_ENUM.index = 3
EUSERSHOWPARAM_EUSERSHOW_SYNC_BACKGROUND_FRAME_ENUM.number = 4
EUSERSHOWPARAM_EUSERSHOW_USE_PHOTO_FRAME_ENUM.name = "EUSERSHOW_USE_PHOTO_FRAME"
EUSERSHOWPARAM_EUSERSHOW_USE_PHOTO_FRAME_ENUM.index = 4
EUSERSHOWPARAM_EUSERSHOW_USE_PHOTO_FRAME_ENUM.number = 5
EUSERSHOWPARAM_EUSERSHOW_USE_BACKGROUND_FRAME_ENUM.name = "EUSERSHOW_USE_BACKGROUND_FRAME"
EUSERSHOWPARAM_EUSERSHOW_USE_BACKGROUND_FRAME_ENUM.index = 5
EUSERSHOWPARAM_EUSERSHOW_USE_BACKGROUND_FRAME_ENUM.number = 6
EUSERSHOWPARAM_EUSERSHOW_SYNC_CHAT_FRAME_ENUM.name = "EUSERSHOW_SYNC_CHAT_FRAME"
EUSERSHOWPARAM_EUSERSHOW_SYNC_CHAT_FRAME_ENUM.index = 6
EUSERSHOWPARAM_EUSERSHOW_SYNC_CHAT_FRAME_ENUM.number = 7
EUSERSHOWPARAM_EUSERSHOW_USE_CHAT_FRAME_ENUM.name = "EUSERSHOW_USE_CHAT_FRAME"
EUSERSHOWPARAM_EUSERSHOW_USE_CHAT_FRAME_ENUM.index = 7
EUSERSHOWPARAM_EUSERSHOW_USE_CHAT_FRAME_ENUM.number = 8
EUSERSHOWPARAM.name = "EUserShowParam"
EUSERSHOWPARAM.full_name = ".Cmd.EUserShowParam"
EUSERSHOWPARAM.values = {
  EUSERSHOWPARAM_EUSERSHOW_NEW_PHOTO_FRAME_ENUM,
  EUSERSHOWPARAM_EUSERSHOW_SYNC_PHOTO_FRAME_ENUM,
  EUSERSHOWPARAM_EUSERSHOW_NEW_BACKGROUND_FRAME_ENUM,
  EUSERSHOWPARAM_EUSERSHOW_SYNC_BACKGROUND_FRAME_ENUM,
  EUSERSHOWPARAM_EUSERSHOW_USE_PHOTO_FRAME_ENUM,
  EUSERSHOWPARAM_EUSERSHOW_USE_BACKGROUND_FRAME_ENUM,
  EUSERSHOWPARAM_EUSERSHOW_SYNC_CHAT_FRAME_ENUM,
  EUSERSHOWPARAM_EUSERSHOW_USE_CHAT_FRAME_ENUM
}
UNLOCKPHOTOFRAME_CMD_FIELD.name = "cmd"
UNLOCKPHOTOFRAME_CMD_FIELD.full_name = ".Cmd.UnlockPhotoFrame.cmd"
UNLOCKPHOTOFRAME_CMD_FIELD.number = 1
UNLOCKPHOTOFRAME_CMD_FIELD.index = 0
UNLOCKPHOTOFRAME_CMD_FIELD.label = 1
UNLOCKPHOTOFRAME_CMD_FIELD.has_default_value = true
UNLOCKPHOTOFRAME_CMD_FIELD.default_value = 225
UNLOCKPHOTOFRAME_CMD_FIELD.enum_type = XCMD_PB_COMMAND
UNLOCKPHOTOFRAME_CMD_FIELD.type = 14
UNLOCKPHOTOFRAME_CMD_FIELD.cpp_type = 8
UNLOCKPHOTOFRAME_PARAM_FIELD.name = "param"
UNLOCKPHOTOFRAME_PARAM_FIELD.full_name = ".Cmd.UnlockPhotoFrame.param"
UNLOCKPHOTOFRAME_PARAM_FIELD.number = 2
UNLOCKPHOTOFRAME_PARAM_FIELD.index = 1
UNLOCKPHOTOFRAME_PARAM_FIELD.label = 1
UNLOCKPHOTOFRAME_PARAM_FIELD.has_default_value = true
UNLOCKPHOTOFRAME_PARAM_FIELD.default_value = 1
UNLOCKPHOTOFRAME_PARAM_FIELD.enum_type = EUSERSHOWPARAM
UNLOCKPHOTOFRAME_PARAM_FIELD.type = 14
UNLOCKPHOTOFRAME_PARAM_FIELD.cpp_type = 8
UNLOCKPHOTOFRAME_ID_FIELD.name = "id"
UNLOCKPHOTOFRAME_ID_FIELD.full_name = ".Cmd.UnlockPhotoFrame.id"
UNLOCKPHOTOFRAME_ID_FIELD.number = 3
UNLOCKPHOTOFRAME_ID_FIELD.index = 2
UNLOCKPHOTOFRAME_ID_FIELD.label = 1
UNLOCKPHOTOFRAME_ID_FIELD.has_default_value = true
UNLOCKPHOTOFRAME_ID_FIELD.default_value = 0
UNLOCKPHOTOFRAME_ID_FIELD.type = 13
UNLOCKPHOTOFRAME_ID_FIELD.cpp_type = 3
UNLOCKPHOTOFRAME_DEL_FIELD.name = "del"
UNLOCKPHOTOFRAME_DEL_FIELD.full_name = ".Cmd.UnlockPhotoFrame.del"
UNLOCKPHOTOFRAME_DEL_FIELD.number = 4
UNLOCKPHOTOFRAME_DEL_FIELD.index = 3
UNLOCKPHOTOFRAME_DEL_FIELD.label = 1
UNLOCKPHOTOFRAME_DEL_FIELD.has_default_value = true
UNLOCKPHOTOFRAME_DEL_FIELD.default_value = false
UNLOCKPHOTOFRAME_DEL_FIELD.type = 8
UNLOCKPHOTOFRAME_DEL_FIELD.cpp_type = 7
UNLOCKPHOTOFRAME.name = "UnlockPhotoFrame"
UNLOCKPHOTOFRAME.full_name = ".Cmd.UnlockPhotoFrame"
UNLOCKPHOTOFRAME.nested_types = {}
UNLOCKPHOTOFRAME.enum_types = {}
UNLOCKPHOTOFRAME.fields = {
  UNLOCKPHOTOFRAME_CMD_FIELD,
  UNLOCKPHOTOFRAME_PARAM_FIELD,
  UNLOCKPHOTOFRAME_ID_FIELD,
  UNLOCKPHOTOFRAME_DEL_FIELD
}
UNLOCKPHOTOFRAME.is_extendable = false
UNLOCKPHOTOFRAME.extensions = {}
SYNCALLPHOTOFRAME_CMD_FIELD.name = "cmd"
SYNCALLPHOTOFRAME_CMD_FIELD.full_name = ".Cmd.SyncAllPhotoFrame.cmd"
SYNCALLPHOTOFRAME_CMD_FIELD.number = 1
SYNCALLPHOTOFRAME_CMD_FIELD.index = 0
SYNCALLPHOTOFRAME_CMD_FIELD.label = 1
SYNCALLPHOTOFRAME_CMD_FIELD.has_default_value = true
SYNCALLPHOTOFRAME_CMD_FIELD.default_value = 225
SYNCALLPHOTOFRAME_CMD_FIELD.enum_type = XCMD_PB_COMMAND
SYNCALLPHOTOFRAME_CMD_FIELD.type = 14
SYNCALLPHOTOFRAME_CMD_FIELD.cpp_type = 8
SYNCALLPHOTOFRAME_PARAM_FIELD.name = "param"
SYNCALLPHOTOFRAME_PARAM_FIELD.full_name = ".Cmd.SyncAllPhotoFrame.param"
SYNCALLPHOTOFRAME_PARAM_FIELD.number = 2
SYNCALLPHOTOFRAME_PARAM_FIELD.index = 1
SYNCALLPHOTOFRAME_PARAM_FIELD.label = 1
SYNCALLPHOTOFRAME_PARAM_FIELD.has_default_value = true
SYNCALLPHOTOFRAME_PARAM_FIELD.default_value = 2
SYNCALLPHOTOFRAME_PARAM_FIELD.enum_type = EUSERSHOWPARAM
SYNCALLPHOTOFRAME_PARAM_FIELD.type = 14
SYNCALLPHOTOFRAME_PARAM_FIELD.cpp_type = 8
SYNCALLPHOTOFRAME_IDS_FIELD.name = "ids"
SYNCALLPHOTOFRAME_IDS_FIELD.full_name = ".Cmd.SyncAllPhotoFrame.ids"
SYNCALLPHOTOFRAME_IDS_FIELD.number = 3
SYNCALLPHOTOFRAME_IDS_FIELD.index = 2
SYNCALLPHOTOFRAME_IDS_FIELD.label = 3
SYNCALLPHOTOFRAME_IDS_FIELD.has_default_value = false
SYNCALLPHOTOFRAME_IDS_FIELD.default_value = {}
SYNCALLPHOTOFRAME_IDS_FIELD.type = 13
SYNCALLPHOTOFRAME_IDS_FIELD.cpp_type = 3
SYNCALLPHOTOFRAME.name = "SyncAllPhotoFrame"
SYNCALLPHOTOFRAME.full_name = ".Cmd.SyncAllPhotoFrame"
SYNCALLPHOTOFRAME.nested_types = {}
SYNCALLPHOTOFRAME.enum_types = {}
SYNCALLPHOTOFRAME.fields = {
  SYNCALLPHOTOFRAME_CMD_FIELD,
  SYNCALLPHOTOFRAME_PARAM_FIELD,
  SYNCALLPHOTOFRAME_IDS_FIELD
}
SYNCALLPHOTOFRAME.is_extendable = false
SYNCALLPHOTOFRAME.extensions = {}
SELECTPHOTOFRAME_CMD_FIELD.name = "cmd"
SELECTPHOTOFRAME_CMD_FIELD.full_name = ".Cmd.SelectPhotoFrame.cmd"
SELECTPHOTOFRAME_CMD_FIELD.number = 1
SELECTPHOTOFRAME_CMD_FIELD.index = 0
SELECTPHOTOFRAME_CMD_FIELD.label = 1
SELECTPHOTOFRAME_CMD_FIELD.has_default_value = true
SELECTPHOTOFRAME_CMD_FIELD.default_value = 225
SELECTPHOTOFRAME_CMD_FIELD.enum_type = XCMD_PB_COMMAND
SELECTPHOTOFRAME_CMD_FIELD.type = 14
SELECTPHOTOFRAME_CMD_FIELD.cpp_type = 8
SELECTPHOTOFRAME_PARAM_FIELD.name = "param"
SELECTPHOTOFRAME_PARAM_FIELD.full_name = ".Cmd.SelectPhotoFrame.param"
SELECTPHOTOFRAME_PARAM_FIELD.number = 2
SELECTPHOTOFRAME_PARAM_FIELD.index = 1
SELECTPHOTOFRAME_PARAM_FIELD.label = 1
SELECTPHOTOFRAME_PARAM_FIELD.has_default_value = true
SELECTPHOTOFRAME_PARAM_FIELD.default_value = 5
SELECTPHOTOFRAME_PARAM_FIELD.enum_type = EUSERSHOWPARAM
SELECTPHOTOFRAME_PARAM_FIELD.type = 14
SELECTPHOTOFRAME_PARAM_FIELD.cpp_type = 8
SELECTPHOTOFRAME_ID_FIELD.name = "id"
SELECTPHOTOFRAME_ID_FIELD.full_name = ".Cmd.SelectPhotoFrame.id"
SELECTPHOTOFRAME_ID_FIELD.number = 3
SELECTPHOTOFRAME_ID_FIELD.index = 2
SELECTPHOTOFRAME_ID_FIELD.label = 1
SELECTPHOTOFRAME_ID_FIELD.has_default_value = true
SELECTPHOTOFRAME_ID_FIELD.default_value = 0
SELECTPHOTOFRAME_ID_FIELD.type = 13
SELECTPHOTOFRAME_ID_FIELD.cpp_type = 3
SELECTPHOTOFRAME.name = "SelectPhotoFrame"
SELECTPHOTOFRAME.full_name = ".Cmd.SelectPhotoFrame"
SELECTPHOTOFRAME.nested_types = {}
SELECTPHOTOFRAME.enum_types = {}
SELECTPHOTOFRAME.fields = {
  SELECTPHOTOFRAME_CMD_FIELD,
  SELECTPHOTOFRAME_PARAM_FIELD,
  SELECTPHOTOFRAME_ID_FIELD
}
SELECTPHOTOFRAME.is_extendable = false
SELECTPHOTOFRAME.extensions = {}
UNLOCKBACKGROUNDFRAME_CMD_FIELD.name = "cmd"
UNLOCKBACKGROUNDFRAME_CMD_FIELD.full_name = ".Cmd.UnlockBackgroundFrame.cmd"
UNLOCKBACKGROUNDFRAME_CMD_FIELD.number = 1
UNLOCKBACKGROUNDFRAME_CMD_FIELD.index = 0
UNLOCKBACKGROUNDFRAME_CMD_FIELD.label = 1
UNLOCKBACKGROUNDFRAME_CMD_FIELD.has_default_value = true
UNLOCKBACKGROUNDFRAME_CMD_FIELD.default_value = 225
UNLOCKBACKGROUNDFRAME_CMD_FIELD.enum_type = XCMD_PB_COMMAND
UNLOCKBACKGROUNDFRAME_CMD_FIELD.type = 14
UNLOCKBACKGROUNDFRAME_CMD_FIELD.cpp_type = 8
UNLOCKBACKGROUNDFRAME_PARAM_FIELD.name = "param"
UNLOCKBACKGROUNDFRAME_PARAM_FIELD.full_name = ".Cmd.UnlockBackgroundFrame.param"
UNLOCKBACKGROUNDFRAME_PARAM_FIELD.number = 2
UNLOCKBACKGROUNDFRAME_PARAM_FIELD.index = 1
UNLOCKBACKGROUNDFRAME_PARAM_FIELD.label = 1
UNLOCKBACKGROUNDFRAME_PARAM_FIELD.has_default_value = true
UNLOCKBACKGROUNDFRAME_PARAM_FIELD.default_value = 3
UNLOCKBACKGROUNDFRAME_PARAM_FIELD.enum_type = EUSERSHOWPARAM
UNLOCKBACKGROUNDFRAME_PARAM_FIELD.type = 14
UNLOCKBACKGROUNDFRAME_PARAM_FIELD.cpp_type = 8
UNLOCKBACKGROUNDFRAME_ID_FIELD.name = "id"
UNLOCKBACKGROUNDFRAME_ID_FIELD.full_name = ".Cmd.UnlockBackgroundFrame.id"
UNLOCKBACKGROUNDFRAME_ID_FIELD.number = 3
UNLOCKBACKGROUNDFRAME_ID_FIELD.index = 2
UNLOCKBACKGROUNDFRAME_ID_FIELD.label = 1
UNLOCKBACKGROUNDFRAME_ID_FIELD.has_default_value = true
UNLOCKBACKGROUNDFRAME_ID_FIELD.default_value = 0
UNLOCKBACKGROUNDFRAME_ID_FIELD.type = 13
UNLOCKBACKGROUNDFRAME_ID_FIELD.cpp_type = 3
UNLOCKBACKGROUNDFRAME_DEL_FIELD.name = "del"
UNLOCKBACKGROUNDFRAME_DEL_FIELD.full_name = ".Cmd.UnlockBackgroundFrame.del"
UNLOCKBACKGROUNDFRAME_DEL_FIELD.number = 4
UNLOCKBACKGROUNDFRAME_DEL_FIELD.index = 3
UNLOCKBACKGROUNDFRAME_DEL_FIELD.label = 1
UNLOCKBACKGROUNDFRAME_DEL_FIELD.has_default_value = true
UNLOCKBACKGROUNDFRAME_DEL_FIELD.default_value = false
UNLOCKBACKGROUNDFRAME_DEL_FIELD.type = 8
UNLOCKBACKGROUNDFRAME_DEL_FIELD.cpp_type = 7
UNLOCKBACKGROUNDFRAME.name = "UnlockBackgroundFrame"
UNLOCKBACKGROUNDFRAME.full_name = ".Cmd.UnlockBackgroundFrame"
UNLOCKBACKGROUNDFRAME.nested_types = {}
UNLOCKBACKGROUNDFRAME.enum_types = {}
UNLOCKBACKGROUNDFRAME.fields = {
  UNLOCKBACKGROUNDFRAME_CMD_FIELD,
  UNLOCKBACKGROUNDFRAME_PARAM_FIELD,
  UNLOCKBACKGROUNDFRAME_ID_FIELD,
  UNLOCKBACKGROUNDFRAME_DEL_FIELD
}
UNLOCKBACKGROUNDFRAME.is_extendable = false
UNLOCKBACKGROUNDFRAME.extensions = {}
SYNCALLBACKGROUNDFRAME_CMD_FIELD.name = "cmd"
SYNCALLBACKGROUNDFRAME_CMD_FIELD.full_name = ".Cmd.SyncAllBackgroundFrame.cmd"
SYNCALLBACKGROUNDFRAME_CMD_FIELD.number = 1
SYNCALLBACKGROUNDFRAME_CMD_FIELD.index = 0
SYNCALLBACKGROUNDFRAME_CMD_FIELD.label = 1
SYNCALLBACKGROUNDFRAME_CMD_FIELD.has_default_value = true
SYNCALLBACKGROUNDFRAME_CMD_FIELD.default_value = 225
SYNCALLBACKGROUNDFRAME_CMD_FIELD.enum_type = XCMD_PB_COMMAND
SYNCALLBACKGROUNDFRAME_CMD_FIELD.type = 14
SYNCALLBACKGROUNDFRAME_CMD_FIELD.cpp_type = 8
SYNCALLBACKGROUNDFRAME_PARAM_FIELD.name = "param"
SYNCALLBACKGROUNDFRAME_PARAM_FIELD.full_name = ".Cmd.SyncAllBackgroundFrame.param"
SYNCALLBACKGROUNDFRAME_PARAM_FIELD.number = 2
SYNCALLBACKGROUNDFRAME_PARAM_FIELD.index = 1
SYNCALLBACKGROUNDFRAME_PARAM_FIELD.label = 1
SYNCALLBACKGROUNDFRAME_PARAM_FIELD.has_default_value = true
SYNCALLBACKGROUNDFRAME_PARAM_FIELD.default_value = 4
SYNCALLBACKGROUNDFRAME_PARAM_FIELD.enum_type = EUSERSHOWPARAM
SYNCALLBACKGROUNDFRAME_PARAM_FIELD.type = 14
SYNCALLBACKGROUNDFRAME_PARAM_FIELD.cpp_type = 8
SYNCALLBACKGROUNDFRAME_IDS_FIELD.name = "ids"
SYNCALLBACKGROUNDFRAME_IDS_FIELD.full_name = ".Cmd.SyncAllBackgroundFrame.ids"
SYNCALLBACKGROUNDFRAME_IDS_FIELD.number = 3
SYNCALLBACKGROUNDFRAME_IDS_FIELD.index = 2
SYNCALLBACKGROUNDFRAME_IDS_FIELD.label = 3
SYNCALLBACKGROUNDFRAME_IDS_FIELD.has_default_value = false
SYNCALLBACKGROUNDFRAME_IDS_FIELD.default_value = {}
SYNCALLBACKGROUNDFRAME_IDS_FIELD.type = 13
SYNCALLBACKGROUNDFRAME_IDS_FIELD.cpp_type = 3
SYNCALLBACKGROUNDFRAME.name = "SyncAllBackgroundFrame"
SYNCALLBACKGROUNDFRAME.full_name = ".Cmd.SyncAllBackgroundFrame"
SYNCALLBACKGROUNDFRAME.nested_types = {}
SYNCALLBACKGROUNDFRAME.enum_types = {}
SYNCALLBACKGROUNDFRAME.fields = {
  SYNCALLBACKGROUNDFRAME_CMD_FIELD,
  SYNCALLBACKGROUNDFRAME_PARAM_FIELD,
  SYNCALLBACKGROUNDFRAME_IDS_FIELD
}
SYNCALLBACKGROUNDFRAME.is_extendable = false
SYNCALLBACKGROUNDFRAME.extensions = {}
SELECTBACKGROUNDFRAME_CMD_FIELD.name = "cmd"
SELECTBACKGROUNDFRAME_CMD_FIELD.full_name = ".Cmd.SelectBackgroundFrame.cmd"
SELECTBACKGROUNDFRAME_CMD_FIELD.number = 1
SELECTBACKGROUNDFRAME_CMD_FIELD.index = 0
SELECTBACKGROUNDFRAME_CMD_FIELD.label = 1
SELECTBACKGROUNDFRAME_CMD_FIELD.has_default_value = true
SELECTBACKGROUNDFRAME_CMD_FIELD.default_value = 225
SELECTBACKGROUNDFRAME_CMD_FIELD.enum_type = XCMD_PB_COMMAND
SELECTBACKGROUNDFRAME_CMD_FIELD.type = 14
SELECTBACKGROUNDFRAME_CMD_FIELD.cpp_type = 8
SELECTBACKGROUNDFRAME_PARAM_FIELD.name = "param"
SELECTBACKGROUNDFRAME_PARAM_FIELD.full_name = ".Cmd.SelectBackgroundFrame.param"
SELECTBACKGROUNDFRAME_PARAM_FIELD.number = 2
SELECTBACKGROUNDFRAME_PARAM_FIELD.index = 1
SELECTBACKGROUNDFRAME_PARAM_FIELD.label = 1
SELECTBACKGROUNDFRAME_PARAM_FIELD.has_default_value = true
SELECTBACKGROUNDFRAME_PARAM_FIELD.default_value = 6
SELECTBACKGROUNDFRAME_PARAM_FIELD.enum_type = EUSERSHOWPARAM
SELECTBACKGROUNDFRAME_PARAM_FIELD.type = 14
SELECTBACKGROUNDFRAME_PARAM_FIELD.cpp_type = 8
SELECTBACKGROUNDFRAME_ID_FIELD.name = "id"
SELECTBACKGROUNDFRAME_ID_FIELD.full_name = ".Cmd.SelectBackgroundFrame.id"
SELECTBACKGROUNDFRAME_ID_FIELD.number = 3
SELECTBACKGROUNDFRAME_ID_FIELD.index = 2
SELECTBACKGROUNDFRAME_ID_FIELD.label = 1
SELECTBACKGROUNDFRAME_ID_FIELD.has_default_value = true
SELECTBACKGROUNDFRAME_ID_FIELD.default_value = 0
SELECTBACKGROUNDFRAME_ID_FIELD.type = 13
SELECTBACKGROUNDFRAME_ID_FIELD.cpp_type = 3
SELECTBACKGROUNDFRAME.name = "SelectBackgroundFrame"
SELECTBACKGROUNDFRAME.full_name = ".Cmd.SelectBackgroundFrame"
SELECTBACKGROUNDFRAME.nested_types = {}
SELECTBACKGROUNDFRAME.enum_types = {}
SELECTBACKGROUNDFRAME.fields = {
  SELECTBACKGROUNDFRAME_CMD_FIELD,
  SELECTBACKGROUNDFRAME_PARAM_FIELD,
  SELECTBACKGROUNDFRAME_ID_FIELD
}
SELECTBACKGROUNDFRAME.is_extendable = false
SELECTBACKGROUNDFRAME.extensions = {}
SYNCUNLOCKCHATFRAME_CMD_FIELD.name = "cmd"
SYNCUNLOCKCHATFRAME_CMD_FIELD.full_name = ".Cmd.SyncUnlockChatFrame.cmd"
SYNCUNLOCKCHATFRAME_CMD_FIELD.number = 1
SYNCUNLOCKCHATFRAME_CMD_FIELD.index = 0
SYNCUNLOCKCHATFRAME_CMD_FIELD.label = 1
SYNCUNLOCKCHATFRAME_CMD_FIELD.has_default_value = true
SYNCUNLOCKCHATFRAME_CMD_FIELD.default_value = 225
SYNCUNLOCKCHATFRAME_CMD_FIELD.enum_type = XCMD_PB_COMMAND
SYNCUNLOCKCHATFRAME_CMD_FIELD.type = 14
SYNCUNLOCKCHATFRAME_CMD_FIELD.cpp_type = 8
SYNCUNLOCKCHATFRAME_PARAM_FIELD.name = "param"
SYNCUNLOCKCHATFRAME_PARAM_FIELD.full_name = ".Cmd.SyncUnlockChatFrame.param"
SYNCUNLOCKCHATFRAME_PARAM_FIELD.number = 2
SYNCUNLOCKCHATFRAME_PARAM_FIELD.index = 1
SYNCUNLOCKCHATFRAME_PARAM_FIELD.label = 1
SYNCUNLOCKCHATFRAME_PARAM_FIELD.has_default_value = true
SYNCUNLOCKCHATFRAME_PARAM_FIELD.default_value = 7
SYNCUNLOCKCHATFRAME_PARAM_FIELD.enum_type = EUSERSHOWPARAM
SYNCUNLOCKCHATFRAME_PARAM_FIELD.type = 14
SYNCUNLOCKCHATFRAME_PARAM_FIELD.cpp_type = 8
SYNCUNLOCKCHATFRAME_IDS_FIELD.name = "ids"
SYNCUNLOCKCHATFRAME_IDS_FIELD.full_name = ".Cmd.SyncUnlockChatFrame.ids"
SYNCUNLOCKCHATFRAME_IDS_FIELD.number = 3
SYNCUNLOCKCHATFRAME_IDS_FIELD.index = 2
SYNCUNLOCKCHATFRAME_IDS_FIELD.label = 3
SYNCUNLOCKCHATFRAME_IDS_FIELD.has_default_value = false
SYNCUNLOCKCHATFRAME_IDS_FIELD.default_value = {}
SYNCUNLOCKCHATFRAME_IDS_FIELD.type = 13
SYNCUNLOCKCHATFRAME_IDS_FIELD.cpp_type = 3
SYNCUNLOCKCHATFRAME.name = "SyncUnlockChatFrame"
SYNCUNLOCKCHATFRAME.full_name = ".Cmd.SyncUnlockChatFrame"
SYNCUNLOCKCHATFRAME.nested_types = {}
SYNCUNLOCKCHATFRAME.enum_types = {}
SYNCUNLOCKCHATFRAME.fields = {
  SYNCUNLOCKCHATFRAME_CMD_FIELD,
  SYNCUNLOCKCHATFRAME_PARAM_FIELD,
  SYNCUNLOCKCHATFRAME_IDS_FIELD
}
SYNCUNLOCKCHATFRAME.is_extendable = false
SYNCUNLOCKCHATFRAME.extensions = {}
SELECTCHATFRAME_CMD_FIELD.name = "cmd"
SELECTCHATFRAME_CMD_FIELD.full_name = ".Cmd.SelectChatFrame.cmd"
SELECTCHATFRAME_CMD_FIELD.number = 1
SELECTCHATFRAME_CMD_FIELD.index = 0
SELECTCHATFRAME_CMD_FIELD.label = 1
SELECTCHATFRAME_CMD_FIELD.has_default_value = true
SELECTCHATFRAME_CMD_FIELD.default_value = 225
SELECTCHATFRAME_CMD_FIELD.enum_type = XCMD_PB_COMMAND
SELECTCHATFRAME_CMD_FIELD.type = 14
SELECTCHATFRAME_CMD_FIELD.cpp_type = 8
SELECTCHATFRAME_PARAM_FIELD.name = "param"
SELECTCHATFRAME_PARAM_FIELD.full_name = ".Cmd.SelectChatFrame.param"
SELECTCHATFRAME_PARAM_FIELD.number = 2
SELECTCHATFRAME_PARAM_FIELD.index = 1
SELECTCHATFRAME_PARAM_FIELD.label = 1
SELECTCHATFRAME_PARAM_FIELD.has_default_value = true
SELECTCHATFRAME_PARAM_FIELD.default_value = 8
SELECTCHATFRAME_PARAM_FIELD.enum_type = EUSERSHOWPARAM
SELECTCHATFRAME_PARAM_FIELD.type = 14
SELECTCHATFRAME_PARAM_FIELD.cpp_type = 8
SELECTCHATFRAME_ID_FIELD.name = "id"
SELECTCHATFRAME_ID_FIELD.full_name = ".Cmd.SelectChatFrame.id"
SELECTCHATFRAME_ID_FIELD.number = 3
SELECTCHATFRAME_ID_FIELD.index = 2
SELECTCHATFRAME_ID_FIELD.label = 1
SELECTCHATFRAME_ID_FIELD.has_default_value = true
SELECTCHATFRAME_ID_FIELD.default_value = 0
SELECTCHATFRAME_ID_FIELD.type = 13
SELECTCHATFRAME_ID_FIELD.cpp_type = 3
SELECTCHATFRAME.name = "SelectChatFrame"
SELECTCHATFRAME.full_name = ".Cmd.SelectChatFrame"
SELECTCHATFRAME.nested_types = {}
SELECTCHATFRAME.enum_types = {}
SELECTCHATFRAME.fields = {
  SELECTCHATFRAME_CMD_FIELD,
  SELECTCHATFRAME_PARAM_FIELD,
  SELECTCHATFRAME_ID_FIELD
}
SELECTCHATFRAME.is_extendable = false
SELECTCHATFRAME.extensions = {}
EUSERSHOW_NEW_BACKGROUND_FRAME = 3
EUSERSHOW_NEW_PHOTO_FRAME = 1
EUSERSHOW_SYNC_BACKGROUND_FRAME = 4
EUSERSHOW_SYNC_CHAT_FRAME = 7
EUSERSHOW_SYNC_PHOTO_FRAME = 2
EUSERSHOW_USE_BACKGROUND_FRAME = 6
EUSERSHOW_USE_CHAT_FRAME = 8
EUSERSHOW_USE_PHOTO_FRAME = 5
SelectBackgroundFrame = protobuf.Message(SELECTBACKGROUNDFRAME)
SelectChatFrame = protobuf.Message(SELECTCHATFRAME)
SelectPhotoFrame = protobuf.Message(SELECTPHOTOFRAME)
SyncAllBackgroundFrame = protobuf.Message(SYNCALLBACKGROUNDFRAME)
SyncAllPhotoFrame = protobuf.Message(SYNCALLPHOTOFRAME)
SyncUnlockChatFrame = protobuf.Message(SYNCUNLOCKCHATFRAME)
UnlockBackgroundFrame = protobuf.Message(UNLOCKBACKGROUNDFRAME)
UnlockPhotoFrame = protobuf.Message(UNLOCKPHOTOFRAME)
