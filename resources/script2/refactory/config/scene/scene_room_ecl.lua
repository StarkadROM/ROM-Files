local Scene_room_ecl = {
  PVE = {
    bps = {
      {
        ID = 1,
        position = {
          -109.439987182617,
          15.1479997634888,
          57.4200057983398
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
          -104.749984741211,
          12.3299999237061,
          51.620002746582
        },
        nextSceneID = 109,
        nextSceneBornPointID = 5,
        type = 0,
        range = 1
      }
    },
    nps = {
      {
        uniqueID = 817187,
        ID = 817187,
        position = {
          -151.759963989258,
          27.6800003051758,
          84.9999847412109
        }
      }
    }
  },
  Raids = {
    [1003505] = {
      bps = {
        {
          ID = 1,
          position = {
            -109.439994812012,
            15.1480007171631,
            57.4200019836426
          },
          range = 0,
          dir = 90.0000076293945
        }
      },
      nps = {
        {
          uniqueID = 817187,
          ID = 817187,
          position = {
            -151.759994506836,
            27.6800003051758,
            85
          }
        }
      }
    },
    [1003961] = {
      bps = {
        {
          ID = 1,
          position = {
            -127.149993896484,
            23.8400001525879,
            73.1999969482422
          },
          range = 0,
          dir = 90
        }
      }
    },
    [1003985] = {
      bps = {
        {
          ID = 1,
          position = {
            -154.350006103516,
            24.7800006866455,
            74.1299896240234
          },
          range = 0,
          dir = 90
        }
      }
    },
    [1003498] = {
      bps = {
        {
          ID = 1,
          position = {
            -148.759994506836,
            24.7999992370605,
            76.3000030517578
          },
          range = 0,
          dir = 90
        }
      }
    }
  },
  MapInfo = {
    [0] = {
      MinPos = {x = -167.699996948242, y = 34},
      Size = {x = 70, y = 70}
    }
  }
}
return Scene_room_ecl
