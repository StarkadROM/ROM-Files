Table_AddWay = {
  [1] = {
    id = 1,
    NameEn = "##123669",
    Icon = "",
    Type = 3,
    Materialdisplay = 0,
    Search1 = {
      "Table_Monster",
      "Dead_Reward",
      {
        {
          "Type",
          "staticselect",
          "none",
          {
            "Monster",
            "MINI",
            "MVP"
          }
        }
      }
    },
    Search2 = {
      "Table_Reward",
      "item",
      {
        {
          "team",
          "dynamicselect",
          "none",
          0
        }
      }
    },
    Search3 = _EmptyTable,
    Desc = "%s",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [2] = {
    id = 2,
    NameEn = "##117231",
    Icon = "",
    Type = 5,
    Search1 = _EmptyTable,
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##123995",
    GotoMode = {3052},
    BeginTime = "",
    EndTime = ""
  },
  [3] = {
    id = 3,
    NameEn = "##124142",
    Icon = "",
    Type = 5,
    Search1 = _EmptyTable,
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124148",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [4] = {
    id = 4,
    NameEn = "##1155663",
    Icon = "",
    Type = 3,
    Materialdisplay = 0,
    Search1 = {
      "Table_DeadBoss",
      "Dead_Reward",
      {
        {
          "none",
          "all",
          "none",
          0
        }
      }
    },
    Search2 = {
      "Table_Reward",
      "item",
      {
        {
          "team",
          "dynamicselect",
          "none",
          0
        }
      }
    },
    Search3 = _EmptyTable,
    Desc = "%s",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [5] = {
    id = 5,
    NameEn = "##117302",
    Icon = "Wanted",
    Type = 3,
    Materialdisplay = 0,
    Search1 = {
      "Table_WantedQuest",
      "Reward",
      {
        {
          "none",
          "all",
          "none",
          0
        }
      }
    },
    Search2 = {
      "Table_Reward",
      "item",
      {
        {
          "team",
          "dynamicselect",
          "none",
          0
        }
      }
    },
    Search3 = _EmptyTable,
    Desc = "##123919",
    GotoMode = {
      1,
      901,
      902,
      903,
      904,
      905,
      906,
      907,
      908,
      909,
      910,
      911,
      912,
      913
    },
    menu = 19,
    BeginTime = "",
    EndTime = ""
  },
  [6] = {
    id = 6,
    NameEn = "##113985",
    Icon = "Map",
    Type = 3,
    Materialdisplay = 0,
    Search1 = {
      "Table_RaidSeal",
      "reward",
      {
        {
          "none",
          "all",
          "none",
          0
        }
      }
    },
    Search2 = {
      "Table_Reward",
      "item",
      {
        {
          "team",
          "dynamicselect",
          "none",
          0
        }
      }
    },
    Search3 = _EmptyTable,
    Desc = "##530679",
    GotoMode = {2},
    menu = 33,
    BeginTime = "",
    EndTime = ""
  },
  [7] = {
    id = 7,
    NameEn = "##113983",
    Icon = "Dungeon",
    Type = 3,
    Materialdisplay = 0,
    Search1 = {
      "Table_EndLessTower",
      "Reward",
      {
        {
          "none",
          "all",
          "none",
          0
        }
      }
    },
    Search2 = {
      "Table_Reward",
      "item",
      {
        {
          "team",
          "dynamicselect",
          "none",
          0
        }
      }
    },
    Search3 = _EmptyTable,
    Desc = "##124071",
    GotoMode = {3},
    menu = 26,
    BeginTime = "",
    EndTime = ""
  },
  [8] = {
    id = 8,
    NameEn = "##1235272",
    Icon = "Map",
    Type = 1,
    Materialdisplay = 0,
    Search1 = {
      "Table_Reward",
      "item",
      {
        {
          "team",
          "compare",
          ">",
          4580
        },
        {
          "team",
          "compare",
          "<",
          4585
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235273",
    GotoMode = {
      1,
      901,
      902,
      903,
      904,
      905,
      906,
      907,
      908,
      909,
      910,
      911,
      912,
      913
    },
    menu = 33,
    BeginTime = "",
    EndTime = ""
  },
  [100] = {
    id = 100,
    NameEn = "##123914",
    Icon = "",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Shop",
      "items",
      {
        {
          "type",
          "compare",
          "=",
          750
        },
        {
          "ShopID",
          "compare",
          "=",
          1
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124190",
    GotoMode = {4},
    BeginTime = "",
    EndTime = ""
  },
  [101] = {
    id = 101,
    NameEn = "##124094",
    Icon = "",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Shop",
      "items",
      {
        {
          "type",
          "compare",
          "=",
          750
        },
        {
          "ShopID",
          "compare",
          "=",
          1
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124190",
    GotoMode = {204},
    BeginTime = "",
    EndTime = ""
  },
  [102] = {
    id = 102,
    NameEn = "##124107",
    Icon = "",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Shop",
      "items",
      {
        {
          "type",
          "compare",
          "=",
          750
        },
        {
          "ShopID",
          "compare",
          "=",
          2
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124009",
    GotoMode = {21},
    BeginTime = "",
    EndTime = ""
  },
  [103] = {
    id = 103,
    NameEn = "##124120",
    Icon = "",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Shop",
      "items",
      {
        {
          "type",
          "compare",
          "=",
          750
        },
        {
          "ShopID",
          "compare",
          "=",
          3
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124211",
    GotoMode = {205},
    BeginTime = "",
    EndTime = ""
  },
  [104] = {
    id = 104,
    NameEn = "##124040",
    Icon = "",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Shop",
      "items",
      {
        {
          "type",
          "compare",
          "=",
          750
        },
        {
          "ShopID",
          "compare",
          "=",
          4
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124036",
    GotoMode = {206},
    BeginTime = "",
    EndTime = ""
  },
  [105] = {
    id = 105,
    NameEn = "##124025",
    Icon = "",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Shop",
      "items",
      {
        {
          "type",
          "compare",
          "=",
          750
        },
        {
          "ShopID",
          "compare",
          "=",
          5
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124067",
    GotoMode = {208},
    BeginTime = "",
    EndTime = ""
  },
  [106] = {
    id = 106,
    NameEn = "##123922",
    Icon = "",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Shop",
      "items",
      {
        {
          "type",
          "compare",
          "=",
          750
        },
        {
          "ShopID",
          "compare",
          "=",
          5
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124208",
    GotoMode = {210},
    BeginTime = "",
    EndTime = ""
  },
  [107] = {
    id = 107,
    NameEn = "##124077",
    Icon = "",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Shop",
      "items",
      {
        {
          "type",
          "compare",
          "=",
          750
        },
        {
          "ShopID",
          "compare",
          "=",
          7
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##123978",
    GotoMode = {214},
    BeginTime = "",
    EndTime = ""
  },
  [108] = {
    id = 108,
    NameEn = "##124102",
    Icon = "",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Shop",
      "items",
      {
        {
          "type",
          "compare",
          "=",
          750
        },
        {
          "ShopID",
          "compare",
          "=",
          8
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124049",
    GotoMode = {216},
    BeginTime = "",
    EndTime = ""
  },
  [109] = {
    id = 109,
    NameEn = "##123957",
    Icon = "",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Shop",
      "items",
      {
        {
          "type",
          "compare",
          "=",
          750
        },
        {
          "ShopID",
          "compare",
          "=",
          9
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##123928",
    GotoMode = {220},
    BeginTime = "",
    EndTime = ""
  },
  [110] = {
    id = 110,
    NameEn = "##124218",
    Icon = "",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Shop",
      "items",
      {
        {
          "type",
          "compare",
          "=",
          750
        },
        {
          "ShopID",
          "compare",
          "=",
          10
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124129",
    GotoMode = {223},
    BeginTime = "",
    EndTime = ""
  },
  [111] = {
    id = 111,
    NameEn = "##530676",
    Icon = "",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Shop",
      "items",
      {
        {
          "type",
          "compare",
          "=",
          750
        },
        {
          "ShopID",
          "compare",
          "=",
          11
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##530673",
    GotoMode = {225},
    BeginTime = "",
    EndTime = ""
  },
  [200] = {
    id = 200,
    NameEn = "##124016",
    Icon = "",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Shop",
      "items",
      {
        {
          "type",
          "compare",
          "=",
          700
        },
        {
          "ShopID",
          "compare",
          "=",
          1
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124209",
    GotoMode = {5},
    BeginTime = "",
    EndTime = ""
  },
  [201] = {
    id = 201,
    NameEn = "##124060",
    Icon = "",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Shop",
      "items",
      {
        {
          "type",
          "compare",
          "=",
          700
        },
        {
          "ShopID",
          "compare",
          "=",
          1
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124209",
    GotoMode = {201},
    BeginTime = "",
    EndTime = ""
  },
  [202] = {
    id = 202,
    NameEn = "##124134",
    Icon = "",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Shop",
      "items",
      {
        {
          "type",
          "compare",
          "=",
          700
        },
        {
          "ShopID",
          "compare",
          "=",
          2
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124031",
    GotoMode = {22},
    BeginTime = "",
    EndTime = ""
  },
  [203] = {
    id = 203,
    NameEn = "##123929",
    Icon = "",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Shop",
      "items",
      {
        {
          "type",
          "compare",
          "=",
          700
        },
        {
          "ShopID",
          "compare",
          "=",
          3
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124106",
    GotoMode = {202},
    BeginTime = "",
    EndTime = ""
  },
  [204] = {
    id = 204,
    NameEn = "##124174",
    Icon = "",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Shop",
      "items",
      {
        {
          "type",
          "compare",
          "=",
          700
        },
        {
          "ShopID",
          "compare",
          "=",
          4
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124023",
    GotoMode = {203},
    BeginTime = "",
    EndTime = ""
  },
  [205] = {
    id = 205,
    NameEn = "##124147",
    Icon = "",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Shop",
      "items",
      {
        {
          "type",
          "compare",
          "=",
          700
        },
        {
          "ShopID",
          "compare",
          "=",
          5
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124081",
    GotoMode = {207},
    BeginTime = "",
    EndTime = ""
  },
  [206] = {
    id = 206,
    NameEn = "##124183",
    Icon = "",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Shop",
      "items",
      {
        {
          "type",
          "compare",
          "=",
          700
        },
        {
          "ShopID",
          "compare",
          "=",
          6
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124219",
    GotoMode = {209},
    BeginTime = "",
    EndTime = ""
  },
  [207] = {
    id = 207,
    NameEn = "##124052",
    Icon = "",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Shop",
      "items",
      {
        {
          "type",
          "compare",
          "=",
          700
        },
        {
          "ShopID",
          "compare",
          "=",
          8
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124135",
    GotoMode = {213},
    BeginTime = "",
    EndTime = ""
  },
  [208] = {
    id = 208,
    NameEn = "##124206",
    Icon = "",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Shop",
      "items",
      {
        {
          "type",
          "compare",
          "=",
          700
        },
        {
          "ShopID",
          "compare",
          "=",
          9
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124028",
    GotoMode = {215},
    BeginTime = "",
    EndTime = ""
  },
  [209] = {
    id = 209,
    NameEn = "##123996",
    Icon = "",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Shop",
      "items",
      {
        {
          "type",
          "compare",
          "=",
          700
        },
        {
          "ShopID",
          "compare",
          "=",
          10
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124175",
    GotoMode = {217},
    BeginTime = "",
    EndTime = ""
  },
  [210] = {
    id = 210,
    NameEn = "##123990",
    Icon = "",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Shop",
      "items",
      {
        {
          "type",
          "compare",
          "=",
          700
        },
        {
          "ShopID",
          "compare",
          "=",
          11
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124115",
    GotoMode = {219},
    BeginTime = "",
    EndTime = ""
  },
  [211] = {
    id = 211,
    NameEn = "##124029",
    Icon = "",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Shop",
      "items",
      {
        {
          "type",
          "compare",
          "=",
          700
        },
        {
          "ShopID",
          "compare",
          "=",
          12
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124014",
    GotoMode = {221},
    BeginTime = "",
    EndTime = ""
  },
  [212] = {
    id = 212,
    NameEn = "##124176",
    Icon = "",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Shop",
      "items",
      {
        {
          "type",
          "compare",
          "=",
          700
        },
        {
          "ShopID",
          "compare",
          "=",
          13
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124140",
    GotoMode = {222},
    BeginTime = "",
    EndTime = ""
  },
  [213] = {
    id = 213,
    NameEn = "##530670",
    Icon = "",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Shop",
      "items",
      {
        {
          "type",
          "compare",
          "=",
          700
        },
        {
          "ShopID",
          "compare",
          "=",
          14
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##530678",
    GotoMode = {224},
    BeginTime = "",
    EndTime = ""
  },
  [300] = {
    id = 300,
    NameEn = "##124010",
    Icon = "",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Shop",
      "items",
      {
        {
          "type",
          "compare",
          "=",
          800
        },
        {
          "ShopID",
          "compare",
          "=",
          11
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124127",
    GotoMode = {6},
    BeginTime = "",
    EndTime = ""
  },
  [301] = {
    id = 301,
    NameEn = "##124069",
    Icon = "",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Shop",
      "items",
      {
        {
          "type",
          "compare",
          "=",
          800
        },
        {
          "ShopID",
          "compare",
          "=",
          21
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124127",
    GotoMode = {16},
    BeginTime = "",
    EndTime = ""
  },
  [302] = {
    id = 302,
    NameEn = "##124027",
    Icon = "",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Shop",
      "items",
      {
        {
          "type",
          "compare",
          "=",
          800
        },
        {
          "ShopID",
          "compare",
          "=",
          31
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124127",
    GotoMode = {17},
    BeginTime = "",
    EndTime = ""
  },
  [303] = {
    id = 303,
    NameEn = "##123894",
    Icon = "",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Shop",
      "items",
      {
        {
          "type",
          "compare",
          "=",
          800
        },
        {
          "ShopID",
          "compare",
          "=",
          41
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124127",
    GotoMode = {23},
    BeginTime = "",
    EndTime = ""
  },
  [304] = {
    id = 304,
    NameEn = "##124210",
    Icon = "",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Shop",
      "items",
      {
        {
          "type",
          "compare",
          "=",
          800
        },
        {
          "ShopID",
          "compare",
          "=",
          12
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124127",
    GotoMode = {33},
    BeginTime = "",
    EndTime = ""
  },
  [305] = {
    id = 305,
    NameEn = "##123923",
    Icon = "",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Shop",
      "items",
      {
        {
          "type",
          "compare",
          "=",
          800
        },
        {
          "ShopID",
          "compare",
          "=",
          51
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124127",
    GotoMode = {301},
    BeginTime = "",
    EndTime = ""
  },
  [306] = {
    id = 306,
    NameEn = "##123940",
    Icon = "",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Shop",
      "items",
      {
        {
          "type",
          "compare",
          "=",
          800
        },
        {
          "ShopID",
          "compare",
          "=",
          61
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124127",
    GotoMode = {302},
    BeginTime = "",
    EndTime = ""
  },
  [307] = {
    id = 307,
    NameEn = "##124179",
    Icon = "",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Shop",
      "items",
      {
        {
          "type",
          "compare",
          "=",
          800
        },
        {
          "ShopID",
          "compare",
          "=",
          81
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124127",
    GotoMode = {304},
    BeginTime = "",
    EndTime = ""
  },
  [308] = {
    id = 308,
    NameEn = "##124037",
    Icon = "",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Shop",
      "items",
      {
        {
          "type",
          "compare",
          "=",
          800
        },
        {
          "ShopID",
          "compare",
          "=",
          91
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124127",
    GotoMode = {305},
    BeginTime = "",
    EndTime = ""
  },
  [309] = {
    id = 309,
    NameEn = "##776901",
    Icon = "",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Shop",
      "items",
      {
        {
          "type",
          "compare",
          "=",
          800
        },
        {
          "ShopID",
          "compare",
          "=",
          11
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124127",
    GotoMode = {306},
    BeginTime = "",
    EndTime = ""
  },
  [350] = {
    id = 350,
    NameEn = "##123956",
    Icon = "",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Shop",
      "items",
      {
        {
          "type",
          "compare",
          "=",
          925
        },
        {
          "ShopID",
          "compare",
          "=",
          1
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##123988",
    GotoMode = {403},
    BeginTime = "",
    EndTime = ""
  },
  [351] = {
    id = 351,
    NameEn = "##123915",
    Icon = "",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Shop",
      "items",
      {
        {
          "type",
          "compare",
          "=",
          912
        },
        {
          "ShopID",
          "compare",
          "=",
          1
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124224",
    GotoMode = {402},
    BeginTime = "",
    EndTime = ""
  },
  [352] = {
    id = 352,
    NameEn = "##118192",
    Icon = "",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Shop",
      "items",
      {
        {
          "type",
          "compare",
          "=",
          904
        },
        {
          "ShopID",
          "compare",
          "=",
          1
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##123953",
    GotoMode = {401},
    BeginTime = "",
    EndTime = ""
  },
  [353] = {
    id = 353,
    NameEn = "##124101",
    Icon = "",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Shop",
      "items",
      {
        {
          "type",
          "compare",
          "=",
          972
        },
        {
          "ShopID",
          "compare",
          "=",
          1
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124105",
    GotoMode = {404},
    BeginTime = "",
    EndTime = ""
  },
  [400] = {
    id = 400,
    NameEn = "##123999",
    Icon = "",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Shop",
      "items",
      {
        {
          "type",
          "compare",
          "=",
          600
        },
        {
          "ShopID",
          "compare",
          "=",
          1
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124193",
    GotoMode = {7},
    BeginTime = "",
    EndTime = ""
  },
  [401] = {
    id = 401,
    NameEn = "##124088",
    Icon = "",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Shop",
      "items",
      {
        {
          "type",
          "compare",
          "=",
          600
        },
        {
          "ShopID",
          "compare",
          "=",
          1
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124193",
    GotoMode = {28},
    BeginTime = "",
    EndTime = ""
  },
  [402] = {
    id = 402,
    NameEn = "##123963",
    Icon = "",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Shop",
      "items",
      {
        {
          "type",
          "compare",
          "=",
          600
        },
        {
          "ShopID",
          "compare",
          "=",
          2
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124193",
    GotoMode = {29},
    BeginTime = "",
    EndTime = ""
  },
  [403] = {
    id = 403,
    NameEn = "##124114",
    Icon = "",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Shop",
      "items",
      {
        {
          "type",
          "compare",
          "=",
          600
        },
        {
          "ShopID",
          "compare",
          "=",
          3
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124193",
    GotoMode = {30},
    BeginTime = "",
    EndTime = ""
  },
  [404] = {
    id = 404,
    NameEn = "##124096",
    Icon = "",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Shop",
      "items",
      {
        {
          "type",
          "compare",
          "=",
          600
        },
        {
          "ShopID",
          "compare",
          "=",
          4
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124193",
    GotoMode = {31},
    BeginTime = "",
    EndTime = ""
  },
  [405] = {
    id = 405,
    NameEn = "##124002",
    Icon = "",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Shop",
      "items",
      {
        {
          "type",
          "compare",
          "=",
          600
        },
        {
          "ShopID",
          "compare",
          "=",
          4
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124193",
    GotoMode = {79},
    BeginTime = "",
    EndTime = ""
  },
  [406] = {
    id = 406,
    NameEn = "##123927",
    Icon = "",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Shop",
      "items",
      {
        {
          "type",
          "compare",
          "=",
          600
        },
        {
          "ShopID",
          "compare",
          "=",
          5
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124193",
    GotoMode = {78},
    BeginTime = "",
    EndTime = ""
  },
  [421] = {
    id = 421,
    NameEn = "##124053",
    Icon = "",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Shop",
      "items",
      {
        {
          "type",
          "compare",
          "=",
          600
        },
        {
          "ShopID",
          "compare",
          "=",
          11
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124150",
    GotoMode = {
      25,
      921,
      922,
      923,
      924,
      925,
      926,
      927,
      928,
      930,
      931,
      932,
      933
    },
    BeginTime = "",
    EndTime = ""
  },
  [422] = {
    id = 422,
    NameEn = "##304574",
    Icon = "",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Shop",
      "items",
      {
        {
          "type",
          "compare",
          "=",
          850
        },
        {
          "ShopID",
          "compare",
          "=",
          1
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124083",
    GotoMode = {62},
    BeginTime = "",
    EndTime = ""
  },
  [423] = {
    id = 423,
    NameEn = "##530672",
    Icon = "",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Shop",
      "items",
      {
        {
          "type",
          "compare",
          "=",
          3304
        },
        {
          "ShopID",
          "compare",
          "=",
          1
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##530681",
    GotoMode = {99},
    BeginTime = "",
    EndTime = ""
  },
  [499] = {
    id = 499,
    NameEn = "##117340",
    Icon = "",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Shop",
      "items",
      {
        {
          "type",
          "compare",
          "=",
          600
        },
        {
          "ShopID",
          "compare",
          "=",
          10
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124046",
    GotoMode = {26},
    BeginTime = "",
    EndTime = ""
  },
  [500] = {
    id = 500,
    NameEn = "##124225",
    Icon = "",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Shop",
      "items",
      {
        {
          "type",
          "compare",
          "=",
          600
        },
        {
          "ShopID",
          "compare",
          "=",
          1
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124193",
    GotoMode = {101},
    BeginTime = "",
    EndTime = ""
  },
  [501] = {
    id = 501,
    NameEn = "##124216",
    Icon = "",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Shop",
      "items",
      {
        {
          "type",
          "compare",
          "=",
          600
        },
        {
          "ShopID",
          "compare",
          "=",
          1
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124193",
    GotoMode = {102},
    BeginTime = "",
    EndTime = ""
  },
  [502] = {
    id = 502,
    NameEn = "##124197",
    Icon = "",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Shop",
      "items",
      {
        {
          "type",
          "compare",
          "=",
          600
        },
        {
          "ShopID",
          "compare",
          "=",
          1
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124193",
    GotoMode = {103},
    BeginTime = "",
    EndTime = ""
  },
  [503] = {
    id = 503,
    NameEn = "##124118",
    Icon = "",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Shop",
      "items",
      {
        {
          "type",
          "compare",
          "=",
          600
        },
        {
          "ShopID",
          "compare",
          "=",
          1
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124193",
    GotoMode = {104},
    BeginTime = "",
    EndTime = ""
  },
  [600] = {
    id = 600,
    NameEn = "##123968",
    Icon = "",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Shop",
      "items",
      {
        {
          "type",
          "compare",
          "=",
          610
        },
        {
          "ShopID",
          "compare",
          "=",
          1
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124152",
    GotoMode = {
      8,
      32,
      14,
      15,
      24,
      79,
      77,
      91,
      50,
      51,
      52,
      53,
      54,
      55,
      56,
      57,
      58
    },
    BeginTime = "",
    EndTime = ""
  },
  [699] = {
    id = 699,
    NameEn = "##123979",
    Icon = "Shopping",
    Type = 4,
    Materialdisplay = 1,
    Search1 = {
      "Table_Compose",
      "Product",
      {
        {
          "id",
          "compare",
          ">",
          0
        },
        {
          "NpcId",
          "compare",
          "=",
          800043
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##123979",
    GotoMode = {699},
    BeginTime = "",
    EndTime = ""
  },
  [700] = {
    id = 700,
    NameEn = "##123908",
    Icon = "Shopping",
    Type = 4,
    Materialdisplay = 1,
    Search1 = {
      "Table_Compose",
      "Product",
      {
        {
          "id",
          "compare",
          ">",
          0
        },
        {
          "NpcId",
          "compare",
          "=",
          4968
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##123908",
    GotoMode = {700},
    BeginTime = "",
    EndTime = ""
  },
  [701] = {
    id = 701,
    NameEn = "##124171",
    Icon = "Shopping",
    Type = 4,
    Materialdisplay = 1,
    Search1 = {
      "Table_Compose",
      "Product",
      {
        {
          "id",
          "compare",
          ">",
          0
        },
        {
          "NpcId",
          "compare",
          "=",
          2620
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124171",
    GotoMode = {701},
    BeginTime = "",
    EndTime = ""
  },
  [702] = {
    id = 702,
    NameEn = "##123994",
    Icon = "Shopping",
    Type = 4,
    Materialdisplay = 1,
    Search1 = {
      "Table_Compose",
      "Product",
      {
        {
          "id",
          "compare",
          ">",
          0
        },
        {
          "NpcId",
          "compare",
          "=",
          2621
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##123994",
    GotoMode = {702},
    BeginTime = "",
    EndTime = ""
  },
  [703] = {
    id = 703,
    NameEn = "##123962",
    Icon = "Shopping",
    Type = 4,
    Materialdisplay = 1,
    Search1 = {
      "Table_Compose",
      "Product",
      {
        {
          "id",
          "compare",
          ">",
          0
        },
        {
          "NpcId",
          "compare",
          "=",
          2622
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##123962",
    GotoMode = {703},
    BeginTime = "",
    EndTime = ""
  },
  [704] = {
    id = 704,
    NameEn = "##124057",
    Icon = "Shopping",
    Type = 4,
    Materialdisplay = 1,
    Search1 = {
      "Table_Compose",
      "Product",
      {
        {
          "id",
          "compare",
          ">",
          0
        },
        {
          "NpcId",
          "compare",
          "=",
          2623
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124057",
    GotoMode = {704},
    BeginTime = "",
    EndTime = ""
  },
  [705] = {
    id = 705,
    NameEn = "##123984",
    Icon = "Shopping",
    Type = 4,
    Materialdisplay = 1,
    Search1 = {
      "Table_Compose",
      "Product",
      {
        {
          "id",
          "compare",
          ">",
          0
        },
        {
          "NpcId",
          "compare",
          "=",
          2624
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##123984",
    GotoMode = {705},
    BeginTime = "",
    EndTime = ""
  },
  [706] = {
    id = 706,
    NameEn = "##124042",
    Icon = "Shopping",
    Type = 4,
    Materialdisplay = 1,
    Search1 = {
      "Table_Compose",
      "Product",
      {
        {
          "id",
          "compare",
          ">",
          0
        },
        {
          "NpcId",
          "compare",
          "=",
          2649
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124042",
    GotoMode = {706},
    BeginTime = "",
    EndTime = ""
  },
  [707] = {
    id = 707,
    NameEn = "##124091",
    Icon = "Shopping",
    Type = 4,
    Materialdisplay = 1,
    Search1 = {
      "Table_Compose",
      "Product",
      {
        {
          "id",
          "compare",
          ">",
          0
        },
        {
          "NpcId",
          "compare",
          "=",
          4537
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124091",
    GotoMode = {707},
    BeginTime = "",
    EndTime = ""
  },
  [708] = {
    id = 708,
    NameEn = "##123980",
    Icon = "Shopping",
    Type = 4,
    Materialdisplay = 1,
    Search1 = {
      "Table_Compose",
      "Product",
      {
        {
          "id",
          "compare",
          ">",
          0
        },
        {
          "NpcId",
          "compare",
          "=",
          4618
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##123980",
    GotoMode = {708},
    BeginTime = "",
    EndTime = ""
  },
  [709] = {
    id = 709,
    NameEn = "##124021",
    Icon = "Shopping",
    Type = 4,
    Materialdisplay = 1,
    Search1 = {
      "Table_Compose",
      "Product",
      {
        {
          "id",
          "compare",
          ">",
          0
        },
        {
          "NpcId",
          "compare",
          "=",
          6955
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124021",
    GotoMode = {709},
    BeginTime = "",
    EndTime = ""
  },
  [710] = {
    id = 710,
    NameEn = "##124095",
    Icon = "Shopping",
    Type = 4,
    Materialdisplay = 1,
    Search1 = {
      "Table_Compose",
      "Product",
      {
        {
          "id",
          "compare",
          ">",
          0
        },
        {
          "NpcId",
          "compare",
          "=",
          5971
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124095",
    GotoMode = {710},
    BeginTime = "",
    EndTime = ""
  },
  [711] = {
    id = 711,
    NameEn = "##124001",
    Icon = "Shopping",
    Type = 4,
    Materialdisplay = 0,
    Search1 = {
      "Table_Compose",
      "Product",
      {
        {
          "id",
          "compare",
          ">",
          0
        },
        {
          "NpcId",
          "compare",
          "=",
          2618
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124001",
    GotoMode = {711},
    BeginTime = "",
    EndTime = ""
  },
  [712] = {
    id = 712,
    NameEn = "##124188",
    Icon = "Shopping",
    Type = 4,
    Materialdisplay = 0,
    Search1 = {
      "Table_Compose",
      "Product",
      {
        {
          "id",
          "compare",
          ">",
          0
        },
        {
          "NpcId",
          "compare",
          "=",
          2626
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124188",
    GotoMode = {712},
    BeginTime = "",
    EndTime = ""
  },
  [713] = {
    id = 713,
    NameEn = "##123975",
    Icon = "Shopping",
    Type = 4,
    Materialdisplay = 0,
    Search1 = {
      "Table_Compose",
      "Product",
      {
        {
          "id",
          "compare",
          ">",
          0
        },
        {
          "NpcId",
          "compare",
          "=",
          2617
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##123975",
    GotoMode = {713},
    BeginTime = "",
    EndTime = ""
  },
  [714] = {
    id = 714,
    NameEn = "##124226",
    Icon = "Shopping",
    Type = 4,
    Materialdisplay = 0,
    Search1 = {
      "Table_Compose",
      "Product",
      {
        {
          "id",
          "compare",
          ">",
          0
        },
        {
          "NpcId",
          "compare",
          "=",
          2625
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124226",
    GotoMode = {714},
    BeginTime = "",
    EndTime = ""
  },
  [715] = {
    id = 715,
    NameEn = "##123946",
    Icon = "Shopping",
    Type = 4,
    Materialdisplay = 0,
    Search1 = {
      "Table_Compose",
      "Product",
      {
        {
          "id",
          "compare",
          ">",
          0
        },
        {
          "NpcId",
          "compare",
          "=",
          4535
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##123946",
    GotoMode = {715},
    BeginTime = "",
    EndTime = ""
  },
  [716] = {
    id = 716,
    NameEn = "##124103",
    Icon = "Shopping",
    Type = 4,
    Materialdisplay = 0,
    Search1 = {
      "Table_Compose",
      "Product",
      {
        {
          "id",
          "compare",
          ">",
          0
        },
        {
          "NpcId",
          "compare",
          "=",
          4536
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124103",
    GotoMode = {716},
    BeginTime = "",
    EndTime = ""
  },
  [717] = {
    id = 717,
    NameEn = "##123926",
    Icon = "Shopping",
    Type = 4,
    Materialdisplay = 0,
    Search1 = {
      "Table_Compose",
      "Product",
      {
        {
          "id",
          "compare",
          ">",
          0
        },
        {
          "NpcId",
          "compare",
          "=",
          4616
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##123926",
    GotoMode = {717},
    BeginTime = "",
    EndTime = ""
  },
  [718] = {
    id = 718,
    NameEn = "##123977",
    Icon = "Shopping",
    Type = 4,
    Materialdisplay = 0,
    Search1 = {
      "Table_Compose",
      "Product",
      {
        {
          "id",
          "compare",
          ">",
          0
        },
        {
          "NpcId",
          "compare",
          "=",
          4617
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##123977",
    GotoMode = {718},
    BeginTime = "",
    EndTime = ""
  },
  [719] = {
    id = 719,
    NameEn = "##124018",
    Icon = "",
    Materialdisplay = 0,
    Search1 = {
      "Table_Compose",
      "Product",
      {
        {
          "id",
          "compare",
          ">",
          0
        },
        {
          "NpcId",
          "compare",
          "=",
          6953
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124018",
    GotoMode = {719},
    BeginTime = "",
    EndTime = ""
  },
  [720] = {
    id = 720,
    NameEn = "##124189",
    Icon = "",
    Materialdisplay = 0,
    Search1 = {
      "Table_Compose",
      "Product",
      {
        {
          "id",
          "compare",
          ">",
          0
        },
        {
          "NpcId",
          "compare",
          "=",
          6954
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124189",
    GotoMode = {720},
    BeginTime = "",
    EndTime = ""
  },
  [725] = {
    id = 725,
    NameEn = "##124048",
    Icon = "Shopping",
    Type = 4,
    Materialdisplay = 0,
    Search1 = {
      "Table_Compose",
      "Product",
      {
        {
          "id",
          "compare",
          ">",
          0
        },
        {
          "NpcId",
          "compare",
          "=",
          800046
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124048",
    GotoMode = {725},
    BeginTime = "",
    EndTime = ""
  },
  [726] = {
    id = 726,
    NameEn = "##123942",
    Icon = "Shopping",
    Type = 4,
    Materialdisplay = 0,
    Search1 = {
      "Table_Compose",
      "Product",
      {
        {
          "id",
          "compare",
          ">",
          0
        },
        {
          "NpcId",
          "compare",
          "=",
          800047
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##123942",
    GotoMode = {726},
    BeginTime = "",
    EndTime = ""
  },
  [727] = {
    id = 727,
    NameEn = "##124030",
    Icon = "Shopping",
    Type = 4,
    Materialdisplay = 1,
    Search1 = {
      "Table_Compose",
      "Product",
      {
        {
          "id",
          "compare",
          ">",
          0
        },
        {
          "NpcId",
          "compare",
          "=",
          801615
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124030",
    GotoMode = {727},
    BeginTime = "",
    EndTime = ""
  },
  [728] = {
    id = 728,
    NameEn = "##124074",
    Icon = "Shopping",
    Type = 4,
    Materialdisplay = 1,
    Search1 = {
      "Table_Compose",
      "Product",
      {
        {
          "id",
          "compare",
          ">",
          0
        },
        {
          "NpcId",
          "compare",
          "=",
          806880
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124074",
    GotoMode = {728},
    BeginTime = "",
    EndTime = ""
  },
  [729] = {
    id = 729,
    NameEn = "##124139",
    Icon = "Shopping",
    Type = 4,
    Materialdisplay = 1,
    Search1 = {
      "Table_Compose",
      "Product",
      {
        {
          "id",
          "compare",
          ">",
          0
        },
        {
          "NpcId",
          "compare",
          "=",
          809009
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124139",
    GotoMode = {729},
    BeginTime = "",
    EndTime = ""
  },
  [730] = {
    id = 730,
    NameEn = "##530675",
    Icon = "Shopping",
    Type = 4,
    Materialdisplay = 1,
    Search1 = {
      "Table_Compose",
      "Product",
      {
        {
          "id",
          "compare",
          ">",
          0
        },
        {
          "NpcId",
          "compare",
          "=",
          805178
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##530680",
    GotoMode = {731},
    BeginTime = "",
    EndTime = ""
  },
  [731] = {
    id = 731,
    NameEn = "##1134480",
    Icon = "Shopping",
    Type = 4,
    Materialdisplay = 1,
    Search1 = {
      "Table_Compose",
      "Product",
      {
        {
          "id",
          "compare",
          ">",
          0
        },
        {
          "NpcId",
          "compare",
          "=",
          821510
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1134480",
    GotoMode = {732},
    BeginTime = "",
    EndTime = ""
  },
  [780] = {
    id = 780,
    NameEn = "##124131",
    Icon = "",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_EquipCompose",
      "ID",
      {
        {
          "Cost",
          "compare",
          "=",
          1000000
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124041",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [795] = {
    id = 795,
    NameEn = "##119329",
    Icon = "",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          172
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124151",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [796] = {
    id = 796,
    NameEn = "##124075",
    Icon = "",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Shop",
      "items",
      {
        {
          "type",
          "compare",
          "=",
          979
        },
        {
          "ShopID",
          "compare",
          "=",
          1
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124151",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [797] = {
    id = 797,
    NameEn = "##124104",
    Icon = "",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Pet",
      "EggID",
      {
        {
          "accessway",
          "compare",
          "=",
          5
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124151",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [798] = {
    id = 798,
    NameEn = "##124097",
    Icon = "",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Pet",
      "EggID",
      {
        {
          "accessway",
          "compare",
          "=",
          3
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124097",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [799] = {
    id = 799,
    NameEn = "##123972",
    Icon = "",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Pet",
      "EggID",
      {
        {
          "accessway",
          "compare",
          "=",
          4
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##123972",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [800] = {
    id = 800,
    NameEn = "##124161",
    Icon = "",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Pet",
      "EggID",
      {
        {
          "accessway",
          "compare",
          "=",
          1
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124161",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [801] = {
    id = 801,
    NameEn = "##124199",
    Icon = "Dungeon",
    Type = 1,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          ">",
          900000
        },
        {
          "id",
          "compare",
          "<",
          900012
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124166",
    GotoMode = {5031},
    BeginTime = "",
    EndTime = ""
  },
  [802] = {
    id = 802,
    NameEn = "##124199",
    Icon = "Dungeon",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          5503
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124166",
    GotoMode = {5031},
    BeginTime = "",
    EndTime = ""
  },
  [803] = {
    id = 803,
    NameEn = "##124199",
    Icon = "Dungeon",
    Type = 1,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          ">",
          900016
        },
        {
          "id",
          "compare",
          "<",
          900033
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124166",
    GotoMode = {5031},
    BeginTime = "",
    EndTime = ""
  },
  [804] = {
    id = 804,
    NameEn = "##124026",
    Icon = "",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          12571
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124026",
    GotoMode = {1004},
    BeginTime = "",
    EndTime = ""
  },
  [805] = {
    id = 805,
    NameEn = "##124026",
    Icon = "",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          12572
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124026",
    GotoMode = {1004},
    BeginTime = "",
    EndTime = ""
  },
  [806] = {
    id = 806,
    NameEn = "##124199",
    Icon = "Dungeon",
    Type = 1,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          ">",
          900033
        },
        {
          "id",
          "compare",
          "<",
          900036
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124166",
    GotoMode = {5031},
    BeginTime = "",
    EndTime = ""
  },
  [807] = {
    id = 807,
    NameEn = "##124199",
    Icon = "Dungeon",
    Type = 1,
    Materialdisplay = 1,
    Search1 = {
      "Table_Reward",
      "item",
      {
        {
          "team",
          "compare",
          ">",
          19999999
        },
        {
          "team",
          "compare",
          "<",
          20000029
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124006",
    GotoMode = {5031},
    BeginTime = "",
    EndTime = ""
  },
  [808] = {
    id = 808,
    NameEn = "##124123",
    Icon = "",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Reward",
      "item",
      {
        {
          "team",
          "compare",
          "=",
          20000030
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124026",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [809] = {
    id = 809,
    NameEn = "##124186",
    Icon = "",
    Type = 1,
    Materialdisplay = 1,
    Search1 = {
      "Table_Reward",
      "item",
      {
        {
          "team",
          "compare",
          ">",
          20000030
        },
        {
          "team",
          "compare",
          "<",
          20000033
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124185",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [810] = {
    id = 810,
    NameEn = "##124145",
    Icon = "bigcat_icon_03",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Reward",
      "item",
      {
        {
          "team",
          "compare",
          "=",
          20000034
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124196",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [811] = {
    id = 811,
    NameEn = "##124132",
    Icon = "",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Pet",
      "EggID",
      {
        {
          "accessway",
          "compare",
          "=",
          6
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124132",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [813] = {
    id = 813,
    NameEn = "##113986",
    Icon = "",
    Type = 1,
    Materialdisplay = 1,
    Search1 = {
      "Table_Reward",
      "item",
      {
        {
          "team",
          "compare",
          ">",
          69999
        },
        {
          "team",
          "compare",
          "<",
          70200
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124169",
    GotoMode = {7012},
    BeginTime = "",
    EndTime = ""
  },
  [814] = {
    id = 814,
    NameEn = "##124136",
    Icon = "",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Shop",
      "items",
      {
        {
          "type",
          "compare",
          "=",
          3248
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124136",
    GotoMode = {94},
    BeginTime = "",
    EndTime = ""
  },
  [815] = {
    id = 815,
    NameEn = "##124043",
    Icon = "",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Shop",
      "items",
      {
        {
          "type",
          "compare",
          "=",
          3244
        },
        {
          "ShopID",
          "compare",
          "=",
          1
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124038",
    GotoMode = {1601},
    BeginTime = "",
    EndTime = ""
  },
  [816] = {
    id = 816,
    NameEn = "##124180",
    Icon = "",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Shop",
      "items",
      {
        {
          "type",
          "compare",
          "=",
          3256
        },
        {
          "ShopID",
          "compare",
          "=",
          1
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124054",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [817] = {
    id = 817,
    NameEn = "##124104",
    Icon = "",
    Type = 1,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          ">",
          499
        },
        {
          "id",
          "compare",
          "<",
          525
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124151",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [818] = {
    id = 818,
    NameEn = "##123955",
    Icon = "",
    Type = 1,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          5838
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124019",
    GotoMode = {95},
    BeginTime = "",
    EndTime = ""
  },
  [819] = {
    id = 819,
    NameEn = "##123895",
    Icon = "Dungeon",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          5924
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124084",
    GotoMode = {98},
    BeginTime = "",
    EndTime = ""
  },
  [820] = {
    id = 820,
    NameEn = "##123895",
    Icon = "Dungeon",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          3000080
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124084",
    GotoMode = {98},
    BeginTime = "",
    EndTime = ""
  },
  [821] = {
    id = 821,
    NameEn = "##123895",
    Icon = "Dungeon",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          3000090
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124084",
    GotoMode = {98},
    BeginTime = "",
    EndTime = ""
  },
  [822] = {
    id = 822,
    NameEn = "##123895",
    Icon = "Dungeon",
    Type = 1,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          ">",
          25143
        },
        {
          "id",
          "compare",
          "<",
          25146
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124084",
    GotoMode = {98},
    BeginTime = "",
    EndTime = ""
  },
  [823] = {
    id = 823,
    NameEn = "##123895",
    Icon = "Dungeon",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          3000124
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124084",
    GotoMode = {98},
    BeginTime = "",
    EndTime = ""
  },
  [824] = {
    id = 824,
    NameEn = "##123895",
    Icon = "Dungeon",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          3000126
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124084",
    GotoMode = {98},
    BeginTime = "",
    EndTime = ""
  },
  [825] = {
    id = 825,
    NameEn = "##123895",
    Icon = "Dungeon",
    Type = 1,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          ">",
          47130
        },
        {
          "id",
          "compare",
          "<",
          47133
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124084",
    GotoMode = {98},
    BeginTime = "",
    EndTime = ""
  },
  [826] = {
    id = 826,
    NameEn = "##123895",
    Icon = "Dungeon",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          145915
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124084",
    GotoMode = {98},
    BeginTime = "",
    EndTime = ""
  },
  [827] = {
    id = 827,
    NameEn = "##307817",
    Icon = "",
    Type = 1,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          5949
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##307817",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [828] = {
    id = 828,
    NameEn = "##307816",
    Icon = "item_5924",
    Type = 1,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          47221
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##307815",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [829] = {
    id = 829,
    NameEn = "##307816",
    Icon = "item_5924",
    Type = 1,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          48101
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##307815",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [830] = {
    id = 830,
    NameEn = "##307816",
    Icon = "item_5924",
    Type = 1,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          149512
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##307815",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [832] = {
    id = 832,
    NameEn = "##124104",
    Icon = "",
    Type = 1,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          ">",
          525
        },
        {
          "id",
          "compare",
          "<",
          532
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124151",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [833] = {
    id = 833,
    NameEn = "##123895",
    Icon = "Dungeon",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          5930
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124084",
    GotoMode = {98},
    BeginTime = "",
    EndTime = ""
  },
  [834] = {
    id = 834,
    NameEn = "##307399",
    Icon = "Dungeon",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          5930
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##307398",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [835] = {
    id = 835,
    NameEn = "##123895",
    Icon = "Dungeon",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          6700
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124084",
    GotoMode = {98},
    BeginTime = "",
    EndTime = ""
  },
  [836] = {
    id = 836,
    NameEn = "##307399",
    Icon = "Dungeon",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          380050
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##307398",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [837] = {
    id = 837,
    NameEn = "##307816",
    Icon = "item_5924",
    Type = 1,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          51590
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##307815",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [838] = {
    id = 838,
    NameEn = "##307816",
    Icon = "item_5924",
    Type = 1,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          51591
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##307815",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [839] = {
    id = 839,
    NameEn = "##307816",
    Icon = "item_5924",
    Type = 1,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          3000081
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##307815",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [840] = {
    id = 840,
    NameEn = "##307816",
    Icon = "item_5924",
    Type = 1,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          3000091
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##307815",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [841] = {
    id = 841,
    NameEn = "##1098875",
    Icon = "",
    Type = 1,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          ">",
          799
        },
        {
          "id",
          "compare",
          "<",
          848
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##315242",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [842] = {
    id = 842,
    NameEn = "##1098875",
    Icon = "",
    Type = 1,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          ">",
          47247
        },
        {
          "id",
          "compare",
          "<",
          47251
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##315242",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [843] = {
    id = 843,
    NameEn = "##124104",
    Icon = "",
    Type = 1,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          ">",
          531
        },
        {
          "id",
          "compare",
          "<",
          568
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124151",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [844] = {
    id = 844,
    NameEn = "##1098875",
    Icon = "",
    Type = 1,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          6815
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##315242",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [845] = {
    id = 845,
    NameEn = "##1098875",
    Icon = "",
    Type = 1,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          7204
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##315242",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [846] = {
    id = 846,
    NameEn = "##123895",
    Icon = "Dungeon",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          40784
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124084",
    GotoMode = {98},
    BeginTime = "",
    EndTime = ""
  },
  [847] = {
    id = 847,
    NameEn = "##123895",
    Icon = "Dungeon",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          40682
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124084",
    GotoMode = {98},
    BeginTime = "",
    EndTime = ""
  },
  [848] = {
    id = 848,
    NameEn = "##1098875",
    Icon = "",
    Type = 1,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          3005180
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##315242",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [849] = {
    id = 849,
    NameEn = "##1098875",
    Icon = "",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          47278
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##315242",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [850] = {
    id = 850,
    NameEn = "##1098875",
    Icon = "",
    Type = 1,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          568
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##315242",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [851] = {
    id = 851,
    NameEn = "##1098875",
    Icon = "",
    Type = 1,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          47283
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##315242",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [852] = {
    id = 852,
    NameEn = "##124026",
    Icon = "Dungeon",
    Type = 1,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          ">",
          4600
        },
        {
          "id",
          "compare",
          "<",
          4614
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124026",
    GotoMode = {1004},
    BeginTime = "",
    EndTime = ""
  },
  [860] = {
    id = 860,
    NameEn = "##1235274",
    Icon = "",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          25190
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235274",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [861] = {
    id = 861,
    NameEn = "##1235274",
    Icon = "",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          25210
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235274",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [862] = {
    id = 862,
    NameEn = "##124104",
    Icon = "",
    Type = 1,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          ">",
          570
        },
        {
          "id",
          "compare",
          "<",
          577
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124151",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [899] = {
    id = 899,
    NameEn = "##1111835",
    Icon = "Shopping",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Shop",
      "items",
      {
        {
          "type",
          "compare",
          "=",
          391
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1134482",
    GotoMode = {1700},
    BeginTime = "",
    EndTime = ""
  },
  [900] = {
    id = 900,
    NameEn = "##1111835",
    Icon = "Shopping",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Shop",
      "items",
      {
        {
          "type",
          "compare",
          "=",
          390
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1134482",
    GotoMode = {1700},
    BeginTime = "",
    EndTime = ""
  },
  [901] = {
    id = 901,
    NameEn = "##1134483",
    Icon = "Dungeon",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          ">",
          6815
        },
        {
          "id",
          "compare",
          "<",
          6822
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1134483",
    GotoMode = {8081},
    BeginTime = "",
    EndTime = ""
  },
  [902] = {
    id = 902,
    NameEn = "##1112444",
    Icon = "Shopping",
    Type = 1,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          6830
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1134485",
    GotoMode = {1701},
    BeginTime = "",
    EndTime = ""
  },
  [903] = {
    id = 903,
    NameEn = "##1134483",
    Icon = "Dungeon",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          ">",
          6829
        },
        {
          "id",
          "compare",
          "<",
          6834
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1134483",
    GotoMode = {8081},
    BeginTime = "",
    EndTime = ""
  },
  [904] = {
    id = 904,
    NameEn = "##1134483",
    Icon = "Dungeon",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          47263
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [905] = {
    id = 905,
    NameEn = "##1134483",
    Icon = "Dungeon",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          48118
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [906] = {
    id = 906,
    NameEn = "##1134483",
    Icon = "Dungeon",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          25176
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [907] = {
    id = 907,
    NameEn = "##1134483",
    Icon = "Dungeon",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          ">",
          391004
        },
        {
          "id",
          "compare",
          "<",
          391008
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [908] = {
    id = 908,
    NameEn = "##1098875",
    Icon = "",
    Type = 1,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          47264
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##315242",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [909] = {
    id = 909,
    NameEn = "##1187387",
    Icon = "Dungeon",
    Type = 1,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          ">",
          6863
        },
        {
          "id",
          "compare",
          "<",
          6873
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1187387",
    GotoMode = {8116},
    BeginTime = "",
    EndTime = ""
  },
  [910] = {
    id = 910,
    NameEn = "##1187387",
    Icon = "Dungeon",
    Type = 1,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          ">",
          6882
        },
        {
          "id",
          "compare",
          "<",
          6887
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1187387",
    GotoMode = {8116},
    BeginTime = "",
    EndTime = ""
  },
  [911] = {
    id = 911,
    NameEn = "##1187387",
    Icon = "Dungeon",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          6861
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1187387",
    GotoMode = {8116},
    BeginTime = "",
    EndTime = ""
  },
  [912] = {
    id = 912,
    NameEn = "##1208051",
    Icon = "Shopping",
    Type = 1,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          6886
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1134485",
    GotoMode = {1701},
    BeginTime = "",
    EndTime = ""
  },
  [913] = {
    id = 913,
    NameEn = "##1187387",
    Icon = "Dungeon",
    Type = 1,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          ">",
          43590
        },
        {
          "id",
          "compare",
          "<",
          43622
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1187387",
    GotoMode = {8116},
    BeginTime = "",
    EndTime = ""
  },
  [914] = {
    id = 914,
    NameEn = "##1187387",
    Icon = "Dungeon",
    Type = 1,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          ">",
          44089
        },
        {
          "id",
          "compare",
          "<",
          44138
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1187387",
    GotoMode = {8116},
    BeginTime = "",
    EndTime = ""
  },
  [915] = {
    id = 915,
    NameEn = "##1187387",
    Icon = "Dungeon",
    Type = 1,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          ">",
          43069
        },
        {
          "id",
          "compare",
          "<",
          43100
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1187387",
    GotoMode = {8116},
    BeginTime = "",
    EndTime = ""
  },
  [916] = {
    id = 916,
    NameEn = "##1211834",
    Icon = "item_6861",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          6817
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1211835",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [917] = {
    id = 917,
    NameEn = "##1211834",
    Icon = "item_6861",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          6832
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1211835",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [918] = {
    id = 918,
    NameEn = "##1211834",
    Icon = "item_6861",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          6865
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1211835",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [919] = {
    id = 919,
    NameEn = "##1211834",
    Icon = "item_6861",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          6868
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1211835",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [920] = {
    id = 920,
    NameEn = "##1211834",
    Icon = "item_6861",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          6871
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1211835",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [921] = {
    id = 921,
    NameEn = "##1187387",
    Icon = "Dungeon",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          6895
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1187387",
    GotoMode = {8116},
    BeginTime = "",
    EndTime = ""
  },
  [922] = {
    id = 922,
    NameEn = "##1187387",
    Icon = "Dungeon",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          47274
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1187387",
    GotoMode = {8116},
    BeginTime = "",
    EndTime = ""
  },
  [923] = {
    id = 923,
    NameEn = "##1187387",
    Icon = "Dungeon",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          49591
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1187387",
    GotoMode = {8116},
    BeginTime = "",
    EndTime = ""
  },
  [924] = {
    id = 924,
    NameEn = "##1187387",
    Icon = "Dungeon",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          25186
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1187387",
    GotoMode = {8116},
    BeginTime = "",
    EndTime = ""
  },
  [925] = {
    id = 925,
    NameEn = "##1187387",
    Icon = "Dungeon",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          391008
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1187387",
    GotoMode = {8116},
    BeginTime = "",
    EndTime = ""
  },
  [926] = {
    id = 926,
    NameEn = "##1187387",
    Icon = "Dungeon",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          391009
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1187387",
    GotoMode = {8116},
    BeginTime = "",
    EndTime = ""
  },
  [927] = {
    id = 927,
    NameEn = "##1187387",
    Icon = "Dungeon",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          391010
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1187387",
    GotoMode = {8116},
    BeginTime = "",
    EndTime = ""
  },
  [928] = {
    id = 928,
    NameEn = "##1224330",
    Icon = "item_6861",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          6818
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1211835",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [929] = {
    id = 929,
    NameEn = "##1224330",
    Icon = "item_6861",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          6833
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1211835",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [930] = {
    id = 930,
    NameEn = "##1224330",
    Icon = "item_6861",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          6866
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1211835",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [931] = {
    id = 931,
    NameEn = "##1224330",
    Icon = "item_6861",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          6869
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1211835",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [932] = {
    id = 932,
    NameEn = "##1224330",
    Icon = "item_6861",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          6872
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1211835",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [933] = {
    id = 933,
    NameEn = "##1098875",
    Icon = "",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          47298
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##315242",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [1000] = {
    id = 1000,
    NameEn = "##117290",
    Icon = "exchange",
    Type = 1,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "AuctionPrice",
          "compare",
          ">",
          0
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124144",
    GotoMode = {
      34,
      35,
      36,
      37,
      38,
      39,
      40,
      41,
      42,
      43,
      44,
      45,
      46,
      47,
      48,
      49,
      59
    },
    BeginTime = "",
    EndTime = ""
  },
  [1001] = {
    id = 1001,
    NameEn = "##124173",
    Icon = "item_111",
    Type = 4,
    Materialdisplay = 0,
    Search1 = {
      "Table_Reward",
      "item",
      {
        {
          "team",
          "compare",
          "=",
          3078
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124172",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [1002] = {
    id = 1002,
    NameEn = "##124201",
    Icon = "item_111",
    Type = 4,
    Materialdisplay = 0,
    Search1 = {
      "Table_Reward",
      "item",
      {
        {
          "team",
          "compare",
          "=",
          3121
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##123974",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [1003] = {
    id = 1003,
    NameEn = "##124109",
    Icon = "item_111",
    Type = 4,
    Materialdisplay = 0,
    Search1 = {
      "Table_Reward",
      "item",
      {
        {
          "team",
          "compare",
          "=",
          6132
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##123899",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [1004] = {
    id = 1004,
    NameEn = "##123952",
    Icon = "item_3707",
    Type = 4,
    Materialdisplay = 0,
    Search1 = {
      "Table_Reward",
      "item",
      {
        {
          "team",
          "compare",
          "=",
          1972
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##123950",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [1005] = {
    id = 1005,
    NameEn = "##124066",
    Icon = "item_3635",
    Type = 4,
    Materialdisplay = 0,
    Search1 = {
      "Table_Reward",
      "item",
      {
        {
          "team",
          "compare",
          "=",
          1972
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##123907",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [1006] = {
    id = 1006,
    NameEn = "##124080",
    Icon = "item_3707",
    Type = 4,
    Materialdisplay = 0,
    Search1 = {
      "Table_Reward",
      "item",
      {
        {
          "team",
          "compare",
          "=",
          1998
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##123950",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [1007] = {
    id = 1007,
    NameEn = "##123964",
    Icon = "item_3635",
    Type = 4,
    Materialdisplay = 0,
    Search1 = {
      "Table_Reward",
      "item",
      {
        {
          "team",
          "compare",
          "=",
          1998
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##123907",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [1008] = {
    id = 1008,
    NameEn = "##119351",
    Icon = "Guild",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Reward",
      "item",
      {
        {
          "team",
          "compare",
          "=",
          1946
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##123920",
    GotoMode = {1500},
    BeginTime = "",
    EndTime = ""
  },
  [1009] = {
    id = 1009,
    NameEn = "##119343",
    Icon = "summer",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Reward",
      "item",
      {
        {
          "team",
          "compare",
          "=",
          40066
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##123898",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = "2021-01-06  00:00:00"
  },
  [1010] = {
    id = 1010,
    NameEn = "##119303",
    Icon = "bigcat_icon_03",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Reward",
      "item",
      {
        {
          "team",
          "compare",
          "=",
          40093
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124196",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [1011] = {
    id = 1011,
    NameEn = "##124141",
    Icon = "item_3866",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          700148
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124020",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [1012] = {
    id = 1012,
    NameEn = "##124141",
    Icon = "item_3866",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          700149
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124020",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [1013] = {
    id = 1013,
    NameEn = "##124141",
    Icon = "item_3866",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          700150
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124020",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [1014] = {
    id = 1014,
    NameEn = "##123945",
    Icon = "item_3867",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          700149
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124082",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [1015] = {
    id = 1015,
    NameEn = "##123945",
    Icon = "item_3867",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          700150
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124082",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [1050] = {
    id = 1050,
    NameEn = "##124004",
    Icon = "item_3780",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          159
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124044",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [1051] = {
    id = 1051,
    NameEn = "##124004",
    Icon = "item_3780",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          161
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124044",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [1052] = {
    id = 1052,
    NameEn = "##124170",
    Icon = "item_3720",
    Type = 1,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          ">",
          5529
        },
        {
          "id",
          "compare",
          "<",
          5533
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124035",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [1060] = {
    id = 1060,
    NameEn = "##119297",
    Icon = "Guild",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          156
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124072",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [1061] = {
    id = 1061,
    NameEn = "##119297",
    Icon = "Guild",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          5897
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124072",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [1070] = {
    id = 1070,
    NameEn = "##123991",
    Icon = "Guild",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          156
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124162",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [1080] = {
    id = 1080,
    NameEn = "##116648",
    Icon = "bar_s",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Shop",
      "items",
      {
        {
          "type",
          "compare",
          "=",
          923
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124039",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [1081] = {
    id = 1081,
    NameEn = "##116614",
    Icon = "machine_s",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Shop",
      "items",
      {
        {
          "type",
          "compare",
          "=",
          924
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124008",
    GotoMode = {1012},
    BeginTime = "",
    EndTime = ""
  },
  [1082] = {
    id = 1082,
    NameEn = "##116614",
    Icon = "machine_s",
    Type = 1,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          ">",
          52832
        },
        {
          "id",
          "compare",
          "<",
          52835
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124008",
    GotoMode = {1012},
    BeginTime = "",
    EndTime = ""
  },
  [1100] = {
    id = 1100,
    NameEn = "##124117",
    Icon = "tiejiangzhizuo",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Compose",
      "Product",
      {
        {
          "Type",
          "compare",
          "=",
          3
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124092",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [1101] = {
    id = 1101,
    NameEn = "##123985",
    Icon = "",
    Type = 3,
    Materialdisplay = 0,
    Search1 = {
      "Table_GuildPVE_Monster",
      "BossReward",
      {
        {
          "Type",
          "staticselect",
          "none",
          {"MINI", "MVP"}
        }
      }
    },
    Search2 = {
      "Table_Reward",
      "item",
      {
        {
          "team",
          "dynamicselect",
          "none",
          0
        }
      }
    },
    Search3 = _EmptyTable,
    Desc = "##123985",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [1102] = {
    id = 1102,
    NameEn = "##118111",
    Icon = "tiejiangzhizuo",
    Type = 1,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          ">",
          52800
        },
        {
          "id",
          "compare",
          "<",
          52830
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##123981",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [1103] = {
    id = 1103,
    NameEn = "##118111",
    Icon = "tiejiangzhizuo",
    Type = 1,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          ">",
          52836
        },
        {
          "id",
          "compare",
          "<",
          52900
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##123981",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [1105] = {
    id = 1105,
    NameEn = "##124181",
    Icon = "CardMech",
    Type = 3,
    Materialdisplay = 1,
    Search1 = {
      "Table_Card",
      "id",
      {
        {
          "Type",
          "bitselect",
          "none",
          {
            {1}
          }
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124155",
    GotoMode = {71},
    BeginTime = "",
    EndTime = ""
  },
  [1106] = {
    id = 1106,
    NameEn = "##124181",
    Icon = "CardMech",
    Type = 3,
    Materialdisplay = 1,
    Search1 = {
      "Table_Card",
      "id",
      {
        {
          "Type",
          "bitselect",
          "none",
          {
            {2}
          }
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124138",
    GotoMode = {71},
    BeginTime = "",
    EndTime = ""
  },
  [1107] = {
    id = 1107,
    NameEn = "##124181",
    Icon = "CardMech",
    Type = 3,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "staticselect",
          "none",
          {5128, 5129}
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124155",
    GotoMode = {71},
    BeginTime = "",
    EndTime = ""
  },
  [1108] = {
    id = 1108,
    NameEn = "##123902",
    Icon = "item_5128",
    Type = 3,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "staticselect",
          "none",
          {3666}
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##123916",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [1109] = {
    id = 1109,
    NameEn = "##123902",
    Icon = "item_3666",
    Type = 3,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "staticselect",
          "none",
          {3667}
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##123905",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [1110] = {
    id = 1110,
    NameEn = "##123987",
    Icon = "23",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Reward",
      "item",
      {
        {
          "team",
          "compare",
          "=",
          3117
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124149",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [1111] = {
    id = 1111,
    NameEn = "##124222",
    Icon = "item_3667",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Reward",
      "item",
      {
        {
          "team",
          "compare",
          "=",
          3118
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124163",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [1112] = {
    id = 1112,
    NameEn = "##123937",
    Icon = "item_710001",
    Type = 1,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          ">",
          710000
        },
        {
          "id",
          "compare",
          "<",
          710101
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124195",
    GotoMode = {72},
    BeginTime = "",
    EndTime = ""
  },
  [1113] = {
    id = 1113,
    NameEn = "##123949",
    Icon = "item_150",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Shop",
      "items",
      {
        {
          "type",
          "compare",
          "=",
          908
        },
        {
          "ShopID",
          "compare",
          "=",
          1
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124207",
    GotoMode = {73},
    BeginTime = "",
    EndTime = ""
  },
  [1114] = {
    id = 1114,
    NameEn = "##123986",
    Icon = "item_551000",
    Type = 4,
    Materialdisplay = 1,
    Search1 = {
      "Table_Recipe",
      "Product",
      {
        {
          "Type",
          "compare",
          ">",
          0
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124220",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [1115] = {
    id = 1115,
    NameEn = "##104813",
    Icon = "lovering",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          145242
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124192",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [1116] = {
    id = 1116,
    NameEn = "##123947",
    Icon = "Shopping",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Shop",
      "items",
      {
        {
          "type",
          "compare",
          "=",
          910
        },
        {
          "ShopID",
          "compare",
          "=",
          1
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124165",
    GotoMode = {74},
    BeginTime = "",
    EndTime = ""
  },
  [1118] = {
    id = 1118,
    NameEn = "##124202",
    Icon = "Shopping",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Shop",
      "items",
      {
        {
          "type",
          "compare",
          "=",
          910
        },
        {
          "ShopID",
          "compare",
          "=",
          2
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##123967",
    GotoMode = {75},
    BeginTime = "",
    EndTime = ""
  },
  [1119] = {
    id = 1119,
    NameEn = "##123943",
    Icon = "Shopping",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Shop",
      "items",
      {
        {
          "type",
          "compare",
          "=",
          3000
        },
        {
          "ShopID",
          "compare",
          "=",
          1
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124011",
    GotoMode = {76},
    BeginTime = "",
    EndTime = ""
  },
  [1120] = {
    id = 1120,
    NameEn = "##123669",
    Icon = "",
    Type = 3,
    Materialdisplay = 0,
    Search1 = {
      "Table_Monster",
      "FoodReward",
      {
        {
          "Type",
          "staticselect",
          "none",
          {
            "Monster",
            "MINI",
            "MVP"
          }
        }
      }
    },
    Search2 = {
      "Table_Reward",
      "item",
      {
        {
          "team",
          "dynamicselect",
          "none",
          0
        }
      }
    },
    Search3 = _EmptyTable,
    Desc = "%s",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [1121] = {
    id = 1121,
    NameEn = "##123937",
    Icon = "CatGod1",
    Type = 1,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          ">",
          14219
        },
        {
          "id",
          "compare",
          "<",
          14232
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124195",
    GotoMode = {72},
    BeginTime = "",
    EndTime = ""
  },
  [1122] = {
    id = 1122,
    NameEn = "##123937",
    Icon = "CatGod1",
    Type = 1,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          ">",
          14157
        },
        {
          "id",
          "compare",
          "<",
          14170
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124195",
    GotoMode = {72},
    BeginTime = "",
    EndTime = ""
  },
  [1123] = {
    id = 1123,
    NameEn = "##123934",
    Icon = "",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Lottery",
      "itemid",
      {
        {
          "type",
          "compare",
          "=",
          1
        }
      }
    },
    Search2 = {
      LotteryMech
    },
    Search3 = _EmptyTable,
    Desc = "##124125",
    GotoMode = {80},
    BeginTime = "",
    EndTime = ""
  },
  [1124] = {
    id = 1124,
    NameEn = "##113974",
    Icon = "item_3504",
    Type = 1,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          ">",
          12365
        },
        {
          "id",
          "compare",
          "<",
          12369
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##123912",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [1125] = {
    id = 1125,
    NameEn = "##113594",
    Icon = "item_800101",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          45505
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124227",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [1126] = {
    id = 1126,
    NameEn = "##113450",
    Icon = "item_800102",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          45501
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124119",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [1127] = {
    id = 1127,
    NameEn = "##113707",
    Icon = "item_800103",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          45503
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124033",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [1128] = {
    id = 1128,
    NameEn = "##113608",
    Icon = "item_800104",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          45504
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124157",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [1129] = {
    id = 1129,
    NameEn = "##113480",
    Icon = "item_800105",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          45500
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##123897",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [1130] = {
    id = 1130,
    NameEn = "##113453",
    Icon = "item_800106",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          45502
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124050",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [1131] = {
    id = 1131,
    NameEn = "##113497",
    Icon = "item_800107",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          45506
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124217",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [1132] = {
    id = 1132,
    NameEn = "##113628",
    Icon = "item_800108",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          45509
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124214",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [1133] = {
    id = 1133,
    NameEn = "##113553",
    Icon = "item_800109",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          48582
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124122",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [1134] = {
    id = 1134,
    NameEn = "##124013",
    Icon = "",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Lottery",
      "itemid",
      {
        {
          "type",
          "compare",
          "=",
          2
        }
      }
    },
    Search2 = {
      EquipLotteryMech
    },
    Search3 = _EmptyTable,
    Desc = "##123958",
    GotoMode = {81},
    BeginTime = "",
    EndTime = ""
  },
  [1136] = {
    id = 1136,
    NameEn = "##124228",
    Icon = "",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Shop",
      "items",
      {
        {
          "type",
          "compare",
          "=",
          800
        },
        {
          "ShopID",
          "compare",
          "=",
          1000
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124076",
    GotoMode = {602},
    BeginTime = "",
    EndTime = ""
  },
  [1138] = {
    id = 1138,
    NameEn = "##124160",
    Icon = "",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Shop",
      "items",
      {
        {
          "type",
          "compare",
          "=",
          605
        },
        {
          "ShopID",
          "compare",
          "=",
          1
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124154",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [1139] = {
    id = 1139,
    NameEn = "##124181",
    Icon = "CardMech",
    Type = 3,
    Materialdisplay = 1,
    Search1 = {
      "Table_Card",
      "id",
      {
        {
          "Type",
          "bitselect",
          "none",
          {
            {5}
          }
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##123997",
    GotoMode = {71},
    BeginTime = "",
    EndTime = ""
  },
  [1140] = {
    id = 1140,
    NameEn = "##124181",
    Icon = "CardMech",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          52836
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124155",
    GotoMode = {71},
    BeginTime = "",
    EndTime = ""
  },
  [1141] = {
    id = 1141,
    NameEn = "##124063",
    Icon = "CardLotteryMech",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          52836
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124064",
    GotoMode = {82},
    BeginTime = "",
    EndTime = ""
  },
  [1142] = {
    id = 1142,
    NameEn = "##124026",
    Icon = "Man",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          52836
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124026",
    GotoMode = {1004},
    BeginTime = "",
    EndTime = ""
  },
  [1150] = {
    id = 1150,
    NameEn = "##123902",
    Icon = "Enchants",
    Type = 1,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          ">",
          52829
        },
        {
          "id",
          "compare",
          "<",
          52835
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##123951",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [1151] = {
    id = 1151,
    NameEn = "##123902",
    Icon = "item_12638",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          12618
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124005",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [1160] = {
    id = 1160,
    NameEn = "##124062",
    Icon = "item_5700",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          45522
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##123998",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [1161] = {
    id = 1161,
    NameEn = "##124213",
    Icon = "item_5701",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          45523
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124098",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [1162] = {
    id = 1162,
    NameEn = "##124022",
    Icon = "item_5702",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          45524
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##123969",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [1163] = {
    id = 1163,
    NameEn = "##123992",
    Icon = "item_5704",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          45938
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124182",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [1164] = {
    id = 1164,
    NameEn = "##123921",
    Icon = "item_5705",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          49031
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124012",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [1165] = {
    id = 1165,
    NameEn = "##124089",
    Icon = "item_5703",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          45607
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124061",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [1166] = {
    id = 1166,
    NameEn = "##1128652",
    Icon = "item_5706",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          47195
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1128653",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [1167] = {
    id = 1167,
    NameEn = "##1128654",
    Icon = "item_5707",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          49205
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1128655",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [1168] = {
    id = 1168,
    NameEn = "##1128656",
    Icon = "item_5708",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          47130
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1128657",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [1169] = {
    id = 1169,
    NameEn = "##1153335",
    Icon = "item_5709",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          3003421
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1153336",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [1170] = {
    id = 1170,
    NameEn = "##1134483",
    Icon = "Dungeon",
    Type = 1,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          ">",
          42126
        },
        {
          "id",
          "compare",
          "<",
          42181
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1134483",
    GotoMode = {8081},
    BeginTime = "",
    EndTime = ""
  },
  [1171] = {
    id = 1171,
    NameEn = "##1134483",
    Icon = "Dungeon",
    Type = 1,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          ">",
          42607
        },
        {
          "id",
          "compare",
          "<",
          42669
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1134483",
    GotoMode = {8081},
    BeginTime = "",
    EndTime = ""
  },
  [1173] = {
    id = 1173,
    NameEn = "##1187393",
    Icon = "item_5991",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          49561
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1187394",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [2010] = {
    id = 2010,
    NameEn = "##117354",
    Icon = "Guild",
    Type = 1,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          5261
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235278",
    GotoMode = {3018},
    BeginTime = "",
    EndTime = ""
  },
  [2011] = {
    id = 2011,
    NameEn = "##117302",
    Icon = "Wanted",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          5260
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##123913",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = "2020-06-11 22:00:00"
  },
  [2012] = {
    id = 2012,
    NameEn = "##113985",
    Icon = "Map",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          5260
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124058",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = "2020-06-11 22:00:00"
  },
  [2013] = {
    id = 2013,
    NameEn = "##113979",
    Icon = "Quest",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          5260
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##123959",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = "2020-06-11 22:00:00"
  },
  [2014] = {
    id = 2014,
    NameEn = "##124070",
    Icon = "Quest",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          5260
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124090",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = "2020-06-11 22:00:00"
  },
  [2015] = {
    id = 2015,
    NameEn = "##113983",
    Icon = "Dungeon",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          5260
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124099",
    GotoMode = {5031},
    BeginTime = "",
    EndTime = "2020-06-11 22:00:00"
  },
  [2016] = {
    id = 2016,
    NameEn = "##117311",
    Icon = "Guild_Dojo",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          147
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124068",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = "2020-06-11 22:00:00"
  },
  [2017] = {
    id = 2017,
    NameEn = "##113983",
    Icon = "Dungeon",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          147
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124000",
    GotoMode = {5031},
    BeginTime = "",
    EndTime = "2020-06-11 22:00:00"
  },
  [2018] = {
    id = 2018,
    NameEn = "##124070",
    Icon = "Quest",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          147
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##123938",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = "2020-06-11 22:00:00"
  },
  [2019] = {
    id = 2019,
    NameEn = "##113985",
    Icon = "Map",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          147
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##123939",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = "2020-06-11 22:00:00"
  },
  [2020] = {
    id = 2020,
    NameEn = "##117302",
    Icon = "Wanted",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          147
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##123941",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = "2020-06-11 22:00:00"
  },
  [2021] = {
    id = 2021,
    NameEn = "##116769",
    Icon = "",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Shop",
      "items",
      {
        {
          "type",
          "compare",
          "=",
          650
        },
        {
          "ShopID",
          "compare",
          "=",
          1
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124130",
    GotoMode = {86},
    BeginTime = "",
    EndTime = ""
  },
  [2022] = {
    id = 2022,
    NameEn = "##124204",
    Icon = "",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Shop",
      "items",
      {
        {
          "type",
          "compare",
          "=",
          914
        },
        {
          "ShopID",
          "compare",
          "=",
          1
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##123966",
    GotoMode = {87},
    BeginTime = "",
    EndTime = ""
  },
  [2023] = {
    id = 2023,
    NameEn = "##123925",
    Icon = "",
    Type = 1,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          ">",
          310000
        },
        {
          "id",
          "compare",
          "<",
          310003
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124056",
    GotoMode = {88},
    BeginTime = "",
    EndTime = ""
  },
  [2024] = {
    id = 2024,
    NameEn = "##123925",
    Icon = "",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          3669
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124056",
    GotoMode = {88},
    BeginTime = "",
    EndTime = ""
  },
  [2025] = {
    id = 2025,
    NameEn = "##123925",
    Icon = "",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          48575
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124056",
    GotoMode = {88},
    BeginTime = "",
    EndTime = ""
  },
  [2026] = {
    id = 2026,
    NameEn = "##123982",
    Icon = "item_3669",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          17575
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124203",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [2027] = {
    id = 2027,
    NameEn = "##123982",
    Icon = "item_3669",
    Type = 1,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          ">",
          551799
        },
        {
          "id",
          "compare",
          "<",
          551807
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124203",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [2028] = {
    id = 2028,
    NameEn = "##123982",
    Icon = "item_3669",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          48575
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124203",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [2500] = {
    id = 2500,
    NameEn = "##124078",
    Icon = "CardMech",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          52835
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124128",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [2501] = {
    id = 2501,
    NameEn = "##119351",
    Icon = "Guild",
    Type = 1,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          6005
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##123920",
    GotoMode = {1500},
    BeginTime = "",
    EndTime = ""
  },
  [2502] = {
    id = 2502,
    NameEn = "##113058",
    Icon = "23",
    Type = 1,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          ">",
          24054
        },
        {
          "id",
          "compare",
          "<",
          24065
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##123948",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [2503] = {
    id = 2503,
    NameEn = "##124199",
    Icon = "Dungeon",
    Type = 1,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          ">",
          900040
        },
        {
          "id",
          "compare",
          "<",
          900048
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124166",
    GotoMode = {5031},
    BeginTime = "",
    EndTime = ""
  },
  [2504] = {
    id = 2504,
    NameEn = "##123936",
    Icon = "Shopping",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Shop",
      "items",
      {
        {
          "type",
          "compare",
          "=",
          915
        },
        {
          "ShopID",
          "compare",
          "=",
          8
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##123924",
    GotoMode = {93},
    BeginTime = "",
    EndTime = ""
  },
  [2505] = {
    id = 2505,
    NameEn = "##124159",
    Icon = "",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Shop",
      "items",
      {
        {
          "type",
          "compare",
          "=",
          3255
        },
        {
          "ShopID",
          "compare",
          "=",
          1
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##123961",
    GotoMode = {972},
    BeginTime = "",
    EndTime = ""
  },
  [2507] = {
    id = 2507,
    NameEn = "##124186",
    Icon = "MVPfight",
    Type = 1,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          5712
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124186",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [2508] = {
    id = 2508,
    NameEn = "##124086",
    Icon = "Shopping",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Shop",
      "items",
      {
        {
          "type",
          "compare",
          "=",
          3263
        },
        {
          "ShopID",
          "compare",
          "=",
          1
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124164",
    GotoMode = {3093},
    BeginTime = "",
    EndTime = ""
  },
  [2509] = {
    id = 2509,
    NameEn = "##122894",
    Icon = "",
    Type = 1,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          ">",
          173
        },
        {
          "id",
          "compare",
          "<",
          176
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124184",
    GotoMode = {95},
    BeginTime = "",
    EndTime = ""
  },
  [2510] = {
    id = 2510,
    NameEn = "##788588",
    Icon = "Shopping",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Shop",
      "items",
      {
        {
          "type",
          "compare",
          "=",
          3303
        },
        {
          "ShopID",
          "compare",
          "=",
          1
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##788587",
    GotoMode = {1605},
    BeginTime = "",
    EndTime = ""
  },
  [2511] = {
    id = 2511,
    NameEn = "##113984",
    Icon = "Guild",
    Type = 1,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          5263
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235279",
    GotoMode = {3019},
    BeginTime = "",
    EndTime = ""
  },
  [2512] = {
    id = 2512,
    NameEn = "##117272",
    Icon = "Guild",
    Type = 1,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          5034
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235280",
    GotoMode = {
      1,
      901,
      902,
      903,
      904,
      905,
      906,
      907,
      908,
      909,
      910,
      911,
      912,
      913
    },
    BeginTime = "",
    EndTime = ""
  },
  [2513] = {
    id = 2513,
    NameEn = "##113984",
    Icon = "Guild",
    Type = 1,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          141
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235279",
    GotoMode = {3019},
    BeginTime = "",
    EndTime = ""
  },
  [2514] = {
    id = 2514,
    NameEn = "##117354",
    Icon = "Guild",
    Type = 1,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          140
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235278",
    GotoMode = {3018},
    BeginTime = "",
    EndTime = ""
  },
  [4000] = {
    id = 4000,
    NameEn = "##113647",
    Icon = "item_800110",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          45510
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##123935",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [4001] = {
    id = 4001,
    NameEn = "##113621",
    Icon = "item_800111",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          45287
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124124",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [4002] = {
    id = 4002,
    NameEn = "##113654",
    Icon = "item_800112",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          45519
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124126",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [4003] = {
    id = 4003,
    NameEn = "##113501",
    Icon = "item_800201",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          47050
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##123910",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [4004] = {
    id = 4004,
    NameEn = "##113712",
    Icon = "item_800202",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          45521
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124168",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [4005] = {
    id = 4005,
    NameEn = "##113697",
    Icon = "item_800203",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          45536
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124032",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [4006] = {
    id = 4006,
    NameEn = "##113413",
    Icon = "item_800204",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          48613
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124113",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [4007] = {
    id = 4007,
    NameEn = "##113549",
    Icon = "item_800205",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          45591
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##123911",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [4008] = {
    id = 4008,
    NameEn = "##113423",
    Icon = "item_800206",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          45619
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##123933",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [4009] = {
    id = 4009,
    NameEn = "##113420",
    Icon = "item_800207",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          48636
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124055",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [4010] = {
    id = 4010,
    NameEn = "##113547",
    Icon = "item_800208",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          48646
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124133",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [4011] = {
    id = 4011,
    NameEn = "##113552",
    Icon = "item_800209",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          48654
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124100",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [4012] = {
    id = 4012,
    NameEn = "##113445",
    Icon = "item_800210",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          45939
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124116",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [4013] = {
    id = 4013,
    NameEn = "##113555",
    Icon = "item_800211",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          48639
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124146",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [4014] = {
    id = 4014,
    NameEn = "##113619",
    Icon = "item_800212",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          45675
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124085",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [4015] = {
    id = 4015,
    NameEn = "##113584",
    Icon = "item_800301",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          49014
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124223",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [4016] = {
    id = 4016,
    NameEn = "##113454",
    Icon = "item_800302",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          48695
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##123971",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [4017] = {
    id = 4017,
    NameEn = "##113611",
    Icon = "item_810001",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          48702
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##123983",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [4018] = {
    id = 4018,
    NameEn = "##113533",
    Icon = "item_810001",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          3000039
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##123909",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [4019] = {
    id = 4019,
    NameEn = "##113638",
    Icon = "item_810001",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          3000046
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124137",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [4020] = {
    id = 4020,
    NameEn = "##113624",
    Icon = "item_810001",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          3000053
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124024",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [4021] = {
    id = 4021,
    NameEn = "##113719",
    Icon = "item_810001",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          3000247
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124221",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [4022] = {
    id = 4022,
    NameEn = "##113467",
    Icon = "item_810001",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          3000326
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124212",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [4023] = {
    id = 4023,
    NameEn = "##113429",
    Icon = "item_810001",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          3000466
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124073",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [4024] = {
    id = 4024,
    NameEn = "##113452",
    Icon = "item_800310",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          3000816
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124167",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [4025] = {
    id = 4025,
    NameEn = "##113571",
    Icon = "item_800311",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          3000536
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124156",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [4026] = {
    id = 4026,
    NameEn = "##113443",
    Icon = "item_800312",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          3001016
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##123970",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [4027] = {
    id = 4027,
    NameEn = "##113690",
    Icon = "item_800313",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          3001116
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124017",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [4028] = {
    id = 4028,
    NameEn = "##113568",
    Icon = "item_800402",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          3001326
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124200",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [4029] = {
    id = 4029,
    NameEn = "##113489",
    Icon = "item_800403",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          3001276
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124112",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [4030] = {
    id = 4030,
    NameEn = "##113411",
    Icon = "item_800404",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          3001466
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124059",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [4031] = {
    id = 4031,
    NameEn = "##113664",
    Icon = "item_800405",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          3001656
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##123931",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [4032] = {
    id = 4032,
    NameEn = "##113502",
    Icon = "item_800406",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          3001906
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124177",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [4033] = {
    id = 4033,
    NameEn = "##124045",
    Icon = "item_800407",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          3001936
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124015",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [4034] = {
    id = 4034,
    NameEn = "##298778",
    Icon = "item_800408",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          3002156
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##298777",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [4035] = {
    id = 4035,
    NameEn = "##303370",
    Icon = "item_800409",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          3002286
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##304410",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [4036] = {
    id = 4036,
    NameEn = "##304470",
    Icon = "item_800410",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          3002336
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##307010",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [4037] = {
    id = 4037,
    NameEn = "##304453",
    Icon = "item_800411",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          3002776
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##309267",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [4038] = {
    id = 4038,
    NameEn = "##304486",
    Icon = "item_800412",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          3002906
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##315244",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [4039] = {
    id = 4039,
    NameEn = "##330123",
    Icon = "item_800501",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          3003066
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##330124",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [4040] = {
    id = 4040,
    NameEn = "##807859",
    Icon = "item_800502",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          3003156
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##807858",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [4041] = {
    id = 4041,
    NameEn = "##1098737",
    Icon = "item_800503",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          3003286
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1098738",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [4042] = {
    id = 4042,
    NameEn = "##1104571",
    Icon = "item_800504",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          3003536
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1104572",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [4043] = {
    id = 4043,
    NameEn = "##1111437",
    Icon = "item_800505",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          3003396
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1123892",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [4044] = {
    id = 4044,
    NameEn = "##1111438",
    Icon = "item_800506",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          3003886
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1131230",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [4045] = {
    id = 4045,
    NameEn = "##1111439",
    Icon = "item_800507",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          3004016
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1151170",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [4046] = {
    id = 4046,
    NameEn = "##1111440",
    Icon = "item_800508",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          3004476
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1153617",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [4047] = {
    id = 4047,
    NameEn = "##1111441",
    Icon = "item_800509",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          3004626
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1160066",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [4048] = {
    id = 4048,
    NameEn = "##1111442",
    Icon = "item_800510",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          3004856
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1171681",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [4049] = {
    id = 4049,
    NameEn = "##1111443",
    Icon = "item_800511",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          3004866
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1183744",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [4050] = {
    id = 4050,
    NameEn = "##1111444",
    Icon = "item_800512",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          3004876
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1187395",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [4051] = {
    id = 4051,
    NameEn = "##1187396",
    Icon = "item_800601",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          3005196
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1187397",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [4052] = {
    id = 4052,
    NameEn = "##1193850",
    Icon = "item_800602",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          3005206
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1193885",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [4053] = {
    id = 4053,
    NameEn = "##1193851",
    Icon = "item_800603",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          3005506
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1193886",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [4054] = {
    id = 4054,
    NameEn = "##1193852",
    Icon = "item_800604",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          3005696
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1193887",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [4055] = {
    id = 4055,
    NameEn = "##1193853",
    Icon = "item_800605",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          3005806
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1193888",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [4056] = {
    id = 4056,
    NameEn = "##1193854",
    Icon = "item_800606",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          3005996
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1193889",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [4057] = {
    id = 4057,
    NameEn = "##1193855",
    Icon = "item_800607",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          3006036
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1193890",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [4058] = {
    id = 4058,
    NameEn = "##1193856",
    Icon = "item_800608",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          3005936
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1193891",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [4059] = {
    id = 4059,
    NameEn = "##1193857",
    Icon = "item_800609",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          3006186
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1193892",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [4060] = {
    id = 4060,
    NameEn = "##1193858",
    Icon = "item_800610",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          3006536
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1193893",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [4061] = {
    id = 4061,
    NameEn = "##1193859",
    Icon = "item_800611",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          3006686
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1193894",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [4062] = {
    id = 4062,
    NameEn = "##1193860",
    Icon = "item_800612",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          3006946
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1193895",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [4100] = {
    id = 4100,
    NameEn = "##123954",
    Icon = "Reward",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Shop",
      "items",
      {
        {
          "type",
          "compare",
          "=",
          812
        },
        {
          "ShopOrder",
          "compare",
          "<",
          50
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##123954",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [4101] = {
    id = 4101,
    NameEn = "##124034",
    Icon = "Mite",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Shop",
      "items",
      {
        {
          "type",
          "compare",
          "=",
          812
        },
        {
          "ShopID",
          "compare",
          "=",
          1
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124003",
    GotoMode = {3056},
    BeginTime = "",
    EndTime = ""
  },
  [4102] = {
    id = 4102,
    NameEn = "##123694",
    Icon = "126",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          ">",
          500600
        },
        {
          "id",
          "compare",
          "<",
          500631
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##304411",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [4103] = {
    id = 4103,
    NameEn = "##306807",
    Icon = "Rainbowstone_poring",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          901430
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##314999",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [4104] = {
    id = 4104,
    NameEn = "##312175",
    Icon = "Butterfly_elf",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          901440
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##314999",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [5000] = {
    id = 5000,
    NameEn = "##124158",
    Icon = "",
    Type = 1,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          ">",
          749999
        },
        {
          "id",
          "compare",
          "<",
          760000
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124065",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [5001] = {
    id = 5001,
    NameEn = "##122900",
    Icon = "",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          750000
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124187",
    GotoMode = {1600},
    BeginTime = "",
    EndTime = ""
  },
  [5002] = {
    id = 5002,
    NameEn = "##123989",
    Icon = "homeliy",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          760060
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124178",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [5003] = {
    id = 5003,
    NameEn = "##124194",
    Icon = "",
    Type = 1,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          ">",
          750029
        },
        {
          "id",
          "compare",
          "<",
          750041
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124215",
    GotoMode = {1602},
    BeginTime = "",
    EndTime = ""
  },
  [5004] = {
    id = 5004,
    NameEn = "##123906",
    Icon = "",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Shop",
      "items",
      {
        {
          "type",
          "compare",
          "=",
          3245
        },
        {
          "ShopID",
          "compare",
          "=",
          1
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124051",
    GotoMode = {1603},
    BeginTime = "",
    EndTime = ""
  },
  [5005] = {
    id = 5005,
    NameEn = "##124079",
    Icon = "",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Shop",
      "items",
      {
        {
          "type",
          "compare",
          "=",
          3246
        },
        {
          "ShopID",
          "compare",
          "=",
          1
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##123901",
    GotoMode = {1604},
    BeginTime = "",
    EndTime = ""
  },
  [5006] = {
    id = 5006,
    NameEn = "##124121",
    Icon = "",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          760070
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124093",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [5007] = {
    id = 5007,
    NameEn = "##124111",
    Icon = "",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          760080
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##123960",
    GotoMode = {8011},
    BeginTime = "",
    EndTime = ""
  },
  [5008] = {
    id = 5008,
    NameEn = "##124194",
    Icon = "",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          750080
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##789594",
    GotoMode = {3073},
    BeginTime = "",
    EndTime = ""
  },
  [5009] = {
    id = 5009,
    NameEn = "##531716",
    Icon = "",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Shop",
      "items",
      {
        {
          "type",
          "compare",
          "=",
          3309
        },
        {
          "ShopID",
          "compare",
          "=",
          1
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1159985",
    GotoMode = {8034},
    BeginTime = "",
    EndTime = ""
  },
  [6000] = {
    id = 6000,
    NameEn = "##123930",
    Icon = "MaleAssistant",
    Type = 1,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          ">",
          5661
        },
        {
          "id",
          "compare",
          "<",
          5664
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124108",
    GotoMode = {3090},
    BeginTime = "",
    EndTime = ""
  },
  [6001] = {
    id = 6001,
    NameEn = "##123932",
    Icon = "",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Shop",
      "items",
      {
        {
          "type",
          "compare",
          "=",
          3250
        },
        {
          "ShopID",
          "compare",
          "=",
          1
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##123904",
    GotoMode = {3091},
    BeginTime = "",
    EndTime = ""
  },
  [6002] = {
    id = 6002,
    NameEn = "##123932",
    Icon = "",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Shop",
      "items",
      {
        {
          "type",
          "compare",
          "=",
          3251
        },
        {
          "ShopID",
          "compare",
          "=",
          1
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##123904",
    GotoMode = {3091},
    BeginTime = "",
    EndTime = ""
  },
  [6003] = {
    id = 6003,
    NameEn = "##123932",
    Icon = "",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Shop",
      "items",
      {
        {
          "type",
          "compare",
          "=",
          3252
        },
        {
          "ShopID",
          "compare",
          "=",
          1
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##123904",
    GotoMode = {3091},
    BeginTime = "",
    EndTime = ""
  },
  [6004] = {
    id = 6004,
    NameEn = "##124191",
    Icon = "",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Shop",
      "items",
      {
        {
          "type",
          "compare",
          "=",
          3247
        },
        {
          "ShopID",
          "compare",
          "=",
          1
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124047",
    GotoMode = {3092},
    BeginTime = "",
    EndTime = ""
  },
  [6005] = {
    id = 6005,
    NameEn = "##123918",
    Icon = "",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          149198
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##123993",
    GotoMode = {6020},
    BeginTime = "",
    EndTime = "2022-02-15 22:00:00"
  },
  [6006] = {
    id = 6006,
    NameEn = "##123918",
    Icon = "",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          48728
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##123993",
    GotoMode = {6020},
    BeginTime = "",
    EndTime = "2022-02-15 22:00:00"
  },
  [6007] = {
    id = 6007,
    NameEn = "##123918",
    Icon = "",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          47210
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##123993",
    GotoMode = {6020},
    BeginTime = "",
    EndTime = "2022-02-15 22:00:00"
  },
  [6008] = {
    id = 6008,
    NameEn = "##123918",
    Icon = "",
    Type = 1,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          ">",
          31234
        },
        {
          "id",
          "compare",
          "<",
          31237
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##123993",
    GotoMode = {6020},
    BeginTime = "",
    EndTime = "2022-02-15 22:00:00"
  },
  [6010] = {
    id = 6010,
    NameEn = "##123944",
    Icon = "",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Shop",
      "items",
      {
        {
          "type",
          "compare",
          "=",
          3277
        },
        {
          "ShopID",
          "compare",
          "=",
          1
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124198",
    GotoMode = {8010},
    BeginTime = "",
    EndTime = ""
  },
  [6011] = {
    id = 6011,
    NameEn = "##124111",
    Icon = "",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Shop",
      "items",
      {
        {
          "type",
          "compare",
          "=",
          3278
        },
        {
          "ShopID",
          "compare",
          "=",
          1
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##123896",
    GotoMode = {8011},
    BeginTime = "",
    EndTime = ""
  },
  [6012] = {
    id = 6012,
    NameEn = "##123918",
    Icon = "",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          31234
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##123993",
    GotoMode = {6020},
    BeginTime = "",
    EndTime = "2022-02-15 22:00:00"
  },
  [6013] = {
    id = 6013,
    NameEn = "##123918",
    Icon = "",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          31231
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##123993",
    GotoMode = {6020},
    BeginTime = "",
    EndTime = "2022-02-15 22:00:00"
  },
  [6014] = {
    id = 6014,
    NameEn = "##123918",
    Icon = "",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          31233
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##123993",
    GotoMode = {6020},
    BeginTime = "",
    EndTime = "2022-02-15 22:00:00"
  },
  [6015] = {
    id = 6015,
    NameEn = "##123918",
    Icon = "",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          31232
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##123993",
    GotoMode = {6020},
    BeginTime = "",
    EndTime = "2022-02-15 22:00:00"
  },
  [6016] = {
    id = 6016,
    NameEn = "##123918",
    Icon = "",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          31230
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##123993",
    GotoMode = {6020},
    BeginTime = "",
    EndTime = "2022-02-15 22:00:00"
  },
  [6017] = {
    id = 6017,
    NameEn = "##124194",
    Icon = "",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          750070
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124143",
    GotoMode = {8012},
    BeginTime = "",
    EndTime = ""
  },
  [6018] = {
    id = 6018,
    NameEn = "##124121",
    Icon = "",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          750060
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124093",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [6019] = {
    id = 6019,
    NameEn = "##123918",
    Icon = "",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          149197
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##123993",
    GotoMode = {6020},
    BeginTime = "",
    EndTime = "2022-02-15 22:00:00"
  },
  [6020] = {
    id = 6020,
    NameEn = "##123918",
    Icon = "",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          48730
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##123993",
    GotoMode = {6020},
    BeginTime = "",
    EndTime = "2022-02-15 22:00:00"
  },
  [6021] = {
    id = 6021,
    NameEn = "##123918",
    Icon = "",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          47208
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##123993",
    GotoMode = {6020},
    BeginTime = "",
    EndTime = "2022-02-15 22:00:00"
  },
  [6022] = {
    id = 6022,
    NameEn = "##123918",
    Icon = "",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          31015
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##123993",
    GotoMode = {6020},
    BeginTime = "",
    EndTime = "2022-02-15 22:00:00"
  },
  [6023] = {
    id = 6023,
    NameEn = "##123918",
    Icon = "",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          31001
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##123993",
    GotoMode = {6020},
    BeginTime = "",
    EndTime = "2022-02-15 22:00:00"
  },
  [6024] = {
    id = 6024,
    NameEn = "##123918",
    Icon = "",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          31010
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##123993",
    GotoMode = {6020},
    BeginTime = "",
    EndTime = "2022-02-15 22:00:00"
  },
  [6026] = {
    id = 6026,
    NameEn = "##106129",
    Icon = "Longhai",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          54879
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##123965",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [6027] = {
    id = 6027,
    NameEn = "##123669",
    Icon = "pet_equip_3",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          112936
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##123973",
    GotoMode = {8015},
    BeginTime = "",
    EndTime = "2022-02-15 22:00:00"
  },
  [6028] = {
    id = 6028,
    NameEn = "##123669",
    Icon = "pet_equip_3",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          112941
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##123973",
    GotoMode = {8015},
    BeginTime = "",
    EndTime = "2022-02-15 22:00:00"
  },
  [6029] = {
    id = 6029,
    NameEn = "##123669",
    Icon = "pet_equip_3",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          112944
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##123973",
    GotoMode = {8015},
    BeginTime = "",
    EndTime = "2022-02-15 22:00:00"
  },
  [6030] = {
    id = 6030,
    NameEn = "##123669",
    Icon = "pet_equip_3",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          112945
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##123973",
    GotoMode = {8015},
    BeginTime = "",
    EndTime = "2022-02-15 22:00:00"
  },
  [6031] = {
    id = 6031,
    NameEn = "##123669",
    Icon = "pet_equip_3",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          112948
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##123973",
    GotoMode = {8015},
    BeginTime = "",
    EndTime = "2022-02-15 22:00:00"
  },
  [6032] = {
    id = 6032,
    NameEn = "##123669",
    Icon = "pet_equip_3",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          112949
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##123973",
    GotoMode = {8015},
    BeginTime = "",
    EndTime = "2022-02-15 22:00:00"
  },
  [6033] = {
    id = 6033,
    NameEn = "##123669",
    Icon = "pet_equip_3",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          112951
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##123973",
    GotoMode = {8015},
    BeginTime = "",
    EndTime = "2022-02-15 22:00:00"
  },
  [6034] = {
    id = 6034,
    NameEn = "##123669",
    Icon = "pet_equip_3",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          112952
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##123973",
    GotoMode = {8015},
    BeginTime = "",
    EndTime = "2022-02-15 22:00:00"
  },
  [6035] = {
    id = 6035,
    NameEn = "##123669",
    Icon = "pet_equip_3",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          112953
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##123973",
    GotoMode = {8015},
    BeginTime = "",
    EndTime = "2022-02-15 22:00:00"
  },
  [6036] = {
    id = 6036,
    NameEn = "##123669",
    Icon = "pet_equip_3",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          12936
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##123973",
    GotoMode = {8015},
    BeginTime = "",
    EndTime = "2022-02-15 22:00:00"
  },
  [6037] = {
    id = 6037,
    NameEn = "##123669",
    Icon = "pet_equip_3",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          12941
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##123973",
    GotoMode = {8015},
    BeginTime = "",
    EndTime = "2022-02-15 22:00:00"
  },
  [6038] = {
    id = 6038,
    NameEn = "##123669",
    Icon = "pet_equip_3",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          12944
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##123973",
    GotoMode = {8015},
    BeginTime = "",
    EndTime = "2022-02-15 22:00:00"
  },
  [6039] = {
    id = 6039,
    NameEn = "##123669",
    Icon = "pet_equip_3",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          12945
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##123973",
    GotoMode = {8015},
    BeginTime = "",
    EndTime = "2022-02-15 22:00:00"
  },
  [6040] = {
    id = 6040,
    NameEn = "##123669",
    Icon = "pet_equip_3",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          12948
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##123973",
    GotoMode = {8015},
    BeginTime = "",
    EndTime = "2022-02-15 22:00:00"
  },
  [6041] = {
    id = 6041,
    NameEn = "##123669",
    Icon = "pet_equip_3",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          12949
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##123973",
    GotoMode = {8015},
    BeginTime = "",
    EndTime = "2022-02-15 22:00:00"
  },
  [6042] = {
    id = 6042,
    NameEn = "##123669",
    Icon = "pet_equip_3",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          12951
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##123973",
    GotoMode = {8015},
    BeginTime = "",
    EndTime = "2022-02-15 22:00:00"
  },
  [6043] = {
    id = 6043,
    NameEn = "##123669",
    Icon = "pet_equip_3",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          12952
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##123973",
    GotoMode = {8015},
    BeginTime = "",
    EndTime = "2022-02-15 22:00:00"
  },
  [6044] = {
    id = 6044,
    NameEn = "##123669",
    Icon = "pet_equip_3",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          12953
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##123973",
    GotoMode = {8015},
    BeginTime = "",
    EndTime = "2022-02-15 22:00:00"
  },
  [6045] = {
    id = 6045,
    NameEn = "##123918",
    Icon = "",
    Type = 1,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          ">",
          12911
        },
        {
          "id",
          "compare",
          "<",
          12914
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##123900",
    GotoMode = {6020},
    BeginTime = "",
    EndTime = "2022-02-15 22:00:00"
  },
  [6046] = {
    id = 6046,
    NameEn = "##123918",
    Icon = "",
    Type = 1,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          ">",
          12922
        },
        {
          "id",
          "compare",
          "<",
          12925
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##123900",
    GotoMode = {6020},
    BeginTime = "",
    EndTime = "2022-02-15 22:00:00"
  },
  [6047] = {
    id = 6047,
    NameEn = "##123918",
    Icon = "",
    Type = 1,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          ">",
          12925
        },
        {
          "id",
          "compare",
          "<",
          12930
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##123900",
    GotoMode = {6020},
    BeginTime = "",
    EndTime = "2022-02-15 22:00:00"
  },
  [6048] = {
    id = 6048,
    NameEn = "##123918",
    Icon = "",
    Type = 1,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          ">",
          12936
        },
        {
          "id",
          "compare",
          "<",
          12941
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##123900",
    GotoMode = {6020},
    BeginTime = "",
    EndTime = "2022-02-15 22:00:00"
  },
  [6049] = {
    id = 6049,
    NameEn = "##123918",
    Icon = "",
    Type = 1,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          ">",
          12941
        },
        {
          "id",
          "compare",
          "<",
          12944
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##123900",
    GotoMode = {6020},
    BeginTime = "",
    EndTime = "2022-02-15 22:00:00"
  },
  [6050] = {
    id = 6050,
    NameEn = "##123918",
    Icon = "",
    Type = 1,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          ">",
          12945
        },
        {
          "id",
          "compare",
          "<",
          12948
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##123900",
    GotoMode = {6020},
    BeginTime = "",
    EndTime = "2022-02-15 22:00:00"
  },
  [6051] = {
    id = 6051,
    NameEn = "##123918",
    Icon = "",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          12921
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##123900",
    GotoMode = {6020},
    BeginTime = "",
    EndTime = "2022-02-15 22:00:00"
  },
  [6052] = {
    id = 6052,
    NameEn = "##123918",
    Icon = "",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          12932
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##123900",
    GotoMode = {6020},
    BeginTime = "",
    EndTime = "2022-02-15 22:00:00"
  },
  [6053] = {
    id = 6053,
    NameEn = "##123918",
    Icon = "",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          12935
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##123900",
    GotoMode = {6020},
    BeginTime = "",
    EndTime = "2022-02-15 22:00:00"
  },
  [6054] = {
    id = 6054,
    NameEn = "##123918",
    Icon = "",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          12950
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##123900",
    GotoMode = {6020},
    BeginTime = "",
    EndTime = "2022-02-15 22:00:00"
  },
  [6055] = {
    id = 6055,
    NameEn = "##123669",
    Icon = "pet_equip_3",
    Type = 1,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          ">",
          12909
        },
        {
          "id",
          "compare",
          "<",
          12912
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124205",
    GotoMode = {8017},
    BeginTime = "",
    EndTime = "2022-02-15 22:00:00"
  },
  [6056] = {
    id = 6056,
    NameEn = "##123669",
    Icon = "pet_equip_3",
    Type = 1,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          ">",
          12913
        },
        {
          "id",
          "compare",
          "<",
          12921
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124205",
    GotoMode = {8017},
    BeginTime = "",
    EndTime = "2022-02-15 22:00:00"
  },
  [6057] = {
    id = 6057,
    NameEn = "##123669",
    Icon = "pet_equip_3",
    Type = 1,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          ">",
          12929
        },
        {
          "id",
          "compare",
          "<",
          12932
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124205",
    GotoMode = {8017},
    BeginTime = "",
    EndTime = "2022-02-15 22:00:00"
  },
  [6058] = {
    id = 6058,
    NameEn = "##123669",
    Icon = "pet_equip_3",
    Type = 1,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          12922
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##124205",
    GotoMode = {8017},
    BeginTime = "",
    EndTime = "2022-02-15 22:00:00"
  },
  [6059] = {
    id = 6059,
    NameEn = "##123669",
    Icon = "MIntrusion",
    Type = 1,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          12905
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##289380",
    GotoMode = {8015},
    BeginTime = "",
    EndTime = ""
  },
  [6060] = {
    id = 6060,
    NameEn = "##123669",
    Icon = "MIntrusion",
    Type = 1,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          12905
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##289381",
    GotoMode = {8014},
    BeginTime = "",
    EndTime = ""
  },
  [6061] = {
    id = 6061,
    NameEn = "##141763",
    Icon = "Incantation_Samurai_2",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          54881
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##302630",
    GotoMode = {8015},
    BeginTime = "",
    EndTime = ""
  },
  [6062] = {
    id = 6062,
    NameEn = "##123918",
    Icon = "",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          900220
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##123900",
    GotoMode = {6020},
    BeginTime = "",
    EndTime = "2022-02-15 22:00:00"
  },
  [6063] = {
    id = 6063,
    NameEn = "##116287",
    Icon = "huangjing_icon02",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Shop",
      "items",
      {
        {
          "type",
          "compare",
          "=",
          420
        },
        {
          "ShopID",
          "compare",
          "=",
          1
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235283",
    GotoMode = {8171},
    BeginTime = "",
    EndTime = ""
  },
  [6064] = {
    id = 6064,
    NameEn = "##530671",
    Icon = "",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          6761
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##530685",
    GotoMode = {6022},
    BeginTime = "",
    EndTime = ""
  },
  [6065] = {
    id = 6065,
    NameEn = "##530674",
    Icon = "",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          6762
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1126129",
    GotoMode = {6026},
    BeginTime = "",
    EndTime = ""
  },
  [6066] = {
    id = 6066,
    NameEn = "##530671",
    Icon = "",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          6763
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##530685",
    GotoMode = {6022},
    BeginTime = "",
    EndTime = ""
  },
  [6067] = {
    id = 6067,
    NameEn = "##530686",
    Icon = "",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          6764
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1126130",
    GotoMode = {6027},
    BeginTime = "",
    EndTime = ""
  },
  [6068] = {
    id = 6068,
    NameEn = "##530674",
    Icon = "",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          6765
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##780991",
    GotoMode = {6030},
    BeginTime = "",
    EndTime = ""
  },
  [6069] = {
    id = 6069,
    NameEn = "##832721",
    Icon = "Quest",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          12903
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##832720",
    GotoMode = {5049},
    BeginTime = "",
    EndTime = ""
  },
  [6070] = {
    id = 6070,
    NameEn = "##531505",
    Icon = "Dungeon",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          7205
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##832722",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [6071] = {
    id = 6071,
    NameEn = "##1101196",
    Icon = "",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          47257
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1101197",
    GotoMode = {6022},
    BeginTime = "",
    EndTime = ""
  },
  [6072] = {
    id = 6072,
    NameEn = "##1101196",
    Icon = "",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          48763
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1101197",
    GotoMode = {6022},
    BeginTime = "",
    EndTime = ""
  },
  [6073] = {
    id = 6073,
    NameEn = "##1101196",
    Icon = "",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          48764
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1101197",
    GotoMode = {6022},
    BeginTime = "",
    EndTime = ""
  },
  [6074] = {
    id = 6074,
    NameEn = "##1101196",
    Icon = "",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          48112
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1101197",
    GotoMode = {6022},
    BeginTime = "",
    EndTime = ""
  },
  [6075] = {
    id = 6075,
    NameEn = "##1101196",
    Icon = "",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          49549
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1101197",
    GotoMode = {6022},
    BeginTime = "",
    EndTime = ""
  },
  [6076] = {
    id = 6076,
    NameEn = "##1111497",
    Icon = "",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          49550
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1123893",
    GotoMode = {6022},
    BeginTime = "",
    EndTime = ""
  },
  [6077] = {
    id = 6077,
    NameEn = "##1111497",
    Icon = "",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          49551
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1123893",
    GotoMode = {6022},
    BeginTime = "",
    EndTime = ""
  },
  [6078] = {
    id = 6078,
    NameEn = "##1101196",
    Icon = "",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          49552
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1101197",
    GotoMode = {6022},
    BeginTime = "",
    EndTime = ""
  },
  [6079] = {
    id = 6079,
    NameEn = "##1111497",
    Icon = "",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          47258
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1123893",
    GotoMode = {6022},
    BeginTime = "",
    EndTime = ""
  },
  [6080] = {
    id = 6080,
    NameEn = "##531884",
    Icon = "",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          7206
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1127197",
    GotoMode = {6022},
    BeginTime = "",
    EndTime = ""
  },
  [6082] = {
    id = 6082,
    NameEn = "##103154",
    Icon = "LotteryMech_Activity",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Lottery",
      "itemid",
      {
        {
          "type",
          "compare",
          "=",
          5
        },
        {
          "Weight",
          "compare",
          ">",
          0
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1123897",
    GotoMode = {92},
    BeginTime = "",
    EndTime = ""
  },
  [6083] = {
    id = 6083,
    NameEn = "##103154",
    Icon = "LotteryMech_Activity",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Lottery",
      "FemaleItemid",
      {
        {
          "type",
          "compare",
          "=",
          5
        },
        {
          "Weight",
          "compare",
          ">",
          0
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1123897",
    GotoMode = {92},
    BeginTime = "",
    EndTime = ""
  },
  [6084] = {
    id = 6084,
    NameEn = "##103154",
    Icon = "LotteryMech_Activity",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Lottery",
      "itemid",
      {
        {
          "type",
          "compare",
          "=",
          6
        },
        {
          "Weight",
          "compare",
          ">",
          0
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1123897",
    GotoMode = {92},
    BeginTime = "",
    EndTime = ""
  },
  [6085] = {
    id = 6085,
    NameEn = "##103154",
    Icon = "LotteryMech_Activity",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Lottery",
      "FemaleItemid",
      {
        {
          "type",
          "compare",
          "=",
          6
        },
        {
          "Weight",
          "compare",
          ">",
          0
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1123897",
    GotoMode = {92},
    BeginTime = "",
    EndTime = ""
  },
  [6086] = {
    id = 6086,
    NameEn = "##103154",
    Icon = "LotteryMech_Activity",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Lottery",
      "itemid",
      {
        {
          "type",
          "compare",
          "=",
          7
        },
        {
          "Weight",
          "compare",
          ">",
          0
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1123897",
    GotoMode = {92},
    BeginTime = "",
    EndTime = ""
  },
  [6087] = {
    id = 6087,
    NameEn = "##103154",
    Icon = "LotteryMech_Activity",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Lottery",
      "FemaleItemid",
      {
        {
          "type",
          "compare",
          "=",
          7
        },
        {
          "Weight",
          "compare",
          ">",
          0
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1123897",
    GotoMode = {92},
    BeginTime = "",
    EndTime = ""
  },
  [6089] = {
    id = 6089,
    NameEn = "##1111800",
    Icon = "",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          7207
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1127198",
    GotoMode = {6022},
    BeginTime = "",
    EndTime = ""
  },
  [6090] = {
    id = 6090,
    NameEn = "##106129",
    Icon = "Longhai",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          6829
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##123965",
    GotoMode = {8017},
    BeginTime = "",
    EndTime = ""
  },
  [6091] = {
    id = 6091,
    NameEn = "##141763",
    Icon = "Incantation_Samurai_2",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          6829
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##302630",
    GotoMode = {8015},
    BeginTime = "",
    EndTime = ""
  },
  [6092] = {
    id = 6092,
    NameEn = "##1110862",
    Icon = "Crane_machine2",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Lottery",
      "itemid",
      {
        {
          "type",
          "compare",
          "=",
          9
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1131118",
    GotoMode = {31200},
    BeginTime = "",
    EndTime = ""
  },
  [6093] = {
    id = 6093,
    NameEn = "##1110862",
    Icon = "Crane_machine2",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Lottery",
      "FemaleItemid",
      {
        {
          "type",
          "compare",
          "=",
          9
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1131118",
    GotoMode = {31200},
    BeginTime = "",
    EndTime = ""
  },
  [6094] = {
    id = 6094,
    NameEn = "##1110862",
    Icon = "Crane_machine2",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Lottery",
      "itemid",
      {
        {
          "type",
          "compare",
          "=",
          10
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1131118",
    GotoMode = {31200},
    BeginTime = "",
    EndTime = ""
  },
  [6095] = {
    id = 6095,
    NameEn = "##1110862",
    Icon = "Crane_machine2",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Lottery",
      "FemaleItemid",
      {
        {
          "type",
          "compare",
          "=",
          10
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1131118",
    GotoMode = {31200},
    BeginTime = "",
    EndTime = ""
  },
  [6096] = {
    id = 6096,
    NameEn = "##1110862",
    Icon = "Crane_machine2",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Lottery",
      "itemid",
      {
        {
          "type",
          "compare",
          "=",
          11
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1131118",
    GotoMode = {31200},
    BeginTime = "",
    EndTime = ""
  },
  [6097] = {
    id = 6097,
    NameEn = "##1110862",
    Icon = "Crane_machine2",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Lottery",
      "FemaleItemid",
      {
        {
          "type",
          "compare",
          "=",
          11
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1131118",
    GotoMode = {31200},
    BeginTime = "",
    EndTime = ""
  },
  [6098] = {
    id = 6098,
    NameEn = "##1134064",
    Icon = "ManorBuild_03",
    Type = 1,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          ">",
          31799
        },
        {
          "id",
          "compare",
          "<",
          31815
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1134488",
    GotoMode = {8109},
    BeginTime = "",
    EndTime = ""
  },
  [6099] = {
    id = 6099,
    NameEn = "##1134064",
    Icon = "ManorBuild_03",
    Type = 1,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          ">",
          3003789
        },
        {
          "id",
          "compare",
          "<",
          3003797
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1134488",
    GotoMode = {8109},
    BeginTime = "",
    EndTime = ""
  },
  [6100] = {
    id = 6100,
    NameEn = "##1134057",
    Icon = "ManorBuild_02",
    Type = 1,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          ">",
          13310
        },
        {
          "id",
          "compare",
          "<",
          13312
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1134490",
    GotoMode = {8111},
    BeginTime = "",
    EndTime = ""
  },
  [6101] = {
    id = 6101,
    NameEn = "##1134491",
    Icon = "ManorBuild_06",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          13313
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1134492",
    GotoMode = {8112},
    BeginTime = "",
    EndTime = ""
  },
  [6102] = {
    id = 6102,
    NameEn = "##1110981",
    Icon = "ManorBuild_07",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          13314
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1134493",
    GotoMode = {8113},
    BeginTime = "",
    EndTime = ""
  },
  [6103] = {
    id = 6103,
    NameEn = "##1134494",
    Icon = "ManorBuildType_09",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          13312
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1134495",
    GotoMode = {8107},
    BeginTime = "",
    EndTime = ""
  },
  [6104] = {
    id = 6104,
    NameEn = "##1134057",
    Icon = "ManorBuild_02",
    Type = 1,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          ">",
          13312
        },
        {
          "id",
          "compare",
          "<",
          13315
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1134490",
    GotoMode = {8111},
    BeginTime = "",
    EndTime = ""
  },
  [6105] = {
    id = 6105,
    NameEn = "##117302",
    Icon = "Wanted",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          3004829
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1180411",
    GotoMode = {
      1,
      901,
      902,
      903,
      904,
      905,
      906,
      907,
      908,
      909,
      910,
      911,
      912,
      913
    },
    BeginTime = "",
    EndTime = ""
  },
  [6106] = {
    id = 6106,
    NameEn = "##117582",
    Icon = "item_6509",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          3004829
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1180412",
    GotoMode = {31295},
    BeginTime = "",
    EndTime = ""
  },
  [6107] = {
    id = 6107,
    NameEn = "##1208052",
    Icon = "jianbei",
    Type = 1,
    Materialdisplay = 0,
    Search1 = {
      "Table_Reward",
      "item",
      {
        {
          "team",
          "compare",
          ">",
          9233000
        },
        {
          "team",
          "compare",
          "<",
          9233026
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1208053",
    GotoMode = {8147},
    menu = 10030,
    BeginTime = "",
    EndTime = ""
  },
  [6108] = {
    id = 6108,
    NameEn = "##137653",
    Icon = "RiskBook",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          31900
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1211844",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [6109] = {
    id = 6109,
    NameEn = "##1208052",
    Icon = "jianbei",
    Type = 1,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          ">",
          31918
        },
        {
          "id",
          "compare",
          "<",
          31924
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1208053",
    GotoMode = {8147},
    menu = 10030,
    BeginTime = "",
    EndTime = ""
  },
  [6110] = {
    id = 6110,
    NameEn = "##1224335",
    Icon = "",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Pet",
      "EggID",
      {
        {
          "accessway",
          "compare",
          "=",
          8
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1224336",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [6111] = {
    id = 6111,
    NameEn = "##1208054",
    Icon = "Quest",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          6884
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1208059",
    GotoMode = {8147},
    BeginTime = "",
    EndTime = ""
  },
  [6112] = {
    id = 6112,
    NameEn = "##123694",
    Icon = "126",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          ">",
          500631
        },
        {
          "id",
          "compare",
          "<",
          500643
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##304411",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [6113] = {
    id = 6113,
    NameEn = "##1216478",
    Icon = "xunshoudui",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          500631
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1216478",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [6114] = {
    id = 6114,
    NameEn = "##1235284",
    Icon = "raidbgicon_liexi06",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          12900
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235285",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [6115] = {
    id = 6115,
    NameEn = "##1235284",
    Icon = "raidbgicon_liexi06",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          12902
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235285",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [6116] = {
    id = 6116,
    NameEn = "##1235288",
    Icon = "raidbgicon_liexi07",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          12900
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235289",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [6117] = {
    id = 6117,
    NameEn = "##1235288",
    Icon = "raidbgicon_liexi07",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          12902
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235289",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [6118] = {
    id = 6118,
    NameEn = "##1235292",
    Icon = "raidbgicon_liexi08",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          12900
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235293",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [6119] = {
    id = 6119,
    NameEn = "##1235292",
    Icon = "raidbgicon_liexi08",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          12902
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235293",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [6120] = {
    id = 6120,
    NameEn = "##1235296",
    Icon = "Shopping",
    Type = 1,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          6896
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1134485",
    GotoMode = {1703},
    BeginTime = "",
    EndTime = ""
  },
  [6121] = {
    id = 6121,
    NameEn = "##1235284",
    Icon = "raidbgicon_liexi06",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          42184
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235298",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6122] = {
    id = 6122,
    NameEn = "##1235284",
    Icon = "raidbgicon_liexi06",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          42672
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235298",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6123] = {
    id = 6123,
    NameEn = "##1235284",
    Icon = "raidbgicon_liexi06",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          43100
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235298",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6124] = {
    id = 6124,
    NameEn = "##1235284",
    Icon = "raidbgicon_liexi06",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          43622
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235298",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6125] = {
    id = 6125,
    NameEn = "##1235284",
    Icon = "raidbgicon_liexi06",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          44138
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235298",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6126] = {
    id = 6126,
    NameEn = "##1235284",
    Icon = "raidbgicon_liexi06",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          44139
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235298",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6127] = {
    id = 6127,
    NameEn = "##1235284",
    Icon = "raidbgicon_liexi06",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          142184
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235298",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6128] = {
    id = 6128,
    NameEn = "##1235284",
    Icon = "raidbgicon_liexi06",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          142672
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235298",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6129] = {
    id = 6129,
    NameEn = "##1235284",
    Icon = "raidbgicon_liexi06",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          143100
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235298",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6130] = {
    id = 6130,
    NameEn = "##1235284",
    Icon = "raidbgicon_liexi06",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          143622
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235298",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6131] = {
    id = 6131,
    NameEn = "##1235284",
    Icon = "raidbgicon_liexi06",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          144138
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235298",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6132] = {
    id = 6132,
    NameEn = "##1235284",
    Icon = "raidbgicon_liexi06",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          144139
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235298",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6133] = {
    id = 6133,
    NameEn = "##1235288",
    Icon = "raidbgicon_liexi07",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          42184
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235298",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6134] = {
    id = 6134,
    NameEn = "##1235288",
    Icon = "raidbgicon_liexi07",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          42672
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235298",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6135] = {
    id = 6135,
    NameEn = "##1235288",
    Icon = "raidbgicon_liexi07",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          43100
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235298",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6136] = {
    id = 6136,
    NameEn = "##1235288",
    Icon = "raidbgicon_liexi07",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          43622
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235298",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6137] = {
    id = 6137,
    NameEn = "##1235288",
    Icon = "raidbgicon_liexi07",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          44138
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235298",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6138] = {
    id = 6138,
    NameEn = "##1235288",
    Icon = "raidbgicon_liexi07",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          44139
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235298",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6139] = {
    id = 6139,
    NameEn = "##1235288",
    Icon = "raidbgicon_liexi07",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          142184
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235298",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6140] = {
    id = 6140,
    NameEn = "##1235288",
    Icon = "raidbgicon_liexi07",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          142672
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235298",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6141] = {
    id = 6141,
    NameEn = "##1235288",
    Icon = "raidbgicon_liexi07",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          143100
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235298",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6142] = {
    id = 6142,
    NameEn = "##1235288",
    Icon = "raidbgicon_liexi07",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          143622
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235298",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6143] = {
    id = 6143,
    NameEn = "##1235288",
    Icon = "raidbgicon_liexi07",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          144138
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235298",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6144] = {
    id = 6144,
    NameEn = "##1235288",
    Icon = "raidbgicon_liexi07",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          144139
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235298",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6145] = {
    id = 6145,
    NameEn = "##1235292",
    Icon = "raidbgicon_liexi08",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          42184
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235298",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6146] = {
    id = 6146,
    NameEn = "##1235292",
    Icon = "raidbgicon_liexi08",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          42672
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235298",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6147] = {
    id = 6147,
    NameEn = "##1235292",
    Icon = "raidbgicon_liexi08",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          43100
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235298",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6148] = {
    id = 6148,
    NameEn = "##1235292",
    Icon = "raidbgicon_liexi08",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          43622
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235298",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6149] = {
    id = 6149,
    NameEn = "##1235292",
    Icon = "raidbgicon_liexi08",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          44138
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235298",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6150] = {
    id = 6150,
    NameEn = "##1235292",
    Icon = "raidbgicon_liexi08",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          44139
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235298",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6151] = {
    id = 6151,
    NameEn = "##1235292",
    Icon = "raidbgicon_liexi08",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          142184
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235298",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6152] = {
    id = 6152,
    NameEn = "##1235292",
    Icon = "raidbgicon_liexi08",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          142672
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235298",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6153] = {
    id = 6153,
    NameEn = "##1235292",
    Icon = "raidbgicon_liexi08",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          143100
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235298",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6154] = {
    id = 6154,
    NameEn = "##1235292",
    Icon = "raidbgicon_liexi08",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          143622
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235298",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6155] = {
    id = 6155,
    NameEn = "##1235292",
    Icon = "raidbgicon_liexi08",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          144138
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235298",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6156] = {
    id = 6156,
    NameEn = "##1235292",
    Icon = "raidbgicon_liexi08",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          144139
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235298",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6157] = {
    id = 6157,
    NameEn = "##1235284",
    Icon = "raidbgicon_liexi06",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          ">",
          43100
        },
        {
          "id",
          "compare",
          "<",
          43106
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235370",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6158] = {
    id = 6158,
    NameEn = "##1235284",
    Icon = "raidbgicon_liexi06",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          ">",
          43622
        },
        {
          "id",
          "compare",
          "<",
          43628
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235370",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6159] = {
    id = 6159,
    NameEn = "##1235284",
    Icon = "raidbgicon_liexi06",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          ">",
          143100
        },
        {
          "id",
          "compare",
          "<",
          143106
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235370",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6160] = {
    id = 6160,
    NameEn = "##1235284",
    Icon = "raidbgicon_liexi06",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          ">",
          143622
        },
        {
          "id",
          "compare",
          "<",
          143628
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235370",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6161] = {
    id = 6161,
    NameEn = "##1235288",
    Icon = "raidbgicon_liexi07",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          ">",
          42184
        },
        {
          "id",
          "compare",
          "<",
          42190
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235370",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6162] = {
    id = 6162,
    NameEn = "##1235288",
    Icon = "raidbgicon_liexi07",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          ">",
          42672
        },
        {
          "id",
          "compare",
          "<",
          42678
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235370",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6163] = {
    id = 6163,
    NameEn = "##1235288",
    Icon = "raidbgicon_liexi07",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          ">",
          142184
        },
        {
          "id",
          "compare",
          "<",
          142190
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235370",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6164] = {
    id = 6164,
    NameEn = "##1235288",
    Icon = "raidbgicon_liexi07",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          ">",
          142672
        },
        {
          "id",
          "compare",
          "<",
          142678
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235370",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6165] = {
    id = 6165,
    NameEn = "##1235292",
    Icon = "raidbgicon_liexi08",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          ">",
          44139
        },
        {
          "id",
          "compare",
          "<",
          44148
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235370",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6166] = {
    id = 6166,
    NameEn = "##1235292",
    Icon = "raidbgicon_liexi08",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          ">",
          144139
        },
        {
          "id",
          "compare",
          "<",
          144148
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235370",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6167] = {
    id = 6167,
    NameEn = "##1233649",
    Icon = "Shopping",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          42184
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235389",
    GotoMode = {8178},
    BeginTime = "",
    EndTime = ""
  },
  [6168] = {
    id = 6168,
    NameEn = "##1233649",
    Icon = "Shopping",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          42672
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235389",
    GotoMode = {8178},
    BeginTime = "",
    EndTime = ""
  },
  [6169] = {
    id = 6169,
    NameEn = "##1233649",
    Icon = "Shopping",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          43100
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235389",
    GotoMode = {8178},
    BeginTime = "",
    EndTime = ""
  },
  [6170] = {
    id = 6170,
    NameEn = "##1233649",
    Icon = "Shopping",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          43622
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235389",
    GotoMode = {8178},
    BeginTime = "",
    EndTime = ""
  },
  [6171] = {
    id = 6171,
    NameEn = "##1233649",
    Icon = "Shopping",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          44138
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235389",
    GotoMode = {8178},
    BeginTime = "",
    EndTime = ""
  },
  [6172] = {
    id = 6172,
    NameEn = "##1233649",
    Icon = "Shopping",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          44139
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235389",
    GotoMode = {8178},
    BeginTime = "",
    EndTime = ""
  },
  [6173] = {
    id = 6173,
    NameEn = "##1233649",
    Icon = "Shopping",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          142184
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235389",
    GotoMode = {8178},
    BeginTime = "",
    EndTime = ""
  },
  [6174] = {
    id = 6174,
    NameEn = "##1233649",
    Icon = "Shopping",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          142672
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235389",
    GotoMode = {8178},
    BeginTime = "",
    EndTime = ""
  },
  [6175] = {
    id = 6175,
    NameEn = "##1233649",
    Icon = "Shopping",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          143100
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235389",
    GotoMode = {8178},
    BeginTime = "",
    EndTime = ""
  },
  [6176] = {
    id = 6176,
    NameEn = "##1233649",
    Icon = "Shopping",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          143622
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235389",
    GotoMode = {8178},
    BeginTime = "",
    EndTime = ""
  },
  [6177] = {
    id = 6177,
    NameEn = "##1233649",
    Icon = "Shopping",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          144138
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235389",
    GotoMode = {8178},
    BeginTime = "",
    EndTime = ""
  },
  [6178] = {
    id = 6178,
    NameEn = "##1233649",
    Icon = "Shopping",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          144139
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235389",
    GotoMode = {8178},
    BeginTime = "",
    EndTime = ""
  },
  [6179] = {
    id = 6179,
    NameEn = "##1233649",
    Icon = "Shopping",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          ">",
          42184
        },
        {
          "id",
          "compare",
          "<",
          42190
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235389",
    GotoMode = {8178},
    BeginTime = "",
    EndTime = ""
  },
  [6180] = {
    id = 6180,
    NameEn = "##1233649",
    Icon = "Shopping",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          ">",
          42672
        },
        {
          "id",
          "compare",
          "<",
          42678
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235389",
    GotoMode = {8178},
    BeginTime = "",
    EndTime = ""
  },
  [6181] = {
    id = 6181,
    NameEn = "##1233649",
    Icon = "Shopping",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          ">",
          43100
        },
        {
          "id",
          "compare",
          "<",
          43106
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235389",
    GotoMode = {8178},
    BeginTime = "",
    EndTime = ""
  },
  [6182] = {
    id = 6182,
    NameEn = "##1233649",
    Icon = "Shopping",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          ">",
          43622
        },
        {
          "id",
          "compare",
          "<",
          43628
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235389",
    GotoMode = {8178},
    BeginTime = "",
    EndTime = ""
  },
  [6183] = {
    id = 6183,
    NameEn = "##1233649",
    Icon = "Shopping",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          ">",
          44139
        },
        {
          "id",
          "compare",
          "<",
          44148
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235389",
    GotoMode = {8178},
    BeginTime = "",
    EndTime = ""
  },
  [6184] = {
    id = 6184,
    NameEn = "##1233649",
    Icon = "Shopping",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          ">",
          142184
        },
        {
          "id",
          "compare",
          "<",
          142190
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235389",
    GotoMode = {8178},
    BeginTime = "",
    EndTime = ""
  },
  [6185] = {
    id = 6185,
    NameEn = "##1233649",
    Icon = "Shopping",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          ">",
          142672
        },
        {
          "id",
          "compare",
          "<",
          142678
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235389",
    GotoMode = {8178},
    BeginTime = "",
    EndTime = ""
  },
  [6186] = {
    id = 6186,
    NameEn = "##1233649",
    Icon = "Shopping",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          ">",
          143100
        },
        {
          "id",
          "compare",
          "<",
          143106
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235389",
    GotoMode = {8178},
    BeginTime = "",
    EndTime = ""
  },
  [6187] = {
    id = 6187,
    NameEn = "##1233649",
    Icon = "Shopping",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          ">",
          143622
        },
        {
          "id",
          "compare",
          "<",
          143628
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235389",
    GotoMode = {8178},
    BeginTime = "",
    EndTime = ""
  },
  [6188] = {
    id = 6188,
    NameEn = "##1233649",
    Icon = "Shopping",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          ">",
          144139
        },
        {
          "id",
          "compare",
          "<",
          144148
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235389",
    GotoMode = {8178},
    BeginTime = "",
    EndTime = ""
  },
  [6189] = {
    id = 6189,
    NameEn = "##1242192",
    Icon = "Shopping",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          900271
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1242192",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [6190] = {
    id = 6190,
    NameEn = "##1112444",
    Icon = "Shopping",
    Type = 1,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          6916
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1134485",
    GotoMode = {1704},
    BeginTime = "",
    EndTime = ""
  },
  [6191] = {
    id = 6191,
    NameEn = "##1243278",
    Icon = "Shopping",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          42679
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1243279",
    GotoMode = {1704},
    BeginTime = "",
    EndTime = ""
  },
  [6192] = {
    id = 6192,
    NameEn = "##1243278",
    Icon = "Shopping",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          42685
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1243279",
    GotoMode = {1704},
    BeginTime = "",
    EndTime = ""
  },
  [6193] = {
    id = 6193,
    NameEn = "##1243278",
    Icon = "Shopping",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          42686
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1243279",
    GotoMode = {1704},
    BeginTime = "",
    EndTime = ""
  },
  [6194] = {
    id = 6194,
    NameEn = "##1243278",
    Icon = "Shopping",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          42191
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1243279",
    GotoMode = {1704},
    BeginTime = "",
    EndTime = ""
  },
  [6195] = {
    id = 6195,
    NameEn = "##1243278",
    Icon = "Shopping",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          42197
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1243279",
    GotoMode = {1704},
    BeginTime = "",
    EndTime = ""
  },
  [6196] = {
    id = 6196,
    NameEn = "##1243278",
    Icon = "Shopping",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          42198
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1243279",
    GotoMode = {1704},
    BeginTime = "",
    EndTime = ""
  },
  [6197] = {
    id = 6197,
    NameEn = "##1243278",
    Icon = "Shopping",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          43629
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1243279",
    GotoMode = {1704},
    BeginTime = "",
    EndTime = ""
  },
  [6198] = {
    id = 6198,
    NameEn = "##1243278",
    Icon = "Shopping",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          43635
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1243279",
    GotoMode = {1704},
    BeginTime = "",
    EndTime = ""
  },
  [6199] = {
    id = 6199,
    NameEn = "##1243278",
    Icon = "Shopping",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          43636
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1243279",
    GotoMode = {1704},
    BeginTime = "",
    EndTime = ""
  },
  [6200] = {
    id = 6200,
    NameEn = "##1243278",
    Icon = "Shopping",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          44148
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1243279",
    GotoMode = {1704},
    BeginTime = "",
    EndTime = ""
  },
  [6201] = {
    id = 6201,
    NameEn = "##1243278",
    Icon = "Shopping",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          44149
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1243279",
    GotoMode = {1704},
    BeginTime = "",
    EndTime = ""
  },
  [6202] = {
    id = 6202,
    NameEn = "##1243278",
    Icon = "Shopping",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          ">",
          44155
        },
        {
          "id",
          "compare",
          "<",
          44159
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1243279",
    GotoMode = {1704},
    BeginTime = "",
    EndTime = ""
  },
  [6203] = {
    id = 6203,
    NameEn = "##1243278",
    Icon = "Shopping",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          44163
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1243279",
    GotoMode = {1704},
    BeginTime = "",
    EndTime = ""
  },
  [6204] = {
    id = 6204,
    NameEn = "##1243278",
    Icon = "Shopping",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          43107
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1243279",
    GotoMode = {1704},
    BeginTime = "",
    EndTime = ""
  },
  [6205] = {
    id = 6205,
    NameEn = "##1243278",
    Icon = "Shopping",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          43113
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1243279",
    GotoMode = {1704},
    BeginTime = "",
    EndTime = ""
  },
  [6206] = {
    id = 6206,
    NameEn = "##1243278",
    Icon = "Shopping",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          43114
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1243279",
    GotoMode = {1704},
    BeginTime = "",
    EndTime = ""
  },
  [6207] = {
    id = 6207,
    NameEn = "##1243278",
    Icon = "Shopping",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          142679
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1243279",
    GotoMode = {1704},
    BeginTime = "",
    EndTime = ""
  },
  [6208] = {
    id = 6208,
    NameEn = "##1243278",
    Icon = "Shopping",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          142685
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1243279",
    GotoMode = {1704},
    BeginTime = "",
    EndTime = ""
  },
  [6209] = {
    id = 6209,
    NameEn = "##1243278",
    Icon = "Shopping",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          142686
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1243279",
    GotoMode = {1704},
    BeginTime = "",
    EndTime = ""
  },
  [6210] = {
    id = 6210,
    NameEn = "##1243278",
    Icon = "Shopping",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          142191
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1243279",
    GotoMode = {1704},
    BeginTime = "",
    EndTime = ""
  },
  [6211] = {
    id = 6211,
    NameEn = "##1243278",
    Icon = "Shopping",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          142197
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1243279",
    GotoMode = {1704},
    BeginTime = "",
    EndTime = ""
  },
  [6212] = {
    id = 6212,
    NameEn = "##1243278",
    Icon = "Shopping",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          142198
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1243279",
    GotoMode = {1704},
    BeginTime = "",
    EndTime = ""
  },
  [6213] = {
    id = 6213,
    NameEn = "##1243278",
    Icon = "Shopping",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          143629
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1243279",
    GotoMode = {1704},
    BeginTime = "",
    EndTime = ""
  },
  [6214] = {
    id = 6214,
    NameEn = "##1243278",
    Icon = "Shopping",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          143635
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1243279",
    GotoMode = {1704},
    BeginTime = "",
    EndTime = ""
  },
  [6215] = {
    id = 6215,
    NameEn = "##1243278",
    Icon = "Shopping",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          143636
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1243279",
    GotoMode = {1704},
    BeginTime = "",
    EndTime = ""
  },
  [6216] = {
    id = 6216,
    NameEn = "##1243278",
    Icon = "Shopping",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          144148
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1243279",
    GotoMode = {1704},
    BeginTime = "",
    EndTime = ""
  },
  [6217] = {
    id = 6217,
    NameEn = "##1243278",
    Icon = "Shopping",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          144149
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1243279",
    GotoMode = {1704},
    BeginTime = "",
    EndTime = ""
  },
  [6218] = {
    id = 6218,
    NameEn = "##1243278",
    Icon = "Shopping",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          ">",
          144155
        },
        {
          "id",
          "compare",
          "<",
          144159
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1243279",
    GotoMode = {1704},
    BeginTime = "",
    EndTime = ""
  },
  [6219] = {
    id = 6219,
    NameEn = "##1243278",
    Icon = "Shopping",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          144163
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1243279",
    GotoMode = {1704},
    BeginTime = "",
    EndTime = ""
  },
  [6220] = {
    id = 6220,
    NameEn = "##1243278",
    Icon = "Shopping",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          143107
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1243279",
    GotoMode = {1704},
    BeginTime = "",
    EndTime = ""
  },
  [6221] = {
    id = 6221,
    NameEn = "##1243278",
    Icon = "Shopping",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          143113
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1243279",
    GotoMode = {1704},
    BeginTime = "",
    EndTime = ""
  },
  [6222] = {
    id = 6222,
    NameEn = "##1243278",
    Icon = "Shopping",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          143114
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1243279",
    GotoMode = {1704},
    BeginTime = "",
    EndTime = ""
  },
  [6223] = {
    id = 6223,
    NameEn = "##1243342",
    Icon = "raidbgicon_liexi01",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          42679
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235298",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6224] = {
    id = 6224,
    NameEn = "##1243342",
    Icon = "raidbgicon_liexi01",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          42191
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235298",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6225] = {
    id = 6225,
    NameEn = "##1243342",
    Icon = "raidbgicon_liexi01",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          43629
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235298",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6226] = {
    id = 6226,
    NameEn = "##1243342",
    Icon = "raidbgicon_liexi01",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          43107
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235298",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6227] = {
    id = 6227,
    NameEn = "##1243342",
    Icon = "raidbgicon_liexi01",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          44148
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235298",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6228] = {
    id = 6228,
    NameEn = "##1243342",
    Icon = "raidbgicon_liexi01",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          44149
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235298",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6229] = {
    id = 6229,
    NameEn = "##1243342",
    Icon = "raidbgicon_liexi01",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          142679
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235298",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6230] = {
    id = 6230,
    NameEn = "##1243342",
    Icon = "raidbgicon_liexi01",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          142191
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235298",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6231] = {
    id = 6231,
    NameEn = "##1243342",
    Icon = "raidbgicon_liexi01",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          143629
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235298",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6232] = {
    id = 6232,
    NameEn = "##1243342",
    Icon = "raidbgicon_liexi01",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          143107
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235298",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6233] = {
    id = 6233,
    NameEn = "##1243342",
    Icon = "raidbgicon_liexi01",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          144148
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235298",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6234] = {
    id = 6234,
    NameEn = "##1243342",
    Icon = "raidbgicon_liexi01",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          144149
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235298",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6235] = {
    id = 6235,
    NameEn = "##1243354",
    Icon = "raidbgicon_liexi02",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          42679
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235298",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6236] = {
    id = 6236,
    NameEn = "##1243354",
    Icon = "raidbgicon_liexi02",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          42191
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235298",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6237] = {
    id = 6237,
    NameEn = "##1243354",
    Icon = "raidbgicon_liexi02",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          43629
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235298",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6238] = {
    id = 6238,
    NameEn = "##1243354",
    Icon = "raidbgicon_liexi02",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          43107
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235298",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6239] = {
    id = 6239,
    NameEn = "##1243354",
    Icon = "raidbgicon_liexi02",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          44148
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235298",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6240] = {
    id = 6240,
    NameEn = "##1243354",
    Icon = "raidbgicon_liexi02",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          44149
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235298",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6241] = {
    id = 6241,
    NameEn = "##1243354",
    Icon = "raidbgicon_liexi02",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          142679
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235298",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6242] = {
    id = 6242,
    NameEn = "##1243354",
    Icon = "raidbgicon_liexi02",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          142191
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235298",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6243] = {
    id = 6243,
    NameEn = "##1243354",
    Icon = "raidbgicon_liexi02",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          143629
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235298",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6244] = {
    id = 6244,
    NameEn = "##1243354",
    Icon = "raidbgicon_liexi02",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          143107
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235298",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6245] = {
    id = 6245,
    NameEn = "##1243354",
    Icon = "raidbgicon_liexi02",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          144148
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235298",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6246] = {
    id = 6246,
    NameEn = "##1243354",
    Icon = "raidbgicon_liexi02",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          144149
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235298",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6247] = {
    id = 6247,
    NameEn = "##1243366",
    Icon = "raidbgicon_liexi03",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          42685
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235298",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6248] = {
    id = 6248,
    NameEn = "##1243366",
    Icon = "raidbgicon_liexi03",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          42197
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235298",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6249] = {
    id = 6249,
    NameEn = "##1243366",
    Icon = "raidbgicon_liexi03",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          43635
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235298",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6250] = {
    id = 6250,
    NameEn = "##1243366",
    Icon = "raidbgicon_liexi03",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          43113
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235298",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6251] = {
    id = 6251,
    NameEn = "##1243366",
    Icon = "raidbgicon_liexi03",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          44156
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235298",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6252] = {
    id = 6252,
    NameEn = "##1243366",
    Icon = "raidbgicon_liexi03",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          44157
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235298",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6253] = {
    id = 6253,
    NameEn = "##1243366",
    Icon = "raidbgicon_liexi03",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          142685
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235298",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6254] = {
    id = 6254,
    NameEn = "##1243366",
    Icon = "raidbgicon_liexi03",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          142197
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235298",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6255] = {
    id = 6255,
    NameEn = "##1243366",
    Icon = "raidbgicon_liexi03",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          143635
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235298",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6256] = {
    id = 6256,
    NameEn = "##1243366",
    Icon = "raidbgicon_liexi03",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          143113
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235298",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6257] = {
    id = 6257,
    NameEn = "##1243366",
    Icon = "raidbgicon_liexi03",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          144156
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235298",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6258] = {
    id = 6258,
    NameEn = "##1243366",
    Icon = "raidbgicon_liexi03",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          144157
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235298",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6259] = {
    id = 6259,
    NameEn = "##1243378",
    Icon = "raidbgicon_liexi04",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          42685
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235298",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6260] = {
    id = 6260,
    NameEn = "##1243378",
    Icon = "raidbgicon_liexi04",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          42197
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235298",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6261] = {
    id = 6261,
    NameEn = "##1243378",
    Icon = "raidbgicon_liexi04",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          43635
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235298",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6262] = {
    id = 6262,
    NameEn = "##1243378",
    Icon = "raidbgicon_liexi04",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          43113
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235298",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6263] = {
    id = 6263,
    NameEn = "##1243378",
    Icon = "raidbgicon_liexi04",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          44156
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235298",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6264] = {
    id = 6264,
    NameEn = "##1243378",
    Icon = "raidbgicon_liexi04",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          44157
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235298",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6265] = {
    id = 6265,
    NameEn = "##1243378",
    Icon = "raidbgicon_liexi04",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          142685
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235298",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6266] = {
    id = 6266,
    NameEn = "##1243378",
    Icon = "raidbgicon_liexi04",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          142197
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235298",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6267] = {
    id = 6267,
    NameEn = "##1243378",
    Icon = "raidbgicon_liexi04",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          143635
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235298",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6268] = {
    id = 6268,
    NameEn = "##1243378",
    Icon = "raidbgicon_liexi04",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          143113
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235298",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6269] = {
    id = 6269,
    NameEn = "##1243378",
    Icon = "raidbgicon_liexi04",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          144156
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235298",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6270] = {
    id = 6270,
    NameEn = "##1243378",
    Icon = "raidbgicon_liexi04",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          144157
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235298",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6271] = {
    id = 6271,
    NameEn = "##1243390",
    Icon = "raidbgicon_liexi05",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          42685
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235298",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6272] = {
    id = 6272,
    NameEn = "##1243390",
    Icon = "raidbgicon_liexi05",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          42197
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235298",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6273] = {
    id = 6273,
    NameEn = "##1243390",
    Icon = "raidbgicon_liexi05",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          43635
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235298",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6274] = {
    id = 6274,
    NameEn = "##1243390",
    Icon = "raidbgicon_liexi05",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          43113
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235298",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6275] = {
    id = 6275,
    NameEn = "##1243390",
    Icon = "raidbgicon_liexi05",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          44156
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235298",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6276] = {
    id = 6276,
    NameEn = "##1243390",
    Icon = "raidbgicon_liexi05",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          44157
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235298",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6277] = {
    id = 6277,
    NameEn = "##1243390",
    Icon = "raidbgicon_liexi05",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          142685
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235298",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6278] = {
    id = 6278,
    NameEn = "##1243390",
    Icon = "raidbgicon_liexi05",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          142197
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235298",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6279] = {
    id = 6279,
    NameEn = "##1243390",
    Icon = "raidbgicon_liexi05",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          143635
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235298",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6280] = {
    id = 6280,
    NameEn = "##1243390",
    Icon = "raidbgicon_liexi05",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          143113
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235298",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6281] = {
    id = 6281,
    NameEn = "##1243390",
    Icon = "raidbgicon_liexi05",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          144156
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235298",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6282] = {
    id = 6282,
    NameEn = "##1243390",
    Icon = "raidbgicon_liexi05",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          144157
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235298",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6283] = {
    id = 6283,
    NameEn = "##1243342",
    Icon = "raidbgicon_liexi01",
    Type = 1,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          ">",
          42679
        },
        {
          "id",
          "compare",
          "<",
          42685
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235370",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6284] = {
    id = 6284,
    NameEn = "##1243342",
    Icon = "raidbgicon_liexi01",
    Type = 1,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          ">",
          42191
        },
        {
          "id",
          "compare",
          "<",
          42197
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235370",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6285] = {
    id = 6285,
    NameEn = "##1243342",
    Icon = "raidbgicon_liexi01",
    Type = 1,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          ">",
          43107
        },
        {
          "id",
          "compare",
          "<",
          43113
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235370",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6286] = {
    id = 6286,
    NameEn = "##1243342",
    Icon = "raidbgicon_liexi01",
    Type = 1,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          ">",
          142679
        },
        {
          "id",
          "compare",
          "<",
          142685
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235370",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6287] = {
    id = 6287,
    NameEn = "##1243342",
    Icon = "raidbgicon_liexi01",
    Type = 1,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          ">",
          142191
        },
        {
          "id",
          "compare",
          "<",
          142197
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235370",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6288] = {
    id = 6288,
    NameEn = "##1243342",
    Icon = "raidbgicon_liexi01",
    Type = 1,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          ">",
          143107
        },
        {
          "id",
          "compare",
          "<",
          143113
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235370",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6289] = {
    id = 6289,
    NameEn = "##1243354",
    Icon = "raidbgicon_liexi02",
    Type = 1,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          ">",
          44149
        },
        {
          "id",
          "compare",
          "<",
          44156
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235370",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6290] = {
    id = 6290,
    NameEn = "##1243354",
    Icon = "raidbgicon_liexi02",
    Type = 1,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          ">",
          43629
        },
        {
          "id",
          "compare",
          "<",
          43635
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235370",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6291] = {
    id = 6291,
    NameEn = "##1243354",
    Icon = "raidbgicon_liexi02",
    Type = 1,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          ">",
          144149
        },
        {
          "id",
          "compare",
          "<",
          144156
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235370",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6292] = {
    id = 6292,
    NameEn = "##1243354",
    Icon = "raidbgicon_liexi02",
    Type = 1,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          ">",
          143629
        },
        {
          "id",
          "compare",
          "<",
          143635
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235370",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6293] = {
    id = 6293,
    NameEn = "##1243366",
    Icon = "raidbgicon_liexi03",
    Type = 1,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          ">",
          42685
        },
        {
          "id",
          "compare",
          "<",
          42691
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235370",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6294] = {
    id = 6294,
    NameEn = "##1243366",
    Icon = "raidbgicon_liexi03",
    Type = 1,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          ">",
          42197
        },
        {
          "id",
          "compare",
          "<",
          42203
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235370",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6295] = {
    id = 6295,
    NameEn = "##1243366",
    Icon = "raidbgicon_liexi03",
    Type = 1,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          ">",
          142685
        },
        {
          "id",
          "compare",
          "<",
          142691
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235370",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6296] = {
    id = 6296,
    NameEn = "##1243366",
    Icon = "raidbgicon_liexi03",
    Type = 1,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          ">",
          142197
        },
        {
          "id",
          "compare",
          "<",
          142203
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235370",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6297] = {
    id = 6297,
    NameEn = "##1243378",
    Icon = "raidbgicon_liexi04",
    Type = 1,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          ">",
          43635
        },
        {
          "id",
          "compare",
          "<",
          43641
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235370",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6298] = {
    id = 6298,
    NameEn = "##1243378",
    Icon = "raidbgicon_liexi04",
    Type = 1,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          ">",
          43113
        },
        {
          "id",
          "compare",
          "<",
          43118
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235370",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6299] = {
    id = 6299,
    NameEn = "##1243378",
    Icon = "raidbgicon_liexi04",
    Type = 1,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          ">",
          143635
        },
        {
          "id",
          "compare",
          "<",
          143641
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235370",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6300] = {
    id = 6300,
    NameEn = "##1243378",
    Icon = "raidbgicon_liexi04",
    Type = 1,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          ">",
          143113
        },
        {
          "id",
          "compare",
          "<",
          143118
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235370",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6301] = {
    id = 6301,
    NameEn = "##1243390",
    Icon = "raidbgicon_liexi05",
    Type = 1,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          ">",
          44157
        },
        {
          "id",
          "compare",
          "<",
          44164
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235370",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6302] = {
    id = 6302,
    NameEn = "##1243390",
    Icon = "raidbgicon_liexi05",
    Type = 1,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          ">",
          144157
        },
        {
          "id",
          "compare",
          "<",
          144164
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1235370",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6303] = {
    id = 6303,
    NameEn = "##1249753",
    Icon = "raidbgicon_liexi10",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Reward",
      "item",
      {
        {
          "team",
          "compare",
          "=",
          74750
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1249754",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6304] = {
    id = 6304,
    NameEn = "##1249753",
    Icon = "raidbgicon_liexi10",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Reward",
      "item",
      {
        {
          "team",
          "compare",
          "=",
          74751
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1249754",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6305] = {
    id = 6305,
    NameEn = "##1249753",
    Icon = "raidbgicon_liexi10",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Reward",
      "item",
      {
        {
          "team",
          "compare",
          "=",
          60006251
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1249754",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6306] = {
    id = 6306,
    NameEn = "##1187387",
    Icon = "Dungeon",
    Type = 1,
    Materialdisplay = 1,
    Search1 = {
      "Table_Reward",
      "item",
      {
        {
          "team",
          "compare",
          "=",
          60006251
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1187387",
    GotoMode = {8116},
    BeginTime = "",
    EndTime = ""
  },
  [6307] = {
    id = 6307,
    NameEn = "##1111835",
    Icon = "Shopping",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Reward",
      "item",
      {
        {
          "team",
          "compare",
          "=",
          60006253
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1134482",
    GotoMode = {1700},
    BeginTime = "",
    EndTime = ""
  },
  [6308] = {
    id = 6308,
    NameEn = "##1111835",
    Icon = "Shopping",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Reward",
      "item",
      {
        {
          "team",
          "compare",
          "=",
          60006252
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1134482",
    GotoMode = {1700},
    BeginTime = "",
    EndTime = ""
  },
  [6309] = {
    id = 6309,
    NameEn = "##1249765",
    Icon = "raidbgicon_liexi09",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Reward",
      "item",
      {
        {
          "team",
          "compare",
          "=",
          74740
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1249766",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6310] = {
    id = 6310,
    NameEn = "##1249765",
    Icon = "raidbgicon_liexi09",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Reward",
      "item",
      {
        {
          "team",
          "compare",
          "=",
          74741
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1249766",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6311] = {
    id = 6311,
    NameEn = "##1249765",
    Icon = "raidbgicon_liexi09",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Reward",
      "item",
      {
        {
          "team",
          "compare",
          "=",
          60006250
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1249766",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6313] = {
    id = 6313,
    NameEn = "##1243342",
    Icon = "raidbgicon_liexi01",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          6935
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1249773",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6314] = {
    id = 6314,
    NameEn = "##1243354",
    Icon = "raidbgicon_liexi02",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          6935
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1249773",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6315] = {
    id = 6315,
    NameEn = "##1243366",
    Icon = "raidbgicon_liexi03",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          6935
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1249773",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6316] = {
    id = 6316,
    NameEn = "##1243378",
    Icon = "raidbgicon_liexi04",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          6935
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1249773",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6317] = {
    id = 6317,
    NameEn = "##1243390",
    Icon = "raidbgicon_liexi05",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          6935
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1249773",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6318] = {
    id = 6318,
    NameEn = "##1243342",
    Icon = "raidbgicon_liexi01",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          6943
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1249773",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6319] = {
    id = 6319,
    NameEn = "##1243354",
    Icon = "raidbgicon_liexi02",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          6943
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1249773",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6320] = {
    id = 6320,
    NameEn = "##1243366",
    Icon = "raidbgicon_liexi03",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          6943
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1249773",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6321] = {
    id = 6321,
    NameEn = "##1243378",
    Icon = "raidbgicon_liexi04",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          6943
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1249773",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6322] = {
    id = 6322,
    NameEn = "##1243390",
    Icon = "raidbgicon_liexi05",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          6943
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1249773",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6323] = {
    id = 6323,
    NameEn = "##1235284",
    Icon = "raidbgicon_liexi06",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          6936
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1249773",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6324] = {
    id = 6324,
    NameEn = "##1235288",
    Icon = "raidbgicon_liexi07",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          6936
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1249773",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6325] = {
    id = 6325,
    NameEn = "##1235292",
    Icon = "raidbgicon_liexi08",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          6936
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1249773",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6326] = {
    id = 6326,
    NameEn = "##1235284",
    Icon = "raidbgicon_liexi06",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          6944
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1249773",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6327] = {
    id = 6327,
    NameEn = "##1235288",
    Icon = "raidbgicon_liexi07",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          6944
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1249773",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6328] = {
    id = 6328,
    NameEn = "##1235292",
    Icon = "raidbgicon_liexi08",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          6944
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1249773",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6329] = {
    id = 6329,
    NameEn = "##1249765",
    Icon = "raidbgicon_liexi09",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          6937
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1249773",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6330] = {
    id = 6330,
    NameEn = "##1249753",
    Icon = "raidbgicon_liexi10",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          6937
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1249773",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6331] = {
    id = 6331,
    NameEn = "##1249765",
    Icon = "raidbgicon_liexi09",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          6958
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1249773",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6332] = {
    id = 6332,
    NameEn = "##1249753",
    Icon = "raidbgicon_liexi10",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          6958
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1249773",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6333] = {
    id = 6333,
    NameEn = "##1253546",
    Icon = "",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Shop",
      "items",
      {
        {
          "type",
          "compare",
          "=",
          3350
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1253547",
    GotoMode = {8223},
    BeginTime = "",
    EndTime = ""
  },
  [6334] = {
    id = 6334,
    NameEn = "##1253548",
    Icon = "",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Shop",
      "items",
      {
        {
          "type",
          "compare",
          "=",
          3349
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1253549",
    GotoMode = {8229},
    BeginTime = "",
    EndTime = ""
  },
  [6335] = {
    id = 6335,
    NameEn = "##1253550",
    Icon = "MIntrusion",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          6956
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1253551",
    GotoMode = {8241},
    BeginTime = "",
    EndTime = ""
  },
  [6336] = {
    id = 6336,
    NameEn = "##1253552",
    Icon = "MVPfight",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          6956
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1253553",
    GotoMode = {8241},
    BeginTime = "",
    EndTime = ""
  },
  [6337] = {
    id = 6337,
    NameEn = "##254962",
    Icon = "jingpilijie",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          6956
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1253554",
    GotoMode = {8241},
    BeginTime = "",
    EndTime = ""
  },
  [6338] = {
    id = 6338,
    NameEn = "##1243342",
    Icon = "raidbgicon_liexi01",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          6927
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1258580",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6339] = {
    id = 6339,
    NameEn = "##1243354",
    Icon = "raidbgicon_liexi02",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          6927
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1258581",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6340] = {
    id = 6340,
    NameEn = "##1243366",
    Icon = "raidbgicon_liexi03",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          6927
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1258582",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6341] = {
    id = 6341,
    NameEn = "##1243378",
    Icon = "raidbgicon_liexi04",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          6927
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1258583",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6342] = {
    id = 6342,
    NameEn = "##1243390",
    Icon = "raidbgicon_liexi05",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          6927
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1258584",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6343] = {
    id = 6343,
    NameEn = "##1249765",
    Icon = "raidbgicon_liexi09",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          13310
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1249766",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6344] = {
    id = 6344,
    NameEn = "##1249765",
    Icon = "raidbgicon_liexi09",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          52116
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1249766",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6345] = {
    id = 6345,
    NameEn = "##1249765",
    Icon = "raidbgicon_liexi09",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          52166
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1249766",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6346] = {
    id = 6346,
    NameEn = "##1249765",
    Icon = "raidbgicon_liexi09",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          52216
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1249766",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6347] = {
    id = 6347,
    NameEn = "##1249753",
    Icon = "raidbgicon_liexi10",
    Type = 2,
    Materialdisplay = 1,
    Search1 = {
      "Table_Item",
      "id",
      {
        {
          "id",
          "compare",
          "=",
          12956
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1249754",
    GotoMode = {2090},
    BeginTime = "",
    EndTime = ""
  },
  [6348] = {
    id = 6348,
    NameEn = "##1252947",
    Icon = "",
    Type = 3,
    Materialdisplay = 0,
    Search1 = {
      "Table_MonsterList",
      "Reward",
      {
        {
          "id",
          "staticselect",
          "none",
          {
            320010,
            320020,
            320030,
            320040,
            320050,
            320060,
            320070,
            320080,
            320090,
            320100,
            320120,
            320130,
            320140,
            320150,
            320160
          }
        }
      }
    },
    Search2 = {
      "Table_Reward",
      "item",
      {
        {
          "team",
          "dynamicselect",
          "none",
          0
        }
      }
    },
    Search3 = _EmptyTable,
    Desc = "%s",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  },
  [6081] = {
    id = 6081,
    NameEn = "##148720",
    Icon = "item_162",
    Type = 2,
    Materialdisplay = 0,
    Search1 = {
      "Table_Shop",
      "items",
      {
        {
          "type",
          "compare",
          "=",
          920
        },
        {
          "ShopID",
          "compare",
          "=",
          1
        }
      }
    },
    Search2 = _EmptyTable,
    Search3 = _EmptyTable,
    Desc = "##1123896",
    GotoMode = _EmptyTable,
    BeginTime = "",
    EndTime = ""
  }
}
Table_AddWay_fields = {
  "id",
  "NameEn",
  "Icon",
  "Type",
  "Materialdisplay",
  "Search1",
  "Search2",
  "Search3",
  "Desc",
  "GotoMode",
  "menu",
  "BeginTime",
  "EndTime"
}
return Table_AddWay
