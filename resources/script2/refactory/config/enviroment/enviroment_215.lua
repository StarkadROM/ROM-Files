local Enviroment_215 = {
  global = {
    sunDir = {
      0.825980365276337,
      -0.494738817214966,
      0.270166575908661,
      0
    },
    sunColor = {
      0.207843154668808,
      0.258823543787003,
      0.407843172550201,
      1
    }
  },
  lighting = {
    ambientMode = 0,
    ambientLight = {
      1,
      1,
      1,
      1
    },
    ambientIntensity = 1,
    defaultReflectionMode = 0,
    defaultReflectionResolution = 0,
    reflectionBounces = 1,
    reflectionIntensity = 0
  },
  fog = {
    fog = true,
    fogColor = {
      0.251748532056808,
      0.398874253034592,
      0.546000003814697,
      1
    },
    fogMode = 1,
    fogStartDistance = 10,
    fogEndDistance = 100,
    globalFogTuner = 0,
    heightFogMode = 1,
    heightFogCutoff = 9.99999974737875E-6,
    heightFogStart = 0,
    heightFogEnd = 270,
    scatteringDensity = 0.280000001192093,
    scatteringFalloff = 4,
    scatteringExponent = 40,
    heightFogMinOpacity = 0,
    radiusFogFactor = 0,
    nearFogColor = {
      0.166963323950768,
      0.491459578275681,
      0.528301894664764,
      1
    },
    nearFogDistance = 20,
    farFogColor = {
      0.251748532056808,
      0.398874253034592,
      0.546000003814697,
      1
    },
    farFogDistance = 50,
    enableLocalHeightFog = 0,
    localHeightFogStart = 0,
    localHeightFogEnd = 1,
    localHeightFogColor = {
      0,
      0,
      0,
      0
    }
  },
  wind = {
    sheenColorNear = {
      0.235294133424759,
      0.184313729405403,
      0.0509803965687752,
      1
    },
    sheenColorFar = {
      0.443137288093567,
      0.368627458810806,
      0.0980392247438431,
      1
    },
    sheenDistanceNear = 31.2000007629395,
    sheenDistanceFar = 42.2999992370605,
    sheenScatterMinInten = 0.601999998092651,
    sheenPower = 10.5,
    windTexTiling = {
      6.69999980926514,
      12.8999996185303,
      0,
      0
    },
    windAngle = 216.800003051758,
    windWaveSpeed = 0.165999993681908,
    windBendStrength = 4.15999984741211,
    windWaveSwingEffect = 0.0860000029206276,
    windMask = 0.5,
    windSheenInten = 2.39299988746643,
    windWaveDisorderFreq = 0.284999996423721
  },
  volumes = {
    [1] = {
      volume = {
        type = 0,
        center = {
          0,
          0,
          0
        },
        extents = {
          175,
          50,
          175
        },
        worldToLocalMatrix = {
          {
            1,
            0,
            0,
            5.90000009536743
          },
          {
            0,
            1,
            0,
            -70
          },
          {
            0,
            0,
            1,
            0
          },
          {
            0,
            0,
            0,
            1
          }
        },
        radius = 1,
        priority = 0
      },
      fog = {
        fog = true,
        weight = 1,
        blendDuration = 0.5,
        fogMode = 1,
        fogStartDistance = 20,
        fogEndDistance = 120,
        globalFogTuner = 0,
        heightFogMode = 1,
        heightFogCutoff = 9.99999974737875E-6,
        heightFogStart = 0,
        heightFogEnd = 270,
        scatteringDensity = 0.280000001192093,
        scatteringFalloff = 1,
        scatteringExponent = 40,
        heightFogMinOpacity = 0,
        radiusFogFactor = 0,
        nearFogColor = {
          1,
          1,
          1,
          1
        },
        nearFogDistance = 100,
        farFogColor = {
          0.278431385755539,
          0.419607877731323,
          0.556862771511078,
          1
        },
        farFogDistance = 130,
        enableLocalHeightFog = 0,
        localHeightFogStart = 0,
        localHeightFogEnd = 1,
        localHeightFogColor = {
          0,
          0,
          0,
          0
        }
      }
    }
  },
  flare = {flareFadeSpeed = 1, flareStrength = 0.495999991893768},
  customskybox = {
    texPath = "Enviroment/CustomSkyboxes/surface_pronteraneo_n_sky",
    tint = {
      1,
      1,
      1,
      1
    },
    rotation = 165,
    exposure = 1,
    finite = true,
    sunsize = 0,
    applyFog = false
  },
  bloom = {
    index = 0,
    version = 1,
    threshold = 0.600000023841858,
    intensity = 1.20000004768372,
    bExposure = false,
    scatter = 0.899999976158142,
    clamp = 0,
    highQualityFiltering = false,
    dirtIntensity = 0
  }
}
return Enviroment_215
