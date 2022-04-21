local asset_conf = {
  floor_bottom = 0.19,
  spriteSheet = love.graphics.newImage('assets/sprites.png'),
  hero = {
    refFrame = {
      pixelwidth = 24,      -- reference pixel width  24 pixel = 1 unit = 1/3 width in viewport dimension
      pixelheight = 56,     -- reference pixel height 56 pixel = 1 unit = 1/12 height in viewport dimension
      height = 1 / 3.2,       -- height in viewport dimension
      width = 1 / 12,       -- width in viewport dimension
    },
    sprites = {
      standing = {
        duration = 1,
        quads = {
          [1] = {
            pos_x = 16,
            pos_y = 500,
            width = 24,
            height = 56,
          },
        }
      },
      walking = {
        duration = 0.35,
        quads = {
          [1] = {
            pos_x = 72,
            pos_y = 496,
            width = 26,
            height = 60,
          },
          [2] = {
            pos_x = 106,
            pos_y = 493,
            width = 17,
            height = 63,
          },
          [2] = {
            pos_x = 131,
            pos_y = 496,
            width = 27,
            height = 60,
          },
          [3] = {
            pos_x = 166,
            pos_y = 494,
            width = 17,
            height = 62,
          },
        },
      },
      sitting = {
        duration = 1,
        quads = {
          [1] = {
            pos_x = 16,
            pos_y = 691,
            width = 23,
            height = 40,
          }
        },
      },
      standJumping = {
        duration = 0.6,
        quads = {
          [1] = {
            pos_x = 16,
            pos_y = 813,
            width = 15,
            height = 56,
          },
          [2] = {
            pos_x = 39,
            pos_y = 788,
            width = 13,
            height = 69,
          },
          [3] = {
            pos_x = 60,
            pos_y = 784,
            width = 17,
            height = 54,
          },
          [4] = {
            pos_x = 85,
            pos_y = 782,
            width = 17,
            height = 69,
          },
          [5] = {
            pos_x = 110,
            pos_y = 813,
            width = 15,
            height = 56,
          },
        },
      },
      walkJumping = {
        duration = 0.6,
        quads = {
          [1] = {
            pos_x = 16,
            pos_y = 937,
            width = 26,
            height = 53,
          },
          [2] = {
            pos_x = 50,
            pos_y = 909,
            width = 13,
            height = 69,
          },
          [3] = {
            pos_x = 71,
            pos_y = 905,
            width = 17,
            height = 54,
          },
          [4] = {
            pos_x = 96,
            pos_y = 903,
            width = 17,
            height = 69,
          },
          [5] = {
            pos_x = 121,
            pos_y = 934,
            width = 15,
            height = 56,
          },
        },
      },
      standPunching = {
        duration = 0.125,
        quads = {
          [1] = {
            pos_x = 52,
            pos_y = 580,
            width = 21,
            height = 62,
          },
          [2] = {
            pos_x = 16,
            pos_y = 581,
            width = 28,
            height = 61,
            hitPoint = {
              pos_x = 39,
              pos_y = 590,
              width = 5,
              height = 6,
            },
          },
          [3] = {
            pos_x = 52,
            pos_y = 580,
            width = 21,
            height = 62,
          },
        },
      },
      standKicking = {
        duration = 0.125,
        quads = {
          [1] = {
            pos_x = 259,
            pos_y = 579,
            width = 29,
            height = 63,
          },
          [2] = {
            pos_x = 296,
            pos_y = 581,
            width = 43,
            height = 61,
            hitPoint = {
              pos_x = 332,
              pos_y = 589,
              width = 7,
              height = 6,
            },
          },
          [3] = {
            pos_x = 259,
            pos_y = 579,
            width = 29,
            height = 63,
          },
        },
      },
      sitPunching = {
        duration = 0.125,
        quads = {
          [1] = {
            pos_x = 108,
            pos_y = 683,
            width = 23,
            height = 48,
          },
          [1] = {
            pos_x = 71,
            pos_y = 683,
            width = 29,
            height = 48,
            hitPoint = {
              pos_x = 94,
              pos_y = 692,
              width = 6,
              height = 6,
            }
          },
          [3] = {
            pos_x = 108,
            pos_y = 683,
            width = 23,
            height = 48,
          },
        },
      },
      sitKicking = {
        duration = 0.125,
        quads = {
          [1] = {
            pos_x = 323,
            pos_y = 688,
            width = 31,
            height = 43,
          },
          [1] = {
            pos_x = 362,
            pos_y = 689,
            width = 49,
            height = 42,
            hitPoint = {
              pos_x = 403,
              pos_y = 724,
              width = 8,
              height = 7,
            }
          },
          [3] = {
            pos_x = 323,
            pos_y = 688,
            width = 31,
            height = 43,
          },
        },
      },
      standJumpKicking = {
        duration = 0.6,
        quads = {
          [1] = {
            pos_x = 363,
            pos_y = 813,
            width = 15,
            height = 56,
          },
          [2] = {
            pos_x = 386,
            pos_y = 788,
            width = 13,
            height = 69,
          },
          [3] = {
            pos_x = 407,
            pos_y = 784,
            width = 17,
            height = 54,
          },
          [4] = {
            pos_x = 432,
            pos_y = 772,
            width = 31,
            height = 68,
            hitPoint = {
              pos_x = 456,
              pos_y = 775,
              --width = 7,
              --height = 10,
              width = 7,
              height = 38,
            },
          },
          [5] = {
            pos_x = 432,
            pos_y = 772,
            width = 31,
            height = 68,
            hitPoint = {
              pos_x = 456,
              pos_y = 775,
              --width = 7,
              --height = 28,
              width = 7,
              height = 38,
            },
          },
          [6] = {
            pos_x = 471,
            pos_y = 782,
            width = 17,
            height = 69,
          },
          [7] = {
            pos_x = 496,
            pos_y = 813,
            width = 15,
            height = 56,
          },
        },
      },
      standJumpPunching = {
        duration = 0.6,
        quads = {
          [1] = {
            pos_x = 157,
            pos_y = 813,
            width = 15,
            height = 56,
          },
          [2] = {
            pos_x = 180,
            pos_y = 788,
            width = 13,
            height = 69,
          },
          [3] = {
            pos_x = 201,
            pos_y = 784,
            width = 17,
            height = 54,
          },
          [4] = {
            pos_x = 226,
            pos_y = 779,
            width = 28,
            height = 61,
            hitPoint = {
              pos_x = 249,
              pos_y = 788,
              width = 5,
              height = 6,
            }
          },
          [5] = {
            pos_x = 262,
            pos_y = 780,
            width = 21,
            height = 62,
          },
          [6] = {
            pos_x = 291,
            pos_y = 782,
            width = 17,
            height = 69,
          },
          [7] = {
            pos_x = 316,
            pos_y = 813,
            width = 15,
            height = 56,
          },
        },
      },
      walkJumpKicking = {
        duration = 0.6,
        quads = {
          [1] = {
            pos_x = 16,
            pos_y = 937,
            width = 26,
            height = 53,
          },
          [2] = {
            pos_x = 50,
            pos_y = 909,
            width = 13,
            height = 69,
          },
          [3] = {
            pos_x = 71,
            pos_y = 905,
            width = 17,
            height = 54,
          },
          [4] = {
            pos_x = 465,
            pos_y = 893,
            width = 31,
            height = 68,
            hitPoint = {
              pos_x = 489,
              pos_y = 896,
              width = 7,
              height = 38,
            }
          },
          [5] = {
            pos_x = 465,
            pos_y = 893,
            width = 31,
            height = 68,
            hitPoint = {
              pos_x = 489,
              pos_y = 896,
              width = 7,
              height = 38,
            }
          },
          [6] = {
            pos_x = 96,
            pos_y = 903,
            width = 17,
            height = 69,
          },
          [7] = {
            pos_x = 121,
            pos_y = 934,
            width = 15,
            height = 56,
          },
        },
      },
      walkJumpPunching = {
        duration = 0.6,
        quads = {
          [1] = {
            pos_x = 16,
            pos_y = 937,
            width = 26,
            height = 53,
          },
          [2] = {
            pos_x = 50,
            pos_y = 909,
            width = 13,
            height = 69,
          },
          [3] = {
            pos_x = 71,
            pos_y = 905,
            width = 17,
            height = 54,
          },
          [4] = {
            pos_x = 248,
            pos_y = 901,
            width = 28,
            height = 61,
            hitPoint = {
              pos_x = 271,
              pos_y = 910,
              width = 5,
              height = 6,
            }
          },
          [5] = {
            pos_x = 284,
            pos_y = 898,
            width = 21,
            height = 62,
          },
          [6] = {
            pos_x = 96,
            pos_y = 903,
            width = 17,
            height = 69,
          },
          [7] = {
            pos_x = 121,
            pos_y = 934,
            width = 15,
            height = 56,
          },
        },
      },
    },
  },
  crazy88 = {
    refFrame = {
      pixelwidth = 20,
      pixelheight = 58,
      height = 1 / 3.2,
      width = 1 / 12,
    },
    sprites = {
      walking = {
        duration = 0.7,
        quads = {
          [1] = {
            pos_x = 16,
            pos_y = 16,
            width = 20,
            height = 58,
          },
          [2] = {
            pos_x = 44,
            pos_y = 16,
            width = 11,
            height = 58,
          },
          [3] = {
            pos_x = 63,
            pos_y = 16,
            width = 21,
            height = 58,
          },
          [4] = {
            pos_x = 92,
            pos_y = 16,
            width = 11,
            height = 58,
          },
        },
      },
      approaching = {
        duration = 0.7,
        quads = {
          [1] = {
            pos_x = 16,
            pos_y = 98,
            width = 20,
            height = 63,
          },
          [2] = {
            pos_x = 44,
            pos_y = 98,
            width = 11,
            height = 63,
          },
          [3] = {
            pos_x = 63,
            pos_y = 98,
            width = 21,
            height = 63,
          },
          [4] = {
            pos_x = 92,
            pos_y = 98,
            width = 11,
            height = 63,
          },
        },
      },
      holding = {
        duration = 0.5,
        quads = {
          [1] = {
            pos_x = 135,
            pos_y = 104,
            width = 22,
            height = 57,
          },
        },
      },
      falling = {
        duration = 0.5,
        quads = {
          [1] = {
            pos_x = 351,
            pos_y = 108,
            width = 37,
            height = 53,
          },
          [2] = {
            pos_x = 396,
            pos_y = 112,
            width = 41,
            height = 49,
          },
        },
      },
      hitTop = {
        duration = 0.1,
        quads = {
          [1] = {
            pos_x = 189,
            pos_y = 102,
            width = 23,
            height = 59,
          },
        },
      },
      hitMiddle = {
        duration = 0.1,
        quads = {
          [1] = {
            pos_x = 244,
            pos_y = 105,
            width = 20,
            height = 56,
          },
        },
      },
      hitBottom = {
        duration = 0.1,
        quads = {
          [1] = {
            pos_x = 296,
            pos_y = 101,
            width = 23,
            height = 60,
          },
        },
      },
    },
  },
  dwarf = {
    refFrame = {
      pixelwidth = 16,
      pixelheight = 43,
      height = 1 / 4.3,
      width = 1 / 12,
    },
    sprites = {
      walking = {
        duration = 0.7,
        quads = {
          [1] = {
            pos_x = 16,
            pos_y = 189,
            width = 16,
            height = 43,
          },
          [2] = {
            pos_x = 40,
            pos_y = 189,
            width = 11,
            height = 43,
          },
          [3] = {
            pos_x = 59,
            pos_y = 189,
            width = 16,
            height = 43,
          },
          [4] = {
            pos_x = 83,
            pos_y = 189,
            width = 11,
            height = 43,
          },
        },
      },
      holding = {
        duration = 0.5,
        quads = {
          [1] = {
            pos_x = 126,
            pos_y = 192,
            width = 19,
            height = 40,
          },
        },
      },
      falling = {
        duration = 0.5,
        quads = {
          [1] = {
            pos_x = 177,
            pos_y = 196,
            width = 27,
            height = 36,
          },
          [2] = {
            pos_x = 212,
            pos_y = 207,
            width = 31,
            height = 25,
          },
        },
      },
      tumbling = {
        duration = 0.7,
        quads = {
          [1] = {
            pos_x = 275,
            pos_y = 192,
            width = 16,
            height = 40,
          },
          [2] = {
            pos_x = 299,
            pos_y = 185,
            width = 18,
            height = 47,
          },
          [3] = {
            pos_x = 325,
            pos_y = 201,
            width = 19,
            height = 31,
          },
          [4] = {
            pos_x = 352,
            pos_y = 204,
            width = 20,
            height = 28,
          },
          [5] = {
            pos_x = 380,
            pos_y = 201,
            width = 19,
            height = 31,
          },
          [6] = {
            pos_x = 435,
            pos_y = 192,
            width = 16,
            height = 40,
          },
        },
      },
    },
  },
  gogo = {
    refFrame = {
      pixelwidth = 22,
      pixelheight = 59,
      height = 1 / 3.2,
      width = 1 / 12,
    },
    sprites = {
      standing = {
        duration = 0.7,
        quads = {
          [1] = {
            pos_x = 139,
            pos_y = 267,
            width = 22,
            height = 59,
          },
        },
      },
      walking = {
        duration = 0.6,
        quads = {
          [1] = {
            pos_x = 16,
            pos_y = 267,
            width = 21,
            height = 59,
          },
          [2] = {
            pos_x = 45,
            pos_y = 267,
            width = 12,
            height = 59,
          },
          [3] = {
            pos_x = 65,
            pos_y = 267,
            width = 22,
            height = 59,
          },
          [4] = {
            pos_x = 95,
            pos_y = 267,
            width = 12,
            height = 59,
          },
        },
      },
      throwingHigh = {
        duration = 0.25,
        quads = {
          [1] = {
            pos_x = 193,
            pos_y = 256,
            width = 16,
            height = 70,
          },
          [2] = {
            pos_x = 217,
            pos_y = 267,
            width = 27,
            height = 59,
          },
        },
      },
      throwingLow = {
        duration = 0.25,
        quads = {
          [1] = {
            pos_x = 276,
            pos_y = 275,
            width = 32,
            height = 51,
          },
          [2] = {
            pos_x = 316,
            pos_y = 275,
            width = 32,
            height = 51,
          },
        },
      },
      falling = {
        duration = 0.25,
        quads = {
          [1] = {
            pos_x = 478,
            pos_y = 274,
            width = 45,
            height = 52,
          },
          [2] = {
            pos_x = 531,
            pos_y = 278,
            width = 47,
            height = 48,
          },
        },
      },
      hit1 = {
        duration = 0.25,
        quads = {
          [1] = {
            pos_x = 380,
            pos_y = 268,
            width = 15,
            height = 58,
          },
        },
      },
      hit2 = {
        duration = 0.25,
        quads = {
          [1] = {
            pos_x = 427,
            pos_y = 267,
            width = 19,
            height = 59,
          },
        },
      },
    },
  },
  knife = {
    refFrame = {
      pixelwidth = 12,
      pixelheight = 7,
      height = 1 / 24,
      width = 1 / 24,
    },
    sprites = {
      flying = {
        duration = 0.1,
        quads = {
          [1] = {
            pos_x = 610,
            pos_y = 319,
            width = 12,
            height = 7,
          },
        },
      },
    },
  },
  hitMark = {
    refFrame = {
      pixelwidth = 11,
      pixelheight = 14,
      height = 1 / 10,
      width = 1 / 10,
    },
    sprites = {
      hit = {
        duration = 0.1,
        quads = {
          [1] = {
            pos_x = 534,
            pos_y = 455,
            width = 11,
            height = 14,
          },
        },
      },
    },
  },
  level = {
    [1] = {
      background = 'assets/floor1.png',
      background_width = 1792,
      background_height = 200,
    },
  },
}

return asset_conf
