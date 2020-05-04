# Quick start

Assuming you already downloaded ni from [Discord Channel](https://discord.gg/mBdcX5) this introductory guide will help you get up to speed.

Lets get started with the location of profiles.

```
addon
└───Core
└───Settings
└───Rotations
│	└───Data
│	└───Warlock
```

Two folders of our interest are `Data` and folder named by the class of our character. In this guide we will create a simple profile for `Warlock`. That means we are going to focus on these two folders.

Our profile needs to have a name - and for this guide we will call it `Warlock_Example`.

Please do the following steps:

#### 1. Create a file called `Warlock_Example.lua` inside the folder addon/Rotations/Warlock. Your folders should look like this:

```
addon
└───Core
└───Settings
└───Rotations
│	└───Data
│	└───Warlock
│	│	└───Warlock_Example.lua
```

2. Once the file is created, open it using your favourite text editor. [Our recommendation](getting-started/faq.md#which-text-editor-to-use)

#### 3. Copy and paste the following boilerplate code:

```lua
local queue = {
	"Print Hello"
}

local abilities = {
	["Print Hello"] = function()
		ni.debug.log("Hello")
	end
}

ni.bootstrap.rotation("Warlock_Example", queue, abilities)
```

!> Make sure that the name of file matches the name passed to `ni.bootstrap.rotation`

This is all that **ni** needs to run a profile. Presss `F12` and see if the word `Hello` is being printed to the console.

#### 4. In case we would like to have a dynamic queue, multiple queues which can change in real time, we can also pass a `function`.

```lua
local ishelloprinted = false

local queue = {
	"Print Hello"
}

local queue2 = {
	"Print Hello World"
}

local abilities = {
	["Print Hello"] = function()
		ishelloprinted = true
		ni.debug.log("Hello")
	end,
	["Print Hello World"] = function()
		ishelloprinted = false
		ni.debug.log("Hello World")
	end
}

local dynamicqueue = function()
	if ishelloprinted then
		return queue
	end

	return queue2
end

ni.bootstrap.rotation("Warlock_Example", dynamicqueue, abilities)
```

!> It's possible to only use one way to set the priority queue (either static or dynamic).

#### 5. In case we have some common functions or variables that we would like to share among multiple profiles - we can do it by creating Lua files in `Data` folder. Lets create `Data_Example.lua`.

```
addon
└───Core
└───Settings
└───Rotations
│	└───Data
│	│	└───Data_Example.lua
│	└───Warlock
│	│	└───Warlock_Example.lua
```

> You can name both files in **Warlock** and **Data** however you like, they don't need to follow any convention.

#### 6. Passing variables and functions between Data and Profile files can be done in two ways:

- by declaring and assigning globals (not recommended)
- by using `ni.data` and having a new unique namespace (`table`)

Lets use the second way and add the following to `Rotations/Data/Data_Example.lua`.

```lua
ni.data.example = {
 ishelloprinted = false
}
```

#### 7. To load data files to our profile we can use `ni.rotation.loadlua` function.

```lua
local data = {"Rotations\\Data\\Data_Example.lua"}
local queue = {
	"Print Hello"
}

local queue2 = {
	"Print Hello World"
}

local abilities = {
	["Print Hello"] = function()
		ni.data.example.ishelloprinted = true
		ni.debug.log("Hello")
	end,
	["Print Hello World"] = function()
		ni.data.example.ishelloprinted = false
		ni.debug.log("Hello World")
	end
}

local dynamicqueue = function()
	if ni.data.example.ishelloprinted then
		return queue
	end

	return queue2
end

ni.bootstrap.rotation("Warlock_Example", dynamicqueue, abilities, data)
```
