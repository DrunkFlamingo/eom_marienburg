local Log = require("eom/eom_log")
local MRelation = require("eom/m_relations");
local MReform = require("eom/m_reform")
local Marienburg = {} --# assume Marienburg: M_MODEL

--v function() --> M_MODEL
function Marienburg.new()
    Log.write("Marienburg Model is being created")
    local self = {};
    setmetatable(self, {
        __index = Marienburg
    })
    --#assume self: M_MODEL

    self.name = "marienburg" --:string
    self.faction = get_faction("wh_main_emp_marienburg") --: CA_FACTION
    self.relation_index = {} --: vector<M_RELATION>
    self.reform_index = {} --: vector<M_REFORM>
    self.cm = get_cm()

    return self;
end;

--v function(self: M_MODEL) --> map<string, WHATEVER>
function Marienburg.PrepareSaveTable(self)
    local si = {
        relation_index = {},
        reform_index = {}
    };

    local rindex = self.relation_index;
    for i = 1, #rindex do
        local r = rindex[i];
        local i = r:PrepareToSave();
        local saved_index = si["relation_index"];
        table.insert(saved_index, i);
    end;

    return si;
end;


--v function(self: M_MODEL, relation: M_RELATION) 
function Marienburg.AddRelation(self, relation)
    Log.write("adding a relation ["..relation.subculture.."] to the relation list")
    local relation_index = self.relation_index;
    table.insert(relation_index, relation);
    relation:ActivateTraits()
    relation:ActivateConsequences()
end;

--v function(self: M_MODEL, name: string) --> WHATEVER
function Marienburg.RelationByKey(self, name)
    local rindex = self.relation_index;
    for i = 1, #rindex do
        local r = rindex[i];
        if r.name == name then
            return r;
        end
    end
    return nil;
end;

--v function(self: M_MODEL, name: string, quantity: number)
function Marienburg.IncreaseNamedRelation(self, name, quantity)
    if Marienburg.RelationByKey(self, name) == nil then
        Log.write("ERROR: IncreaseNamedRelation() cannot find the named relation for which the command specified, aborting")
        return
    end
    Log.write("IncreaseNamedRelation() called for ["..name.."] with quantity ["..tostring(quantity).."]")
    local r = Marienburg.RelationByKey(self, name);
    r:ImproveRelation(quantity)

end;

--v function(self: M_MODEL, name: string, quantity: number)
function Marienburg.DecreaseNamedRelation(self, name, quantity)
    if Marienburg.RelationByKey(self, name) == nil then
        Log.write("ERROR: DecreaseNamedRelation() cannot find the named relation for which the command specified, aborting")
        return
    end
    Log.write("DecreaseNamedRelation() called for ["..name.."] with quantity ["..tostring(quantity).."]")
    local r = Marienburg.RelationByKey(self, name);
    r:HarmRelation(quantity)

end;



return {
    new = Marienburg.new;
}