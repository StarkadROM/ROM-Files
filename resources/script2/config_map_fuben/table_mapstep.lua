Table_MapStep = {
  [1] = {
    id = 1,
    Content = "summon",
    Params = {
      id = 811000,
      pos = {
        1.33,
        -20.36,
        -135.32
      },
      dir = 137.72,
      group_id = 1
    },
    MapID = 102,
    StartCondition = {after_kill_elite = 1000}
  },
  [2] = {
    id = 2,
    Content = "visit",
    Params = {
      npc = 811000,
      dialog = {350100},
      distance = 3,
      record_char = 1,
      ShowSymbol = 1
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [3] = {
    id = 3,
    Content = "dialog",
    Params = {
      dialog = {350101},
      spec_char = 1,
      limit_time = 3
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [4] = {
    id = 4,
    Content = "dialog",
    Params = {
      dialog = {350102, 350129},
      spec_char = 1,
      limit_time = 3
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [5] = {
    id = 5,
    Content = "clearnpc",
    Params = {
      group_ids = {1}
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [6] = {
    id = 6,
    Content = "multigm",
    Params = {
      type = "follower",
      id = 811000,
      time = 300,
      behavior = 1,
      spec_char = 1,
      only_in_map = 1
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [7] = {
    id = 7,
    Content = "move",
    Params = {
      pos = {
        -28.7,
        1.15,
        -51.07
      },
      distance = 3,
      limit_time = 300,
      spec_char = 1,
      fail_on_leave = 1
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [8] = {
    id = 8,
    Content = "dialog",
    Params = {
      dialog = {350103},
      spec_char = 1,
      limit_time = 3
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [9] = {
    id = 9,
    Content = "multigm",
    Params = {
      type = "follower",
      clear = 811000,
      spec_char = 1
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [10] = {
    id = 10,
    Content = "multigm",
    Params = {
      type = "follower",
      clear = 811000,
      spec_char = 1
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [11] = {
    id = 11,
    Content = "summon",
    Params = {
      id = 811000,
      pos = {
        -28.7,
        1.15,
        -51.07
      },
      dir = 203,
      group_id = 4
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [12] = {
    id = 12,
    Content = "dialog",
    Params = {
      dialog = {350104},
      spec_char = 1,
      limit_time = 3
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [13] = {
    id = 13,
    Content = "summon",
    Params = {
      id = 811001,
      pos = {
        103.92,
        -21.78,
        -139.52
      },
      dir = 161.56,
      group_id = 2
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [14] = {
    id = 14,
    Content = "visit",
    Params = {
      npc = 811001,
      dialog = {350105},
      distance = 3,
      record_char = 1,
      ShowSymbol = 1
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [15] = {
    id = 15,
    Content = "dialog",
    Params = {
      dialog = {350106},
      spec_char = 1,
      limit_time = 3
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [16] = {
    id = 16,
    Content = "dialog",
    Params = {
      dialog = {350107, 350130},
      spec_char = 1,
      limit_time = 3
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [17] = {
    id = 17,
    Content = "clearnpc",
    Params = {
      group_ids = {2}
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [18] = {
    id = 18,
    Content = "multigm",
    Params = {
      type = "follower",
      id = 811001,
      time = 300,
      behavior = 1,
      spec_char = 1,
      only_in_map = 1
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [19] = {
    id = 19,
    Content = "move",
    Params = {
      pos = {
        -28.7,
        1.15,
        -51.07
      },
      distance = 3,
      limit_time = 300,
      spec_char = 1,
      fail_on_leave = 1
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [20] = {
    id = 20,
    Content = "dialog",
    Params = {
      dialog = {350108},
      spec_char = 1,
      limit_time = 3
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [21] = {
    id = 21,
    Content = "multigm",
    Params = {
      type = "follower",
      clear = 811001,
      spec_char = 1
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [22] = {
    id = 22,
    Content = "multigm",
    Params = {
      type = "follower",
      clear = 811001,
      spec_char = 1
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [23] = {
    id = 23,
    Content = "summon",
    Params = {
      id = 811001,
      pos = {
        -25.84,
        1.153,
        -53.39
      },
      dir = 240,
      group_id = 4
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [24] = {
    id = 24,
    Content = "dialog",
    Params = {
      dialog = {350109},
      spec_char = 1,
      limit_time = 3
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [25] = {
    id = 25,
    Content = "summon",
    Params = {
      id = 811002,
      pos = {
        74,
        -21.78,
        -188.84
      },
      dir = 324.27,
      group_id = 3
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [26] = {
    id = 26,
    Content = "visit",
    Params = {
      npc = 811002,
      dialog = {350110},
      distance = 3,
      record_char = 1,
      ShowSymbol = 1
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [27] = {
    id = 27,
    Content = "dialog",
    Params = {
      dialog = {350111},
      spec_char = 1,
      limit_time = 3
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [28] = {
    id = 28,
    Content = "dialog",
    Params = {
      dialog = {350112, 350131},
      spec_char = 1,
      limit_time = 3
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [29] = {
    id = 29,
    Content = "clearnpc",
    Params = {
      group_ids = {3}
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [30] = {
    id = 30,
    Content = "multigm",
    Params = {
      type = "follower",
      id = 811002,
      time = 300,
      behavior = 1,
      spec_char = 1,
      only_in_map = 1
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [31] = {
    id = 31,
    Content = "move",
    Params = {
      pos = {
        -28.7,
        1.15,
        -51.07
      },
      distance = 3,
      limit_time = 300,
      spec_char = 1,
      fail_on_leave = 1
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [32] = {
    id = 32,
    Content = "dialog",
    Params = {
      dialog = {350113},
      spec_char = 1,
      limit_time = 3
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [33] = {
    id = 33,
    Content = "multigm",
    Params = {
      type = "follower",
      clear = 811002,
      spec_char = 1
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [34] = {
    id = 34,
    Content = "multigm",
    Params = {
      type = "follower",
      clear = 811002,
      spec_char = 1
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [35] = {
    id = 35,
    Content = "summon",
    Params = {
      id = 811002,
      pos = {
        -32,
        1.153,
        -50.58
      },
      dir = 157.76,
      group_id = 4
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [36] = {
    id = 36,
    Content = "dialog",
    Params = {
      dialog = {350114},
      spec_char = 1,
      limit_time = 3
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [37] = {
    id = 37,
    Content = "wait",
    Params = {time = 3},
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [38] = {
    id = 38,
    Content = "multigm",
    Params = {
      type = "npctalk",
      talkid = 350115,
      npcid = 811000,
      sync = 0
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [39] = {
    id = 39,
    Content = "wait",
    Params = {time = 2},
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [40] = {
    id = 40,
    Content = "multigm",
    Params = {
      type = "npctalk",
      talkid = 350116,
      npcid = 811001,
      sync = 0
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [41] = {
    id = 41,
    Content = "wait",
    Params = {time = 2},
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [42] = {
    id = 42,
    Content = "multigm",
    Params = {
      type = "npctalk",
      talkid = 350117,
      npcid = 811002,
      sync = 0
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [43] = {
    id = 43,
    Content = "wait",
    Params = {time = 3},
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [44] = {
    id = 44,
    Content = "multigm",
    Params = {
      type = "npctalk",
      talkid = 350118,
      npcid = 811000,
      sync = 0
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [45] = {
    id = 45,
    Content = "wait",
    Params = {time = 2},
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [46] = {
    id = 46,
    Content = "multigm",
    Params = {
      type = "npctalk",
      talkid = 350119,
      npcid = 811001,
      sync = 0
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [47] = {
    id = 47,
    Content = "multigm",
    Params = {
      type = "npctalk",
      talkid = 350120,
      npcid = 811002,
      sync = 0
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [48] = {
    id = 48,
    Content = "wait",
    Params = {time = 3},
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [49] = {
    id = 49,
    Content = "multigm",
    Params = {
      type = "effect",
      effect = "Common/16TeleportPoint",
      opt = "add",
      pos = {
        -28.7,
        1.15,
        -51.07
      },
      times = 0,
      index = 1
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [50] = {
    id = 50,
    Content = "multigm",
    Params = {
      type = "effect",
      effect = "Common/16TeleportPoint",
      opt = "add",
      pos = {
        -25.84,
        1.153,
        -53.39
      },
      times = 0,
      index = 2
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [51] = {
    id = 51,
    Content = "multigm",
    Params = {
      type = "effect",
      effect = "Common/16TeleportPoint",
      opt = "add",
      pos = {
        -32,
        1.153,
        -50.58
      },
      times = 0,
      index = 3
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [52] = {
    id = 52,
    Content = "wait",
    Params = {time = 2},
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [53] = {
    id = 53,
    Content = "multigm",
    Params = {
      type = "npctalk",
      talkid = 350134,
      npcid = 811001,
      sync = 0
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [54] = {
    id = 54,
    Content = "wait",
    Params = {time = 2},
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [55] = {
    id = 55,
    Content = "multigm",
    Params = {
      type = "npctalk",
      talkid = 350135,
      npcid = 811002,
      sync = 0
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [56] = {
    id = 56,
    Content = "wait",
    Params = {time = 2},
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [57] = {
    id = 57,
    Content = "multigm",
    Params = {
      type = "npctalk",
      talkid = 350136,
      npcid = 811000,
      sync = 0
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [58] = {
    id = 58,
    Content = "wait",
    Params = {time = 2},
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [59] = {
    id = 59,
    Content = "clearnpc",
    Params = {
      group_ids = {4}
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [60] = {
    id = 60,
    Content = "summon",
    Params = {
      id = 280340,
      pos = {
        -28.7,
        1.15,
        -51.07
      },
      dir = 203,
      group_id = 5
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [61] = {
    id = 61,
    Content = "summon",
    Params = {
      id = 280341,
      pos = {
        -25.84,
        1.153,
        -53.39
      },
      dir = 240,
      group_id = 5
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [62] = {
    id = 62,
    Content = "summon",
    Params = {
      id = 280342,
      pos = {
        -32,
        1.153,
        -50.58
      },
      dir = 157.76,
      group_id = 5
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [63] = {
    id = 63,
    Content = "multigm",
    Params = {
      type = "effect",
      effect = "Common/16TeleportPoint",
      opt = "delete",
      index = 1
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [64] = {
    id = 64,
    Content = "multigm",
    Params = {
      type = "effect",
      effect = "Common/16TeleportPoint",
      opt = "delete",
      index = 2
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [65] = {
    id = 65,
    Content = "multigm",
    Params = {
      type = "effect",
      effect = "Common/16TeleportPoint",
      opt = "delete",
      index = 3
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [66] = {
    id = 66,
    Content = "multigm",
    Params = {
      type = "effect",
      effect = "Common/16TeleportPoint",
      opt = "add",
      npcid = 280340,
      times = 0,
      index = 4
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [67] = {
    id = 67,
    Content = "multigm",
    Params = {
      type = "effect",
      effect = "Common/16TeleportPoint",
      opt = "add",
      npcid = 280341,
      times = 0,
      index = 5
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [68] = {
    id = 68,
    Content = "multigm",
    Params = {
      type = "effect",
      effect = "Common/16TeleportPoint",
      opt = "add",
      npcid = 280342,
      times = 0,
      index = 6
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [69] = {
    id = 69,
    Content = "killmonster",
    Params = {
      npcid = {
        280340,
        280341,
        280342
      },
      num = 3
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [70] = {
    id = 70,
    Content = "stop_other",
    Params = _EmptyTable,
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [71] = {
    id = 71,
    Content = "clearnpc",
    Params = {
      group_ids = {5}
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [72] = {
    id = 72,
    Content = "summon",
    Params = {
      id = 811000,
      pos = {
        -28.7,
        1.15,
        -51.07
      },
      dir = 203,
      group_id = 6
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [73] = {
    id = 73,
    Content = "summon",
    Params = {
      id = 811001,
      pos = {
        -25.84,
        1.153,
        -53.39
      },
      dir = 240,
      group_id = 6
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [74] = {
    id = 74,
    Content = "summon",
    Params = {
      id = 811002,
      pos = {
        -32,
        1.153,
        -50.58
      },
      dir = 157.76,
      group_id = 6
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [75] = {
    id = 75,
    Content = "wait",
    Params = {time = 2},
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [76] = {
    id = 76,
    Content = "multigm",
    Params = {
      type = "npctalk",
      talkid = 350127,
      npcid = 811000,
      sync = 0
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [77] = {
    id = 77,
    Content = "wait",
    Params = {time = 1},
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [78] = {
    id = 78,
    Content = "multigm",
    Params = {
      type = "playaction",
      style = 3,
      id = 7,
      npcid = 811000
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [79] = {
    id = 79,
    Content = "multigm",
    Params = {
      type = "playaction",
      style = 3,
      id = 7,
      npcid = 811001
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [80] = {
    id = 80,
    Content = "multigm",
    Params = {
      type = "playaction",
      style = 3,
      id = 7,
      npcid = 811002
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [81] = {
    id = 81,
    Content = "wait",
    Params = {time = 1},
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [82] = {
    id = 82,
    Content = "clearnpc",
    Params = {
      group_ids = {6}
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [83] = {
    id = 83,
    Content = "wait_refresh",
    Params = {time = 5, no_stat_num = 1},
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [84] = {
    id = 84,
    Content = "wait",
    Params = {time = 12},
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [85] = {
    id = 85,
    Content = "clearnpc",
    Params = {
      group_ids = {5}
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [86] = {
    id = 86,
    Content = "summon",
    Params = {
      id = 811000,
      pos = {
        -28.7,
        1.15,
        -51.07
      },
      dir = 203,
      group_id = 7
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [87] = {
    id = 87,
    Content = "summon",
    Params = {
      id = 811001,
      pos = {
        -25.84,
        1.153,
        -53.39
      },
      dir = 240,
      group_id = 7
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [88] = {
    id = 88,
    Content = "summon",
    Params = {
      id = 811002,
      pos = {
        -32,
        1.153,
        -50.58
      },
      dir = 157.76,
      group_id = 7
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [89] = {
    id = 89,
    Content = "multigm",
    Params = {
      type = "effect",
      effect = "Common/16TeleportPoint",
      opt = "add",
      npcid = 811000,
      times = 0,
      index = 7
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [90] = {
    id = 90,
    Content = "multigm",
    Params = {
      type = "effect",
      effect = "Common/16TeleportPoint",
      opt = "add",
      npcid = 811001,
      times = 0,
      index = 8
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [91] = {
    id = 91,
    Content = "multigm",
    Params = {
      type = "effect",
      effect = "Common/16TeleportPoint",
      opt = "add",
      npcid = 811002,
      times = 0,
      index = 9
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [92] = {
    id = 92,
    Content = "wait",
    Params = {time = 2},
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [93] = {
    id = 93,
    Content = "multigm",
    Params = {
      type = "effect",
      effect = "Common/26TeleportPointP",
      opt = "add",
      pos = {
        -30.2,
        1.253,
        -54.94
      },
      times = 0,
      index = 10
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [94] = {
    id = 94,
    Content = "multigm",
    Params = {
      type = "effect",
      effect = "Common/16TeleportPoint",
      opt = "delete",
      index = 7
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [95] = {
    id = 95,
    Content = "multigm",
    Params = {
      type = "effect",
      effect = "Common/16TeleportPoint",
      opt = "delete",
      index = 8
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [96] = {
    id = 96,
    Content = "multigm",
    Params = {
      type = "effect",
      effect = "Common/16TeleportPoint",
      opt = "delete",
      index = 9
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [97] = {
    id = 97,
    Content = "wait",
    Params = {time = 1},
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [98] = {
    id = 98,
    Content = "multigm",
    Params = {
      type = "npctalk",
      talkid = 350121,
      npcid = 811000,
      sync = 0
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [99] = {
    id = 99,
    Content = "wait",
    Params = {time = 2},
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [100] = {
    id = 100,
    Content = "multigm",
    Params = {
      type = "effect",
      effect = "Common/26TeleportPointP",
      opt = "delete",
      index = 10
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [101] = {
    id = 101,
    Content = "summon",
    Params = {
      id = 811090,
      pos = {
        -30.2,
        1.253,
        -54.94
      },
      dir = 23.91,
      fadein = 1,
      group_id = 10
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [102] = {
    id = 102,
    Content = "multigm",
    Params = {
      type = "effect",
      effect = "Common/MaxViewOn",
      opt = "add",
      pos = {
        -30.2,
        1.253,
        -54.94
      },
      times = 1,
      index = 11
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [103] = {
    id = 103,
    Content = "wait",
    Params = {time = 2},
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [104] = {
    id = 104,
    Content = "multigm",
    Params = {
      type = "npctalk",
      talkid = 350122,
      npcid = 811001,
      sync = 0
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [105] = {
    id = 105,
    Content = "multigm",
    Params = {
      type = "npctalk",
      talkid = 350123,
      npcid = 811002,
      sync = 0
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [106] = {
    id = 106,
    Content = "wait",
    Params = {time = 2},
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [107] = {
    id = 107,
    Content = "multigm",
    Params = {
      type = "playaction",
      style = 1,
      id = 5,
      npcid = 811090
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [108] = {
    id = 108,
    Content = "wait",
    Params = {time = 2},
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [109] = {
    id = 109,
    Content = "multigm",
    Params = {
      type = "npctalk",
      talkid = 350124,
      npcid = 811000,
      sync = 0
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [110] = {
    id = 110,
    Content = "wait",
    Params = {time = 1},
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [111] = {
    id = 111,
    Content = "multigm",
    Params = {
      type = "playaction",
      style = 3,
      id = 11,
      npcid = 811090
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [112] = {
    id = 112,
    Content = "wait",
    Params = {time = 1},
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [113] = {
    id = 113,
    Content = "multigm",
    Params = {
      type = "npctalk",
      talkid = 350125,
      npcid = 811001,
      sync = 0
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [114] = {
    id = 114,
    Content = "multigm",
    Params = {
      type = "npctalk",
      talkid = 350126,
      npcid = 811002,
      sync = 0
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [115] = {
    id = 115,
    Content = "multigm",
    Params = {
      type = "playaction",
      style = 3,
      id = 7,
      npcid = 811000
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [116] = {
    id = 116,
    Content = "multigm",
    Params = {
      type = "playaction",
      style = 3,
      id = 7,
      npcid = 811001
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [117] = {
    id = 117,
    Content = "multigm",
    Params = {
      type = "playaction",
      style = 3,
      id = 7,
      npcid = 811002
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [118] = {
    id = 118,
    Content = "wait",
    Params = {time = 1},
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [119] = {
    id = 119,
    Content = "clearnpc",
    Params = {
      group_ids = {7}
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [120] = {
    id = 120,
    Content = "multigm",
    Params = {
      type = "npctalk",
      talkid = 350128,
      npcid = 811090,
      sync = 0
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [121] = {
    id = 121,
    Content = "wait",
    Params = {time = 3},
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [122] = {
    id = 122,
    Content = "multigm",
    Params = {
      type = "npctalk",
      talkid = 350132,
      npcid = 811090,
      sync = 0
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [123] = {
    id = 123,
    Content = "wait",
    Params = {time = 3},
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [124] = {
    id = 124,
    Content = "multigm",
    Params = {
      type = "npctalk",
      talkid = 350133,
      npcid = 811090,
      sync = 0
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [125] = {
    id = 125,
    Content = "wait",
    Params = {time = 3},
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [126] = {
    id = 126,
    Content = "clearnpc",
    Params = {
      group_ids = {10}
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [127] = {
    id = 127,
    Content = "summon",
    Params = {
      id = 280301,
      pos = {
        -30.2,
        1.253,
        -54.94
      },
      dir = 23.91,
      group_id = 8,
      dead_disp_time = 5
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [128] = {
    id = 128,
    Content = "killall",
    Params = {
      group_ids = {8}
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [129] = {
    id = 129,
    Content = "wait_refresh",
    Params = {time = 900},
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [130] = {
    id = 130,
    Content = "summon",
    Params = {
      id = 280302,
      pos = {
        20.82,
        0.03,
        -23.63
      },
      dir = 150,
      territory = 0,
      search = 0,
      group_id = 1,
      dead_disp_time = 5
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [131] = {
    id = 131,
    Content = "multigm",
    Params = {
      type = "effect",
      effect = "Common/MaxViewOn",
      opt = "add",
      pos = {
        20.82,
        0.03,
        -23.63
      },
      times = 1,
      index = 12
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [132] = {
    id = 132,
    Content = "weather",
    Params = {
      weather_id = {
        1,
        2,
        3,
        39,
        40,
        46,
        47,
        53
      }
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [133] = {
    id = 133,
    Content = "summon",
    Params = {
      id = 811003,
      pos = {
        23.2,
        0.03,
        -24.23
      },
      group_id = 2
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [134] = {
    id = 134,
    Content = "useskill",
    Params = {
      skillid = 40058,
      pos = {
        20.82,
        0.03,
        -23.63
      },
      distance = 6
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [135] = {
    id = 135,
    Content = "summon",
    Params = {
      id = 811003,
      pos = {
        23.2,
        0.03,
        -24.23
      },
      group_id = 2
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [136] = {
    id = 136,
    Content = "killall",
    Params = {
      group_ids = {1}
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [137] = {
    id = 137,
    Content = "clearnpc",
    Params = {
      group_ids = {2}
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [138] = {
    id = 138,
    Content = "wait_refresh",
    Params = {time = 900},
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [139] = {
    id = 139,
    Content = "weather",
    Params = {
      weather_id = {
        1,
        2,
        3,
        39,
        40,
        46,
        47,
        53
      }
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [140] = {
    id = 140,
    Content = "multigm",
    Params = {
      type = "npctalk",
      talkid = 350200,
      npcid = 280302,
      sync = 0
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [141] = {
    id = 141,
    Content = "wait",
    Params = {time = 120},
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [142] = {
    id = 142,
    Content = "weather",
    Params = {
      not_id = {
        1,
        2,
        3,
        39,
        40,
        46,
        47,
        53
      }
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [143] = {
    id = 143,
    Content = "multigm",
    Params = {
      type = "npctalk",
      talkid = 350201,
      npcid = 280302,
      sync = 0
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [144] = {
    id = 144,
    Content = "wait",
    Params = {time = 120},
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [145] = {
    id = 145,
    Content = "useskill",
    Params = {
      skillid = 40073,
      pos = {
        20.82,
        0.03,
        -23.63
      },
      distance = 6
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [146] = {
    id = 146,
    Content = "summon",
    Params = {
      id = 811003,
      pos = {
        23.2,
        0.03,
        -24.23
      },
      group_id = 2
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [147] = {
    id = 147,
    Content = "summon",
    Params = {
      id = 280303,
      pos = {
        71.34,
        -21.78,
        -169.58
      },
      group_id = 1,
      dead_disp_time = 5
    },
    MapID = 102,
    StartCondition = {after_kill_elite = 5000}
  },
  [148] = {
    id = 148,
    Content = "multigm",
    Params = {
      type = "effect",
      effect = "Common/MaxViewOn",
      opt = "add",
      pos = {
        71.34,
        -21.78,
        -169.58
      },
      times = 1,
      index = 13
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [149] = {
    id = 149,
    Content = "killall",
    Params = {
      group_ids = {1}
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [150] = {
    id = 150,
    Content = "wait_refresh",
    Params = {exactly_divide_minute = 30},
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [151] = {
    id = 151,
    Content = "summon",
    Params = {
      id = 811004,
      pos = {
        40.6,
        -20.36,
        -150.08
      },
      dir = 245,
      group_id = 1
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [152] = {
    id = 152,
    Content = "stepvisit",
    Params = {
      npc = 811004,
      dialog = {
        350400,
        350401,
        350402,
        350403,
        350404,
        350405,
        350406,
        350408
      },
      distance = 2
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [153] = {
    id = 153,
    Content = "wait",
    Params = {time = 2},
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [154] = {
    id = 154,
    Content = "clearnpc",
    Params = {
      group_ids = {1}
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [155] = {
    id = 155,
    Content = "summon",
    Params = {
      id = 280304,
      pos = {
        40.6,
        -20.36,
        -150.08
      },
      group_id = 2,
      dead_disp_time = 5
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [156] = {
    id = 156,
    Content = "multigm",
    Params = {
      type = "effect",
      effect = "Common/MaxViewOn",
      opt = "add",
      pos = {
        40.6,
        -20.36,
        -150.08
      },
      times = 1,
      index = 14
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [157] = {
    id = 157,
    Content = "killall",
    Params = {
      group_ids = {2}
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [158] = {
    id = 158,
    Content = "wait_refresh",
    Params = {time = 900},
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [159] = {
    id = 159,
    Content = "summon",
    Params = {
      id = 280305,
      randpos = 1,
      group_id = 1,
      dead_disp_time = 5
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [160] = {
    id = 160,
    Content = "killall",
    Params = {
      group_ids = {1}
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [161] = {
    id = 161,
    Content = "wait_refresh",
    Params = {time = 900},
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [162] = {
    id = 162,
    Content = "summon",
    Params = {
      id = 811005,
      pos = {
        28.26,
        1.53,
        3.63
      },
      dir = 110,
      group_id = 1
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [163] = {
    id = 163,
    Content = "use",
    Params = {
      itemIcon = "item_12928",
      name = "##116414",
      button = "##296879",
      pos = {
        28.26,
        1.53,
        3.63
      },
      distance = 3,
      bagcheck = 1,
      itemid = 12926,
      record_char = 1
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [164] = {
    id = 164,
    Content = "dialog",
    Params = {
      dialog = {350602},
      spec_char = 1,
      limit_time = 3
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [165] = {
    id = 165,
    Content = "clearnpc",
    Params = {
      group_ids = {1}
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [166] = {
    id = 166,
    Content = "summon",
    Params = {
      id = 811105,
      pos = {
        28.26,
        1.53,
        3.63
      },
      dir = 110,
      group_id = 1
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [167] = {
    id = 167,
    Content = "wait",
    Params = {time = 20},
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [168] = {
    id = 168,
    Content = "dialog",
    Params = {
      dialog = {350604},
      spec_char = 1,
      limit_time = 3
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [169] = {
    id = 169,
    Content = "wait",
    Params = {time = 2},
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [170] = {
    id = 170,
    Content = "clearnpc",
    Params = {
      group_ids = {1}
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [171] = {
    id = 171,
    Content = "summon",
    Params = {
      id = 280306,
      pos = {
        28.26,
        1.53,
        3.63
      },
      search = 0,
      group_id = 2,
      dead_disp_time = 5
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [172] = {
    id = 172,
    Content = "multigm",
    Params = {
      type = "effect",
      effect = "Common/MaxViewOn",
      opt = "add",
      pos = {
        28.26,
        1.53,
        3.63
      },
      times = 1,
      index = 15
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [173] = {
    id = 173,
    Content = "killall",
    Params = {
      group_ids = {2}
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [174] = {
    id = 174,
    Content = "wait_refresh",
    Params = {time = 900},
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [232] = {
    id = 232,
    Content = "clearnpc",
    Params = {
      npcid = {811015}
    },
    MapID = 103,
    StartCondition = {after_kill_elite = 9000}
  },
  [233] = {
    id = 233,
    Content = "summon",
    Params = {
      id = 809955,
      pos = {
        -5.95,
        16.81,
        -46.84
      },
      group_id = 2
    },
    MapID = 103,
    StartCondition = _EmptyTable
  },
  [234] = {
    id = 234,
    Content = "visit",
    Params = {
      npc = 809955,
      pos = {
        -5.95,
        16.81,
        -46.84
      },
      distance = 2,
      record_char = 1
    },
    MapID = 103,
    StartCondition = _EmptyTable
  },
  [235] = {
    id = 235,
    Content = "clearnpc",
    Params = {
      group_ids = {2}
    },
    MapID = 103,
    StartCondition = _EmptyTable
  },
  [236] = {
    id = 236,
    Content = "summon",
    Params = {
      id = 811015,
      pos = {
        -5.95,
        16.81,
        -46.84
      },
      group_id = 3,
      behavior = 1024,
      no_clear = 1
    },
    MapID = 103,
    StartCondition = _EmptyTable
  },
  [237] = {
    id = 237,
    Content = "dialog",
    Params = {
      dialog = {341000},
      spec_char = 1,
      limit_time = 3
    },
    MapID = 103,
    StartCondition = _EmptyTable
  },
  [238] = {
    id = 238,
    Content = "clearnpc",
    Params = {
      npcid = {811017}
    },
    MapID = 103,
    StartCondition = _EmptyTable
  },
  [239] = {
    id = 239,
    Content = "summon",
    Params = {
      id = 809960,
      pos = {
        -76.45,
        23.88,
        -13.28
      },
      group_id = 4
    },
    MapID = 103,
    StartCondition = _EmptyTable
  },
  [240] = {
    id = 240,
    Content = "visit",
    Params = {
      npc = 809960,
      pos = {
        -76.45,
        23.88,
        -13.28
      },
      distance = 2,
      record_char = 1
    },
    MapID = 103,
    StartCondition = _EmptyTable
  },
  [241] = {
    id = 241,
    Content = "clearnpc",
    Params = {
      group_ids = {4}
    },
    MapID = 103,
    StartCondition = _EmptyTable
  },
  [242] = {
    id = 242,
    Content = "summon",
    Params = {
      id = 811017,
      pos = {
        -76.45,
        23.88,
        -13.28
      },
      group_id = 5,
      behavior = 1024,
      no_clear = 1
    },
    MapID = 103,
    StartCondition = _EmptyTable
  },
  [243] = {
    id = 243,
    Content = "dialog",
    Params = {
      dialog = {341001},
      spec_char = 1,
      limit_time = 3
    },
    MapID = 103,
    StartCondition = _EmptyTable
  },
  [244] = {
    id = 244,
    Content = "clearnpc",
    Params = {
      npcid = {811019}
    },
    MapID = 103,
    StartCondition = _EmptyTable
  },
  [245] = {
    id = 245,
    Content = "summon",
    Params = {
      id = 809961,
      pos = {
        67.05,
        21.83,
        38.29
      },
      group_id = 6
    },
    MapID = 103,
    StartCondition = _EmptyTable
  },
  [246] = {
    id = 246,
    Content = "visit",
    Params = {
      npc = 809961,
      pos = {
        67.05,
        21.83,
        38.29
      },
      distance = 2,
      record_char = 1
    },
    MapID = 103,
    StartCondition = _EmptyTable
  },
  [247] = {
    id = 247,
    Content = "clearnpc",
    Params = {
      group_ids = {6}
    },
    MapID = 103,
    StartCondition = _EmptyTable
  },
  [248] = {
    id = 248,
    Content = "summon",
    Params = {
      id = 811019,
      pos = {
        67.05,
        21.83,
        38.29
      },
      group_id = 7,
      behavior = 1024,
      no_clear = 1
    },
    MapID = 103,
    StartCondition = _EmptyTable
  },
  [249] = {
    id = 249,
    Content = "dialog",
    Params = {
      dialog = {341002},
      spec_char = 1,
      limit_time = 3
    },
    MapID = 103,
    StartCondition = _EmptyTable
  },
  [250] = {
    id = 250,
    Content = "add_map_buff",
    Params = {
      buff = {171002},
      target = "user"
    },
    MapID = 103,
    StartCondition = _EmptyTable
  },
  [251] = {
    id = 251,
    Content = "add_map_buff",
    Params = {
      buff = {4184},
      target = "npc"
    },
    MapID = 103,
    StartCondition = _EmptyTable
  },
  [252] = {
    id = 252,
    Content = "del_map_buff",
    Params = {
      buff = {171002},
      target = "user"
    },
    MapID = 103,
    StartCondition = _EmptyTable
  },
  [253] = {
    id = 253,
    Content = "del_map_buff",
    Params = {
      buff = {4184},
      target = "npc"
    },
    MapID = 103,
    StartCondition = _EmptyTable
  },
  [254] = {
    id = 254,
    Content = "summon",
    Params = {
      id = 280311,
      randpos = 1,
      group_id = 1,
      dead_disp_time = 5
    },
    MapID = 103,
    StartCondition = _EmptyTable
  },
  [255] = {
    id = 255,
    Content = "killall",
    Params = {
      group_ids = {1}
    },
    MapID = 103,
    StartCondition = _EmptyTable
  },
  [256] = {
    id = 256,
    Content = "wait_refresh",
    Params = {time = 1800},
    MapID = 103,
    StartCondition = _EmptyTable
  },
  [281] = {
    id = 281,
    Content = "weather",
    Params = {
      weather_id = {50}
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [282] = {
    id = 282,
    Content = "summon",
    Params = {
      id = 280316,
      randpos = 1,
      group_id = 1,
      dead_disp_time = 5
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [283] = {
    id = 283,
    Content = "killall",
    Params = {
      group_ids = {1}
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [284] = {
    id = 284,
    Content = "wait_refresh",
    Params = {time = 900},
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [285] = {
    id = 285,
    Content = "summon",
    Params = {
      id = 280317,
      randpos = 1,
      xrange = {min = -0.52, max = 41.69},
      zrange = {min = -169.49, max = -109.96},
      group_id = 1,
      dead_disp_time = 5
    },
    MapID = 102,
    StartCondition = {after_kill_elite = 2000}
  },
  [286] = {
    id = 286,
    Content = "killall",
    Params = {
      group_ids = {1}
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [287] = {
    id = 287,
    Content = "wait_refresh",
    Params = {time = 900},
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [296] = {
    id = 296,
    Content = "summon",
    Params = {
      id = 280320,
      randpos = 1,
      group_id = 1,
      dead_disp_time = 5
    },
    MapID = 102,
    StartCondition = {after_kill_elite = 3000}
  },
  [297] = {
    id = 297,
    Content = "killall",
    Params = {
      group_ids = {1}
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [298] = {
    id = 298,
    Content = "wait_refresh",
    Params = {time = 900},
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [299] = {
    id = 299,
    Content = "summon",
    Params = {
      id = 280371,
      randpos = 1,
      group_id = 3
    },
    MapID = 105,
    StartCondition = _EmptyTable
  },
  [300] = {
    id = 300,
    Content = "weather",
    Params = {
      weather_id = {47}
    },
    MapID = 105,
    StartCondition = _EmptyTable
  },
  [301] = {
    id = 301,
    Content = "summon",
    Params = {
      id = 816000,
      around_npc_group = 3,
      around_npc_range = 0,
      behavior = 1024,
      group_id = 10
    },
    MapID = 105,
    StartCondition = _EmptyTable
  },
  [302] = {
    id = 302,
    Content = "clearnpc",
    Params = {
      group_ids = {3}
    },
    MapID = 105,
    StartCondition = _EmptyTable
  },
  [303] = {
    id = 303,
    Content = "multigm",
    Params = {
      type = "effect",
      effect = "Skill/Eff_Chainoverload_hit",
      opt = "add",
      npcid = 816000,
      times = 1,
      index = 1
    },
    MapID = 105,
    StartCondition = _EmptyTable
  },
  [304] = {
    id = 304,
    Content = "wait",
    Params = {time = 1},
    MapID = 105,
    StartCondition = _EmptyTable
  },
  [305] = {
    id = 305,
    Content = "summon",
    Params = {
      id = 280343,
      around_npc_group = 10,
      around_npc_range = 0,
      group_id = 1,
      dead_disp_time = 5
    },
    MapID = 105,
    StartCondition = _EmptyTable
  },
  [306] = {
    id = 306,
    Content = "killall",
    Params = {
      group_ids = {1}
    },
    MapID = 105,
    StartCondition = _EmptyTable
  },
  [307] = {
    id = 307,
    Content = "wait_refresh",
    Params = {time = 1800},
    MapID = 105,
    StartCondition = _EmptyTable
  },
  [308] = {
    id = 308,
    Content = "weather",
    Params = {
      weather_id = {50}
    },
    MapID = 105,
    StartCondition = _EmptyTable
  },
  [309] = {
    id = 309,
    Content = "summon",
    Params = {
      id = 816000,
      around_npc_group = 3,
      around_npc_range = 0,
      behavior = 1024,
      group_id = 11
    },
    MapID = 105,
    StartCondition = _EmptyTable
  },
  [310] = {
    id = 310,
    Content = "clearnpc",
    Params = {
      group_ids = {3}
    },
    MapID = 105,
    StartCondition = _EmptyTable
  },
  [311] = {
    id = 311,
    Content = "multigm",
    Params = {
      type = "effect",
      effect = "Skill/Eff_Chainoverload_hit",
      opt = "add",
      npcid = 816000,
      times = 1,
      index = 2
    },
    MapID = 105,
    StartCondition = _EmptyTable
  },
  [312] = {
    id = 312,
    Content = "wait",
    Params = {time = 1},
    MapID = 105,
    StartCondition = _EmptyTable
  },
  [313] = {
    id = 313,
    Content = "summon",
    Params = {
      id = 280344,
      around_npc_group = 11,
      around_npc_range = 0,
      group_id = 2,
      dead_disp_time = 5
    },
    MapID = 105,
    StartCondition = _EmptyTable
  },
  [314] = {
    id = 314,
    Content = "killall",
    Params = {
      group_ids = {2}
    },
    MapID = 105,
    StartCondition = _EmptyTable
  },
  [315] = {
    id = 315,
    Content = "wait_refresh",
    Params = {time = 1800},
    MapID = 105,
    StartCondition = _EmptyTable
  },
  [316] = {
    id = 316,
    Content = "killmonster",
    Params = {
      npcid = {280371},
      num = 1
    },
    MapID = 105,
    StartCondition = _EmptyTable
  },
  [317] = {
    id = 317,
    Content = "wait_refresh",
    Params = {time = 1, no_stat_num = 1},
    MapID = 105,
    StartCondition = _EmptyTable
  },
  [339] = {
    id = 339,
    Content = "summon",
    Params = {
      id = 280372,
      pos = {
        80.46,
        -20.922,
        -107.73
      },
      dir = 220.64,
      group_id = 2,
      territory = 0,
      search = 0
    },
    MapID = 105,
    StartCondition = _EmptyTable
  },
  [340] = {
    id = 340,
    Content = "summon",
    Params = {
      id = 815997,
      around_npc_group = 2,
      around_npc_range = 0,
      behavior = 1024,
      group_id = 10
    },
    MapID = 105,
    StartCondition = _EmptyTable
  },
  [341] = {
    id = 341,
    Content = "killall",
    Params = {
      group_ids = {2},
      record_char = 1
    },
    MapID = 105,
    StartCondition = _EmptyTable
  },
  [342] = {
    id = 342,
    Content = "dialog",
    Params = {
      dialog = {351014},
      spec_char = 1,
      limit_time = 3
    },
    MapID = 105,
    StartCondition = _EmptyTable
  },
  [343] = {
    id = 343,
    Content = "wait",
    Params = {time = 2},
    MapID = 105,
    StartCondition = _EmptyTable
  },
  [344] = {
    id = 344,
    Content = "multigm",
    Params = {
      type = "effect",
      effect = "Skill/LightOfHeal_hit",
      opt = "add",
      npcid = 815997,
      times = 1,
      index = 1
    },
    MapID = 105,
    StartCondition = _EmptyTable
  },
  [345] = {
    id = 345,
    Content = "wait",
    Params = {time = 1},
    MapID = 105,
    StartCondition = _EmptyTable
  },
  [346] = {
    id = 346,
    Content = "summon",
    Params = {
      id = 280348,
      around_npc_group = 10,
      around_npc_range = 0,
      group_id = 1,
      dead_disp_time = 5
    },
    MapID = 105,
    StartCondition = _EmptyTable
  },
  [347] = {
    id = 347,
    Content = "killall",
    Params = {
      group_ids = {1}
    },
    MapID = 105,
    StartCondition = _EmptyTable
  },
  [348] = {
    id = 348,
    Content = "wait_refresh",
    Params = {time = 1800},
    MapID = 105,
    StartCondition = _EmptyTable
  },
  [358] = {
    id = 358,
    Content = "summon",
    Params = {
      id = 816004,
      pos = {
        77.64,
        -19.52,
        -133.92
      },
      group_id = 2
    },
    MapID = 105,
    StartCondition = _EmptyTable
  },
  [360] = {
    id = 360,
    Content = "use",
    Params = {
      itemIcon = "item_12946",
      name = "##282938",
      button = "##121222",
      pos = {
        77.64,
        -19.52,
        -133.92
      },
      distance = 3,
      bagcheck = 1,
      itemid = 12983,
      record_char = 1
    },
    MapID = 105,
    StartCondition = _EmptyTable
  },
  [361] = {
    id = 361,
    Content = "clearnpc",
    Params = {
      group_ids = {2}
    },
    MapID = 105,
    StartCondition = _EmptyTable
  },
  [362] = {
    id = 362,
    Content = "multigm",
    Params = {
      type = "shakescreen",
      amplitude = 5,
      msec = 1000,
      shaketype = 1,
      sync = 1,
      spec_char = 1
    },
    MapID = 105,
    StartCondition = _EmptyTable
  },
  [363] = {
    id = 363,
    Content = "summon",
    Params = {
      id = 280350,
      pos = {
        77.64,
        -19.52,
        -133.92
      },
      group_id = 1,
      dead_disp_time = 5
    },
    MapID = 105,
    StartCondition = _EmptyTable
  },
  [364] = {
    id = 364,
    Content = "dialog",
    Params = {
      dialog = {351015},
      spec_char = 1,
      limit_time = 3
    },
    MapID = 105,
    StartCondition = _EmptyTable
  },
  [365] = {
    id = 365,
    Content = "killall",
    Params = {
      group_ids = {1}
    },
    MapID = 105,
    StartCondition = _EmptyTable
  },
  [366] = {
    id = 366,
    Content = "wait_refresh",
    Params = {time = 1800},
    MapID = 105,
    StartCondition = _EmptyTable
  },
  [367] = {
    id = 367,
    Content = "summon",
    Params = {
      id = 280351,
      randpos = 1,
      group_id = 1,
      dead_disp_time = 5
    },
    MapID = 105,
    StartCondition = _EmptyTable
  },
  [368] = {
    id = 368,
    Content = "killall",
    Params = {
      group_ids = {1}
    },
    MapID = 105,
    StartCondition = _EmptyTable
  },
  [369] = {
    id = 369,
    Content = "wait_refresh",
    Params = {time = 1800},
    MapID = 105,
    StartCondition = _EmptyTable
  },
  [370] = {
    id = 370,
    Content = "summon",
    Params = {
      id = 815999,
      pos = {
        16.35,
        3.92,
        53.21
      },
      dir = 122.64,
      behavior = 1024,
      group_id = 2
    },
    MapID = 104,
    StartCondition = _EmptyTable
  },
  [371] = {
    id = 371,
    Content = "summon",
    Params = {
      id_by_turn = {816005, 816006},
      pos = {
        16.35,
        3.92,
        53.21
      },
      group_id = 3,
      dir = 183.34,
      behavior = 1024
    },
    MapID = 104,
    StartCondition = _EmptyTable
  },
  [372] = {
    id = 372,
    Content = "useskill",
    Params = {
      skillid = 40079,
      pos = {
        16.35,
        3.92,
        53.21
      },
      distance = 3
    },
    MapID = 104,
    StartCondition = _EmptyTable
  },
  [373] = {
    id = 373,
    Content = "multigm",
    Params = {
      type = "effect",
      effect = "Skill/ColdJokes_hit",
      opt = "add",
      pos = {
        16.35,
        3.92,
        53.21
      },
      scale = 2.5,
      times = 1,
      index = 1
    },
    MapID = 104,
    StartCondition = _EmptyTable
  },
  [374] = {
    id = 374,
    Content = "wait",
    Params = {time = 1},
    MapID = 104,
    StartCondition = _EmptyTable
  },
  [375] = {
    id = 375,
    Content = "clearnpc",
    Params = {
      group_ids = {2}
    },
    MapID = 104,
    StartCondition = _EmptyTable
  },
  [376] = {
    id = 376,
    Content = "wait",
    Params = {time = 2},
    MapID = 104,
    StartCondition = _EmptyTable
  },
  [377] = {
    id = 377,
    Content = "clearnpc",
    Params = {
      group_ids = {3}
    },
    MapID = 104,
    StartCondition = _EmptyTable
  },
  [378] = {
    id = 378,
    Content = "summon",
    Params = {
      id_by_turn = {280352, 280353},
      pos = {
        16.35,
        3.92,
        53.21
      },
      dir = 183.34,
      group_id = 1,
      dead_disp_time = 5
    },
    MapID = 104,
    StartCondition = _EmptyTable
  },
  [379] = {
    id = 379,
    Content = "killall",
    Params = {
      group_ids = {1}
    },
    MapID = 104,
    StartCondition = _EmptyTable
  },
  [380] = {
    id = 380,
    Content = "wait_refresh",
    Params = {time = 1800},
    MapID = 104,
    StartCondition = _EmptyTable
  },
  [381] = {
    id = 381,
    Content = "summon",
    Params = {
      id = 280354,
      randpos = 1,
      min_visible_nightmare = 1000,
      group_id = 1,
      dead_disp_time = 5
    },
    MapID = 105,
    StartCondition = _EmptyTable
  },
  [382] = {
    id = 382,
    Content = "killall",
    Params = {
      group_ids = {1}
    },
    MapID = 105,
    StartCondition = _EmptyTable
  },
  [383] = {
    id = 383,
    Content = "wait_refresh",
    Params = {time = 1800},
    MapID = 105,
    StartCondition = _EmptyTable
  },
  [401] = {
    id = 401,
    Content = "summon",
    Params = {
      id = 280356,
      randpos = 1,
      min_visible_nightmare = 1500,
      group_id = 1,
      dead_disp_time = 5
    },
    MapID = 105,
    StartCondition = _EmptyTable
  },
  [402] = {
    id = 402,
    Content = "killall",
    Params = {
      group_ids = {1}
    },
    MapID = 105,
    StartCondition = _EmptyTable
  },
  [403] = {
    id = 403,
    Content = "wait_refresh",
    Params = {time = 900},
    MapID = 105,
    StartCondition = _EmptyTable
  },
  [404] = {
    id = 404,
    Content = "summon",
    Params = {
      id = 280357,
      randpos = 1,
      min_visible_nightmare = 2000,
      group_id = 1,
      dead_disp_time = 5
    },
    MapID = 105,
    StartCondition = _EmptyTable
  },
  [405] = {
    id = 405,
    Content = "killall",
    Params = {
      group_ids = {1}
    },
    MapID = 105,
    StartCondition = _EmptyTable
  },
  [406] = {
    id = 406,
    Content = "wait_refresh",
    Params = {time = 1800},
    MapID = 105,
    StartCondition = _EmptyTable
  },
  [407] = {
    id = 407,
    Content = "clearnpc",
    Params = {
      npcid = {816008}
    },
    MapID = 105,
    StartCondition = _EmptyTable
  },
  [408] = {
    id = 408,
    Content = "clearnpc",
    Params = {
      npcid = {816007}
    },
    MapID = 105,
    StartCondition = _EmptyTable
  },
  [409] = {
    id = 409,
    Content = "summon",
    Params = {
      id = 816007,
      pos = {
        -30.27,
        1.51,
        -55.05
      },
      dir = 24.265,
      max_visible_nightmare = 2999,
      group_id = 2
    },
    MapID = 105,
    StartCondition = _EmptyTable
  },
  [410] = {
    id = 410,
    Content = "summon",
    Params = {
      id = 280358,
      pos = {
        -30.27,
        1.51,
        -55.05
      },
      dir = 24.265,
      min_visible_nightmare = 3000,
      group_id = 1,
      dead_disp_time = 5
    },
    MapID = 105,
    StartCondition = _EmptyTable
  },
  [411] = {
    id = 411,
    Content = "killall",
    Params = {
      group_ids = {1}
    },
    MapID = 105,
    StartCondition = _EmptyTable
  },
  [412] = {
    id = 412,
    Content = "wait",
    Params = {time = 3},
    MapID = 105,
    StartCondition = _EmptyTable
  },
  [413] = {
    id = 413,
    Content = "clearnpc",
    Params = {
      group_ids = {2}
    },
    MapID = 105,
    StartCondition = _EmptyTable
  },
  [414] = {
    id = 414,
    Content = "summon",
    Params = {
      id = 816008,
      pos = {
        -30.27,
        1.51,
        -55.05
      },
      dir = 24.265,
      max_visible_nightmare = 3000,
      group_id = 3,
      no_clear = 1
    },
    MapID = 105,
    StartCondition = _EmptyTable
  },
  [415] = {
    id = 415,
    Content = "summon",
    Params = {
      id = 816007,
      pos = {
        -30.27,
        1.51,
        -55.05
      },
      dir = 24.265,
      min_visible_nightmare = 3001,
      group_id = 4,
      no_clear = 1
    },
    MapID = 105,
    StartCondition = _EmptyTable
  },
  [416] = {
    id = 416,
    Content = "wait_refresh",
    Params = {time = 1800},
    MapID = 105,
    StartCondition = _EmptyTable
  },
  [417] = {
    id = 417,
    Content = "summon",
    Params = {
      id = 280359,
      randpos = 1,
      group_id = 1,
      dead_disp_time = 5
    },
    MapID = 105,
    StartCondition = _EmptyTable
  },
  [418] = {
    id = 418,
    Content = "killall",
    Params = {
      group_ids = {1}
    },
    MapID = 105,
    StartCondition = _EmptyTable
  },
  [419] = {
    id = 419,
    Content = "wait_refresh",
    Params = {time = 1800},
    MapID = 105,
    StartCondition = _EmptyTable
  },
  [458] = {
    id = 458,
    Content = "summon",
    Params = {
      id = 280361,
      randpos = 1,
      group_id = 1,
      dead_disp_time = 5
    },
    MapID = 105,
    StartCondition = _EmptyTable
  },
  [459] = {
    id = 459,
    Content = "killall",
    Params = {
      group_ids = {1}
    },
    MapID = 105,
    StartCondition = _EmptyTable
  },
  [460] = {
    id = 460,
    Content = "wait_refresh",
    Params = {time = 1800},
    MapID = 105,
    StartCondition = _EmptyTable
  },
  [464] = {
    id = 464,
    Content = "weather",
    Params = {
      weather_id = {46}
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [465] = {
    id = 465,
    Content = "summon",
    Params = {
      id = 810203,
      pos = {
        115.96,
        -21.75,
        -170.49
      },
      group_id = 1
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [466] = {
    id = 466,
    Content = "summon",
    Params = {
      id = 810204,
      pos = {
        91.84,
        -21.8,
        -180
      },
      group_id = 2
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [467] = {
    id = 467,
    Content = "weather",
    Params = {
      weather_id = {
        47,
        48,
        49,
        50,
        51,
        52,
        53
      }
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [468] = {
    id = 468,
    Content = "clearnpc",
    Params = {
      group_ids = {1}
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [469] = {
    id = 469,
    Content = "clearnpc",
    Params = {
      group_ids = {2}
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [470] = {
    id = 470,
    Content = "wait_refresh",
    Params = {time = 1800},
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [471] = {
    id = 471,
    Content = "summon",
    Params = {
      id = 280500,
      pos = {
        -48.27,
        3.82,
        20.06
      },
      group_id = 1,
      dead_disp_time = 20,
      search = 0
    },
    MapID = 102,
    StartCondition = {after_open_server = 13}
  },
  [472] = {
    id = 472,
    Content = "killall",
    Params = {
      group_ids = {1}
    },
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [473] = {
    id = 473,
    Content = "wait_refresh",
    Params = {exactly_divide_minute = 120},
    MapID = 102,
    StartCondition = _EmptyTable
  },
  [474] = {
    id = 474,
    Content = "clearnpc",
    Params = {
      npcid = {801994}
    },
    MapID = 103,
    StartCondition = _EmptyTable
  },
  [475] = {
    id = 475,
    Content = "clearnpc",
    Params = {
      npcid = {801993}
    },
    MapID = 103,
    StartCondition = _EmptyTable
  },
  [476] = {
    id = 476,
    Content = "visit",
    Params = {
      npc = 801992,
      pos = {
        -9.83,
        21.44,
        26.09
      },
      dialog = {
        420862,
        420863,
        420864,
        420865
      },
      distance = 3,
      ShowSymbol = 1,
      record_char = 1
    },
    MapID = 103,
    StartCondition = _EmptyTable
  },
  [477] = {
    id = 477,
    Content = "dialog",
    Params = {
      dialog = {420866},
      limit_time = 5,
      spec_char = 1
    },
    MapID = 103,
    StartCondition = _EmptyTable
  },
  [478] = {
    id = 478,
    Content = "dialog",
    Params = {
      dialog = {420867},
      limit_time = 10,
      spec_char = 1
    },
    MapID = 103,
    StartCondition = _EmptyTable
  },
  [479] = {
    id = 479,
    Content = "multigm",
    Params = {
      type = "subitem",
      packtype = 1,
      id = 54879,
      num = 1,
      spec_char = 1
    },
    MapID = 103,
    StartCondition = _EmptyTable
  },
  [480] = {
    id = 480,
    Content = "multigm",
    Params = {
      type = "subitem",
      packtype = 8,
      id = 54879,
      num = 1,
      spec_char = 1
    },
    MapID = 103,
    StartCondition = _EmptyTable
  },
  [481] = {
    id = 481,
    Content = "dialog",
    Params = {
      dialog = {420868},
      limit_time = 10,
      spec_char = 1
    },
    MapID = 103,
    StartCondition = _EmptyTable
  },
  [482] = {
    id = 482,
    Content = "dialog",
    Params = {
      dialog = {
        420869,
        420870,
        420871,
        420872,
        420873,
        420874,
        420875,
        420876,
        420877
      },
      limit_time = 10,
      spec_char = 1
    },
    MapID = 103,
    StartCondition = _EmptyTable
  },
  [483] = {
    id = 483,
    Content = "multigm",
    Params = {
      type = "sound_effect",
      se = "Common/EnterScene"
    },
    MapID = 103,
    StartCondition = _EmptyTable
  },
  [484] = {
    id = 484,
    Content = "multigm",
    Params = {
      type = "effect",
      effect = "Common/Magatama_playshow_F",
      times = 1
    },
    MapID = 103,
    StartCondition = _EmptyTable
  },
  [485] = {
    id = 485,
    Content = "wait",
    Params = {time = 2},
    MapID = 103,
    StartCondition = _EmptyTable
  },
  [486] = {
    id = 486,
    Content = "dialog",
    Params = {
      dialog = {420880},
      limit_time = 5,
      spec_char = 1,
      all_zone_jump = 14,
      broadcast_msg = 41000
    },
    MapID = 103,
    StartCondition = _EmptyTable
  },
  [487] = {
    id = 487,
    Content = "multigm",
    Params = {
      type = "sound_effect",
      se = "Common/EnterScene"
    },
    MapID = 103,
    StartCondition = _EmptyTable
  },
  [488] = {
    id = 488,
    Content = "multigm",
    Params = {
      type = "effect",
      effect = "Common/65JobChange",
      times = 1,
      pos = {
        -18.32,
        27.4,
        23.1
      },
      ignorenavmesh = 1,
      scale = 3
    },
    MapID = 103,
    StartCondition = _EmptyTable
  },
  [489] = {
    id = 489,
    Content = "wait",
    Params = {time = 2},
    MapID = 103,
    StartCondition = _EmptyTable
  },
  [490] = {
    id = 490,
    Content = "multigm",
    Params = {
      type = "sound_effect",
      se = "Common/Task_Shiny"
    },
    MapID = 103,
    StartCondition = _EmptyTable
  },
  [491] = {
    id = 491,
    Content = "multigm",
    Params = {
      type = "effect",
      effect = "Skill/Eff_Eliminate_area04",
      pos = {
        -18.32,
        27.4,
        23.1
      },
      ignorenavmesh = 1
    },
    MapID = 103,
    StartCondition = _EmptyTable
  },
  [492] = {
    id = 492,
    Content = "wait",
    Params = {time = 2},
    MapID = 103,
    StartCondition = _EmptyTable
  },
  [493] = {
    id = 493,
    Content = "multigm",
    Params = {
      type = "sound_effect",
      se = "Common/Task_Shiny"
    },
    MapID = 103,
    StartCondition = _EmptyTable
  },
  [494] = {
    id = 494,
    Content = "multigm",
    Params = {
      type = "effect",
      effect = "Skill/Eff_Eliminate_area04",
      pos = {
        -18.32,
        27.4,
        23.1
      },
      ignorenavmesh = 1
    },
    MapID = 103,
    StartCondition = _EmptyTable
  },
  [495] = {
    id = 495,
    Content = "wait",
    Params = {time = 2},
    MapID = 103,
    StartCondition = _EmptyTable
  },
  [496] = {
    id = 496,
    Content = "multigm",
    Params = {
      type = "sound_effect",
      se = "Common/Task_Shiny"
    },
    MapID = 103,
    StartCondition = _EmptyTable
  },
  [497] = {
    id = 497,
    Content = "multigm",
    Params = {
      type = "effect",
      effect = "Skill/Eff_Eliminate_area04",
      pos = {
        -18.32,
        27.4,
        23.1
      },
      ignorenavmesh = 1
    },
    MapID = 103,
    StartCondition = _EmptyTable
  },
  [498] = {
    id = 498,
    Content = "multigm",
    Params = {
      type = "effect",
      effect = "Skill/LotteryCard_buff",
      pos = {
        -18.18,
        22.44,
        22.56
      },
      index = 76,
      times = 0,
      opt = "add",
      ignorenavmesh = 1,
      scale = 7
    },
    MapID = 103,
    StartCondition = _EmptyTable
  },
  [499] = {
    id = 499,
    Content = "multigm",
    Params = {
      type = "effect",
      effect = "Skill/PoemOfBragi_buff2",
      pos = {
        -18.4,
        25.62,
        22.79
      },
      index = 77,
      times = 0,
      opt = "add",
      ignorenavmesh = 1,
      scale = 2
    },
    MapID = 103,
    StartCondition = _EmptyTable
  },
  [500] = {
    id = 500,
    Content = "wait",
    Params = {time = 2},
    MapID = 103,
    StartCondition = _EmptyTable
  },
  [501] = {
    id = 501,
    Content = "multigm",
    Params = {
      type = "sound_effect",
      se = "Common/EnterScene"
    },
    MapID = 103,
    StartCondition = _EmptyTable
  },
  [502] = {
    id = 502,
    Content = "multigm",
    Params = {
      type = "effect",
      effect = "Skill/LightOfHeal_attack",
      pos = {
        -17.78,
        22.11,
        22.6
      },
      times = 1,
      ignorenavmesh = 1,
      scale = 2
    },
    MapID = 103,
    StartCondition = _EmptyTable
  },
  [503] = {
    id = 503,
    Content = "wait",
    Params = {time = 2},
    MapID = 103,
    StartCondition = _EmptyTable
  },
  [504] = {
    id = 504,
    Content = "multigm",
    Params = {
      type = "effect",
      effect = "Skill/LVUP_Process",
      pos = {
        -17.63,
        21.51,
        15.33
      },
      times = 0,
      ignorenavmesh = 1,
      index = 81,
      opt = "add"
    },
    MapID = 103,
    StartCondition = _EmptyTable
  },
  [505] = {
    id = 505,
    Content = "multigm",
    Params = {
      type = "effect",
      effect = "Skill/LVUP_Process",
      pos = {
        -24.61,
        21.48,
        22.01
      },
      times = 0,
      ignorenavmesh = 1,
      index = 82,
      opt = "add"
    },
    MapID = 103,
    StartCondition = _EmptyTable
  },
  [506] = {
    id = 506,
    Content = "multigm",
    Params = {
      type = "effect",
      effect = "Skill/LVUP_Process",
      pos = {
        -9.84,
        21.48,
        20.37
      },
      times = 0,
      ignorenavmesh = 1,
      index = 83,
      opt = "add"
    },
    MapID = 103,
    StartCondition = _EmptyTable
  },
  [507] = {
    id = 507,
    Content = "multigm",
    Params = {
      type = "effect",
      effect = "Skill/LVUP_Process",
      pos = {
        -13.19,
        21.45,
        28.18
      },
      times = 0,
      ignorenavmesh = 1,
      index = 84,
      opt = "add"
    },
    MapID = 103,
    StartCondition = _EmptyTable
  },
  [508] = {
    id = 508,
    Content = "dialog",
    Params = {
      dialog = {420881},
      limit_time = 5,
      spec_char = 1
    },
    MapID = 103,
    StartCondition = _EmptyTable
  },
  [509] = {
    id = 509,
    Content = "multigm",
    Params = {
      type = "sound_effect",
      se = "Common/EnterScene"
    },
    MapID = 103,
    StartCondition = _EmptyTable
  },
  [510] = {
    id = 510,
    Content = "multigm",
    Params = {
      type = "effect",
      effect = "Skill/LightOfHeal_attack",
      pos = {
        -17.78,
        22.11,
        22.6
      },
      times = 1,
      ignorenavmesh = 1,
      scale = 2
    },
    MapID = 103,
    StartCondition = _EmptyTable
  },
  [511] = {
    id = 511,
    Content = "wait",
    Params = {time = 2},
    MapID = 103,
    StartCondition = _EmptyTable
  },
  [512] = {
    id = 512,
    Content = "multigm",
    Params = {
      type = "sound_effect",
      se = "Skill/attack8"
    },
    MapID = 103,
    StartCondition = _EmptyTable
  },
  [513] = {
    id = 513,
    Content = "multigm",
    Params = {
      type = "effect",
      effect = "Skill/LVUP_Process_2",
      pos = {
        -17.0,
        22.24,
        21.98
      },
      scale = 4
    },
    MapID = 103,
    StartCondition = _EmptyTable
  },
  [514] = {
    id = 514,
    Content = "wait",
    Params = {time = 1},
    MapID = 103,
    StartCondition = _EmptyTable
  },
  [515] = {
    id = 515,
    Content = "multigm",
    Params = {
      type = "effect",
      effect = "Skill/LVUP_Process_2",
      pos = {
        -17.63,
        21.51,
        15.33
      }
    },
    MapID = 103,
    StartCondition = _EmptyTable
  },
  [516] = {
    id = 516,
    Content = "multigm",
    Params = {
      type = "effect",
      effect = "Skill/LVUP_Process_2",
      pos = {
        -24.61,
        21.48,
        22.01
      }
    },
    MapID = 103,
    StartCondition = _EmptyTable
  },
  [517] = {
    id = 517,
    Content = "multigm",
    Params = {
      type = "effect",
      effect = "Skill/LVUP_Process_2",
      pos = {
        -9.84,
        21.48,
        20.37
      }
    },
    MapID = 103,
    StartCondition = _EmptyTable
  },
  [518] = {
    id = 518,
    Content = "multigm",
    Params = {
      type = "effect",
      effect = "Skill/LVUP_Process_2",
      pos = {
        -13.19,
        21.45,
        28.18
      }
    },
    MapID = 103,
    StartCondition = _EmptyTable
  },
  [519] = {
    id = 519,
    Content = "multigm",
    Params = {
      type = "effect",
      effect = "Skill/LVUP_Process",
      pos = {
        -17.63,
        21.51,
        15.33
      },
      times = 0,
      ignorenavmesh = 1,
      index = 81,
      opt = "delete"
    },
    MapID = 103,
    StartCondition = _EmptyTable
  },
  [520] = {
    id = 520,
    Content = "multigm",
    Params = {
      type = "effect",
      effect = "Skill/LVUP_Process",
      pos = {
        -24.61,
        21.48,
        22.01
      },
      times = 0,
      ignorenavmesh = 1,
      index = 82,
      opt = "delete"
    },
    MapID = 103,
    StartCondition = _EmptyTable
  },
  [521] = {
    id = 521,
    Content = "multigm",
    Params = {
      type = "effect",
      effect = "Skill/LVUP_Process",
      pos = {
        -9.84,
        21.48,
        20.37
      },
      times = 0,
      ignorenavmesh = 1,
      index = 83,
      opt = "delete"
    },
    MapID = 103,
    StartCondition = _EmptyTable
  },
  [522] = {
    id = 522,
    Content = "multigm",
    Params = {
      type = "effect",
      effect = "Skill/LVUP_Process",
      pos = {
        -13.19,
        21.45,
        28.18
      },
      times = 0,
      ignorenavmesh = 1,
      index = 84,
      opt = "delete"
    },
    MapID = 103,
    StartCondition = _EmptyTable
  },
  [523] = {
    id = 523,
    Content = "wait",
    Params = {time = 5},
    MapID = 103,
    StartCondition = _EmptyTable
  },
  [524] = {
    id = 524,
    Content = "summon",
    Params = {
      id = 801993,
      pos = {
        -8.65,
        21.44,
        26.75
      },
      dir = 150.74,
      group_id = 1,
      no_clear = 1
    },
    MapID = 103,
    StartCondition = _EmptyTable
  },
  [525] = {
    id = 525,
    Content = "summon",
    Params = {
      id = 801994,
      pos = {
        -18.69,
        21.44,
        14.49
      },
      dir = 150.74,
      group_id = 2,
      no_clear = 1
    },
    MapID = 103,
    StartCondition = _EmptyTable
  },
  [526] = {
    id = 526,
    Content = "summon",
    Params = {
      id = 801994,
      pos = {
        -24.36,
        21.44,
        19.17
      },
      dir = 150.74,
      group_id = 3,
      no_clear = 1
    },
    MapID = 103,
    StartCondition = _EmptyTable
  },
  [527] = {
    id = 527,
    Content = "summon",
    Params = {
      id = 801994,
      pos = {
        -21.01,
        21.44,
        27.18
      },
      dir = 150.74,
      group_id = 4,
      no_clear = 1
    },
    MapID = 103,
    StartCondition = _EmptyTable
  },
  [528] = {
    id = 528,
    Content = "summon",
    Params = {
      id = 801994,
      pos = {
        -11.01,
        21.44,
        21.55
      },
      dir = 150.74,
      group_id = 5,
      no_clear = 1
    },
    MapID = 103,
    StartCondition = _EmptyTable
  },
  [529] = {
    id = 529,
    Content = "wait_refresh",
    Params = {week_refresh = 1},
    MapID = 103,
    StartCondition = _EmptyTable
  },
  [530] = {
    id = 530,
    Content = "clearnpc",
    Params = {
      npcid = {808304}
    },
    MapID = 104,
    StartCondition = _EmptyTable
  },
  [531] = {
    id = 531,
    Content = "clearnpc",
    Params = {
      npcid = {808306}
    },
    MapID = 104,
    StartCondition = _EmptyTable
  },
  [532] = {
    id = 532,
    Content = "summon",
    Params = {
      id = 808305,
      pos = {
        31.31,
        3.2,
        19.56
      },
      dir = 97.0,
      behavior = 1024,
      ignorenavmesh = 1,
      group_id = 2
    },
    MapID = 104,
    StartCondition = _EmptyTable
  },
  [533] = {
    id = 533,
    Content = "summon",
    Params = {
      id = 808303,
      pos = {
        -22.09,
        0.45,
        -62.74
      },
      dir = 122.76,
      group_id = 3
    },
    MapID = 104,
    StartCondition = _EmptyTable
  },
  [534] = {
    id = 534,
    Content = "visit",
    Params = {
      npc = 808303,
      pos = {
        -22.09,
        0.45,
        -62.74
      },
      dialog = {
        603894,
        603895,
        603896,
        603897
      },
      distance = 3,
      ShowSymbol = 1,
      record_char = 1
    },
    MapID = 104,
    StartCondition = _EmptyTable
  },
  [535] = {
    id = 535,
    Content = "dialog",
    Params = {
      dialog = {603898},
      limit_time = 5,
      spec_char = 1
    },
    MapID = 104,
    StartCondition = _EmptyTable
  },
  [536] = {
    id = 536,
    Content = "dialog",
    Params = {
      dialog = {603899},
      limit_time = 10,
      spec_char = 1
    },
    MapID = 104,
    StartCondition = _EmptyTable
  },
  [537] = {
    id = 537,
    Content = "multigm",
    Params = {
      type = "subitem",
      packtype = 1,
      id = 54881,
      num = 1,
      spec_char = 1
    },
    MapID = 104,
    StartCondition = _EmptyTable
  },
  [538] = {
    id = 538,
    Content = "multigm",
    Params = {
      type = "subitem",
      packtype = 8,
      id = 54881,
      num = 1,
      spec_char = 1
    },
    MapID = 104,
    StartCondition = _EmptyTable
  },
  [539] = {
    id = 539,
    Content = "dialog",
    Params = {
      dialog = {603900},
      limit_time = 10,
      spec_char = 1
    },
    MapID = 104,
    StartCondition = _EmptyTable
  },
  [540] = {
    id = 540,
    Content = "dialog",
    Params = {
      dialog = {
        603901,
        603902,
        603903,
        603904,
        603905
      },
      limit_time = 10,
      spec_char = 1
    },
    MapID = 104,
    StartCondition = _EmptyTable
  },
  [541] = {
    id = 541,
    Content = "multigm",
    Params = {
      type = "gocity",
      mapid = 104,
      x = 30.79,
      y = 3.2,
      z = 15.06,
      spec_char = 1
    },
    MapID = 104,
    StartCondition = _EmptyTable
  },
  [542] = {
    id = 542,
    Content = "multigm",
    Params = {
      type = "effect",
      effect = "Skill/MagicRiot_attack",
      opt = "add",
      npcid = 808303,
      scale = 1.5,
      times = 1,
      index = 2
    },
    MapID = 104,
    StartCondition = _EmptyTable
  },
  [543] = {
    id = 543,
    Content = "wait",
    Params = {time = 1},
    MapID = 104,
    StartCondition = _EmptyTable
  },
  [544] = {
    id = 544,
    Content = "clearnpc",
    Params = {
      group_ids = {3}
    },
    MapID = 104,
    StartCondition = _EmptyTable
  },
  [545] = {
    id = 545,
    Content = "summon",
    Params = {
      id = 808303,
      pos = {
        28.8,
        3.2,
        18.08
      },
      dir = 121.58,
      group_id = 5
    },
    MapID = 104,
    StartCondition = _EmptyTable
  },
  [546] = {
    id = 546,
    Content = "dialog",
    Params = {
      dialog = {603907, 603908},
      limit_time = 10,
      spec_char = 1,
      all_zone_jump = 18,
      broadcast_msg = 41001
    },
    MapID = 104,
    StartCondition = _EmptyTable
  },
  [547] = {
    id = 547,
    Content = "wait",
    Params = {time = 3},
    MapID = 104,
    StartCondition = _EmptyTable
  },
  [548] = {
    id = 548,
    Content = "multigm",
    Params = {
      type = "shakescreen",
      amplitude = 10,
      msec = 1000,
      shaketype = 1,
      sync = 1,
      spec_char = 1
    },
    MapID = 104,
    StartCondition = _EmptyTable
  },
  [549] = {
    id = 549,
    Content = "multigm",
    Params = {
      type = "effect",
      effect = "Skill/Eff_Detale_binghe_atk",
      opt = "add",
      npcid = 808305,
      index = 1
    },
    MapID = 104,
    StartCondition = _EmptyTable
  },
  [550] = {
    id = 550,
    Content = "wait",
    Params = {time = 1},
    MapID = 104,
    StartCondition = _EmptyTable
  },
  [551] = {
    id = 551,
    Content = "multigm",
    Params = {
      type = "effect",
      effect = "Skill/Eff_Detale_binghe_atk",
      opt = "delete",
      npcid = 808305,
      index = 1
    },
    MapID = 104,
    StartCondition = _EmptyTable
  },
  [552] = {
    id = 552,
    Content = "multigm",
    Params = {
      type = "shakescreen",
      amplitude = 10,
      msec = 1000,
      shaketype = 1,
      sync = 1,
      spec_char = 1
    },
    MapID = 104,
    StartCondition = _EmptyTable
  },
  [553] = {
    id = 553,
    Content = "multigm",
    Params = {
      type = "playaction",
      style = 3,
      id = 502,
      npcid = 808305
    },
    MapID = 104,
    StartCondition = _EmptyTable
  },
  [554] = {
    id = 554,
    Content = "summon",
    Params = {
      id = 808306,
      pos = {
        31.31,
        3.2,
        19.56
      },
      dir = 97.0,
      waitaction = "state2002",
      group_id = 4,
      behavior = 1024,
      ignorenavmesh = 1,
      no_clear = 1
    },
    MapID = 104,
    StartCondition = _EmptyTable
  },
  [555] = {
    id = 555,
    Content = "wait",
    Params = {time = 1},
    MapID = 104,
    StartCondition = _EmptyTable
  },
  [556] = {
    id = 556,
    Content = "dialog",
    Params = {
      dialog = {603906},
      limit_time = 10,
      spec_char = 1
    },
    MapID = 104,
    StartCondition = _EmptyTable
  },
  [557] = {
    id = 557,
    Content = "multigm",
    Params = {
      type = "effect",
      effect = "Skill/MagicRiot_attack",
      opt = "add",
      npcid = 808303,
      times = 1,
      scale = 1.5,
      index = 3
    },
    MapID = 104,
    StartCondition = _EmptyTable
  },
  [558] = {
    id = 558,
    Content = "wait",
    Params = {time = 0},
    MapID = 104,
    StartCondition = _EmptyTable
  },
  [559] = {
    id = 559,
    Content = "clearnpc",
    Params = {
      group_ids = {2, 5}
    },
    MapID = 104,
    StartCondition = _EmptyTable
  },
  [560] = {
    id = 560,
    Content = "summon",
    Params = {
      id = 808304,
      pos = {
        -22.09,
        0.45,
        -62.74
      },
      dir = 122.76,
      group_id = 1,
      no_clear = 1
    },
    MapID = 104,
    StartCondition = _EmptyTable
  },
  [561] = {
    id = 561,
    Content = "wait",
    Params = {time = 1},
    MapID = 104,
    StartCondition = _EmptyTable
  },
  [562] = {
    id = 562,
    Content = "wait_refresh",
    Params = {week_refresh = 1},
    MapID = 104,
    StartCondition = _EmptyTable
  },
  [563] = {
    id = 563,
    Content = "summon",
    Params = {
      id = 280600,
      pos = {
        -34.04,
        3.6,
        -4.74
      },
      dir = 336.41,
      group_id = 1,
      dead_disp_time = 20,
      search = 0
    },
    MapID = 105,
    StartCondition = {after_open_server = 13}
  },
  [564] = {
    id = 564,
    Content = "killall",
    Params = {
      group_ids = {1}
    },
    MapID = 105,
    StartCondition = _EmptyTable
  },
  [565] = {
    id = 565,
    Content = "wait_refresh",
    Params = {exactly_divide_minute = 120},
    MapID = 105,
    StartCondition = _EmptyTable
  },
  [566] = {
    id = 566,
    Content = "weather",
    Params = {
      weather_id = {
        3,
        40,
        47
      }
    },
    MapID = 104,
    StartCondition = _EmptyTable
  },
  [567] = {
    id = 567,
    Content = "summon",
    Params = {
      id = 816224,
      pos = {
        -3.47,
        0.07,
        3.57
      },
      dir = 135.5377,
      group_id = 1
    },
    MapID = 104,
    StartCondition = _EmptyTable
  },
  [568] = {
    id = 568,
    Content = "weather",
    Params = {
      weather_id = {
        1,
        2,
        4,
        5,
        13,
        39,
        46,
        49,
        51,
        53
      }
    },
    MapID = 104,
    StartCondition = _EmptyTable
  },
  [569] = {
    id = 569,
    Content = "clearnpc",
    Params = {
      group_ids = {1}
    },
    MapID = 104,
    StartCondition = _EmptyTable
  },
  [570] = {
    id = 570,
    Content = "wait_refresh",
    Params = {time = 1800},
    MapID = 104,
    StartCondition = _EmptyTable
  },
  [571] = {
    id = 571,
    Content = "weather",
    Params = {
      weather_id = {57}
    },
    MapID = 138,
    StartCondition = _EmptyTable
  },
  [572] = {
    id = 572,
    Content = "summon",
    Params = {
      id = 824430,
      pos = {
        -57.58,
        15.11,
        -10.04
      },
      dir = 80.16666,
      waitaction = "functional_action7",
      group_id = 1
    },
    MapID = 138,
    StartCondition = _EmptyTable
  },
  [573] = {
    id = 573,
    Content = "multigm",
    Params = {
      type = "effect",
      effect = "Skill/Eff_Chainoverload_hit",
      opt = "add",
      npcid = 824430,
      times = 1,
      index = 1
    },
    MapID = 138,
    StartCondition = _EmptyTable
  },
  [574] = {
    id = 574,
    Content = "weather",
    Params = {
      weather_id = {
        58,
        59,
        60,
        61
      }
    },
    MapID = 138,
    StartCondition = _EmptyTable
  },
  [575] = {
    id = 575,
    Content = "multigm",
    Params = {
      type = "effect",
      effect = "Skill/Teleport",
      opt = "add",
      pos = {
        -57.58,
        15.11,
        -10.04
      },
      times = 0,
      index = 2
    },
    MapID = 138,
    StartCondition = _EmptyTable
  },
  [576] = {
    id = 576,
    Content = "clearnpc",
    Params = {
      group_ids = {1}
    },
    MapID = 138,
    StartCondition = _EmptyTable
  },
  [577] = {
    id = 577,
    Content = "wait_refresh",
    Params = {time = 10},
    MapID = 138,
    StartCondition = _EmptyTable
  },
  [578] = {
    id = 578,
    Content = "weather",
    Params = {
      weather_id = {58}
    },
    MapID = 138,
    StartCondition = _EmptyTable
  },
  [579] = {
    id = 579,
    Content = "summon",
    Params = {
      id = 824431,
      pos = {
        20.73,
        15.86,
        -89.98
      },
      dir = 284.1544,
      waitaction = "sit_down",
      group_id = 2
    },
    MapID = 138,
    StartCondition = _EmptyTable
  },
  [580] = {
    id = 580,
    Content = "multigm",
    Params = {
      type = "effect",
      effect = "Skill/Eff_Chainoverload_hit",
      opt = "add",
      npcid = 824431,
      times = 1,
      index = 1
    },
    MapID = 138,
    StartCondition = _EmptyTable
  },
  [581] = {
    id = 581,
    Content = "weather",
    Params = {
      weather_id = {
        57,
        59,
        60,
        61
      }
    },
    MapID = 138,
    StartCondition = _EmptyTable
  },
  [582] = {
    id = 582,
    Content = "multigm",
    Params = {
      type = "effect",
      effect = "Skill/Teleport",
      opt = "add",
      pos = {
        20.73,
        15.86,
        -89.98
      },
      times = 0,
      index = 2
    },
    MapID = 138,
    StartCondition = _EmptyTable
  },
  [583] = {
    id = 583,
    Content = "clearnpc",
    Params = {
      group_ids = {2}
    },
    MapID = 138,
    StartCondition = _EmptyTable
  },
  [584] = {
    id = 584,
    Content = "wait_refresh",
    Params = {time = 10},
    MapID = 138,
    StartCondition = _EmptyTable
  },
  [585] = {
    id = 585,
    Content = "weather",
    Params = {
      weather_id = {59}
    },
    MapID = 138,
    StartCondition = _EmptyTable
  },
  [586] = {
    id = 586,
    Content = "summon",
    Params = {
      id = 824432,
      pos = {
        -5.82,
        16.2,
        22.33
      },
      dir = 219.2,
      waitaction = "collect",
      group_id = 3
    },
    MapID = 138,
    StartCondition = _EmptyTable
  },
  [587] = {
    id = 587,
    Content = "multigm",
    Params = {
      type = "effect",
      effect = "Skill/Eff_Chainoverload_hit",
      opt = "add",
      npcid = 824432,
      times = 1,
      index = 1
    },
    MapID = 138,
    StartCondition = _EmptyTable
  },
  [588] = {
    id = 588,
    Content = "weather",
    Params = {
      weather_id = {
        57,
        58,
        60,
        61
      }
    },
    MapID = 138,
    StartCondition = _EmptyTable
  },
  [589] = {
    id = 589,
    Content = "multigm",
    Params = {
      type = "effect",
      effect = "Skill/Teleport",
      opt = "add",
      pos = {
        -5.82,
        16.2,
        22.33
      },
      times = 0,
      index = 2
    },
    MapID = 138,
    StartCondition = _EmptyTable
  },
  [590] = {
    id = 590,
    Content = "clearnpc",
    Params = {
      group_ids = {3}
    },
    MapID = 138,
    StartCondition = _EmptyTable
  },
  [591] = {
    id = 591,
    Content = "wait_refresh",
    Params = {time = 10},
    MapID = 138,
    StartCondition = _EmptyTable
  },
  [592] = {
    id = 592,
    Content = "weather",
    Params = {
      weather_id = {60}
    },
    MapID = 138,
    StartCondition = _EmptyTable
  },
  [593] = {
    id = 593,
    Content = "summon",
    Params = {
      id = 824433,
      pos = {
        59.33,
        13.67,
        -31.59
      },
      dir = 306,
      waitaction = "die",
      group_id = 4
    },
    MapID = 138,
    StartCondition = _EmptyTable
  },
  [594] = {
    id = 594,
    Content = "multigm",
    Params = {
      type = "effect",
      effect = "Skill/Eff_Chainoverload_hit",
      opt = "add",
      npcid = 824433,
      times = 1,
      index = 1
    },
    MapID = 138,
    StartCondition = _EmptyTable
  },
  [595] = {
    id = 595,
    Content = "weather",
    Params = {
      weather_id = {
        57,
        58,
        59,
        61
      }
    },
    MapID = 138,
    StartCondition = _EmptyTable
  },
  [596] = {
    id = 596,
    Content = "multigm",
    Params = {
      type = "effect",
      effect = "Skill/Teleport",
      opt = "add",
      pos = {
        59.33,
        13.67,
        -31.59
      },
      times = 0,
      index = 2
    },
    MapID = 138,
    StartCondition = _EmptyTable
  },
  [597] = {
    id = 597,
    Content = "clearnpc",
    Params = {
      group_ids = {4}
    },
    MapID = 138,
    StartCondition = _EmptyTable
  },
  [598] = {
    id = 598,
    Content = "wait_refresh",
    Params = {time = 10},
    MapID = 138,
    StartCondition = _EmptyTable
  },
  [599] = {
    id = 599,
    Content = "weather",
    Params = {
      weather_id = {61}
    },
    MapID = 138,
    StartCondition = _EmptyTable
  },
  [600] = {
    id = 600,
    Content = "summon",
    Params = {
      id = 824434,
      pos = {
        27.76,
        15.42,
        37.2
      },
      dir = 169.7498,
      waitaction = "play_sleep",
      group_id = 5
    },
    MapID = 138,
    StartCondition = _EmptyTable
  },
  [601] = {
    id = 601,
    Content = "multigm",
    Params = {
      type = "effect",
      effect = "Skill/Eff_Chainoverload_hit",
      opt = "add",
      npcid = 824434,
      times = 1,
      index = 1
    },
    MapID = 138,
    StartCondition = _EmptyTable
  },
  [602] = {
    id = 602,
    Content = "weather",
    Params = {
      weather_id = {
        57,
        58,
        59,
        60
      }
    },
    MapID = 138,
    StartCondition = _EmptyTable
  },
  [603] = {
    id = 603,
    Content = "multigm",
    Params = {
      type = "effect",
      effect = "Skill/Teleport",
      opt = "add",
      pos = {
        27.76,
        15.42,
        37.2
      },
      times = 0,
      index = 2
    },
    MapID = 138,
    StartCondition = _EmptyTable
  },
  [604] = {
    id = 604,
    Content = "clearnpc",
    Params = {
      group_ids = {5}
    },
    MapID = 138,
    StartCondition = _EmptyTable
  },
  [605] = {
    id = 605,
    Content = "wait_refresh",
    Params = {time = 10},
    MapID = 138,
    StartCondition = _EmptyTable
  },
  [606] = {
    id = 606,
    Content = "summon",
    Params = {
      id = 1203104,
      pos = {
        -104.79,
        22.5,
        76.9
      },
      group_id = 10,
      dead_disp_time = 5,
      territory = 0,
      search = 0
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [607] = {
    id = 607,
    Content = "summon",
    Params = {
      id = 1203100,
      pos = {
        -106.7,
        22.13,
        73.06
      },
      group_id = 1,
      dead_disp_time = 5,
      territory = 0,
      search = 0,
      purse = 6,
      dir = 30
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [608] = {
    id = 608,
    Content = "summon",
    Params = {
      id = 1203100,
      pos = {
        -101.28,
        22.13,
        74.53
      },
      group_id = 1,
      dead_disp_time = 5,
      territory = 0,
      search = 0,
      purse = 6,
      dir = 300
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [609] = {
    id = 609,
    Content = "summon",
    Params = {
      id = 1203100,
      pos = {
        -102.65,
        22.13,
        80.09
      },
      group_id = 1,
      dead_disp_time = 5,
      territory = 0,
      search = 0,
      purse = 6,
      dir = 210
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [610] = {
    id = 610,
    Content = "summon",
    Params = {
      id = 1203100,
      pos = {
        -108.1,
        22.13,
        78.47
      },
      group_id = 1,
      dead_disp_time = 5,
      territory = 0,
      search = 0,
      purse = 6,
      dir = 120
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [611] = {
    id = 611,
    Content = "summon",
    Params = {
      id = 1203100,
      pos = {
        -109.05,
        22.13,
        69
      },
      group_id = 1,
      dead_disp_time = 5,
      territory = 0,
      search = 0,
      purse = 6,
      dir = 30
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [612] = {
    id = 612,
    Content = "summon",
    Params = {
      id = 1203100,
      pos = {
        -97.03,
        22.13,
        72.08
      },
      group_id = 1,
      dead_disp_time = 5,
      territory = 0,
      search = 0,
      purse = 6,
      dir = 300
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [613] = {
    id = 613,
    Content = "summon",
    Params = {
      id = 1203100,
      pos = {
        -100.37,
        22.13,
        84.04
      },
      group_id = 1,
      dead_disp_time = 5,
      territory = 0,
      search = 0,
      purse = 6,
      dir = 210
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [614] = {
    id = 614,
    Content = "summon",
    Params = {
      id = 1203100,
      pos = {
        -112.34,
        22.13,
        80.91
      },
      group_id = 1,
      dead_disp_time = 5,
      territory = 0,
      search = 0,
      purse = 6,
      dir = 120
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [615] = {
    id = 615,
    Content = "summon",
    Params = {
      id = 1203100,
      pos = {
        -103.13,
        22.13,
        71.14
      },
      group_id = 1,
      dead_disp_time = 5,
      territory = 0,
      search = 0,
      purse = 6,
      dir = 345
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [616] = {
    id = 616,
    Content = "summon",
    Params = {
      id = 1203100,
      pos = {
        -99.6,
        22.13,
        77.91
      },
      group_id = 1,
      dead_disp_time = 5,
      territory = 0,
      search = 0,
      purse = 6,
      dir = 255
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [617] = {
    id = 617,
    Content = "summon",
    Params = {
      id = 1203100,
      pos = {
        -105.99,
        22.13,
        81.78
      },
      group_id = 1,
      dead_disp_time = 5,
      territory = 0,
      search = 0,
      purse = 6,
      dir = 165
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [618] = {
    id = 618,
    Content = "summon",
    Params = {
      id = 1203100,
      pos = {
        -109.8,
        22.13,
        75.18
      },
      group_id = 1,
      dead_disp_time = 5,
      territory = 0,
      search = 0,
      purse = 6,
      dir = 75
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [619] = {
    id = 619,
    Content = "killall",
    Params = {
      group_ids = {1}
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [620] = {
    id = 620,
    Content = "summon",
    Params = {
      id = 1203142,
      pos = {
        -104.89,
        22.85,
        76.58
      },
      group_id = 10,
      territory = 0,
      search = 0
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [621] = {
    id = 621,
    Content = "wait",
    Params = {time = 2},
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [622] = {
    id = 622,
    Content = "summon",
    Params = {
      id = 320030,
      pos = {
        -104.89,
        22.85,
        76.58
      },
      group_id = 2,
      dead_disp_time = 900,
      territory = 10,
      search = 10,
      purse = 10
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [623] = {
    id = 623,
    Content = "wait",
    Params = {time = 2},
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [624] = {
    id = 624,
    Content = "clearnpc",
    Params = {
      npcid = {1203115}
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [625] = {
    id = 625,
    Content = "clearnpc",
    Params = {
      group_ids = {10}
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [626] = {
    id = 626,
    Content = "killall",
    Params = {
      group_ids = {2}
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [627] = {
    id = 627,
    Content = "wait_refresh",
    Params = {time = 1800, work_time_type = 1},
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [628] = {
    id = 628,
    Content = "summon",
    Params = {
      id = 1203107,
      pos = {
        -136.49,
        15.34,
        -90.38
      },
      group_id = 1,
      dead_disp_time = 5,
      territory = 0,
      search = 0
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [629] = {
    id = 629,
    Content = "wait_super_ai",
    Params = _EmptyTable,
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [630] = {
    id = 630,
    Content = "killall",
    Params = {
      group_ids = {1}
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [631] = {
    id = 631,
    Content = "del_map_zone",
    Params = {map_zone = 102, type = 1},
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [632] = {
    id = 632,
    Content = "wait_refresh",
    Params = {time = 10},
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [633] = {
    id = 633,
    Content = "count_down_zone",
    Params = {map_zone = 102, time = 30},
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [634] = {
    id = 634,
    Content = "wait",
    Params = {time = 30},
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [635] = {
    id = 635,
    Content = "stop_other",
    Params = _EmptyTable,
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [636] = {
    id = 636,
    Content = "clearnpc",
    Params = {
      npcid = {1203105, 1203106}
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [637] = {
    id = 637,
    Content = "clearnpc",
    Params = {
      group_ids = {1}
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [638] = {
    id = 638,
    Content = "summon",
    Params = {
      id = 1203142,
      pos = {
        -136.49,
        15.34,
        -90.38
      },
      group_id = 10,
      territory = 0,
      search = 0
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [639] = {
    id = 639,
    Content = "wait",
    Params = {time = 2},
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [640] = {
    id = 640,
    Content = "summon",
    Params = {
      id = 320050,
      pos = {
        -136.49,
        15.34,
        -90.38
      },
      group_id = 2,
      dead_disp_time = 900,
      territory = 10,
      search = 10,
      purse = 10
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [641] = {
    id = 641,
    Content = "wait",
    Params = {time = 2},
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [642] = {
    id = 642,
    Content = "clearnpc",
    Params = {
      group_ids = {10}
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [643] = {
    id = 643,
    Content = "killall",
    Params = {
      group_ids = {2}
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [644] = {
    id = 644,
    Content = "wait_refresh",
    Params = {time = 1800, work_time_type = 1},
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [645] = {
    id = 645,
    Content = "multigm",
    Params = {
      type = "effect",
      effect = "Skill/Task_NecromancerSummons",
      opt = "add",
      pos = {
        2.17,
        16.92,
        -88.13
      },
      times = 1
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [646] = {
    id = 646,
    Content = "wait",
    Params = {time = 3},
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [647] = {
    id = 647,
    Content = "summon",
    Params = {
      id = 1203001,
      pos = {
        62.73,
        1.28,
        -34.57
      },
      group_id = 1,
      dead_disp_time = 20,
      territory = 0,
      search = 0,
      dir = 152,
      purse = 10
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [648] = {
    id = 648,
    Content = "summon",
    Params = {
      id = 1202001,
      pos = {
        55.65,
        1.28,
        -33.58
      },
      group_id = 3,
      dead_disp_time = 20,
      territory = 0,
      search = 0,
      dir = 152,
      purse = 10,
      ai = 25540
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [649] = {
    id = 649,
    Content = "summon",
    Params = {
      id = 1202001,
      pos = {
        58.65,
        1.28,
        -36.88
      },
      group_id = 3,
      dead_disp_time = 20,
      territory = 0,
      search = 0,
      dir = 152,
      purse = 10,
      ai = 25540
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [650] = {
    id = 650,
    Content = "summon",
    Params = {
      id = 1202001,
      pos = {
        63.86,
        1.28,
        -37.45
      },
      group_id = 3,
      dead_disp_time = 20,
      territory = 0,
      search = 0,
      dir = 152,
      purse = 10,
      ai = 25540
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [651] = {
    id = 651,
    Content = "summon",
    Params = {
      id = 1202001,
      pos = {
        66.44,
        1.28,
        -32.46
      },
      group_id = 3,
      dead_disp_time = 20,
      territory = 0,
      search = 0,
      dir = 152,
      purse = 10,
      ai = 25540
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [652] = {
    id = 652,
    Content = "summon",
    Params = {
      id = 1202001,
      pos = {
        65.61,
        1.28,
        -28.2
      },
      group_id = 3,
      dead_disp_time = 20,
      territory = 0,
      search = 0,
      dir = 152,
      purse = 10,
      ai = 25540
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [653] = {
    id = 653,
    Content = "summon",
    Params = {
      id = 818330,
      pos = {
        61.441,
        1.28,
        -32.352
      },
      group_id = 2,
      territory = 0,
      search = 0,
      dir = 152,
      no_clear = 1
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [654] = {
    id = 654,
    Content = "killall",
    Params = {
      group_ids = {1}
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [655] = {
    id = 655,
    Content = "wait_refresh",
    Params = {time = 300, work_time_type = 1},
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [656] = {
    id = 656,
    Content = "multigm",
    Params = {
      type = "effect",
      effect = "Skill/Task_NecromancerSummons",
      opt = "add",
      pos = {
        2.17,
        16.92,
        -88.13
      },
      times = 1
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [657] = {
    id = 657,
    Content = "wait",
    Params = {time = 3},
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [658] = {
    id = 658,
    Content = "summon",
    Params = {
      id = 1203002,
      pos = {
        -9.66,
        7.29,
        -104.47
      },
      group_id = 1,
      dead_disp_time = 20,
      territory = 0,
      search = 0,
      dir = 64,
      purse = 10
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [659] = {
    id = 659,
    Content = "summon",
    Params = {
      id = 818330,
      pos = {
        -12.72,
        7.29,
        -106.03
      },
      group_id = 2,
      territory = 0,
      search = 0,
      dir = 64,
      no_clear = 1
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [660] = {
    id = 660,
    Content = "summon",
    Params = {
      id = 1202001,
      pos = {
        -9.398804,
        7.29,
        -110.7685
      },
      group_id = 3,
      dead_disp_time = 20,
      territory = 0,
      search = 0,
      dir = 64,
      purse = 10,
      ai = 25540
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [661] = {
    id = 661,
    Content = "summon",
    Params = {
      id = 1202001,
      pos = {
        -6.060401,
        7.29,
        -107.8113
      },
      group_id = 3,
      dead_disp_time = 20,
      territory = 0,
      search = 0,
      dir = 64,
      purse = 10,
      ai = 25540
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [662] = {
    id = 662,
    Content = "summon",
    Params = {
      id = 1202001,
      pos = {
        -5.423309,
        7.29,
        -102.6091
      },
      group_id = 3,
      dead_disp_time = 20,
      territory = 0,
      search = 0,
      dir = 64,
      purse = 10,
      ai = 25540
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [663] = {
    id = 663,
    Content = "summon",
    Params = {
      id = 1202001,
      pos = {
        -10.37964,
        7.29,
        -99.96497
      },
      group_id = 3,
      dead_disp_time = 20,
      territory = 0,
      search = 0,
      dir = 64,
      purse = 10,
      ai = 25540
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [664] = {
    id = 664,
    Content = "summon",
    Params = {
      id = 1202001,
      pos = {
        -14.65,
        7.29,
        -100.74
      },
      group_id = 3,
      dead_disp_time = 20,
      territory = 0,
      search = 0,
      dir = 64,
      purse = 10
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [665] = {
    id = 665,
    Content = "killall",
    Params = {
      group_ids = {1}
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [666] = {
    id = 666,
    Content = "wait_refresh",
    Params = {time = 300, work_time_type = 1},
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [667] = {
    id = 667,
    Content = "multigm",
    Params = {
      type = "effect",
      effect = "Skill/Task_NecromancerSummons",
      opt = "add",
      pos = {
        2.17,
        16.92,
        -88.13
      },
      times = 1
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [668] = {
    id = 668,
    Content = "wait",
    Params = {time = 3},
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [669] = {
    id = 669,
    Content = "summon",
    Params = {
      id = 1203003,
      pos = {
        91.19,
        8.2,
        19.44
      },
      group_id = 1,
      dead_disp_time = 20,
      territory = 0,
      search = 0,
      dir = 230,
      purse = 10
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [670] = {
    id = 670,
    Content = "summon",
    Params = {
      id = 818329,
      pos = {
        94.3,
        8.2,
        21.81
      },
      group_id = 2,
      territory = 0,
      search = 0,
      dir = 230,
      no_clear = 1
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [671] = {
    id = 671,
    Content = "summon",
    Params = {
      id = 1202006,
      pos = {
        90.8073,
        8.2,
        26.26636
      },
      group_id = 3,
      dead_disp_time = 20,
      territory = 0,
      search = 0,
      dir = 230,
      purse = 10,
      ai = 25540
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [672] = {
    id = 672,
    Content = "summon",
    Params = {
      id = 1202006,
      pos = {
        87.8216,
        8.2,
        22.95347
      },
      group_id = 3,
      dead_disp_time = 20,
      territory = 0,
      search = 0,
      dir = 230,
      purse = 10,
      ai = 25540
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [673] = {
    id = 673,
    Content = "summon",
    Params = {
      id = 1202006,
      pos = {
        87.77191,
        8.2,
        17.71259
      },
      group_id = 3,
      dead_disp_time = 20,
      territory = 0,
      search = 0,
      dir = 230,
      purse = 10,
      ai = 25540
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [674] = {
    id = 674,
    Content = "summon",
    Params = {
      id = 1202006,
      pos = {
        92.99355,
        8.2,
        15.64097
      },
      group_id = 3,
      dead_disp_time = 20,
      territory = 0,
      search = 0,
      dir = 230,
      purse = 10,
      ai = 25540
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [675] = {
    id = 675,
    Content = "summon",
    Params = {
      id = 1202006,
      pos = {
        97.15,
        8.2,
        16.89
      },
      group_id = 3,
      dead_disp_time = 20,
      territory = 0,
      search = 0,
      dir = 230,
      purse = 10,
      ai = 25540
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [676] = {
    id = 676,
    Content = "killall",
    Params = {
      group_ids = {1}
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [677] = {
    id = 677,
    Content = "wait_refresh",
    Params = {time = 300, work_time_type = 1},
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [678] = {
    id = 678,
    Content = "multigm",
    Params = {
      type = "effect",
      effect = "Skill/Task_NecromancerSummons",
      opt = "add",
      pos = {
        2.17,
        16.92,
        -88.13
      },
      times = 1
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [679] = {
    id = 679,
    Content = "wait",
    Params = {time = 3},
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [680] = {
    id = 680,
    Content = "summon",
    Params = {
      id = 1203004,
      pos = {
        87.04,
        21.48,
        74.55
      },
      group_id = 1,
      dead_disp_time = 20,
      territory = 0,
      search = 0,
      dir = 279,
      purse = 10
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [681] = {
    id = 681,
    Content = "summon",
    Params = {
      id = 818329,
      pos = {
        90.55,
        21.48,
        73.98
      },
      group_id = 2,
      territory = 0,
      search = 0,
      dir = 279,
      no_clear = 1
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [682] = {
    id = 682,
    Content = "summon",
    Params = {
      id = 1202006,
      pos = {
        89.90845,
        21.48,
        79.54097
      },
      group_id = 3,
      dead_disp_time = 20,
      territory = 0,
      search = 0,
      dir = 279,
      purse = 10,
      ai = 25540
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [683] = {
    id = 683,
    Content = "summon",
    Params = {
      id = 1202006,
      pos = {
        85.47253,
        21.48,
        79.07999
      },
      group_id = 3,
      dead_disp_time = 20,
      territory = 0,
      search = 0,
      dir = 279,
      purse = 10,
      ai = 25540
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [684] = {
    id = 684,
    Content = "summon",
    Params = {
      id = 1202006,
      pos = {
        81.92605,
        21.48,
        75.22105
      },
      group_id = 3,
      dead_disp_time = 20,
      territory = 0,
      search = 0,
      dir = 279,
      purse = 10,
      ai = 25540
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [685] = {
    id = 685,
    Content = "summon",
    Params = {
      id = 1202006,
      pos = {
        84.41668,
        21.48,
        70.18577
      },
      group_id = 3,
      dead_disp_time = 20,
      territory = 0,
      search = 0,
      dir = 279,
      purse = 10,
      ai = 25540
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [686] = {
    id = 686,
    Content = "summon",
    Params = {
      id = 1202006,
      pos = {
        88.34,
        21.48,
        68.33
      },
      group_id = 3,
      dead_disp_time = 20,
      territory = 0,
      search = 0,
      dir = 279,
      purse = 10,
      ai = 25540
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [687] = {
    id = 687,
    Content = "killall",
    Params = {
      group_ids = {1}
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [688] = {
    id = 688,
    Content = "wait_refresh",
    Params = {time = 300, work_time_type = 1},
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [689] = {
    id = 689,
    Content = "multigm",
    Params = {
      type = "effect",
      effect = "Skill/Task_NecromancerSummons",
      opt = "add",
      pos = {
        2.17,
        16.92,
        -88.13
      },
      times = 1
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [690] = {
    id = 690,
    Content = "wait",
    Params = {time = 3},
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [691] = {
    id = 691,
    Content = "summon",
    Params = {
      id = 1203005,
      pos = {
        34.76,
        21.8,
        26.28
      },
      group_id = 1,
      dead_disp_time = 20,
      territory = 0,
      search = 0,
      dir = 337,
      purse = 10
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [692] = {
    id = 692,
    Content = "summon",
    Params = {
      id = 818328,
      pos = {
        36,
        21.8,
        22.87
      },
      group_id = 2,
      territory = 0,
      search = 0,
      dir = 337,
      no_clear = 1
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [693] = {
    id = 693,
    Content = "summon",
    Params = {
      id = 1202004,
      pos = {
        41.36715,
        21.48,
        25.10052
      },
      group_id = 3,
      dead_disp_time = 20,
      territory = 0,
      search = 0,
      dir = 337,
      purse = 10,
      ai = 25540
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [694] = {
    id = 694,
    Content = "summon",
    Params = {
      id = 1202004,
      pos = {
        38.63358,
        21.48,
        28.62437
      },
      group_id = 3,
      dead_disp_time = 20,
      territory = 0,
      search = 0,
      dir = 337,
      purse = 10,
      ai = 25540
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [695] = {
    id = 695,
    Content = "summon",
    Params = {
      id = 1202004,
      pos = {
        33.48388,
        21.48,
        29.59878
      },
      group_id = 3,
      dead_disp_time = 20,
      territory = 0,
      search = 0,
      dir = 337,
      purse = 10,
      ai = 25540
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [696] = {
    id = 696,
    Content = "summon",
    Params = {
      id = 1202004,
      pos = {
        30.52264,
        21.48,
        24.82505
      },
      group_id = 3,
      dead_disp_time = 20,
      territory = 0,
      search = 0,
      dir = 337,
      purse = 10,
      ai = 25540
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [697] = {
    id = 697,
    Content = "summon",
    Params = {
      id = 1202004,
      pos = {
        31.01807,
        21.48,
        20.51333
      },
      group_id = 3,
      dead_disp_time = 20,
      territory = 0,
      search = 0,
      dir = 337,
      purse = 10,
      ai = 25540
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [698] = {
    id = 698,
    Content = "killall",
    Params = {
      group_ids = {1}
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [699] = {
    id = 699,
    Content = "wait_refresh",
    Params = {time = 300, work_time_type = 1},
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [700] = {
    id = 700,
    Content = "multigm",
    Params = {
      type = "effect",
      effect = "Skill/Task_NecromancerSummons",
      opt = "add",
      pos = {
        2.17,
        16.92,
        -88.13
      },
      times = 1
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [701] = {
    id = 701,
    Content = "wait",
    Params = {time = 3},
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [702] = {
    id = 702,
    Content = "summon",
    Params = {
      id = 1203007,
      pos = {
        -25.17,
        19.74,
        9.16
      },
      group_id = 1,
      dead_disp_time = 20,
      territory = 0,
      search = 0,
      dir = 63,
      purse = 10
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [703] = {
    id = 703,
    Content = "summon",
    Params = {
      id = 818328,
      pos = {
        -28.47,
        19.74,
        7.18
      },
      group_id = 2,
      territory = 0,
      search = 0,
      dir = 63,
      no_clear = 1
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [704] = {
    id = 704,
    Content = "summon",
    Params = {
      id = 1202004,
      pos = {
        -25.13042,
        19.74,
        2.73155
      },
      group_id = 3,
      dead_disp_time = 20,
      territory = 0,
      search = 0,
      dir = 63,
      purse = 10,
      ai = 25540
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [705] = {
    id = 705,
    Content = "summon",
    Params = {
      id = 1202004,
      pos = {
        -22.10358,
        19.74,
        6.004215
      },
      group_id = 3,
      dead_disp_time = 20,
      territory = 0,
      search = 0,
      dir = 63,
      purse = 10,
      ai = 25540
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [706] = {
    id = 706,
    Content = "summon",
    Params = {
      id = 1202004,
      pos = {
        -21.98671,
        19.74,
        11.24332
      },
      group_id = 3,
      dead_disp_time = 20,
      territory = 0,
      search = 0,
      dir = 63,
      purse = 10,
      ai = 25540
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [707] = {
    id = 707,
    Content = "summon",
    Params = {
      id = 1202004,
      pos = {
        -27.17942,
        19.74,
        13.38375
      },
      group_id = 3,
      dead_disp_time = 20,
      territory = 0,
      search = 0,
      dir = 63,
      purse = 10,
      ai = 25540
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [708] = {
    id = 708,
    Content = "summon",
    Params = {
      id = 1202004,
      pos = {
        -31.35,
        19.74,
        12.19
      },
      group_id = 3,
      dead_disp_time = 20,
      territory = 0,
      search = 0,
      dir = 63,
      purse = 10,
      ai = 25540
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [709] = {
    id = 709,
    Content = "killall",
    Params = {
      group_ids = {1}
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [710] = {
    id = 710,
    Content = "wait_refresh",
    Params = {time = 300, work_time_type = 1},
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [711] = {
    id = 711,
    Content = "multigm",
    Params = {
      type = "effect",
      effect = "Skill/Task_NecromancerSummons",
      opt = "add",
      pos = {
        2.17,
        16.92,
        -88.13
      },
      times = 1
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [712] = {
    id = 712,
    Content = "wait",
    Params = {time = 3},
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [713] = {
    id = 713,
    Content = "summon",
    Params = {
      id = 1203006,
      pos = {
        -78.34,
        12.28,
        -79.61
      },
      group_id = 1,
      dead_disp_time = 20,
      territory = 0,
      search = 0,
      dir = 335,
      purse = 10
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [714] = {
    id = 714,
    Content = "summon",
    Params = {
      id = 818328,
      pos = {
        -76.73,
        12.28,
        -83.65
      },
      group_id = 2,
      territory = 0,
      search = 0,
      dir = 335,
      no_clear = 1
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [715] = {
    id = 715,
    Content = "summon",
    Params = {
      id = 1202005,
      pos = {
        -71.9342,
        12.28,
        -79.8372
      },
      group_id = 3,
      dead_disp_time = 20,
      territory = 0,
      search = 0,
      dir = 335,
      purse = 10,
      ai = 25540
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [716] = {
    id = 716,
    Content = "summon",
    Params = {
      id = 1202005,
      pos = {
        -74.94549,
        12.28,
        -76.54765
      },
      group_id = 3,
      dead_disp_time = 20,
      territory = 0,
      search = 0,
      dir = 335,
      purse = 10,
      ai = 25540
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [717] = {
    id = 717,
    Content = "summon",
    Params = {
      id = 1202005,
      pos = {
        -80.15565,
        12.28,
        -75.99525
      },
      group_id = 3,
      dead_disp_time = 20,
      territory = 0,
      search = 0,
      dir = 335,
      purse = 10,
      ai = 25540
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [718] = {
    id = 718,
    Content = "summon",
    Params = {
      id = 1202005,
      pos = {
        -82.71588,
        12.28,
        -80.99335
      },
      group_id = 3,
      dead_disp_time = 20,
      territory = 0,
      search = 0,
      dir = 335,
      purse = 10,
      ai = 25540
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [719] = {
    id = 719,
    Content = "summon",
    Params = {
      id = 1202005,
      pos = {
        -81.87,
        12.28,
        -85.25
      },
      group_id = 3,
      dead_disp_time = 20,
      territory = 0,
      search = 0,
      dir = 335,
      purse = 10,
      ai = 25540
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [720] = {
    id = 720,
    Content = "killall",
    Params = {
      group_ids = {1}
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [721] = {
    id = 721,
    Content = "wait_refresh",
    Params = {time = 300, work_time_type = 1},
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [722] = {
    id = 722,
    Content = "set_obj_state",
    Params = {
      obj_states = {
        {
          obj = 17,
          state = "mfx_scmvp3_yanfire_state1001"
        },
        {
          obj = 19,
          state = "mfx_scmvp3_yanfire_state1001"
        },
        {
          obj = 22,
          state = "mfx_scmvp3_shifire_state1001"
        },
        {
          obj = 20,
          state = "mfx_scmvp3_yanfire_state1001"
        },
        {
          obj = 21,
          state = "mfx_scmvp3_yanfire_state1001"
        },
        {
          obj = 18,
          state = "mfx_scmvp3_shifire_state1001"
        },
        {
          obj = 10,
          state = "mfx_scmvp3_fire01_blue_state1001"
        }
      }
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [723] = {
    id = 723,
    Content = "in_order_kill",
    Params = {
      order_kill_npc = {
        1203162,
        1203163,
        1203164,
        1203165
      },
      show_type = 3,
      pos_data = {
        {
          pos = {
            115.84,
            1.1,
            -66.49
          },
          obj_id = 8,
          dir = 41,
          state = {
            [0] = "mfx_scmvp3_fire02_4_state1001",
            [1] = "mfx_scmvp3_fire02_4_state2001"
          }
        },
        {
          pos = {
            126.38,
            11.1,
            -51.67
          },
          obj_id = 5,
          dir = 218.5,
          state = {
            [0] = "mfx_scmvp3_fire02_1_state1001",
            [1] = "mfx_scmvp3_fire02_1_state2001"
          }
        },
        {
          pos = {
            117.06,
            1.1,
            -51.11
          },
          obj_id = 7,
          dir = 151.4,
          state = {
            [0] = "mfx_scmvp3_fire02_3_state1001",
            [1] = "mfx_scmvp3_fire02_3_state2001"
          }
        },
        {
          pos = {
            126.02,
            1.1,
            -67.62
          },
          obj_id = 6,
          dir = 331.7,
          state = {
            [0] = "mfx_scmvp3_fire02_2_state1001",
            [1] = "mfx_scmvp3_fire02_2_state2001"
          }
        }
      },
      fail_buffs = {
        159797,
        159798,
        159815
      },
      no_rand = 1
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [724] = {
    id = 724,
    Content = "set_obj_state",
    Params = {
      obj_states = {
        {
          obj = 10,
          state = "mfx_scmvp3_fire01_blue_state2001"
        },
        {
          obj = 20,
          state = "mfx_scmvp3_yanfire_state2001"
        },
        {
          obj = 21,
          state = "mfx_scmvp3_yanfire_state2001"
        },
        {
          obj = 17,
          state = "mfx_scmvp3_yanfire_state2001"
        },
        {
          obj = 19,
          state = "mfx_scmvp3_yanfire_state2001"
        },
        {
          obj = 22,
          state = "mfx_scmvp3_shifire_state2001"
        },
        {
          obj = 18,
          state = "mfx_scmvp3_shifire_state2001"
        }
      }
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [725] = {
    id = 725,
    Content = "summon",
    Params = {
      id = 1203142,
      pos = {
        120.03,
        1.36,
        -59.14
      },
      group_id = 10,
      territory = 0,
      search = 0
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [726] = {
    id = 726,
    Content = "wait",
    Params = {time = 2},
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [727] = {
    id = 727,
    Content = "summon",
    Params = {
      id = 320010,
      pos = {
        120.03,
        1.36,
        -59.14
      },
      group_id = 6,
      dead_disp_time = 900,
      territory = 10,
      search = 10
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [728] = {
    id = 728,
    Content = "wait",
    Params = {time = 1},
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [729] = {
    id = 729,
    Content = "clearnpc",
    Params = {
      group_ids = {10}
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [730] = {
    id = 730,
    Content = "killall",
    Params = {
      group_ids = {6}
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [731] = {
    id = 731,
    Content = "wait_refresh",
    Params = {time = 1800, work_time_type = 1},
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [732] = {
    id = 732,
    Content = "summon",
    Params = {
      id = 1203111,
      pos = {
        47.34,
        20.42,
        109.81
      },
      group_id = 1,
      dead_disp_time = 5,
      territory = 0,
      search = 0,
      purse = 6
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [733] = {
    id = 733,
    Content = "attack",
    Params = {group_id = 1},
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [734] = {
    id = 734,
    Content = "summon",
    Params = {
      id = 1203118,
      pos = {
        47.34,
        20.42,
        109.81
      },
      group_id = 10,
      territory = 0,
      search = 0
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [735] = {
    id = 735,
    Content = "summon",
    Params = {
      id = 1203111,
      randpos = 1,
      xrange = {min = 45, max = 50},
      zrange = {min = 107, max = 112},
      group_id = 2,
      dead_disp_time = 5,
      territory = 3,
      search = 5,
      purse = 6
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [736] = {
    id = 736,
    Content = "summon",
    Params = {
      id = 1203111,
      randpos = 1,
      xrange = {min = 45, max = 50},
      zrange = {min = 107, max = 112},
      group_id = 2,
      dead_disp_time = 5,
      territory = 3,
      search = 5,
      purse = 6
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [737] = {
    id = 737,
    Content = "summon",
    Params = {
      id = 1203111,
      randpos = 1,
      xrange = {min = 45, max = 50},
      zrange = {min = 107, max = 112},
      group_id = 2,
      dead_disp_time = 5,
      territory = 3,
      search = 5,
      purse = 6
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [738] = {
    id = 738,
    Content = "wait",
    Params = {time = 10},
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [739] = {
    id = 739,
    Content = "summon",
    Params = {
      id = 1203111,
      randpos = 1,
      xrange = {min = 45, max = 50},
      zrange = {min = 107, max = 112},
      group_id = 3,
      dead_disp_time = 5,
      territory = 3,
      search = 5,
      purse = 6
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [740] = {
    id = 740,
    Content = "summon",
    Params = {
      id = 1203111,
      randpos = 1,
      xrange = {min = 45, max = 50},
      zrange = {min = 107, max = 112},
      group_id = 3,
      dead_disp_time = 5,
      territory = 3,
      search = 5,
      purse = 6
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [741] = {
    id = 741,
    Content = "summon",
    Params = {
      id = 1203111,
      randpos = 1,
      xrange = {min = 45, max = 50},
      zrange = {min = 107, max = 112},
      group_id = 3,
      dead_disp_time = 5,
      territory = 3,
      search = 5,
      purse = 6
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [742] = {
    id = 742,
    Content = "wait",
    Params = {time = 10},
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [743] = {
    id = 743,
    Content = "summon",
    Params = {
      id = 1203111,
      randpos = 1,
      xrange = {min = 45, max = 50},
      zrange = {min = 107, max = 112},
      group_id = 4,
      dead_disp_time = 5,
      territory = 3,
      search = 5,
      purse = 6
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [744] = {
    id = 744,
    Content = "summon",
    Params = {
      id = 1203111,
      randpos = 1,
      xrange = {min = 45, max = 50},
      zrange = {min = 107, max = 112},
      group_id = 4,
      dead_disp_time = 5,
      territory = 3,
      search = 5,
      purse = 6
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [745] = {
    id = 745,
    Content = "summon",
    Params = {
      id = 1203111,
      randpos = 1,
      xrange = {min = 45, max = 50},
      zrange = {min = 107, max = 112},
      group_id = 4,
      dead_disp_time = 5,
      territory = 3,
      search = 5,
      purse = 6
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [746] = {
    id = 746,
    Content = "killall",
    Params = {
      group_ids = {
        1,
        2,
        3,
        4
      }
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [747] = {
    id = 747,
    Content = "summon",
    Params = {
      id = 1203142,
      pos = {
        47.34,
        20.42,
        109.81
      },
      group_id = 10,
      territory = 0,
      search = 0
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [748] = {
    id = 748,
    Content = "wait",
    Params = {time = 2},
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [749] = {
    id = 749,
    Content = "summon",
    Params = {
      id = 320020,
      pos = {
        47.34,
        20.42,
        109.81
      },
      group_id = 5,
      dead_disp_time = 900,
      territory = 10,
      search = 10
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [750] = {
    id = 750,
    Content = "clearnpc",
    Params = {
      group_ids = {10}
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [751] = {
    id = 751,
    Content = "killall",
    Params = {
      group_ids = {5}
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [752] = {
    id = 752,
    Content = "wait_refresh",
    Params = {time = 1800, work_time_type = 1},
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [753] = {
    id = 753,
    Content = "wait_super_ai",
    Params = _EmptyTable,
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [754] = {
    id = 754,
    Content = "wait_refresh",
    Params = {time = 5},
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [755] = {
    id = 755,
    Content = "set_obj_state",
    Params = {
      obj_states = {
        {
          obj = 11,
          state = "mfx_scmvp3_yanfire_state1001"
        },
        {
          obj = 14,
          state = "mfx_scmvp3_yanfire_state1001"
        },
        {
          obj = 12,
          state = "mfx_scmvp3_shifire_state1001"
        },
        {
          obj = 15,
          state = "mfx_scmvp3_yanfire_state1001"
        },
        {
          obj = 16,
          state = "mfx_scmvp3_yanfire_state1001"
        },
        {
          obj = 13,
          state = "mfx_scmvp3_shifire_state1001"
        },
        {
          obj = 9,
          state = "mfx_scmvp3_fire01_blue_state1001"
        }
      }
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [756] = {
    id = 756,
    Content = "in_order_kill",
    Params = {
      order_kill_npc = {
        1203167,
        1203168,
        1203169,
        1203170
      },
      show_type = 2,
      pos_data = {
        {
          pos = {
            -17.84,
            9.08,
            -42.25
          },
          obj_id = 1,
          dir = 30.8,
          state = {
            [0] = "mfx_scmvp3_fire02_1_state1001",
            [1] = "mfx_scmvp3_fire02_1_state3001"
          }
        },
        {
          pos = {
            -18.41,
            9.08,
            -25.97
          },
          obj_id = 2,
          dir = 149.6,
          state = {
            [0] = "mfx_scmvp3_fire02_2_state1001",
            [1] = "mfx_scmvp3_fire02_2_state3001"
          }
        },
        {
          pos = {
            -8.14,
            9.08,
            -41.58
          },
          obj_id = 3,
          dir = 324.3,
          state = {
            [0] = "mfx_scmvp3_fire02_3_state1001",
            [1] = "mfx_scmvp3_fire02_3_state3001"
          }
        },
        {
          pos = {
            -9.14,
            9.08,
            -25.48
          },
          obj_id = 4,
          dir = 209.4,
          state = {
            [0] = "mfx_scmvp3_fire02_4_state1001",
            [1] = "mfx_scmvp3_fire02_4_state3001"
          }
        }
      },
      fail_buffs = {
        159797,
        159798,
        159815
      }
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [757] = {
    id = 757,
    Content = "set_obj_state",
    Params = {
      obj_states = {
        {
          obj = 11,
          state = "mfx_scmvp3_yanfire_state2001"
        },
        {
          obj = 14,
          state = "mfx_scmvp3_yanfire_state2001"
        },
        {
          obj = 12,
          state = "mfx_scmvp3_shifire_state2001"
        },
        {
          obj = 15,
          state = "mfx_scmvp3_yanfire_state2001"
        },
        {
          obj = 16,
          state = "mfx_scmvp3_yanfire_state2001"
        },
        {
          obj = 13,
          state = "mfx_scmvp3_shifire_state2001"
        },
        {
          obj = 9,
          state = "mfx_scmvp3_fire01_blue_state2001"
        }
      }
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [758] = {
    id = 758,
    Content = "summon",
    Params = {
      id = 1203142,
      pos = {
        -14.1,
        9.12,
        -34.14
      },
      group_id = 10,
      territory = 0,
      search = 0
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [759] = {
    id = 759,
    Content = "wait",
    Params = {time = 2},
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [760] = {
    id = 760,
    Content = "summon",
    Params = {
      id = 320040,
      pos = {
        -14.1,
        9.12,
        -34.14
      },
      group_id = 6,
      dead_disp_time = 900,
      territory = 10,
      search = 10
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [761] = {
    id = 761,
    Content = "wait",
    Params = {time = 1},
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [762] = {
    id = 762,
    Content = "clearnpc",
    Params = {
      group_ids = {10}
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [763] = {
    id = 763,
    Content = "killall",
    Params = {
      group_ids = {6}
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [764] = {
    id = 764,
    Content = "wait_refresh",
    Params = {time = 1800, work_time_type = 1},
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [765] = {
    id = 765,
    Content = "clearnpc",
    Params = {
      npcid = {294110, 294111}
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [766] = {
    id = 766,
    Content = "move",
    Params = {
      pos = {
        -165.41,
        29.06,
        35.19
      },
      distance = 10,
      record_char = 1
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [767] = {
    id = 767,
    Content = "multigm",
    Params = {
      type = "effect",
      effect = "Skill/SwordCall",
      pos = {
        -165.41,
        30.15,
        35.19
      },
      times = 1,
      ignorenavmesh = 1,
      scale = 2
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [768] = {
    id = 768,
    Content = "summon",
    Params = {
      id = 294114,
      pos = {
        -165.41,
        30.15,
        35.19
      },
      group_id = 10,
      dir = 130,
      ignorenavmesh = 1
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [769] = {
    id = 769,
    Content = "multigm",
    Params = {
      type = "shakescreen",
      amplitude = 10,
      msec = 8000,
      shaketype = 1,
      sync = 1
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [770] = {
    id = 770,
    Content = "multigm",
    Params = {
      type = "effect",
      effect = "Skill/SwordCall",
      pos = {
        -161.31,
        30.0,
        15.63
      },
      times = 1,
      ignorenavmesh = 1,
      scale = 2
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [771] = {
    id = 771,
    Content = "multigm",
    Params = {
      type = "effect",
      effect = "Skill/SwordCall",
      pos = {
        -146.42,
        30.0,
        41.46
      },
      times = 1,
      ignorenavmesh = 1,
      scale = 2
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [772] = {
    id = 772,
    Content = "multigm",
    Params = {
      type = "effect",
      effect = "Skill/SwordCall",
      pos = {
        -184.44,
        30.0,
        29.09
      },
      times = 1,
      ignorenavmesh = 1,
      scale = 2
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [773] = {
    id = 773,
    Content = "multigm",
    Params = {
      type = "effect",
      effect = "Skill/SwordCall",
      pos = {
        -169.32,
        30.0,
        54.7
      },
      times = 1,
      ignorenavmesh = 1,
      scale = 2
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [774] = {
    id = 774,
    Content = "summon",
    Params = {
      id = 294113,
      pos = {
        -161.31,
        30.0,
        15.63
      },
      group_id = 20,
      dir = 0,
      ignorenavmesh = 1
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [775] = {
    id = 775,
    Content = "summon",
    Params = {
      id = 294113,
      pos = {
        -146.42,
        30.0,
        41.46
      },
      group_id = 30,
      dir = 0,
      ignorenavmesh = 1
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [776] = {
    id = 776,
    Content = "summon",
    Params = {
      id = 294113,
      pos = {
        -184.44,
        30.0,
        29.09
      },
      group_id = 40,
      dir = 0,
      ignorenavmesh = 1
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [777] = {
    id = 777,
    Content = "summon",
    Params = {
      id = 294113,
      pos = {
        -169.32,
        30.0,
        54.7
      },
      group_id = 50,
      dir = 0,
      ignorenavmesh = 1
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [778] = {
    id = 778,
    Content = "random_jump",
    Params = {
      jump = {
        {step = 15, rate = 17},
        {step = 32, rate = 17},
        {step = 49, rate = 17},
        {step = 66, rate = 17},
        {step = 83, rate = 16},
        {step = 100, rate = 16}
      }
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [779] = {
    id = 779,
    Content = "summon",
    Params = {
      id = 294112,
      pos = {
        -165.41,
        28,
        35.19
      },
      group_id = 55,
      waitaction = "state1001",
      ignorenavmesh = 1,
      dir = 0
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [780] = {
    id = 780,
    Content = "multigm",
    Params = {
      type = "playaction",
      style = 3,
      npcid = 294112,
      id = 500,
      sync = 1
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [781] = {
    id = 781,
    Content = "wait",
    Params = {time = 2},
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [782] = {
    id = 782,
    Content = "multigm",
    Params = {
      type = "playaction",
      style = 3,
      npcid = 294112,
      id = 502,
      sync = 1
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [783] = {
    id = 783,
    Content = "wait",
    Params = {time = 2},
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [784] = {
    id = 784,
    Content = "multigm",
    Params = {
      type = "playaction",
      style = 3,
      npcid = 294112,
      id = 504,
      sync = 1
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [785] = {
    id = 785,
    Content = "wait",
    Params = {time = 2},
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [786] = {
    id = 786,
    Content = "multigm",
    Params = {
      type = "playaction",
      style = 3,
      npcid = 294112,
      id = 506,
      sync = 1
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [787] = {
    id = 787,
    Content = "wait",
    Params = {time = 2},
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [788] = {
    id = 788,
    Content = "clearnpc",
    Params = {
      group_ids = {55}
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [789] = {
    id = 789,
    Content = "summon",
    Params = {
      id = 294115,
      pos = {
        -165.41,
        28,
        35.19
      },
      group_id = 60,
      waitaction = "state4002",
      ignorenavmesh = 1,
      dir = 0
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [790] = {
    id = 790,
    Content = "summon",
    Params = {
      id = 294110,
      pos = {
        -157.3,
        30.24,
        35.29
      },
      dir = 270,
      search = 0,
      territory = 0,
      pursue = 0,
      pursuetime = 0,
      group_id = 100,
      life = 1
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [791] = {
    id = 791,
    Content = "summon",
    Params = {
      id = 294111,
      pos = {
        -161.13,
        30.24,
        28.16
      },
      dir = 330,
      search = 0,
      territory = 0,
      pursue = 0,
      pursuetime = 0,
      group_id = 200,
      life = 0
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [792] = {
    id = 792,
    Content = "summon",
    Params = {
      id = 294111,
      pos = {
        -169.44,
        30.24,
        28.07
      },
      dir = 30,
      search = 0,
      territory = 0,
      pursue = 0,
      pursuetime = 0,
      group_id = 300,
      life = 0
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [793] = {
    id = 793,
    Content = "summon",
    Params = {
      id = 294111,
      pos = {
        -173.46,
        30.24,
        35.12
      },
      dir = 90,
      search = 0,
      territory = 0,
      pursue = 0,
      pursuetime = 0,
      group_id = 400,
      life = 0
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [794] = {
    id = 794,
    Content = "summon",
    Params = {
      id = 294111,
      pos = {
        -169.51,
        30.24,
        42.29
      },
      dir = 150,
      search = 0,
      territory = 0,
      pursue = 0,
      pursuetime = 0,
      group_id = 500,
      life = 0
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [795] = {
    id = 795,
    Content = "summon",
    Params = {
      id = 294111,
      pos = {
        -161.38,
        30.24,
        42.26
      },
      dir = 210,
      search = 0,
      territory = 0,
      pursue = 0,
      pursuetime = 0,
      group_id = 600,
      life = 0
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [796] = {
    id = 796,
    Content = "summon",
    Params = {
      id = 294112,
      pos = {
        -165.41,
        28,
        35.19
      },
      group_id = 55,
      waitaction = "state1001",
      ignorenavmesh = 1,
      dir = 60
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [797] = {
    id = 797,
    Content = "multigm",
    Params = {
      type = "playaction",
      style = 3,
      npcid = 294112,
      id = 500,
      sync = 1
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [798] = {
    id = 798,
    Content = "wait",
    Params = {time = 2},
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [799] = {
    id = 799,
    Content = "multigm",
    Params = {
      type = "playaction",
      style = 3,
      npcid = 294112,
      id = 502,
      sync = 1
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [800] = {
    id = 800,
    Content = "wait",
    Params = {time = 2},
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [801] = {
    id = 801,
    Content = "multigm",
    Params = {
      type = "playaction",
      style = 3,
      npcid = 294112,
      id = 504,
      sync = 1
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [802] = {
    id = 802,
    Content = "wait",
    Params = {time = 2},
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [803] = {
    id = 803,
    Content = "multigm",
    Params = {
      type = "playaction",
      style = 3,
      npcid = 294112,
      id = 506,
      sync = 1
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [804] = {
    id = 804,
    Content = "wait",
    Params = {time = 2},
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [805] = {
    id = 805,
    Content = "clearnpc",
    Params = {
      group_ids = {55}
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [806] = {
    id = 806,
    Content = "summon",
    Params = {
      id = 294115,
      pos = {
        -165.41,
        28,
        35.19
      },
      group_id = 60,
      waitaction = "state4002",
      ignorenavmesh = 1,
      dir = 60
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [807] = {
    id = 807,
    Content = "summon",
    Params = {
      id = 294111,
      pos = {
        -157.3,
        30.24,
        35.29
      },
      dir = 270,
      search = 0,
      territory = 0,
      pursue = 0,
      pursuetime = 0,
      group_id = 100,
      life = 1
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [808] = {
    id = 808,
    Content = "summon",
    Params = {
      id = 294110,
      pos = {
        -161.13,
        30.24,
        28.16
      },
      dir = 330,
      search = 0,
      territory = 0,
      pursue = 0,
      pursuetime = 0,
      group_id = 200,
      life = 0
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [809] = {
    id = 809,
    Content = "summon",
    Params = {
      id = 294111,
      pos = {
        -169.44,
        30.24,
        28.07
      },
      dir = 30,
      search = 0,
      territory = 0,
      pursue = 0,
      pursuetime = 0,
      group_id = 300,
      life = 0
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [810] = {
    id = 810,
    Content = "summon",
    Params = {
      id = 294111,
      pos = {
        -173.46,
        30.24,
        35.12
      },
      dir = 90,
      search = 0,
      territory = 0,
      pursue = 0,
      pursuetime = 0,
      group_id = 400,
      life = 0
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [811] = {
    id = 811,
    Content = "summon",
    Params = {
      id = 294111,
      pos = {
        -169.51,
        30.24,
        42.29
      },
      dir = 150,
      search = 0,
      territory = 0,
      pursue = 0,
      pursuetime = 0,
      group_id = 500,
      life = 0
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [812] = {
    id = 812,
    Content = "summon",
    Params = {
      id = 294111,
      pos = {
        -161.38,
        30.24,
        42.26
      },
      dir = 210,
      search = 0,
      territory = 0,
      pursue = 0,
      pursuetime = 0,
      group_id = 600,
      life = 0
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [813] = {
    id = 813,
    Content = "summon",
    Params = {
      id = 294112,
      pos = {
        -165.41,
        28,
        35.19
      },
      group_id = 55,
      waitaction = "state1001",
      ignorenavmesh = 1,
      dir = 120
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [814] = {
    id = 814,
    Content = "multigm",
    Params = {
      type = "playaction",
      style = 3,
      npcid = 294112,
      id = 500,
      sync = 1
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [815] = {
    id = 815,
    Content = "wait",
    Params = {time = 2},
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [816] = {
    id = 816,
    Content = "multigm",
    Params = {
      type = "playaction",
      style = 3,
      npcid = 294112,
      id = 502,
      sync = 1
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [817] = {
    id = 817,
    Content = "wait",
    Params = {time = 2},
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [818] = {
    id = 818,
    Content = "multigm",
    Params = {
      type = "playaction",
      style = 3,
      npcid = 294112,
      id = 504,
      sync = 1
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [819] = {
    id = 819,
    Content = "wait",
    Params = {time = 2},
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [820] = {
    id = 820,
    Content = "multigm",
    Params = {
      type = "playaction",
      style = 3,
      npcid = 294112,
      id = 506,
      sync = 1
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [821] = {
    id = 821,
    Content = "wait",
    Params = {time = 2},
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [822] = {
    id = 822,
    Content = "clearnpc",
    Params = {
      group_ids = {55}
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [823] = {
    id = 823,
    Content = "summon",
    Params = {
      id = 294115,
      pos = {
        -165.41,
        28,
        35.19
      },
      group_id = 60,
      waitaction = "state4002",
      ignorenavmesh = 1,
      dir = 120
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [824] = {
    id = 824,
    Content = "summon",
    Params = {
      id = 294111,
      pos = {
        -157.3,
        30.24,
        35.29
      },
      dir = 270,
      search = 0,
      territory = 0,
      pursue = 0,
      pursuetime = 0,
      group_id = 100,
      life = 1
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [825] = {
    id = 825,
    Content = "summon",
    Params = {
      id = 294111,
      pos = {
        -161.13,
        30.24,
        28.16
      },
      dir = 330,
      search = 0,
      territory = 0,
      pursue = 0,
      pursuetime = 0,
      group_id = 200,
      life = 0
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [826] = {
    id = 826,
    Content = "summon",
    Params = {
      id = 294110,
      pos = {
        -169.44,
        30.24,
        28.07
      },
      dir = 30,
      search = 0,
      territory = 0,
      pursue = 0,
      pursuetime = 0,
      group_id = 300,
      life = 0
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [827] = {
    id = 827,
    Content = "summon",
    Params = {
      id = 294111,
      pos = {
        -173.46,
        30.24,
        35.12
      },
      dir = 90,
      search = 0,
      territory = 0,
      pursue = 0,
      pursuetime = 0,
      group_id = 400,
      life = 0
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [828] = {
    id = 828,
    Content = "summon",
    Params = {
      id = 294111,
      pos = {
        -169.51,
        30.24,
        42.29
      },
      dir = 150,
      search = 0,
      territory = 0,
      pursue = 0,
      pursuetime = 0,
      group_id = 500,
      life = 0
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [829] = {
    id = 829,
    Content = "summon",
    Params = {
      id = 294111,
      pos = {
        -161.38,
        30.24,
        42.26
      },
      dir = 210,
      search = 0,
      territory = 0,
      pursue = 0,
      pursuetime = 0,
      group_id = 600,
      life = 0
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [830] = {
    id = 830,
    Content = "summon",
    Params = {
      id = 294112,
      pos = {
        -165.41,
        28,
        35.19
      },
      group_id = 55,
      waitaction = "state1001",
      ignorenavmesh = 1,
      dir = 180
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [831] = {
    id = 831,
    Content = "multigm",
    Params = {
      type = "playaction",
      style = 3,
      npcid = 294112,
      id = 500,
      sync = 1
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [832] = {
    id = 832,
    Content = "wait",
    Params = {time = 2},
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [833] = {
    id = 833,
    Content = "multigm",
    Params = {
      type = "playaction",
      style = 3,
      npcid = 294112,
      id = 502,
      sync = 1
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [834] = {
    id = 834,
    Content = "wait",
    Params = {time = 2},
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [835] = {
    id = 835,
    Content = "multigm",
    Params = {
      type = "playaction",
      style = 3,
      npcid = 294112,
      id = 504,
      sync = 1
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [836] = {
    id = 836,
    Content = "wait",
    Params = {time = 2},
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [837] = {
    id = 837,
    Content = "multigm",
    Params = {
      type = "playaction",
      style = 3,
      npcid = 294112,
      id = 506,
      sync = 1
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [838] = {
    id = 838,
    Content = "wait",
    Params = {time = 2},
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [839] = {
    id = 839,
    Content = "clearnpc",
    Params = {
      group_ids = {55}
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [840] = {
    id = 840,
    Content = "summon",
    Params = {
      id = 294115,
      pos = {
        -165.41,
        28,
        35.19
      },
      group_id = 60,
      waitaction = "state4002",
      ignorenavmesh = 1,
      dir = 180
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [841] = {
    id = 841,
    Content = "summon",
    Params = {
      id = 294111,
      pos = {
        -157.3,
        30.24,
        35.29
      },
      dir = 270,
      search = 0,
      territory = 0,
      pursue = 0,
      pursuetime = 0,
      group_id = 100,
      life = 1
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [842] = {
    id = 842,
    Content = "summon",
    Params = {
      id = 294111,
      pos = {
        -161.13,
        30.24,
        28.16
      },
      dir = 330,
      search = 0,
      territory = 0,
      pursue = 0,
      pursuetime = 0,
      group_id = 200,
      life = 0
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [843] = {
    id = 843,
    Content = "summon",
    Params = {
      id = 294111,
      pos = {
        -169.44,
        30.24,
        28.07
      },
      dir = 30,
      search = 0,
      territory = 0,
      pursue = 0,
      pursuetime = 0,
      group_id = 300,
      life = 0
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [844] = {
    id = 844,
    Content = "summon",
    Params = {
      id = 294110,
      pos = {
        -173.46,
        30.24,
        35.12
      },
      dir = 90,
      search = 0,
      territory = 0,
      pursue = 0,
      pursuetime = 0,
      group_id = 400,
      life = 0
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [845] = {
    id = 845,
    Content = "summon",
    Params = {
      id = 294111,
      pos = {
        -169.51,
        30.24,
        42.29
      },
      dir = 150,
      search = 0,
      territory = 0,
      pursue = 0,
      pursuetime = 0,
      group_id = 500,
      life = 0
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [846] = {
    id = 846,
    Content = "summon",
    Params = {
      id = 294111,
      pos = {
        -161.38,
        30.24,
        42.26
      },
      dir = 210,
      search = 0,
      territory = 0,
      pursue = 0,
      pursuetime = 0,
      group_id = 600,
      life = 0
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [847] = {
    id = 847,
    Content = "summon",
    Params = {
      id = 294112,
      pos = {
        -165.41,
        28,
        35.19
      },
      group_id = 55,
      waitaction = "state1001",
      ignorenavmesh = 1,
      dir = 240
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [848] = {
    id = 848,
    Content = "multigm",
    Params = {
      type = "playaction",
      style = 3,
      npcid = 294112,
      id = 500,
      sync = 1
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [849] = {
    id = 849,
    Content = "wait",
    Params = {time = 2},
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [850] = {
    id = 850,
    Content = "multigm",
    Params = {
      type = "playaction",
      style = 3,
      npcid = 294112,
      id = 502,
      sync = 1
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [851] = {
    id = 851,
    Content = "wait",
    Params = {time = 2},
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [852] = {
    id = 852,
    Content = "multigm",
    Params = {
      type = "playaction",
      style = 3,
      npcid = 294112,
      id = 504,
      sync = 1
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [853] = {
    id = 853,
    Content = "wait",
    Params = {time = 2},
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [854] = {
    id = 854,
    Content = "multigm",
    Params = {
      type = "playaction",
      style = 3,
      npcid = 294112,
      id = 506,
      sync = 1
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [855] = {
    id = 855,
    Content = "wait",
    Params = {time = 2},
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [856] = {
    id = 856,
    Content = "clearnpc",
    Params = {
      group_ids = {55}
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [857] = {
    id = 857,
    Content = "summon",
    Params = {
      id = 294115,
      pos = {
        -165.41,
        28,
        35.19
      },
      group_id = 60,
      waitaction = "state4002",
      ignorenavmesh = 1,
      dir = 240
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [858] = {
    id = 858,
    Content = "summon",
    Params = {
      id = 294111,
      pos = {
        -157.3,
        30.24,
        35.29
      },
      dir = 270,
      search = 0,
      territory = 0,
      pursue = 0,
      pursuetime = 0,
      group_id = 100,
      life = 1
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [859] = {
    id = 859,
    Content = "summon",
    Params = {
      id = 294111,
      pos = {
        -161.13,
        30.24,
        28.16
      },
      dir = 330,
      search = 0,
      territory = 0,
      pursue = 0,
      pursuetime = 0,
      group_id = 200,
      life = 0
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [860] = {
    id = 860,
    Content = "summon",
    Params = {
      id = 294111,
      pos = {
        -169.44,
        30.24,
        28.07
      },
      dir = 30,
      search = 0,
      territory = 0,
      pursue = 0,
      pursuetime = 0,
      group_id = 300,
      life = 0
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [861] = {
    id = 861,
    Content = "summon",
    Params = {
      id = 294111,
      pos = {
        -173.46,
        30.24,
        35.12
      },
      dir = 90,
      search = 0,
      territory = 0,
      pursue = 0,
      pursuetime = 0,
      group_id = 400,
      life = 0
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [862] = {
    id = 862,
    Content = "summon",
    Params = {
      id = 294110,
      pos = {
        -169.51,
        30.24,
        42.29
      },
      dir = 150,
      search = 0,
      territory = 0,
      pursue = 0,
      pursuetime = 0,
      group_id = 500,
      life = 0
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [863] = {
    id = 863,
    Content = "summon",
    Params = {
      id = 294111,
      pos = {
        -161.38,
        30.24,
        42.26
      },
      dir = 210,
      search = 0,
      territory = 0,
      pursue = 0,
      pursuetime = 0,
      group_id = 600,
      life = 0
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [864] = {
    id = 864,
    Content = "summon",
    Params = {
      id = 294112,
      pos = {
        -165.41,
        28,
        35.19
      },
      group_id = 55,
      waitaction = "state1001",
      ignorenavmesh = 1,
      dir = 300
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [865] = {
    id = 865,
    Content = "multigm",
    Params = {
      type = "playaction",
      style = 3,
      npcid = 294112,
      id = 500,
      sync = 1
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [866] = {
    id = 866,
    Content = "wait",
    Params = {time = 2},
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [867] = {
    id = 867,
    Content = "multigm",
    Params = {
      type = "playaction",
      style = 3,
      npcid = 294112,
      id = 502,
      sync = 1
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [868] = {
    id = 868,
    Content = "wait",
    Params = {time = 2},
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [869] = {
    id = 869,
    Content = "multigm",
    Params = {
      type = "playaction",
      style = 3,
      npcid = 294112,
      id = 504,
      sync = 1
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [870] = {
    id = 870,
    Content = "wait",
    Params = {time = 2},
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [871] = {
    id = 871,
    Content = "multigm",
    Params = {
      type = "playaction",
      style = 3,
      npcid = 294112,
      id = 506,
      sync = 1
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [872] = {
    id = 872,
    Content = "wait",
    Params = {time = 2},
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [873] = {
    id = 873,
    Content = "clearnpc",
    Params = {
      group_ids = {55}
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [874] = {
    id = 874,
    Content = "summon",
    Params = {
      id = 294115,
      pos = {
        -165.41,
        28,
        35.19
      },
      group_id = 60,
      waitaction = "state4002",
      ignorenavmesh = 1,
      dir = 300
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [875] = {
    id = 875,
    Content = "summon",
    Params = {
      id = 294111,
      pos = {
        -157.3,
        30.24,
        35.29
      },
      dir = 270,
      search = 0,
      territory = 0,
      pursue = 0,
      pursuetime = 0,
      group_id = 100,
      life = 1
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [876] = {
    id = 876,
    Content = "summon",
    Params = {
      id = 294111,
      pos = {
        -161.13,
        30.24,
        28.16
      },
      dir = 330,
      search = 0,
      territory = 0,
      pursue = 0,
      pursuetime = 0,
      group_id = 200,
      life = 0
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [877] = {
    id = 877,
    Content = "summon",
    Params = {
      id = 294111,
      pos = {
        -169.44,
        30.24,
        28.07
      },
      dir = 30,
      search = 0,
      territory = 0,
      pursue = 0,
      pursuetime = 0,
      group_id = 300,
      life = 0
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [878] = {
    id = 878,
    Content = "summon",
    Params = {
      id = 294111,
      pos = {
        -173.46,
        30.24,
        35.12
      },
      dir = 90,
      search = 0,
      territory = 0,
      pursue = 0,
      pursuetime = 0,
      group_id = 400,
      life = 0
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [879] = {
    id = 879,
    Content = "summon",
    Params = {
      id = 294111,
      pos = {
        -169.51,
        30.24,
        42.29
      },
      dir = 150,
      search = 0,
      territory = 0,
      pursue = 0,
      pursuetime = 0,
      group_id = 500,
      life = 0
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [880] = {
    id = 880,
    Content = "summon",
    Params = {
      id = 294110,
      pos = {
        -161.38,
        30.24,
        42.26
      },
      dir = 210,
      search = 0,
      territory = 0,
      pursue = 0,
      pursuetime = 0,
      group_id = 600,
      life = 0
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [881] = {
    id = 881,
    Content = "multigm",
    Params = {
      type = "shakescreen",
      amplitude = 50,
      msec = 1000,
      shaketype = 1,
      sync = 1
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [882] = {
    id = 882,
    Content = "multigm",
    Params = {
      type = "effect",
      effect = "Skill/SuperLandBite",
      pos = {
        -157.3,
        30.24,
        35.29
      },
      times = 1
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [883] = {
    id = 883,
    Content = "multigm",
    Params = {
      type = "effect",
      effect = "Skill/SuperLandBite",
      pos = {
        -161.13,
        30.24,
        28.16
      },
      times = 1
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [884] = {
    id = 884,
    Content = "multigm",
    Params = {
      type = "effect",
      effect = "Skill/SuperLandBite",
      pos = {
        -169.44,
        30.24,
        28.07
      },
      times = 1
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [885] = {
    id = 885,
    Content = "multigm",
    Params = {
      type = "effect",
      effect = "Skill/SuperLandBite",
      pos = {
        -173.46,
        30.24,
        35.12
      },
      times = 1
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [886] = {
    id = 886,
    Content = "multigm",
    Params = {
      type = "effect",
      effect = "Skill/SuperLandBite",
      pos = {
        -169.51,
        30.24,
        42.29
      },
      times = 1
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [887] = {
    id = 887,
    Content = "multigm",
    Params = {
      type = "effect",
      effect = "Skill/SuperLandBite",
      pos = {
        -161.38,
        30.24,
        42.26
      },
      times = 1
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [888] = {
    id = 888,
    Content = "killmonster",
    Params = {
      npcid = {294111},
      num = 1,
      record_char = 100
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [889] = {
    id = 889,
    Content = "multigm",
    Params = {
      type = "addbuff",
      id = 10050,
      spec_char = 100
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [890] = {
    id = 890,
    Content = "random_jump",
    Params = {
      jump = {
        {step = 4, rate = 25},
        {step = 5, rate = 25},
        {step = 6, rate = 25},
        {step = 7, rate = 25}
      }
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [891] = {
    id = 891,
    Content = "multigm",
    Params = {
      type = "gopos",
      pos = {
        -161.31,
        30.0,
        15.63
      },
      spec_char = 100
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [892] = {
    id = 892,
    Content = "multigm",
    Params = {
      type = "gopos",
      pos = {
        -146.42,
        30.0,
        41.46
      },
      spec_char = 100
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [893] = {
    id = 893,
    Content = "multigm",
    Params = {
      type = "gopos",
      pos = {
        -184.44,
        30.0,
        29.09
      },
      spec_char = 100
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [894] = {
    id = 894,
    Content = "multigm",
    Params = {
      type = "gopos",
      pos = {
        -169.32,
        30.0,
        54.7
      },
      spec_char = 100
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [895] = {
    id = 895,
    Content = "killmonster",
    Params = {
      npcid = {294110},
      num = 1
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [896] = {
    id = 896,
    Content = "multigm",
    Params = {
      type = "shakescreen",
      amplitude = 10,
      msec = 4000,
      shaketype = 1,
      sync = 1
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [897] = {
    id = 897,
    Content = "multigm",
    Params = {
      type = "playaction",
      style = 3,
      npcid = 294115,
      id = 508,
      sync = 1
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [898] = {
    id = 898,
    Content = "wait",
    Params = {time = 2},
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [899] = {
    id = 899,
    Content = "multigm",
    Params = {
      type = "playaction",
      style = 3,
      npcid = 294115,
      id = 510,
      sync = 1
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [900] = {
    id = 900,
    Content = "wait",
    Params = {time = 2},
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [901] = {
    id = 901,
    Content = "multigm",
    Params = {
      type = "shakescreen",
      amplitude = 50,
      msec = 1000,
      shaketype = 1,
      sync = 1
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [902] = {
    id = 902,
    Content = "multigm",
    Params = {
      type = "effect",
      effect = "Skill/SuperLandBite",
      pos = {
        -165.41,
        29.05,
        35.19
      },
      times = 1,
      scale = 5
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [903] = {
    id = 903,
    Content = "clearnpc",
    Params = {
      group_ids = {
        10,
        20,
        30,
        40,
        50,
        60,
        100,
        200,
        300,
        400,
        500,
        600
      }
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [904] = {
    id = 904,
    Content = "clearnpc",
    Params = {
      npcid = {294110, 294111}
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [905] = {
    id = 905,
    Content = "wait",
    Params = {time = 1},
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [906] = {
    id = 906,
    Content = "multigm",
    Params = {
      type = "effect",
      effect = "Skill/SuperLandBite",
      pos = {
        -165.41,
        29.05,
        35.19
      },
      times = 1,
      scale = 5
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [907] = {
    id = 907,
    Content = "summon",
    Params = {
      id = 320160,
      pos = {
        -165.41,
        29.05,
        35.19
      },
      dir = 78.93244,
      dead_disp_time = 900,
      territory = 10,
      search = 10
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [908] = {
    id = 908,
    Content = "killmonster",
    Params = {
      npcid = {320160},
      num = 1
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [909] = {
    id = 909,
    Content = "wait_refresh",
    Params = {time = 1800, work_time_type = 1},
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [910] = {
    id = 910,
    Content = "summon",
    Params = {
      id = 1203142,
      pos = {
        6.38,
        14.36,
        -99.37
      },
      group_id = 5,
      dead_disp_time = 3,
      dir = 130
    },
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [911] = {
    id = 911,
    Content = "move",
    Params = {
      pos = {
        6.38,
        14.36,
        -99.37
      },
      distance = 10,
      record_char = 1
    },
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [912] = {
    id = 912,
    Content = "multigm",
    Params = {
      type = "shakescreen",
      amplitude = 10,
      msec = 2500,
      shaketype = 1,
      sync = 1,
      spec_char = 1,
      fail_on_leave = 1
    },
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [913] = {
    id = 913,
    Content = "wait",
    Params = {time = 2},
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [914] = {
    id = 914,
    Content = "multigm",
    Params = {
      type = "shakescreen",
      amplitude = 10,
      msec = 5000,
      shaketype = 1,
      sync = 1,
      spec_char = 1,
      fail_on_leave = 1
    },
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [915] = {
    id = 915,
    Content = "wait",
    Params = {time = 1},
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [916] = {
    id = 916,
    Content = "multigm",
    Params = {
      type = "effect",
      effect = "Skill/SuperLandBite",
      pos = {
        6.38,
        14.36,
        -99.37
      },
      times = 1
    },
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [917] = {
    id = 917,
    Content = "summon",
    Params = {
      id = 1203120,
      pos = {
        6.38,
        14.36,
        -99.37
      },
      dir = 78.93244,
      group_id = 1
    },
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [918] = {
    id = 918,
    Content = "killmonster",
    Params = {
      npcid = {1203121},
      num = 100,
      process_msg_zone = 101
    },
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [919] = {
    id = 919,
    Content = "del_map_zone",
    Params = {map_zone = 101, type = 2},
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [920] = {
    id = 920,
    Content = "clearnpc",
    Params = {
      npcid = {1203120}
    },
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [921] = {
    id = 921,
    Content = "multigm",
    Params = {
      type = "effect",
      effect = "Skill/EleDefence_Death",
      pos = {
        6.38,
        14.36,
        -99.37
      },
      times = 1
    },
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [922] = {
    id = 922,
    Content = "wait",
    Params = {time = 1},
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [923] = {
    id = 923,
    Content = "wait",
    Params = {time = 2},
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [924] = {
    id = 924,
    Content = "summon",
    Params = {
      id = 320080,
      pos = {
        6.38,
        14.36,
        -99.37
      },
      dir = 78.93244,
      dead_disp_time = 900,
      territory = 10,
      search = 10
    },
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [925] = {
    id = 925,
    Content = "killmonster",
    Params = {
      npcid = {320080},
      num = 1
    },
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [926] = {
    id = 926,
    Content = "wait_refresh",
    Params = {time = 1800, work_time_type = 1},
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [927] = {
    id = 927,
    Content = "wait",
    Params = {time = 1},
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [928] = {
    id = 928,
    Content = "clearnpc",
    Params = {
      group_ids = {1, 5}
    },
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [929] = {
    id = 929,
    Content = "set_obj_state",
    Params = {
      obj_states = {
        {
          obj = 5,
          state = "mfx_scmvp3_fire01_blue_state1001"
        },
        {
          obj = 6,
          state = "mfx_scmvp3_yanfire_state1001"
        },
        {
          obj = 7,
          state = "mfx_scmvp3_yanfire_state1001"
        },
        {
          obj = 8,
          state = "mfx_scmvp3_shifire_state1001"
        },
        {
          obj = 9,
          state = "mfx_scmvp3_yanfire_state1001"
        },
        {
          obj = 10,
          state = "mfx_scmvp3_yanfire_state1001"
        },
        {
          obj = 11,
          state = "mfx_scmvp3_shifire_state1001"
        }
      }
    },
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [930] = {
    id = 930,
    Content = "in_order_kill",
    Params = {
      order_kill_npc = {
        1203147,
        1203148,
        1203149,
        1203150
      },
      show_type = 3,
      pos_data = {
        {
          pos = {
            -20.83,
            18.03,
            -33.2
          },
          obj_id = 1,
          dir = 176,
          state = {
            [0] = "mfx_scmvp3_fire02_1_state1001",
            [1] = "mfx_scmvp3_fire02_1_state2001"
          }
        },
        {
          pos = {
            -18.62,
            18.03,
            -50.22
          },
          obj_id = 2,
          dir = 351,
          state = {
            [0] = "mfx_scmvp3_fire02_2_state1001",
            [1] = "mfx_scmvp3_fire02_2_state2001"
          }
        },
        {
          pos = {
            -11.85,
            18.03,
            -45.09
          },
          obj_id = 3,
          dir = 291,
          state = {
            [0] = "mfx_scmvp3_fire02_3_state1001",
            [1] = "mfx_scmvp3_fire02_3_state2001"
          }
        },
        {
          pos = {
            -27.73,
            18.03,
            -38.43
          },
          obj_id = 4,
          dir = 110,
          state = {
            [0] = "mfx_scmvp3_fire02_4_state1001",
            [1] = "mfx_scmvp3_fire02_4_state2001"
          }
        }
      },
      fail_buffs = {
        159797,
        159798,
        159815
      },
      no_rand = 1
    },
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [931] = {
    id = 931,
    Content = "set_obj_state",
    Params = {
      obj_states = {
        {
          obj = 5,
          state = "mfx_scmvp3_fire01_blue_state2001"
        },
        {
          obj = 6,
          state = "mfx_scmvp3_yanfire_state2001"
        },
        {
          obj = 7,
          state = "mfx_scmvp3_yanfire_state2001"
        },
        {
          obj = 8,
          state = "mfx_scmvp3_shifire_state2001"
        },
        {
          obj = 9,
          state = "mfx_scmvp3_yanfire_state2001"
        },
        {
          obj = 10,
          state = "mfx_scmvp3_yanfire_state2001"
        },
        {
          obj = 11,
          state = "mfx_scmvp3_shifire_state2001"
        }
      }
    },
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [932] = {
    id = 932,
    Content = "summon",
    Params = {
      id = 1203142,
      pos = {
        -19.77,
        18.03,
        -41.76
      },
      group_id = 10,
      dead_disp_time = 3,
      dir = 45.49591
    },
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [933] = {
    id = 933,
    Content = "wait",
    Params = {time = 2},
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [934] = {
    id = 934,
    Content = "summon",
    Params = {
      id = 320070,
      pos = {
        -19.77,
        18.03,
        -41.76
      },
      dir = 45.49591,
      dead_disp_time = 900,
      territory = 10,
      search = 10
    },
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [935] = {
    id = 935,
    Content = "wait",
    Params = {time = 1},
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [936] = {
    id = 936,
    Content = "clearnpc",
    Params = {
      group_ids = {10}
    },
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [937] = {
    id = 937,
    Content = "killmonster",
    Params = {
      npcid = {320070},
      num = 1
    },
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [938] = {
    id = 938,
    Content = "wait_refresh",
    Params = {time = 1800, work_time_type = 1},
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [939] = {
    id = 939,
    Content = "summon",
    Params = {
      id = 1203142,
      pos = {
        -51.57,
        14.57,
        -90.74
      },
      group_id = 5,
      dead_disp_time = 3,
      dir = 316.3857
    },
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [940] = {
    id = 940,
    Content = "summon",
    Params = {
      id = 1203131,
      pos = {
        -51.02,
        14.78,
        -91.25
      },
      dir = 314.5,
      walkid = 4700,
      group_id = 1
    },
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [941] = {
    id = 941,
    Content = "summon",
    Params = {
      id = 1203131,
      pos = {
        -51.02,
        14.78,
        -91.25
      },
      dir = 314.5,
      walkid = 4701,
      group_id = 1
    },
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [942] = {
    id = 942,
    Content = "killall",
    Params = {
      group_ids = {1}
    },
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [943] = {
    id = 943,
    Content = "clearnpc",
    Params = {
      npcid = {1203131}
    },
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [944] = {
    id = 944,
    Content = "multigm",
    Params = {
      type = "effect",
      effect = "Skill/EleDefence_Death",
      pos = {
        -51.57,
        14.57,
        -90.74
      },
      times = 1
    },
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [945] = {
    id = 945,
    Content = "wait",
    Params = {time = 2},
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [946] = {
    id = 946,
    Content = "summon",
    Params = {
      id = 320060,
      pos = {
        -51.57,
        14.57,
        -90.74
      },
      dir = 316.3857,
      dead_disp_time = 900,
      territory = 10,
      search = 10
    },
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [947] = {
    id = 947,
    Content = "wait",
    Params = {time = 1},
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [948] = {
    id = 948,
    Content = "clearnpc",
    Params = {
      group_ids = {5}
    },
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [949] = {
    id = 949,
    Content = "killmonster",
    Params = {
      npcid = {320060},
      num = 1
    },
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [950] = {
    id = 950,
    Content = "wait_refresh",
    Params = {time = 1800, work_time_type = 1},
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [951] = {
    id = 951,
    Content = "summon",
    Params = {
      id = 1203142,
      pos = {
        -103.11,
        29.75,
        -5.55
      },
      group_id = 5,
      dead_disp_time = 3,
      dir = 119.7583
    },
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [952] = {
    id = 952,
    Content = "multigm",
    Params = {
      type = "effect",
      effect = "Skill/Task_NecromancerSummons",
      pos = {
        -103.11,
        29.75,
        -5.55
      },
      times = 1
    },
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [953] = {
    id = 953,
    Content = "wait",
    Params = {time = 3},
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [954] = {
    id = 954,
    Content = "summon",
    Params = {
      id = 1203130,
      pos = {
        -103.11,
        29.75,
        -5.55
      },
      group_id = 1,
      dead_disp_time = 5,
      dir = 119.7583,
      purse = 8
    },
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [955] = {
    id = 955,
    Content = "killall",
    Params = {
      group_ids = {1}
    },
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [956] = {
    id = 956,
    Content = "clearnpc",
    Params = {
      npcid = {1203130}
    },
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [957] = {
    id = 957,
    Content = "multigm",
    Params = {
      type = "effect",
      effect = "Skill/EleDefence_Death",
      pos = {
        -103.11,
        29.75,
        -5.55
      },
      times = 1
    },
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [958] = {
    id = 958,
    Content = "wait",
    Params = {time = 2},
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [959] = {
    id = 959,
    Content = "summon",
    Params = {
      id = 320090,
      pos = {
        -103.11,
        29.75,
        -5.55
      },
      dir = 119.7583,
      dead_disp_time = 900,
      territory = 10,
      search = 10
    },
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [960] = {
    id = 960,
    Content = "wait",
    Params = {time = 1},
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [961] = {
    id = 961,
    Content = "clearnpc",
    Params = {
      group_ids = {5}
    },
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [962] = {
    id = 962,
    Content = "killmonster",
    Params = {
      npcid = {320090},
      num = 1
    },
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [963] = {
    id = 963,
    Content = "wait_refresh",
    Params = {time = 1800, work_time_type = 1},
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [964] = {
    id = 964,
    Content = "summon",
    Params = {
      id = 1203161,
      pos = {
        -7.34,
        30.27,
        43.9
      },
      group_id = 5,
      territory = 0,
      search = 0
    },
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [965] = {
    id = 965,
    Content = "set_obj_state",
    Params = {
      obj_states = {
        {
          obj = 20,
          state = "mfx_scmvp3_yanfire_state1001"
        },
        {
          obj = 21,
          state = "mfx_scmvp3_yanfire_state1001"
        },
        {
          obj = 22,
          state = "mfx_scmvp3_shifire_state1001"
        },
        {
          obj = 17,
          state = "mfx_scmvp3_yanfire_state1001"
        },
        {
          obj = 18,
          state = "mfx_scmvp3_yanfire_state1001"
        },
        {
          obj = 19,
          state = "mfx_scmvp3_shifire_state1001"
        },
        {
          obj = 16,
          state = "mfx_scmvp3_fire01_blue_state1001"
        }
      }
    },
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [966] = {
    id = 966,
    Content = "in_order_kill",
    Params = {
      order_kill_npc = {
        1203154,
        1203155,
        1203156,
        1203157
      },
      show_type = 3,
      pos_data = {
        {
          pos = {
            -16.08,
            30.27,
            48.17
          },
          obj_id = 15,
          dir = 120,
          state = {
            [0] = "mfx_scmvp3_fire02_4_state1001",
            [1] = "mfx_scmvp3_fire02_4_state2001"
          }
        },
        {
          pos = {
            1.34,
            30.27,
            39.72
          },
          obj_id = 12,
          dir = 295,
          state = {
            [0] = "mfx_scmvp3_fire02_1_state1001",
            [1] = "mfx_scmvp3_fire02_1_state2001"
          }
        },
        {
          pos = {
            0.52,
            30.27,
            49.37
          },
          obj_id = 14,
          dir = 235,
          state = {
            [0] = "mfx_scmvp3_fire02_3_state1001",
            [1] = "mfx_scmvp3_fire02_3_state2001"
          }
        },
        {
          pos = {
            -15.24,
            30.27,
            38.49
          },
          obj_id = 13,
          dir = 55,
          state = {
            [0] = "mfx_scmvp3_fire02_2_state1001",
            [1] = "mfx_scmvp3_fire02_2_state2001"
          }
        }
      },
      fail_buffs = {
        159797,
        159798,
        159815
      },
      no_rand = 1
    },
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [967] = {
    id = 967,
    Content = "set_obj_state",
    Params = {
      obj_states = {
        {
          obj = 20,
          state = "mfx_scmvp3_yanfire_state2001"
        },
        {
          obj = 21,
          state = "mfx_scmvp3_yanfire_state2001"
        },
        {
          obj = 22,
          state = "mfx_scmvp3_shifire_state2001"
        },
        {
          obj = 17,
          state = "mfx_scmvp3_yanfire_state2001"
        },
        {
          obj = 18,
          state = "mfx_scmvp3_yanfire_state2001"
        },
        {
          obj = 19,
          state = "mfx_scmvp3_shifire_state2001"
        },
        {
          obj = 16,
          state = "mfx_scmvp3_fire01_blue_state2001"
        }
      }
    },
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [968] = {
    id = 968,
    Content = "summon",
    Params = {
      id = 1203142,
      pos = {
        -7.34,
        30.27,
        43.9
      },
      group_id = 10,
      territory = 0,
      search = 0
    },
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [969] = {
    id = 969,
    Content = "wait",
    Params = {time = 2},
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [970] = {
    id = 970,
    Content = "summon",
    Params = {
      id = 320100,
      pos = {
        -7.34,
        30.27,
        43.9
      },
      group_id = 6,
      dead_disp_time = 900,
      territory = 10,
      search = 10
    },
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [971] = {
    id = 971,
    Content = "wait",
    Params = {time = 1},
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [972] = {
    id = 972,
    Content = "clearnpc",
    Params = {
      group_ids = {10}
    },
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [973] = {
    id = 973,
    Content = "killall",
    Params = {
      group_ids = {6}
    },
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [974] = {
    id = 974,
    Content = "wait_refresh",
    Params = {time = 1800, work_time_type = 1},
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [975] = {
    id = 975,
    Content = "multigm",
    Params = {
      type = "effect",
      effect = "Skill/Task_NecromancerSummons",
      pos = {
        38.82,
        11.51,
        -100.13
      },
      times = 1
    },
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [976] = {
    id = 976,
    Content = "wait",
    Params = {time = 3},
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [977] = {
    id = 977,
    Content = "summon",
    Params = {
      id = 1203008,
      pos = {
        -95.23,
        24.19,
        52.54
      },
      dir = 114.9256,
      walkid = 4702,
      group_id = 1,
      dead_disp_time = 20,
      territory = 3,
      search = 0,
      purse = 10
    },
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [978] = {
    id = 978,
    Content = "summon",
    Params = {
      id = 818330,
      pos = {
        -98.36,
        24.19,
        55.17
      },
      group_id = 3,
      territory = 0,
      search = 0,
      dir = 123.8283,
      no_clear = 1
    },
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [979] = {
    id = 979,
    Content = "killall",
    Params = {
      group_ids = {1}
    },
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [980] = {
    id = 980,
    Content = "wait_refresh",
    Params = {time = 300, work_time_type = 1},
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [981] = {
    id = 981,
    Content = "multigm",
    Params = {
      type = "effect",
      effect = "Skill/Task_NecromancerSummons",
      pos = {
        30.3,
        14.24,
        -34.87
      },
      times = 1
    },
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [982] = {
    id = 982,
    Content = "wait",
    Params = {time = 3},
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [983] = {
    id = 983,
    Content = "summon",
    Params = {
      id = 1203009,
      pos = {
        47.24,
        14.64,
        -37.85
      },
      dir = 257.7221,
      walkid = 4703,
      group_id = 1,
      dead_disp_time = 20,
      territory = 3,
      search = 0,
      purse = 10
    },
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [984] = {
    id = 984,
    Content = "summon",
    Params = {
      id = 818330,
      pos = {
        52.4,
        15.37,
        -32.56
      },
      group_id = 3,
      territory = 0,
      search = 0,
      dir = 254.2726,
      no_clear = 1
    },
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [985] = {
    id = 985,
    Content = "killall",
    Params = {
      group_ids = {1}
    },
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [986] = {
    id = 986,
    Content = "wait_refresh",
    Params = {time = 300, work_time_type = 1},
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [987] = {
    id = 987,
    Content = "multigm",
    Params = {
      type = "effect",
      effect = "Skill/Task_NecromancerSummons",
      pos = {
        -39.33,
        16.8,
        5.84
      },
      times = 1
    },
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [988] = {
    id = 988,
    Content = "wait",
    Params = {time = 3},
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [989] = {
    id = 989,
    Content = "summon",
    Params = {
      id = 1203010,
      pos = {
        -39.33,
        16.8,
        5.84
      },
      dir = 116.2966,
      walkid = 4704,
      group_id = 1,
      dead_disp_time = 20,
      territory = 3,
      search = 0,
      purse = 10
    },
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [990] = {
    id = 990,
    Content = "summon",
    Params = {
      id = 1202007,
      pos = {
        -37.9,
        16.91,
        10.24
      },
      dir = 195.199,
      walkid = 4723,
      group_id = 2,
      territory = 0,
      search = 0,
      purse = 10,
      ai = 25636
    },
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [991] = {
    id = 991,
    Content = "summon",
    Params = {
      id = 1202007,
      pos = {
        -41.14,
        16.91,
        1.59
      },
      dir = 16.30038,
      walkid = 4724,
      group_id = 2,
      territory = 0,
      search = 0,
      purse = 10,
      ai = 25636
    },
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [992] = {
    id = 992,
    Content = "summon",
    Params = {
      id = 1202002,
      pos = {
        -41.25,
        16.91,
        4.9
      },
      dir = 67.5233,
      walkid = 4725,
      group_id = 2,
      territory = 0,
      search = 0,
      purse = 10,
      ai = 25636
    },
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [993] = {
    id = 993,
    Content = "summon",
    Params = {
      id = 1202002,
      pos = {
        -37.68,
        16.91,
        6.87
      },
      dir = 248.4258,
      walkid = 4726,
      group_id = 2,
      territory = 0,
      search = 0,
      purse = 10,
      ai = 25636
    },
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [994] = {
    id = 994,
    Content = "summon",
    Params = {
      id = 1202002,
      pos = {
        -38.58,
        16.91,
        3.91
      },
      dir = 338.7038,
      walkid = 4727,
      group_id = 2,
      territory = 0,
      search = 0,
      purse = 10,
      ai = 25636
    },
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [995] = {
    id = 995,
    Content = "summon",
    Params = {
      id = 1202002,
      pos = {
        -40.13,
        16.91,
        7.71
      },
      dir = 154.3431,
      walkid = 4728,
      group_id = 2,
      territory = 0,
      search = 0,
      purse = 10,
      ai = 25636
    },
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [996] = {
    id = 996,
    Content = "summon",
    Params = {
      id = 818329,
      pos = {
        -45.46,
        16.82,
        -2.95
      },
      group_id = 3,
      territory = 0,
      search = 0,
      dir = 134.6713,
      no_clear = 1
    },
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [997] = {
    id = 997,
    Content = "killall",
    Params = {
      group_ids = {1}
    },
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [998] = {
    id = 998,
    Content = "wait_refresh",
    Params = {time = 300, work_time_type = 1},
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [999] = {
    id = 999,
    Content = "multigm",
    Params = {
      type = "effect",
      effect = "Skill/Task_NecromancerSummons",
      pos = {
        -31.57,
        22.95,
        69.64
      },
      times = 1
    },
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [1000] = {
    id = 1000,
    Content = "wait",
    Params = {time = 3},
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [1001] = {
    id = 1001,
    Content = "summon",
    Params = {
      id = 1203011,
      pos = {
        -31.57,
        22.95,
        69.64
      },
      dir = 165.4106,
      walkid = 4705,
      group_id = 1,
      dead_disp_time = 20,
      territory = 3,
      search = 0,
      purse = 10
    },
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [1002] = {
    id = 1002,
    Content = "summon",
    Params = {
      id = 818329,
      pos = {
        -42.33,
        24.53,
        66.6
      },
      group_id = 3,
      territory = 0,
      search = 0,
      dir = 85.743,
      no_clear = 1
    },
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [1003] = {
    id = 1003,
    Content = "killall",
    Params = {
      group_ids = {1}
    },
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [1004] = {
    id = 1004,
    Content = "wait_refresh",
    Params = {time = 300, work_time_type = 1},
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [1005] = {
    id = 1005,
    Content = "multigm",
    Params = {
      type = "effect",
      effect = "Skill/Task_NecromancerSummons",
      pos = {
        -78.14,
        14.07,
        -53.77
      },
      times = 1
    },
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [1006] = {
    id = 1006,
    Content = "wait",
    Params = {time = 3},
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [1007] = {
    id = 1007,
    Content = "summon",
    Params = {
      id = 1203012,
      pos = {
        -78.86,
        13.77,
        -56.16
      },
      dir = 132.2903,
      walkid = 4706,
      group_id = 1,
      dead_disp_time = 20,
      territory = 3,
      search = 0,
      purse = 10
    },
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [1008] = {
    id = 1008,
    Content = "summon",
    Params = {
      id = 818328,
      pos = {
        -88.81,
        13.48,
        -52.44
      },
      group_id = 3,
      territory = 0,
      search = 0,
      dir = 111.4198,
      no_clear = 1
    },
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [1009] = {
    id = 1009,
    Content = "killall",
    Params = {
      group_ids = {1}
    },
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [1010] = {
    id = 1010,
    Content = "wait_refresh",
    Params = {time = 300, work_time_type = 1},
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [1011] = {
    id = 1011,
    Content = "multigm",
    Params = {
      type = "effect",
      effect = "Skill/Task_NecromancerSummons",
      pos = {
        31.76,
        33.61,
        62.58
      },
      times = 1
    },
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [1012] = {
    id = 1012,
    Content = "wait",
    Params = {time = 3},
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [1013] = {
    id = 1013,
    Content = "summon",
    Params = {
      id = 1203013,
      pos = {
        31.76,
        33.61,
        62.58
      },
      dir = 206.3317,
      walkid = 4707,
      group_id = 1,
      dead_disp_time = 20,
      territory = 3,
      search = 0,
      purse = 10
    },
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [1014] = {
    id = 1014,
    Content = "summon",
    Params = {
      id = 818328,
      pos = {
        42.28,
        33.49,
        67.7
      },
      group_id = 3,
      territory = 0,
      search = 0,
      dir = 251.9539,
      no_clear = 1
    },
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [1015] = {
    id = 1015,
    Content = "killall",
    Params = {
      group_ids = {1}
    },
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [1016] = {
    id = 1016,
    Content = "wait_refresh",
    Params = {time = 300, work_time_type = 1},
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [1017] = {
    id = 1017,
    Content = "random_jump",
    Params = {
      jump = {
        {step = 2, rate = 25},
        {step = 3, rate = 25},
        {step = 4, rate = 25},
        {step = 5, rate = 25}
      }
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [1018] = {
    id = 1018,
    Content = "summon",
    Params = {
      id = 294212,
      pos = {
        72.33,
        1.18,
        -58.48
      },
      dir = 255.8451,
      walkid = 4801,
      search = 0,
      territory = 0,
      pursue = 0,
      pursuetime = 0,
      group_id = 1
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [1019] = {
    id = 1019,
    Content = "summon",
    Params = {
      id = 294215,
      pos = {
        72.33,
        1.18,
        -58.48
      },
      dir = 255.8451,
      walkid = 4801,
      search = 0,
      territory = 0,
      pursue = 0,
      pursuetime = 0,
      group_id = 1
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [1020] = {
    id = 1020,
    Content = "summon",
    Params = {
      id = 294217,
      pos = {
        72.33,
        1.18,
        -58.48
      },
      dir = 255.8451,
      walkid = 4801,
      search = 0,
      territory = 0,
      pursue = 0,
      pursuetime = 0,
      group_id = 1
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [1021] = {
    id = 1021,
    Content = "summon",
    Params = {
      id = 294218,
      pos = {
        72.33,
        1.18,
        -58.48
      },
      dir = 255.8451,
      walkid = 4801,
      search = 0,
      territory = 0,
      pursue = 0,
      pursuetime = 0,
      group_id = 1
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [1022] = {
    id = 1022,
    Content = "killall",
    Params = {
      group_ids = {1}
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [1023] = {
    id = 1023,
    Content = "wait",
    Params = {time = 20},
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [1024] = {
    id = 1024,
    Content = "clearnpc",
    Params = {
      group_ids = {1}
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [1025] = {
    id = 1025,
    Content = "wait_refresh",
    Params = {time = 580},
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [1026] = {
    id = 1026,
    Content = "random_jump",
    Params = {
      jump = {
        {step = 2, rate = 25},
        {step = 3, rate = 25},
        {step = 4, rate = 25},
        {step = 5, rate = 25}
      }
    },
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [1027] = {
    id = 1027,
    Content = "summon",
    Params = {
      id = 294212,
      pos = {
        -7.9,
        14.7,
        6.52
      },
      dir = 167.599,
      walkid = 4802,
      search = 0,
      territory = 0,
      pursue = 0,
      pursuetime = 0,
      group_id = 1
    },
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [1028] = {
    id = 1028,
    Content = "summon",
    Params = {
      id = 294215,
      pos = {
        -7.9,
        14.7,
        6.52
      },
      dir = 167.599,
      walkid = 4802,
      search = 0,
      territory = 0,
      pursue = 0,
      pursuetime = 0,
      group_id = 1
    },
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [1029] = {
    id = 1029,
    Content = "summon",
    Params = {
      id = 294217,
      pos = {
        -7.9,
        14.7,
        6.52
      },
      dir = 167.599,
      walkid = 4802,
      search = 0,
      territory = 0,
      pursue = 0,
      pursuetime = 0,
      group_id = 1
    },
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [1030] = {
    id = 1030,
    Content = "summon",
    Params = {
      id = 294218,
      pos = {
        -7.9,
        14.7,
        6.52
      },
      dir = 167.599,
      walkid = 4802,
      search = 0,
      territory = 0,
      pursue = 0,
      pursuetime = 0,
      group_id = 1
    },
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [1031] = {
    id = 1031,
    Content = "killall",
    Params = {
      group_ids = {1}
    },
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [1032] = {
    id = 1032,
    Content = "wait",
    Params = {time = 20},
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [1033] = {
    id = 1033,
    Content = "clearnpc",
    Params = {
      group_ids = {1}
    },
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [1034] = {
    id = 1034,
    Content = "wait_refresh",
    Params = {time = 580},
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [1035] = {
    id = 1035,
    Content = "random_jump",
    Params = {
      jump = {
        {step = 2, rate = 25},
        {step = 3, rate = 25},
        {step = 4, rate = 25},
        {step = 5, rate = 25}
      }
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1036] = {
    id = 1036,
    Content = "summon",
    Params = {
      id = 294212,
      pos = {
        -38.11,
        14.67,
        -70.54
      },
      dir = 329.2252,
      walkid = 4803,
      search = 0,
      territory = 0,
      pursue = 0,
      pursuetime = 0,
      group_id = 1
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1037] = {
    id = 1037,
    Content = "summon",
    Params = {
      id = 294215,
      pos = {
        -38.11,
        14.67,
        -70.54
      },
      dir = 329.2252,
      walkid = 4803,
      search = 0,
      territory = 0,
      pursue = 0,
      pursuetime = 0,
      group_id = 1
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1038] = {
    id = 1038,
    Content = "summon",
    Params = {
      id = 294217,
      pos = {
        -38.11,
        14.67,
        -70.54
      },
      dir = 329.2252,
      walkid = 4803,
      search = 0,
      territory = 0,
      pursue = 0,
      pursuetime = 0,
      group_id = 1
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1039] = {
    id = 1039,
    Content = "summon",
    Params = {
      id = 294218,
      pos = {
        -38.11,
        14.67,
        -70.54
      },
      dir = 329.2252,
      walkid = 4803,
      search = 0,
      territory = 0,
      pursue = 0,
      pursuetime = 0,
      group_id = 1
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1040] = {
    id = 1040,
    Content = "killall",
    Params = {
      group_ids = {1}
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1041] = {
    id = 1041,
    Content = "wait",
    Params = {time = 20},
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1042] = {
    id = 1042,
    Content = "clearnpc",
    Params = {
      group_ids = {1}
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1043] = {
    id = 1043,
    Content = "wait_refresh",
    Params = {time = 580},
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1044] = {
    id = 1044,
    Content = "summon",
    Params = {
      id = 294222,
      pos = {
        65.49,
        1.75,
        -71.16
      },
      dir = 106.2561,
      territory = 0,
      search = 0
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [1045] = {
    id = 1045,
    Content = "visit",
    Params = {
      npc = 294222,
      pos = {
        65.49,
        1.75,
        -71.16
      },
      dialog = {396187, 396188},
      distance = 3,
      ShowSymbol = 2
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [1046] = {
    id = 1046,
    Content = "multigm",
    Params = {
      type = "addbuff",
      id = 158676,
      npcid = 294222
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [1047] = {
    id = 1047,
    Content = "multigm",
    Params = {
      type = "delbuff",
      id = 158675,
      npcid = 294222
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [1048] = {
    id = 1048,
    Content = "wait_super_ai",
    Params = _EmptyTable,
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [1049] = {
    id = 1049,
    Content = "summon",
    Params = {
      id = 294266,
      pos = {
        -113.89,
        18.57,
        -7.78
      },
      dir = 259.2914,
      territory = 0,
      search = 0
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [1050] = {
    id = 1050,
    Content = "wait_super_ai",
    Params = _EmptyTable,
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [1051] = {
    id = 1051,
    Content = "wait",
    Params = {time = 120},
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [1052] = {
    id = 1052,
    Content = "wait_refresh",
    Params = {time = 180},
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [1053] = {
    id = 1053,
    Content = "summon",
    Params = {
      id = 294263,
      pos = {
        94.45,
        1.24,
        -44.83
      },
      dir = 201.6179,
      territory = 0,
      search = 0,
      group_id = 1
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [1054] = {
    id = 1054,
    Content = "summon",
    Params = {
      id = 294220,
      pos = {
        93.5,
        1.24,
        -44.45
      },
      dir = 201.6179,
      territory = 0,
      search = 0
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [1055] = {
    id = 1055,
    Content = "visit",
    Params = {
      npc = 294263,
      pos = {
        94.45,
        1.24,
        -44.83
      },
      dialog = {396158, 396159},
      distance = 3,
      ShowSymbol = 2
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [1056] = {
    id = 1056,
    Content = "multigm",
    Params = {
      type = "addbuff",
      id = 158676,
      npcid = 294220
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [1057] = {
    id = 1057,
    Content = "multigm",
    Params = {
      type = "delbuff",
      id = 158675,
      npcid = 294220
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [1058] = {
    id = 1058,
    Content = "wait_super_ai",
    Params = _EmptyTable,
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [1059] = {
    id = 1059,
    Content = "clearnpc",
    Params = {
      group_ids = {1}
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [1060] = {
    id = 1060,
    Content = "wait_super_ai",
    Params = _EmptyTable,
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [1061] = {
    id = 1061,
    Content = "summon",
    Params = {
      id = 294264,
      pos = {
        -72.32,
        20.06,
        45.07
      },
      dir = 173.1111,
      territory = 0,
      search = 0
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [1062] = {
    id = 1062,
    Content = "visit",
    Params = {npc = 294220, ShowSymbol = 2},
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [1063] = {
    id = 1063,
    Content = "wait_super_ai",
    Params = _EmptyTable,
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [1064] = {
    id = 1064,
    Content = "wait",
    Params = {time = 120},
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [1065] = {
    id = 1065,
    Content = "wait_refresh",
    Params = {time = 180},
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [1066] = {
    id = 1066,
    Content = "summon",
    Params = {
      id = 294223,
      pos = {
        1.6,
        14.7,
        18.04
      },
      dir = 190.7708,
      territory = 0,
      search = 0
    },
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [1067] = {
    id = 1067,
    Content = "visit",
    Params = {
      npc = 294223,
      pos = {
        1.6,
        14.7,
        18.04
      },
      dialog = {396200, 396201},
      distance = 3,
      ShowSymbol = 2
    },
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [1068] = {
    id = 1068,
    Content = "multigm",
    Params = {
      type = "addbuff",
      id = 158676,
      npcid = 294223
    },
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [1069] = {
    id = 1069,
    Content = "multigm",
    Params = {
      type = "delbuff",
      id = 158675,
      npcid = 294223
    },
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [1070] = {
    id = 1070,
    Content = "wait_super_ai",
    Params = _EmptyTable,
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [1071] = {
    id = 1071,
    Content = "summon",
    Params = {
      id = 294267,
      pos = {
        17.07,
        16.98,
        -13.85
      },
      dir = 145.7297,
      territory = 0,
      search = 0
    },
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [1072] = {
    id = 1072,
    Content = "wait_super_ai",
    Params = _EmptyTable,
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [1073] = {
    id = 1073,
    Content = "wait",
    Params = {time = 120},
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [1074] = {
    id = 1074,
    Content = "wait_refresh",
    Params = {time = 180},
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [1075] = {
    id = 1075,
    Content = "summon",
    Params = {
      id = 294224,
      pos = {
        -102.92,
        11.94,
        -95.74
      },
      dir = 54.62042,
      territory = 0,
      search = 0
    },
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [1076] = {
    id = 1076,
    Content = "visit",
    Params = {
      npc = 294224,
      pos = {
        -102.92,
        11.94,
        -95.74
      },
      dialog = {396214, 396215},
      distance = 3,
      ShowSymbol = 2
    },
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [1077] = {
    id = 1077,
    Content = "multigm",
    Params = {
      type = "addbuff",
      id = 158676,
      npcid = 294224
    },
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [1078] = {
    id = 1078,
    Content = "multigm",
    Params = {
      type = "delbuff",
      id = 158675,
      npcid = 294224
    },
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [1079] = {
    id = 1079,
    Content = "wait_super_ai",
    Params = _EmptyTable,
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [1080] = {
    id = 1080,
    Content = "summon",
    Params = {
      id = 294268,
      pos = {
        -18.04,
        14.82,
        -12.24
      },
      dir = 39.8591,
      territory = 0,
      search = 0
    },
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [1081] = {
    id = 1081,
    Content = "summon",
    Params = {
      id = 294268,
      pos = {
        -16.11,
        14.82,
        -9.43
      },
      dir = 223.153,
      territory = 0,
      search = 0
    },
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [1082] = {
    id = 1082,
    Content = "summon",
    Params = {
      id = 294268,
      pos = {
        -15.67,
        14.82,
        -11.75
      },
      dir = 311.7534,
      territory = 0,
      search = 0
    },
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [1083] = {
    id = 1083,
    Content = "wait_super_ai",
    Params = _EmptyTable,
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [1084] = {
    id = 1084,
    Content = "summon",
    Params = {
      id = 294269,
      pos = {
        -17.06,
        14.7,
        -10.8
      },
      dir = 311.7534,
      territory = 0,
      search = 0
    },
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [1085] = {
    id = 1085,
    Content = "wait",
    Params = {time = 120},
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [1086] = {
    id = 1086,
    Content = "wait_refresh",
    Params = {time = 180},
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [1087] = {
    id = 1087,
    Content = "summon",
    Params = {
      id = 294221,
      pos = {
        -78.05,
        14.22,
        -62.1
      },
      dir = 147.4471,
      territory = 0,
      search = 0
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1088] = {
    id = 1088,
    Content = "visit",
    Params = {
      npc = 294221,
      pos = {
        -78.05,
        14.22,
        -62.1
      },
      dialog = {
        396173,
        396174,
        396175
      },
      distance = 3,
      ShowSymbol = 2
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1089] = {
    id = 1089,
    Content = "multigm",
    Params = {
      type = "addbuff",
      id = 158676,
      npcid = 294221
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1090] = {
    id = 1090,
    Content = "multigm",
    Params = {
      type = "delbuff",
      id = 158675,
      npcid = 294221
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1091] = {
    id = 1091,
    Content = "wait_super_ai",
    Params = _EmptyTable,
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1092] = {
    id = 1092,
    Content = "summon",
    Params = {
      id = 294265,
      pos = {
        -1.71,
        16.47,
        -28.93
      },
      dir = 147.4471,
      territory = 0,
      search = 0
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1093] = {
    id = 1093,
    Content = "wait_super_ai",
    Params = _EmptyTable,
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1094] = {
    id = 1094,
    Content = "wait",
    Params = {time = 120},
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1095] = {
    id = 1095,
    Content = "wait_refresh",
    Params = {time = 180},
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1096] = {
    id = 1096,
    Content = "summon",
    Params = {
      id = 294219,
      pos = {
        -77.22,
        16.31,
        -27.34
      },
      dir = 91.43607,
      territory = 0,
      search = 0
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1097] = {
    id = 1097,
    Content = "visit",
    Params = {
      npc = 294219,
      pos = {
        -77.22,
        16.31,
        -27.34
      },
      dialog = {
        396146,
        396147,
        396148
      },
      distance = 3,
      ShowSymbol = 2
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1098] = {
    id = 1098,
    Content = "multigm",
    Params = {
      type = "addbuff",
      id = 158676,
      npcid = 294219
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1099] = {
    id = 1099,
    Content = "multigm",
    Params = {
      type = "delbuff",
      id = 158675,
      npcid = 294219
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1100] = {
    id = 1100,
    Content = "wait_super_ai",
    Params = _EmptyTable,
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1101] = {
    id = 1101,
    Content = "summon",
    Params = {
      id = 294262,
      pos = {
        24.45,
        24.8,
        4.96
      },
      dir = 359.9538,
      territory = 0,
      search = 0
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1102] = {
    id = 1102,
    Content = "wait_super_ai",
    Params = _EmptyTable,
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1103] = {
    id = 1103,
    Content = "wait",
    Params = {time = 120},
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1104] = {
    id = 1104,
    Content = "wait_refresh",
    Params = {time = 180},
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1105] = {
    id = 1105,
    Content = "summon",
    Params = {
      id = 294251,
      pos = {
        85.27,
        2.84,
        -70.73
      },
      dir = 110.0629,
      territory = 0,
      search = 0
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [1106] = {
    id = 1106,
    Content = "summon",
    Params = {
      id = 294252,
      pos = {
        84.92,
        2.84,
        -71.54
      },
      dir = 115.5153,
      territory = 0,
      search = 0
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [1107] = {
    id = 1107,
    Content = "summon",
    Params = {
      id = 294253,
      pos = {
        85.86,
        2.76,
        -71.37
      },
      dir = 97.98624,
      territory = 0,
      search = 0
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [1108] = {
    id = 1108,
    Content = "summon",
    Params = {
      id = 294226,
      pos = {
        88.69,
        3.07,
        -72.84
      },
      group_id = 1,
      dir = 0,
      territory = 0,
      search = 0
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [1109] = {
    id = 1109,
    Content = "killall",
    Params = {
      group_ids = {1}
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [1110] = {
    id = 1110,
    Content = "clearnpc",
    Params = {
      npcid = {294226}
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [1111] = {
    id = 1111,
    Content = "wait",
    Params = {time = 120},
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [1112] = {
    id = 1112,
    Content = "wait_refresh",
    Params = {time = 180},
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [1113] = {
    id = 1113,
    Content = "summon",
    Params = {
      id = 294254,
      pos = {
        -127.1,
        16.85,
        -36.3
      },
      dir = 110.0002,
      territory = 0,
      search = 0
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [1114] = {
    id = 1114,
    Content = "summon",
    Params = {
      id = 294229,
      pos = {
        -126.85,
        16.83,
        -37.0
      },
      group_id = 1,
      dir = 299.8509,
      territory = 0,
      search = 0
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [1115] = {
    id = 1115,
    Content = "killall",
    Params = {
      group_ids = {1}
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [1116] = {
    id = 1116,
    Content = "clearnpc",
    Params = {
      npcid = {294229}
    },
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [1117] = {
    id = 1117,
    Content = "wait",
    Params = {time = 120},
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [1118] = {
    id = 1118,
    Content = "wait_refresh",
    Params = {time = 180},
    MapID = 141,
    StartCondition = _EmptyTable
  },
  [1119] = {
    id = 1119,
    Content = "summon",
    Params = {
      id = 294228,
      pos = {
        70.29,
        13.28,
        -73.58
      },
      dir = 24.75166,
      territory = 0,
      search = 0
    },
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [1120] = {
    id = 1120,
    Content = "summon",
    Params = {
      id = 294227,
      pos = {
        70.96,
        13.26,
        -72.56
      },
      group_id = 1,
      dir = 215.6849,
      territory = 0,
      search = 0
    },
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [1121] = {
    id = 1121,
    Content = "killall",
    Params = {
      group_ids = {1}
    },
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [1122] = {
    id = 1122,
    Content = "clearnpc",
    Params = {
      npcid = {294227}
    },
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [1123] = {
    id = 1123,
    Content = "wait",
    Params = {time = 120},
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [1124] = {
    id = 1124,
    Content = "wait_refresh",
    Params = {time = 180},
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [1125] = {
    id = 1125,
    Content = "summon",
    Params = {
      id = 294255,
      pos = {
        9.53,
        13.53,
        -41.26
      },
      dir = 20.48186,
      territory = 0,
      search = 0
    },
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [1126] = {
    id = 1126,
    Content = "summon",
    Params = {
      id = 294230,
      pos = {
        9.59,
        13.7,
        -39.59
      },
      group_id = 1,
      dir = 185.0026,
      territory = 0,
      search = 0
    },
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [1127] = {
    id = 1127,
    Content = "killall",
    Params = {
      group_ids = {1}
    },
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [1128] = {
    id = 1128,
    Content = "clearnpc",
    Params = {
      npcid = {294230}
    },
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [1129] = {
    id = 1129,
    Content = "wait",
    Params = {time = 120},
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [1130] = {
    id = 1130,
    Content = "wait_refresh",
    Params = {time = 180},
    MapID = 142,
    StartCondition = _EmptyTable
  },
  [1131] = {
    id = 1131,
    Content = "summon",
    Params = {
      id = 294257,
      pos = {
        19.13,
        16.57,
        -37.15
      },
      dir = 0,
      territory = 0,
      search = 0,
      ignorenavmesh = 1
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1132] = {
    id = 1132,
    Content = "summon",
    Params = {
      id = 294258,
      pos = {
        17.66,
        16.34,
        -41.01
      },
      dir = 21.08116,
      territory = 0,
      search = 0
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1133] = {
    id = 1133,
    Content = "summon",
    Params = {
      id = 294259,
      pos = {
        16.87,
        16.83,
        -41.96
      },
      dir = 18.17349,
      territory = 0,
      search = 0
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1134] = {
    id = 1134,
    Content = "summon",
    Params = {
      id = 294260,
      pos = {
        17.78,
        16.83,
        -41.89
      },
      dir = 18.17349,
      territory = 0,
      search = 0
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1135] = {
    id = 1135,
    Content = "summon",
    Params = {
      id = 294261,
      pos = {
        16.69,
        16.83,
        -41.38
      },
      dir = 18.17349,
      territory = 0,
      search = 0
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1136] = {
    id = 1136,
    Content = "summon",
    Params = {
      id = 294233,
      pos = {
        17.36,
        16.46,
        -37.98
      },
      group_id = 1,
      dir = 66.28593,
      territory = 0,
      search = 0
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1137] = {
    id = 1137,
    Content = "killall",
    Params = {
      group_ids = {1}
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1138] = {
    id = 1138,
    Content = "clearnpc",
    Params = {
      npcid = {294233}
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1139] = {
    id = 1139,
    Content = "wait",
    Params = {time = 120},
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1140] = {
    id = 1140,
    Content = "wait_refresh",
    Params = {time = 180},
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1141] = {
    id = 1141,
    Content = "summon",
    Params = {
      id = 294256,
      pos = {
        21.06,
        24.91,
        30.73
      },
      dir = 137.7963,
      territory = 0,
      search = 0
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1142] = {
    id = 1142,
    Content = "summon",
    Params = {
      id = 294232,
      pos = {
        20.61,
        24.79,
        29.52
      },
      group_id = 1,
      dir = 0,
      territory = 0,
      search = 0
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1143] = {
    id = 1143,
    Content = "killall",
    Params = {
      group_ids = {1}
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1144] = {
    id = 1144,
    Content = "clearnpc",
    Params = {
      npcid = {294232}
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1145] = {
    id = 1145,
    Content = "wait",
    Params = {time = 120},
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1146] = {
    id = 1146,
    Content = "wait_refresh",
    Params = {time = 180},
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1147] = {
    id = 1147,
    Content = "multigm",
    Params = {
      type = "effect",
      effect = "Skill/Task_NecromancerSummons",
      pos = {
        -4.62,
        20.76,
        6.51
      },
      times = 1
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1148] = {
    id = 1148,
    Content = "wait",
    Params = {time = 3},
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1149] = {
    id = 1149,
    Content = "summon",
    Params = {
      id = 1203014,
      pos = {
        -4.62,
        20.76,
        6.51
      },
      group_id = 1,
      dead_disp_time = 20,
      territory = 0,
      search = 0,
      dir = 345,
      purse = 10,
      walkid = 4763
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1150] = {
    id = 1150,
    Content = "summon",
    Params = {
      id = 818330,
      pos = {
        -0.79,
        21.05,
        -5.29
      },
      group_id = 2,
      territory = 0,
      search = 0,
      dir = 354,
      no_clear = 1
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1151] = {
    id = 1151,
    Content = "killall",
    Params = {
      group_ids = {1}
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1152] = {
    id = 1152,
    Content = "wait_refresh",
    Params = {time = 300, work_time_type = 1},
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1153] = {
    id = 1153,
    Content = "multigm",
    Params = {
      type = "effect",
      effect = "Skill/Task_NecromancerSummons",
      pos = {
        50.56,
        24.66,
        41.51
      },
      times = 1
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1154] = {
    id = 1154,
    Content = "wait",
    Params = {time = 3},
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1155] = {
    id = 1155,
    Content = "summon",
    Params = {
      id = 1203015,
      pos = {
        50.56,
        24.66,
        41.51
      },
      group_id = 1,
      dead_disp_time = 20,
      territory = 0,
      search = 0,
      dir = 254,
      purse = 10,
      walkid = 4764
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1156] = {
    id = 1156,
    Content = "summon",
    Params = {
      id = 818330,
      pos = {
        50.72,
        24.84,
        46.32
      },
      group_id = 2,
      territory = 0,
      search = 0,
      dir = 210,
      no_clear = 1
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1157] = {
    id = 1157,
    Content = "summon",
    Params = {
      id = 1202001,
      pos = {
        30.52,
        24.72,
        37.48
      },
      group_id = 2,
      dead_disp_time = 3,
      territory = 0,
      search = 0,
      dir = 118,
      purse = 10,
      ai = 25636
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1158] = {
    id = 1158,
    Content = "summon",
    Params = {
      id = 1202001,
      pos = {
        35.81,
        24.72,
        30.27
      },
      group_id = 2,
      dead_disp_time = 3,
      territory = 0,
      search = 0,
      dir = 333,
      purse = 10,
      ai = 25636
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1159] = {
    id = 1159,
    Content = "summon",
    Params = {
      id = 1202001,
      pos = {
        39.52,
        24.66,
        37.47
      },
      group_id = 2,
      dead_disp_time = 3,
      territory = 0,
      search = 0,
      dir = 359,
      purse = 10,
      ai = 25636,
      walkid = 4768
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1160] = {
    id = 1160,
    Content = "summon",
    Params = {
      id = 1202001,
      pos = {
        38.36,
        24.66,
        35.26
      },
      group_id = 2,
      dead_disp_time = 3,
      territory = 0,
      search = 0,
      dir = 255,
      purse = 10,
      ai = 25636,
      walkid = 4769
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1161] = {
    id = 1161,
    Content = "summon",
    Params = {
      id = 1202001,
      pos = {
        48.05,
        24.66,
        39
      },
      group_id = 2,
      dead_disp_time = 3,
      territory = 0,
      search = 0,
      dir = 25.26,
      purse = 10,
      ai = 25636,
      walkid = 4770
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1162] = {
    id = 1162,
    Content = "killall",
    Params = {
      group_ids = {1}
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1163] = {
    id = 1163,
    Content = "wait_refresh",
    Params = {time = 300, work_time_type = 1},
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1164] = {
    id = 1164,
    Content = "multigm",
    Params = {
      type = "effect",
      effect = "Skill/Task_NecromancerSummons",
      pos = {
        -40.34,
        18.08,
        -9.99
      },
      times = 1
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1165] = {
    id = 1165,
    Content = "wait",
    Params = {time = 3},
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1166] = {
    id = 1166,
    Content = "summon",
    Params = {
      id = 1203016,
      pos = {
        -40.34,
        18.08,
        -9.99
      },
      group_id = 1,
      dead_disp_time = 20,
      territory = 0,
      search = 0,
      dir = 161.44,
      purse = 10,
      walkid = 4765
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1167] = {
    id = 1167,
    Content = "summon",
    Params = {
      id = 818329,
      pos = {
        -39.08,
        18.15,
        -16.02
      },
      group_id = 2,
      territory = 0,
      search = 0,
      dir = 350,
      no_clear = 1
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1168] = {
    id = 1168,
    Content = "killall",
    Params = {
      group_ids = {1}
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1169] = {
    id = 1169,
    Content = "wait_refresh",
    Params = {time = 300, work_time_type = 1},
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1170] = {
    id = 1170,
    Content = "multigm",
    Params = {
      type = "effect",
      effect = "Skill/Task_NecromancerSummons",
      pos = {
        -73.77,
        20.33,
        55
      },
      times = 1
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1171] = {
    id = 1171,
    Content = "wait",
    Params = {time = 3},
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1172] = {
    id = 1172,
    Content = "summon",
    Params = {
      id = 1203017,
      pos = {
        -73.77,
        20.33,
        55
      },
      group_id = 1,
      dead_disp_time = 20,
      territory = 0,
      search = 3,
      dir = 125,
      purse = 10
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1173] = {
    id = 1173,
    Content = "summon",
    Params = {
      id = 818329,
      pos = {
        -77.25,
        20.4,
        57.31
      },
      group_id = 2,
      territory = 0,
      search = 0,
      dir = 124.78,
      no_clear = 1
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1174] = {
    id = 1174,
    Content = "summon",
    Params = {
      id = 1202003,
      pos = {
        -73.1,
        20.21,
        45.54
      },
      group_id = 2,
      dead_disp_time = 3,
      territory = 0,
      search = 0,
      dir = 344.78,
      purse = 10,
      ai = 25688
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1175] = {
    id = 1175,
    Content = "summon",
    Params = {
      id = 1202003,
      pos = {
        -69.7,
        20.21,
        47.28
      },
      group_id = 2,
      dead_disp_time = 3,
      territory = 0,
      search = 0,
      dir = 330.3,
      purse = 10,
      ai = 25688
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1176] = {
    id = 1176,
    Content = "summon",
    Params = {
      id = 1202003,
      pos = {
        -66.56,
        20.21,
        50.74
      },
      group_id = 2,
      dead_disp_time = 3,
      territory = 0,
      search = 0,
      dir = 303,
      purse = 10,
      ai = 25688
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1177] = {
    id = 1177,
    Content = "summon",
    Params = {
      id = 1202003,
      pos = {
        -65,
        20.21,
        55.04
      },
      group_id = 2,
      dead_disp_time = 3,
      territory = 0,
      search = 0,
      dir = 279.56,
      purse = 10,
      ai = 25688
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1178] = {
    id = 1178,
    Content = "summon",
    Params = {
      id = 1202003,
      pos = {
        -64.83,
        20.21,
        59.14
      },
      group_id = 2,
      dead_disp_time = 3,
      territory = 0,
      search = 0,
      dir = 263.36,
      purse = 10,
      ai = 25688
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1179] = {
    id = 1179,
    Content = "summon",
    Params = {
      id = 1202003,
      pos = {
        -66.25,
        20.21,
        63.54
      },
      group_id = 2,
      dead_disp_time = 3,
      territory = 0,
      search = 0,
      dir = 239.15,
      purse = 10,
      ai = 25688
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1180] = {
    id = 1180,
    Content = "summon",
    Params = {
      id = 1202003,
      pos = {
        -77.89,
        20.21,
        44.93
      },
      group_id = 2,
      dead_disp_time = 3,
      territory = 0,
      search = 0,
      dir = 11,
      purse = 10,
      ai = 25688
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1181] = {
    id = 1181,
    Content = "summon",
    Params = {
      id = 1202003,
      pos = {
        -75.71,
        20.21,
        46.27
      },
      group_id = 2,
      dead_disp_time = 3,
      territory = 0,
      search = 0,
      dir = 350.1,
      purse = 10,
      ai = 25688
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1182] = {
    id = 1182,
    Content = "summon",
    Params = {
      id = 1202003,
      pos = {
        -71.89,
        20.21,
        47.36
      },
      group_id = 2,
      dead_disp_time = 3,
      territory = 0,
      search = 0,
      dir = 334,
      purse = 10,
      ai = 25688
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1183] = {
    id = 1183,
    Content = "summon",
    Params = {
      id = 1202003,
      pos = {
        -68.91,
        20.21,
        49.53
      },
      group_id = 2,
      dead_disp_time = 3,
      territory = 0,
      search = 0,
      dir = 311.46,
      purse = 10,
      ai = 25688
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1184] = {
    id = 1184,
    Content = "summon",
    Params = {
      id = 1202003,
      pos = {
        -66.61,
        20.21,
        53.3
      },
      group_id = 2,
      dead_disp_time = 3,
      territory = 0,
      search = 0,
      dir = 286.72,
      purse = 10,
      ai = 25688
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1185] = {
    id = 1185,
    Content = "summon",
    Params = {
      id = 1202003,
      pos = {
        -65.88,
        20.21,
        57.1
      },
      group_id = 2,
      dead_disp_time = 3,
      territory = 0,
      search = 0,
      dir = 269.23,
      purse = 10,
      ai = 25688
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1186] = {
    id = 1186,
    Content = "summon",
    Params = {
      id = 1202003,
      pos = {
        -66.36,
        20.21,
        61
      },
      group_id = 2,
      dead_disp_time = 3,
      territory = 0,
      search = 0,
      dir = 254,
      purse = 10,
      ai = 25688
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1187] = {
    id = 1187,
    Content = "summon",
    Params = {
      id = 1202003,
      pos = {
        -63.5,
        20,
        50
      },
      dir = 296,
      group_id = 2,
      dead_disp_time = 3,
      territory = 0,
      search = 0,
      purse = 10,
      waitaction = "die",
      ai = 25636
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1188] = {
    id = 1188,
    Content = "summon",
    Params = {
      id = 1202003,
      pos = {
        -66.68,
        20,
        46.5
      },
      dir = 314.22,
      group_id = 2,
      dead_disp_time = 3,
      territory = 0,
      search = 0,
      purse = 10,
      waitaction = "die",
      ai = 25636
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1189] = {
    id = 1189,
    Content = "summon",
    Params = {
      id = 1202003,
      pos = {
        -63,
        20,
        48.86
      },
      dir = 314.22,
      group_id = 2,
      dead_disp_time = 3,
      territory = 0,
      search = 0,
      purse = 10,
      waitaction = "die",
      ai = 25636
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1190] = {
    id = 1190,
    Content = "summon",
    Params = {
      id = 1202003,
      pos = {
        -65.84,
        20,
        44.13
      },
      dir = 314.22,
      group_id = 2,
      dead_disp_time = 3,
      territory = 0,
      search = 0,
      purse = 10,
      waitaction = "die",
      ai = 25636
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1191] = {
    id = 1191,
    Content = "summon",
    Params = {
      id = 1202003,
      pos = {
        -60.78,
        20,
        47.58
      },
      dir = 314.22,
      group_id = 2,
      dead_disp_time = 3,
      territory = 0,
      search = 0,
      purse = 10,
      waitaction = "die",
      ai = 25636
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1192] = {
    id = 1192,
    Content = "summon",
    Params = {
      id = 1202003,
      pos = {
        -63.44,
        20,
        42.82
      },
      dir = 314.22,
      group_id = 2,
      dead_disp_time = 3,
      territory = 0,
      search = 0,
      purse = 10,
      waitaction = "die",
      ai = 25636
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1193] = {
    id = 1193,
    Content = "summon",
    Params = {
      id = 1202003,
      pos = {
        -58.98,
        20,
        44.3
      },
      dir = 314.22,
      group_id = 2,
      dead_disp_time = 3,
      territory = 0,
      search = 0,
      purse = 10,
      waitaction = "die",
      ai = 25636
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1194] = {
    id = 1194,
    Content = "summon",
    Params = {
      id = 1202003,
      pos = {
        -61.22,
        20,
        40.06
      },
      dir = 314.22,
      group_id = 2,
      dead_disp_time = 3,
      territory = 0,
      search = 0,
      purse = 10,
      waitaction = "die",
      ai = 25636
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1195] = {
    id = 1195,
    Content = "summon",
    Params = {
      id = 1202003,
      pos = {
        -58.13,
        20,
        41.68
      },
      dir = 314.22,
      group_id = 2,
      dead_disp_time = 3,
      territory = 0,
      search = 0,
      purse = 10,
      waitaction = "die",
      ai = 25636
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1196] = {
    id = 1196,
    Content = "summon",
    Params = {
      id = 1202003,
      pos = {
        -59.96,
        20,
        37.98
      },
      dir = 319.1,
      group_id = 2,
      dead_disp_time = 3,
      territory = 0,
      search = 0,
      purse = 10,
      waitaction = "die",
      ai = 25636
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1197] = {
    id = 1197,
    Content = "summon",
    Params = {
      id = 1202003,
      pos = {
        -56.67,
        20,
        39.64
      },
      dir = 319.1,
      group_id = 2,
      dead_disp_time = 3,
      territory = 0,
      search = 0,
      purse = 10,
      waitaction = "die",
      ai = 25636
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1198] = {
    id = 1198,
    Content = "summon",
    Params = {
      id = 1202003,
      pos = {
        -60.23,
        20,
        35.63
      },
      dir = 319.1,
      group_id = 2,
      dead_disp_time = 3,
      territory = 0,
      search = 0,
      purse = 10,
      waitaction = "die",
      ai = 25636
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1199] = {
    id = 1199,
    Content = "summon",
    Params = {
      id = 1202003,
      pos = {
        -58.7,
        20,
        35.66
      },
      dir = 319.1,
      group_id = 2,
      dead_disp_time = 3,
      territory = 0,
      search = 0,
      purse = 10,
      waitaction = "die",
      ai = 25636
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1200] = {
    id = 1200,
    Content = "summon",
    Params = {
      id = 1202003,
      pos = {
        -54.67,
        20,
        38.99
      },
      dir = 306.52,
      group_id = 2,
      dead_disp_time = 3,
      territory = 0,
      search = 0,
      purse = 10,
      waitaction = "die",
      ai = 25636
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1201] = {
    id = 1201,
    Content = "killall",
    Params = {
      group_ids = {1}
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1202] = {
    id = 1202,
    Content = "wait_refresh",
    Params = {time = 300, work_time_type = 1},
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1203] = {
    id = 1203,
    Content = "multigm",
    Params = {
      type = "effect",
      effect = "Skill/Task_NecromancerSummons",
      pos = {
        -64.84,
        14.79,
        -75.49
      },
      times = 1
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1204] = {
    id = 1204,
    Content = "wait",
    Params = {time = 3},
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1205] = {
    id = 1205,
    Content = "summon",
    Params = {
      id = 1203018,
      pos = {
        -64.84,
        14.79,
        -75.49
      },
      group_id = 1,
      dead_disp_time = 20,
      territory = 0,
      search = 0,
      dir = 33,
      purse = 10,
      walkid = 4766
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1206] = {
    id = 1206,
    Content = "summon",
    Params = {
      id = 818328,
      pos = {
        -71.54,
        14.74,
        -83.59
      },
      group_id = 2,
      territory = 0,
      search = 0,
      dir = 28,
      no_clear = 1
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1207] = {
    id = 1207,
    Content = "summon",
    Params = {
      id = 1202004,
      pos = {
        -54.22,
        14.9,
        -19.64
      },
      group_id = 2,
      dead_disp_time = 3,
      territory = 0,
      search = 0,
      dir = 5,
      purse = 10,
      ai = 25636
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1208] = {
    id = 1208,
    Content = "summon",
    Params = {
      id = 1202004,
      pos = {
        -57.04,
        14.9,
        -72.45
      },
      group_id = 2,
      dead_disp_time = 3,
      territory = 0,
      search = 0,
      dir = 95.66,
      purse = 10,
      ai = 25636
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1209] = {
    id = 1209,
    Content = "summon",
    Params = {
      id = 1202004,
      pos = {
        -58.67,
        14.9,
        -76.9
      },
      group_id = 2,
      dead_disp_time = 3,
      territory = 0,
      search = 0,
      dir = 220,
      purse = 10,
      ai = 25636,
      walkid = 4771
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1210] = {
    id = 1210,
    Content = "summon",
    Params = {
      id = 1202004,
      pos = {
        -68.29,
        14.9,
        -69.33
      },
      group_id = 2,
      dead_disp_time = 3,
      territory = 0,
      search = 0,
      dir = 244,
      purse = 10,
      ai = 25636,
      walkid = 4772
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1211] = {
    id = 1211,
    Content = "killall",
    Params = {
      group_ids = {1}
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1212] = {
    id = 1212,
    Content = "wait_refresh",
    Params = {time = 300, work_time_type = 1},
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1213] = {
    id = 1213,
    Content = "multigm",
    Params = {
      type = "effect",
      effect = "Skill/Task_NecromancerSummons",
      pos = {
        2.17,
        16.92,
        -88.13
      },
      times = 1
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1214] = {
    id = 1214,
    Content = "wait",
    Params = {time = 3},
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1215] = {
    id = 1215,
    Content = "summon",
    Params = {
      id = 1203019,
      pos = {
        2.17,
        16.92,
        -88.13
      },
      group_id = 1,
      dead_disp_time = 20,
      territory = 0,
      search = 4,
      dir = 325,
      purse = 10,
      walkid = 4767
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1216] = {
    id = 1216,
    Content = "summon",
    Params = {
      id = 818328,
      pos = {
        5.33,
        17.11,
        -92.26
      },
      group_id = 2,
      territory = 0,
      search = 0,
      dir = 325,
      no_clear = 1
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1217] = {
    id = 1217,
    Content = "killall",
    Params = {
      group_ids = {1}
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1218] = {
    id = 1218,
    Content = "wait_refresh",
    Params = {time = 300, work_time_type = 1},
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1219] = {
    id = 1219,
    Content = "summon",
    Params = {
      id = 1203142,
      pos = {
        -8.01,
        21.65,
        50.03
      },
      group_id = 5,
      dead_disp_time = 3,
      dir = 130
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1220] = {
    id = 1220,
    Content = "move",
    Params = {
      pos = {
        -8.01,
        21.65,
        50.03
      },
      distance = 10,
      record_char = 1
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1221] = {
    id = 1221,
    Content = "multigm",
    Params = {
      type = "shakescreen",
      amplitude = 10,
      msec = 2500,
      shaketype = 1,
      sync = 1,
      spec_char = 1,
      fail_on_leave = 1
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1222] = {
    id = 1222,
    Content = "wait",
    Params = {time = 2},
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1223] = {
    id = 1223,
    Content = "multigm",
    Params = {
      type = "shakescreen",
      amplitude = 10,
      msec = 5000,
      shaketype = 1,
      sync = 1,
      spec_char = 1,
      fail_on_leave = 1
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1224] = {
    id = 1224,
    Content = "wait",
    Params = {time = 1},
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1225] = {
    id = 1225,
    Content = "multigm",
    Params = {
      type = "effect",
      effect = "Skill/SuperLandBite",
      pos = {
        -8.01,
        21.65,
        50.03
      },
      times = 1
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1226] = {
    id = 1226,
    Content = "summon",
    Params = {
      id = 1203151,
      pos = {
        -8.01,
        21.65,
        50.03
      },
      group_id = 1,
      dir = 50
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1227] = {
    id = 1227,
    Content = "killmonster",
    Params = {
      npcid = {1203152},
      num = 100,
      process_msg_zone = 100
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1228] = {
    id = 1228,
    Content = "del_map_zone",
    Params = {map_zone = 100, type = 2},
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1229] = {
    id = 1229,
    Content = "multigm",
    Params = {
      type = "effect",
      effect = "Skill/EleDefence_Death",
      pos = {
        -8.01,
        21.65,
        50.03
      },
      times = 1
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1230] = {
    id = 1230,
    Content = "wait",
    Params = {time = 2},
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1231] = {
    id = 1231,
    Content = "summon",
    Params = {
      id = 320110,
      pos = {
        -8.11,
        21.65,
        49.25
      },
      dir = 180,
      dead_disp_time = 900,
      territory = 10,
      search = 10
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1232] = {
    id = 1232,
    Content = "wait",
    Params = {time = 1},
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1233] = {
    id = 1233,
    Content = "clearnpc",
    Params = {
      group_ids = {1, 5}
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1234] = {
    id = 1234,
    Content = "killmonster",
    Params = {
      npcid = {320110},
      num = 1
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1235] = {
    id = 1235,
    Content = "clearnpc",
    Params = {
      npcid = {1203152}
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1236] = {
    id = 1236,
    Content = "wait_refresh",
    Params = {time = 1800, work_time_type = 1},
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1237] = {
    id = 1237,
    Content = "summon",
    Params = {
      id = 1203142,
      pos = {
        66.45,
        27.56,
        10.55
      },
      group_id = 5,
      dead_disp_time = 3,
      dir = 130
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1238] = {
    id = 1238,
    Content = "summon",
    Params = {
      id = 1203131,
      pos = {
        42.95,
        26.34,
        10.69
      },
      group_id = 1,
      dir = 10,
      walkid = 4751
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1239] = {
    id = 1239,
    Content = "summon",
    Params = {
      id = 1203131,
      pos = {
        67.48,
        26.81,
        23.73
      },
      group_id = 1,
      dir = 10,
      walkid = 4752
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1240] = {
    id = 1240,
    Content = "summon",
    Params = {
      id = 1203131,
      pos = {
        76.83,
        26.88,
        5.28
      },
      group_id = 1,
      dir = 10,
      walkid = 4753
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1241] = {
    id = 1241,
    Content = "killall",
    Params = {
      group_ids = {1}
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1242] = {
    id = 1242,
    Content = "clearnpc",
    Params = {
      npcid = {1203131}
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1243] = {
    id = 1243,
    Content = "multigm",
    Params = {
      type = "effect",
      effect = "Skill/EleDefence_Death",
      pos = {
        66.59,
        27.48,
        10.33
      },
      times = 1
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1244] = {
    id = 1244,
    Content = "wait",
    Params = {time = 2},
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1245] = {
    id = 1245,
    Content = "summon",
    Params = {
      id = 320120,
      pos = {
        66.45,
        27.56,
        10.55
      },
      dir = -90.51,
      dead_disp_time = 900,
      territory = 10,
      search = 10
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1246] = {
    id = 1246,
    Content = "wait",
    Params = {time = 1},
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1247] = {
    id = 1247,
    Content = "clearnpc",
    Params = {
      group_ids = {5}
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1248] = {
    id = 1248,
    Content = "killmonster",
    Params = {
      npcid = {320120},
      num = 1
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1249] = {
    id = 1249,
    Content = "wait_refresh",
    Params = {time = 1800, work_time_type = 1},
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1250] = {
    id = 1250,
    Content = "set_obj_state",
    Params = {
      obj_states = {
        {
          obj = 3,
          state = "mfx_scmvp3_yanfire_state1001"
        },
        {
          obj = 9,
          state = "mfx_scmvp3_yanfire_state1001"
        },
        {
          obj = 2,
          state = "mfx_scmvp3_shifire_state1001"
        },
        {
          obj = 10,
          state = "mfx_scmvp3_yanfire_state1001"
        },
        {
          obj = 11,
          state = "mfx_scmvp3_yanfire_state1001"
        },
        {
          obj = 8,
          state = "mfx_scmvp3_shifire_state1001"
        },
        {
          obj = 1,
          state = "mfx_scmvp3_fire01_blue_state1001"
        }
      }
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1251] = {
    id = 1251,
    Content = "in_order_kill",
    Params = {
      order_kill_npc = {
        1203143,
        1203144,
        1203145,
        1203146
      },
      show_type = 3,
      pos_data = {
        {
          pos = {
            -84.38,
            17.61,
            3.09
          },
          obj_id = 4,
          dir = 230,
          state = {
            [0] = "mfx_scmvp3_fire02_4_state1001",
            [1] = "mfx_scmvp3_fire02_4_state2001"
          }
        },
        {
          pos = {
            -99.51,
            17.61,
            -0.79
          },
          obj_id = 5,
          dir = 62,
          state = {
            [0] = "mfx_scmvp3_fire02_3_state1001",
            [1] = "mfx_scmvp3_fire02_3_state2001"
          }
        },
        {
          pos = {
            -92.97,
            17.61,
            -6.68
          },
          obj_id = 6,
          dir = 69,
          state = {
            [0] = "mfx_scmvp3_fire02_2_state1001",
            [1] = "mfx_scmvp3_fire02_2_state2001"
          }
        },
        {
          pos = {
            -90.64,
            17.61,
            8.78
          },
          obj_id = 7,
          dir = 171,
          state = {
            [0] = "mfx_scmvp3_fire02_1_state1001",
            [1] = "mfx_scmvp3_fire02_1_state2001"
          }
        }
      },
      fail_buffs = {
        159797,
        159798,
        159815
      },
      no_rand = 1
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1252] = {
    id = 1252,
    Content = "set_obj_state",
    Params = {
      obj_states = {
        {
          obj = 3,
          state = "mfx_scmvp3_yanfire_state2001"
        },
        {
          obj = 9,
          state = "mfx_scmvp3_yanfire_state2001"
        },
        {
          obj = 2,
          state = "mfx_scmvp3_shifire_state2001"
        },
        {
          obj = 10,
          state = "mfx_scmvp3_yanfire_state2001"
        },
        {
          obj = 11,
          state = "mfx_scmvp3_yanfire_state2001"
        },
        {
          obj = 8,
          state = "mfx_scmvp3_shifire_state2001"
        },
        {
          obj = 1,
          state = "mfx_scmvp3_fire01_blue_state2001"
        }
      }
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1253] = {
    id = 1253,
    Content = "summon",
    Params = {
      id = 1203142,
      pos = {
        -91.76,
        17.68,
        1.22
      },
      group_id = 10,
      dead_disp_time = 3,
      dir = 130,
      ai = 25669
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1254] = {
    id = 1254,
    Content = "wait",
    Params = {time = 2},
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1255] = {
    id = 1255,
    Content = "summon",
    Params = {
      id = 320130,
      pos = {
        -91.76,
        17.68,
        1.22
      },
      dir = 124.52,
      dead_disp_time = 900,
      territory = 10,
      search = 10
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1256] = {
    id = 1256,
    Content = "wait",
    Params = {time = 1},
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1257] = {
    id = 1257,
    Content = "clearnpc",
    Params = {
      group_ids = {10}
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1258] = {
    id = 1258,
    Content = "killmonster",
    Params = {
      npcid = {320130},
      num = 1
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1259] = {
    id = 1259,
    Content = "wait_refresh",
    Params = {time = 1800, work_time_type = 1},
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1260] = {
    id = 1260,
    Content = "summon",
    Params = {
      id = 1203153,
      pos = {
        -42.81,
        17.86,
        -117.66
      },
      group_id = 1,
      dead_disp_time = 5,
      territory = 0,
      search = 0
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1261] = {
    id = 1261,
    Content = "wait_super_ai",
    Params = _EmptyTable,
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1262] = {
    id = 1262,
    Content = "killall",
    Params = {
      group_ids = {1}
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1263] = {
    id = 1263,
    Content = "del_map_zone",
    Params = {map_zone = 103, type = 1},
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1264] = {
    id = 1264,
    Content = "wait_refresh",
    Params = {time = 10},
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1265] = {
    id = 1265,
    Content = "count_down_zone",
    Params = {map_zone = 103, time = 30},
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1266] = {
    id = 1266,
    Content = "wait",
    Params = {time = 30},
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1267] = {
    id = 1267,
    Content = "stop_other",
    Params = _EmptyTable,
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1268] = {
    id = 1268,
    Content = "clearnpc",
    Params = {
      npcid = {1203158, 1203159}
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1269] = {
    id = 1269,
    Content = "clearnpc",
    Params = {
      group_ids = {1}
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1270] = {
    id = 1270,
    Content = "summon",
    Params = {
      id = 1203142,
      pos = {
        -42.81,
        17.75,
        -117.66
      },
      group_id = 10,
      territory = 0,
      search = 0
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1271] = {
    id = 1271,
    Content = "wait",
    Params = {time = 2},
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1272] = {
    id = 1272,
    Content = "summon",
    Params = {
      id = 320140,
      pos = {
        -42.81,
        17.75,
        -117.66
      },
      group_id = 2,
      dead_disp_time = 900,
      territory = 10,
      search = 10,
      purse = 10
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1273] = {
    id = 1273,
    Content = "wait",
    Params = {time = 2},
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1274] = {
    id = 1274,
    Content = "clearnpc",
    Params = {
      group_ids = {10}
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1275] = {
    id = 1275,
    Content = "killall",
    Params = {
      group_ids = {2}
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1276] = {
    id = 1276,
    Content = "wait_refresh",
    Params = {time = 1800, work_time_type = 1},
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1277] = {
    id = 1277,
    Content = "summon",
    Params = {
      id = 1203142,
      pos = {
        38.65,
        19,
        -66.78
      },
      group_id = 5,
      dead_disp_time = 3,
      dir = 130
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1278] = {
    id = 1278,
    Content = "summon",
    Params = {
      id = 1203118,
      pos = {
        28.63,
        19.04,
        -66.24
      },
      group_id = 10,
      territory = 0,
      search = 0
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1279] = {
    id = 1279,
    Content = "summon",
    Params = {
      id = 1203118,
      pos = {
        33.8,
        19.04,
        -57.87
      },
      group_id = 10,
      territory = 0,
      search = 0
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1280] = {
    id = 1280,
    Content = "wait",
    Params = {time = 3},
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1281] = {
    id = 1281,
    Content = "summon",
    Params = {
      id = 1203140,
      pos = {
        28.63,
        19.04,
        -66.24
      },
      group_id = 1,
      dead_disp_time = 5,
      dir = 164,
      purse = 8
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1282] = {
    id = 1282,
    Content = "summon",
    Params = {
      id = 1203140,
      pos = {
        33.8,
        19.04,
        -57.87
      },
      group_id = 1,
      dead_disp_time = 5,
      dir = 70,
      purse = 8
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1283] = {
    id = 1283,
    Content = "killall",
    Params = {
      group_ids = {1}
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1284] = {
    id = 1284,
    Content = "multigm",
    Params = {
      type = "effect",
      effect = "Skill/EleDefence_Death",
      pos = {
        38.69,
        19,
        -66.73
      },
      times = 1
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1285] = {
    id = 1285,
    Content = "wait",
    Params = {time = 2},
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1286] = {
    id = 1286,
    Content = "summon",
    Params = {
      id = 320150,
      pos = {
        38.87,
        19.08,
        -66.8
      },
      dir = -50.09,
      dead_disp_time = 900,
      territory = 10,
      search = 10
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1287] = {
    id = 1287,
    Content = "wait",
    Params = {time = 1},
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1288] = {
    id = 1288,
    Content = "clearnpc",
    Params = {
      group_ids = {5, 10}
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1289] = {
    id = 1289,
    Content = "killmonster",
    Params = {
      npcid = {320150},
      num = 1
    },
    MapID = 143,
    StartCondition = _EmptyTable
  },
  [1290] = {
    id = 1290,
    Content = "wait_refresh",
    Params = {time = 1800, work_time_type = 1},
    MapID = 143,
    StartCondition = _EmptyTable
  }
}
Table_MapStep_fields = {
  "id",
  "Content",
  "Params",
  "MapID",
  "StartCondition"
}
return Table_MapStep
