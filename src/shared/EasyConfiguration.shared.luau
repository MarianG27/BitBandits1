-- Secure EasyConfiguration
-- Clean, validated, and safe for server-side use

local lib = {}

-- Only allow safe value objects
local AllowedTypes = {
StringValue = true,
IntValue = true,
NumberValue = true,
BoolValue = true,
Color3Value = true,
Vector3Value = true,
}

-- Only allow safe properties
local AllowedProps = {
Name = true,
Value = true,
Parent = true,
}

local function SafeModify(instance, values)
assert(type(values) == "table", "Values must be a table")

```
for key, val in pairs(values) do
	if type(key) == "string" and AllowedProps[key] then
		instance[key] = val
	end
end

return instance
```

end

local function ValidateType(valueType)
if type(valueType) ~= "string" or not AllowedTypes[valueType] then
error("Invalid valueType: " .. tostring(valueType), 2)
end
end

local function ValidateValues(values)
if type(values) ~= "table" then
error("Values must be a table", 2)
end

```
if type(values.Name) ~= "string" then
	error("Values.Name must be a string", 2)
end
```

end

function lib.MakeEasyConfiguration(Configuration)
assert(typeof(Configuration) == "Instance", "Configuration must be an Instance")

```
local Config = {}

setmetatable(Config, {
	__index = function(_, key)
		if type(key) ~= "string" then
			error("Index must be a string", 2)
		end

		local lowered = key:lower()

		-- 🔧 Add new value
		if lowered == "addvalue" then
			return function(valueType, values)
				ValidateType(valueType)
				ValidateValues(values)

				local existing = Configuration:FindFirstChild(values.Name)

				if existing then
					if existing.ClassName ~= valueType then
						error("Type mismatch for existing value: " .. values.Name, 2)
					end
					return existing
				end

				local newInstance = Instance.new(valueType)
				SafeModify(newInstance, values)
				newInstance.Parent = Configuration

				return newInstance
			end
		end

		-- 🔍 Get value
		local obj = Configuration:FindFirstChild(key)

		if not obj then
			error("Config value not found: " .. key, 2)
		end

		if not AllowedTypes[obj.ClassName] then
			error("Invalid config type: " .. obj.ClassName, 2)
		end

		return obj.Value
	end,

	__newindex = function(_, key, newValue)
		if type(key) ~= "string" then
			error("Index must be a string", 2)
		end

		local obj = Configuration:FindFirstChild(key)

		if not obj then
			error("Cannot set non-existent config value: " .. key, 2)
		end

		if not AllowedTypes[obj.ClassName] then
			error("Invalid config type: " .. obj.ClassName, 2)
		end

		obj.Value = newValue
	end
})

return Config
```

end

return lib
