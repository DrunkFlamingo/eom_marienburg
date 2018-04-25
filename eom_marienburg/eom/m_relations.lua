local Log = require("eom/eom_log")
local MTrait = require("eom/m_trait")
local MConsequence = require("eom/m_consequence")
local MRelation = {} --#assume MRelation: M_RELATION


--This object MUST be reobjectified at the beginning of every new session.


--v function(info: map<string, WHATEVER>) --> M_RELATION
function MRelation.new(info) 
    Log.write("Relation.new called for ["..info.sub_key.."] and ["..info.name.."]");
    local self = {};
    setmetatable(self, {
        __index = MRelation
    })
    --#assume self: M_RELATION
    self.name = info.name --: string
    self.subculture = info.sub_key --:string
    self.value = info.value --:number
    self.traits_index = {} --:vector<M_TRAIT>
    self.consequence_index = {} --:vector<M_CONSEQUENCE>

    return self;
end;



--v function(self: M_RELATION) --> map<string, WHATEVER>
function MRelation.PrepareToSave(self)
    local i = {}
    i.name = self.name;
    i.sub_key = self.subculture;
    i.value = self.value;

    return i;
end;

--v function(self: M_RELATION, trait: M_TRAIT)
function MRelation.RegisterTrait(self, trait)
    local tindex = self.traits_index;
    table.insert(tindex, trait);
    Log.write("RegisterTrait() called for relation ["..self.name.."] and added trait ["..trait.name.."] to the trait index");
end;

--v function(self: M_RELATION)
function MRelation.ActivateTraits(self)
    Log.write("ActivateTraits called for ["..self.name.."]")
    local tindex = self.traits_index;
    for i = 1, #tindex do
        local t = tindex[i];
        core:add_listener(
            t.name,
            t.event,
            t.condition,
            t.callback,
            true
        );
        Log.write("ActivateTraits created a listener for trait ["..t.name.."]")
    end
end;




--v function(self: M_RELATION, consequence: M_CONSEQUENCE)
function MRelation.RegisterConsequence(self, consequence)
    local cindex = self.consequence_index;
    table.insert(cindex, consequence)
    Log.write("RegisterConsequence() called for relation ["..self.name.."] and added consequence ["..consequence.name.."] to the consequence index")
end;

--v function(self: M_RELATION)
function MRelation.ActivateConsequences(self)
    Log.write("ActivateConsequences() called for ["..self.name.."]")
    local cindex = self.consequence_index;
    for i = 1, #cindex do
        local c = cindex[i];
        core:add_listener(
            c.name,
            "FactionTurnStart",
            function(context)
                return ( context:faction():is_human() and context:faction():name() == "wh_main_emp_marienburg" and ( self.value > c.min and self.value < c.max ) )
            end,
            function(context)
                if cm:get_saved_value("m_"..self.name.."_consequence") == c.name then
                    c.everyturn_callback();
                else 
                    cm:set_saved_value("m_"..self.name.."_consequence", c.name)
                    c.everyturn_callback();
                    c.onshift_callback();
                end
            end,
            true
        );
        Log.write("ActivateConsequences() created a listener for ["..c.name.."]");
    end

end;

--v function(self: M_RELATION, quantity: number)
function MRelation.ImproveRelation(self, quantity)
    local ov = self.value;
    local nv = ov + quantity;
    Log.write("increasing relations with ["..self.name.."] by ["..tostring(quantity).."] from ["..tostring(self.value).."] to ["..tostring(nv).."]")
        if nv > 100 then
            Log.write("relation exceeded maximum, setting it to 100")
            nv = 100;
        end
    self.value = nv;
end;

--v function(self: M_RELATION, quantity: number)
function MRelation.HarmRelation(self, quantity)
    local ov = self.value;
    local nv = ov - quantity;
    Log.write("decrease relations with ["..self.name.."] by ["..tostring(quantity).."] from ["..tostring(self.value).."] to ["..tostring(nv).."]")
        if nv < 0 then
            Log.write("relation undershot minimum, setting it to 0")
            nv = 0;
        end
    self.value = nv;
end;









return {
    new = MRelation.new;
}