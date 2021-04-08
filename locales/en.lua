Locales['en'] = {
  -- Inventory
  ['inventory'] = 'inventory %s / %s',
  ['use'] = 'use',
  ['give'] = 'give',
  ['remove'] = 'remove',
  ['return'] = 'return',
  ['give_to'] = 'give to',
  ['amount'] = 'amount',
  ['giveammo'] = 'give ammo',
  ['amountammo'] = 'ammunition',
  ['noammo'] = 'you dont have enough ammo!',
  ['gave_item'] = 'you have given ~y~%sx~s~ ~b~%s~s~ to ~y~%s~s~',
  ['received_item'] = 'you have recieved ~y~%sx~s~ ~b~%s~s~ from ~b~%s~s~',
  ['gave_weapon'] = 'you have given weapon: ~b~%s~s~ to ~y~%s~s~',
  ['gave_weapon_ammo'] = 'you have given ~o~%sx %s~s~ for ~b~%s~s~ to ~y~%s~s~',
  ['gave_weapon_withammo'] = 'you have given ~b~%s~s~ with ~o~%sx %s~s~ to ~y~%s~s~',
  ['gave_weapon_hasalready'] = '~y~%s~s~ already has ~y~%s~s~',
  ['gave_weapon_noweapon'] = '~y~%s~s~ does not have that weapon',
  ['received_weapon'] = 'you have recieved ~b~%s~s~ from ~b~%s~s~',
  ['received_weapon_ammo'] = 'you have recieved ~o~%sx %s~s~ for your ~b~%s~s~ from ~b~%s~s~',
  ['received_weapon_withammo'] = 'you have recieved ~b~%s~s~ with ~o~%sx %s~s~ from ~b~%s~s~',
  ['received_weapon_hasalready'] = '~b~%s~s~ has tried to give ~y~%s~s~, but you already have one',
  ['received_weapon_noweapon'] = '~b~%s~s~ has tried to give ammunition for ~y~%s~s~, but you dont have one',
  ['gave_account_money'] = 'you have given ~g~$%s~s~ (%s) to ~y~%s~s~',
  ['received_account_money'] = 'you have recieved ~g~$%s~s~ (%s) from ~b~%s~s~',
  ['amount_invalid'] = 'amount invalid',
  ['players_nearby'] = 'there are no players nearby',
  ['ex_inv_lim'] = 'Impossible action, ~y~%s~s~ has a full inventory.',
  ['imp_invalid_quantity'] = 'Impossible action, invalid quantity.',
  ['imp_invalid_amount'] = 'Impossible action, invalid amount.',
  ['threw_standard'] = 'You have thrown ~y~%sx~s~ ~b~%s~s~',
  ['threw_account'] = 'You have thrown ~g~$%s~s~ ~b~%s~s~',
  ['threw_weapon'] = 'You have thrown ~y~1x~s~ ~b~%s~s~',
  ['threw_weapon_ammo'] = 'You have thrown ~y~1x~s~ ~b~%s~s~ with ~o~%sx~s~ bullets',
  ['threw_weapon_already'] = 'You are already carrying this weapon',
  ['threw_cannot_pickup'] = 'You were unable to carry this item because your inventory is full!',
  ['threw_pickup_prompt'] = 'press ~y~E~s~ to pickup',

  -- Key mapping
  ['keymap_showinventory'] = 'Show inventory',

  -- Salary related
  ['received_salary'] = 'Final salary: ~g~$%s~s~ \nTAX: ~g~$%s\n~s~Bonus: ~g~$%s',
  ['received_help'] = 'You have received your wellfare check: ~g~$%s~s~',
  ['company_nomoney'] = 'The company you work for is too poor to pay you',
  ['received_paycheck'] = 'Check received',
  ['bank'] = 'maze Bank',
  ['account_bank'] = 'Bank',
  ['account_black_money'] = 'Dirty money',
  ['account_money'] = 'Money',

  ['act_imp'] = 'Impossible Action',
  ['in_vehicle'] = 'you cannot give someone anything while in a vehicle',

  -- Commands
  ['command_car'] = 'Spawning a Vehicle',
  ['command_car_car'] = 'vehicle spawn name or hash',
  ['command_cardel'] = 'Delete the nearest vehicle',
  ['command_cardel_radius'] = 'optional, remove all vehicles within the specified radius',
  ['command_clear'] = 'Clear chat',
  ['command_clearall'] = 'Clear chat for all players',
  ['command_clearinventory'] = 'Empty all players inventory',
  ['command_clearloadout'] = 'clear a players loadout',
  ['command_giveaccountmoney'] = 'Give money to the account',
  ['command_giveaccountmoney_account'] = 'Account name valid',
  ['command_giveaccountmoney_amount'] = 'Amount to add',
  ['command_giveaccountmoney_invalid'] = 'Invalid account name',
  ['command_giveitem'] = 'Give an item to a player',
  ['command_giveitem_item'] = 'Object name',
  ['command_giveitem_count'] = 'Number of objects',
  ['command_giveweapon'] = 'Give a player a weapon',
  ['command_giveweapon_weapon'] = 'Name of the weapon',
  ['command_giveweapon_ammo'] = 'Ammo reload',
  ['command_giveweapon_hasalready'] = 'This player already has this weapon',
  ['command_giveweaponcomponent'] = 'Give the weapon component',
  ['command_giveweaponcomponent_component'] = 'Component name',
  ['command_giveweaponcomponent_invalid'] = 'Invalid component',
  ['command_giveweaponcomponent_hasalready'] = 'The player already has this component',
  ['command_giveweaponcomponent_missingweapon'] = 'The player already has this weapon',
  ['command_save'] = 'Save the player to the database',
  ['command_saveall'] = 'Add all players to the database',
  ['command_setaccountmoney'] = 'Enter the amount of money',
  ['command_setaccountmoney_amount'] = 'Amount of money to give',
  ['command_setcoords'] = 'Teleport to coordinates',
  ['command_setcoords_x'] = 'x axis',
  ['command_setcoords_y'] = 'y axis',
  ['command_setcoords_z'] = 'z axis',
  ['command_setjob'] = 'Give the player a job',
  ['command_setjob_job'] = 'Name of the job',
  ['command_setjob_grade'] = 'Job rank',
  ['command_setjob_invalid'] = 'job, degree, or both are invalid',
  ['command_setgroup'] = 'Enter the players group',
  ['command_setgroup_group'] = 'Group name',
  ['commanderror_argumentmismatch'] = 'argument count discrepancy (Passed %s, are required %s)',
  ['commanderror_argumentmismatch_number'] = 'Argument #%s type mismatch (passed string, desired number)',
  ['commanderror_invaliditem'] = 'Invalid object name',
  ['commanderror_invalidweapon'] = 'Invalid weapon',
  ['commanderror_console'] = 'This command cannot be executed in the console',
  ['commanderror_invalidcommand'] = '^3%s^0 is not a valid command!',
  ['commanderror_invalidplayerid'] = 'There is no online player matching the given id',
  ['commandgeneric_playerid'] = 'Player ID',

  -- Locale settings
  ['locale_digit_grouping_symbol'] = ',',
  ['locale_currency'] = '$%s',

  -- Weapons
  ['weapon_knife'] = 'Knife',
  ['weapon_nightstick'] = 'Nightstick',
  ['weapon_hammer'] = 'Hammer',
  ['weapon_bat'] = 'Bat',
  ['weapon_golfclub'] = 'Golf club',
  ['weapon_crowbar'] = 'Crowbar',
  ['weapon_pistol'] = 'Pistol',
  ['weapon_combatpistol'] = 'Combat Pistol',
  ['weapon_appistol'] = 'AP Gun',
  ['weapon_pistol50'] = 'Pistol .50',
  ['weapon_microsmg'] = 'Micro Smg',
  ['weapon_smg'] = 'SMG',
  ['weapon_assaultsmg'] = 'Assault SMG',
  ['weapon_assaultrifle'] = 'Assault Rifle',
  ['weapon_carbinerifle'] = 'Carbine Rifle',
  ['weapon_advancedrifle'] = 'Advanced Rifle',
  ['weapon_mg'] = 'Machine Gun',
  ['weapon_combatmg'] = 'Combat Machine Gun',
  ['weapon_pumpshotgun'] = 'Pump Shotgun',
  ['weapon_sawnoffshotgun'] = 'Sawn-off Shotgun',
  ['weapon_assaultshotgun'] = 'Assault Shotgun',
  ['weapon_bullpupshotgun'] = 'Bullpup Shotgun',
  ['weapon_stungun'] = 'Taser',
  ['weapon_sniperrifle'] = 'Sniper Rifle',
  ['weapon_heavysniper'] = 'Heavy Sniper Rifle',
  ['weapon_grenadelauncher'] = 'Grenade Launcher',
  ['weapon_rpg'] = 'Missile Launcher',
  ['weapon_minigun'] = 'Minigun',
  ['weapon_grenade'] = 'Grenade',
  ['weapon_stickybomb'] = 'C4',
  ['weapon_smokegrenade'] = 'Smoke Grenade',
  ['weapon_bzgas'] = 'Tear Gas',
  ['weapon_molotov'] = 'Molotov',
  ['weapon_fireextinguisher'] = 'Fire Extinguisher',
  ['weapon_petrolcan'] = 'Petrol Can',
  ['weapon_ball'] = 'Ball',
  ['weapon_snspistol'] = 'Small Gun',
  ['weapon_bottle'] = 'Bottle',
  ['weapon_gusenberg'] = 'Thompson Machine Gun',
  ['weapon_specialcarbine'] = 'Special Carbine',
  ['weapon_heavypistol'] = 'Heavy Pistol',
  ['weapon_bullpuprifle'] = 'Semi-auto Rifle',
  ['weapon_dagger'] = 'Dagger',
  ['weapon_vintagepistol'] = 'Vintage Pistol',
  ['weapon_firework'] = 'Firework Launcher',
  ['weapon_musket'] = 'Musket',
  ['weapon_heavyshotgun'] = 'Heavy Shotgun',
  ['weapon_marksmanrifle'] = 'Marksman Rifle',
  ['weapon_hominglauncher'] = 'Homing Missile Launcher',
  ['weapon_proxmine'] = 'Proximity Mine',
  ['weapon_snowball'] = 'Snowball',
  ['weapon_flaregun'] = 'Flaregun',
  ['weapon_combatpdw'] = 'Combat PDW',
  ['weapon_marksmanpistol'] = 'Marksman Pistol',
  ['weapon_knuckle'] = 'Iron Fists',
  ['weapon_hatchet'] = 'Hatchet',
  ['weapon_railgun'] = 'Railgun',
  ['weapon_machete'] = 'Machete',
  ['weapon_machinepistol'] = 'Machine Pistol',
  ['weapon_switchblade'] = 'Switchblade',
  ['weapon_revolver'] = 'Revolver',
  ['weapon_dbshotgun'] = 'Double Barrel Shotgun',
  ['weapon_compactrifle'] = 'Compact Rifle',
  ['weapon_autoshotgun'] = 'Auto Shotgun',
  ['weapon_battleaxe'] = 'Battleaxe',
  ['weapon_compactlauncher'] = 'Compact Launcher',
  ['weapon_minismg'] = 'Mini SMG',
  ['weapon_pipebomb'] = 'Pipebomb',
  ['weapon_poolcue'] = 'Pool Cue',
  ['weapon_wrench'] = 'Wrench',
  ['weapon_flashlight'] = 'Flashlight',
  ['gadget_parachute'] = 'Parachute',
  ['weapon_flare'] = 'Flare',
  ['weapon_doubleaction'] = 'Double-action Revolver',

  -- Weapon Components
  ['component_clip_default'] = 'Factory Charger',
  ['component_clip_extended'] = 'Extender Charger',
  ['component_clip_drum'] = 'Drum Loader',
  ['component_clip_box'] = 'Box Loader',
  ['component_flashlight'] = 'Flashlight',
  ['component_scope'] = 'Scope',
  ['component_scope_advanced'] = 'Advanced Scope',
  ['component_suppressor'] = 'Silencer',
  ['component_grip'] = 'Grip',
  ['component_luxary_finish'] = 'Luxury Finish',


  -- Weapon Ammo
  ['ammo_rounds'] = 'Round(s)',
  ['ammo_shells'] = 'Shell(s)',
  ['ammo_charge'] = 'Charge',
  ['ammo_petrol'] = 'Gallons of gasoline',
  ['ammo_firework'] = 'Firework(s)',
  ['ammo_rockets'] = 'Rocket(s)',
  ['ammo_grenadelauncher'] = 'Grenade(s)',
  ['ammo_grenade'] = 'Grenade(s)',
  ['ammo_stickybomb'] = 'Bomb(s)',
  ['ammo_pipebomb'] = 'Bomb(s)',
  ['ammo_smokebomb'] = 'Bomb(s)',
  ['ammo_molotov'] = 'Molotov Cocktail(s)',
  ['ammo_proxmine'] = 'Mine(s)',
  ['ammo_bzgas'] = 'Gas(s)',
  ['ammo_ball'] = 'Ball(s)',
  ['ammo_snowball'] = 'Snowball',
  ['ammo_flare'] = 'Flare(s)',
  ['ammo_flaregun'] = 'Flare(s)',

  -- Weapon Tints
  ['tint_default'] = 'Common camouflage',
  ['tint_green'] = 'Green Camouflage',
  ['tint_gold'] = 'Gold Camouflage',
  ['tint_pink'] = 'Pink Camouflage',
  ['tint_army'] = 'Navel Camouflage',
  ['tint_lspd'] = 'Police Camouflage',
  ['tint_orange'] = 'Orange Camouflage',
  ['tint_platinum'] = 'Platinum Camouflage',
}
