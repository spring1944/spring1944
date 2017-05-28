
 -- ai_spam.lua
     
-- Subsequent permanent assualt mode ai gadget
     
function gadget:GetInfo()
    return {
        name = "Spammer",
        desc = "A spammer ai gadget",
        author = "Code_Man",
        date = "27/6/2014",
        license = "MIT X11",
        layer = 1,
        enabled = true
    }
end
     
if (not gadgetHandler:IsSyncedCode ()) then
    return false
end
     
include ("LuaRules/Gadgets/spam/main.lua")
     

