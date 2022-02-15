//
// match.qc
//
// This file contains code for the elohim server match (tournament) mode.
//
// Fields used:
//
// .height          - used to store player team
//
// In elohim_match_timer:
//
// lip - minutes left
// count - seconds left
//
// All code by J.P. Grossman unless otherwise commented.
//

// Function declarations
void () SUB_regen;
void () GibPlayer;
void () respawn;
void () match_timer_think2;
void () match_enter_ghost_code;
void (entity ghostent) match_restore_ghost;
void () admin_disable_item;
void () console_show_score;

//
//  S H O W  T I M E L I M I T
//
//  Set the console variable 'timelimit' to show relevant match
//  information.
//
void () match_show_timelimit =
{
	local string temp;

	localcmd("timelimit \"");
	if (!(elohim_state & ELOHIM_TIMER_STARTED))
	{
		if (elohim_state & ELOHIM_MATCH_OVER)
		{
			localcmd("Final Score is ");
			temp = ftos(elohim_teamfrags1);
			if (elohim_teamfrags1 < 0)
				localcmd("<");
			localcmd(temp);
			if (elohim_teamfrags1 < 0)
				localcmd(">");
			localcmd(" - ");
			temp = ftos(elohim_teamfrags2);
			if (elohim_teamfrags2 < 0)
				localcmd("<");
			localcmd(temp);
			if (elohim_teamfrags2 < 0)
				localcmd(">");
			localcmd("\"\n");
		}
		else
		{
			temp = ftos(elohim_timelimit);
			localcmd2(temp, " : Waiting for teams\"\n");
		}
	}
	else if (!(elohim_state & ELOHIM_MATCH_STARTED))
	{
		temp = ftos(elohim_timelimit);
		localcmd2(temp, " : Match Starting\"\n");
	}
	else
	{
		temp = ftos(elohim_match_timer.lip);
		localcmd2(temp, "\"\n");
	}
};

//
//  I T E M  R E S E T
//
//  Prevent an item from respawning.
//
void () match_item_reset =
{
	self.nextthink = -1;
};

//
//  I N I T  P L A Y E R
//
//  Initialize a player in match mode and make him an observer.
//
void () match_init_player =
{
	self.style = self.style - (self.style & ELOHIM_READY);
	self.finaldest_x = time; // So we don't get autokickedd!!
	observer_start();
};

//
//  U N R E A D Y  P L A Y E R
//
void () match_unready_player =
{
	self.style = self.style - (self.style & ELOHIM_READY);
};

//
//  R E S E T
//
void () match_reset =
{
	elohim_team1 = 0;
	elohim_team2 = 0;
	elohim_teamsize1 = 0;
	elohim_teamsize2 = 0;

	elohim_state = elohim_state - (elohim_state & ELOHIM_MATCH_WAIT);

	// prevent items from respawning
	utils_do_items(match_item_reset);

	// remove all backpacks
	utils_do_item(SUB_Remove, "item_backpack");

	// unready all players
	utils_do_players(match_unready_player);

	// remove all ghosts
	utils_do_item(SUB_Remove, "elohim_ghost");

	bprint("No teams present\n");

	if (self.classname == "elohim_match_timer")
		remove(self);
};

//
//  G I B  P L A Y E R
//
//  Gib players; set observers to colour 0.  Called at start
//  and end of match.
//
void () match_gib_player =
{
	if (self.style & ELOHIM_OBSERVER)
		stuffcmd(self, "color 0\n");
	else if (!(self.style & ELOHIM_READY))
		observer_start();
	else
	{
		self.health = -99;
		GibPlayer();
		self.deadflag = DEAD_DYING;
		self.think = respawn;
		self.nextthink = time + 1;
		if (elohim_state & ELOHIM_MATCH_STARTED)
		{
			// start of match
			self.frags = 0;
			stats_reset();
		}
		else
		{
			// end of match
			self.owner = world;
		}
	}
};

//
//  B P R I N T  S C O R E
//
void () match_bprint_score =
{
	local string score;
	local string teamname;
	local string temp;

	teamname = strings_get_teamname(elohim_team1);
	score = ftos(elohim_teamfrags1);
	temp = strings_szplural(elohim_teamfrags1);
	bprint6("The ", teamname, " has ", score, " frag", temp);
	teamname = strings_get_teamname(elohim_team2);
	score = ftos(elohim_teamfrags2);
	temp = strings_szplural(elohim_teamfrags2);
	bprint6("The ", teamname, " has ", score, " frag", temp);
};

//
//  M A T C H  B P R I N T  T I M E
//
void () match_bprint_time =
{
	local string temp;

	temp = ftos(elohim_match_timer.lip);
	bprint3("Time remaining:  ", temp, ":");
	temp = ftos(elohim_match_timer.count);
	if (elohim_match_timer.count < 10)
		bprint("0");
	bprint2(temp, "\n");
};

//
//  S P R I N T  S T A T U S
//
//  Print the time remaining and the score.
//
void () match_sprint_status =
{
	local float team1, team2;
	local string temp;

	if (elohim_state & ELOHIM_MATCH_STARTED)
	{
		team1 = elohim_team1;
		team2 = elohim_team2;
	}
	else
	{
		if (elohim_state & ELOHIM_MATCH_OVER)
		{
			team1 = elohim_lastteam1;
			team2 = elohim_lastteam2;
		}
		else
		{
			sprint(self, "Match has not started yet\n");
			return;
		}
	}

	if (elohim_state & ELOHIM_MATCH_OVER)
		sprint(self, "Match over\n");
	else
	{
		temp = ftos(elohim_match_timer.lip);
		sprint3(self, "Time remaining:  ", temp, ":");
		temp = ftos(elohim_match_timer.count);
		if (elohim_match_timer.count < 10)
			sprint(self, "0");
		sprint2(self, temp, "\n");
	}

	local string score;
	local string teamname;

	teamname = strings_get_teamname(team1);
	score = ftos(elohim_teamfrags1);
	temp = strings_szplural(elohim_teamfrags1);
	sprint6(self, "The ", teamname, " has ", score, " frag", temp);
	teamname = strings_get_teamname(team2);
	score = ftos(elohim_teamfrags2);
	temp = strings_szplural(elohim_teamfrags2);
	sprint6(self, "The ", teamname, " has ", score, " frag", temp);
};

//
//  E N D
//
//  Called to end the match when the timer runs out or an administrator
//  aborts the match.
//
void () match_end =
{
	local string teamname;

	if (self.classname == "elohim_match_timer")
	{
		// Regular match end (timer ran out)
		if ((elohim_teamfrags1 == elohim_teamfrags2) && elohim_overtime)
		{
			// go into overtime
			bprint("Match tied - Overtime!!\n");
			self.lip = elohim_overtime;
			self.count = 0;
			self.think = match_timer_think2;
			match_timer_think2();
			return;
		}
	}
	else
	{
		// Administrator aborted the match
		if (!(elohim_state & ELOHIM_MATCH_STARTED))
			return;

		if (elohim_state & ELOHIM_MATCH_PAUSED) // if administrator aborts match
		{
			WriteByte(MSG_ALL, SVC_CENTERPRINT);
			WriteShort(MSG_ALL,1);
			WriteString(MSG_ALL, " ");
			elohim_state = elohim_state - ELOHIM_MATCH_PAUSED;
		}
	}

	elohim_state = elohim_state - ELOHIM_MATCH_STARTED;
	elohim_state = elohim_state - ELOHIM_TIMER_STARTED;
	elohim_state = elohim_state | ELOHIM_MATCH_OVER | ELOHIM_MATCH_WAIT;
	utils_do_players(match_gib_player);
	match_show_timelimit();
	bprint("The match is over\n");
	match_bprint_score();
	teamname = strings_get_teamname(elohim_winning_team);

	if (elohim_teamfrags1 == elohim_teamfrags2)
		bprint("Tie game!\n");
	else
		bprint3("The ", teamname, " has won\n");

	// remember teams so that 'score' will continue to work
	elohim_lastteam1 = elohim_team1;
	elohim_lastteam2 = elohim_team2;
	console_show_score();

	elohim_match_timer.think = match_reset;
	elohim_match_timer.nextthink = time + 5;

	score_update_time();

	// Dump statistics for anyone who has autostats set
	utils_do_players(stats_autodump);
};

//
//  T I M E R  T H I N K 2
//
//  Match timer think function.
//
//  self.count gives the number of seconds remaining in the match.
//
void () match_timer_think2 =
{
	local string temp;

	self.count = self.count - 1;
	if (self.count < 0)
	{
		self.count = 59;
		self.lip = self.lip - 1;
	}
	self.nextthink = time + 1;

	score_update_time();

	if (self.lip)
	{
		if (self.count)
				return;
		if (self.lip > 1)
		{
			temp = ftos(self.lip);
			match_show_timelimit();
			bprint3("Match ends in ", temp, " minutes\n");
			if (self.lip == 5 * floor(self.lip / 5))
				match_bprint_score();
		}
		else
		{
			match_show_timelimit();
			bprint("Match ends in 1 minute\n");
			match_bprint_score();
		}
	}
	else if (self.count == 30)
	{
		bprint("Match ends in 30 seconds\n");
		if (elohim_overtime)
		{
			temp = ftos(elohim_overtime);
			bprint2(temp, " minute overtime in case of tie\n");
		}
	}
	else if (self.count > 10)
		return;
	else if (self.count > 1)
	{
		if (self.count == 10)
			bprint("Match ends in T minus\n");
		temp = ftos(self.count);
		bprint3("  ", temp, " seconds\n");
	}
	else
	{
		bprint("  1 second\n");
		self.think = match_end;
	}
};

//
//  A D D  S P A W N
//
//  Turn this extra start point into a spawn point for the match start
//
void () match_add_spawn =
{
	self.mdl = "elohim_start_point";
	self.classname = "info_player_deathmatch";
};

//
//  R E M O V E  S T A R T
//
//  Turn this extra start point back into a start point 2 seconds into
//  the match.
//
void () match_remove_start =
{
	if (self.mdl == "elohim_start_point")
		self.classname = self.mdl;
};

//
//  R E M O V E  S T A R T S
//
//  2 seconds into the match all start points revert to start points.
//
void () match_remove_starts =
{
	utils_do_item(match_remove_start, "info_player_deathmatch");
	elohim_num_spawns = elohim_num_spawns - elohim_num_starts;
};

//
//  B E G I N
//
//  Gib all players and start the match.
//
void () match_begin =
{
	local string temp;

	elohim_state = elohim_state | ELOHIM_MATCH_STARTED;
	utils_do_players(match_gib_player);

	// Set the team size so that unwanted A-holes can't join in
	elohim_maxsize = utils_max(elohim_teamsize1, elohim_teamsize2);
	temp = ftos(elohim_maxsize);
	bprint5("Match is ", temp, "v", temp, "\n");

	temp = ftos(elohim_timelimit);
	bprint2(temp, " minutes remaining\n");

	self.think = match_timer_think2;
	self.nextthink = time + 1;
	self.lip = elohim_timelimit;
	self.count = 0;
	match_show_timelimit();

	// Temporarily turn the extra start points into spawn points if necessary
	if (elohim_teamsize1 + elohim_teamsize2 > elohim_num_spawns)
	{
		utils_do_item(match_add_spawn, "elohim_start_point");
		elohim_num_spawns = elohim_num_spawns + elohim_num_starts;
		utils_make_scheduled_event(match_remove_starts, 2);
	}

	// Reset team match stats
	stats_reset_team();

	// Initialize the score module
	score_init();
};

//
//  T I M E R  T H I N K 1
//
//  Pre-match timer think function.
//
//  self.count gives the number of seconds until the match begins.
//
void () match_timer_think1 =
{
	local string temp;

	if (self.count == 20)
	{

		elohim_maxsize = utils_max(elohim_teamsize1, elohim_teamsize2);
		temp = ftos(elohim_maxsize);
		bprint5("Match is currently ", temp, "v", temp, "\n");
		bprint("Match begins in 20 seconds\n");

		self.count = 10;
		self.nextthink = time + 10;


	}
	else if (self.count == 15)
	{
	// respawn all items
		utils_do_items(SUB_regen);
		if (elohim_playmode & ELOHIM_NO_QUAD)
			utils_do_item(admin_disable_item, "item_artifact_super_damage");
		if (elohim_playmode & ELOHIM_NO_PENT)
			utils_do_item(admin_disable_item, "item_artifact_invulnerability");
		if (elohim_playmode & ELOHIM_NO_RING)
			utils_do_item(admin_disable_item, "item_artifact_invisibility");

		bprint("All items have respawned\n");
		bprint("Match begins in 15 seconds\n");

		self.count = 10;
		self.nextthink = time + 5;
	}
	else if (self.count > 1)
	{
		if (self.count == 10)
			bprint("Match begins in T minus\n");
		temp = ftos(self.count);
		bprint3("  ", temp, " seconds\n");
		self.count = self.count - 1;
		self.nextthink = time + 1;
	}
	else
	{
		bprint("  1 second\n");
		self.think = match_begin;
		self.nextthink = time + 1;
	}
};

//
//  P U T  P L A Y E R  I N  T E A M
//
//  Try to put a player into the team that he has chosen.  Called
//  when a player enters 'ready' in the console.  Returns TRUE if
//  successful, FALSE otherwise.
//
float () match_put_player_in_team =
{
	local string teamname;
	local float create;

	if (self.team == 1)
	{
		sprint(self, "Invalid pants color\n");
		return FALSE;
	}

	self.height = self.team - 1;
	create = 0;

	if (!elohim_team1)
	{
		// Create team1
		elohim_team1 = self.height;
		elohim_teamsize1 = 1;
		create = 1;
	}
	else if (elohim_team1 == self.height)
	{
		// Add to team1 if possible
		if ((elohim_state & ELOHIM_MATCH_STARTED) &&
			(elohim_teamsize1 == elohim_maxsize))
		{
			sprint(self, "Team full.  Enter 'unlock' in console\n");
			sprint(self, "to request permission to join.\n");
			return FALSE;
		}
		elohim_teamsize1 = elohim_teamsize1 + 1;
	}
	else if (!elohim_team2)
	{
		// Create team2
		elohim_team2 = self.height;
		elohim_teamsize2 = 1;
		create = 2;
	}
	else if (elohim_team2 == self.height)
	{
		// Add to team2 if possible
		if ((elohim_state & ELOHIM_MATCH_STARTED) &&
			(elohim_teamsize2 == elohim_maxsize))
		{
			sprint(self, "Team full.  Administrator or match\n");
			sprint(self, "participant must enter 'unlock' in\n");
			sprint(self, "console to allow you to join.\n");
			return FALSE;
		}
		elohim_teamsize2 = elohim_teamsize2 + 1;
	}
	else
	{
		sprint(self, "There are already 2 teams:\n");
		teamname = strings_get_teamname(elohim_team1);
		sprint(self, teamname);
		teamname = ftos(elohim_team1);
		sprint3(self, " (colour ", teamname, ") and\n");
		teamname = strings_get_teamname(elohim_team2);
		sprint(self, teamname);
		teamname = ftos(elohim_team2);
		sprint3(self, " (colour ", teamname, ")\n");

		return FALSE;
	}

	teamname = strings_get_teamname(self.height);
	if (create)
		bprint2(teamname, " created\n");
	bprint4(self.netname, " has joined the ", teamname, "\n");
	if (!elohim_team2)
		bprint("Only one team present\n");

	return TRUE;
};

//
//  A L L  R E A D Y
//
//  Returns TRUE if all non-observers are ready, FALSE otherwise.
//
float () match_all_ready =
{
	local entity player;

	player = find(world, classname, "player");
	while (player)
	{
		if (!(player.style & (ELOHIM_OBSERVER | ELOHIM_READY)) &&
			(player.style & ELOHIM_CONNECTED))
			return FALSE;
		player = find(player, classname, "player");
	}
	return TRUE;
};

//
//  S T A R T  T I M E R
//
//  Starts the timer.
//
void () match_start_timer =
{
	elohim_match_timer = spawn();
	elohim_match_timer.classname = "elohim_match_timer";
	elohim_match_timer.think = match_timer_think1;
	elohim_match_timer.nextthink = floor(time) + 2;
	//elohim_match_timer.nextthink = time + 30;
	//elohim_match_timer.count = 30;



	elohim_teamfrags1 = 0;
	elohim_teamfrags2 = 0;
	elohim_state = elohim_state | ELOHIM_TIMER_STARTED;
	elohim_state = elohim_state - (elohim_state & ELOHIM_MATCH_OVER);
	match_show_timelimit();
	elohim_match_timer.count = 19;
	bprint("Match begins in 20 seconds\n");
	bprint("Timelimit is ");
	utils_bprint_float(elohim_timelimit);
};

//
//  F I N D  G H O S T
//
//  Finds a ghost from a ghost code; returns world if the ghost doesn't
//  exist.
//
entity (float code) match_find_ghost =
{
	local entity e;

	e = find(world, classname, "elohim_ghost");
	while ((e != world) && (e.count != code))
		e = find(e, classname, "elohim_ghost");
	return e;
};

//
//  M A K E  G H O S T
//
//  Create a ghost for the player (if does not already have one)
//  and tell him what his ghost code is.
//
void () match_make_ghost =
{
	// can't have two ghosts
	if (self.owner)
		remove(self.owner);

	// create ghost code
	local float ghostcode;
	ghostcode = 100 + floor(899.99 * random());
	while (match_find_ghost(ghostcode))
		ghostcode = 100 + floor(899.99 * random());

	// initialize ghost
	self.owner = spawn();
	self.owner.classname = "elohim_ghost";
	self.owner.owner = self;
	self.owner.frags = 0;
	self.owner.height = self.height;
	self.owner.count = ghostcode;

	sprint(self, "Your ghost code is ");
	utils_print_float(self.owner.count);
};

//
//  S H O W  G H O S T  C O D E
//
void () match_show_ghost_code =
{
	if (self.owner)
	{
		sprint(self, "Your ghost code is ");
		utils_print_float(self.owner.count);
	}
	else
		sprint(self, "You do not have a ghost\n");
};

//
//  R E Q U E S T  R E S T O R E  G H O S T
//
//  Request to be restored from a ghost.  The player is prompted
//  to enter his three digit ghost code.
//
void () match_request_restore_ghost =
{
	if (!(elohim_state & ELOHIM_MATCH_STARTED))
	{
		sprint(self, "There is no match in progress\n");
		return;
	}

	// only uncomitted players can ghost themselves
	if (self.style & ELOHIM_READY)
	{
		sprint(self, "You are already in the match\n");
		return;
	}

	sprint(self, "Enter the first ghost code digit:\n");
	self.count = 0;
	self.use = match_enter_ghost_code;
};

//
//  E N T E R  G H O S T  C O D E
//
//  Enter another ghost code digit.  The digit is stored in
//  self.finaldest_z.
//
void () match_enter_ghost_code =
{
	if (self.finaldest_z > 9)
		return;
	self.count = self.count * 10 + self.finaldest_z;
	if (!self.count)
		return;

	if (self.count < 10)
		sprint(self, "Enter the second ghost code digit:\n");
	else if (self.count < 100)
		sprint(self, "Enter the third ghost code digit:\n");
	else
	{
		// ghost code has been entered
		local entity e;

		e = match_find_ghost(self.count);
		if (!e)
			sprint(self, "Ghost not found\n");
		else
		{
			// Check to make sure the client is gone
			if (e.owner.owner == e)
				sprint2(self, e.owner.netname, " owns this ghost\n");
			else
				match_restore_ghost(e);
		}
		self.use = SUB_Null;
	}
};

//
//  R E S T O R E  G H O S T
//
//  Restore a player from their ghost after they've entered their
//  ghost code.  Note that the only way for this function to be
//  called is if there is a match in progress and the player entering
//  the ghostcode is an uncommitted observer.
//
void (entity ghostent) match_restore_ghost =
{
	self.team = ghostent.height + 1;
	if (match_put_player_in_team())
	{
		local string temp;

		// Must ready before observer_end, or will be made observer again
		// Must observer_end before setting frags, or frags will be set to 0
		self.style = self.style | ELOHIM_READY;
		observer_end();
		self.frags = ghostent.frags;
		self.dest = ghostent.dest;
		self.dest1 = ghostent.dest1;
		self.dest2 = ghostent.dest2;
		self.mangle = ghostent.mangle;
		self.owner = ghostent;
		ghostent.owner = self;
		temp = ftos(self.height);
		stuffcmd(self, "color ");
		stuffcmd(self, temp);
		stuffcmd(self, "\n");

		temp = ftos(self.frags);
		bprint4(self.netname, " restored from ghost\nwith ", temp, " frag");
		if (self.frags == 1)
			bprint("\n");
		else
			bprint("s\n");
	}
};

//
//  R E A D Y
//
//  Called when a player enters 'ready' in the console.
//
void () match_ready =
{
	if (elohim_state & ELOHIM_MATCH_WAIT)
	{
		sprint(self, "Try again in 5 seconds\n");
		return;
	}
	if (self.style & ELOHIM_READY)
	{
		sprint(self, "You are already committed\n");
		return;
	}

	// can't commit while entering ghost code
	if (self.use == match_enter_ghost_code)
	{
		sprint(self, "Finish entering the ghost code\n");
		return;
	}

	// Try to add the player; colour him white if unsuccessful
	if (!match_put_player_in_team())
	{
		stuffcmd(self, "color 0\n");
		return;
	}

	self.style = self.style | ELOHIM_READY;

	// check to see if we need to start the timer
	if (elohim_team2 && !(elohim_state & ELOHIM_TIMER_STARTED) && match_all_ready())
		match_start_timer();

	// Give the player a ghost
	match_make_ghost();

	if (self.style & ELOHIM_OBSERVER)
		observer_end();
};

//
//  N O T  R E A D Y
//
//  Called when a player enters 'notready' in the console.
//
void () match_notready =
{
	if (elohim_state & ELOHIM_MATCH_WAIT)
	{
		sprint(self, "Try again in 5 seconds\n");
		return;
	}
	if (!(self.style & ELOHIM_READY))
	{
		sprint(self, "You have not yet committed\n");
		return;
	}
	if (elohim_state & ELOHIM_MATCH_STARTED)
	{
		sprint(self, "Cannot uncommit during match\n");
		sprint(self, "Type 'observer' to leave match\n");
		return;
	}

	self.style = self.style - ELOHIM_READY;
	bprint2(self.netname, " is not ready\n");

	// He was ready but the match hadn't started, so remove his ghost
	remove(self.owner);
	self.owner = world;

	// Remove from team
	if (self.height == elohim_team1)
	{
		elohim_teamsize1 = elohim_teamsize1 - 1;
		if (!elohim_teamsize1)
		{
			// Team 1 is now empty - remove it
			elohim_team1 = elohim_team2;
			elohim_teamsize1 = elohim_teamsize2;
			if (elohim_team1)
			{
				elohim_team2 = 0;
				elohim_teamsize2 = 0;
				bprint("Only one team present\n");
			}
			else
				bprint("No teams present\n");
		}
	}
	else
	{
		elohim_teamsize2 = elohim_teamsize2 - 1;
		if (!elohim_teamsize2)
		{
			// Team 2 is now empty - remove it.  Since the player was
			// just in team 2 and it is never the case that team 1 is
			// empty when team 2 is not, we know that team 1 must
			// exist.
			elohim_team2 = 0;
			bprint("Only one team present\n");
		}
	}

	if (elohim_state & ELOHIM_TIMER_STARTED)
	{
		bprint("Timer stopped\n");
		remove(elohim_match_timer);
		elohim_state = elohim_state - ELOHIM_TIMER_STARTED;
		match_show_timelimit();
	}
};

//
//  U N L O C K
//
//  Allow new players to joing the match.
//
void () match_unlock =
{
	elohim_maxsize = 16;
	bprint("Match has been unlocked\n");
	bprint("New players may join at will\n");
};

//
//  R E Q U E S T  U N L O C K
//
//  Request to allow new players to join the match.
//
void () match_request_unlock =
{
	if (!(elohim_state & ELOHIM_MATCH_STARTED))
	{
		sprint(self, "No match in progress\n");
		return;
	}
	if (elohim_maxsize == 16)
	{
		sprint(self, "Match is already unlocked\n");
		return;
	}

	// Do it right away if we're an administrator, otherwise vote
	if (self.style & ELOHIM_ADMINISTRATOR)
		match_unlock();
	else if (self.style & ELOHIM_READY)
	{
		if (vote_init("allow new players to join", "", match_unlock))
			vote_yes();
	}
	else
	{
		sprint(self, "unlock comand available to match\n");
		sprint(self, "participants and administrators only\n");
   }
};

//
//  L O C K
//
//  Re-cap the team size.
//
void () match_lock =
{
	elohim_maxsize = utils_max(elohim_teamsize1, elohim_teamsize2);

	bprint("Match has been locked\n");
	bprint("Max teamsize set to ");
	utils_bprint_float(elohim_maxsize);
};

//
//  R E Q E S T  L O C K
//
//  Request to re-cap the team size.
//
void () match_request_lock =
{
	if (!(elohim_state & ELOHIM_MATCH_STARTED))
	{
		sprint(self, "No match in progress\n");
		return;
	}
	if (elohim_maxsize == utils_max(elohim_teamsize1, elohim_teamsize2))
	{
		sprint(self, "Match is already locked\n");
		return;
	}

	// Do it right away if we're an administrator, otherwise vote
	if (self.style & ELOHIM_ADMINISTRATOR)
		match_lock();
	else if (self.style & ELOHIM_READY)
	{
		if (vote_init("lock the match", "", match_lock))
			vote_yes();
	}
	else
	{
		sprint(self, "lock comand available to match\n");
		sprint(self, "participants and administrators only\n");
   }
};

//
//  H E L P
//
void () match_help =
{
	sprint(self, "Match commands (for match mode only):\n");
	sprint(self, " timelimitØØ - change timelimit\n");
	sprint(self, "         (ØØ = 5, 10, 15, 20, 25, 30)\n");
	sprint(self, " ready    - commit to a team\n");
	sprint(self, " notready - uncommit yourself\n");
	sprint(self, " ready?   - find out who is not ready\n");
	sprint(self, " unlock   - allow new players to join\n");
	sprint(self, " lock     - re-cap the team size\n");
	sprint(self, " timerstop  - pause the match\n");
	sprint(self, " timerstart - start/restart the timer\n");
	sprint(self, " ghostcode  - view your ghost code\n");
	sprint(self, " ghost - restore yourself from ghost\n");
	sprint(self, " score - show time left and score\n");
	sprint(self, " +teamscores - bind this to a key\n");
};

//
//  S H O W  N O T  R E A D Y
//
//  Prints a list of players who are not ready.
//
void () match_show_not_ready =
{
	if (match_all_ready())
	{
		if (!elohim_team1)
			sprint(self, "No teams present\n");
		else
		{
			sprint(self, "All players are ready\n");
			if (!elohim_team2)
				sprint(self, "Only one team present\n");
		}
	}
	else
	{
		local entity player;

		// Name and shame with broadcast print to all players
		bprint("The following players are not ready:\n");

		player = find(world, classname, "player");
		while (player)
		{
			if (!(player.style & (ELOHIM_OBSERVER | ELOHIM_READY)) &&
				(player.style & ELOHIM_CONNECTED))
				bprint3(" ", player.netname, "\n");
			player = find(player, classname, "player");
		}
	}
};

//
//  P A U S E  I T E M
//
void () match_pause_item =
{
	self.nextthink = self.nextthink + 1000000;
};

//
//  S H O W  P A U S E
//
//  Centerprint "Paused" to all clients.
//
void () match_show_pause =
{
	WriteByte(MSG_ALL, SVC_CENTERPRINT);
	WriteShort(MSG_ALL,1);
	WriteByte(MSG_ALL, 1);
	WriteByte(MSG_ALL, 2);
	WriteByte(MSG_ALL, 2);
	WriteByte(MSG_ALL, 2);
	WriteByte(MSG_ALL, 2);
	WriteByte(MSG_ALL, 2);
	WriteByte(MSG_ALL, 2);
	WriteByte(MSG_ALL, 3);
	WriteString(MSG_ALL, "\n„ÐÁÕÓÅÄ†\n‡ˆˆˆˆˆˆ‰");
	elohim_match_timer.nextthink = time + 0.5;
	elohim_match_timer.think = match_show_pause;
};

//
//  P A U S E
//
//  Called after the request to pause has passed.
//
void () match_pause =
{
	elohim_state = elohim_state | ELOHIM_MATCH_PAUSED;
	elohim_match_pause_time = time;
	utils_do_items(match_pause_item);
	bprint("Match paused\n");
	match_bprint_time();
	match_bprint_score();
	elohim_match_timer.think1 = elohim_match_timer.think;
	elohim_match_timer.cnt = elohim_match_timer.nextthink;
	match_show_pause();
};

//
//  R E Q U E S T  P A U S E
//
void () match_request_pause =
{
	if (!(elohim_state & ELOHIM_MATCH_STARTED))
	{
		sprint(self, "No match in progress\n");
		return;
	}
	if (elohim_state & ELOHIM_MATCH_PAUSED)
	{
		sprint(self, "Match is already paused\n");
		return;
	}

	// Do it right away if we're an administrator, otherwise vote
	if (self.style & ELOHIM_ADMINISTRATOR)
		match_pause();
	else if (vote_init("pause the match", (""), match_pause))
		vote_yes();
};

//
//  U N P A U S E  I T E M
//
void () match_unpause_item =
{
	self.nextthink = self.nextthink - 1000000 + elohim_match_pause_time;
};

//
//  U N P A U S E  P L A Y E R
//
void () match_unpause_player =
{
	if (self.super_damage_finished)
		self.super_damage_finished = self.super_damage_finished +
									 elohim_match_pause_time;
	if (self.invisible_finished)
		self.invisible_finished = self.invisible_finished +
								  elohim_match_pause_time;
	if (self.invincible_finished)
		self.invincible_finished = self.invincible_finished +
								   elohim_match_pause_time;
	if (self.radsuit_finished)
		self.radsuit_finished = self.radsuit_finished +
								elohim_match_pause_time;
	self.air_finished = self.air_finished + elohim_match_pause_time;
	self.pain_finished = self.pain_finished + elohim_match_pause_time;
};

//
//  U N P A U S E
//
//  Called after the request to unpause has passed.
//
void () match_unpause =
{
	elohim_state = elohim_state - ELOHIM_MATCH_PAUSED;
	elohim_match_pause_time = time - elohim_match_pause_time;
	utils_do_items(match_unpause_item);
	utils_do_players(match_unpause_player);
	bprint("Match unpaused\n");
	match_bprint_time();
	match_bprint_score();
	elohim_match_timer.nextthink = elohim_match_timer.cnt + elohim_match_pause_time;
	elohim_match_timer.think = elohim_match_timer.think1;
	WriteByte(MSG_ALL, SVC_CENTERPRINT);
	WriteShort(MSG_ALL,1);
	WriteString(MSG_ALL, " ");
};

//
//  R E Q U E S T  U N P A U S E
//
//  Request to start/restart the timer
//
void () match_request_unpause =
{
	if (!(elohim_state & ELOHIM_MATCH_STARTED))
	{
		if (elohim_state & ELOHIM_TIMER_STARTED)
		{
			sprint(self, "Timer has already started\n");
			return;
		}
		if (!elohim_team2)
		{
			if (!elohim_team1)
				sprint(self, "There are no teams present\n");
			else
				sprint(self, "There is only one team present\n");
			// Disabling this line allows match dev testing with only one team present :)
			return;
		}
		// request to force the timer to start.
		// Do it right away if we're an administrator, otherwise vote
		if (self.style & ELOHIM_ADMINISTRATOR)
			match_start_timer();
		else if (vote_init("start the timer", "", match_start_timer))
			vote_yes();
		return;
	}
	if (!(elohim_state & ELOHIM_MATCH_PAUSED))
	{
		sprint(self, "Match is not paused\n");
		return;
	}

	// Do it right away if we're an administrator, otherwise vote
	if (self.style & ELOHIM_ADMINISTRATOR)
		match_unpause();
	else if (vote_init("unpause the match", "", match_unpause))
		vote_yes();
};

//
//  I M P U L S E
//
void () match_impulse =
{
	if (self.impulse == 129)
		match_help();
	else if (self.impulse == 128)
		match_sprint_status();

	if (!(elohim_playmode & ELOHIM_MATCH_MODE))
	{
		if (self.impulse == 120  || self.impulse == 225)
		{
			if (self.style & ELOHIM_OBSERVER)
				observer_end();
			else
				sprint(self, "You are not an obseraver\n");
		}
		else
			sprint(self, "Command valid in match mode only\n");
		return;
	}

	if (self.impulse == 120 || self.impulse == 225)
		match_ready();
	else if (self.impulse == 121)
		match_notready();
	else if (self.impulse == 122)
		match_request_unlock();
	else if (self.impulse == 123)
		match_show_not_ready();
	else if (self.impulse == 124)
		match_request_pause();
	else if (self.impulse == 125)
		match_request_unpause();
	else if (self.impulse == 126)
		match_show_ghost_code();
	else if (self.impulse == 127)
		match_request_restore_ghost();
	else if (self.impulse == 130)
		match_request_lock();
	else if (self.impulse == 131)
		score_show_teamscores();
	else if (self.impulse == 132)
		score_restore_scoreboard();
};

//
//  V E R I F Y  T E A M
//
//  Called every frame to verify that a committed player hasn't tried
//  to change colour.
//
void (entity player) match_verify_team =
{
	if (!(elohim_playmode & ELOHIM_MATCH_MODE))
		return;

	if (!(player.style & ELOHIM_READY))
		return;

	if (player.height != player.team - 1)
	{
		local string temp;
		temp = ftos(player.height);
		stuffcmd(player, "color ");
		stuffcmd(player, temp);
		stuffcmd(player, "\n");
		player.team = player.height + 1;

		sprint(player, "You cannot change color after\n");
		sprint(player, "you have committed\n");
	}
};

//
//  D I S C O N N E C T  N O T I F Y
//
//  Called when a player disconnects from the server or enters
//  observer mode.
//
void (entity player) match_disconnect_notify =
{
	if (!(player.style & ELOHIM_READY))
	{
		// Check to see if we need to start the timer
		if (!(elohim_state & ELOHIM_MATCH_WAIT))
		{
			if (!(elohim_state & ELOHIM_TIMER_STARTED))
			{
				if (elohim_team2)
				{
					if (match_all_ready())
						match_start_timer();
				}
			}
		}
		return;
	}

	player.style = player.style - ELOHIM_READY;

	// Remove the player from the appropriate team
	if (player.height == elohim_team1)
		elohim_teamsize1 = elohim_teamsize1 - 1;
	else
		elohim_teamsize2 = elohim_teamsize2 - 1;

	// Copy his info to his ghost
	if (self.owner)
	{
		self.owner.frags = self.frags;
		self.owner.dest = self.dest;
		self.owner.dest1 = self.dest1;
		self.owner.dest2 = self.dest2;
		self.owner.mangle = self.mangle;
	}

	// Check to see if we need to stop the match
	if (elohim_state & ELOHIM_MATCH_STARTED)
	{
		// if he's turned himself into an observer, then get rid of his
		// ghost
		if (self.style & ELOHIM_OBSERVER)
		{
			if (self.owner)
				remove(self.owner);
			else  // Sanity check added 5/15/98
				cprint("Internal error #1.  Please send mail to crbug@mpog.com\n");
		}
		self.owner = world;

		if (!elohim_teamsize1 && !elohim_teamsize2)
		{
			match_reset();
			bprint("Match aborted\n");
			remove(elohim_match_timer);
			elohim_state = elohim_state - (elohim_state & ELOHIM_MATCH_PAUSED);
			elohim_state = elohim_state - ELOHIM_TIMER_STARTED;
			elohim_state = elohim_state - ELOHIM_MATCH_STARTED;
			match_show_timelimit();
		}
		return;
	}

	// JP - 5/15/98
	// Bug fix for players falling out of map.
	// For the 5 seconds after a match ends, players are "ready" but they
	// have no ghost.  So let's return before we remove world, okay? :p
	// That's what was causing it!
	if (elohim_state & ELOHIM_MATCH_WAIT)
		return;

	// He was ready but the match hadn't started, so remove his ghost
	if (self.owner)
		remove(self.owner);
	else  // Sanity check added 5/15/98
		cprint("Internal error #2.  Please send mail to crbug@mpog.com\n");
	self.owner = world;

	// Check for empty team1
	if (!elohim_teamsize1)
	{
		elohim_team1 = elohim_team2;
		elohim_teamsize1 = elohim_teamsize2;
		elohim_team2 = 0;
		elohim_teamsize2 = 0;
	}

	// Check for empty team2
	if (!elohim_teamsize2)
		elohim_team2 = 0;

	// Check to see if we need to stop the timer
	if ((elohim_state & ELOHIM_TIMER_STARTED) && !elohim_team2)
	{
		bprint("Only one team present\n");
		bprint("Timer stopped\n");
		remove(elohim_match_timer);
		elohim_state = elohim_state - ELOHIM_TIMER_STARTED;
		match_show_timelimit();
	}

	if (!elohim_team1)
		bprint("No teams present\n");
};
