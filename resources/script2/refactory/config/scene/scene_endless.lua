local Scene_endless = {
  PVE = {
    nps = {
      {
        uniqueID = 0,
        ID = 1149,
        position = {
          -62.071475982666,
          2.7012996673584,
          2.47552633285522
        }
      }
    }
  },
  Raids = {
    [20002] = {
      bps = {
        {
          ID = 1,
          position = {
            -50.220703125,
            440.739990234375,
            599.384887695313
          },
          range = 0
        }
      },
      eps = {
        {
          ID = 1,
          commonEffectID = 16,
          position = {
            -67.8112030029297,
            445.980010986328,
            627.98486328125
          },
          nextSceneID = 0,
          nextSceneBornPointID = 0,
          type = 0,
          range = 1
        }
      },
      nps = {
        {
          uniqueID = 101,
          ID = 0,
          position = {
            -60.3612022399902,
            446.375946044922,
            621.73486328125
          }
        },
        {
          uniqueID = 1001,
          ID = 9312,
          position = {
            -60.3212471008301,
            185.375930786133,
            193.204971313477
          }
        },
        {
          uniqueID = 1002,
          ID = 0,
          position = {
            -60.3612022399902,
            446.375946044922,
            621.73486328125
          }
        },
        {
          uniqueID = 201,
          ID = 0,
          position = {
            -60.3612022399902,
            446.375946044922,
            621.73486328125
          }
        },
        {
          uniqueID = 301,
          ID = 0,
          position = {
            -60.3612022399902,
            446.375946044922,
            621.73486328125
          }
        }
      }
    },
    [20001] = {
      bps = {
        {
          ID = 1,
          position = {
            -53.7112731933594,
            2.71000003814697,
            -3.64502811431885
          },
          range = 0
        }
      },
      eps = {
        {
          ID = 1,
          commonEffectID = 16,
          position = {
            -54.601261138916,
            7.76000022888184,
            25.1549758911133
          },
          nextSceneID = 0,
          nextSceneBornPointID = 0,
          type = 0,
          range = 1
        }
      },
      nps = {
        {
          uniqueID = 101,
          ID = 0,
          position = {
            -76.7906341552734,
            8.10593795776367,
            19.4049415588379
          }
        },
        {
          uniqueID = 201,
          ID = 0,
          position = {
            -77.6406402587891,
            5.51593780517578,
            -2.22505760192871
          }
        },
        {
          uniqueID = 301,
          ID = 0,
          position = {
            -56.8406372070313,
            8.10593795776367,
            26.384937286377
          }
        }
      }
    }
  },
  MapInfo = {
    [0] = {
      MinPos = {x = -89.870002746582, y = -11.75},
      Size = {x = 45, y = 45}
    },
    [1] = {
      MinPos = {x = -83.1300048828125, y = 593},
      Size = {x = 45, y = 45}
    }
  }
}
return Scene_endless
