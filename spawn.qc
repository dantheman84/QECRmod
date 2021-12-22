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
	self = o;
};

void ()
place_my_items =
{


	if (mapname == "aerowalk")
	{
		spawn_item ("item_artifact_super_damage", 0, '-895 -878 248', 0);
	}

};