-- Secure Type Module (Modern Replacement)
-- No hacks, no pcall abuse, uses Roblox typeof()

local Type = {}

-- Basic type checks

function Type.isInstance(value)
return typeof(value) == "Instance"
end

function Type.isEnum(value)
return typeof(value) == "EnumItem"
end

function Type.isVector3(value)
return typeof(value) == "Vector3"
end

function Type.isVector2(value)
return typeof(value) == "Vector2"
end

function Type.isColor3(value)
return typeof(value) == "Color3"
end

function Type.isCFrame(value)
return typeof(value) == "CFrame"
end

function Type.isUDim2(value)
return typeof(value) == "UDim2"
end

function Type.isUDim(value)
return typeof(value) == "UDim"
end

function Type.isRay(value)
return typeof(value) == "Ray"
end

-- Number checks

function Type.isNumber(value)
return typeof(value) == "number"
end

function Type.isInteger(value)
return typeof(value) == "number" and value % 1 == 0
end

function Type.isPositiveInteger(value)
return Type.isInteger(value) and value > 0
end

-- Table checks

function Type.isArray(value)
if typeof(value) ~= "table" then
return false
end

```
local count = 0

for k, _ in pairs(value) do
	if not Type.isPositiveInteger(k) then
		return false
	end
	count += 1
end

return count == #value
```

end

-- Enum coercion (SAFE)

function Type.coerceEnum(value, enumType)
if typeof(enumType) ~= "Enum" then
error("Invalid enumType", 2)
end

```
for _, item in ipairs(enumType:GetEnumItems()) do
	if value == item or value == item.Name or value == item.Value then
		return item
	end
end

error("Cannot coerce value to enum", 2)
```

end

-- Type getter (clean and reliable)

function Type.getType(value)
local t = typeof(value)

```
if t == "Instance" then
	return value.ClassName
end

return t
```

end

return Type
