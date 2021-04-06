Locales['en'] = {
  -- Inventory
  ['inventory'] = 'inventario %s / %s',
  ['use'] = 'usar',
  ['give'] = 'dar',
  ['remove'] = 'lanzar',
  ['return'] = 'regresar',
  ['give_to'] = 'dar a',
  ['amount'] = 'monto',
  ['giveammo'] = 'dar municion',
  ['amountammo'] = 'municion',
  ['noammo'] = 'no tienes suficiente municion!',
  ['gave_item'] = 'tu tienes ~y~%sx~s~ ~b~%s~s~ to ~y~%s~s~',
  ['received_item'] = 'has recibido ~y~%sx~s~ ~b~%s~s~ from ~b~%s~s~',
  ['gave_weapon'] = 'has dado ~b~%s~s~ to ~y~%s~s~',
  ['gave_weapon_ammo'] = 'has dado ~o~%sx %s~s~ for ~b~%s~s~ to ~y~%s~s~',
  ['gave_weapon_withammo'] = 'has dado ~b~%s~s~ with ~o~%sx %s~s~ to ~y~%s~s~',
  ['gave_weapon_hasalready'] = '~y~%s~s~ ya tiene una ~y~%s~s~',
  ['gave_weapon_noweapon'] = '~y~%s~s~ no tiene esa arma',
  ['received_weapon'] = 'has recibido ~b~%s~s~ from ~b~%s~s~',
  ['received_weapon_ammo'] = 'has recibido ~o~%sx %s~s~ for your ~b~%s~s~ from ~b~%s~s~',
  ['received_weapon_withammo'] = 'has recibido ~b~%s~s~ with ~o~%sx %s~s~ from ~b~%s~s~',
  ['received_weapon_hasalready'] = '~b~%s~s~ has intentado dar ~y~%s~s~, but you already have one',
  ['received_weapon_noweapon'] = '~b~%s~s~ has intentado dar municion a ~y~%s~s~, but you dont have one',
  ['gave_account_money'] = 'has dado ~g~$%s~s~ (%s) to ~y~%s~s~',
  ['received_account_money'] = 'has recibido ~g~$%s~s~ (%s) from ~b~%s~s~',
  ['amount_invalid'] = 'monto invalido',
  ['players_nearby'] = 'no hay jugadores cerca',
  ['ex_inv_lim'] = 'Accion imposible, ~y~%s~s~ tiene el inventario lleno.',
  ['imp_invalid_quantity'] = 'Acción imposible, cantidad inválida',
  ['imp_invalid_amount'] = 'Acción imposible, monto inválido',
  ['threw_standard'] = 'Has tirado ~y~%sx~s~ ~b~%s~s~',
  ['threw_account'] = 'Has tirado ~g~$%s~s~ ~b~%s~s~',
  ['threw_weapon'] = 'Has tirado ~y~1x~s~ ~b~%s~s~',
  ['threw_weapon_ammo'] = 'Has tirado ~y~1x~s~ ~b~%s~s~ con ~o~%sx~s~ balas',
  ['threw_weapon_already'] = 'Actualmente ya llevas esta arma',
  ['threw_cannot_pickup'] = 'No has podido llevar este item porque tu inventario está lleno!',
  ['threw_pickup_prompt'] = 'presiona ~y~E~s~ para recojer',

  -- Key mapping
  ['keymap_showinventory'] = 'Mostrar inventario',

  -- Salary related
  ['received_salary'] = 'Salario Final: ~g~$%s~s~ \nTAX: ~g~$%s\n~s~Bonus: ~g~$%s',
  ['received_help'] = 'Has recibido tu cheque de bienestar: ~g~$%s~s~',
  ['company_nomoney'] = 'La empresa la cual trabajas es demasiado pobre como para pagarte',
  ['received_paycheck'] = 'Cheque recibido',
  ['bank'] = 'maze Bank',
  ['account_bank'] = 'Banco',
  ['account_black_money'] = 'Dinero sucio',
  ['account_money'] = 'Dinero',

  ['act_imp'] = 'Acción Imposible',
  ['in_vehicle'] = 'no puedes darle nada a alguien en un vehículo',

  -- Commands
  ['command_car'] = 'Espawnear un Vehiculo',
  ['command_car_car'] = 'vehicle spawn name or hash',
  ['command_cardel'] = 'Borrar el vehiculo más cercano',
  ['command_cardel_radius'] = 'opcional, elimine todos los vehículos dentro del radio especificado',
  ['command_clear'] = 'Vaciar chat',
  ['command_clearall'] = 'Vaciar chat para todos los jugadores',
  ['command_clearinventory'] = 'Vaciar inventario a todos los jugadores',
  ['command_clearloadout'] = 'clear a player loadout',
  ['command_giveaccountmoney'] = 'Dar dinero a la cuenta',
  ['command_giveaccountmoney_account'] = 'Nombre de cuenta valido',
  ['command_giveaccountmoney_amount'] = 'Monto a agregar',
  ['command_giveaccountmoney_invalid'] = 'Nombre de la cuenta invalido',
  ['command_giveitem'] = 'Dar un item a un jugador',
  ['command_giveitem_item'] = 'Nombre de el objeto',
  ['command_giveitem_count'] = 'Cantidad de objetos',
  ['command_giveweapon'] = 'Dar un arma a un jugador',
  ['command_giveweapon_weapon'] = 'Nombre de el arma',
  ['command_giveweapon_ammo'] = 'Recarga de municion',
  ['command_giveweapon_hasalready'] = 'El jugador ya tiene esta arma',
  ['command_giveweaponcomponent'] = 'Dar el componente de arma',
  ['command_giveweaponcomponent_component'] = 'Nombre de el componente',
  ['command_giveweaponcomponent_invalid'] = 'Componente invalido',
  ['command_giveweaponcomponent_hasalready'] = 'El jugador ya tiene este componente',
  ['command_giveweaponcomponent_missingweapon'] = 'El jugador ya tiene esta arma',
  ['command_save'] = 'Guardar el jugador en la base de datos',
  ['command_saveall'] = 'Añadir todos los jugadores a la base de datos',
  ['command_setaccountmoney'] = 'Ingresar monto de dinero',
  ['command_setaccountmoney_amount'] = 'Monto de dinero a dar',
  ['command_setcoords'] = 'Teletransportar a las coordenadas',
  ['command_setcoords_x'] = 'x axis',
  ['command_setcoords_y'] = 'y axis',
  ['command_setcoords_z'] = 'z axis',
  ['command_setjob'] = 'Dar un trabajo a un jugador',
  ['command_setjob_job'] = 'Nombre del trabajo',
  ['command_setjob_grade'] = 'Grado del trabajo',
  ['command_setjob_invalid'] = 'el trabajo, el grado o ambos no son válidos',
  ['command_setgroup'] = 'Ingresa el grupo del jugador',
  ['command_setgroup_group'] = 'Nombre del grupo',
  ['commanderror_argumentmismatch'] = 'discrepancia en el recuento de argumentos (Pasaron %s, se requieren %s)',
  ['commanderror_argumentmismatch_number'] = 'Argumento #%s falta de coincidencia de tipo (cadena pasada, número deseado)',
  ['commanderror_invaliditem'] = 'Nombre de objeto invalido',
  ['commanderror_invalidweapon'] = 'Arma invalida',
  ['commanderror_console'] = 'Este comando no puede ser ejecutado en la consola',
  ['commanderror_invalidcommand'] = '^3%s^0 no es un comando valido!',
  ['commanderror_invalidplayerid'] = 'No hay ningún jugador en línea que coincida con la id entregada',
  ['commandgeneric_playerid'] = 'ID del jugador',

  -- Locale settings
  ['locale_digit_grouping_symbol'] = ',',
  ['locale_currency'] = '$%s',

  -- Weapons
  ['weapon_knife'] = 'Cuchillo',
  ['weapon_nightstick'] = 'Porra de policía',
  ['weapon_hammer'] = 'Martillo',
  ['weapon_bat'] = 'Bate',
  ['weapon_golfclub'] = 'Hacha de bomberos',
  ['weapon_crowbar'] = 'Palanca',
  ['weapon_pistol'] = 'Pistola',
  ['weapon_combatpistol'] = 'Pistola de Combate',
  ['weapon_appistol'] = 'Pistola AP',
  ['weapon_pistol50'] = 'Pistola .50',
  ['weapon_microsmg'] = 'Micro Uzi',
  ['weapon_smg'] = 'SMG',
  ['weapon_assaultsmg'] = 'SMG de Asalto',
  ['weapon_assaultrifle'] = 'Rifle de Asalto',
  ['weapon_carbinerifle'] = 'Rifle de Carabina',
  ['weapon_advancedrifle'] = 'Rifle Avanzado',
  ['weapon_mg'] = 'Ametralladora',
  ['weapon_combatmg'] = 'Ametralladora de Combate',
  ['weapon_pumpshotgun'] = 'Escopeta',
  ['weapon_sawnoffshotgun'] = 'Escopeta Recortada',
  ['weapon_assaultshotgun'] = 'Escopeta de Asalto',
  ['weapon_bullpupshotgun'] = 'Escopeta Semi-Auto',
  ['weapon_stungun'] = 'Taser',
  ['weapon_sniperrifle'] = 'Rifle Francotirador',
  ['weapon_heavysniper'] = 'Rifle Francotirador Pesado',
  ['weapon_grenadelauncher'] = 'Lanzagranadas',
  ['weapon_rpg'] = 'Lanzamisiles',
  ['weapon_minigun'] = 'Minigun',
  ['weapon_grenade'] = 'Granada',
  ['weapon_stickybomb'] = 'C4',
  ['weapon_smokegrenade'] = 'Granada de Humo',
  ['weapon_bzgas'] = 'Gas Lacrimógeno',
  ['weapon_molotov'] = 'Molotov',
  ['weapon_fireextinguisher'] = 'Extintor',
  ['weapon_petrolcan'] = 'Bidón de Gasolina',
  ['weapon_ball'] = 'Pelota',
  ['weapon_snspistol'] = 'Pistola Pequeña',
  ['weapon_bottle'] = 'Botella Rota',
  ['weapon_gusenberg'] = 'Ametralladora Thompson',
  ['weapon_specialcarbine'] = 'Carabina Especial',
  ['weapon_heavypistol'] = 'Pistola Pesada',
  ['weapon_bullpuprifle'] = 'Rifle Semi-Auto',
  ['weapon_dagger'] = 'Daga',
  ['weapon_vintagepistol'] = 'Pistola Vintage',
  ['weapon_firework'] = 'Lanzador de Fuegos Artificiales',
  ['weapon_musket'] = 'Mosquete',
  ['weapon_heavyshotgun'] = 'Escopeta Pesada',
  ['weapon_marksmanrifle'] = 'Rifle de Tirador',
  ['weapon_hominglauncher'] = 'Lanzamisiles Homing',
  ['weapon_proxmine'] = 'Mina de Proximidad',
  ['weapon_snowball'] = 'Bola de Nieve',
  ['weapon_flaregun'] = 'Pistola de Bengalas',
  ['weapon_combatpdw'] = 'combat pdw',
  ['weapon_marksmanpistol'] = 'Pistola Marksman',
  ['weapon_knuckle'] = 'Puños de hierro',
  ['weapon_hatchet'] = 'Hacha',
  ['weapon_railgun'] = 'Railgun',
  ['weapon_machete'] = 'Machete',
  ['weapon_machinepistol'] = 'Pistola Automatica',
  ['weapon_switchblade'] = 'Navaja compacta',
  ['weapon_revolver'] = 'Revolver Pesado',
  ['weapon_dbshotgun'] = 'Escopeta de doble cañón',
  ['weapon_compactrifle'] = 'Rifle compacto',
  ['weapon_autoshotgun'] = 'Escopeta automatica',
  ['weapon_battleaxe'] = 'Hacha de combate',
  ['weapon_compactlauncher'] = 'Lanzador compacto',
  ['weapon_minismg'] = 'mini smg',
  ['weapon_pipebomb'] = 'Bomba casera',
  ['weapon_poolcue'] = 'Palo de billar',
  ['weapon_wrench'] = 'LLave inglesa',
  ['weapon_flashlight'] = 'Linterna',
  ['gadget_parachute'] = 'Paracaidas',
  ['weapon_flare'] = 'Bengala',
  ['weapon_doubleaction'] = 'Revolver de Doble-Accion',

  -- Weapon Components
  ['component_clip_default'] = 'Cargador de fabrica',
  ['component_clip_extended'] = 'Cargador ampliado',
  ['component_clip_drum'] = 'Cargador de tambor',
  ['component_clip_box'] = 'Cargador de caja',
  ['component_flashlight'] = 'Linterna',
  ['component_scope'] = 'Mira',
  ['component_scope_advanced'] = 'Mira avanzada',
  ['component_suppressor'] = 'Silenciador',
  ['component_grip'] = 'Empuñadura',
  ['component_luxary_finish'] = 'Lujo de Yusuv Amir',


  -- Weapon Ammo
  ['ammo_rounds'] = 'Ronda(s)',
  ['ammo_shells'] = 'Escudo(s)',
  ['ammo_charge'] = 'carga',
  ['ammo_petrol'] = 'Galones de gasolina',
  ['ammo_firework'] = 'Fuego artificiale(s)',
  ['ammo_rockets'] = 'Cohete(s)',
  ['ammo_grenadelauncher'] = 'Granada(s)',
  ['ammo_grenade'] = 'Granada(s)',
  ['ammo_stickybomb'] = 'bomba(s)',
  ['ammo_pipebomb'] = 'bomba(s)',
  ['ammo_smokebomb'] = 'bomba(s)',
  ['ammo_molotov'] = 'Cocteles Molotov(s)',
  ['ammo_proxmine'] = 'mina(s)',
  ['ammo_bzgas'] = 'Gaz(s)',
  ['ammo_ball'] = 'Bola(s)',
  ['ammo_snowball'] = 'Bola de nieve',
  ['ammo_flare'] = 'Bengala(s)',
  ['ammo_flaregun'] = 'Bengalas(s)',

  -- Weapon Tints
  ['tint_default'] = 'Camuflaje común',
  ['tint_green'] = 'Camuflaje verde',
  ['tint_gold'] = 'Camuflaje dorado',
  ['tint_pink'] = 'Camuflaje rosado',
  ['tint_army'] = 'Camuflaje naval',
  ['tint_lspd'] = 'Camuflaje policial',
  ['tint_orange'] = 'Camuflaje naranjo',
  ['tint_platinum'] = 'Camuflaje de platino',
}