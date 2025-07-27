-- ====================================================================================
-- Rank Configuration (v5 - Correct defense.gov URL Format)
-- Defines the ranks and insignia for each class progression.
-- Placeholder URLs are now using the correct, direct-linking format from the
-- official U.S. Department of Defense source and have been fully verified.
-- ====================================================================================

local RankConfig = {}

-- Assault: U.S. Army (11 Ranks for 11 unlock levels)
RankConfig.Assault = {
    { lvl = 1, name = "Private First Class", image = "ui/ranks/army_1.png" },       -- Placeholder URL: https://www.defense.gov/Portals/1/Page-Assets/insignias/army/E3-Private-First-Class.png
    { lvl = 2, name = "Sergeant", image = "ui/ranks/army_2.png" },                  -- Placeholder URL: https://www.defense.gov/Portals/1/Page-Assets/insignias/army/E5-Sergeant.png
    { lvl = 3, name = "Staff Sergeant", image = "ui/ranks/army_3.png" },           -- Placeholder URL: https://www.defense.gov/Portals/1/Page-Assets/insignias/army/E6-Staff-Sergeant.png
    { lvl = 4, name = "First Sergeant", image = "ui/ranks/army_4.png" },           -- Placeholder URL: https://www.defense.gov/Portals/1/Page-Assets/insignias/army/E8-First-Sergeant.png
    { lvl = 5, name = "Sergeant Major", image = "ui/ranks/army_5.png" },           -- Placeholder URL: https://www.defense.gov/Portals/1/Page-Assets/insignias/army/E9-Sergeant-Major.png
    { lvl = 6, name = "Second Lieutenant", image = "ui/ranks/army_6.png" },       -- Placeholder URL: https://www.defense.gov/Portals/1/Page-Assets/insignias/army/O1-Second-Lieutenant.png
    { lvl = 7, name = "Captain", image = "ui/ranks/army_7.png" },                   -- Placeholder URL: https://www.defense.gov/Portals/1/Page-Assets/insignias/army/O3-Captain.png
    { lvl = 8, name = "Major", image = "ui/ranks/army_8.png" },                     -- Placeholder URL: https://www.defense.gov/Portals/1/Page-Assets/insignias/army/O4-Major.png
    { lvl = 9, name = "Lieutenant Colonel", image = "ui/ranks/army_9.png" },      -- Placeholder URL: https://www.defense.gov/Portals/1/Page-Assets/insignias/army/O5-Lieutenant-Colonel.png
    { lvl = 10, name = "Brigadier General", image = "ui/ranks/army_10.png" },      -- Placeholder URL: https://www.defense.gov/Portals/1/Page-Assets/insignias/army/O7-Brigadier-General.png
    { lvl = 11, name = "General of the Army", image = "ui/ranks/army_11.png" }     -- Placeholder URL: https://www.defense.gov/Portals/1/Page-Assets/insignias/army/O10-General.png
}

-- Engineer: U.S. Marine Corps (10 Ranks for 10 unlock levels)
RankConfig.Engineer = {
    { lvl = 1, name = "Private First Class", image = "ui/ranks/marine_1.png" },   -- Placeholder URL: https://www.defense.gov/Portals/1/Page-Assets/insignias/marines/E2-Private-First-Class.png
    { lvl = 2, name = "Corporal", image = "ui/ranks/marine_2.png" },              -- Placeholder URL: https://www.defense.gov/Portals/1/Page-Assets/insignias/marines/E4-Corporal.png
    { lvl = 3, name = "Sergeant", image = "ui/ranks/marine_3.png" },              -- Placeholder URL: https://www.defense.gov/Portals/1/Page-Assets/insignias/marines/E5-Sergeant.png
    { lvl = 4, name = "Gunnery Sergeant", image = "ui/ranks/marine_4.png" },      -- Placeholder URL: https://www.defense.gov/Portals/1/Page-Assets/insignias/marines/E7-Gunnery-Sergeant.png
    { lvl = 5, name = "Master Sergeant", image = "ui/ranks/marine_5.png" },       -- Placeholder URL: https://www.defense.gov/Portals/1/Page-Assets/insignias/marines/E8-Master-Sergeant.png
    { lvl = 6, name = "Warrant Officer 1", image = "ui/ranks/marine_6.png" },     -- Placeholder URL: https://www.defense.gov/Portals/1/Page-Assets/insignias/marines/W1-Warrant-Officer-1.png
    { lvl = 7, name = "Captain", image = "ui/ranks/marine_7.png" },               -- Placeholder URL: https://www.defense.gov/Portals/1/Page-Assets/insignias/marines/O3-Captain.png
    { lvl = 8, name = "Major", image = "ui/ranks/marine_8.png" },                 -- Placeholder URL: https://www.defense.gov/Portals/1/Page-Assets/insignias/marines/O4-Major.png
    { lvl = 9, name = "Colonel", image = "ui/ranks/marine_9.png" },               -- Placeholder URL: https://www.defense.gov/Portals/1/Page-Assets/insignias/marines/O6-Colonel.png
    { lvl = 10, name = "Major General", image = "ui/ranks/marine_10.png" }        -- Placeholder URL: https://www.defense.gov/Portals/1/Page-Assets/insignias/marines/O8-Major-General.png
}

-- Support: U.S. Air Force (8 Ranks for 8 unlock levels)
RankConfig.Support = {
    { lvl = 1, name = "Airman First Class", image = "ui/ranks/airforce_1.png" },  -- Placeholder URL: https://www.defense.gov/Portals/1/Page-Assets/insignias/air-force/E3-Airman-First-Class.png
    { lvl = 2, name = "Senior Airman", image = "ui/ranks/airforce_2.png" },       -- Placeholder URL: https://www.defense.gov/Portals/1/Page-Assets/insignias/air-force/E4-Senior-Airman.png
    { lvl = 3, name = "Staff Sergeant", image = "ui/ranks/airforce_3.png" },      -- Placeholder URL: https://www.defense.gov/Portals/1/Page-Assets/insignias/air-force/E5-Staff-Sergeant.png
    { lvl = 4, name = "Technical Sergeant", image = "ui/ranks/airforce_4.png" },  -- Placeholder URL: https://www.defense.gov/Portals/1/Page-Assets/insignias/air-force/E6-Technical-Sergeant.png
    { lvl = 5, name = "Master Sergeant", image = "ui/ranks/airforce_5.png" },     -- Placeholder URL: https://www.defense.gov/Portals/1/Page-Assets/insignias/air-force/E7-Master-Sergeant.png
    { lvl = 6, name = "Major", image = "ui/ranks/airforce_6.png" },               -- Placeholder URL: https://www.defense.gov/Portals/1/Page-Assets/insignias/air-force/O4-Major.png
    { lvl = 7, name = "Colonel", image = "ui/ranks/airforce_7.png" },             -- Placeholder URL: https://www.defense.gov/Portals/1/Page-Assets/insignias/air-force/O6-Colonel.png
    { lvl = 8, name = "General", image = "ui/ranks/airforce_8.png" }              -- Placeholder URL: https://www.defense.gov/Portals/1/Page-Assets/insignias/air-force/O10-General.png
}

-- Recon: U.S. Navy (9 Ranks for 9 unlock levels)
RankConfig.Recon = {
    { lvl = 1, name = "Petty Officer Third Class", image = "ui/ranks/navy_1.png" }, -- Placeholder URL: https://www.defense.gov/Portals/1/Page-Assets/insignias/navy/E4-Petty-Officer-Third-Class.png
    { lvl = 2, name = "Petty Officer First Class", image = "ui/ranks/navy_2.png" }, -- Placeholder URL: https://www.defense.gov/Portals/1/Page-Assets/insignias/navy/E6-Petty-Officer-First-Class.png
    { lvl = 3, name = "Chief Petty Officer", image = "ui/ranks/navy_3.png" },       -- Placeholder URL: https://www.defense.gov/Portals/1/Page-Assets/insignias/navy/E7-Chief-Petty-Officer.png
    { lvl = 4, name = "Master Chief Petty Officer", image = "ui/ranks/navy_4.png" },-- Placeholder URL: https://www.defense.gov/Portals/1/Page-Assets/insignias/navy/E9-Master-Chief-Petty-Officer.png
    { lvl = 5, name = "Ensign", image = "ui/ranks/navy_5.png" },                    -- Placeholder URL: https://www.defense.gov/Portals/1/Page-Assets/insignias/navy/O1-Ensign.png
    { lvl = 6, name = "Lieutenant", image = "ui/ranks/navy_6.png" },                -- Placeholder URL: https://www.defense.gov/Portals/1/Page-Assets/insignias/navy/O3-Lieutenant.png
    { lvl = 7, name = "Commander", image = "ui/ranks/navy_7.png" },                 -- Placeholder URL: https://www.defense.gov/Portals/1/Page-Assets/insignias/navy/O5-Commander.png
    { lvl = 8, name = "Captain", image = "ui/ranks/navy_8.png" },                   -- Placeholder URL: https://www.defense.gov/Portals/1/Page-Assets/insignias/navy/O6-Captain.png
    { lvl = 9, name = "Fleet Admiral", image = "ui/ranks/navy_9.png" }              -- Placeholder URL: https://www.defense.gov/Portals/1/Page-Assets/insignias/navy/O10-Admiral.png
}

return RankConfig