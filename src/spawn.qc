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
	   else if (e.classname == "weapon_rocketlauncher")	weapon_rocketlauncher ();
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

};