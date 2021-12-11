//
// ELOHIM_MOD
//
// The original monsters.qc is gone.. this file provides spawn functions
// for the monsters so that quake doesn't complain.
//
void() monster_fish =
{
		remove(self);
		return;
};
void() monster_army =
{
		remove(self);
		return;
};
void() monster_dog =
{
		remove(self);
		return;
};
void() monster_boss =
{
		remove(self);
		return;
};
void() monster_demon1 =
{
		remove(self);
		return;
};
void() monster_enforcer =
{
		remove(self);
		return;
};
void() monster_hell_knight =
{
		remove(self);
		return;
};
void() monster_knight =
{
		remove(self);
		return;
};
void() monster_ogre =
{
		remove(self);
		return;
};
void() monster_oldone =
{
		remove(self);
		return;
};
void() monster_shalrath =
{
		remove(self);
		return;
};
void() monster_shambler =
{
		remove(self);
		return;
};
void() monster_tarbaby =
{
		remove(self);
		return;
};
void() monster_wizard =
{
		remove(self);
		return;
};
void() monster_zombie =
{
		remove(self);
		return;
};
void() movetarget_f =
{
	if (!self.targetname)
		objerror ("monster_movetarget: no targetname");
		
	self.solid = SOLID_TRIGGER;
	setsize (self, '-8 -8 -8', '8 8 8');
	
};

// This was in Ai.qc

/*QUAKED path_corner (0.5 0.3 0) (-8 -8 -8) (8 8 8)
Monsters will continue walking towards the next target corner.
*/
void() path_corner =
{
	movetarget_f ();
};

// END_MOD
