local Log = require("eom/eom_log")
local MConsequence = {} --# assume MConsequence: M_CONSEQUENCE
--this object is recreated at the beginning of any new session, but contains no saved data.



--register a consequence.
--v function(name: string, min: number, max: number, onshift_callback: function(), everyturn_callback: function()) --> M_CONSEQUENCE
function MConsequence.new(name, min, max, onshift_callback, everyturn_callback) 
Log.write("MConsequence.new() called for ["..name.."] with range ["..tostring(min).."] to ["..tostring(max).."]")

local self = {}
setmetatable(self,{
    __index = MConsequence
})
--# assume self: M_CONSEQUENCE

self.name = name;
self.min = min;
self.max = max;
self.onshift_callback = onshift_callback;
self.everyturn_callback = everyturn_callback;

return self;

end;

return {
    new = MConsequence.new;
}