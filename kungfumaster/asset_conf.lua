local asset_conf = {
  spriteSheet = love.graphics.newImage('assets/sprites.png'),
  hero = {
    sprites = {
      standing = {
        duration = 1,
        oneshot = false,
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
        duration = 0.5,
        oneshot = false,
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
        oneshot = false,
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
        duration = 0.5,
        oneshot = true,
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
        duration = 0.5,
        oneshot = true,
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
        duration = 0.15,
        oneshot = true,
        quads = {
          [1] = {
            pos_x = 16,
            pos_y = 581,
            width = 28,
            height = 61,
          },
          [2] = {
            pos_x = 52,
            pos_y = 580,
            width = 21,
            height = 62,
          },
        },
      },
      standKicking = {
        duration = 0.15,
        oneshot = true,
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
          },
        },
      },
    },
  },
}

return asset_conf
