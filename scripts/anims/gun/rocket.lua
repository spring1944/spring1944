-- GUN
local backblast = piece "backblast"
local tubes = piece "tubes"


local tags, poses, keyframes, keyframeDelays = include "anims/gun/gun_anim.lua"
tags.pitchPiece = tubes
tags.cegPiece = backblast

return tags, poses, keyframes, keyframeDelays
