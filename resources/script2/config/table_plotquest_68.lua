Table_PlotQuest_68 = {
  [1] = {
    id = 1,
    Type = "play_effect_ui",
    Params = {path = "BtoW"}
  },
  [2] = {
    id = 2,
    Type = "startfilter",
    Params = {
      fliter = {39}
    }
  },
  [3] = {
    id = 3,
    Type = "showview",
    Params = {panelid = 800, showtype = 1}
  },
  [4] = {
    id = 4,
    Type = "change_bgm",
    Params = {
      path = "Clown_Normal",
      time = 0
    }
  },
  [5] = {
    id = 5,
    Type = "move",
    Params = {
      player = 1,
      pos = {
        -3.94,
        1.27,
        -0.33
      },
      dir = 180,
      spd = 5
    }
  },
  [6] = {
    id = 6,
    Type = "wait_time",
    Params = {time = 1000}
  },
  [7] = {
    id = 7,
    Type = "action",
    Params = {
      player = 1,
      id = 40,
      loop = true
    }
  },
  [8] = {
    id = 8,
    Type = "fullScreenEffect",
    Params = {
      on = true,
      path = "UI/Eff_Blink_ui"
    }
  },
  [9] = {
    id = 9,
    Type = "wait_time",
    Params = {time = 4000}
  },
  [10] = {
    id = 10,
    Type = "dialog",
    Params = {
      dialog = {750668}
    }
  },
  [11] = {
    id = 11,
    Type = "wait_time",
    Params = {time = 2000}
  },
  [12] = {
    id = 12,
    Type = "dialog",
    Params = {
      dialog = {750669}
    }
  },
  [13] = {
    id = 13,
    Type = "wait_time",
    Params = {time = 1000}
  },
  [14] = {
    id = 14,
    Type = "dialog",
    Params = {
      dialog = {750670}
    }
  },
  [15] = {
    id = 15,
    Type = "wait_time",
    Params = {time = 1000}
  },
  [16] = {
    id = 16,
    Type = "dialog",
    Params = {
      dialog = {750671}
    }
  },
  [17] = {
    id = 17,
    Type = "wait_time",
    Params = {time = 1000}
  },
  [18] = {
    id = 18,
    Type = "dialog",
    Params = {
      dialog = {750672}
    }
  },
  [19] = {
    id = 19,
    Type = "fullScreenEffect",
    Params = {
      on = false,
      path = "UI/Eff_Blink_ui"
    }
  },
  [20] = {
    id = 20,
    Type = "camera_filter",
    Params = {filterid = 5, on = 1}
  },
  [21] = {
    id = 21,
    Type = "play_sound",
    Params = {
      path = "Common/Task_rainbow"
    }
  },
  [22] = {
    id = 22,
    Type = "play_effect_scene",
    Params = {
      id = 1,
      path = "Skill/ResistantSouls",
      pos = {
        -0.08,
        2.04,
        1.69
      },
      onshot = 1
    }
  },
  [23] = {
    id = 23,
    Type = "wait_time",
    Params = {time = 500}
  },
  [24] = {
    id = 24,
    Type = "play_effect_scene",
    Params = {
      id = 101,
      path = "Skill/AdvancedDetoxification_hit",
      pos = {
        -0.08,
        2.04,
        1.69
      },
      onshot = 1
    }
  },
  [25] = {
    id = 25,
    Type = "wait_time",
    Params = {time = 500}
  },
  [26] = {
    id = 26,
    Type = "play_effect_scene",
    Params = {
      id = 102,
      path = "Skill/ResistantSouls_buff",
      pos = {
        -0.08,
        2.78,
        1.69
      }
    }
  },
  [27] = {
    id = 27,
    Type = "summon",
    Params = {
      npcid = 808040,
      npcuid = 808040,
      pos = {
        -0.08,
        2.04,
        1.69
      },
      dir = 225
    }
  },
  [28] = {
    id = 28,
    Type = "talk",
    Params = {npcuid = 808040, talkid = 750673}
  },
  [29] = {
    id = 29,
    Type = "dialog",
    Params = {
      dialog = {750673}
    }
  },
  [30] = {
    id = 30,
    Type = "talk",
    Params = {npcuid = 808040, talkid = 750674}
  },
  [31] = {
    id = 31,
    Type = "dialog",
    Params = {
      dialog = {750674}
    }
  },
  [32] = {
    id = 32,
    Type = "dialog",
    Params = {
      dialog = {750675}
    }
  },
  [33] = {
    id = 33,
    Type = "wait_time",
    Params = {time = 1000}
  },
  [34] = {
    id = 34,
    Type = "play_sound",
    Params = {
      path = "Common/Task_rainbow"
    }
  },
  [35] = {
    id = 35,
    Type = "play_effect_scene",
    Params = {
      id = 2,
      path = "Skill/ResistantSouls",
      pos = {
        -7.9,
        2.04,
        1.79
      },
      onshot = 1
    }
  },
  [36] = {
    id = 36,
    Type = "wait_time",
    Params = {time = 500}
  },
  [37] = {
    id = 37,
    Type = "play_effect_scene",
    Params = {
      id = 201,
      path = "Skill/AdvancedDetoxification_hit",
      pos = {
        -7.9,
        2.04,
        1.79
      },
      onshot = 1
    }
  },
  [38] = {
    id = 38,
    Type = "wait_time",
    Params = {time = 500}
  },
  [39] = {
    id = 39,
    Type = "play_effect_scene",
    Params = {
      id = 202,
      path = "Skill/ResistantSouls_buff",
      pos = {
        -7.87,
        2.77,
        1.76
      }
    }
  },
  [40] = {
    id = 40,
    Type = "summon",
    Params = {
      npcid = 808043,
      npcuid = 808043,
      pos = {
        -7.9,
        2.04,
        1.79
      },
      dir = 135
    }
  },
  [41] = {
    id = 41,
    Type = "talk",
    Params = {npcuid = 808043, talkid = 750676}
  },
  [42] = {
    id = 42,
    Type = "dialog",
    Params = {
      dialog = {750676}
    }
  },
  [43] = {
    id = 43,
    Type = "dialog",
    Params = {
      dialog = {750677}
    }
  },
  [44] = {
    id = 44,
    Type = "wait_time",
    Params = {time = 1000}
  },
  [45] = {
    id = 45,
    Type = "play_sound",
    Params = {
      path = "Common/Task_rainbow"
    }
  },
  [46] = {
    id = 46,
    Type = "play_effect_scene",
    Params = {
      id = 3,
      path = "Skill/ResistantSouls",
      pos = {
        -3.93,
        2.04,
        -4.36
      },
      onshot = 1
    }
  },
  [47] = {
    id = 47,
    Type = "wait_time",
    Params = {time = 500}
  },
  [48] = {
    id = 48,
    Type = "play_effect_scene",
    Params = {
      id = 301,
      path = "Skill/AdvancedDetoxification_hit",
      pos = {
        -3.93,
        2.04,
        -4.36
      },
      onshot = 1
    }
  },
  [49] = {
    id = 49,
    Type = "wait_time",
    Params = {time = 500}
  },
  [50] = {
    id = 50,
    Type = "play_effect_scene",
    Params = {
      id = 302,
      path = "Skill/ResistantSouls_buff",
      pos = {
        -3.93,
        2.78,
        -4.36
      }
    }
  },
  [51] = {
    id = 51,
    Type = "summon",
    Params = {
      npcid = 808045,
      npcuid = 808045,
      pos = {
        -3.93,
        2.04,
        -4.36
      },
      dir = 0
    }
  },
  [52] = {
    id = 52,
    Type = "talk",
    Params = {npcuid = 808045, talkid = 750678}
  },
  [53] = {
    id = 53,
    Type = "dialog",
    Params = {
      dialog = {750678}
    }
  },
  [54] = {
    id = 54,
    Type = "dialog",
    Params = {
      dialog = {750679}
    }
  },
  [55] = {
    id = 55,
    Type = "wait_time",
    Params = {time = 1000}
  },
  [56] = {
    id = 56,
    Type = "play_sound",
    Params = {
      path = "Common/Task_rainbow"
    }
  },
  [57] = {
    id = 57,
    Type = "play_effect_scene",
    Params = {
      id = 4,
      path = "Skill/ResistantSouls",
      pos = {
        -7.88,
        2.04,
        -2.29
      },
      onshot = 1
    }
  },
  [58] = {
    id = 58,
    Type = "wait_time",
    Params = {time = 500}
  },
  [59] = {
    id = 59,
    Type = "play_effect_scene",
    Params = {
      id = 401,
      path = "Skill/AdvancedDetoxification_hit",
      pos = {
        -7.88,
        2.04,
        -2.29
      },
      onshot = 1
    }
  },
  [60] = {
    id = 60,
    Type = "wait_time",
    Params = {time = 500}
  },
  [61] = {
    id = 61,
    Type = "play_effect_scene",
    Params = {
      id = 402,
      path = "Skill/ResistantSouls_buff",
      pos = {
        -7.88,
        2.78,
        -2.29
      }
    }
  },
  [62] = {
    id = 62,
    Type = "summon",
    Params = {
      npcid = 808041,
      npcuid = 808041,
      pos = {
        -7.88,
        2.04,
        -2.29
      },
      dir = 45
    }
  },
  [63] = {
    id = 63,
    Type = "talk",
    Params = {npcuid = 808041, talkid = 750680}
  },
  [64] = {
    id = 64,
    Type = "dialog",
    Params = {
      dialog = {750680}
    }
  },
  [65] = {
    id = 65,
    Type = "dialog",
    Params = {
      dialog = {750681}
    }
  },
  [66] = {
    id = 66,
    Type = "wait_time",
    Params = {time = 1000}
  },
  [67] = {
    id = 67,
    Type = "play_sound",
    Params = {
      path = "Common/Task_rainbow"
    }
  },
  [68] = {
    id = 68,
    Type = "play_effect_scene",
    Params = {
      id = 5,
      path = "Skill/ResistantSouls",
      pos = {
        -0.11,
        2.04,
        -2.23
      },
      onshot = 1
    }
  },
  [69] = {
    id = 69,
    Type = "wait_time",
    Params = {time = 500}
  },
  [70] = {
    id = 70,
    Type = "play_effect_scene",
    Params = {
      id = 501,
      path = "Skill/AdvancedDetoxification_hit",
      pos = {
        -0.11,
        2.04,
        -2.23
      },
      onshot = 1
    }
  },
  [71] = {
    id = 71,
    Type = "wait_time",
    Params = {time = 500}
  },
  [72] = {
    id = 72,
    Type = "play_effect_scene",
    Params = {
      id = 502,
      path = "Skill/ResistantSouls_buff",
      pos = {
        -0.11,
        2.78,
        -2.23
      }
    }
  },
  [73] = {
    id = 73,
    Type = "summon",
    Params = {
      npcid = 808042,
      npcuid = 808042,
      pos = {
        -0.11,
        2.04,
        -2.23
      },
      dir = 315
    }
  },
  [74] = {
    id = 74,
    Type = "talk",
    Params = {npcuid = 808042, talkid = 750682}
  },
  [75] = {
    id = 75,
    Type = "dialog",
    Params = {
      dialog = {750682}
    }
  },
  [76] = {
    id = 76,
    Type = "dialog",
    Params = {
      dialog = {750683}
    }
  },
  [77] = {
    id = 77,
    Type = "wait_time",
    Params = {time = 1000}
  },
  [78] = {
    id = 78,
    Type = "play_sound",
    Params = {
      path = "Common/Task_rainbow"
    }
  },
  [79] = {
    id = 79,
    Type = "play_effect_scene",
    Params = {
      id = 6,
      path = "Skill/ResistantSouls",
      pos = {
        -3.92,
        2.04,
        3.89
      },
      onshot = 1
    }
  },
  [80] = {
    id = 80,
    Type = "wait_time",
    Params = {time = 500}
  },
  [81] = {
    id = 81,
    Type = "play_effect_scene",
    Params = {
      id = 601,
      path = "Skill/AdvancedDetoxification_hit",
      pos = {
        -3.92,
        2.04,
        3.89
      },
      onshot = 1
    }
  },
  [82] = {
    id = 82,
    Type = "wait_time",
    Params = {time = 500}
  },
  [83] = {
    id = 83,
    Type = "play_effect_scene",
    Params = {
      id = 602,
      path = "Skill/ResistantSouls_buff",
      pos = {
        -3.91,
        2.78,
        3.83
      }
    }
  },
  [84] = {
    id = 84,
    Type = "summon",
    Params = {
      npcid = 808044,
      npcuid = 808044,
      pos = {
        -3.92,
        2.04,
        3.89
      },
      dir = 180
    }
  },
  [85] = {
    id = 85,
    Type = "talk",
    Params = {npcuid = 808044, talkid = 750684}
  },
  [86] = {
    id = 86,
    Type = "dialog",
    Params = {
      dialog = {750684}
    }
  },
  [87] = {
    id = 87,
    Type = "dialog",
    Params = {
      dialog = {750685}
    }
  },
  [88] = {
    id = 88,
    Type = "wait_time",
    Params = {time = 1000}
  },
  [89] = {
    id = 89,
    Type = "dialog",
    Params = {
      dialog = {750686}
    }
  },
  [90] = {
    id = 90,
    Type = "talk",
    Params = {npcuid = 808044, talkid = 750687}
  },
  [91] = {
    id = 91,
    Type = "dialog",
    Params = {
      dialog = {750687}
    }
  },
  [92] = {
    id = 92,
    Type = "talk",
    Params = {npcuid = 808044, talkid = 750688}
  },
  [93] = {
    id = 93,
    Type = "dialog",
    Params = {
      dialog = {750688}
    }
  },
  [94] = {
    id = 94,
    Type = "talk",
    Params = {npcuid = 808044, talkid = 750689}
  },
  [95] = {
    id = 95,
    Type = "dialog",
    Params = {
      dialog = {750689}
    }
  },
  [96] = {
    id = 96,
    Type = "dialog",
    Params = {
      dialog = {750690}
    }
  },
  [97] = {
    id = 97,
    Type = "wait_time",
    Params = {time = 1000}
  },
  [98] = {
    id = 98,
    Type = "talk",
    Params = {npcuid = 808040, talkid = 750691}
  },
  [99] = {
    id = 99,
    Type = "play_sound",
    Params = {
      path = "Common/Task_Shiny"
    }
  },
  [100] = {
    id = 100,
    Type = "summon",
    Params = {
      npcid = 808039,
      npcuid = 808039,
      pos = {
        -3.9,
        1.0,
        -0.24
      },
      dir = 270,
      ignoreNavMesh = 1
    }
  },
  [101] = {
    id = 101,
    Type = "wait_time",
    Params = {time = 2000}
  },
  [102] = {
    id = 102,
    Type = "play_effect_scene",
    Params = {
      id = 105,
      path = "Skill/MonsterInvincible",
      pos = {
        -7.87,
        2.77,
        1.76
      }
    }
  },
  [103] = {
    id = 103,
    Type = "dialog",
    Params = {
      dialog = {750692}
    }
  },
  [104] = {
    id = 104,
    Type = "talk",
    Params = {npcuid = 808043, talkid = 750693}
  },
  [105] = {
    id = 105,
    Type = "play_sound",
    Params = {
      path = "Common/Task_Shiny"
    }
  },
  [106] = {
    id = 106,
    Type = "action",
    Params = {npcuid = 808039, id = 502}
  },
  [107] = {
    id = 107,
    Type = "wait_time",
    Params = {time = 2000}
  },
  [108] = {
    id = 108,
    Type = "play_effect_scene",
    Params = {
      id = 106,
      path = "Skill/MonsterInvincible",
      pos = {
        -3.93,
        2.78,
        -4.36
      }
    }
  },
  [109] = {
    id = 109,
    Type = "dialog",
    Params = {
      dialog = {750694}
    }
  },
  [110] = {
    id = 110,
    Type = "talk",
    Params = {npcuid = 808045, talkid = 750695}
  },
  [111] = {
    id = 111,
    Type = "play_sound",
    Params = {
      path = "Common/Task_Shiny"
    }
  },
  [112] = {
    id = 112,
    Type = "action",
    Params = {npcuid = 808039, id = 504}
  },
  [113] = {
    id = 113,
    Type = "wait_time",
    Params = {time = 2000}
  },
  [114] = {
    id = 114,
    Type = "play_effect_scene",
    Params = {
      id = 107,
      path = "Skill/MonsterInvincible",
      pos = {
        -0.08,
        2.78,
        1.69
      }
    }
  },
  [115] = {
    id = 115,
    Type = "dialog",
    Params = {
      dialog = {750696}
    }
  },
  [116] = {
    id = 116,
    Type = "talk",
    Params = {npcuid = 808041, talkid = 750697}
  },
  [117] = {
    id = 117,
    Type = "play_sound",
    Params = {
      path = "Common/Task_Shiny"
    }
  },
  [118] = {
    id = 118,
    Type = "action",
    Params = {npcuid = 808039, id = 506}
  },
  [119] = {
    id = 119,
    Type = "wait_time",
    Params = {time = 2000}
  },
  [120] = {
    id = 120,
    Type = "play_effect_scene",
    Params = {
      id = 108,
      path = "Skill/MonsterInvincible",
      pos = {
        -0.11,
        2.78,
        -2.23
      }
    }
  },
  [121] = {
    id = 121,
    Type = "shakescreen",
    Params = {amplitude = 10, time = 4000}
  },
  [122] = {
    id = 122,
    Type = "dialog",
    Params = {
      dialog = {750698}
    }
  },
  [123] = {
    id = 123,
    Type = "talk",
    Params = {npcuid = 808044, talkid = 750699}
  },
  [124] = {
    id = 124,
    Type = "play_sound",
    Params = {
      path = "Common/Task_Shiny"
    }
  },
  [125] = {
    id = 125,
    Type = "action",
    Params = {npcuid = 808039, id = 508}
  },
  [126] = {
    id = 126,
    Type = "wait_time",
    Params = {time = 2000}
  },
  [127] = {
    id = 127,
    Type = "play_effect_scene",
    Params = {
      id = 109,
      path = "Skill/MonsterInvincible",
      pos = {
        -3.91,
        2.78,
        3.84
      }
    }
  },
  [128] = {
    id = 128,
    Type = "shakescreen",
    Params = {amplitude = 10, time = 4000}
  },
  [129] = {
    id = 129,
    Type = "dialog",
    Params = {
      dialog = {750700}
    }
  },
  [130] = {
    id = 130,
    Type = "change_bgm",
    Params = {
      path = "Task_xingyunsiyecao",
      time = 0
    }
  },
  [131] = {
    id = 131,
    Type = "talk",
    Params = {npcuid = 808044, talkid = 750701}
  },
  [132] = {
    id = 132,
    Type = "dialog",
    Params = {
      dialog = {750701}
    }
  },
  [133] = {
    id = 133,
    Type = "talk",
    Params = {npcuid = 808044, talkid = 750702}
  },
  [134] = {
    id = 134,
    Type = "dialog",
    Params = {
      dialog = {750702}
    }
  },
  [135] = {
    id = 135,
    Type = "talk",
    Params = {npcuid = 808044, talkid = 750703}
  },
  [136] = {
    id = 136,
    Type = "dialog",
    Params = {
      dialog = {750703}
    }
  },
  [137] = {
    id = 137,
    Type = "play_sound",
    Params = {
      path = "Common/Task_Shiny"
    }
  },
  [138] = {
    id = 138,
    Type = "action",
    Params = {npcuid = 808039, id = 510}
  },
  [139] = {
    id = 139,
    Type = "wait_time",
    Params = {time = 2000}
  },
  [140] = {
    id = 140,
    Type = "play_effect_scene",
    Params = {
      id = 110,
      path = "Skill/MonsterInvincible",
      pos = {
        -7.88,
        2.78,
        -2.29
      }
    }
  },
  [141] = {
    id = 141,
    Type = "shakescreen",
    Params = {amplitude = 10, time = 4000}
  },
  [142] = {
    id = 142,
    Type = "dialog",
    Params = {
      dialog = {750704}
    }
  },
  [143] = {
    id = 143,
    Type = "dialog",
    Params = {
      dialog = {750705}
    }
  },
  [144] = {
    id = 144,
    Type = "dialog",
    Params = {
      dialog = {750706}
    }
  },
  [145] = {
    id = 145,
    Type = "play_effect_scene",
    Params = {
      id = 21,
      path = "Skill/MagicRod_buff",
      pos = {
        -7.87,
        2.77,
        1.76
      }
    }
  },
  [146] = {
    id = 146,
    Type = "play_effect_scene",
    Params = {
      id = 22,
      path = "Skill/MagicRod_buff",
      pos = {
        -3.93,
        2.78,
        -4.36
      }
    }
  },
  [147] = {
    id = 147,
    Type = "play_effect_scene",
    Params = {
      id = 23,
      path = "Skill/MagicRod_buff",
      pos = {
        -0.08,
        2.78,
        1.69
      }
    }
  },
  [148] = {
    id = 148,
    Type = "play_effect_scene",
    Params = {
      id = 24,
      path = "Skill/MagicRod_buff",
      pos = {
        -0.11,
        2.78,
        -2.23
      }
    }
  },
  [149] = {
    id = 149,
    Type = "play_effect_scene",
    Params = {
      id = 25,
      path = "Skill/MagicRod_buff",
      pos = {
        -3.91,
        2.78,
        3.84
      }
    }
  },
  [150] = {
    id = 150,
    Type = "play_effect_scene",
    Params = {
      id = 26,
      path = "Skill/MagicRod_buff",
      pos = {
        -7.88,
        2.78,
        -2.29
      }
    }
  },
  [151] = {
    id = 151,
    Type = "talk",
    Params = {npcuid = 808040, talkid = 750707}
  },
  [152] = {
    id = 152,
    Type = "talk",
    Params = {npcuid = 808043, talkid = 750708}
  },
  [153] = {
    id = 153,
    Type = "talk",
    Params = {npcuid = 808045, talkid = 750709}
  },
  [154] = {
    id = 154,
    Type = "talk",
    Params = {npcuid = 808041, talkid = 750710}
  },
  [155] = {
    id = 155,
    Type = "talk",
    Params = {npcuid = 808042, talkid = 750711}
  },
  [156] = {
    id = 156,
    Type = "talk",
    Params = {npcuid = 808044, talkid = 750712}
  },
  [157] = {
    id = 157,
    Type = "action",
    Params = {
      npcuid = 808040,
      id = 22,
      loop = true
    }
  },
  [158] = {
    id = 158,
    Type = "action",
    Params = {
      npcuid = 808041,
      id = 22,
      loop = true
    }
  },
  [159] = {
    id = 159,
    Type = "action",
    Params = {
      npcuid = 808042,
      id = 22,
      loop = true
    }
  },
  [160] = {
    id = 160,
    Type = "action",
    Params = {
      npcuid = 808043,
      id = 22,
      loop = true
    }
  },
  [161] = {
    id = 161,
    Type = "action",
    Params = {
      npcuid = 808044,
      id = 22,
      loop = true
    }
  },
  [162] = {
    id = 162,
    Type = "action",
    Params = {
      npcuid = 808045,
      id = 22,
      loop = true
    }
  },
  [163] = {
    id = 163,
    Type = "play_sound",
    Params = {
      path = "Common/GodPower"
    }
  },
  [164] = {
    id = 164,
    Type = "play_effect_scene",
    Params = {
      id = 71,
      path = "Common/GodPower",
      pos = {
        -3.61,
        2.32,
        -0.37
      },
      onshot = 1
    }
  },
  [165] = {
    id = 165,
    Type = "wait_time",
    Params = {time = 2000}
  },
  [166] = {
    id = 166,
    Type = "action",
    Params = {npcuid = 808040, id = 25}
  },
  [167] = {
    id = 167,
    Type = "action",
    Params = {npcuid = 808041, id = 25}
  },
  [168] = {
    id = 168,
    Type = "action",
    Params = {npcuid = 808042, id = 25}
  },
  [169] = {
    id = 169,
    Type = "action",
    Params = {npcuid = 808043, id = 25}
  },
  [170] = {
    id = 170,
    Type = "action",
    Params = {npcuid = 808044, id = 25}
  },
  [171] = {
    id = 171,
    Type = "action",
    Params = {npcuid = 808045, id = 25}
  },
  [172] = {
    id = 172,
    Type = "play_effect_scene",
    Params = {
      id = 7,
      path = "Skill/CrazySlave_Atk",
      pos = {
        -3.77,
        2.01,
        -0.27
      },
      onshot = 1
    }
  },
  [173] = {
    id = 173,
    Type = "action",
    Params = {player = 1, id = 0}
  },
  [174] = {
    id = 174,
    Type = "addbutton",
    Params = {
      id = 1,
      text = "##298178",
      eventtype = "goon"
    }
  },
  [175] = {
    id = 175,
    Type = "wait_ui",
    Params = {button = 1}
  },
  [176] = {
    id = 176,
    Type = "action",
    Params = {
      player = 1,
      id = 22,
      loop = true
    }
  },
  [177] = {
    id = 177,
    Type = "play_effect_scene",
    Params = {
      id = 8,
      path = "Common/DrawMagicCircle",
      pos = {
        -3.77,
        2.01,
        -0.27
      }
    }
  },
  [178] = {
    id = 178,
    Type = "wait_time",
    Params = {time = 1000}
  },
  [179] = {
    id = 179,
    Type = "talk",
    Params = {npcuid = 808040, talkid = 750713}
  },
  [180] = {
    id = 180,
    Type = "talk",
    Params = {npcuid = 808043, talkid = 750714}
  },
  [181] = {
    id = 181,
    Type = "wait_time",
    Params = {time = 2000}
  },
  [182] = {
    id = 182,
    Type = "addbutton",
    Params = {
      id = 2,
      text = "##298178",
      eventtype = "goon"
    }
  },
  [183] = {
    id = 183,
    Type = "wait_ui",
    Params = {button = 2}
  },
  [184] = {
    id = 184,
    Type = "play_effect_scene",
    Params = {
      id = 9,
      path = "Common/Eff_Gravitational_buff",
      pos = {
        -3.81,
        1.84,
        -0.36
      }
    }
  },
  [185] = {
    id = 185,
    Type = "wait_time",
    Params = {time = 1000}
  },
  [186] = {
    id = 186,
    Type = "talk",
    Params = {npcuid = 808044, talkid = 750715}
  },
  [187] = {
    id = 187,
    Type = "talk",
    Params = {npcuid = 808045, talkid = 750716}
  },
  [188] = {
    id = 188,
    Type = "wait_time",
    Params = {time = 2000}
  },
  [189] = {
    id = 189,
    Type = "addbutton",
    Params = {
      id = 3,
      text = "##298178",
      eventtype = "goon"
    }
  },
  [190] = {
    id = 190,
    Type = "wait_ui",
    Params = {button = 3}
  },
  [191] = {
    id = 191,
    Type = "action",
    Params = {player = 1, id = 25}
  },
  [192] = {
    id = 192,
    Type = "play_effect_scene",
    Params = {
      id = 10,
      path = "Skill/SectorCut_atk",
      pos = {
        -3.49,
        2.23,
        -0.3
      },
      onshot = 1
    }
  },
  [193] = {
    id = 193,
    Type = "wait_time",
    Params = {time = 1000}
  },
  [194] = {
    id = 194,
    Type = "talk",
    Params = {npcuid = 808041, talkid = 750717}
  },
  [195] = {
    id = 195,
    Type = "talk",
    Params = {npcuid = 808042, talkid = 750718}
  },
  [196] = {
    id = 196,
    Type = "wait_time",
    Params = {time = 2000}
  },
  [197] = {
    id = 197,
    Type = "play_effect_scene",
    Params = {
      id = 11,
      path = "Skill/Detonator_slow",
      pos = {
        -7.87,
        2.77,
        1.76
      },
      onshot = 1
    }
  },
  [198] = {
    id = 198,
    Type = "play_effect_scene",
    Params = {
      id = 12,
      path = "Skill/Detonator_slow",
      pos = {
        -3.93,
        2.78,
        -4.36
      },
      onshot = 1
    }
  },
  [199] = {
    id = 199,
    Type = "play_effect_scene",
    Params = {
      id = 13,
      path = "Skill/Detonator_slow",
      pos = {
        -0.08,
        2.78,
        1.69
      },
      onshot = 1
    }
  },
  [200] = {
    id = 200,
    Type = "play_effect_scene",
    Params = {
      id = 14,
      path = "Skill/Detonator_slow",
      pos = {
        -0.11,
        2.78,
        -2.23
      },
      onshot = 1
    }
  },
  [201] = {
    id = 201,
    Type = "play_effect_scene",
    Params = {
      id = 15,
      path = "Skill/Detonator_slow",
      pos = {
        -3.91,
        2.78,
        3.84
      },
      onshot = 1
    }
  },
  [202] = {
    id = 202,
    Type = "play_effect_scene",
    Params = {
      id = 16,
      path = "Skill/Detonator_slow",
      pos = {
        -7.88,
        2.78,
        -2.29
      },
      onshot = 1
    }
  },
  [203] = {
    id = 203,
    Type = "wait_time",
    Params = {time = 1000}
  },
  [204] = {
    id = 204,
    Type = "remove_npc",
    Params = {npcuid = 808040}
  },
  [205] = {
    id = 205,
    Type = "remove_npc",
    Params = {npcuid = 808043}
  },
  [206] = {
    id = 206,
    Type = "remove_npc",
    Params = {npcuid = 808045}
  },
  [207] = {
    id = 207,
    Type = "remove_npc",
    Params = {npcuid = 808041}
  },
  [208] = {
    id = 208,
    Type = "remove_npc",
    Params = {npcuid = 808042}
  },
  [209] = {
    id = 209,
    Type = "remove_npc",
    Params = {npcuid = 808044}
  },
  [210] = {
    id = 210,
    Type = "remove_effect_scene",
    Params = {id = 102}
  },
  [211] = {
    id = 211,
    Type = "remove_effect_scene",
    Params = {id = 202}
  },
  [212] = {
    id = 212,
    Type = "remove_effect_scene",
    Params = {id = 302}
  },
  [213] = {
    id = 213,
    Type = "remove_effect_scene",
    Params = {id = 402}
  },
  [214] = {
    id = 214,
    Type = "remove_effect_scene",
    Params = {id = 502}
  },
  [215] = {
    id = 215,
    Type = "remove_effect_scene",
    Params = {id = 602}
  },
  [216] = {
    id = 216,
    Type = "remove_effect_scene",
    Params = {id = 105}
  },
  [217] = {
    id = 217,
    Type = "remove_effect_scene",
    Params = {id = 106}
  },
  [218] = {
    id = 218,
    Type = "remove_effect_scene",
    Params = {id = 107}
  },
  [219] = {
    id = 219,
    Type = "remove_effect_scene",
    Params = {id = 108}
  },
  [220] = {
    id = 220,
    Type = "remove_effect_scene",
    Params = {id = 109}
  },
  [221] = {
    id = 221,
    Type = "remove_effect_scene",
    Params = {id = 110}
  },
  [222] = {
    id = 222,
    Type = "remove_effect_scene",
    Params = {id = 21}
  },
  [223] = {
    id = 223,
    Type = "remove_effect_scene",
    Params = {id = 22}
  },
  [224] = {
    id = 224,
    Type = "remove_effect_scene",
    Params = {id = 23}
  },
  [225] = {
    id = 225,
    Type = "remove_effect_scene",
    Params = {id = 24}
  },
  [226] = {
    id = 226,
    Type = "remove_effect_scene",
    Params = {id = 25}
  },
  [227] = {
    id = 227,
    Type = "remove_effect_scene",
    Params = {id = 26}
  },
  [228] = {
    id = 228,
    Type = "play_sound",
    Params = {
      path = "Common/JobChange"
    }
  },
  [229] = {
    id = 229,
    Type = "play_effect_scene",
    Params = {
      id = 116,
      path = "Common/JobChange",
      pos = {
        -3.94,
        2.27,
        -0.33
      },
      onshot = 1
    }
  },
  [230] = {
    id = 230,
    Type = "wait_time",
    Params = {time = 3000}
  },
  [231] = {
    id = 231,
    Type = "play_effect_scene",
    Params = {
      id = 126,
      path = "Skill/BlessingFaith_buff1",
      pos = {
        -3.77,
        2.01,
        -0.27
      }
    }
  },
  [232] = {
    id = 232,
    Type = "wait_time",
    Params = {time = 1000}
  },
  [233] = {
    id = 233,
    Type = "dialog",
    Params = {
      dialog = {750719}
    }
  },
  [234] = {
    id = 234,
    Type = "dialog",
    Params = {
      dialog = {750720}
    }
  },
  [235] = {
    id = 235,
    Type = "camera_filter",
    Params = {filterid = 5, on = 0}
  },
  [236] = {
    id = 236,
    Type = "showview",
    Params = {panelid = 800, showtype = 2}
  },
  [237] = {
    id = 237,
    Type = "endfilter",
    Params = {
      fliter = {39}
    }
  }
}
Table_PlotQuest_68_fields = {
  "id",
  "Type",
  "Params"
}
return Table_PlotQuest_68
