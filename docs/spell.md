# Spell

> All functions when used will be prepended with `ni.spell`.

---

## available

Arguments:

- **spell** `id|string`
- **stutter** `boolean` _default: true_

Returns: `boolean`

Checks if specified spell is available to use. Includes checks such as:

- [`ni.spell.gcd`](spell.md#gcd)
- [`ni.vars.combar.casting`](vars.md)
- [`ni.spell.cd`](spell.md#cd)
- [`ni.stopcastingtracker.shouldstop`](stopcasting.md)
- [`ni.player.powerraw`](player.md)
- [`ni.player.hpraw`](player.md)

!> [`ni.spell.available`](spell.md#available) is not the same as [`ni.spell.valid`](spell.md#valid).

```lua
if ni.spell.available("Fear") then
  -- Fear passess all the checks and is available
end
```

## cast

Arguments:

- **spell** `id|string`
- **target** `token|guid`

Returns: `void`

Casts the specified spell. If the target is provided it'll cast on that target, otherwise spell wll be casted on self.

```lua
ni.spell.cast("Shadow Bolt", "target")
```

## castat

Arguments:

- **spell** `id|string`
- **target** `token|guid`
- **offset** `number`

Returns: `void`

Casts specified spell which required click on the ground (e.g. Death and Decay, Rain of Fire, Blizzard).

```lua
ni.spell.castat("Rain of Fire", "target")
```

## castatqueue

Arguments:

- **spell** `id|string`
- **target** `token|guid`

Returns: `void`

Queues a specified spell to be casted on the ground once it's available.

```lua
ni.spell.castatqueue("Blizzard", "target")
```

## castqueue

Arguments:

- **spell** `id|string`
- **target** `token|guid`

Returns: `void`

Queues a specified spell to be casted once it's available.

```lua
ni.spell.castqueue("Fear", "target")
```

## castspells

Arguments:

- **spell** `id|string`
- **target** `token|guid`

Returns: `void`

Casts specified spells separated by pipe (`|`). If the target is provided it'll cast on that target, otherwise spells wll be casted on self. Does not work if spells more than one spell triggers global cooldown.

```lua
ni.spell.castspells("Heroic Strike|Bloodthirst", "target")
```

## casttime

Arguments:

- **spell** `id|string`

Returns: `number`

Calculates the cast time of specified spell.

```lua
local casttime = ni.spell.casttime("Immolate") -- 1.25
```

## cd

Arguments:

- **spell** `id|string`

Returns: `number`

Calculates specified spell's cooldown. If the spell is not on cooldown returns 0.

```lua
if not ni.spell.cd(47891) then
  -- Shadow Ward is not on cooldown
end
```

## gcd

Arguments:

Returns: `boolean`

Checks if global cooldown is triggered.

```lua
if not ni.spell.gcd() then
  -- Global cooldown is not active, we can do something
end
```

## id

Arguments:

- **spellname** `string`

Returns: `number|nil`

Converts spell's name into spell id. If spell doesn't exist returns nil.

```lua
local spellid = ni.spell.id("Life Tap") -- 57946
```

## stopcasting

Arguments:

Returns: `void`

Stops casting.

```lua
ni.spell.stopcasting()
```

## stopchanneling

Arguments:

Returns: `void`

Stops channeling.

```lua
ni.spell.stopchanneling()
```

## valid

Arguments:

- **spell** `id|string`
- **target** `token|guid`
- **facing** `boolean` _default: false_
- **los** `boolean` _default: false_
- **friendly** `boolean` _default: false_

Returns: `boolean`

This functions ensures that a spell can be casted at specific target. It includes checks such as:

!> [`ni.spell.valid`](spell.md#valid) is not the same as [`ni.spell.available`](spell.md#available).

- [`ni.unit.exists`](unit.md#exists)
- [`ni.player.los`](player.md)
- [`ni.player.isfacing`](player.md)

```lua
if ni.spell.valid("Fear", "target") then
  -- Fear meets all of the critera to be valid
end
```
