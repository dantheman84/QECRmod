//
// Elodefs.qc
//
// Constants and global variables used in the Elohim mod.
//
// All code by J.P. Grossman unless otherwise commented.
//

// constants
float ELOHIM_SUICIDE_OK = 0;
float ELOHIM_TOO_MANY_SUICIDES = 1;
float ELOHIM_NEGINF = -9999999;

// client styles
float ELOHIM_NEW_CLIENT = 1;           // set when a client first connects
float ELOHIM_ADMINISTRATOR = 2;        // set if the client is an admin
float CRMOD_DETECTING_QSMACK = 4;    // set when detecting if client is a qsmack bot
float ELOHIM_POP_FORWARD = 8;       // used to walk through doors
float ELOHIM_READY = 16;             // ready to play in match
float ELOHIM_YES = 32;               // used for voting
float ELOHIM_HEADS_UP = 64;          // enable heads up display
float ELOHIM_SETTING_OPTIONS = 128;  // set when setting options
float ELOHIM_MOTD = 256;             // showing MOTD
float ELOHIM_OK_TO_SHOOT = 512;      // don't fire after options/respawn
float ELOHIM_KICK_CONFIRM = 1024;    // used to confirm a kick
float ELOHIM_CONFIRM_LEAVE = 2048;   // confirmation for leaving match
float ELOHIM_CONNECTED = 4096;       // client has been put in server
float ELOHIM_FOUND_BINDINGS = 8192; // used to check for bindings
float CRMOD_SMART_WEAPON = 16384;    // whether or not to use `smart' weapon switching
float ELOHIM_OBSERVER = 32768;		 // set if the client is an observer
float CRMOD_QSMACK = 65536;			// set for qsmack bots
float ELOHIM_SCOREBOARD = 131072;	// player is looking at teamscores
float CRMOD_AUTOSTATS = 262144;	    // player has autostats enabled

// observer flags  (/me kills jp)
float OBSERVER_WALK = 1;        // set in walk mode
float OBSERVER_FLY = 2;        // set in fly mode
float OBSERVER_CHASE = 4;      // set in chase mode
float OBSERVER_DEMO = 8;       // see through chasetargets eyes
float OBSERVER_CAMERA = 16;		// set to camera mode
float OBSERVER_AUTO = 32;	   // view autoswitching
float OBSERVER_TOURNEY = 64;	   // set tournement mode for chasecam
float OBSERVER_GO_AUTO = 128;  // player entering an auto mode


// CRMOD qsmack variables
.float qsmack_level;
.float qsmack_trylevel;
float qsmack_statusokay;				// True if qsmack bot just did a status


// server mode - stored in cvar 'samelevel' and preserved across levels
float ELOHIM_SAME_LEVEL = 1;
float ELOHIM_MATCH_MODE = 2;
float ELOHIM_PRACTICE_MODE = 4;
float ELOHIM_SERVER_INITIALIZED = 8;
float ELOHIM_NO_GIBS = 16;
float ELOHIM_LOW_GIBS = 32;
float ELOHIM_NO_QUAD = 64;
float ELOHIM_NO_PENT = 128;
float ELOHIM_NO_RING = 256;
float ELOHIM_MODE_VOTE = 512;
float ELOHIM_DEDICATED_SERVER = 1024;
float ELOHIM_NO_SPOOGE = 2048;			// disable spooging in practice mode
float CRMOD_QSMACK_ON = 4096;			// CRMOD is server using Qsmack?
float ELOHIM_EXTENDED_OBITS = 8192;
float ELOHIM_GGMOD = 16384;
float ELOHIM_QUAD_DROP = 32768;

// server state - not preserved across level changes
float ELOHIM_TIMER_STARTED = 1;
float ELOHIM_MATCH_STARTED = 2;
float ELOHIM_MATCH_PAUSED = 4;
float ELOHIM_MATCH_OVER = 8;
float ELOHIM_MATCH_WAIT = 16;   // 5 second delay after match ends
float ELOHIM_KICKING = 32;

// admin constants
float ADMIN_NORMAL_MODE = 0;
float ADMIN_PRACTICE_MODE = 1;
float ADMIN_MATCH_MODE = 2;

// elohim global variables
float elohim_player_ids;    // used for assigning unique player ID's
float elohim_password;      // used to store the administrator password
float elohim_devparam;      // used for development
float elohim_playmode;      // current play mode (non volatile flags)
float elohim_state;         // server state (volatile flags)
float elohim_timelimit;     // timelimit for matches (default 20 minutes)
float elohim_overtime;      // length of auto-overtime; 0 if none
float elohim_nextcheck;     // used for periodic checks
float elohim_nextcheck2;	// used for frequent periodic checks
entity elohim_request;      // used to control voting
float elohim_level;         // number of current level in user level order
float elohim_levelcount;    // used to scan through list in levels.cfg
float elohim_lastcount;     // used to detect end-of-file in levels.cfg
float elohim_num_spawns;    // number of deathmatch spawn points
float elohim_num_starts;    // number of match extra start points
float elohim_num_cameras;   // number of cameras
string elohim_version;      // used for motd and help-server
string elohim_version_info; // text info including rev. and compile time
string crmod_version_number; // text info storing version number (ie "4.0")
entity elohim_debug_client; // used for debugging

// match global variables
float elohim_match_pause_time;  // records time that match was paused
float elohim_team1;             // pants colour of team 1
float elohim_team2;             // pants colour of team 2
float elohim_lastteam1;         // team 1 colour from last match
float elohim_lastteam2;         // team 2 colour from last match
float elohim_teamsize1;         // # players in team 1
float elohim_teamsize2;         // # players in team 2
float elohim_teamfrags1;        // team 1 score
float elohim_teamfrags2;        // team 2 score
float elohim_maxsize;           // maximum allowed team size
entity elohim_match_timer;      // used to time match

// score global variables
float elohim_winning_team;		// team number of team in the lead
string elohim_winning_teamname;	// name of winning team (as returned by strings_get_teamname)
string elohim_teamname1;		// as returned by strings_get_teamname_bronze
string elohim_teamname2;		// as returned by strings_get_teamname
float elohim_score_number;		// either difference in score or tied score
string ELOHIM_STRING_TIED;		// initialized to "   Tied at "
float elohim_score_count;		// number of clients looking at score

// team stats
float crmod_teamra1;            // team 1 red armor pickups
float crmod_teamya1;            // team 1 yellow armor pickups
float crmod_teamga1;            // team 1 green armor pickups
float crmod_teamquad1;          // team 1 quad pickups
float crmod_teampent1;          // team 1 pentagram pickups
float crmod_teameyes1;          // team 1 eyes pickups
float crmod_teammega1;          // team 1 mega health pickups
float crmod_teamrl1;            // team 1 rocket launcher pickups
float crmod_teamlg1;            // team 1 lightning gun pickups
float crmod_teamgl1;            // team 1 grenade launcher pickups
float crmod_teamsn1;            // team 1 super nailgun pickups
float crmod_teamng1;            // team 1 nailgun pickups
float crmod_teamss1;            // team 1 super shotgun pickups
float crmod_teamquad2;          // team 2 quad pickups
float crmod_teampent2;          // team 2 pentagram pickups
float crmod_teameyes2;          // team 2 eyes pickups
float crmod_teammega2;          // team 2 mega health pickups
float crmod_teamrl2;            // team 2 rocket launcher pickups
float crmod_teamlg2;            // team 2 lightning gun pickups
float crmod_teamgl2;            // team 2 grenade launcher pickups
float crmod_teamsn2;            // team 2 super nailgun pickups
float crmod_teamng2;            // team 2 nailgun pickups
float crmod_teamss2;            // team 2 super shotgun pickups
float crmod_teamra2;            // team 2 red armor pickups
float crmod_teamya2;            // team 2 yellow armor pickups
float crmod_teamga2;            // team 2 green armor pickups

// auto parameters
float auto_parm1;	// activity bonus factor (default 20)
float auto_parm2;	// proximity bonus for cameras (default 100)
float auto_parm3;	// proximity factor for players (default 10)
float auto_parm4;	// chasetarget hysteresis (default 100)

// other global variables
string nextmap;  // moved here from client.qc
float timelimit; // this used to be local in CheckRules in Client.qc
float fraglimit; // this used to be local in CheckRules in Client.qc

entity crmod_best_chase_target; // calculated every second who is the best target to chase // CRMOD - auto
entity crmod_best_camera;       // set after each camera's think

// client variables
.vector crmod_qdwep;  // vector to keep track of quad weapon stats	// CRMOD - stats
.vector crmod_qdkill; // vector to keep track of quad kill stats	// CRMOD - stats
.entity crmod_othertarget; // entity to focus on in tourneycam		// CRMOD - tourneycam
.entity crmod_inflicted;   // stores entity last attacked			// CRMOD - combat
.float crmod_chase_score;  // same as above, also used by cameras
.float crmod_did_damage;   // last time person did damage
.float crmod_lastkill;     // last kill time
.float oflags;				// CRMOD observer flags
.float crmod_cam_delay;    // keep autocam from overswitching
.vector crmod_oldangle;    // set by angles_fixangle
.float delayed_impulse;		// saves self.impulse so it doesn't get nuked by a ping
.vector scoreboard;			// records which scoreboard slots are used by teamscores

float CRMOD_ANGLE_SMOOTHING = 0.6; // CRMOD use this instead of typing the number a billion times
