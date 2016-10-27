require "clientDBBase"
local setmetatable = setmetatable
local getmetatable = getmetatable
local type = type
local tostring = tostring
local pairs = pairs
local ipairs = ipairs
local __m = {}

__m.__index = function (self, field)
	local index = self.__meta[field]
	if index == nil then
		return nil
	end
	
	if self[index] == nil then
		return nil;
	end

	self[field] = self[index]
	local fieldData = self[field]
	
	local __dict = self.__meta.__dict
	if __dict then
		if __dict[index] then
			fieldData.__meta = __dict[index]
			setmetatable(fieldData,__m)
		end
	end

	return fieldData
end

function TableLoader()
    for k, v in pairs(Table) do
        if type(v) == "table" and v.__meta ~= nil then
            v.get = function(...)
                local arg = {...}
                if #arg == 0 then
                    return
                end

                -- splice key
                local key
                if #arg == 1 then
                    key = arg[1] 
                    if type(key) == "string" then
                        key = tostring(key)
                    end
                else
                    for i,v in ipairs(arg) do
                        if i == 1 then
                            key = tostring(v)
                        else
                            key = key .."_" .. tostring(v)
                        end
                    end
                end
                if key == nil or key == "__meta" or key == "get"  then
                    return nil
                end

                local row = v[key]
                if row ~= nil then
                    if row.__meta == nil then
						row.__meta = v.__meta
                        setmetatable(row, __m)
                    end
                end

                return row
            end
        end
    end
end

TableLoader();