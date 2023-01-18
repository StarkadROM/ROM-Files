Table_PlotQuest_76 = {
  [1] = {
    id = 1,
    Type = "showview",
    Params = {panelid = 800, showtype = 1}
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
    Type = "onoff_camerapoint",
    Params = {groupid = 2, on = true}
  },
  [4] = {
    id = 4,
    Type = "summon",
    Params = {
      npcid = 807312,
      npcuid = 312,
      groupid = 1,
      pos = {
        -17.76,
        0.85,
        21.39
      },
      dir = 44.45
    }
  },
  [5] = {
    id = 5,
    Type = "wait_time",
    Params = {time = 2000}
  },
  [6] = {
    id = 6,
    Type = "play_effect_scene",
    Params = {
      id = 170,
      path = "Common/Eff_MeteorFall",
      pos = {
        -16.57,
        0.69,
        23.57
      },
      ignoreNavMesh = 1,
      scale = 2
    }
  },
  [7] = {
    id = 7,
    Type = "summon",
    Params = {
      npcid = 807319,
      npcuid = 3391,
      groupid = 1,
      pos = {
        -15.1,
        0.69,
        23.91
      },
      dir = 82.314
    }
  },
  [8] = {
    id = 8,
    Type = "play_effect_scene",
    Params = {
      id = 17,
      path = "Skill/EarthDrive_buff",
      pos = {
        -15.1,
        0.69,
        23.91
      }
    }
  },
  [9] = {
    id = 9,
    Type = "play_effect_scene",
    Params = {
      id = 180,
      path = "Common/Eff_MeteorFall",
      pos = {
        -15.26,
        0.69,
        17.61
      },
      ignoreNavMesh = 1,
      scale = 2
    }
  },
  [10] = {
    id = 10,
    Type = "summon",
    Params = {
      npcid = 807320,
      npcuid = 3392,
      groupid = 1,
      pos = {
        -13.8,
        0.71,
        17.93
      },
      dir = 0.68
    }
  },
  [11] = {
    id = 11,
    Type = "play_effect_scene",
    Params = {
      id = 18,
      path = "Skill/EarthDrive_buff",
      pos = {
        -13.8,
        0.71,
        17.93
      }
    }
  },
  [12] = {
    id = 12,
    Type = "play_effect_scene",
    Params = {
      id = 190,
      path = "Common/Eff_MeteorFall",
      pos = {
        -10.81,
        0.69,
        22.13
      },
      ignoreNavMesh = 1,
      scale = 2
    }
  },
  [13] = {
    id = 13,
    Type = "summon",
    Params = {
      npcid = 807321,
      npcuid = 3393,
      groupid = 1,
      pos = {
        -9.08,
        0.87,
        22.29
      },
      dir = 174.5597
    }
  },
  [14] = {
    id = 14,
    Type = "play_effect_scene",
    Params = {
      id = 19,
      path = "Skill/EarthDrive_buff",
      pos = {
        -9.08,
        0.87,
        22.29
      }
    }
  },
  [15] = {
    id = 15,
    Type = "wait_time",
    Params = {time = 2000}
  },
  [16] = {
    id = 16,
    Type = "addbutton",
    Params = {
      id = 1,
      text = "##298181",
      eventtype = "goon"
    }
  },
  [17] = {
    id = 17,
    Type = "wait_ui",
    Params = {button = 1}
  },
  [18] = {
    id = 18,
    Type = "action",
    Params = {player = 1, id = 38}
  },
  [19] = {
    id = 19,
    Type = "play_effect_scene",
    Params = {
      id = 1,
      path = "Skill/Eff_MeteorPulse_hit",
      pos = {
        -12.55,
        1.75,
        21.45
      },
      onshot = 1
    }
  },
  [20] = {
    id = 20,
    Type = "wait_time",
    Params = {time = 1000}
  },
  [21] = {
    id = 21,
    Type = "play_effect_scene",
    Params = {
      id = 100,
      path = "Skill/Eff_MeteorPulse_hit",
      pos = {
        -12.55,
        0.75,
        21.45
      },
      onshot = 1
    }
  },
  [22] = {
    id = 22,
    Type = "wait_time",
    Params = {time = 1000}
  },
  [23] = {
    id = 23,
    Type = "onoff_camerapoint",
    Params = {groupid = 2, on = false}
  },
  [24] = {
    id = 24,
    Type = "onoff_camerapoint",
    Params = {groupid = 0, on = true}
  },
  [25] = {
    id = 25,
    Type = "play_effect_scene",
    Params = {
      id = 101,
      path = "Skill/Eff_CryogenicCyclone_buff",
      pos = {
        -11.67,
        0.69,
        20.77
      }
    }
  },
  [26] = {
    id = 26,
    Type = "wait_time",
    Params = {time = 2000}
  },
  [27] = {
    id = 27,
    Type = "remove_effect_scene",
    Params = {id = 1}
  },
  [28] = {
    id = 28,
    Type = "addbutton",
    Params = {
      id = 2,
      text = "##298183",
      eventtype = "goon"
    }
  },
  [29] = {
    id = 29,
    Type = "wait_ui",
    Params = {button = 2}
  },
  [30] = {
    id = 30,
    Type = "play_effect_scene",
    Params = {
      id = 20,
      path = "Skill/LVUP_Process",
      pos = {
        -15.1,
        1.69,
        23.91
      },
      ignoreNavMesh = 1,
      scale = 3
    }
  },
  [31] = {
    id = 31,
    Type = "play_effect_scene",
    Params = {
      id = 21,
      path = "Skill/LVUP_Process",
      pos = {
        -13.8,
        1.69,
        17.93
      },
      ignoreNavMesh = 1,
      scale = 3
    }
  },
  [32] = {
    id = 32,
    Type = "play_effect_scene",
    Params = {
      id = 22,
      path = "Skill/LVUP_Process",
      pos = {
        -9.08,
        1.69,
        22.29
      },
      ignoreNavMesh = 1,
      scale = 3
    }
  },
  [33] = {
    id = 33,
    Type = "action",
    Params = {player = 1, id = 10}
  },
  [34] = {
    id = 34,
    Type = "onoff_camerapoint",
    Params = {groupid = 0, on = false}
  },
  [35] = {
    id = 35,
    Type = "onoff_camerapoint",
    Params = {groupid = 1, on = true}
  },
  [36] = {
    id = 36,
    Type = "remove_effect_scene",
    Params = {id = 101}
  },
  [37] = {
    id = 37,
    Type = "play_effect_scene",
    Params = {
      id = 8,
      path = "Skill/LVUP_Process_2",
      pos = {
        -12.83,
        2.76,
        21.55
      },
      ignoreNavMesh = 1
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
      id = 30,
      path = "Common/Eff_MeteorFall",
      pos = {
        -18.21,
        8.29,
        26.69
      },
      ignoreNavMesh = 1,
      scale = 2
    }
  },
  [40] = {
    id = 40,
    Type = "play_effect_scene",
    Params = {
      id = 300,
      path = "Common/Eff_MeteorFall",
      pos = {
        -17.81,
        9.18,
        21.69
      },
      ignoreNavMesh = 1,
      scale = 2
    }
  },
  [41] = {
    id = 41,
    Type = "wait_time",
    Params = {time = 500}
  },
  [42] = {
    id = 42,
    Type = "play_effect_scene",
    Params = {
      id = 31,
      path = "Common/Eff_MeteorFall",
      pos = {
        -17.21,
        7.29,
        25.69
      },
      ignoreNavMesh = 1,
      scale = 2.5
    }
  },
  [43] = {
    id = 43,
    Type = "play_effect_scene",
    Params = {
      id = 32,
      path = "Common/Eff_MeteorFall",
      pos = {
        -16.21,
        6.29,
        24.69
      },
      ignoreNavMesh = 1,
      scale = 3
    }
  },
  [44] = {
    id = 44,
    Type = "play_effect_scene",
    Params = {
      id = 310,
      path = "Common/Eff_MeteorFall",
      pos = {
        -17.21,
        7.29,
        22.69
      },
      ignoreNavMesh = 1,
      scale = 2.5
    }
  },
  [45] = {
    id = 45,
    Type = "play_effect_scene",
    Params = {
      id = 320,
      path = "Common/Eff_MeteorFall",
      pos = {
        -16.21,
        6.29,
        23.69
      },
      ignoreNavMesh = 1,
      scale = 3
    }
  },
  [46] = {
    id = 46,
    Type = "wait_time",
    Params = {time = 100}
  },
  [47] = {
    id = 47,
    Type = "play_effect_scene",
    Params = {
      id = 33,
      path = "Common/Eff_MeteorFall",
      pos = {
        -18.21,
        6.29,
        27.59
      },
      ignoreNavMesh = 1,
      scale = 2
    }
  },
  [48] = {
    id = 48,
    Type = "play_effect_scene",
    Params = {
      id = 34,
      path = "Common/Eff_MeteorFall",
      pos = {
        -17.21,
        7.29,
        26.19
      },
      ignoreNavMesh = 1,
      scale = 2.5
    }
  },
  [49] = {
    id = 49,
    Type = "play_effect_scene",
    Params = {
      id = 330,
      path = "Common/Eff_MeteorFall",
      pos = {
        -18.21,
        6.29,
        27.59
      },
      ignoreNavMesh = 1,
      scale = 2
    }
  },
  [50] = {
    id = 50,
    Type = "play_effect_scene",
    Params = {
      id = 340,
      path = "Common/Eff_MeteorFall",
      pos = {
        -17.21,
        7.29,
        26.19
      },
      ignoreNavMesh = 1,
      scale = 2.5
    }
  },
  [51] = {
    id = 51,
    Type = "wait_time",
    Params = {time = 100}
  },
  [52] = {
    id = 52,
    Type = "play_effect_scene",
    Params = {
      id = 35,
      path = "Common/Eff_MeteorFall",
      pos = {
        -16.21,
        8.29,
        22.69
      },
      ignoreNavMesh = 1,
      scale = 3
    }
  },
  [53] = {
    id = 53,
    Type = "play_effect_scene",
    Params = {
      id = 35,
      path = "Common/Eff_MeteorFall",
      pos = {
        -18.21,
        8.29,
        26.69
      },
      ignoreNavMesh = 1,
      scale = 3
    }
  },
  [54] = {
    id = 54,
    Type = "wait_time",
    Params = {time = 100}
  },
  [55] = {
    id = 55,
    Type = "play_effect_scene",
    Params = {
      id = 36,
      path = "Common/Eff_MeteorFall",
      pos = {
        -12.21,
        6.29,
        26.69
      },
      ignoreNavMesh = 1,
      scale = 2.5
    }
  },
  [56] = {
    id = 56,
    Type = "play_effect_scene",
    Params = {
      id = 360,
      path = "Common/Eff_MeteorFall",
      pos = {
        -13.21,
        6.29,
        22.69
      },
      ignoreNavMesh = 1,
      scale = 2.5
    }
  },
  [57] = {
    id = 57,
    Type = "wait_time",
    Params = {time = 100}
  },
  [58] = {
    id = 58,
    Type = "play_effect_scene",
    Params = {
      id = 37,
      path = "Common/Eff_MeteorFall",
      pos = {
        -14.21,
        7.29,
        23.69
      },
      ignoreNavMesh = 1,
      scale = 2
    }
  },
  [59] = {
    id = 59,
    Type = "play_effect_scene",
    Params = {
      id = 370,
      path = "Common/Eff_MeteorFall",
      pos = {
        -17.21,
        7.29,
        23.69
      },
      ignoreNavMesh = 1,
      scale = 2
    }
  },
  [60] = {
    id = 60,
    Type = "wait_time",
    Params = {time = 100}
  },
  [61] = {
    id = 61,
    Type = "play_effect_scene",
    Params = {
      id = 38,
      path = "Common/Eff_MeteorFall",
      pos = {
        -16.21,
        8.29,
        26.69
      },
      ignoreNavMesh = 1,
      scale = 3
    }
  },
  [62] = {
    id = 62,
    Type = "play_effect_scene",
    Params = {
      id = 39,
      path = "Common/Eff_MeteorFall",
      pos = {
        -18.21,
        5.29,
        26.69
      },
      ignoreNavMesh = 1,
      scale = 3
    }
  },
  [63] = {
    id = 63,
    Type = "play_effect_scene",
    Params = {
      id = 380,
      path = "Common/Eff_MeteorFall",
      pos = {
        -20.21,
        8.29,
        26.69
      },
      ignoreNavMesh = 1,
      scale = 3
    }
  },
  [64] = {
    id = 64,
    Type = "play_effect_scene",
    Params = {
      id = 390,
      path = "Common/Eff_MeteorFall",
      pos = {
        -21.21,
        5.29,
        26.69
      },
      ignoreNavMesh = 1,
      scale = 3
    }
  },
  [65] = {
    id = 65,
    Type = "wait_time",
    Params = {time = 200}
  },
  [66] = {
    id = 66,
    Type = "play_effect_scene",
    Params = {
      id = 40,
      path = "Common/Eff_MeteorFall",
      pos = {
        -17.21,
        8.29,
        26.69
      },
      ignoreNavMesh = 1,
      scale = 3
    }
  },
  [67] = {
    id = 67,
    Type = "play_effect_scene",
    Params = {
      id = 41,
      path = "Common/Eff_MeteorFall",
      pos = {
        -16.21,
        9,
        26.69
      },
      ignoreNavMesh = 1,
      scale = 2
    }
  },
  [68] = {
    id = 68,
    Type = "play_effect_scene",
    Params = {
      id = 400,
      path = "Common/Eff_MeteorFall",
      pos = {
        -15.21,
        8.29,
        23.69
      },
      ignoreNavMesh = 1,
      scale = 3
    }
  },
  [69] = {
    id = 69,
    Type = "play_effect_scene",
    Params = {
      id = 410,
      path = "Common/Eff_MeteorFall",
      pos = {
        -20.21,
        9,
        24.69
      },
      ignoreNavMesh = 1,
      scale = 2
    }
  },
  [70] = {
    id = 70,
    Type = "wait_time",
    Params = {time = 100}
  },
  [71] = {
    id = 71,
    Type = "play_effect_scene",
    Params = {
      id = 42,
      path = "Common/Eff_MeteorFall",
      pos = {
        -18.21,
        8.29,
        26.69
      },
      ignoreNavMesh = 1,
      scale = 3
    }
  },
  [72] = {
    id = 72,
    Type = "play_effect_scene",
    Params = {
      id = 420,
      path = "Common/Eff_MeteorFall",
      pos = {
        -11.21,
        8.29,
        26.69
      },
      ignoreNavMesh = 1,
      scale = 3
    }
  },
  [73] = {
    id = 73,
    Type = "wait_time",
    Params = {time = 200}
  },
  [74] = {
    id = 74,
    Type = "play_effect_scene",
    Params = {
      id = 43,
      path = "Common/Eff_MeteorFall",
      pos = {
        -18.21,
        7.29,
        27.59
      },
      ignoreNavMesh = 1,
      scale = 2
    }
  },
  [75] = {
    id = 75,
    Type = "play_effect_scene",
    Params = {
      id = 44,
      path = "Common/Eff_MeteorFall",
      pos = {
        -17.21,
        10.29,
        26.19
      },
      ignoreNavMesh = 1,
      scale = 3
    }
  },
  [76] = {
    id = 76,
    Type = "play_effect_scene",
    Params = {
      id = 430,
      path = "Common/Eff_MeteorFall",
      pos = {
        -10.21,
        7.29,
        23.59
      },
      ignoreNavMesh = 1,
      scale = 2
    }
  },
  [77] = {
    id = 77,
    Type = "play_effect_scene",
    Params = {
      id = 440,
      path = "Common/Eff_MeteorFall",
      pos = {
        -21.21,
        10.29,
        26.19
      },
      ignoreNavMesh = 1,
      scale = 3
    }
  },
  [78] = {
    id = 78,
    Type = "wait_time",
    Params = {time = 100}
  },
  [79] = {
    id = 79,
    Type = "play_effect_scene",
    Params = {
      id = 45,
      path = "Common/Eff_MeteorFall",
      pos = {
        -16.21,
        6.29,
        22.69
      },
      ignoreNavMesh = 1,
      scale = 2.5
    }
  },
  [80] = {
    id = 80,
    Type = "play_effect_scene",
    Params = {
      id = 450,
      path = "Common/Eff_MeteorFall",
      pos = {
        -12.21,
        6.29,
        22.69
      },
      ignoreNavMesh = 1,
      scale = 2.5
    }
  },
  [81] = {
    id = 81,
    Type = "wait_time",
    Params = {time = 100}
  },
  [82] = {
    id = 82,
    Type = "play_effect_scene",
    Params = {
      id = 461,
      path = "Skill/Eff_GuardianStars_buff",
      pos = {
        -12.55,
        0.75,
        21.45
      }
    }
  },
  [83] = {
    id = 83,
    Type = "play_effect_scene",
    Params = {
      id = 46,
      path = "Common/Eff_MeteorFall",
      pos = {
        -12.21,
        8.29,
        26.69
      },
      ignoreNavMesh = 1,
      scale = 3
    }
  },
  [84] = {
    id = 84,
    Type = "play_effect_scene",
    Params = {
      id = 47,
      path = "Common/Eff_MeteorFall",
      pos = {
        -14.21,
        7.29,
        23.69
      },
      ignoreNavMesh = 1,
      scale = 2
    }
  },
  [85] = {
    id = 85,
    Type = "play_effect_scene",
    Params = {
      id = 460,
      path = "Common/Eff_MeteorFall",
      pos = {
        -13.21,
        8.29,
        26.69
      },
      ignoreNavMesh = 1,
      scale = 3
    }
  },
  [86] = {
    id = 86,
    Type = "play_effect_scene",
    Params = {
      id = 470,
      path = "Common/Eff_MeteorFall",
      pos = {
        -17.21,
        7.29,
        24.69
      },
      ignoreNavMesh = 1,
      scale = 2
    }
  },
  [87] = {
    id = 87,
    Type = "wait_time",
    Params = {time = 100}
  },
  [88] = {
    id = 88,
    Type = "play_effect_scene",
    Params = {
      id = 48,
      path = "Common/Eff_MeteorFall",
      pos = {
        -18.21,
        6.29,
        25.09
      },
      ignoreNavMesh = 1,
      scale = 3
    }
  },
  [89] = {
    id = 89,
    Type = "play_effect_scene",
    Params = {
      id = 49,
      path = "Common/Eff_MeteorFall",
      pos = {
        -17.21,
        6.29,
        22.99
      },
      ignoreNavMesh = 1,
      scale = 2.5
    }
  },
  [90] = {
    id = 90,
    Type = "play_effect_scene",
    Params = {
      id = 480,
      path = "Common/Eff_MeteorFall",
      pos = {
        -20,
        6.29,
        25.09
      },
      ignoreNavMesh = 1,
      scale = 3
    }
  },
  [91] = {
    id = 91,
    Type = "play_effect_scene",
    Params = {
      id = 490,
      path = "Common/Eff_MeteorFall",
      pos = {
        -17.21,
        6.29,
        19.99
      },
      ignoreNavMesh = 1,
      scale = 2.5
    }
  },
  [92] = {
    id = 92,
    Type = "wait_time",
    Params = {time = 100}
  },
  [93] = {
    id = 93,
    Type = "play_effect_scene",
    Params = {
      id = 50,
      path = "Common/Eff_MeteorFall",
      pos = {
        -16.21,
        7.29,
        23.89
      },
      ignoreNavMesh = 1,
      scale = 2.5
    }
  },
  [94] = {
    id = 94,
    Type = "play_effect",
    Params = {
      id = 2,
      path = "Common/Angel_playshow_M",
      player = 1,
      ep = 3
    }
  },
  [95] = {
    id = 95,
    Type = "wait_time",
    Params = {time = 1000}
  },
  [96] = {
    id = 96,
    Type = "remove_effect_scene",
    Params = {id = 8}
  },
  [97] = {
    id = 97,
    Type = "onoff_camerapoint",
    Params = {groupid = 1, on = false}
  },
  [98] = {
    id = 98,
    Type = "remove_effect_scene",
    Params = {id = 30}
  },
  [99] = {
    id = 99,
    Type = "remove_effect_scene",
    Params = {id = 31}
  },
  [100] = {
    id = 100,
    Type = "remove_effect_scene",
    Params = {id = 32}
  },
  [101] = {
    id = 101,
    Type = "remove_effect_scene",
    Params = {id = 33}
  },
  [102] = {
    id = 102,
    Type = "remove_effect_scene",
    Params = {id = 34}
  },
  [103] = {
    id = 103,
    Type = "remove_effect_scene",
    Params = {id = 35}
  },
  [104] = {
    id = 104,
    Type = "remove_effect_scene",
    Params = {id = 36}
  },
  [105] = {
    id = 105,
    Type = "remove_effect_scene",
    Params = {id = 37}
  },
  [106] = {
    id = 106,
    Type = "remove_effect_scene",
    Params = {id = 38}
  },
  [107] = {
    id = 107,
    Type = "remove_effect_scene",
    Params = {id = 39}
  },
  [108] = {
    id = 108,
    Type = "remove_effect_scene",
    Params = {id = 40}
  },
  [109] = {
    id = 109,
    Type = "remove_effect_scene",
    Params = {id = 41}
  },
  [110] = {
    id = 110,
    Type = "remove_effect_scene",
    Params = {id = 42}
  },
  [111] = {
    id = 111,
    Type = "remove_effect_scene",
    Params = {id = 43}
  },
  [112] = {
    id = 112,
    Type = "remove_effect_scene",
    Params = {id = 44}
  },
  [113] = {
    id = 113,
    Type = "remove_effect_scene",
    Params = {id = 45}
  },
  [114] = {
    id = 114,
    Type = "remove_effect_scene",
    Params = {id = 46}
  },
  [115] = {
    id = 115,
    Type = "remove_effect_scene",
    Params = {id = 47}
  },
  [116] = {
    id = 116,
    Type = "remove_effect_scene",
    Params = {id = 48}
  },
  [117] = {
    id = 117,
    Type = "remove_effect_scene",
    Params = {id = 49}
  },
  [118] = {
    id = 118,
    Type = "onoff_camerapoint",
    Params = {groupid = 2, on = true}
  },
  [119] = {
    id = 119,
    Type = "addbutton",
    Params = {
      id = 3,
      text = "##298182",
      eventtype = "goon"
    }
  },
  [120] = {
    id = 120,
    Type = "remove_effect_scene",
    Params = {id = 20}
  },
  [121] = {
    id = 121,
    Type = "remove_effect_scene",
    Params = {id = 21}
  },
  [122] = {
    id = 122,
    Type = "remove_effect_scene",
    Params = {id = 22}
  },
  [123] = {
    id = 123,
    Type = "remove_effect_scene",
    Params = {id = 101}
  },
  [124] = {
    id = 124,
    Type = "wait_ui",
    Params = {button = 3}
  },
  [125] = {
    id = 125,
    Type = "remove_effect_scene",
    Params = {id = 17}
  },
  [126] = {
    id = 126,
    Type = "remove_effect_scene",
    Params = {id = 18}
  },
  [127] = {
    id = 127,
    Type = "remove_effect_scene",
    Params = {id = 19}
  },
  [128] = {
    id = 128,
    Type = "play_effect_scene",
    Params = {
      id = 14,
      path = "Skill/Eff_CometTrap_floor",
      pos = {
        -15.34,
        0.62,
        24.1
      },
      ignoreNavMesh = 1
    }
  },
  [129] = {
    id = 129,
    Type = "play_effect_scene",
    Params = {
      id = 15,
      path = "Skill/Eff_CometTrap_floor",
      pos = {
        -13.66,
        0.62,
        17.83
      },
      ignoreNavMesh = 1
    }
  },
  [130] = {
    id = 130,
    Type = "play_effect_scene",
    Params = {
      id = 16,
      path = "Skill/Eff_CometTrap_floor",
      pos = {
        -9.04,
        0.62,
        22.29
      },
      ignoreNavMesh = 1
    }
  },
  [131] = {
    id = 131,
    Type = "wait_time",
    Params = {time = 1500}
  },
  [132] = {
    id = 132,
    Type = "shakescreen",
    Params = {amplitude = 20, time = 3000}
  },
  [133] = {
    id = 133,
    Type = "remove_effect",
    Params = {id = 4}
  },
  [134] = {
    id = 134,
    Type = "remove_effect",
    Params = {id = 5}
  },
  [135] = {
    id = 135,
    Type = "remove_effect",
    Params = {id = 6}
  },
  [136] = {
    id = 136,
    Type = "set_dir",
    Params = {player = 1, dir = 130}
  },
  [137] = {
    id = 137,
    Type = "play_effect_scene",
    Params = {
      id = 110,
      path = "Skill/Eff_StarFlash_atk",
      pos = {
        -11.15,
        0.63,
        21.01
      },
      ignoreNavMesh = 1,
      onshot = 1,
      dir = {
        0,
        93.55,
        0
      }
    }
  },
  [138] = {
    id = 138,
    Type = "wait_time",
    Params = {time = 200}
  },
  [139] = {
    id = 139,
    Type = "play_effect_scene",
    Params = {
      id = 111,
      path = "Skill/Eff_StarFlash_atk",
      pos = {
        -13.1,
        0.63,
        21.7
      },
      ignoreNavMesh = 1,
      onshot = 1,
      dir = {
        0,
        64.9,
        0
      }
    }
  },
  [140] = {
    id = 140,
    Type = "wait_time",
    Params = {time = 200}
  },
  [141] = {
    id = 141,
    Type = "play_effect_scene",
    Params = {
      id = 112,
      path = "Skill/Eff_StarFlash_atk",
      pos = {
        -12.74,
        0.63,
        21.72
      },
      ignoreNavMesh = 1,
      onshot = 1,
      dir = {
        0,
        25.11,
        0
      }
    }
  },
  [142] = {
    id = 142,
    Type = "wait_time",
    Params = {time = 200}
  },
  [143] = {
    id = 143,
    Type = "play_effect_scene",
    Params = {
      id = 113,
      path = "Skill/Eff_StarFlash_atk",
      pos = {
        -12.89,
        0.63,
        22.14
      },
      ignoreNavMesh = 1,
      onshot = 1,
      dir = {
        0,
        -8.5,
        0
      }
    }
  },
  [144] = {
    id = 144,
    Type = "wait_time",
    Params = {time = 200}
  },
  [145] = {
    id = 145,
    Type = "play_effect_scene",
    Params = {
      id = 114,
      path = "Skill/Eff_StarFlash_atk",
      pos = {
        -12.97,
        0.63,
        21.64
      },
      ignoreNavMesh = 1,
      onshot = 1,
      dir = {
        0,
        -43.12,
        0
      }
    }
  },
  [146] = {
    id = 146,
    Type = "wait_time",
    Params = {time = 200}
  },
  [147] = {
    id = 147,
    Type = "play_effect_scene",
    Params = {
      id = 115,
      path = "Skill/Eff_StarFlash_atk",
      pos = {
        -13.06,
        0.63,
        21.33
      },
      ignoreNavMesh = 1,
      onshot = 1,
      dir = {
        0,
        -64.3,
        0
      }
    }
  },
  [148] = {
    id = 148,
    Type = "wait_time",
    Params = _EmptyTable
  },
  [149] = {
    id = 149,
    Type = "play_effect_scene",
    Params = {
      id = 115,
      path = "Skill/Eff_StarFlash_atk",
      pos = {
        -12.6,
        0.63,
        21.2
      },
      ignoreNavMesh = 1,
      onshot = 1,
      dir = {
        0,
        -93.15,
        0
      }
    }
  },
  [150] = {
    id = 150,
    Type = "wait_time",
    Params = {time = 200}
  },
  [151] = {
    id = 151,
    Type = "play_effect_scene",
    Params = {
      id = 116,
      path = "Skill/Eff_StarFlash_atk",
      pos = {
        -12.94,
        0.63,
        21.47
      },
      ignoreNavMesh = 1,
      onshot = 1,
      dir = {
        0,
        -127.9,
        0
      }
    }
  },
  [152] = {
    id = 152,
    Type = "wait_time",
    Params = {time = 200}
  },
  [153] = {
    id = 153,
    Type = "play_effect_scene",
    Params = {
      id = 117,
      path = "Skill/Eff_StarFlash_atk",
      pos = {
        -12.5,
        0.63,
        20.85
      },
      ignoreNavMesh = 1,
      onshot = 1,
      dir = {
        0,
        -154.25,
        0
      }
    }
  },
  [154] = {
    id = 154,
    Type = "wait_time",
    Params = {time = 200}
  },
  [155] = {
    id = 155,
    Type = "play_effect_scene",
    Params = {
      id = 118,
      path = "Skill/Eff_StarFlash_atk",
      pos = {
        -12.54,
        0.63,
        21.09
      },
      ignoreNavMesh = 1,
      onshot = 1,
      dir = {
        0,
        166.07,
        0
      }
    }
  },
  [156] = {
    id = 156,
    Type = "wait_time",
    Params = {time = 200}
  },
  [157] = {
    id = 157,
    Type = "play_effect_scene",
    Params = {
      id = 119,
      path = "Skill/Eff_StarFlash_atk",
      pos = {
        -11.76,
        0.63,
        20.45
      },
      ignoreNavMesh = 1,
      onshot = 1,
      dir = {
        0,
        137.47,
        0
      }
    }
  },
  [158] = {
    id = 158,
    Type = "wait_time",
    Params = {time = 200}
  },
  [159] = {
    id = 159,
    Type = "play_effect_scene",
    Params = {
      id = 120,
      path = "Skill/Eff_StarFlash_atk",
      pos = {
        -12.16,
        0.63,
        21.27
      },
      ignoreNavMesh = 1,
      onshot = 1,
      dir = {
        0,
        116.66,
        0
      }
    }
  },
  [160] = {
    id = 160,
    Type = "wait_time",
    Params = {time = 1000}
  },
  [161] = {
    id = 161,
    Type = "play_effect",
    Params = {
      id = 122,
      path = "Skill/Knight_buff2",
      player = 1
    }
  },
  [162] = {
    id = 162,
    Type = "dialog",
    Params = {
      dialog = {501759},
      player = 1
    }
  },
  [163] = {
    id = 163,
    Type = "wait_time",
    Params = {time = 1000}
  },
  [164] = {
    id = 164,
    Type = "play_effect_scene",
    Params = {
      id = 9,
      path = "Skill/Eff_GuardianStars_buff",
      pos = {
        -15.1,
        0.69,
        23.91
      }
    }
  },
  [165] = {
    id = 165,
    Type = "play_effect_scene",
    Params = {
      id = 10,
      path = "Skill/Eff_GuardianStars_buff",
      pos = {
        -13.8,
        0.71,
        17.93
      }
    }
  },
  [166] = {
    id = 166,
    Type = "play_effect_scene",
    Params = {
      id = 11,
      path = "Skill/Eff_GuardianStars_buff",
      pos = {
        -9.08,
        0.87,
        22.29
      }
    }
  },
  [167] = {
    id = 167,
    Type = "wait_time",
    Params = {time = 500}
  },
  [168] = {
    id = 168,
    Type = "remove_npc",
    Params = {npcuid = 3391}
  },
  [169] = {
    id = 169,
    Type = "remove_npc",
    Params = {npcuid = 3392}
  },
  [170] = {
    id = 170,
    Type = "remove_npc",
    Params = {npcuid = 3393}
  },
  [171] = {
    id = 171,
    Type = "play_effect",
    Params = {
      id = 12,
      path = "Common/Angel_playshow_F",
      player = 1,
      ignoreNavMesh = 1
    }
  },
  [172] = {
    id = 172,
    Type = "wait_time",
    Params = {time = 2000}
  },
  [173] = {
    id = 173,
    Type = "play_effect",
    Params = {
      id = 13,
      path = "Common/Fireworks_xmas",
      player = 1,
      ep = 0,
      onshot = 1
    }
  },
  [174] = {
    id = 174,
    Type = "wait_time",
    Params = {time = 1000}
  },
  [175] = {
    id = 175,
    Type = "remove_effect_scene",
    Params = {id = 1}
  },
  [176] = {
    id = 176,
    Type = "remove_effect_scene",
    Params = {id = 2}
  },
  [177] = {
    id = 177,
    Type = "remove_effect_scene",
    Params = {id = 3}
  },
  [178] = {
    id = 178,
    Type = "remove_effect_scene",
    Params = {id = 9}
  },
  [179] = {
    id = 179,
    Type = "remove_effect_scene",
    Params = {id = 10}
  },
  [180] = {
    id = 180,
    Type = "remove_effect_scene",
    Params = {id = 11}
  },
  [181] = {
    id = 181,
    Type = "remove_effect_scene",
    Params = {id = 12}
  },
  [182] = {
    id = 182,
    Type = "remove_effect_scene",
    Params = {id = 13}
  },
  [183] = {
    id = 183,
    Type = "remove_effect_scene",
    Params = {id = 14}
  },
  [184] = {
    id = 184,
    Type = "remove_effect_scene",
    Params = {id = 15}
  },
  [185] = {
    id = 185,
    Type = "remove_effect_scene",
    Params = {id = 16}
  },
  [186] = {
    id = 186,
    Type = "showview",
    Params = {panelid = 800, showtype = 2}
  },
  [187] = {
    id = 187,
    Type = "endfilter",
    Params = {
      fliter = {39}
    }
  },
  [188] = {
    id = 188,
    Type = "onoff_camerapoint",
    Params = {
      groupid = 2,
      on = false,
      returnDefaultTime = 1500
    }
  }
}
Table_PlotQuest_76_fields = {
  "id",
  "Type",
  "Params"
}
return Table_PlotQuest_76
