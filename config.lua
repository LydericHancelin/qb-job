Config = {}

-- ADMIN AUTHORIZATIONS
Config.AuthorizedIds = {
    "insertcitizenidhere",
}

-- JOB INFOS
Config.jobname = "jobname" -- Name of your job
Config.stashname = "jobstash" -- Name of stash for your job

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
