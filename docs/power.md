# Power

> All functions when used will be prepended with `ni.power`.

If you only need to get unit's current power percent - there are two shorthand functions such as:

- [`ni.unit.power`](unit.md#power)
- [`ni.unit.powerraw`](unit.md#powerraw)
- [`ni.player.power`](player.md).
- [`ni.player.power`](player.md).

By default power type will match specialization's current power type.

---

## current

Arguments:

- **unit** `guid|token`
- **type** `name|id`

Returns: `number`

Calculates unit's current power percent.

```lua
local power = ni.power.current("player") -- 90%
```

## currentraw

Arguments:

- **unit** `guid|token`
- **type** `name|id`

Returns: `number`

Calculates unit's current power.

```lua
local power = ni.power.currentraw("player") -- 20000 mana
```

## ismax

Arguments:

- **unit** `guid|token`
- **type** `name|id`

Returns: `boolean`

Checks if unit's power is at its maximum.

```lua
if ni.power.ismax("player") then
  -- Player's power is at 100%
end
```

## max

Arguments:

- **unit** `guid|token`
- **type** `name|id`

Returns: `number`

Calculates unit's maximum power.

```lua
local maxpower = ni.power.max("target")
```
