# Delay

> This is just a single `ni.delayfor` function.

---

## delayfor

Arguments:

- **delay** `number`
- **func** `function`
- **rest** `arguments`

Returns: `bool`

Delays a call for specified time on a specific function.

```lua
ni.delayfor(2, ni.spell.cast, "Shadow Bolt", "target")
-- Shadow Bolt will be casted 2 seconds from now
```
