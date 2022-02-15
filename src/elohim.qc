//
// Elohim.qc
//
// This is the main file for CRMod++.  CRMod++ was derived from the
// Elohim server, which is why everything is still called "elohim".
//
// Developed by J.P. Grossman (a.k.a. ùMephistopheles) and Paul Baker
//
// All code by J.P. Grossman unless otherwise commented.
//
// Client fields used:
//
// General:
//
// .style           - Elohim player flags
// .count           - used for entering password / ghostcode / warplevel
// .cnt             - number of suicides remaining
// .wait            - time to do periodic checks
// .state           - unique player id
// .finaldest_y     - used for pinging
// .height          - used to store player team
// .finaldest_x     - used to test for disconnected players
// .use             - pointer to function to call when a number is entered
// .finaldest_z     - the number that was entered
// .owner           - players's ghost entity
// .enemy           - stores last spawn point/camera location for admins
//
// Statistics:
//
// .dest1_x         - damage fired from bullets
// .dest2_x         - damage done from bullets
// .dest1_y         - damage fired from nails
// .dest2_y         - damage done from nails
// .dest1_z         - damage fired from lightning gun
// .dest2_z         - damage done from lightning gun
// .dest_x          - damage fired from rockets
// .dest_y          - damage done from rockets
// .mangle_x        - number of times killed self
// .mangle_y        - number of times killed teammate
// .mangle_z        - number of times was killed
// .crmod_qdwep_x   - damage done with quad        // CRMOD
// .crmod_qdwep_y   - damage fired with quad       // CRMOD
// .crmod_qdwep_z   - number times quad pickedup   // CRMOD
// .crmod_qdkill_x  - number of enemies killed     // CRMOD
// .crmod_qdkill_y  - number of teammates killed   // CRMOD
// .crmod_qdkill_z  - number of self kills         // CRMOD
//
// Observer mode:
//
// .trigger_field   - closest teleport when observing, last spawn if playing
// .t_width         - activation radius for closest teleport
// .dest            - stores destination for popping forward through doors
// .dest1           - stores velocity for popping forward through doors
// .delay           - time to refresh head's up display for observing
// .speed           - z component of velocity from previous frame (for fly)
// .movetarget      - player being watched in observer mode (world if none)
// .owner           - last spawn point/camera for admins
// .lip             - time to clear display when no target is in line of sight (walk/fly)
// .attack_finished - used to delay before flying through obstacles
//
// Used for setting options:
//
// .delay     - time to update display (shared with observer.qc)
// .pos1_x    - timelimit
// .pos1_y    - fraglimit
// .pos1_z    - mode
// .pos2_x    - gibs
// .pos2_y    - teamplay
// .pos2_z    - noexit
// .worldtype - sys_ticrate
// .aflag     - pausable/quad/pent/ring/mode vote
// .t_length  - which option is currently selected
//
// Scoreboard:
//
// .scoreboard_x  - slot used for team 1
// .scoreboard_y  - slot used for team 2
// .scoreboard_z  - slot used for time remaining
//
// Console variables used:
//
// samelevel    = elohim_playmode - server flags
// v_kickroll   = elohim_level    - level number in user level sequence
// v_kicktime   = elohim_overtime - length of overtime
// temp1                          - console commands
// v_kickpitch                    - used non-destructively for utils_stof
//

// function declarations
void () elohim_load_entities;
void (float vlaue) elohim_set_teamplay;
void (float vlaue) elohim_set_fraglimit;
void () stats_reset;
void () stats_show_quadstats;
void () stats_show_killstats;
void () stats_show_efficiency;
void () stats_show_summary;
void () stats_autodump;
void () stats_show_teamstats;
void () motd_init_world;
void () motd_create;
void () score_init_world;
void () score_client_connect;
void () score_client_disconnect;
void (float command) console_command;
void () console_set_aliases;
void (entity client) observer_disconnect_notify;
void () admin_send_aliases1;
void () admin_impulse;
void () admin_start_code;
void (float fDoKick) admin_confirm_kick_response;
void (entity player) admin_disconnect_notify;
void () observer_impulse;
void () observer_help;
void () observer_start;
void () observer_find_teleport;
void () observer_check_size;
void (float response) observer_confirm_leave_response;
void () match_show_timelimit;
void () match_impulse;
void (entity player) match_verify_team;
void (entity player) match_disconnect_notify;
void () vote_impulse;
float () options_get_mode;
void () execute_changelevel;
void () NextLevel;
void (vector org, entity death_owner) spawn_tdeath;
void () player_stand1;
void() ClientDisconnect;
void (vector org) spawn_tfog;

//
//  I N I T  W O R L D
//
//  Called from InitWorld in World.qc
//
void () elohim_init_world =
{
		local float mode;
		local string szmode;
		local float temp;

		// DO NOT EDIT THESE LINES
		elohim_version = "Clanring CRMod++ V4.0";
		elohim_version_info = "Clanring CRMod++ V4.0 2:34am 5/21/98";
		crmod_version_number = "4.0";   // CRMOD - string to be used throughout
						//         code to show version number.
		// DO NOT EDIT THESE LINES

		// Initialize user map names, MOTD, and hotspots, etc..
		userdefs_init_world();
		motd_init_world();
	score_init_world();
		hotspots_init_world();      // CRMOD - init hotspots

		// Hack to allow console to emulate an administrator
	world.style = ELOHIM_ADMINISTRATOR;

		// Precache sound used when players connect
		precache_sound("wizard/wsight.wav");

		// Get/set console variables
		elohim_playmode = cvar("samelevel");
		if (elohim_playmode & ELOHIM_MATCH_MODE)
		teamplay = 2;
		else
		teamplay = cvar("teamplay");
		elohim_set_teamplay(-1);
		elohim_set_fraglimit(-1);

		// Check to see if we need to initialize the server
		if (!(elohim_playmode & ELOHIM_SERVER_INITIALIZED))
		{
		// Check to see if this is a dedicated server.
		// Dedicated servers do not have an ambient_fade cvar, so the
		// value returned by cvar() will not change.
		temp = cvar("ambient_fade");
		utils_set_cvar("ambient_fade", temp + 1);
		if (temp == cvar("ambient_fade"))
		{
			cprint("Initializing dedicated server...\n");
			elohim_playmode = elohim_playmode | ELOHIM_DEDICATED_SERVER;
		}
		else
		{
			cprint("Initializing listen server...\n");
			utils_set_cvar("ambient_fade", temp);
		}

		// Set aliases for console commands
		console_set_aliases();

		// Initialize global variables
		if (elohim_playmode & ELOHIM_DEDICATED_SERVER)
		{
			cvar_set("v_kickroll", "0");  // elohim_level
			cvar_set("v_kicktime", "0");  // elohim_overtime
		}
		serverflags = 0;
		elohim_playmode = elohim_playmode | ELOHIM_SERVER_INITIALIZED;
		elohim_playmode = elohim_playmode | ELOHIM_NO_SPOOGE;
		elohim_playmode = elohim_playmode | ELOHIM_EXTENDED_OBITS;
		utils_set_cvar("samelevel", elohim_playmode);
		}

		if (elohim_playmode & ELOHIM_DEDICATED_SERVER)
		{
		elohim_level = cvar("v_kickroll");
		elohim_overtime = cvar("v_kicktime");
		}

		// Set global variables
		elohim_player_ids = 1;
		elohim_devparam = 0;
		elohim_nextcheck = time;
	elohim_nextcheck2 = time;
		elohim_request = world;
		elohim_levelcount = 0;
		elohim_lastcount = 0;
		elohim_state = 0;
		elohim_num_spawns = 0;
		elohim_num_starts = 0;
		elohim_num_cameras = 0;
		elohim_debug_client = world;
	crmod_best_chase_target = world;
	auto_parm1 = 80;
	auto_parm2 = 270;
	auto_parm3 = 20;
	auto_parm4 = 100;
	elohim_score_count = 0;


		if (elohim_playmode & ELOHIM_MATCH_MODE)
		{
		elohim_timelimit = cvar("timelimit");
		if (elohim_timelimit == 0)
			elohim_timelimit = 20;
		if (elohim_timelimit < 2)
			elohim_timelimit = 2;
		match_show_timelimit();
		}
		else
		elohim_timelimit = 20;

		// show mode
		mode = options_get_mode();
		szmode = strings_get_mode(mode);
		cprint2(szmode, " mode\n");

		localcmd("exec crmod.cfg\n");

		// schedule the entities for a bit later so that they don't
		// interfere with the password
		if (elohim_playmode & ELOHIM_DEDICATED_SERVER)
			utils_make_scheduled_event(elohim_load_entities, 0.2);
};

//
//  L O A D  C A M E R A S
//
//  This is scheduled after elohim_load_entities.
//
void () elohim_load_cameras =
{
		return;
		// May crash QE?
		// cprint3("\"Searching for optional file cameras/", mapname, ".cam\"\n");
		// cprint("\"It is OPTIONAL - there is nothing wrong if it can't be found.\"\n");
		// localcmd3("exec cameras/", mapname, ".cam;wait\n");
		// remove(self);
};

//
//  L O A D  E N T I T I E S
//
void () elohim_load_entities =
{
		return;
		// Crashes QE!
		// cprint3("\"Searching for optional file entities/", mapname, ".ent\"\n");
		// cprint("\"It is OPTIONAL - there is nothing wrong if it can't be found.\"\n");
		// localcmd3("exec entities/", mapname, ".ent;wait\n");
		// self.think = elohim_load_cameras;
		// self.nextthink = time + 0.2;
};

//
//  S E T  T E A M P L A Y
//
//  Sets the teamplay server variable to show teamplay and "ClanRing4.0".
//  If value = -1 then the teamplay variable is preserved; otherwise it
//  is changed to 'value'.
//
void (float value) elohim_set_teamplay =
{
		local string temp;

		if (value != -1)
		teamplay = value;
		temp = ftos(teamplay);
		localcmd5("teamplay \"", temp, "?ClanRing", crmod_version_number, "\"\n");
};

//
//  S E T  F R A G L I M I T
//
//  Sets the fraglimit server variable to show fraglimit, "CRMod++",
//  and either "FFA", "Practice" or "Match" depending on the current mode.
//  If value = -1 then the fraglimit variable is preserved; otherwise it
//  is changed to 'value'.
//
void (float value) elohim_set_fraglimit =
{
		local string temp;

		if (value != -1)
		utils_set_cvar("fraglimit", value);
		fraglimit = cvar("fraglimit");
		temp = ftos(fraglimit);
		localcmd3("fraglimit \"", temp, " : CRMod++ ");
		if (elohim_playmode & ELOHIM_MATCH_MODE)
		localcmd("Match\"\n");
		else if (elohim_playmode & ELOHIM_PRACTICE_MODE)
		localcmd("Practice\"\n");
		else
		localcmd("FFA\"\n");
};

//
//  S E T  A L I A S E S
//
//  This is scheduled using a temporary entity; the client
//  is stored in self.owner.
//
void () elohim_set_aliases =
{
		local entity temp;

		temp = self;
		self = self.owner;

		// Check for binds
		if (self.style & ELOHIM_FOUND_BINDINGS)
	{
		self = temp;
		remove(self);
		return;
	}

		sprint3(self, "Sending ", elohim_version, " bindings\n");

		// Set aliases
	stuffcmd(self, "alias dbinfo impulse 40\n");    // undocumented debug command
	stuffcmd(self, "alias dbflags impulse 41\n");   // undocumented debug command
	stuffcmd(self, "alias dbvars impulse 42\n");    // undocumented debug command
	stuffcmd(self, "alias dbcvar impulse 43\n");    // undocumented debug command
	stuffcmd(self, "alias dbclient impulse 44\n");  // undocumented debug command
	stuffcmd(self, "alias dbcflags impulse 45\n");  // undocumented debug command
	stuffcmd(self, "alias dbparm1 impulse 46\n");   // undocumented debug command
	stuffcmd(self, "alias dbparm2 impulse 47\n");   // undocumented debug command
	stuffcmd(self, "alias dbparm3 impulse 48\n");   // undocumented debug command
	stuffcmd(self, "alias dbparm4 impulse 49\n");   // undocumented debug command
	stuffcmd(self, "alias dbparms impulse 50\n");   // undocumented debug command
	stuffcmd(self, "alias dbhelp impulse 59\n");	// undocumented debug command
		stuffcmd(self, "alias chase_active \"say chase_active has been disabled on this server.\"\n");  // CRMOD cheat fix
		stuffcmd(self, "alias help-server impulse 100\n");
		stuffcmd(self, "alias help-observer impulse 101\n");
		stuffcmd(self, "alias help-misc impulse 105\n");
		stuffcmd(self, "alias commands impulse 106\n");
		stuffcmd(self, "alias levels impulse 107\n");
		stuffcmd(self, "alias warp impulse 107\n");
		stuffcmd(self, "alias admin impulse 108\n");
		stuffcmd(self, "alias motd impulse 109\n");
		stuffcmd(self, "alias killstats impulse 110\n");
		stuffcmd(self, "alias efficiency impulse 111\n");
		stuffcmd(self, "alias eff impulse 111\n");                  // CRMOD - so people don't have to spell out efficiency
		stuffcmd(self, "alias stats impulse 112\n");
		stuffcmd(self, "alias quadstats impulse 113\n");    // CRMOD - new impulse
		stuffcmd(self, "alias autostats impulse 204\n");
		stuffcmd(self, "alias allstats impulse 203\n");
		stuffcmd(self, "alias teamstats impulse 202\n");
		stuffcmd(self, "alias autoweapon impulse 114\n");
		stuffcmd(self, "alias aw impulse 114\n");
		stuffcmd(self, "alias vinfo impulse 117\n");
		stuffcmd(self, "alias ticrate impulse 118\n");
		stuffcmd(self, "alias ignorethis impulse 119\n"); // CRMOD - matches alias init that is used in crmods pre-4.0 and turns smooth off
		stuffcmd(self, "alias yes impulse 115\n");
		stuffcmd(self, "alias no impulse 116\n");
		stuffcmd(self, "alias ready impulse 120\n");
		stuffcmd(self, "alias notready impulse 121\n");
		stuffcmd(self, "alias unlock impulse 122\n");
		stuffcmd(self, "alias ready? impulse 123\n");
		stuffcmd(self, "alias timerstop impulse 124\n");
		stuffcmd(self, "alias timerstart impulse 125\n");
		stuffcmd(self, "alias ghostcode impulse 126\n");
		stuffcmd(self, "alias ghost impulse 127\n");
		stuffcmd(self, "alias score impulse 128\n");
		stuffcmd(self, "alias help-match impulse 129\n");
		stuffcmd(self, "alias lock impulse 130\n");
		// Disabled because they result in aliases containing incomplete quotes
		// stuffcmd(self, "alias +teamscores impulse 131\"\n");
		// stuffcmd(self, "alias -teamscores impulse 132\"\n");
		stuffcmd(self, "alias observer impulse 140\n");
		stuffcmd(self, "alias walk impulse 141\n");
		stuffcmd(self, "alias flyme impulse 142\n");
		stuffcmd(self, "alias chase impulse 143\n");
		stuffcmd(self, "alias chasecam impulse 143\n");
		stuffcmd(self, "alias headsup impulse 148\n");
		stuffcmd(self, "alias eyecam impulse 149\n");
		stuffcmd(self, "alias help-walk impulse 144\n");
		stuffcmd(self, "alias help-fly impulse 145\n");
		stuffcmd(self, "alias help-chase impulse 146\n");
		stuffcmd(self, "alias tourney impulse 151\n");              // CRMOD - enables tournament mode chasecam
		stuffcmd(self, "alias camera impulse 153\n");               // CRMOD - sets camera mode
		stuffcmd(self, "alias autocam impulse 154\n");              // CRMOD - autocam
		stuffcmd(self, "alias autocamera impulse 154\n");   // CRMOD - autocam
		stuffcmd(self, "alias quaketv impulse 154\n");              // CRMOD - autocam
		stuffcmd(self, "alias autochase impulse 155\n");    // CRMOD - autochase
		stuffcmd(self, "alias help-camera impulse 156\n");  // CRMOD - camera help
		stuffcmd(self, "alias autoeye impulse 157\n");      // CRMOD - autochase in eyecam/demo mode
	// Disable broken multi-command alias- set cl_nolerp 1 and cl_predict 0 for chase cams (smooth on)
	//   stuffcmd(self, "alias sm1 \"echo Smoothing ON ; cl_nolerp 1 ; alias smooth sm0\"\n"); // CRMOD - smooth now uses aliases
	// Disable broken multi-command alias- set cl_nolerp 0 and cl_predict 1 for normal play (smooth off)
	// stuffcmd(self, "alias sm0 \"echo Smoothing OFF ; cl_nolerp 0 ; alias smooth sm1\"\n");  // CRMOD
	// stuffcmd(self, "alias smooth sm1\n");                                                   // CRMOD
	stuffcmd(self, "alias init echo\n");                            // CRMOD - So clients only see 'init' once

	self.style = self.style | ELOHIM_FOUND_BINDINGS;

		// remove the temporary entity
		self = temp;

	self.nextthink = time + 0.5;
	self.think = admin_send_aliases1;
};

//
//  P R E  S E T  A L I A S E S
//
void () elohim_pre_set_aliases =
{
	sprint(self.owner, "Checking bindings.. (set cl_filterstuffcmd 0 before connecting!)\n");
	// Probably not even valid with QE, just disable until/unless it matters
	// sprint(self.owner, "\bUse \b-zone 512 \bif quake crashes\n");

		self.think = elohim_set_aliases;
		self.nextthink = time + 2.5;
};

//
//  I N I T  T H I N K
//
//  Called 0.2 seconds after a client connects.  Plays the wizard sound
//  and schedules the aliases to be sent.
//
void () elohim_init_think =
{
		local entity temp;
		temp = self;
		self = self.owner;
		if (!(elohim_playmode & ELOHIM_MATCH_MODE) ||
		!(elohim_state & ELOHIM_MATCH_STARTED))
		sound(self, CHAN_AUTO, "wizard/wsight.wav", 1, ATTN_NONE);
	if (utils_illegal_name(self.netname))
		stuffcmd(self, "name player\n");

	// test for binds
		stuffcmd(self, "ignorethis\n");                     // CRMOD

		sprint(self, "Trying to disable unicode font...\n");
		// Disable unicode font (allow quake characters/red letters)
		stuffcmd(self, "scr_usekfont 0\n");

		self = temp;
		self.think = elohim_pre_set_aliases;
		self.nextthink = time + 1.5;
};

//
//  S H O W  M O D E
//
//  Show mode and help info to a player after they connect.
//
void () elohim_show_mode =
{
		sprint2(self.owner, elohim_version, "\n");
		if (elohim_playmode & ELOHIM_MATCH_MODE)
		sprint(self.owner, "match mode - help-match for help\n");
		else if (elohim_playmode & ELOHIM_PRACTICE_MODE)
		sprint(self.owner, "practice mode\n");
		else
		sprint(self.owner, "FFA mode\n");
		remove(self);
};

//
//  C L I E N T  C O N N E C T
//
//  Called from ClientConnect in Client.qc when a client enters the
//  server.  This occurs when the client first connects over the network
//  and every time a new level is started.
//
void () elohim_client_connect =
{
		if ((parm10 & ELOHIM_NEW_CLIENT) > 0)
		{
		// This is a new client (just connected over the network)

		// Show the MOTD
		motd_create();
		utils_make_scheduled_event(elohim_init_think, 0.5);
		if (elohim_playmode & CRMOD_QSMACK_ON)
			utils_make_scheduled_event(qsmack_detect, 1.5);

		// Give the player a unique ID
		parm11 = elohim_player_ids;
		elohim_player_ids = elohim_player_ids + 1;
		if (elohim_player_ids > 65535)
			elohim_player_ids = 1;

		// Get rid of the new client flag
		parm10 = parm10 - ELOHIM_NEW_CLIENT;

		// Set default observer flags
		parm12 = OBSERVER_TOURNEY | OBSERVER_WALK;

		// Show the status for people who log the console
		localcmd("status\n");

		stats_reset();
		}

	// Check to see if there is a scoreboard conflict
	if (elohim_playmode & ELOHIM_MATCH_MODE)
		score_client_connect();

		utils_make_scheduled_event(elohim_show_mode, 0.5);
		self.cnt = ELOHIM_MAX_SUICIDES;  // numer of suicides allowed
		self.finaldest_y = 0;    // used for pinging
		self.owner = world;      // no ghost
		self.trigger_field = world; // last spawn point
		self.use = SUB_Null;
		self.style = 0;
	self.delayed_impulse = 0;
	self.crmod_cam_delay = 0;
	self.crmod_did_damage = time - 15;
	self.crmod_lastkill = time - 30;
	self.attack_finished = time - 10;

	// This is to prevent a condition where one player is another player's
	// movetarget, which can confuse the auto module.
	self.movetarget = world;

		parm10 = parm10 - (parm10 &
		(ELOHIM_READY | ELOHIM_KICK_CONFIRM | ELOHIM_MOTD |
		 ELOHIM_SETTING_OPTIONS | ELOHIM_SCOREBOARD |
		 CRMOD_DETECTING_QSMACK | ELOHIM_CONFIRM_LEAVE));
};

//
//  C L I E N T  D I S C O N N E C T
//
//  Called from ClientDisconnect in Client.qc when a client leaves.
//
void () elohim_client_disconnect =
{
		self.style = self.style - (self.style & ELOHIM_CONNECTED);
		self.finaldest_x = -30;     // Used to test for disconnected players
		self.crmod_chase_score = ELOHIM_NEGINF;  // CRMOD make sure they don't have some high rating that can't be beat by the other players

		// Check to see if anyone was observing this client;
		observer_disconnect_notify(self);

		// If we're in match mode, then inform match and score modules
		if (elohim_playmode & ELOHIM_MATCH_MODE)
	{
		match_disconnect_notify(self);
		score_client_disconnect();
	}

		// Let the admin module know in case there's a kick in progress
		admin_disconnect_notify(self);

		// Check to see if we were debugging this client
		if (elohim_debug_client == self)
		elohim_debug_client = world;

		// CRMOD Qsmack Reset
		self.qsmack_level = 0;
		self.qsmack_trylevel = 0;
		qsmack_statusokay = 0;
		// CRMOD END
};

//
//  B F  T H I N K
//
//  Creates a background flash - used for player spawns.
//
void () elohim_bf_think =
{
		stuffcmd(self.owner, "bf\n");
		remove(self);
};

//
//  O B S E R V E R  S T A R T  T H I N K
//
//  This is a hack.. observer_start is being called a second time, 0.6
//  seconds after the first time, to cover a few details that don't make
//  it when the client first connects (such as the observer colour).
//
void () elohim_observer_start_think =
{
		local entity oself;

		oself = self;
		self = self.owner;
		observer_start();
		self = oself;
		remove(self);
};

//
//  P U T  C L I E N T  I N  S E R V E R
//
//  Called from PutClientInServer in Client.qc
//
void () elohim_put_client_in_server =
{
		utils_make_scheduled_event(elohim_bf_think, 0.1);

		if ((self.style & ELOHIM_OBSERVER) || (self.style & CRMOD_QSMACK) ||
		((elohim_playmode & ELOHIM_MATCH_MODE) && (!(self.style & ELOHIM_READY))))
		{
		observer_start();
		utils_make_scheduled_event(elohim_observer_start_think, 0.6);
		}
		else
		{
		player_stand1();
		spawn_tdeath (self.origin, self);
		makevectors(self.angles);
		spawn_tfog (self.origin + v_forward*20);
		}

		// Prevent fire-on-respawn (in case player used attack button to respawn)
		self.style = self.style - (self.style & ELOHIM_OK_TO_SHOOT);
		self.style = self.style | ELOHIM_CONNECTED;
		self.button0 = 1;
		self.wait = time + 2;    // for periodic checks
		self.finaldest_x = time; // used to check for disconnected clients
};

//
//  H E L P
//
//  Show general help commands.
//
void () elohim_help =
{
		local string numsuicides;

		numsuicides = strings_ftos_gold(ELOHIM_MAX_SUICIDES);

		sprint2(self, elohim_version, "\n");
		sprint(self, "http://www.mpog.com/clanring/crmod\n");
		sprint(self, "Âõç òåðïòôó ôï crbug@mpog.com\n");
		sprint3(self, "ŽÍáøéíõí ", numsuicides, " óõéãéäåó ðåò ìåöåìŽ\n");
		sprint(self, "Help commands (type in console):\n");
		sprint(self, " vinfo         - server version info\n");
		sprint(self, " help-misc     - misc commands\n");
		sprint(self, " help-observer - observer commands\n");
		sprint(self, " help-match    - match mode help\n");
		if (self.style & ELOHIM_ADMINISTRATOR)
		sprint(self, " help-admin    - admin commands\n");
	sprint(self, " commands - list commands/impulses\n");
};

//
//  H E L P  C H A N G E
//
//  Show help on how to change levels.
//
void () elohim_help_change =
{
		sprint(self, "\n");
		sprint(self, "Ôï ãèáîçå ìåöåìó¬ åîôåò ôèå îáíå ïæ\n");
		sprint(self, "ôèå ìåöåì éî ôèå ãïîóïìå®\n");
};

//
//  H E L P  M I S C
//
//  Show misc commands.
//
void () elohim_help_misc =
{
		sprint(self, " admin    - enter admin code\n");
		sprint(self, " setquad  - enable/disable quad\n");
		sprint(self, " setpent  - enable/disable pent\n");
		sprint(self, " setring  - enable/disable ring\n");
		if (elohim_playmode & ELOHIM_MODE_VOTE)
		{
		sprint(self, " normal   - request FFA play\n");
		sprint(self, " practice - request practice mode\n");
		sprint(self, " match    - request match mode\n");
		}
		sprint(self, " nogibs   - disable gibs\n");
		sprint(self, " lowgibs  - set gibs to 'low'\n");
		sprint(self, " highgibs - set gibs to 'high'\n");
		sprint(self, " motd     - show message of the day\n");
		sprint(self, " commands - list commands/impulses\n");
		sprint(self, " observer - toggle observer mode\n");
		sprint(self, " levels   - list all server levels\n");
		sprint(self, " stats    - summarize statistics\n");
		sprint(self, " killstats  - list player kill stats\n");
		sprint(self, " efficiency - list player efficiency\n");
		sprint(self, " quadstats  - list player quad stats\n");
		sprint(self, " autoweapon - toggle smartweapon\n");
		sprint(self, " ticrate  - view sys_ticrate\n");
};

//
//  I N F O
//
void () elohim_info =
{
		sprint(self, "\n");
		sprint(self, "Åìïèéí - Literally, the shining ones.\n");
		sprint(self, "         Used in ancient texts to\n");
		sprint(self, "         refer to angels.\n\n");
		sprint(self, "http://elo.home.ml.org\n\n");
};

//
//  C O M M A N D S
//
//  List all commands and impulses.
//
void () elohim_commands =
{
		// regular user commands
		sprint(self, " vinfo®®®®®®®®®®““™ help-server®®®“’’\n");
		sprint(self, " help-misc®®®®®®“’— help-match®®®®“”›\n");
		sprint(self, " help-observer®®“’“ help-walk®®®®®“––\n");
		sprint(self, " help-fly®®®®®®®“–— help-chase®®®®“–˜\n");
		sprint(self, " help-camera®®®®“—˜ commands®®®®®®“’˜\n");
	sprint(self, " levels®®®®®®®®®“’™ autoweapon®®®®““–\n");
		sprint(self, " admin®®®®®®®®®®“’š motd®®®®®®®®®®“’›\n");
		sprint(self, " observer®®®®®®®“–’ walk®®®®®®®®®®“–“\n");
		sprint(self, " flyme®®®®®®®®®®“–” chase®®®®®®®®®“–•\n");
		sprint(self, " eyecam®®®®®®®®®“–› camera®®®®®®®®“—•\n");
	sprint(self, " autochase®®®®®®“—— autocam®®®®®®®“—–\n");
		sprint(self, " headsup®®®®®®®®“–š smooth®®®®®®®®N/A\n");
		sprint(self, " tourney®®®®®®®®“—“ yes®®®®®®®®®®®““—\n");
		sprint(self, " no®®®®®®®®®®®®®““˜ ready®®®®®®®®®“”’\n");
		sprint(self, " notready®®®®®®®“”“ ready?®®®®®®®®“”•\n");
		sprint(self, " unlock®®®®®®®®®“”” lock®®®®®®®®®®“•’\n");
		sprint(self, " timerstop®®®®®®“”– timerstart®®®®“”—\n");
	sprint(self, " +teamscores®®®®N/A -teamscores®®®N/A\n");
		sprint(self, " timelimit5®®®®®”“— timelimit10®®®”“˜\n");
		sprint(self, " timelimit15®®®®”“™ timelimit20®®®”“š\n");
		sprint(self, " timelimit25®®®®”“› timelimit30®®®””’\n");
		sprint(self, " ghostcode®®®®®®“”˜ ghost®®®®®®®®®“”™\n");
		sprint(self, " score®®®®®®®®®®“”š nogibs®®®®®®®®””—\n");
		sprint(self, " lowgibs®®®®®®®®””˜ highgibs®®®®®®””™\n");
		sprint(self, " setquad®®®®®®®®””“ setpent®®®®®®®”””\n");
		sprint(self, " setring®®®®®®®®””• normal®®®®®®®®”’š\n");
		sprint(self, " practice®®®®®®®”’› match®®®®®®®®®”“’\n");
		sprint(self, " efficiency®®®®®“““ stats®®®®®®®®®““”\n");
		sprint(self, " killstats®®®®®®““’ quadstats®®®®®““•\n");
	sprint(self, " obits®®®®®®®®®®”““ ticrate®®®®®®®““š\n");

		// admin commands
		if (self.style & ELOHIM_ADMINISTRATOR)
		{
		sprint(self, " help-admin®®®®®”’’ options®®®®®®®””›\n");
		sprint(self, " setcharge®®®®®®””– kick!®®®®®®®®®”“•\n");          // CRMOD - changed spooge to (dis)charge
		sprint(self, " abortmatch®®®®®”“– ghostlist®®®®®”“”\n");
		sprint(self, " modevote®®®®®®®””š spot®®®®®®®®®®”—’\n");
		sprint(self, " nextspawn®®®®®®”–˜ makespawn®®®®®”–™\n");
		sprint(self, " nextcam®®®®®®®®”–š makecam®®®®®®®”–›\n");
		sprint(self, " qsmack®®®®®®®®®•™\n");
		}
		sprint(self, "\n");

		elohim_help_change();
};

//
//  L E V E L S
//
//  List all levels recognized by the server.
//
void () elohim_levels =
{
		local float index;
		local string name;

		elohim_help_change();
		sprint(self, "\n");

		// standard levels
		sprint(self, " start, start0, start1, end\n");
		sprint(self, " e1m1-e1m8 ¼åðéóïäå ±¾\n");
		sprint(self, " e2m1-e2m7 ¼åðéóïäå ²¾\n");
		sprint(self, " e3m1-e3m7 ¼åðéóïäå ³¾\n");
		sprint(self, " e4m1-e4m8 ¼åðéóïäå ´¾\n");
		sprint(self, " dm1-dm6   ¼äåáôèíáôãè¾\n");

		// user defined levels
		index = 0;
		while (index < 10)
		{
		name = array_get_user_map(index);
		if (name != "")
			sprint3(self, " ", name, "\n");
		index = index + 1;
		}
};

//
//  P I N G  R E P L Y
//
//  Called when a client responds to a manual ping via impulse 38 (was 103).
//
void () elohim_ping_reply =
{
		cprint3("reply from \"", self.netname, "\"\n");
		self.finaldest_y = time;
};

//
//  B A D  I M P U L S E
//
//  Seems like some people get stuck with the old clanring bindings.
//  Let them know that something ain't right.
//
void () elohim_bad_impulse =
{
		sprint(self, "You have entered an invalid impulse.\n");
		sprint(self, "Your bindings may be incorrect - try\n");
		sprint(self, "reconnecting to the server.\n");
};

//
//  V E R S I O N  I N F O
//
void () elohim_vinfo =
{
		sprint3(self, "\n", elohim_version_info, "\n\n");
		sprint(self, "Adapted from the Elohim Server\n\n");
};

//
//  T I C R A T E
//
void () elohim_ticrate =
{
	if (elohim_playmode & ELOHIM_DEDICATED_SERVER)
	{
		local float ticrate;

		ticrate = cvar("sys_ticrate");
		sprint(self, "sys_ticrate = ");
		utils_print_floatn(ticrate, 3);
	}
	else
		sprint(self, "This is not a dedicated server\n");
};

//
//  I M P U L S E
//
//  Called from PlayerPreThink or observer_pre_think
//
void () elohim_impulse =
{
		if (self == elohim_debug_client)
		{
		local string temp;
		temp = ftos(self.impulse);
		cprint3("elohim impulse ", temp, "\n");
		}

	// CRMOD Qsmack
	if (self.style & CRMOD_DETECTING_QSMACK)
		qsmack_detecting();
	else if (self.impulse == 38) // used for sping (was 103)
		elohim_ping_reply();
	else if (self.impulse == 39) // used for testing for disconnects (was 104)
		self.finaldest_x = time;
	else if (self.impulse < 100)
	{
		if ((self.impulse >= 40) && (self.impulse <= 59))
			debug_impulse();
		else
			qsmack_impulse();
	}
		// CRMOD END
		else if ((self.impulse >= 120 && self.impulse <= 139) || self.impulse == 225)
		match_impulse();

		else if ((self.impulse >= 140 && self.impulse <= 159) || self.impulse == 226)
		observer_impulse();

		else if (self.impulse == 202)
			stats_show_teamstats();

		else if (self.impulse == 203)
			stats_autodump();

		else if (self.impulse == 204)
			utils_toggle_flag(CRMOD_AUTOSTATS, "Autostats");

		else if (self.impulse >= 190)
		admin_impulse();


		else if (self.impulse == 100)
		elohim_help();
		else if (self.impulse == 101)
		observer_help();
		else if (self.impulse == 102)
		elohim_info();
		else if (self.impulse == 105)
		elohim_help_misc();
		else if (self.impulse == 106) // list commands and impulses
		elohim_commands();
		else if (self.impulse == 107) // list valid levels
		elohim_levels();
		else if (self.impulse == 108) // start entering the admin code
		admin_start_code();
		else if (self.impulse == 109) // show the MOTD
		motd_create();
		else if (self.impulse == 110)
		stats_show_killstats();
		else if (self.impulse == 111)
		stats_show_efficiency();
		else if (self.impulse == 112) // show summary statistics
		stats_show_summary();
		else if (self.impulse == 113) // CRMOD - show quad statistics
		stats_show_quadstats();
	else if (self.impulse == 114)
		utils_toggle_flag(CRMOD_SMART_WEAPON, "Smart weapon switching");
		else if (self.impulse == 117) // show version info
		elohim_vinfo();
	else if (self.impulse == 118)
		elohim_ticrate();
		else if (self.impulse == 119)
		self.style = self.style | ELOHIM_FOUND_BINDINGS;
		else if (self.impulse >= 115 && self.impulse <= 116) // yes/no
		{
		if (self.style & ELOHIM_KICK_CONFIRM)
			admin_confirm_kick_response(116 - self.impulse);
		else if (self.style & ELOHIM_CONFIRM_LEAVE)
			observer_confirm_leave_response(116 - self.impulse);
		else
			vote_impulse();
		}
		else
		sprint(self, "type 'help-server' in console for help\n");

		self.impulse = 0;
};

//
//  K I C K  P L A Y E R
//
void (entity client) elohim_kick_player =
{
		local string temp;
	local entity oself;

		temp = ftos(client.colormap);
		localcmd3("kick # ", temp, "\n");
	oself = self;
	self = client;
	ClientDisconnect();
	self = oself;
};

//
//  C L I E N T  S U I C I D E
//
//  Called from ClientKill in Client.qc.  Checks to see if the player
//  has exceeded their suicide limit and returns either ELOHIM_SUICIDE_OK
//  or ELOHIM_TOO_MANY_SUICIDES accordingly.
//
float () elohim_client_suicide =
{
		local string temp;

		// Always OK for admins or practice mode
		if (self.style & ELOHIM_ADMINISTRATOR)
		return ELOHIM_SUICIDE_OK;

		self.cnt = self.cnt - 1;
		if (self.cnt < 0)
		{
		// too many suicides
		if (self.cnt == -1) // only want to do this stuff once
		{
			bprint2(self.netname, " kicked for suiciding\n");
			cprint3("\"", self.netname, " kicked for suiciding\"\n");
			elohim_kick_player(self);
		}
		return ELOHIM_TOO_MANY_SUICIDES;
		}
		temp = ftos(self.cnt);
		sprint3(self, "you have ", temp, " suicides remaining\n");
		return ELOHIM_SUICIDE_OK;
};

//
//  P E R I O D I C  C H E C K S
//
//  Do various checks every second.  Called from PlayerPreThink in
//  Client.qc.
//
void () elohim_periodic_checks =
{
	if (!(self.style & ELOHIM_CONNECTED))
		return;

	/* //removed because this happens often during pub games
  if (utils_illegal_name(self.netname))
	{
		// Let's be fairly draconian about this
		bprint("Player kicked for illegal name\n");
		cprint("\"Player kicked for illegal name\"\n");
		elohim_kick_player(self);
		return;
	}
  */

		if (self.style & ELOHIM_OBSERVER)
		{
		// find the closest teleport
		observer_find_teleport();

		// check for 'squished'
		observer_check_size();
		}
	else
		auto_compute_score();
};

//
//  S T A R T  F R A M E
//
//  Called from StartFrame in World.qc.  This routine performs periodic
//  checks in match mode and checks for server console commands.
//
void () elohim_start_frame =
{
		local float command;

		if (!(elohim_playmode & ELOHIM_MATCH_MODE))
		{
		if (time >= timelimit)
		{
			if (timelimit && !gameover)
			NextLevel ();
		}
		}

	// Do some maintenance
		if (time >= elohim_nextcheck && !gameover)
		{
		local entity player;

		// update variables
		timelimit = cvar("timelimit") * 60;
		fraglimit = cvar("fraglimit");
		teamplay = cvar("teamplay");

		// send out ping to test for disconnected players
		/*
		WriteByte(MSG_ALL, SVC_STUFFCMD);
		WriteString(MSG_ALL, "impulse 39\n");           // CRMOD changed from 104 to 39
		*/
		player = find(world, classname, "player");
		while (player)
		{
			if (player.style & ELOHIM_CONNECTED)
			{
				if (time > player.finaldest_x + 20)
				{
					// Automatically kick player
					/*
					bprint3("No response from ", player.netname, "\n");
					cprint3("\"No response from ", player.netname, "\"\n");
					elohim_kick_player(player);
					*/
				}
			}
			else
			{
				// remove clutter
				player.model = string_null;
				player.solid = SOLID_NOT;
			}

			player = find(player, classname, "player");
		}

		elohim_nextcheck = time + 5;
		}

		if (time >= elohim_nextcheck2 && !gameover)
	{
		auto_find_best();
		elohim_nextcheck2 = time + 1;
	}

		if (elohim_levelcount)
		{
		// Check for end of file in levels.cfg.  We assume end of file
		// if it's been 1 second since the last update to levelcount.
		// When end of file is detected, levelcount is reset to 0 to
		// allow players to exit the intermission.
		if (time >= elohim_nextcheck)
		{
			if (elohim_levelcount == elohim_lastcount)
			elohim_levelcount = 0;
			elohim_lastcount = elohim_levelcount;
			elohim_nextcheck = time + 1;
		}
		}

		// Check for a console command
		command = cvar("temp1");
		cvar_set("temp1", "0");
		if (command)
		console_command(command);
};
