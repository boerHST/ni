# Generic

> This is for generic functions that don't fit in the categories.

---

## keypressed

Arguments:
- **key** `number`

Returns: `bool`

Returns true or false if the key specified is pressed (uses hex or decimal numbers; [Get key codes here](https://docs.microsoft.com/en-us/windows/win32/inputdev/virtual-key-codes))

```lua
if ni.functions.keypressed(0x41) and ni.functions.keypressed(0x42) then
  print("A and B are down");
end
```

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
