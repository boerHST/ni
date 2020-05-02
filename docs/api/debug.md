# Debug

> All functions when used will be prepended with `ni.debug`.

---

## print

Arguments:

- **message** `string`

Returns: `table`, `boolean`

Prints the message if `ni.vars.debug` is set to true.

```lua
ni.debuf.print("Test") -- Won't print
ni.vars.debug = true
ni.debuf.print("Test") -- Will print
```

## log

Arguments:

- **message** `string`
- **error** `boolean` _optional_

Returns: `void`

Prints the message in the console of ni's application. Eror is optional, true for error message and empty for false or normal.

```lua
ni.debug.log("Test")
```

## popup

Arguments:

- **title** `string`
- **body** `string`

Returns: `void`

Creates a popup with specified title and body.

```lua
ni.debuf.popup("This is the title", "This is the body.")
```
