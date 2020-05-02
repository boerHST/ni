# Vars

> All variables when used will be prepended with `ni.vars`.

---

## general

```lua
ni.vars.latency -- interval between executing the rotation
ni.vars.interrupt -- could be `all` or `wl` or `bl`
ni.vars.build -- build version of currently running client
ni.vars.debug -- is debug enabled/disabled?
ni.vars.customtarget -- token or guid of custom target
```

## hotkeys

```lua
ni.vars.hotkeys.aoe
ni.vars.hotkeys.cd
ni.vars.hotkeys.pause
ni.vars.hotkeys.custom
```

## profiles

```lua
ni.vars.profiles.primary
ni.vars.profiles.secondary
ni.vars.profiles.active
ni.vars.profiles.interrupt
ni.vars.profiles.enabled
ni.vars.profiles.useEngine
```

## units

```lua
ni.vars.units.follow
ni.vars.units.followEnabled
ni.vars.units.mainTank
ni.vars.units.mainTankEnabled
ni.vars.units.offTank
ni.vars.units.offTankEnabled
```

## combat

```lua
ni.vars.combat.started -- is combat started?
ni.vars.combat.time -- time since combat started
ni.vars.combat.melee -- is player melee?
ni.vars.combat.cd -- is cooldown toggled?
ni.vars.combat.aoe -- is aoe toggled?
ni.vars.combat.casting --  is player casting?
```
