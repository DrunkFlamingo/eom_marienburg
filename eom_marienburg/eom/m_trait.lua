local Log = require("eom/eom_log");
local MTrait = {} --#assume MTrait: M_TRAIT

--create a new trait;

--v function(name: string, uitext: string, tooltip: string, event: string, condition: function(context: WHATEVER) --> boolean, callback: function(context: WHATEVER)) --> M_TRAIT
function MTrait.new(name, uitext, tooltip, event, condition, callback)
    local self = {}
    setmetatable(self,{
        __index = MTrait
    })
    --# assume self: M_TRAIT
    self.name = name;
    self.uitext = uitext;
    self.tooltip = tooltip;
    self.event = event;
    self.condition = condition;
    self.callback = callback;

    return self;

end;

return {
    new = MTrait.new;
}