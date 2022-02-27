//
// Admin.qc
//
// Administrative functions for the Elohim server mod.
//
// Fields used:
//
// .count           - used for entering password
//
// All code by J.P. Grossman unless otherwise commented.
//

// function declarations
void () admin_cancel_kick;
void () admin_confirm_kick;
void () admin_do_kick;
void () options_start_setting;
float () options_get_mode;

// global variables
string request_mapname;     // Used for requesting a new level
float request_timelimit;    // Used for requesting a new time limit
float request_gibs;         // Used to set gib level
float request_mode;         // Used to request a new mode
float request_deathmatch;   // Used to request new deathmatch mode
entity kick_target;         // Player to kick

//
//  S E N D  A L I A S E S 1
//
//  Stuffs aliases for votable commands and numbers.
//
void () admin_send_aliases1 =
{
	local entity temp;

	temp = self;
	self = self.owner;

	// episode warp aliases since QE won't let us do two impulses at once
	stuffcmd(self, "alias warp0 impulse 190\n");
	stuffcmd(self, "alias warp1 impulse 191\n");
	stuffcmd(self, "alias warp2 impulse 192\n");
	stuffcmd(self, "alias warp3 impulse 193\n");
	stuffcmd(self, "alias warp4 impulse 194\n");
	stuffcmd(self, "alias warp5 impulse 195\n");
	stuffcmd(self, "alias warp6 impulse 196\n");
	
	//
	// maps
	//
	// e.g.:   alias start impulse 150
	//
	local float levelnum, episode;
	local string szTemp;
	levelnum = 100;
	while (levelnum < 170)
	{
		szTemp = strings_get_mapname(levelnum - 100);
		if (szTemp != "")
		{
			episode = floor(levelnum / 10) - 10;

			stuffcmd(self, "alias ");
			stuffcmd(self, szTemp);
			szTemp = ftos(levelnum - 100 - episode * 10);
			stuffcmd(self, " ");
			stuffcmd(self, szTemp);
			stuffcmd(self, "\n");
		}
		levelnum = levelnum + 1;
	}

	// toggle extended obits
	stuffcmd(self, "alias obits impulse 211\n");

	// timelimit aliases
	stuffcmd(self, "alias timelimit5 impulse 215\n");
	stuffcmd(self, "alias timelimit10 impulse 216\n");
	stuffcmd(self, "alias timelimit15 impulse 217\n");
	stuffcmd(self, "alias timelimit20 impulse 218\n");
	stuffcmd(self, "alias timelimit25 impulse 219\n");
	stuffcmd(self, "alias timelimit30 impulse 220\n");

	// Quad, Pent, Ring aliases
	stuffcmd(self, "alias setquad impulse 221\n");
	stuffcmd(self, "alias setpent impulse 222\n");
	stuffcmd(self, "alias setring impulse 223\n");

	// toggle quad drop behavior
	stuffcmd(self, "alias quaddrop impulse 201\n");

	// gib aliases
	stuffcmd(self, "alias nogibs impulse 225\n");
	stuffcmd(self, "alias lowgibs impulse 226\n");
	stuffcmd(self, "alias highgibs impulse 227\n");

	// alias for Kilomile's GGMod weapon adjustments
	stuffcmd(self, "alias ggmod impulse 207\n");

	// playmode aliases
	stuffcmd(self, "alias normal impulse 208\n");
	stuffcmd(self, "alias practice impulse 209\n");
	stuffcmd(self, "alias match impulse 210\n");

	// number aliases
	stuffcmd(self, "alias 0 impulse 230\n");
	stuffcmd(self, "alias 1 impulse 231\n");
	stuffcmd(self, "alias 2 impulse 232\n");
	stuffcmd(self, "alias 3 impulse 233\n");
	stuffcmd(self, "alias 4 impulse 234\n");
	stuffcmd(self, "alias 5 impulse 235\n");
	stuffcmd(self, "alias 6 impulse 236\n");
	stuffcmd(self, "alias 7 impulse 237\n");
	stuffcmd(self, "alias 8 impulse 238\n");
	stuffcmd(self, "alias 9 impulse 239\n");
	stuffcmd(self, "alias 10 impulse 240\n");
	stuffcmd(self, "alias 11 impulse 241\n");
	stuffcmd(self, "alias 12 impulse 242\n");
	stuffcmd(self, "alias 13 impulse 243\n");
	stuffcmd(self, "alias 14 impulse 244\n");
	stuffcmd(self, "alias 15 impulse 245\n");

	self = temp;
	remove(self);
};

//
//  S E N D  A L I A S E S 2
//
//  Stuffs admin-only aliases into the administrators console.  Called
//  when a player becomes an administrator.
//
void () admin_send_aliases2 =
{
	// Qsmack commands
	stuffcmd(self, "alias qsmack impulse 37\n");

	// set deathmatch mode 1 (weapon spawn)
	stuffcmd(self, "alias setdm1 impulse 205\n");

	// set deathmatch mode 3 (weapon stay)
	stuffcmd(self, "alias setdm3 impulse 206\n");

	// kick a player
	stuffcmd(self, "alias kick! impulse 213\n");
	stuffcmd(self, "alias skick impulse 213\n");

	// stop match
	stuffcmd(self, "alias abortmatch impulse 214\n");

	// list ghosts
	stuffcmd(self, "alias ghostlist impulse 212\n");

	// help
	stuffcmd(self, "alias help-admin impulse 200\n");

	// enable/disable practice mode spooging
	stuffcmd(self, "alias setcharge impulse 224\n");

	// enable/disable mode voting
	stuffcmd(self, "alias modevote impulse 228\n");

	// set options
	stuffcmd(self, "alias options impulse 229\n");

	// spawn point editing
	stuffcmd(self, "alias nextspawn impulse 246\n");
	stuffcmd(self, "alias makespawn impulse 247\n");
	stuffcmd(self, "alias nextcam impulse 248\n");
	stuffcmd(self, "alias makecam impulse 249\n");
	stuffcmd(self, "alias spot impulse 250\n");
};

//
//  C R E A T E
//
//  Turn 'self' into an administrator.
//
void () admin_create =
{
	self.style = self.style | ELOHIM_ADMINISTRATOR;
	self.use = SUB_Null;
	centerprint(self, "You are now an administrator");
	bprint2(self.netname, " has become an administrator\n");
	cprint3("\"", self.netname, " has become an administrator\"\n");
	admin_send_aliases2();
};

//
//  E N T E R  C O D E
//
//  Enter another code digit.
//  The digit being entered is stored in self.finaldest_z.
//  The digits that are entered are accumulated by self.count;
//  when self.count == elohim_password the client is made into an
//  administrator.
//
void () admin_enter_code =
{
	if (self.finaldest_z > 9)
	return;

	self.count = self.count * 10 + self.finaldest_z;
	if (self.count >= 10000000)
	{
		sprint(self, "Invalid code\n");
		self.use = SUB_Null;
		return;
	}
	if (self.count == elohim_password)
		admin_create();
	else
		sprint(self, "Enter the next code digit:\n");
};

//
//  S T A R T  C O D E
//
//  Initiate the admin code sequence.
//
void () admin_start_code =
{
	if (elohim_password < 1000)
	{
		sprint(self, "Administrator password disabled\n");
		sprint(self, "Type 'exec crmod.cfg' in server\n");
		sprint(self, "console to set password.\n");
		return;
	}

	if (self.style & ELOHIM_ADMINISTRATOR)
	{
		sprint(self, "You are already an administrator\n");
		return;
	}
	sprint(self, "Enter the first code digit:\n");
	self.count = 0;
	self.use = admin_enter_code;
};

//
//  C H A N G E  L E V E L
//
//  Called when a request to change level passses.  The level name is
//  stored in request_mapname.
//
void () admin_change_level =
{
	if (request_mapname == "start0")
	{
		serverflags = 0;
		changelevel("start");
	}
	else if (request_mapname == "start1")
	{
		serverflags = 15;
		changelevel("start");
	}
	else
		changelevel (request_mapname);
};

//
//  R E Q U E S T  C H A N G E  L E V E L
//
//  Called when a player requests a new level.
//
void () admin_request_change_level =
{
	local float level;
	local string newmap;

	self.use = SUB_Null;
	if (elohim_state & ELOHIM_MATCH_STARTED)
	{
		sprint(self, "Cannot change level while match is\nin progress.");
		return;
	}

	level = self.count * 10 + self.finaldest_z;
	newmap = strings_get_mapname(level);

	// Do it right away if we're an administrator, otherwise vote
	if (self.style & ELOHIM_ADMINISTRATOR)
	{
		request_mapname = newmap;
		admin_change_level();
	}
	else if (vote_init("change level to ", newmap, admin_change_level))
	{
		request_mapname = newmap;
		vote_yes();
	}
};

//
//  I N I T  W A R P
//
//  Called to initiate the warp.  The episode is passed as a parameter.
//  The level will be entered next; admin_request_change_level will be
//  called when it is.
//
void (float episode) admin_init_warp =
{
	self.count = episode;
	self.use = admin_request_change_level;
};

//
//  P H A T T E N  P L A Y E R
//
//  Phatten up players when entering practice mode.
//
void () admin_phatten_player =
{
	self.items = IT_SHOTGUN | IT_AXE | IT_ROCKET_LAUNCHER | IT_ARMOR3 |
		IT_SUPER_SHOTGUN | IT_NAILGUN | IT_GRENADE_LAUNCHER |
		IT_LIGHTNING | IT_SUPER_NAILGUN;
	self.health = 100;
	self.armorvalue = 200;
	self.ammo_shells = 100;
	self.ammo_nails = 200;
	self.ammo_rockets = 100;
	self.ammo_cells = 100;
	self.weapon = 32;
	self.armortype = 0.8;
	self.weaponmodel = "progs/v_rock2.mdl";
	self.weaponframe = 0;
};

//
//  S E T  M O D E
//
//  Called when a request to set the mode passes.
//
void () admin_set_mode =
{
	if (elohim_playmode & ELOHIM_MATCH_MODE)
	{
		if (elohim_state & ELOHIM_TIMER_STARTED)
		{
			sprint(self, "Timer has started; cannot change mode\n");
			return;
		}
		elohim_playmode = elohim_playmode - ELOHIM_MATCH_MODE;

		// Reset teamplay to 0
		cvar_set("teamplay", "0");

		// Get rid of observers
		utils_do_players(observer_end);
	}

	// Set the default timelimit if it was not set by options
	if (!(self.style & ELOHIM_SETTING_OPTIONS) ||
		(self.pos1_x != cvar("timelimit")))
	{
		if (request_mode == ADMIN_NORMAL_MODE)
			cvar_set("timelimit", "30");
		else if (request_mode == ADMIN_PRACTICE_MODE)
			cvar_set("timelimit", "0");
	}

	elohim_playmode = elohim_playmode - (elohim_playmode & ELOHIM_PRACTICE_MODE);

	if (request_mode == ADMIN_PRACTICE_MODE)
	{
		elohim_playmode = elohim_playmode | ELOHIM_PRACTICE_MODE;
		utils_do_players(admin_phatten_player);
	}
	else if (request_mode == ADMIN_MATCH_MODE)
	{
		elohim_playmode = elohim_playmode | ELOHIM_MATCH_MODE;
		utils_set_cvar("timelimit", elohim_timelimit);
	}

	local string mode;
	mode = strings_get_mode(request_mode);
	bprint3("playmode set to '", mode, "'\n");
	cprint3("\"playmode set to '", mode, "'\"\n");
	utils_set_cvar("samelevel", elohim_playmode);
	changelevel(mapname);
};

//
//  R E Q U E S T  S E T  M O D E
//
//  Request to change to the mode indicated by 'newmode':
//
//      0   -   normal
//      1   -   practice
//      2   -   match
//
void (float newmode) admin_request_set_mode =
{
	local string mode;

	mode = strings_get_mode(newmode);
	if (newmode == options_get_mode())
	{
		if (self == world)
			cprint3("Already in ", mode, " mode\n");
		else
			sprint3(self, "Already in ", mode, " mode\n");
		return;
	}

	if ((elohim_playmode & ELOHIM_MATCH_MODE) &&
		(elohim_state & ELOHIM_TIMER_STARTED))
	{
		if (self == world)
			cprint("Cannot change mode while match is in progress\n");
		else
			sprint(self, "Timer has started; cannot change mode\n");
		return;
	}

	// Do it right away if we're an administrator, otherwise vote
	if (self.style & ELOHIM_ADMINISTRATOR)
	{
		request_mode = newmode;
		admin_set_mode();
	}
	else if (elohim_playmode & ELOHIM_MODE_VOTE)
	{
		if (vote_init("change mode to ", mode, admin_set_mode))
		{
			request_mode = newmode;
			vote_yes();
		}
	}
	else
		sprint(self, "Mode voting has been disabled\n");
};

//
//  S E T  D E A T H M A T C H
//
void () admin_set_deathmatch =
{
	local string temp;

	deathmatch = request_deathmatch;
	temp = ftos(deathmatch);
	localcmd3("deathmatch ", temp, "\n");
	bprint3("deathmatch changed to ", temp, "\n");
	cprint3("deathmatch changed to ", temp, "\n");
};

//
//  R E Q U E S T  S E T  D E A T H M A T C H
//
//  Request to enable/disable deathmatch.
//
void (float val) admin_request_set_deathmatch =
{
	// Do it right away if we're an administrator, otherwise vote
	if (self.style & ELOHIM_ADMINISTRATOR)
	{
		request_deathmatch = val;
		admin_set_deathmatch();
	}
	else
	{
		request_deathmatch = val;
		local string newstate;
		newstate = ftos(val);
		if (vote_init("deathmatch ", newstate, admin_set_deathmatch))
			vote_yes();
	}
};

//
//  S E T  T E A M P L A Y
//
//  Set teamplay to 'value' if playmode is not 'match'.
//
void (float value) admin_set_teamplay =
{
	if (elohim_playmode & ELOHIM_MATCH_MODE)
	{
		sprint(self, "Teamplay cannot be set in match mode.\n");
		return;
	}
	elohim_set_teamplay(value);
};

//
//  S E T  T I M E L I M I T
//
//  Called when a request to change the timelimit passes.  The new
//  timelimit is stored in the global variable request_timelimit.
//
void () admin_set_timelimit =
{
	local string temp;

	elohim_timelimit = request_timelimit;
	temp = ftos(elohim_timelimit);
	bprint3("Match length changed to ", temp, " minutes\n");
	if (elohim_playmode & ELOHIM_MATCH_MODE)
		match_show_timelimit();
};

//
//  R E Q U E S T  S E T  T I M E L I M I T
//
//  Called when a player requests a new timelimit.
//
void (float newlimit) admin_request_set_timelimit =
{
	local string temp;

	if (elohim_state & ELOHIM_MATCH_STARTED)
	{
		sprint(self, "Cannot change time limit while match\nis in progress.");
		return;
	}

	// Do it right away if we're an administrator, otherwise vote
	if (self.style & ELOHIM_ADMINISTRATOR)
	{
		request_timelimit = newlimit;
		admin_set_timelimit();
	}
	else
	{
		temp = strings_ftos(newlimit);
		if (vote_init("change match length to ", temp, admin_set_timelimit))
		{
			request_timelimit = newlimit;
			vote_yes();
		}
	}
};

//
//  R E Q U E S T  S E T  O V E R T I M E
//
//  Currently this is only called from Options.qc
//
void (float overtime) admin_request_set_overtime =
{
	elohim_overtime = overtime;

	if (overtime)
	{
		local string temp;
		local string szplural;
		temp = ftos(overtime);
		szplural = strings_szplural(overtime);
		bprint4("Overtime changed to ", temp, " minute", szplural);
	}
	else
		bprint("Overtime disabled\n");

	utils_set_cvar("v_kicktime", overtime);
};

//
//  S E T  G I B S
//
//  Called when a request to set gibs passes.  The new setting for gibs
//  is specified by the global variable request_gibs.
//
void () admin_set_gibs =
{
	elohim_playmode = elohim_playmode -
	(elohim_playmode & (ELOHIM_NO_GIBS | ELOHIM_LOW_GIBS));
	if (request_gibs == 0)
	{
		elohim_playmode = elohim_playmode | ELOHIM_NO_GIBS;
		bprint("Gibs disabled\n");
		cprint("Gibs disabled\n");
	}
	else if (request_gibs == 1)
	{
		elohim_playmode = elohim_playmode | ELOHIM_LOW_GIBS;
		bprint("Gibs set to 'low'\n");
		cprint("\"Gibs set to 'low'\"\n");
	}
	else
	{
		bprint("Gibs set to 'high'\n");
		cprint("\"Gibs set to 'high'\"\n");
	}
	utils_set_cvar("samelevel", elohim_playmode);
};

//
//  R E Q U E S T  S E T  G I B S
//
//  Called when a player requests a new setting for gibs.
//
void (float gibs) admin_request_set_gibs =
{
	if (elohim_playmode & ELOHIM_NO_GIBS)
	{
		if (gibs == 0)
		{
			if (self == world)
				cprint("Gibs already disabled\n");
			else
				sprint(self, "Gibs already disabled\n");
			return;
		}
	}
	else if (elohim_playmode & ELOHIM_LOW_GIBS)
	{
		if (gibs == 1)
		{
			if (self == world)
				cprint("\"Gibs already set to 'low'\"\n");
			else
				sprint(self, "Gibs already set to 'low'\n");
			return;
		}
	}
	else
	{
		if (gibs == 2)
		{
			if (self == world)
				cprint("\"Gibs already set to 'high'\"\n");
			else
				sprint(self, "Gibs already set to 'high'\n");
			return;
		}
	}

	// Do it right away if we're an administrator, otherwise vote
	if (self.style & ELOHIM_ADMINISTRATOR)
	{
		request_gibs = gibs;
		admin_set_gibs();
	}
	else
	{
		local string gibmode;
		if (gibs == 0)
			gibmode = "'disabled'";
		else if (gibs == 1)
			gibmode = "'low'";
		else
			gibmode = "'high'";
		if (vote_init("change gibs to ", gibmode, admin_set_gibs))
		{
			request_gibs = gibs;
			vote_yes();
		}
	}
};

//
//  D I S A B L E  I T E M
//
//  Used to disable quad/pent/ring.  Called with the item as 'self'.
//
void () admin_disable_item =
{
	self.model = string_null;
	self.solid = SOLID_NOT;
	self.nextthink = -1;
};


//
//  S E T  G G M O D
//
//  Enable/disable ggmod.
//
void () admin_set_ggmod =
{
	if (!(elohim_playmode & ELOHIM_GGMOD))
	{
		bprint("GGMod enabled\n");
		cprint("GGMod enabled\n");
		elohim_playmode = elohim_playmode | ELOHIM_GGMOD;
		// GGmod nails travel at 2750 and QE default is 2000
		if (cvar("sv_maxvelocity") < 2750)
		{
			cvar_set("sv_maxvelocity", ftos(2750));
		}
	}
	else
	{
		bprint("GGMod disabled\n");
		cprint("GGMod disabled\n");
		elohim_playmode = elohim_playmode - ELOHIM_GGMOD;
	}
};

//
//  R E Q U E S T  S E T  G G M O D
//
//  Request to enable/disable ggmod.
//
void () admin_request_set_ggmod =
{
	// Do it right away if we're an administrator, otherwise vote
	if (self.style & ELOHIM_ADMINISTRATOR)
		admin_set_ggmod();
	else
	{
		local string newstate;

		if (!(elohim_playmode & ELOHIM_GGMOD))
			newstate = "enable";
		else
			newstate = "disable";

		if (vote_init(newstate, " ggmod", admin_set_ggmod))
			vote_yes();
	}
};

//
//  S E T  Q U A D  D R O P
//
//  Enable/disable quad drop.
//
void () admin_set_quad_drop =
{
	if (!(elohim_playmode & ELOHIM_QUAD_DROP))
	{
		bprint("Quad Drop enabled\n");
		cprint("Quad Drop enabled\n");
		elohim_playmode = elohim_playmode | ELOHIM_QUAD_DROP;
	}
	else
	{
		bprint("Quad Drop disabled\n");
		cprint("Quad Drop disabled\n");
		elohim_playmode = elohim_playmode - ELOHIM_QUAD_DROP;
	}
};

//
//  R E Q U E S T  S E T  Q U A D  D R O P
//
//  Request to enable/disable quad drop.
//
void () admin_request_set_quad_drop =
{
	// Do it right away if we're an administrator, otherwise vote
	if (self.style & ELOHIM_ADMINISTRATOR)
		admin_set_quad_drop();
	else
	{
		local string newstate;

		if (!(elohim_playmode & ELOHIM_QUAD_DROP))
			newstate = "enable";
		else
			newstate = "disable";

		if (vote_init(newstate, " quad drop", admin_set_quad_drop))
			vote_yes();
	}
};

//
//  S E T  Q U A D
//
//  Enable/disable quad.
//
void () admin_set_quad =
{
	if (elohim_playmode & ELOHIM_NO_QUAD)
	{
		utils_do_item(SUB_regen, "item_artifact_super_damage");
		bprint("Quad enabled\n");
		cprint("Quad enabled\n");
		elohim_playmode = elohim_playmode - ELOHIM_NO_QUAD;
	}
	else
	{
		utils_do_item(admin_disable_item, "item_artifact_super_damage");
		bprint("Quad disabled\n");
		cprint("Quad disabled\n");
		elohim_playmode = elohim_playmode | ELOHIM_NO_QUAD;
	}
	utils_set_cvar("samelevel", elohim_playmode);
};

//
//  R E Q U E S T  S E T  Q U A D
//
//  Request to enable/disable quad.
//
void () admin_request_set_quad =
{
	// Do it right away if we're an administrator, otherwise vote
	if (self.style & ELOHIM_ADMINISTRATOR)
		admin_set_quad();
	else
	{
		local string newstate;

		if (elohim_playmode & ELOHIM_NO_QUAD)
			newstate = "enable";
		else
			newstate = "disable";

		if (vote_init(newstate, " quad", admin_set_quad))
			vote_yes();
	}
};

//
//  S E T  P E N T
//
//  Enable/disable pentagram.
//
void () admin_set_pent =
{
	if (elohim_playmode & ELOHIM_NO_PENT)
	{
		utils_do_item(SUB_regen, "item_artifact_invulnerability");
		bprint("Pentagram enabled\n");
		cprint("Pentagram enabled\n");
		elohim_playmode = elohim_playmode - ELOHIM_NO_PENT;
	}
	else
	{
		utils_do_item(admin_disable_item, "item_artifact_invulnerability");
		bprint("Pentagram disabled\n");
		cprint("Pentagram disabled\n");
		elohim_playmode = elohim_playmode | ELOHIM_NO_PENT;
	}
	utils_set_cvar("samelevel", elohim_playmode);
};

//
//  R E Q U E S T  S E T  P E N T
//
//  Request to enable/disable pentagram.
//
void () admin_request_set_pent =
{
	// Do it right away if we're an administrator, otherwise vote
	if (self.style & ELOHIM_ADMINISTRATOR)
		admin_set_pent();
	else
	{
		local string newstate;

		if (elohim_playmode & ELOHIM_NO_PENT)
			newstate = "enable";
		else
			newstate = "disable";

		if (vote_init(newstate, " pentagram", admin_set_pent))
			vote_yes();
	}
};

//
//  S E T  R I N G
//
//  Enable/disable ring of shadows.
//
void () admin_set_ring =
{
	if (elohim_playmode & ELOHIM_NO_RING)
	{
		utils_do_item(SUB_regen, "item_artifact_invisibility");
		bprint("Ring of shadows enabled\n");
		cprint("Ring of shadows enabled\n");
		elohim_playmode = elohim_playmode - ELOHIM_NO_RING;
	}
	else
	{
		utils_do_item(admin_disable_item, "item_artifact_invisibility");
		bprint("Ring of shadows disabled\n");
		cprint("Ring of shadows disabled\n");
		elohim_playmode = elohim_playmode | ELOHIM_NO_RING;
	}
	utils_set_cvar("samelevel", elohim_playmode);
};

//
//  R E Q U E S T  S E T  R I N G
//
//  Request to enable/disable ring of shadows.
//
void () admin_request_set_ring =
{
	// Do it right away if we're an administrator, otherwise vote
	if (self.style & ELOHIM_ADMINISTRATOR)
		admin_set_ring();
	else
	{
		local string newstate;

		if (elohim_playmode & ELOHIM_NO_RING)
			newstate = "enable";
		else
			newstate = "disable";

		if (vote_init(newstate, " ring of shadows", admin_set_ring))
			vote_yes();
	}
};

//
//  S E T  O B I T S
//
//  Enable/disable extended obituaries.
//
void () admin_set_obits =
{
	if (elohim_playmode & ELOHIM_EXTENDED_OBITS)
	{
		bprint("Extended obituaries disabled\n");
		cprint("Extended obituaries disabled\n");
		elohim_playmode = elohim_playmode - ELOHIM_EXTENDED_OBITS;
	}
	else
	{
		bprint("Extended obituaries enabled\n");
		cprint("Extended obituaries enabled\n");
		elohim_playmode = elohim_playmode | ELOHIM_EXTENDED_OBITS;
	}
	utils_set_cvar("samelevel", elohim_playmode);
};

//
//  R E Q U E S T  S E T  O B I T S
//
//  Request to enable/disable extended obituaries.
//
void () admin_request_set_obits =
{
	// Do it right away if we're an administrator, otherwise vote
	if (self.style & ELOHIM_ADMINISTRATOR)
		admin_set_obits();
	else
	{
		local string newstate;

		if (elohim_playmode & ELOHIM_EXTENDED_OBITS)
			newstate = "disable";
		else
			newstate = "enable";

		if (vote_init(newstate, " extended obituaries", admin_set_obits))
			vote_yes();
	}
};

//
//  S E T  M O D E  V O T E
//
//  Enable/disable mode voting
//
void () admin_set_mode_vote =
{
	if (elohim_playmode & ELOHIM_MODE_VOTE)
	{
		bprint("Mode voting disabled\n");
		cprint("Mode voting disabled\n");
		elohim_playmode = elohim_playmode - ELOHIM_MODE_VOTE;
	}
	else
	{
		bprint("Mode voting enabled\n");
		cprint("Mode voting enabled\n");
		elohim_playmode = elohim_playmode | ELOHIM_MODE_VOTE;
	}
	utils_set_cvar("samelevel", elohim_playmode);
};

//
//  S E T  S P O O G E
//
//  Enable/Disable spooging in practice mode
//
void () admin_set_spooge =
{
	if (elohim_playmode & ELOHIM_NO_SPOOGE)
	{
		elohim_playmode = elohim_playmode - ELOHIM_NO_SPOOGE;
		bprint("Practice mode discharging enabled\n");		// CRMOD - spooge -> discharge
		cprint("Practice mode discharging enabled\n");		// CRMOD - spooge -> discharge
	}
	else
	{
		elohim_playmode = elohim_playmode | ELOHIM_NO_SPOOGE;
		bprint("Practice mode discharging disabled\n");		// CRMOD - spooge -> discharge
		cprint("Practice mode discharging disabled\n");		// CRMOD - spooge -> discharge
	}
};

//
//  P R I N T  K I C K  C H O I C E
//
//  Display a choice of players to kick.
//
void () admin_print_kick_choice =
{
	local entity client;
	local float index;
	local string num;

	// Print the choice
	sprint(self, "Which player do you want to kick?\n");
	sprint(self, " 0  cancel\n");
	index = 1;
	while (index <= 15)
	{
		client = array_get_kick(index);
		if (client)
		{
			num = strings_ftos(index);
			sprint5(self, " ", num, " ", client.netname, "\n");
		}
		index = index + 1;
	}
};

//
//  S T A R T  K I C K
//
//  Get a list of players and ask the admin which one to kick.
//
void () admin_start_kick =
{
	if (elohim_state & ELOHIM_KICKING)
	{
		sprint(self, "There is already a kick in progress\n");
		return;
	}

	// Get the list of players
	local entity client;
	local float index;
	index = 1;
	client = find(world, classname, "player");
	while (client)
	{
		if (!(client.style & ELOHIM_ADMINISTRATOR) &&
			(client.style & ELOHIM_CONNECTED))
		{
			array_set_kick(index, client);
			index = index + 1;
		}
		client = find(client, classname, "player");
	}
	if (index == 1)
	{
		sprint(self, "There is no-one to kick\n");
		return;
	}
	while (index <= 15)
	{
		array_set_kick(index, world);
		index = index + 1;
	}

	// Print the choice
	admin_print_kick_choice();

	// Set up the kick
	local entity kick_timeout;
	self.use = admin_confirm_kick;
	kick_timeout = spawn();
	kick_timeout.movetarget = self;
	kick_timeout.classname = "elohim_kick_timeout";
	kick_timeout.think = admin_cancel_kick;
	kick_timeout.nextthink = time + 10;
	elohim_state = elohim_state | ELOHIM_KICKING;
};

//
//  C O N F I R M  K I C K
//
//  Ask for confirmation to kick the selected player.  The index of
//  the player to be kicked is stored in self.finaldest_z.
//
void () admin_confirm_kick =
{
	if (self.finaldest_z == 0)
	{
		// Cancel the kick
		local entity oself;
		oself = self;
		self = find(world, classname, "elohim_kick_timeout");
		admin_cancel_kick();
		self = oself;
		return;
	}

	kick_target = array_get_kick(self.finaldest_z);

	// sanity checks
	if (!kick_target)
	{
		sprint(self, "Invalid\n");
		admin_print_kick_choice();
		return;
	}
	if (kick_target.style & ELOHIM_ADMINISTRATOR)
	{
		sprint2(self, kick_target.netname, " is an administrator\n");
		admin_print_kick_choice();
		return;
	}

	// ask for confirmation
	sprint3(self, "kick ", kick_target.netname, "?\n");
	self.style = self.style | ELOHIM_KICK_CONFIRM;
};

//
//  C O N F I R M  K I C K  R E S P O N S E
//
//  Called when the administrator enters 'yes' or 'no' in
//  response to the confirmation request.
//
void (float fDoKick) admin_confirm_kick_response =
{
	if (fDoKick)
		admin_do_kick();
	else
	{
		// Cancel the kick
		local entity oself;
		oself = self;
		self = find(world, classname, "elohim_kick_timeout");
		admin_cancel_kick();
		self = oself;
	}
};

//
//  D O  K I C K
//
//  Kick a player once the admin has confirmed.
//
void () admin_do_kick =
{
	// Function had early return in QECRmod... maybe crashed QE?
	// return;
	bprint2(kick_target.netname, " kicked by administrator\n");
	cprint3("\"", kick_target.netname, " kicked by administrator\"\n");
	elohim_kick_player(kick_target);

	// Clean up
	self.use = SUB_Null;
	kick_target = find(world, classname, "elohim_kick_timeout");
	remove(kick_target);
	elohim_state = elohim_state - ELOHIM_KICKING;
	self.style = self.style - ELOHIM_KICK_CONFIRM;
};

//
//  C A N C E L  K I C K
//
//  Called when the kick times out or is cancelled by the admin.
//
void () admin_cancel_kick =
{
	sprint(self.movetarget, "Kick cancelled\n");
	self.movetarget.use = SUB_Null;
	remove(self);
	elohim_state = elohim_state - ELOHIM_KICKING;
	self.movetarget.style = self.movetarget.style -
		(self.movetarget.style & ELOHIM_KICK_CONFIRM);
};

//
//  L I S T  G H O S T S
//
void () admin_list_ghosts =
{
	local entity e;
	e = find(world, classname, "elohim_ghost");
	if (!e)
	{
		sprint(self, "There are no ghosts\n");
		return;
	}
	sprint(self, "\ncode�   team   �frags�     name\n");
	sprint(self, "�������������������������������������\n");
	while (e)
	{
		local string num, szTeam, pad;
		local float frag;
		num = ftos(e.count);
		sprint2(self, num, " �");

		szTeam = strings_get_teamname2(e.height);
		if (e.owner.owner == e)
			frag = e.owner.frags;
		else
			frag = e.frags;
		if (frag < -99)
			pad = "�";
		else if (frag < -9)
			pad = "� ";
		else if (frag < 0)
			pad = "�  ";
		else if (frag < 10)
			pad = "�   ";
		else if (frag < 100)
			pad = "�  ";
		else
			pad = "� ";
		num = ftos(frag);
		if (e.owner.owner == e)
			sprint6(self, szTeam, pad, num, " �", e.owner.netname, "\n");
		else
			sprint4(self, szTeam, pad, num, " � Disconnected\n");

		e = find(e, classname, "elohim_ghost");
	}
	sprint(self, "\n");
};

//
//  S H O W  S P O T  I N F O
//
//  Display the current position and angle.
//
void () admin_show_spot_info =
{
	local string temp;

	temp = vtos(self.origin + '0 0 22');
	sprint3(self, " origin: ", temp, "\n");
	temp = vtos(self.v_angle);
	sprint3(self, " angle: ", temp, "\n");
};

//
//  N E X T  S P A W N  P O I N T
//
//  If the admin is in walk or fly observer mode, move him to the
//  next spawn point.
//
void () admin_next_spawn_point =
{
	if (!(self.style & ELOHIM_OBSERVER) ||
		!(self.oflags & (OBSERVER_WALK | OBSERVER_FLY)))
	{
		sprint(self, "You must be in walk or fly mode\n");
		return;
	}
	utils_do_item(match_add_spawn, "elohim_start_point");
	self.owner = find(self.owner, classname, "info_player_deathmatch");
	if (!self.owner)
	{
		self.owner = find(self.owner, classname, "info_player_deathmatch");
		if (!self.owner)
		{
			sprint(self, "No spawn points found\n");
			return;
		}
	}
	utils_do_item(match_remove_start, "info_player_deathmatch");

	// setorigin will not actually set the origin if a bad origin is given.
	// Therefore, we first set the origin manually to ensure that the spot info
	// is displayed correctly.
	//
	self.origin = self.owner.origin;
	admin_show_spot_info();
	setorigin(self, self.owner.origin + '0 0 1');
	self.angles = self.owner.angles;
	self.fixangle = TRUE;           // turn this way immediately
	self.velocity = '0 0 0';
	makevectors(self.angles);
	observer_spawn_tfog(self.origin + v_forward*20);
};

//
//  M A K E  S P A W N  P O I N T
//
//  If the admin is in walk observer mode, standing on the ground and
//  not underwater, then create a new deathmatch spawn point at his
//  location.
//
void () admin_make_spawn_point =
{
	if (!(self.style & ELOHIM_OBSERVER) || !(self.oflags & OBSERVER_WALK))
	{
		sprint(self, "You must be in walk mode\n");
		return;
	}
	if (!(self.flags & FL_ONGROUND))
	{
		sprint(self, "You must be on the ground\n");
		return;
	}
	if (self.waterlevel)
	{
		sprint(self, "Cannot create underwater spawn point\n");
		return;
	}
	if (elohim_num_spawns >= 20)
	{
		sprint(self, "Max. number of spawn points reached\n");
		return;
	}

	self.owner = spawn();
	self.owner.owner = world;
	self.owner.solid = SOLID_NOT;
	self.owner.movetype = MOVETYPE_NONE;
	self.owner.takedamage = DAMAGE_NO;
	self.owner.fixangle = TRUE;
	self.owner.classname = "info_player_deathmatch";
	self.angles_x = 0;
	self.angles_z = 0;
	self.fixangle = TRUE;
	self.owner.angles = self.angles;
	self.owner.origin = self.origin;
	elohim_num_spawns = elohim_num_spawns + 1;
	sprint(self, "Spawn point created\n");
	admin_show_spot_info();
};

//
//  N E X T  C A M E R A
//
//  If the admin is in fly observer mode, move him to the next camera.
//
void () admin_next_camera=
{
	if (!(self.style & ELOHIM_OBSERVER) || !(self.oflags & OBSERVER_FLY))
	{
		sprint(self, "You must be in fly mode\n");
		return;
	}
	self.owner = find(self.owner, classname, "elohim_camera");
	if (!self.owner)
	{
		self.owner = find(self.owner, classname, "elohim_camera");
		if (!self.owner)
		{
			sprint(self, "No cameras found\n");
			return;
		}
	}

	// setorigin will not actually set the origin if a bad origin is given.
	// Therefore, we first set the origin manually to ensure that the spot info
	// is displayed correctly.
	//
	self.origin = self.owner.origin - '0 0 22';
	self.angles = self.v_angle = self.owner.angles;
	admin_show_spot_info();
	setorigin(self, self.owner.origin);
	self.fixangle = TRUE;           // turn this way immediately
	self.velocity = '0 0 0';
};

//
//  M A K E  C A M E R A
//
//  If the admin is in fly observer mode, create a new camera at his
//  location.
//
void () admin_make_camera =
{
	if (!(self.style & ELOHIM_OBSERVER) || !(self.oflags & OBSERVER_FLY))
	{
		sprint(self, "You must be in fly mode\n");
		return;
	}
	if (elohim_num_cameras >= 20)
	{
		sprint(self, "Max. number of cameras reached\n");
		return;
	}

	self.owner = spawn();
	self.owner.owner = world;
	self.owner.solid = SOLID_NOT;
	self.owner.movetype = MOVETYPE_NONE;
	self.owner.takedamage = DAMAGE_NO;
	self.owner.fixangle = TRUE;
	self.owner.classname = "elohim_camera";
	self.v_angle_z = 0;
	self.angles = self.v_angle;
	self.fixangle = TRUE;
	self.owner.angles = self.v_angle;
	self.owner.origin = self.origin + '0 0 22';
	elohim_num_cameras = elohim_num_cameras + 1;
	sprint(self, "Camera created\n");
	admin_show_spot_info();
};

//
//  H E L P
//
void () admin_help =
{
	sprint(self, "Admin only commands:\n");
	sprint(self, " kick!    - kick a player\n");
	sprint(self, " modevote - enable/disable mode votes\n");
	sprint(self, " options  - on-screen options menu\n");
	sprint(self, " abortmatch - abort current match\n");
	sprint(self, " ghostlist  - view list of ghosts\n");
	sprint(self, " setcharge  - ban practice discharges\n");
	sprint(self, " spot       - show location/angles\n");
	sprint(self, " nextspawn  - go to next spawn point\n");
	sprint(self, " makespawn  - add spawn point\n");
	sprint(self, " nextcam    - go to next camera\n");
	sprint(self, " makecam    - add camera\n");
};

//
//  I M P U L S E
//
//  Called by elohim_impulse in Elohim.qc
//
void () admin_impulse =
{
	// votable commands
	if (self.impulse >= 190 && self.impulse <= 196)
		admin_init_warp(self.impulse - 190);
	else if (self.impulse == 201)
		admin_request_set_quad_drop();
	else if (self.impulse == 205)
		admin_request_set_deathmatch(1);
	else if (self.impulse == 206)
		admin_request_set_deathmatch(3);
	else if (self.impulse == 207)
		admin_request_set_ggmod();
	else if (self.impulse >= 208 && self.impulse <= 210)
		admin_request_set_mode(self.impulse - 208);
	else if (self.impulse == 211)
		admin_request_set_obits();
	else if (self.impulse >= 215 && self.impulse <= 220)
		admin_request_set_timelimit(5 * (self.impulse - 214));
	else if (self.impulse == 221)
		admin_request_set_quad();
	else if (self.impulse == 222)
		admin_request_set_pent();
	else if (self.impulse == 223)
		admin_request_set_ring();
	else if (self.impulse >= 225 && self.impulse <= 227)
		admin_request_set_gibs(self.impulse - 225);
	else if (self.impulse >= 230 && self.impulse <= 245)
	{
		if (self.use)
		{
			self.finaldest_z = self.impulse - 230;
			self.use();
		}
	}

	if (!(self.style & ELOHIM_ADMINISTRATOR))
		return;

	// admin only commands
	if (self.impulse == 200)
		admin_help();
	else if (self.impulse == 212)
		admin_list_ghosts();
	else if (self.impulse == 213)
		admin_start_kick();
	else if (self.impulse == 214)
		match_end();
	else if (self.impulse == 224)
		admin_set_spooge();
	else if (self.impulse == 228)
		admin_set_mode_vote();
	else if (self.impulse == 229)
		options_start_setting();
	else if (self.impulse == 246)
		admin_next_spawn_point();
	else if (self.impulse == 247)
		admin_make_spawn_point();
	else if (self.impulse == 248)
		admin_next_camera();
	else if (self.impulse == 249)
		admin_make_camera();
	else if (self.impulse == 250)
		admin_show_spot_info();
};

//
//  D I S C O N N E C T  N O T I F Y
//
//  Remove this player from the list of kickable players.
//
void (entity player) admin_disconnect_notify =
{
	local float index;

	index = 1;
	while (index < 16)
	{
		if (self == array_get_kick(index))
			array_set_kick(index, world);
		index = index + 1;
	}
};






