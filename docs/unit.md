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

| Numeric | String       |
| ------- | ------------ |
| 0       | Unknown      |
| 1       | Beast        |
| 2       | Dragon       |
| 3       | Demon        |
| 4       | Elemental    |
| 5       | Giant        |
| 6       | Undead       |
| 7       | Humanoid     |
| 8       | Critter      |
| 9       | Mechanical   |
| 10      | NotSpecified |
| 11      | Totem        |
| 12      | NonCombatPet |
| 13      | GasCloud     |

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

| Numeric | String       |
| ------- | ------------ |
| 0       | Unknown      |
| 1       | Beast        |
| 2       | Dragon       |
| 3       | Demon        |
| 4       | Elemental    |
| 5       | Giant        |
| 6       | Undead       |
| 7       | Humanoid     |
| 8       | Critter      |
| 9       | Mechanical   |
| 10      | NotSpecified |
| 11      | Totem        |
| 12      | NonCombatPet |
| 13      | GasCloud     |

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

## combatreach

Arguments:

- **target** `guid|token`

Returns: `number`

The combat reach of the unit checked (default return of 0).

```lua
local combatreach = ni.unit.combatreach("player");
-- Would most likely print 1.5 as the combat reach of the player unit
```

## isboss

Arguments:

- **target** `guid|token`

Returns: `boolean`

Checks if specific unit is a boss.

```lua
if ni.unit.isboss("target") then
  -- Do something
end
```

## threat

Arguments:

- **unit** `guid|token`
- **unittargeted** `guid|token` _optional_

Returns: `number`

Calculates a threat of `unit`. If second argument is passed threat is calculated according to `unittargeted`.

```lua
local threat = ni.unit.threat("player", "target")
```

## ismoving

Arguments:

- **unit** `guid|token`

Returns: `boolean`

Checks if unit is moving or not.

```lua
if ni.unit.ismoving("player") then
  -- Do something
end
```

## isdummy

Arguments:

- **unit** `guid|token`

Returns: `boolean`

Checks whether or not the unit is a dummy.

```lua
if ni.unit.isdummy("target") then
  -- Do something
end
```

## ttd

Arguments:

- **unit** `guid|token`

Returns: `number`

Retrieves time to die of specified unit in seconds. If unit doesn't exist it returns `-2`, if the unit is a dummy or if the unit somehow skipped the ttd calculation returns `99`.

```lua
if ni.unit.ttd("target") > 10 then
  -- Do something
end
```

## hp

Arguments:

- **unit** `guid|token`

Returns: `number`

Calculates and returns current percent of the unit's health.

```lua
if ni.unit.hp("target") > 90 then
  -- Unit has more than 90% hp
end
```

## hpraw

Arguments:

- **unit** `guid|token`

Returns: `number`

Calculates and returns current unit's health.

```lua
if ni.unit.hpraw("target") > 20000 then
  -- Unit has more than 20k hp
end
```

## power

Arguments:

- **unit** `guid|token`
- **type** `string` _optional_

Returns: `number`

Calculates and returns current percent of the unit's power (e.g. mana, energy, focus, etc.).

```lua
if ni.unit.power("target") > 90 then
  -- Unit has more than 90% power
end
```

## info

Arguments:

- **unit** `guid|token`

Returns: `number`

Retrieves detailed information about the unit.

```lua
local x, y, z, facing, unittype, target, guid, height = ni.unit.info("target")
```

## isfacing

Arguments:

- **unit** `guid|token`
- **target** `guid|token`

Returns: `boolean`

Checks if `unit` is facing `target`.

```lua
if ni.unit.isfacing("player", "target") then
  -- Player is facing the target
end
```

## isbehind

Arguments:

- **unit** `guid|token`
- **target** `guid|token`

Returns: `boolean`

Checks if `unit` is behind `target`.

```lua
if ni.unit.isbehind("player", "target") then
  -- Player is behind the target
end
```

## distance

Arguments:

- **unit** `guid|token`
- **target** `guid|token`

Returns: `number|nil`

Calculates the distance between `unit` and `target` in yards. If any of the arguments are not passed this function will return `nil`.

```lua
if ni.unit.distance("player", "target") < 40 then
  -- Target is closer than 40 yards
end
```

## enemiesinrange

Arguments:

- **unit** `guid|token`
- **range** `number`

Returns: `table`

Returns a table of all enemies which are in range of specified unit. Each enemy has `guid`, `name` and `distance` properties.

```lua
local enemies = ni.unit.enemiesinrange("player", 30)

for i = 1, #enemies do
  local target = enemies[i].guid
  local name = enemies[i].name
  local distance = enemies[i].distance
  -- Do something with the enemy target
end
```

## friendsinrange

Arguments:

- **unit** `guid|token`
- **range** `number`

Returns: `table`

Returns a table of all friendlies which are in range of specified unit. Each friendly has `guid`, `name` and `distance` properties.

```lua
local friends = ni.unit.friendsinrange("player", 30)

for i = 1, #friends do
  local target = friends[i].guid
  local name = friends[i].name
  local distance = friends[i].distance
  -- Do something with the friendly target
end
```

## unitstargeting

Arguments:

- **unit** `guid|token`
- **friendlies** `boolean` _default: false_

Returns: `table`

Returns a table of all units which are in range of specified unit. Each unit has `guid`, `name` and `distance` properties.

```lua
local units = ni.unit.unitstargeting("player")

for i = 1, #units do
  local target = units[i].guid
  local name = units[i].name
  local distance = units[i].distance
  -- Do something with the units targeting the player
end
```

## iscasting

Arguments:

- **unit** `guid|token`

Returns: `boolean`

Checks if specified unit is casting.

```lua
if ni.unit.iscasting("target") then
  -- Target is casting
end
```

## ischanneling

Arguments:

- **unit** `guid|token`

Returns: `boolean`

Checks if specified unit is channeling.

```lua
if ni.unit.ischanneling("target") then
  -- Target is channeling
end
```

## hasaura

Arguments:

- **unit** `guid|token`
- **aura** `name|id`

Returns: `boolean`

Checks if specified unit has aura.

```lua
if ni.unit.hasaura("player", "Crusader Aura") then
  -- Player has Crusader Aura
end
```

## hasbuff

Arguments:

- **target** `guid|token`
- **id** `name|id`
- **caster** `guid|token` _optional_
- **exact** `boolean` _default: false_

Returns: `boolean`

Checks if specified unit has certain buff.

```lua
if ni.unit.hasbuff("target", "Life Tap", "player") then
  -- Target has Life Tap active
end
```

## hasbuffs

Arguments:

- **target** `guid|token`
- **ids** `name|id`
- **caster** `guid|token` _optional_
- **exact** `boolean` _default: false_

Returns: `boolean`

Checks if specified unit has certain buffs separated by `&&`.

```lua
if ni.unit.hasbuffs("target", "63321&&Fel Armor", "player") then
  -- Target has both Life Tap and Fel Armor
end
```

## hasdebufftype

Arguments:

- **target** `guid|token`
- **types** `string|string`

Returns: `boolean`

Checks if specified unit has certain debuff types. Multiple types can be passed by using the pipe character (`|`).

| Type    |
| ------- |
| Magic   |
| Poison  |
| Curse   |
| Disease |

```lua
if ni.unit.hasdebufftype("target", "Poison|Magic") then
	-- Target has either a poison or magic debuff present
end
```

## hasdebuff

Arguments:

- **target** `guid|token`
- **id** `name|id`
- **caster** `guid|token` _optional_
- **exact** `boolean` _default: false_

Returns: `boolean`

Checks if specified unit has certain debuff.

```lua
if ni.unit.hasdebuff("target", "Unstable Affliction", "player") then
  -- Target has Unstable Affliction
end
```

## hasdebuffs

Arguments:

- **target** `guid|token`
- **ids** `name|id`
- **caster** `guid|token` _optional_
- **exact** `boolean` _default: false_

Returns: `boolean`

Checks if specified unit has certain debuffs separated by `&&`.

```lua
if ni.unit.hasdebuffs("target", "Faerie Fire&&Curse of Agony", "player") then
  -- Target has both Faerie Fire and Curse of Agony
end
```

## buffremaining

Arguments:

- **target** `guid|token`
- **id** `name|id`
- **caster** `guid|token` _optional_

Returns: `boolean`

Calculates the remaining time of the buff on target in seconds.

```lua
if ni.unit.buffremaining("target", 48441, "player") < 5 then
  -- Target has Rejuvenation for less than 5 seconds
end
```

## isplayer

Arguments:

- **unit** `guid|token`

Returns: `boolean`

Checks if passed unit is a player type.

```lua
if ni.unit.isplayer("target") then
  -- Target is a player type
end
```
