#!/bin/bash
# Author: Tobi Vollebregt
# License: GNU General Public License v2
#
# Makes a release of the AI by creating mutator for
# current stable Spring: 1944 release.
#

mkdir .tmp
cp -r * .tmp/
rm -fv .tmp/mutator.zip .tmp/mutator.sdz

# Generate modinfo.lua for Operation Konstantin (v0.92)
cat > .tmp/modinfo.lua << EOD
-- Author: Tobi Vollebregt
-- License: GNU General Public License v2

local modinfo = {
	name = "Spring: 1944 Konstantin + C.R.A.I.G. (v1)",
	shortName = "S44",
	game = "Spring 1944",
	shortGame = "S44",
	mutator = "AI for Spring: 1944",
	description = "AI for Spring: 1944",
	url = "http://www.spring1944.com",
	modtype = "1",
	depend = {
		"Spring: 1944 Operation Konstantin (v0.92)"
	},
}

return modinfo
EOD

# Disable debugging.
sed -i 's/^local CRAIG_Debug_Mode = 1/local CRAIG_Debug_Mode = 0/g' \
	.tmp/LuaRules/Gadgets/craig/main.lua

# Zip it & cleanup.
cd .tmp &&
zip -r ../mutator.zip * &&
cd .. &&
rm -rf .tmp &&
mv mutator.zip mutator.sdz

echo "==> Mutator created in mutator.sdz <=="
