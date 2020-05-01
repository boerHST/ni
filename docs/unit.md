# Unit

!> All functions when used will be prepended with `ni.unit`.

---

## exists

Arguments:

- **target** `guid|token`

Returns: `boolean`

Checks if specified unit exists in viewable world. If you want to check if unit exists overall, you can use WoW's `UnitExists` function.

```lua
if ni.unit.exists("target") then
  -- Do something
end
```

## los

Arguments:

- **targetfrom** `guid|token`
- **targetto** `guid|token`

Returns: `boolean`

Checks if units have line of sight on each other.

```lua
if ni.unit.los("player", "target") then
  -- Do something
end
```

## creator

Arguments:

- **target** `guid|token`

Returns: `guid|nil`

Returns a `guid` if specified unit has a creator or `nil` if it doesn't.

```lua
local creator = ni.unit.creator("playerpet");

if UnitGUID("player") == creator then
  -- We're the creator of the checked unit
end
```

## creations

Arguments:

- **target** `guid|token`

Returns: `table|nil`

Table of all the units checked creations (i.e. totems, pets) or nil if there is none.

```lua
local creations = ni.unit.creations("player");

for i = 1, #creations do
  local creature = creations[i]
  -- Do something
end
```

## creaturetype

Arguments:

- **target** `guid|token`

Returns: `number`

Numerical type of the unit checked.

```lua
local type = ni.unit.creaturetype("playerpet")

if type == 3 then
  --Our pet is a demon
end
```

## readablecreaturetype

Arguments:

- **target** `guid|token`

Returns: `string`

Readable creature string of the unit checked.

```lua
local type = ni.unit.readablecreaturetype("playerpet")

if type == "Demon" then
  -- Do something
end
```

## istotem

Arguments:

- **target** `guid|token`

Returns: `boolean`

Checks whether the creature is a totem. Shorthand function for [creaturetype](unit.md#creaturetype).

```lua
if ni.unit.istotem("target") then
  -- Do something
end
```
