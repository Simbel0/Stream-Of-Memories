local Utils = {}

table.filter = function(tbl, filter)
    for i=#tbl, 1, -1 do
        if not filter(tbl[i]) then
            table.remove(tbl, i)
        end
    end
end

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

function Utils.lerp(a, b, t)
    return a + t * (b - 1)
end

function Utils.preciseLerp(a, b, t)
    return (1 - t)* a + t * b
end

function Utils.clamp(val, min, max)
    return math.max(math.min(val, max), min)
end

function Utils.merge(tbl, other, deep)
    if Utils.isArray(other) then
        -- If the source table is an array, just append the values
        -- to the end of the destination table.
        for _,v in ipairs(other) do
            table.insert(tbl, v)
        end
    else
        for k,v in pairs(other) do
            if deep and type(tbl[k]) == "table" and type(v) == "table" then
                -- If we're deep merging and both values are tables,
                -- merge the tables together.
                Utils.merge(tbl[k], v, true)
            else
                -- Otherwise, just copy the value over.
                tbl[k] = v
            end
        end
    end
    return tbl
end

function Utils.simpleTitleCase(str)
    local w = str:sub(1, 1)
    local ord = str:sub(2, -1)

    return w:upper()..ord
end

function Utils.generateBS()
    local str = ""
    for i=1,love.math.random(2, 15) do
        str = str..string.char(love.math.random(32, 126))
    end
end

function Utils.RandomNegation()
    if love.math.random() < 0.5 then
        return -1
    else
        return 1
    end
end

function Utils.copy(tbl)
    local new_tbl = {}
    for k,v in pairs(tbl) do
        if type(v) == "table" then
            new_tbl[k] = copy(v)
        else
            new_tbl[k] = v
        end
    end

    return new_tbl
end

function Utils.getIndexFromValue(tbl, value)
    for i,v in ipairs(tbl) do
        if v == value then
            return i
        end
    end
end

function Utils.getPreviousValueInArray(tbl, value)
    local index = Utils.getIndexFromValue(tbl, value)
    if index == nil then
        error("Utils: The given value was not in the given array!")
    elseif index <= 1 then
        return tbl[index]
    end
    return tbl[index-1]
end

function Utils.getNextValueInArray(tbl, value)
    local index = Utils.getIndexFromValue(tbl, value)
    if index == nil then
        error("Utils: The given value was not in the given array!")
    elseif index >= #tbl then
        return tbl[index]
    end
    return tbl[index+1]
end

function Utils.isInTable(value, tbl)
    for i,v in ipairs(tbl) do
        if v == value then
            return true
        end
    end
    return false
end

function Utils.stringContains(value, strTbl)
    for i,v in ipairs(strTbl) do
        local s, e = value:lower():find(v:lower())
        if s then
            return true, s, e
        end
    end
    return false
end

return Utils