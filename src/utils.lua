local Utils = {}

---- from Kristal

local function dumpKey(key)
    if type(key) == 'table' then
        return '('..tostring(key)..')'
    elseif type(key) == 'string' and (not key:find("[^%w_]") and not tonumber(key:sub(1,1)) and key ~= "") then
        return key
    else
        return '['..Utils.dump(key)..']'
    end
end

---
--- Returns a string converting a table value into readable text. Useful for debugging table values.
---
---@param o any          # The value to convert to a string.
---@return string result # The newly generated string.
---
function Utils.dump(o)
    if type(o) == 'table' then
        local s = '{'
        local cn = 1
        if Utils.isArray(o) then
            for _,v in ipairs(o) do
                if cn > 1 then s = s .. ', ' end
                s = s .. Utils.dump(v)
                cn = cn + 1
            end
        else
            for k,v in pairs(o) do
                if cn > 1 then s = s .. ', ' end
                s = s .. dumpKey(k) .. ' = ' .. Utils.dump(v)
                cn = cn + 1
            end
        end
        return s .. '}'
    elseif type(o) == 'string' then
        return '"' .. o .. '"'
    else
        return tostring(o)
    end
end

function Utils.isArray(tbl)
    for k,_ in pairs(tbl) do
        if type(k) ~= "number" then
            return false
        end
    end
    return true
end

function Utils.removeFromTable(tbl, value)
    for i,v in ipairs(tbl) do
        if v == value then
            return table.remove(tbl, i)
        end
    end
end

return Utils