local Scene_moon_lake = {
  PVE = {
    bps = {
      {
        ID = 1,
        position = {
          -12.4932355880737,
          2.5,
          -208.918395996094
        },
        range = 0,
        dir = 90
      },
      {
        ID = 2,
        position = {
          -13.6039695739746,
          6.46299982070923,
          0.86798095703125
        },
        range = 0,
        dir = 90.0000076293945
      }
    },
    eps = {
      {
        ID = 1,
        commonEffectID = 16,
        exitType = 0,
        position = {
          -12.4932355880737,
          1.73963212966919,
          -214.937454223633
        },
        nextSceneID = 69,
        nextSceneBornPointID = 3,
        type = 0,
        range = 1.29999995231628
      },
      {
        ID = 2,
        commonEffectID = 16,
        exitType = 0,
        position = {
          -13.649341583252,
          6.36963224411011,
          9.6025390625
        },
        nextSceneID = 107,
        nextSceneBornPointID = 1,
        type = 0,
        range = 1.29999995231628
      }
    },
    nps = {
      {
        uniqueID = 1058,
        ID = 1058,
        position = {
          -25.5005397796631,
          2.54129934310913,
          -213.500198364258
        }
      },
      {
        uniqueID = 810216,
        ID = 810216,
        position = {
          8.58946132659912,
          3.59129953384399,
          -176.990203857422
        }
      }
    }
  },
  Raids = {
    [1003180] = {
      bps = {
        {
          ID = 1,
          position = {
            -12.4932355880737,
            2.5,
            -208.918395996094
          },
          range = 0,
          dir = 0
        },
        {
          ID = 2,
          position = {
            -13.6039695739746,
            6.46299982070923,
            0.86798095703125
          },
          range = 0,
          dir = 90.0000076293945
        }
      },
      eps = {
        {
          ID = 1,
          commonEffectID = 16,
          exitType = 0,
          position = {
            -12.4932355880737,
            1.73963117599487,
            -214.937454223633
          },
          nextSceneID = 69,
          nextSceneBornPointID = 3,
          type = 0,
          range = 1.29999995231628
        },
        {
          ID = 2,
          commonEffectID = 16,
          exitType = 0,
          position = {
            -13.6493425369263,
            6.36963129043579,
            9.6025390625
          },
          nextSceneID = 1003181,
          nextSceneBornPointID = 1,
          type = 0,
          range = 1.29999995231628
        }
      }
    },
    [1003102] = {
      bps = {
        {
          ID = 1,
          position = {
            -9.19323539733887,
            2.48535656929016,
            -193.6083984375
          },
          range = 0,
          dir = 0
        }
      },
      nps = {
        {
          uniqueID = 1,
          ID = 809424,
          position = {
            -16.9700012207031,
            2.83000016212463,
            -193.360000610352
          }
        },
        {
          uniqueID = 2,
          ID = 809424,
          position = {
            -19.230001449585,
            2.83000016212463,
            -185.470001220703
          }
        },
        {
          uniqueID = 3,
          ID = 809424,
          position = {
            -6.22000122070313,
            2.83000016212463,
            -191.910003662109
          }
        },
        {
          uniqueID = 4,
          ID = 809424,
          position = {
            -4.41000175476074,
            2.83000016212463,
            -187.040008544922
          }
        },
        {
          uniqueID = 5,
          ID = 809425,
          position = {
            -12.5700016021729,
            2.83000016212463,
            -187.589996337891
          }
        },
        {
          uniqueID = 809414,
          ID = 809414,
          position = {
            -12.3900012969971,
            2.83000016212463,
            -193.149993896484
          }
        },
        {
          uniqueID = 809412,
          ID = 809412,
          position = {
            -13.6700010299683,
            2.83000016212463,
            -190.119995117188
          }
        }
      }
    },
    [1003966] = {
      bps = {
        {
          ID = 1,
          position = {
            -20.9300003051758,
            3.09999990463257,
            -168.759979248047
          },
          range = 0,
          dir = 265.48193359375
        }
      },
      eps = {
        {
          ID = 1,
          commonEffectID = 16,
          exitType = 0,
          position = {
            -12.4932355880737,
            1.73963117599487,
            -214.937438964844
          },
          nextSceneID = 1,
          nextSceneBornPointID = 1,
          type = 0,
          range = 1.29999995231628
        }
      }
    }
  },
  MapInfo = {
    [0] = {
      MinPos = {x = -153.399993896484, y = -263.800018310547},
      Size = {x = 280, y = 280}
    }
  }
}
return Scene_moon_lake
