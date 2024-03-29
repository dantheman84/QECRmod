// Update player HUD with match timer, current score, weapon and ammo count info
void hud_update() =
{
	// Calculate time values for display
	local float cur_sec;
	local float cur_min;

	// Print different timer values based on what's interesting
	if (elohim_playmode & ELOHIM_MATCH_MODE)
	{
		if (elohim_state & ELOHIM_MATCH_OVER)
		{
			cur_sec = 0;
			cur_min = 0;
		}
		else
		{
			cur_sec = elohim_match_timer.count;
			cur_min = elohim_match_timer.lip;
			// Handle weird between-match cases
			if (cur_sec > 59)
			{
				cur_sec = 0;
			}
		}
	}
	else if (timelimit != 0)
	{
		cur_sec = floor(timelimit - time) % 60;
		cur_min = floor(floor(timelimit - time) / 60);
	}
	else
	{
		cur_sec = floor(time) % 60;
		cur_min = floor(floor(time) / 60);
	}

	// Team scores if a match is in progress
	local float my_team_score;
	local float their_team_score;

	// Always print my team's score on the left
	if (self.height == elohim_team2)
	{
		my_team_score = elohim_teamfrags2;
		their_team_score = elohim_teamfrags1;
	}
	else
	{
		my_team_score = elohim_teamfrags1;
		their_team_score = elohim_teamfrags2;
	}

	// If headsup is off, just print a match timer
	if (!(self.style & ELOHIM_HEADS_UP))
	{
		local string cur_min_pad;
		if (cur_min < 10)
		{
			cur_min_pad = "  ";
		}
		else if (cur_min < 100)
		{
			cur_min_pad = " ";
		}
		else // >= 100
		{
			cur_min_pad = "";
		}

		local string cur_sec_pad;
		if (cur_sec < 10)
		{
			// Leading zero on seconds
			cur_sec_pad = "0";
		}
		else // >= 100
		{
			cur_sec_pad = "";
		}

		centerprint7(self,
		"\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n",
		cur_min_pad,ftos(cur_min),":",cur_sec_pad,ftos(cur_sec),
		"                                            \n");
		// Return for non-headsup mode (non-QE clients)
		return;
	}

	// QE clients (or those that can handle QE-style centerprints) only from here!

	// Reminder: centerprint can do 7 strings, 40 lines, 50 characters wide
	msg_entity = self;
	WriteByte (MSG_ONE, SVC_CENTERPRINT);

	// 1 base(?) + 1 format string + 96 format parameters
	WriteShort (MSG_ONE, 108); // QE reserved

	// Print newlines to push hud to bottom of screen
	local float newlines = 0;
	local float i;
	for(i = 0; i < newlines; i = i + 1)
	{
		WriteByte (MSG_ONE, '\n');
	}

	// Write format string
	WriteString(MSG_ONE,
		// Team names for match observer mode
		"{}                                  {}\n"
		// Team item stats for match observer mode
		"{}{}{}{}{}                                    {}{}{}{}{}\n"
		"{}{}{}{}{}                                    {}{}{}{}{}\n"
		"{}{}{}{}{}                                    {}{}{}{}{}\n"
		"{}{}{}{}{}                                    {}{}{}{}{}\n"
		"\n"
		// Item timers for observer mode
		"                                           {}{}{}{}{}\n"
		"                                           {}{}{}{}{}\n"
		"                                           {}{}{}{}{}\n"
		"                                           {}{}{}{}{}\n"
		"                                           {}{}{}{}{}\n"
		"                                           {}{}{}{}{}\n"
		"                                           {}{}{}{}{}\n"
		"                                           {}{}{}{}{}\n"
		// Target name for observer mode
		"{}\n"
		// Player name for observer mode
		"{}\n"
		// Timer
		"\x10  {}{}:{}{}\x11                                        \n"
		// Frags
		"\x10{}{}{}{}{}\x11                                        \n"
		// 10-character Team name, Cells
		"{}                                 {}\x10{}{}\x11\n"
		// Rockets
		"                                           {}\x10{}{}\x11\n"
		// Nails
		"                                           {}\x10{}{}\x11\n"
		// Shells
		"                                           {}\x10{}{}\x11\n"
	);

	local entity item;
	local float item_slots;
	local float item_count;
	local float item_time;
	local float teams_printed;

	item_slots = 4;
	item_count = 0;

	/* Only print team item stats in observer HUD when in match mode */
	if ((self.style & ELOHIM_OBSERVER) && (elohim_playmode & ELOHIM_MATCH_MODE))
	{
		/* Team names */
		WriteString(MSG_ONE, strings_get_teamname4_bronze(elohim_team1));
		WriteString(MSG_ONE, strings_get_teamname4_bronze(elohim_team2));
		teams_printed = 1;

		/* Quad pickup counts */
		item = find(world, classname, "item_artifact_super_damage");
		if (item && (item_count < item_slots) && !(elohim_playmode & ELOHIM_NO_QUAD)){
			WriteString(MSG_ONE, " \sq");
			WriteString(MSG_ONE, "\x10");
			if (crmod_teamquad1 < 10)
			{
				WriteString(MSG_ONE, "  ");
			}
			else if (crmod_teamquad1 < 100)
			{
				WriteString(MSG_ONE, " ");
			}
			else // >= 100
			{
				WriteString(MSG_ONE, "");
			}
			WriteString(MSG_ONE, ftos(crmod_teamquad1));
			WriteString(MSG_ONE, "\x11");

			WriteString(MSG_ONE, " \sq");
			WriteString(MSG_ONE, "\x10");
			if (crmod_teamquad2 < 10)
			{
				WriteString(MSG_ONE, "  ");
			}
			else if (crmod_teamquad2 < 100)
			{
				WriteString(MSG_ONE, " ");
			}
			else // >= 100
			{
				WriteString(MSG_ONE, "");
			}
			WriteString(MSG_ONE, ftos(crmod_teamquad2));
			WriteString(MSG_ONE, "\x11");

			item_count = item_count + 1;
		}

		/* Red Armor pickup counts */
		item = find(world, classname, "item_armorInv");
		if (item && (item_count < item_slots))
		{
			WriteString(MSG_ONE, "\sra");
			WriteString(MSG_ONE, "\x10");
			if (crmod_teamra1 < 10)
			{
				WriteString(MSG_ONE, "  ");
			}
			else if (crmod_teamra1 < 100)
			{
				WriteString(MSG_ONE, " ");
			}
			else // >= 100
			{
				WriteString(MSG_ONE, "");
			}
			WriteString(MSG_ONE, ftos(crmod_teamra1));
			WriteString(MSG_ONE, "\x11");

			WriteString(MSG_ONE, "\sra");
			WriteString(MSG_ONE, "\x10");
			if (crmod_teamra2 < 10)
			{
				WriteString(MSG_ONE, "  ");
			}
			else if (crmod_teamra2 < 100)
			{
				WriteString(MSG_ONE, " ");
			}
			else // >= 100
			{
				WriteString(MSG_ONE, "");
			}
			WriteString(MSG_ONE, ftos(crmod_teamra2));
			WriteString(MSG_ONE, "\x11");

			item_count = item_count + 1;
		}

		/* Mega Health pickup counts */
		local float has_mega;
		item = find(world, classname, "item_health");
		while (item)
		{
			/* Skip health items that aren't mega */
			if (!(item.spawnflags & 2))
			{
				item = find(item, classname, "item_health");
				continue;
			}
			/* Mega health item was found, stop searching */
			has_mega = 1;
			break;
		}
		if (has_mega && (item_count < item_slots))
		{
			/* Mega Health */
			WriteString(MSG_ONE, "\smh");
			WriteString(MSG_ONE, "\x10");
			if (crmod_teammega1 < 10)
			{
				WriteString(MSG_ONE, "  ");
			}
			else if (crmod_teammega1 < 100)
			{
				WriteString(MSG_ONE, " ");
			}
			else // >= 100
			{
				WriteString(MSG_ONE, "");
			}
			WriteString(MSG_ONE, ftos(crmod_teammega1));
			WriteString(MSG_ONE, "\x11");

			WriteString(MSG_ONE, "\smh");
			WriteString(MSG_ONE, "\x10");
			if (crmod_teammega2 < 10)
			{
				WriteString(MSG_ONE, "  ");
			}
			else if (crmod_teammega2 < 100)
			{
				WriteString(MSG_ONE, " ");
			}
			else // >= 100
			{
				WriteString(MSG_ONE, "");
			}
			WriteString(MSG_ONE, ftos(crmod_teammega2));
			WriteString(MSG_ONE, "\x11");
			item_count = item_count + 1;
		}

		/* Yellow Armor pickup counts */
		item = find(world, classname, "item_armor2");
		if (item && (item_count < item_slots))
		{
			WriteString(MSG_ONE, "\sya");
			WriteString(MSG_ONE, "\x10");
			if (crmod_teamya1 < 10)
			{
				WriteString(MSG_ONE, "  ");
			}
			else if (crmod_teamya1 < 100)
			{
				WriteString(MSG_ONE, " ");
			}
			else // >= 100
			{
				WriteString(MSG_ONE, "");
			}
			WriteString(MSG_ONE, ftos(crmod_teamya1));
			WriteString(MSG_ONE, "\x11");

			WriteString(MSG_ONE, "\sya");
			WriteString(MSG_ONE, "\x10");
			if (crmod_teamya2 < 10)
			{
				WriteString(MSG_ONE, "  ");
			}
			else if (crmod_teamya2 < 100)
			{
				WriteString(MSG_ONE, " ");
			}
			else // >= 100
			{
				WriteString(MSG_ONE, "");
			}
			WriteString(MSG_ONE, ftos(crmod_teamya2));
			WriteString(MSG_ONE, "\x11");

			item_count = item_count + 1;
		}
	}

	/* Eat up extra item format string parameters */
	if (teams_printed == 0)
	{
		WriteString(MSG_ONE, "  ");
		WriteString(MSG_ONE, "  ");
	}
	for(i = 0; i < (item_slots - item_count); i = i + 1)
	{
		// Team 1 (left side)
		// Outside (usually 2 red characters)
		WriteString(MSG_ONE, "  ");
		// Open bracket
		WriteString(MSG_ONE, " ");
		// Padding
		WriteString(MSG_ONE, "   ");
		// Number
		WriteString(MSG_ONE, "");
		// Close bracket
		WriteString(MSG_ONE, " ");

		// Team 2 (right side)
		// Outside (usually 2 red characters)
		WriteString(MSG_ONE, "  ");
		// Open bracket
		WriteString(MSG_ONE, " ");
		// Padding
		WriteString(MSG_ONE, "   ");
		// Number
		WriteString(MSG_ONE, "");
		// Close bracket
		WriteString(MSG_ONE, " ");
	}

	/* Allow for 8 item timer slots, reset count */
	item_slots = 8;
	item_count = 0;

	/* Only print item timers for observer HUD */
	if (self.style & ELOHIM_OBSERVER)
	{
		/* Quad */
		item = find(world, classname, "item_artifact_super_damage");
		while (item && (item_count < item_slots))
		{
			if (elohim_playmode & ELOHIM_NO_QUAD){
				break;
			}
			WriteString(MSG_ONE, " \sq");
			WriteString(MSG_ONE, "\x10");
			if (item.nextthink == 0)
			{
				WriteString(MSG_ONE, " ");
				WriteString(MSG_ONE, "up");
			}
			else
			{
				item_time = floor(item.nextthink - time);
				if (item_time < 0)
				{
					item_time = 0;
				}
				if (item_time < 10)
				{
					WriteString(MSG_ONE, "  ");
				}
				else if (item_time < 100)
				{
					WriteString(MSG_ONE, " ");
				}
				else // >= 100
				{
					WriteString(MSG_ONE, "");
				}
				WriteString(MSG_ONE, ftos(item_time));
			}
			WriteString(MSG_ONE, "\x11");
			item_count = item_count + 1;
			item = find(item, classname, "item_artifact_super_damage");
		}
		/* Pentagram */
		item = find(world, classname, "item_artifact_invulnerability");
		while (item && (item_count < item_slots))
		{
			if (elohim_playmode & ELOHIM_NO_PENT){
				break;
			}
			WriteString(MSG_ONE, " \sp");
			WriteString(MSG_ONE, "\x10");
			if (item.nextthink == 0)
			{
				WriteString(MSG_ONE, " ");
				WriteString(MSG_ONE, "up");
			}
			else
			{
				item_time = floor(item.nextthink - time);
				if (item_time < 0)
				{
					item_time = 0;
				}
				if (item_time < 10)
				{
					WriteString(MSG_ONE, "  ");
				}
				else if (item_time < 100)
				{
					WriteString(MSG_ONE, " ");
				}
				else // >= 100
				{
					WriteString(MSG_ONE, "");
				}
				WriteString(MSG_ONE, ftos(item_time));
			}
			WriteString(MSG_ONE, "\x11");
			item_count = item_count + 1;
			item = find(item, classname, "item_artifact_invulnerability");
		}
		/* Ring of Shadows (Eyes) */
		item = find(world, classname, "item_artifact_invisibility");
		while (item && (item_count < item_slots))
		{
			if (elohim_playmode & ELOHIM_NO_RING){
				break;
			}
			WriteString(MSG_ONE, " \se");
			WriteString(MSG_ONE, "\x10");
			if (item.nextthink == 0)
			{
				WriteString(MSG_ONE, " ");
				WriteString(MSG_ONE, "up");
			}
			else
			{
				item_time = floor(item.nextthink - time);
				if (item_time < 0)
				{
					item_time = 0;
				}
				if (item_time < 10)
				{
					WriteString(MSG_ONE, "  ");
				}
				else if (item_time < 100)
				{
					WriteString(MSG_ONE, " ");
				}
				else // >= 100
				{
					WriteString(MSG_ONE, "");
				}
				WriteString(MSG_ONE, ftos(item_time));
			}
			WriteString(MSG_ONE, "\x11");
			item_count = item_count + 1;
			item = find(item, classname, "item_artifact_invisibility");
		}
		/* Red Armor */
		item = find(world, classname, "item_armorInv");
		while (item && (item_count < item_slots))
		{
			WriteString(MSG_ONE, "\sra");
			WriteString(MSG_ONE, "\x10");
			if (item.nextthink == 0)
			{
				WriteString(MSG_ONE, " ");
				WriteString(MSG_ONE, "up");
			}
			else
			{
				item_time = floor(item.nextthink - time);
				if (item_time < 0)
				{
					item_time = 0;
				}
				if (item_time < 10)
				{
					WriteString(MSG_ONE, "  ");
				}
				else if (item_time < 100)
				{
					WriteString(MSG_ONE, " ");
				}
				else // >= 100
				{
					WriteString(MSG_ONE, "");
				}
				WriteString(MSG_ONE, ftos(item_time));
			}
			WriteString(MSG_ONE, "\x11");
			item_count = item_count + 1;
			item = find(item, classname, "item_armorInv");
		}
		/* Mega */
		item = find(world, classname, "item_health");
		while (item && (item_count < item_slots))
		{
			/* Skip health items that aren't mega */
			if (!(item.spawnflags & 2))
			{
				item = find(item, classname, "item_health");
				continue;
			}

			WriteString(MSG_ONE, "\smh");
			WriteString(MSG_ONE, "\x10");
			if (item.nextthink == 0)
			{
				WriteString(MSG_ONE, " ");
				WriteString(MSG_ONE, "up");
			}
			else
			{
				item_time = floor(item.nextthink - time);
				if (item_time < 0)
				{
					item_time = 0;
				}
				if (item_time < 10)
				{
					WriteString(MSG_ONE, "  ");
				}
				else if (item_time < 100)
				{
					WriteString(MSG_ONE, " ");
				}
				else // >= 100
				{
					WriteString(MSG_ONE, "");
				}
				WriteString(MSG_ONE, ftos(item_time));
			}
			WriteString(MSG_ONE, "\x11");
			item_count = item_count + 1;
			item = find(item, classname, "item_health");
		}
		/* Yellow Armor */
		item = find(world, classname, "item_armor2");
		while (item && (item_count < item_slots))
		{
			WriteString(MSG_ONE, "\sya");
			WriteString(MSG_ONE, "\x10");
			if (item.nextthink == 0)
			{
				WriteString(MSG_ONE, " ");
				WriteString(MSG_ONE, "up");
			}
			else
			{
				item_time = floor(item.nextthink - time);
				if (item_time < 0)
				{
					item_time = 0;
				}
				if (item_time < 10)
				{
					WriteString(MSG_ONE, "  ");
				}
				else if (item_time < 100)
				{
					WriteString(MSG_ONE, " ");
				}
				else // >= 100
				{
					WriteString(MSG_ONE, "");
				}
				WriteString(MSG_ONE, ftos(item_time));
			}
			WriteString(MSG_ONE, "\x11");
			item_count = item_count + 1;
			item = find(item, classname, "item_armor2");
		}
		/* Green Armor */
		item = find(world, classname, "item_armor1");
		while (item && (item_count < item_slots))
		{
			WriteString(MSG_ONE, "\sga");
			WriteString(MSG_ONE, "\x10");
			if (item.nextthink == 0)
			{
				WriteString(MSG_ONE, " ");
				WriteString(MSG_ONE, "up");
			}
			else
			{
				item_time = floor(item.nextthink - time);
				if (item_time < 0)
				{
					item_time = 0;
				}
				if (item_time < 10)
				{
					WriteString(MSG_ONE, "  ");
				}
				else if (item_time < 100)
				{
					WriteString(MSG_ONE, " ");
				}
				else // >= 100
				{
					WriteString(MSG_ONE, "");
				}
				WriteString(MSG_ONE, ftos(item_time));
			}
			WriteString(MSG_ONE, "\x11");
			item_count = item_count + 1;
			item = find(item, classname, "item_armor1");
		}
	}

	/* Eat up extra item format string parameters */
	for(i = 0; i < (item_slots - item_count); i = i + 1)
	{
		// Outside (usually 2 red characters)
		WriteString(MSG_ONE, "  ");
		// Open bracket
		WriteString(MSG_ONE, " ");
		// Padding
		WriteString(MSG_ONE, "   ");
		// Number
		WriteString(MSG_ONE, "");
		// Close bracket
		WriteString(MSG_ONE, " ");
	}

	/* Target Name */
	if ((self.style & ELOHIM_OBSERVER) && (self.crmod_othertarget != world) && (self.movetarget.classname == "player"))
	{
		WriteString(MSG_ONE, self.crmod_othertarget.netname);
	}
	else
	{
		WriteString(MSG_ONE, "");
	}

	/* Player Name */
	if ((self.style & ELOHIM_OBSERVER) && (self.movetarget)) {
		WriteString(MSG_ONE, self.movetarget.netname);
	}
	else
	{
		WriteString(MSG_ONE, "");
	}

	// Timer
	// Padding
	if (cur_min < 10)
	{
		WriteString(MSG_ONE, "  ");
	}
	else if (cur_min < 100)
	{
		WriteString(MSG_ONE, " ");
	}
	else // >= 100
	{
		WriteString(MSG_ONE, "");
	}
	// Minutes
	WriteString(MSG_ONE, ftos(cur_min));
	// Seconds
	// Padding
	if (cur_sec < 10)
	{
		// Leading zero on seconds
		WriteString(MSG_ONE, "0");
	}
	else
	{
		WriteString(MSG_ONE, "");
	}
	// Value
	WriteString(MSG_ONE, ftos(cur_sec));

	// Frags/Score
	// Non-match version
	if (!(elohim_playmode & ELOHIM_MATCH_MODE))
	{
		// Spacing before score
		WriteString(MSG_ONE, "  ");
		WriteString(MSG_ONE, " ");
		WriteString(MSG_ONE, "  ");
		// 3-digit score padding
		if (self.frags < -9)
		{
			WriteString(MSG_ONE, "");
		}
		else if (self.frags < 0)
		{
			WriteString(MSG_ONE, " ");
		}
		else if (self.frags < 10)
		{
			WriteString(MSG_ONE, "  ");
		}
		else if (self.frags < 100)
		{
			WriteString(MSG_ONE, " ");
		}
		else // >= 100
		{
			WriteString(MSG_ONE, "");
		}
		// Value
		WriteString(MSG_ONE, ftos(self.frags));
	}
	// Match version
	else
	{
		// 3-digit score padding
		if (my_team_score < -9)
		{
			WriteString(MSG_ONE, "");
		}
		else if (my_team_score < 0)
		{
			WriteString(MSG_ONE, " ");
		}
		else if (my_team_score < 10)
		{
			WriteString(MSG_ONE, "  ");
		}
		else if (my_team_score < 100)
		{
			WriteString(MSG_ONE, " ");
		}
		else // >= 100
		{
			WriteString(MSG_ONE, "");
		}
		// My Team Score Value
		WriteString(MSG_ONE, ftos(my_team_score));

		// Inter-Team-Score Brackets
		WriteString(MSG_ONE, "\x11\x10");

		// 3-digit score padding
		if (their_team_score < -9)
		{
			WriteString(MSG_ONE, "");
		}
		else if (their_team_score < 0)
		{
			WriteString(MSG_ONE, " ");
		}
		else if (their_team_score < 10)
		{
			WriteString(MSG_ONE, "  ");
		}
		else if (their_team_score < 100)
		{
			WriteString(MSG_ONE, " ");
		}
		else // >= 100
		{
			WriteString(MSG_ONE, "");
		}
		// Second Team Score Value
		WriteString(MSG_ONE, ftos(their_team_score));
	}

	// Team name
	// Non-match version
	if (!(elohim_playmode & ELOHIM_MATCH_MODE))
	{
		WriteString(MSG_ONE, "          ");
	}
	// Match version
	else
	{
		if (self.height == 1)
			WriteString(MSG_ONE, "\sBrown     ");
		else if (self.height == 2)
			WriteString(MSG_ONE, "\sLight Blue");
		else if (self.height == 3)
			WriteString(MSG_ONE, "\sGreen     ");
		else if (self.height == 4)
			WriteString(MSG_ONE, "\sRed       ");
		else if (self.height == 5)
			WriteString(MSG_ONE, "\sOlive     ");
		else if (self.height == 6)
			WriteString(MSG_ONE, "\sGold      ");
		else if (self.height == 7)
			WriteString(MSG_ONE, "\sFlesh     ");
		else if (self.height == 8)
			WriteString(MSG_ONE, "\sLavender  ");
		else if (self.height == 9)
			WriteString(MSG_ONE, "\sPurple    ");
		else if (self.height == 10)
			WriteString(MSG_ONE, "\sBeige     ");
		else if (self.height == 11)
			WriteString(MSG_ONE, "\sAqua      ");
		else if (self.height == 12)
			WriteString(MSG_ONE, "\sYellow    ");
		else if (self.height == 13)
			WriteString(MSG_ONE, "\sBlue      ");
		else if (self.height == 14)
			WriteString(MSG_ONE, "\sOrange    ");
		else if (self.height == 15)
			WriteString(MSG_ONE, "\sBlood     ");
		else
			WriteString(MSG_ONE, "          ");
	}

	// LG, Cells
	if (self.items & IT_LIGHTNING)
	{
		WriteString(MSG_ONE, " \sl"); // bronze l
	}
	else
	{
		WriteString(MSG_ONE, "  ");
	}
	// Padding
	if (self.ammo_cells < 10)
	{
		WriteString(MSG_ONE, "  ");
	}
	else if (self.ammo_cells < 100)
	{
		WriteString(MSG_ONE, " ");
	}
	else // >= 100
	{
		WriteString(MSG_ONE, "");
	}
	// Value
	WriteString(MSG_ONE, ftos(self.ammo_cells));

	// RL/GL, Rockets
	if ((self.items & IT_GRENADE_LAUNCHER) && (self.items & IT_ROCKET_LAUNCHER))
	{
		WriteString(MSG_ONE, "\sgr"); // bronze gr
	}
	else if (self.items & IT_GRENADE_LAUNCHER)
	{
		WriteString(MSG_ONE, " \sg"); // bronze g
	}
	else if (self.items & IT_ROCKET_LAUNCHER)
	{
		WriteString(MSG_ONE, " \sr"); // bronze r
	}
	else
	{
		WriteString(MSG_ONE, "  ");
	}
	// Padding
	if (self.ammo_rockets < 10)
	{
		WriteString(MSG_ONE, "  ");
	}
	else if (self.ammo_rockets < 100)
	{
		WriteString(MSG_ONE, " ");
	}
	else // >= 100
	{
		WriteString(MSG_ONE, "");
	}
	// Value
	WriteString(MSG_ONE, ftos(self.ammo_rockets));

	// NG/SNG, Nails
	if ((self.items & IT_NAILGUN) && (self.items & IT_SUPER_NAILGUN))
	{
		WriteString(MSG_ONE, "\sns"); // bronze ns
	}
	else if (self.items & IT_NAILGUN)
	{
			WriteString(MSG_ONE, " \sn"); // bronze n
	}
	else if (self.items & IT_SUPER_NAILGUN)
	{
		WriteString(MSG_ONE, " \ss"); // bronze s
	}
	else
	{
		WriteString(MSG_ONE, "  ");
	}
	// Padding
	if (self.ammo_nails < 10)
	{
		WriteString(MSG_ONE, "  ");
	}
	else if (self.ammo_nails < 100)
	{
		WriteString(MSG_ONE, " ");
	}
	else // >= 100
	{
		WriteString(MSG_ONE, "");
	}
	// Value
	WriteString(MSG_ONE, ftos(self.ammo_nails));

	// SG/SSG, Shells
	if ((self.items & IT_SHOTGUN) && (self.items & IT_SUPER_SHOTGUN))
	{
		WriteString(MSG_ONE, "\sss"); // bronze ss
	}
	else if (self.items & IT_SHOTGUN)
	{
		WriteString(MSG_ONE, " \ss"); //bronze s
	}
	else if (self.items & IT_SUPER_SHOTGUN)
	{
		WriteString(MSG_ONE, " \ss"); // bronze s
	}
	else
	{
		WriteString(MSG_ONE, "  ");
	}
	// Padding
	if (self.ammo_shells < 10)
	{
		WriteString(MSG_ONE, "  ");
	}
	else if (self.ammo_shells < 100)
	{
		WriteString(MSG_ONE, " ");
	}
	else // >= 100
	{
		WriteString(MSG_ONE, "");
	}
	// Value
	WriteString(MSG_ONE, ftos(self.ammo_shells));

	// Everything after the format string parameters gets eaten

	// Terminating null byte
	WriteByte (MSG_ONE, 0);
}
