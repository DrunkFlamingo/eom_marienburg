--[[

>Create Model (always)
>Create Relations (newgame) or Restore them from load (oldgame)
>Create traits and add them to relations. (always)
>Create Consequences and add them to relations. (always)
>Add relations to model. (always)
>Add reforms to model (always)



Notes:
Events can be added as traits, since each trait is a listener





>


]]--

cm:set_saved_value("eom_marienburg", true)


local Log = require("eom/eom_log")
local Marienburg = require("eom/m_model")


--v function()
function eom_new_game()


end;

--v function()
function eom_load_game()

end;











--v function()
function eom_marienburg()
    
    if get_faction("wh_main_emp_marienburg"):is_human() then
        if cm:is_new_game() then
            eom_new_game();
        else
            eom_load_game();
        end
    end

end;
