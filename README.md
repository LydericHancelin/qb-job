# qb-job
Job for QB-Core Framework

## Dependencies
- [qb-core](https://github.com/qbcore-framework/qb-core)
- [qb-inventory](https://github.com/qbcore-framework/qb-inventory)
- [qb-bossmenu](https://github.com/qbcore-framework/qb-bossmenu)

## Screenshots
![Vehicle Spawner](https://imgur.com/bDYiFoG.png)
![Stash](https://imgur.com/8fvy9FA.png)
![On Duty/Off Duty](https://i.imgur.com/CM34EsL.png)

## Features
- To create a new job (ex : baker, gardener...) you just have to create a copy of qb-job and rename it with your job name (ex : qb-baker). Now you have to change config.lua datas. 
- /setnewjob_"yourjob" - Sets someone yourjob -- Replace "yourjob" by your job name
- /firejob_"yourjob" - Fires a yourjob worker -- Replace "yourjob" by your job name
- On Duty/Off Duty
- Choose vehicules in shared.lua and add them on config.lua.

## Installation
### Manual
- Download the script and put it in the `[qb]` directory.
- Import `qb-.sql` in your database
- Add the following code to your server.cfg/resouces.cfg
```
ensure qb-core
ensure qb-inventory
ensure qb-bossmenu
ensure qb-job
```

/!\ Be sure to add your new job on shared.lua like : 
```
	["jobname"] = {
		label = "jobname",
		defaultDuty = true,
		bossmenu = vector3(-175.750, -1530.35, 34.353),
			grades = {
            ['0'] = {
                name = "Recruit",
                payment = 50
            },
			['1'] = {
                name = "Novice",
                payment = 75
            },
			['2'] = {
                name = "Experienced",
                payment = 100
            },
			['3'] = {
                name = "Advanced",
                payment = 125
            },
			['4'] = {
                name = "Boss",
				isboss = true,
                payment = 150
            },
        },
	}

```

## Configuration
```
Config = {}

-- ADMIN AUTHORIZATIONS
Config.AuthorizedIds = {
    "insertcitizenidhere",
}

-- JOB INFOS
Config.jobname = "jobname" -- Name of your job
config.stashname = "jobstash" -- Name of stash for your job

-- WORKING LOCATIONS
Config.Locations = {
    ["exit"] = vector4(945.13, -975.84, 39.49, 181.5), -- DONT CHANGE --
    ["stash"] = vector4(-189.858, -1556.05, 34.955, 2.369), -- Stash position
    ["duty"] = vector4(-184.970, -1541.42, 34.315, 215.2), -- On duty / off Duty position
    ["vehicle"] = vector4(-190.750, -1530.35, 34.353, 217.5),  -- Garage position
}

-- WORKING VEHICULES -- [Vehicule name in shared.lua] = "Display name"
Config.Vehicles = {
    ["minivan"] = "Minivan (Leen Auto)", 
    ["blista"] = "Blista",
}
```
