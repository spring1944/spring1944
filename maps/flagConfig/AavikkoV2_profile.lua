-- maps/AavikkoV2_profile.lua
-- used BLOCK_SIZE = 8 and METAL_THRESHOLD = 0.5

local resources = {
	{
		x = 9552,
		z = 240,
		feature = nil
	},
	{
		x = 4848,
		z = 320,
		feature = nil
	},
	{
		x = 544,
		z = 368,
		feature = nil
	},
	{
		x = 336,
		z = 432,
		feature = nil
	},
	{
		x = 5376,
		z = 464,
		feature = nil
	},
	{
		x = 448,
		z = 560,
		feature = nil
	},
	{
		x = 3312,
		z = 672,
		feature = nil
	},
	{
		x = 7088,
		z = 672,
		feature = nil
	},
	{
		x = 8192,
		z = 832,
		feature = nil
	},
	{
		x = 4848,
		z = 848,
		feature = nil
	},
	{
		x = 736,
		z = 912,
		feature = nil
	},
	{
		x = 9200,
		z = 912,
		feature = nil
	},
	{
		x = 9536,
		z = 912,
		feature = nil
	},
	{
		x = 1968,
		z = 960,
		feature = nil
	},
	{
		x = 9856,
		z = 1008,
		feature = nil
	},
	{
		x = 3344,
		z = 1520,
		feature = nil
	},
	{
		x = 3472,
		z = 1872,
		feature = nil
	},
	{
		x = 6496,
		z = 1984,
		feature = nil
	},
	{
		x = 3264,
		z = 2240,
		feature = nil
	},
	{
		x = 3776,
		z = 2288,
		feature = nil
	},
	{
		x = 5392,
		z = 2544,
		feature = nil
	},
	{
		x = 4816,
		z = 2560,
		feature = nil
	},
	{
		x = 6800,
		z = 2576,
		feature = nil
	},
	{
		x = 6256,
		z = 2640,
		feature = nil
	},
	{
		x = 8192,
		z = 2944,
		feature = nil
	},
	{
		x = 6528,
		z = 2960,
		feature = nil
	},
	{
		x = 4880,
		z = 2992,
		feature = nil
	},
	{
		x = 9312,
		z = 3056,
		feature = nil
	},
	{
		x = 10080,
		z = 3200,
		feature = nil
	},
	{
		x = 400,
		z = 3248,
		feature = nil
	},
	{
		x = 9472,
		z = 3296,
		feature = nil
	},
	{
		x = 3232,
		z = 3376,
		feature = nil
	},
	{
		x = 560,
		z = 3392,
		feature = nil
	},
	{
		x = 10112,
		z = 3424,
		feature = nil
	},
	{
		x = 784,
		z = 3600,
		feature = nil
	},
	{
		x = 304,
		z = 3616,
		feature = nil
	},
	{
		x = 7200,
		z = 3824,
		feature = nil
	},
	{
		x = 1696,
		z = 4064,
		feature = nil
	},
	{
		x = 5520,
		z = 4416,
		feature = nil
	},
	{
		x = 4704,
		z = 4576,
		feature = nil
	},
	{
		x = 5008,
		z = 4848,
		feature = nil
	},
	{
		x = 2736,
		z = 4880,
		feature = nil
	},
	{
		x = 3104,
		z = 5024,
		feature = nil
	},
	{
		x = 5280,
		z = 5152,
		feature = nil
	},
	{
		x = 7088,
		z = 5296,
		feature = nil
	},
	{
		x = 3216,
		z = 5392,
		feature = nil
	},
	{
		x = 4784,
		z = 5504,
		feature = nil
	},
	{
		x = 5728,
		z = 5504,
		feature = nil
	},
	{
		x = 7472,
		z = 5536,
		feature = nil
	},
	{
		x = 7024,
		z = 5664,
		feature = nil
	},
	{
		x = 9840,
		z = 5712,
		feature = nil
	},
	{
		x = 8320,
		z = 5776,
		feature = nil
	},
	{
		x = 2032,
		z = 5968,
		feature = nil
	},
	{
		x = 10048,
		z = 5984,
		feature = nil
	},
	{
		x = 608,
		z = 6128,
		feature = nil
	},
	{
		x = 384,
		z = 6320,
		feature = nil
	},
	{
		x = 5040,
		z = 6368,
		feature = nil
	},
	{
		x = 720,
		z = 6416,
		feature = nil
	},
	{
		x = 9568,
		z = 6480,
		feature = nil
	},
	{
		x = 9952,
		z = 6640,
		feature = nil
	},
	{
		x = 160,
		z = 6864,
		feature = nil
	},
	{
		x = 5360,
		z = 6944,
		feature = nil
	},
	{
		x = 4896,
		z = 6976,
		feature = nil
	},
	{
		x = 6448,
		z = 7024,
		feature = nil
	},
	{
		x = 6816,
		z = 7296,
		feature = nil
	},
	{
		x = 6656,
		z = 7648,
		feature = nil
	},
	{
		x = 3728,
		z = 8016,
		feature = nil
	},
	{
		x = 3168,
		z = 8032,
		feature = nil
	},
	{
		x = 6496,
		z = 8096,
		feature = nil
	},
	{
		x = 3472,
		z = 8368,
		feature = nil
	},
	{
		x = 5008,
		z = 8368,
		feature = nil
	},
	{
		x = 2288,
		z = 8464,
		feature = nil
	},
	{
		x = 7776,
		z = 8544,
		feature = nil
	},
	{
		x = 3568,
		z = 8688,
		feature = nil
	},
	{
		x = 752,
		z = 8736,
		feature = nil
	},
	{
		x = 5328,
		z = 9056,
		feature = nil
	},
	{
		x = 560,
		z = 9088,
		feature = nil
	},
	{
		x = 4816,
		z = 9088,
		feature = nil
	},
	{
		x = 9472,
		z = 9088,
		feature = nil
	},
	{
		x = 9040,
		z = 9136,
		feature = nil
	},
	{
		x = 2736,
		z = 9440,
		feature = nil
	},
	{
		x = 6784,
		z = 9472,
		feature = nil
	},
	{
		x = 784,
		z = 9504,
		feature = nil
	},
	{
		x = 8672,
		z = 9584,
		feature = nil
	},
	{
		x = 416,
		z = 9616,
		feature = nil
	},
	{
		x = 9008,
		z = 9856,
		feature = nil
	},
}

return resources
