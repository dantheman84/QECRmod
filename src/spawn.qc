void (string ec, float ea, vector eo, float es)
spawn_item =
{
	local entity e, o;

	e		= spawn ();
	e.classname	= ec;
	e.origin	= eo;
	e.angles_y	= ea;
	e.spawnflags	= es;

	o = self;
	self = e;
	   if (e.classname == "item_artifact_super_damage")   item_artifact_super_damage ();
	   else if (e.classname == "item_armor1")			item_armor1 ();
	else if (e.classname == "item_armor2")			item_armor2 ();
	else if (e.classname == "item_armorInv")		item_armorInv ();
	else if (e.classname == "item_cells")			item_cells ();
	else if (e.classname == "item_health")			item_health ();
	else if (e.classname == "item_rockets")			item_rockets ();
	else if (e.classname == "item_shells")			item_shells ();
	else if (e.classname == "item_spikes")			item_spikes ();
	else if (e.classname == "weapon_grenadelauncher")	weapon_grenadelauncher ();
	else if (e.classname == "weapon_lightning")		weapon_lightning ();
	else if (e.classname == "weapon_nailgun")		weapon_nailgun ();
	else if (e.classname == "weapon_rocketlauncher")	weapon_rocketlauncher ();
	else if (e.classname == "weapon_supernailgun")		weapon_supernailgun ();
	else if (e.classname == "weapon_supershotgun")		weapon_supershotgun ();
	else if (e.classname == "item_artifact_invulnerability")item_artifact_invulnerability ();
	self = o;
};

void ()
place_my_items =
{


	if (mapname == "aerowalk")
	{
		//by GL
		spawn_item ("item_artifact_super_damage", 0, '-895 -878 248', 0);
	}
	else if (mapname == "dm1")
	{	
		// Room where entrance requires trigger activation.
		spawn_item ("weapon_rocketlauncher", 0, '423 1532 -120', 0);
	}	
	else if (mapname == "dm6")
	{	
		//On top of teleport in middle room
		spawn_item ("item_artifact_super_damage", 0, '1042 -1096 96', 0);
	}		
	else if (mapname == "dm7")
	{
		//suggestion by Levon: Middle arena to force confrontations in tdm
		spawn_item ("item_artifact_super_damage", 0, '1197 672 472', 0);
	}	
	else if (mapname == "aggressr")
	{
		//lower tunnel near lower RL
		spawn_item ("item_artifact_super_damage", 0, '-581 323 -40', 0);
	}
	//dantheman - experimental with horde4 the hunt, these maps require spawn files to be placed in saved games\night dive studios\quake\mg1\spawns
	//they are created in game by typing sv_cheats 1 and then spawn_edit 1. After you placed your spawns then type spawn_save and look at console where it saves it to	
	else if (mapname == "horde4")
	{
		spawn_item ("item_artifact_super_damage", 0, '2 153 142', 0);
		spawn_item ("weapon_rocketlauncher", 0, '-573 1031 238', 0);
		spawn_item ("item_spikes", 0, '-78 -218 -82', 0);
		spawn_item ("item_spikes", 0, '548 493 -18', 0);
		spawn_item ("item_rockets", 0, '-592 -156 -2', 0);
		spawn_item ("item_rockets", 0, '-566 -255 -2', 0);
		spawn_item ("item_rockets", 0, '-1227 626 46', 0);
		spawn_item ("item_cells", 0, '1202 319 -114', 0);
		spawn_item ("item_shells", 0, '1220 -250 -114', 0);
		spawn_item ("item_cells", 0, '1187 187 -114', 0);
		spawn_item ("item_armor1", 0, '-866 -1023 -144', 0);
		spawn_item ("item_health", 0, '-597 577 46', 0);
		spawn_item ("item_health", 0, '-962 -1020 -114', 0);
		spawn_item ("item_health", 0, '-1043 -1034 -114', 0);

	}
	else if (mapname == "horde1")
	{
		spawn_item ("item_artifact_super_damage", 0, '-736 -0 8', 0);
		spawn_item ("item_spikes", 0, '-6 -263 24', 0);
		spawn_item ("item_spikes", 0, '121 -266 24', 0);
		spawn_item ("item_rockets", 0, '-48 -5 24', 0);
		spawn_item ("item_rockets", 0, '759 -105 -55', 0);
		spawn_item ("item_cells", 0, '-62 344 40', 0);
		spawn_item ("item_shells", 0, '-812 -350 -55', 0);
		spawn_item ("item_armor1", 0, '704 -5 -39', 0);
		spawn_item ("item_health", 0, '482 -282 -39', 0);

	}
	else if (mapname == "horde2")
	{
		spawn_item ("item_artifact_super_damage", 0, '10 14 217', 0);
	}	

};