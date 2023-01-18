local Enviroment_146 = {
  global = {
    sunDir = {
      0.596653163433075,
      -0.258818984031677,
      0.759616851806641,
      0
    },
    sunColor = {
      1,
      0.700166821479797,
      0.396226406097412,
      1
    }
  },
  fog = {
    fog = true,
    fogColor = {
      0.952830195426941,
      0.69664478302002,
      0.440459281206131,
      1
    },
    fogMode = 1,
    fogStartDistance = 12,
    fogEndDistance = 90,
    globalFogTuner = 0.0500000007450581,
    heightFogMode = 1,
    heightFogCutoff = 9.99999974737875E-6,
    heightFogStart = -20,
    heightFogEnd = 340,
    scatteringDensity = 0.720000028610229,
    scatteringFalloff = 4,
    scatteringExponent = 4.80000019073486,
    heightFogMinOpacity = 0,
    radiusFogFactor = 1,
    nearFogColor = {
      1,
      0.462745130062103,
      0.227450996637344,
      1
    },
    nearFogDistance = 30,
    farFogColor = {
      0.952830195426941,
      0.69664478302002,
      0.440459281206131,
      1
    },
    farFogDistance = 180,
    enableLocalHeightFog = 1,
    localHeightFogStart = -5,
    localHeightFogEnd = 0.5,
    localHeightFogColor = {
      0.22641509771347,
      0.0961196199059486,
      0.148978531360626,
      0
    }
  },
  wind = {
    sheenColorNear = {
      0.556603789329529,
      0.432069629430771,
      0.178533285856247,
      1
    },
    sheenColorFar = {
      0.443137288093567,
      0.368627458810806,
      0.0980392247438431,
      1
    },
    sheenDistanceNear = 28.3999996185303,
    sheenDistanceFar = 39,
    sheenScatterMinInten = 0.46000000834465,
    sheenPower = 4,
    windTexTiling = {
      5,
      5,
      0,
      0
    },
    windAngle = 170,
    windWaveSpeed = 0.150000005960464,
    windBendStrength = 0.152999997138977,
    windWaveSwingEffect = 0.100000001490116,
    windMask = 0.5,
    windSheenInten = 1,
    windWaveDisorderFreq = 0.238999992609024
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
          90,
          20,
          7.5
        },
        worldToLocalMatrix = {
          {
            1,
            0,
            0,
            0
          },
          {
            0,
            1,
            0,
            -18.3999996185303
          },
          {
            0,
            0,
            1,
            -15.3599996566772
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
        blendDuration = 3,
        fogMode = 1,
        fogStartDistance = 10,
        fogEndDistance = 100,
        globalFogTuner = 0,
        heightFogMode = 1,
        heightFogCutoff = 9.99999974737875E-6,
        heightFogStart = -20,
        heightFogEnd = 120,
        scatteringDensity = 0,
        scatteringFalloff = 1,
        scatteringExponent = 4,
        heightFogMinOpacity = 0,
        radiusFogFactor = 1,
        nearFogColor = {
          1,
          0.536920607089996,
          0.330188691616058,
          1
        },
        nearFogDistance = 40,
        farFogColor = {
          1,
          0.856063306331635,
          0.575471699237823,
          0
        },
        farFogDistance = 180,
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
    },
    [2] = {
      volume = {
        type = 0,
        center = {
          0,
          0,
          0
        },
        extents = {
          90,
          20,
          60
        },
        worldToLocalMatrix = {
          {
            1,
            0,
            0,
            0
          },
          {
            0,
            1,
            0,
            -18.3999996185303
          },
          {
            0,
            0,
            1,
            -82.1999969482422
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
        blendDuration = 3,
        fogMode = 1,
        fogStartDistance = 5,
        fogEndDistance = 80,
        globalFogTuner = 0.200000002980232,
        heightFogMode = 1,
        heightFogCutoff = 9.99999974737875E-6,
        heightFogStart = -20,
        heightFogEnd = 120,
        scatteringDensity = 0,
        scatteringFalloff = 1,
        scatteringExponent = 4,
        heightFogMinOpacity = 0,
        radiusFogFactor = 1,
        nearFogColor = {
          1,
          0.728773653507233,
          0.443396210670471,
          1
        },
        nearFogDistance = 50,
        farFogColor = {
          0.981132090091705,
          0.90138840675354,
          0.684941291809082,
          0
        },
        farFogDistance = 180,
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
    texPath = "Enviroment/CustomSkyboxes/sky_Guild_baseneo2_d",
    tint = {
      1,
      1,
      1,
      1
    },
    rotation = 192,
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
return Enviroment_146
