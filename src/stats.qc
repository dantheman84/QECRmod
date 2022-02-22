//
// Stats.qc
//
// Various routines for displaying statistics.
//
// All code by J.P. Grossman unless otherwise commented.
//

//
//  P R O T O T Y P E S
//
void (float frac, float tot) stats_print_percent3;


//
//  R E S E T  S T A T S
//
void () stats_reset =
{
	self.dest1 = self.dest2 = self.dest = self.mangle = '0 0 0';
	self.crmod_qdwep = self.crmod_qdkill = '0 0 0';
	self.crmod_did_damage = 0; // CRMOD moved here from put_client_in_server

};

//
//  R E S E T  T E A M  S T A T S
//
void () stats_reset_team =
{
	crmod_teamquad1 = 0;
	crmod_teampent1 = 0;
	crmod_teameyes1 = 0;
	crmod_teammega1 = 0;
	crmod_teamrl1 = 0;
	crmod_teamlg1 = 0;
	crmod_teamgl1 = 0;
	crmod_teamsn1 = 0;
	crmod_teamng1 = 0;
	crmod_teamss1 = 0;
	crmod_teamra1 = 0;
	crmod_teamya1 = 0;
	crmod_teamga1 = 0;
	crmod_teamquad2 = 0;
	crmod_teampent2 = 0;
	crmod_teameyes2 = 0;
	crmod_teammega2 = 0;
	crmod_teamrl2 = 0;
	crmod_teamlg2 = 0;
	crmod_teamgl2 = 0;
	crmod_teamsn2 = 0;
	crmod_teamng2 = 0;
	crmod_teamss2 = 0;
	crmod_teamra2 = 0;
	crmod_teamya2 = 0;
	crmod_teamga2 = 0;
};

//
//  S H O W  Q U A D S T A T S
//
void () stats_show_quadstats =
{
	local entity player;

	// Don't take up exta lines from scr_maxlines limit in QE
	// sprint(self, "quads - quads picked up\n");
	// sprint(self, "eff   - quad weapon efficiency\n");
	// sprint(self, "opp   - number of opponents killed\n");
	// sprint(self, "slf   - number of times killed self\n");
	// sprint(self, "tm    - number of teammates killed\n");
	// sprint(self, "\n");
	sprint(self, "quads|eff|opp|slf|tm |     name\n");
	sprint(self, "-----+---+---+---+---+---------------\n");

	player = find(world, classname, "player");
	while (player)
	{
		if ((player.style & ELOHIM_CONNECTED) &&
			!(player.style & ELOHIM_OBSERVER))
		{
			if (player == self)
			{
				sprint(self, "[");
				utils_print_int3(player.crmod_qdwep_z);
				sprint(self, "]|");
			}
			else
			{
				sprint(self, " ");
				utils_print_int3(player.crmod_qdwep_z);
				sprint(self, " |");
			}
			stats_print_percent3(player.crmod_qdwep_x, player.crmod_qdwep_y);
			sprint(self, "|");
			utils_print_int3(player.crmod_qdkill_x);
			sprint(self, "|");
			utils_print_int3(player.crmod_qdkill_z);
			sprint(self, "|");
			utils_print_int3(player.crmod_qdkill_y);
			sprint3(self, "|", player.netname, "\n");
		}
		player = find(player, classname, "player");
	}
};

//
//  S H O W  K I L L S T A T S
//
void () stats_show_killstats =
{
	local entity player;

	// Don't take up exta lines from scr_maxlines limit in QE
	// sprint(self, "opp - number of opponents killed\n");
	// sprint(self, "slf - number of times killed self\n");
	// sprint(self, "tm  - number of teammates killed\n");
	// sprint(self, "kld - number of times killed by enemy\n");
	// sprint(self, "\n");
	sprint(self, "frags|opp|slf|tm |kld|     name\n");
	sprint(self, "-----+---+---+---+---+---------------\n");

	player = find(world, classname, "player");
	while (player)
	{
		if ((player.style & ELOHIM_CONNECTED) &&
			!(player.style & ELOHIM_OBSERVER))
		{
			if (player == self)
			{
				sprint(self, "[");
				utils_print_int3(player.frags);
				sprint(self, "]|");
			}
			else
			{
				sprint(self, " ");
				utils_print_int3(player.frags);
				sprint(self, " |");
			}
			utils_print_int3(player.frags + player.mangle_x + player.mangle_y);
			sprint(self, "|");
			utils_print_int3(player.mangle_x);
			sprint(self, "|");
			utils_print_int3(player.mangle_y);
			sprint(self, "|");
			utils_print_int3(player.mangle_z);
			sprint3(self, "|", player.netname, "\n");
		}
		player = find(player, classname, "player");
	}
};

//
//  P R I N T  P E R C E N T 3
//
//  Helper function for stats_show_efficiency.  Prints the percentage
//  100 * (frac / tot) as a 3 character integer, or N/A if tot = 0.
//
void (float frac, float tot) stats_print_percent3 =
{
	if (tot)
	{
		local float n;
		local string temp;

		n = floor(100 * frac / tot);
		if (n < 10)
			sprint(self, " ");
		temp = ftos(n);
		sprint(self, temp);
		if (n < 100)
			sprint(self, "%");
	}
	else
		sprint(self, "N/A");
};

//
//  S H O W  E F F I C I E N C Y
//
//  Show the weapon efficiency for each player.
//
void () stats_show_efficiency =
{
	local entity player;
	local float tot_fired, tot_done;

	// Don't take up exta lines from scr_maxlines limit in QE
	// sprint(self, "bul - bullet efficiency\n");
	// sprint(self, "nls - nail efficiency\n");
	// sprint(self, "rox - rocket efficiency\n");
	// sprint(self, "lg  - lightning gun efficiency\n");
	// sprint(self, "\n");
	sprint(self, "bul|nls|rox|lg |total|     name\n");
	sprint(self, "---+---+---+---+-----+---------------\n");

	player = find(world, classname, "player");
	while (player)
	{
		if ((player.style & ELOHIM_CONNECTED) &&
			!(player.style & ELOHIM_OBSERVER))
		{
			stats_print_percent3(player.dest2_x, player.dest1_x);
			sprint(self, "|");
			stats_print_percent3(player.dest2_y, player.dest1_y);
			sprint(self, "|");
			stats_print_percent3(player.dest_y, player.dest_x);
			sprint(self, "|");
			stats_print_percent3(player.dest2_z, player.dest1_z);
			sprint(self, "|");

			tot_fired = player.dest1_x + player.dest1_y + player.dest1_z +
						player.dest_x;
			tot_done = player.dest2_x + player.dest2_y + player.dest2_z +
					   player.dest_y;
			if (player == self)
			{
				sprint(self, "[");
				stats_print_percent3(tot_done, tot_fired);
				sprint(self, "]|");
			}
			else
			{
				sprint(self, " ");
				stats_print_percent3(tot_done, tot_fired);
				sprint(self, " |");
			}
			sprint2(self, player.netname, "\n");
		}
		player = find(player, classname, "player");
	}
};

//
//  S H O W  S U M M A R Y
//
//  Show kill and weapon efficiency for each player.
//
void () stats_show_summary =
{
	local entity player;
	local float wfrac, wtot, kfrac, ktot, doit, currteam;
	local string teamname;

	// Don't take up exta lines from scr_maxlines limit in QE
	// sprint(self, "kill  - kill efficiency\n");
	// sprint(self, "weapn - weapon efficiency\n");
	// sprint(self, "\n");
	if (elohim_state & ELOHIM_MATCH_STARTED)
	{
		sprint(self, "   team  |kill |weapn|     name\n");
		sprint(self, "---------+-----+-----+---------------\n");
		currteam = elohim_team1;
		doit = 2;
	}
	else
	{
		sprint(self, "kill |weapn|     name\n");
		sprint(self, "-----+-----+---------------\n");
		currteam = 0;
		doit = 1;
	}

	while (doit)
	{
		teamname = strings_get_teamname3(currteam);
		player = find(world, classname, "player");
		while (player)
		{
			if ((player.style & ELOHIM_CONNECTED) &&
				!(player.style & ELOHIM_OBSERVER) &&
				(!currteam || player.height == currteam))
			{
				if (currteam)
					sprint2(self, teamname, "|");

				kfrac = player.frags + player.mangle_x + player.mangle_y;
				ktot = kfrac + player.mangle_x + player.mangle_y +
					   player.mangle_z;
				wtot = player.dest1_x + player.dest1_y + player.dest1_z +
					   player.dest_x;
				wfrac = player.dest2_x + player.dest2_y + player.dest2_z +
						player.dest_y;
				if (player == self)
				{
					sprint(self, "[");
					stats_print_percent3(kfrac, ktot);
					sprint(self, "]|[");
					stats_print_percent3(wfrac, wtot);
					sprint(self, "]|");
				}
				else
				{
					sprint(self, " ");
					stats_print_percent3(kfrac, ktot);
					sprint(self, " | ");
					stats_print_percent3(wfrac, wtot);
					sprint(self, " |");
				}
				sprint2(self, player.netname, "\n");
			}
			player = find(player, classname, "player");
		}
		currteam = elohim_team2;
		doit = doit - 1;
	}
};

//
//  S H O W  T E A M  S T A T S
//
void() stats_show_teamstats =
{
	local string s;

	if (!(teamplay && (elohim_playmode & ELOHIM_MATCH_MODE)))
	{
		sprint(self, "Teamstats valid in match mode only\n");
		return;
	}
	if (!elohim_team1)
	{
		sprint(self, "No teams present\n");
		return;
	}
	if ((elohim_state & ELOHIM_MATCH_STARTED) && !(self.style & ELOHIM_OBSERVER))
	{
		sprint(self, "Teamstats available to observers or after match only\n");
		return;
	}

	sprint(self, " Q | P | E | MH| RL| LG| GL| SN| NG| SS| RA| YA| GA| Team\n");
	sprint(self, "---+---+---+---+---+---+---+---+---+---+---+---+---+----------\n");
	utils_print_int3(crmod_teamquad1);
	sprint(self, "|");
	utils_print_int3(crmod_teampent1);
	sprint(self, "|");
	utils_print_int3(crmod_teameyes1);
	sprint(self, "|");
	utils_print_int3(crmod_teammega1);
	sprint(self, "|");
	utils_print_int3(crmod_teamrl1);
	sprint(self, "|");
	utils_print_int3(crmod_teamlg1);
	sprint(self, "|");
	utils_print_int3(crmod_teamgl1);
	sprint(self, "|");
	utils_print_int3(crmod_teamsn1);
	sprint(self, "|");
	utils_print_int3(crmod_teamng1);
	sprint(self, "|");
	utils_print_int3(crmod_teamss1);
	sprint(self, "|");
	utils_print_int3(crmod_teamra1);
	sprint(self, "|");
	utils_print_int3(crmod_teamya1);
	sprint(self, "|");
	utils_print_int3(crmod_teamga1);
	sprint(self, "|");
	s = strings_get_teamname2(elohim_team1);
	sprint(self, s);
	sprint(self, "\n");

	utils_print_int3(crmod_teamquad2);
	sprint(self, "|");
	utils_print_int3(crmod_teampent2);
	sprint(self, "|");
	utils_print_int3(crmod_teameyes2);
	sprint(self, "|");
	utils_print_int3(crmod_teammega2);
	sprint(self, "|");
	utils_print_int3(crmod_teamrl2);
	sprint(self, "|");
	utils_print_int3(crmod_teamlg2);
	sprint(self, "|");
	utils_print_int3(crmod_teamgl2);
	sprint(self, "|");
	utils_print_int3(crmod_teamsn2);
	sprint(self, "|");
	utils_print_int3(crmod_teamng2);
	sprint(self, "|");
	utils_print_int3(crmod_teamss2);
	sprint(self, "|");
	utils_print_int3(crmod_teamra2);
	sprint(self, "|");
	utils_print_int3(crmod_teamya2);
	sprint(self, "|");
	utils_print_int3(crmod_teamga2);
	sprint(self, "|");
	s = strings_get_teamname2(elohim_team2);
	sprint(self, s);
	sprint(self, "\n");
};

//
//  A U T O  S U M M A R Y
//
//  Dump summary statistics if player has autostats enabled.
//
void() stats_auto_summary =
{
	if (self.style & CRMOD_AUTOSTATS)
	{
		sprint(self, "[CRMod match statistics]\n");

		stats_show_summary();
		sprint(self, "\n");
	}
};

//
//  A U T O  K I L L S T A T S
//
//  Dump kill statistics if player has autostats enabled.
//
void() stats_auto_killstats =
{
	if (self.style & CRMOD_AUTOSTATS)
	{
		stats_show_killstats();
		sprint(self, "\n");
	}
};
//
//  A U T O  E F F I C I E N C Y
//
//  Dump efficiency statistics if player has autostats enabled.
//
void() stats_auto_efficiency =
{
	if (self.style & CRMOD_AUTOSTATS)
	{
		stats_show_efficiency();
		sprint(self, "\n");
	}
};
//
//  A U T O  Q U A D S T A T S
//
//  Dump quad statistics if player has autostats enabled.
//
void() stats_auto_quadstats =
{
	if (self.style & CRMOD_AUTOSTATS)
	{
		if (!(elohim_playmode & ELOHIM_NO_QUAD))//R00k -added-
		{
			stats_show_quadstats();
			sprint(self, "\n");
		}
	}
};
//
//  A U T O  T E A M S T A T S
//
//  Dump team if player has autostats enabled.
//
void() stats_auto_teamstats =
{
	if (self.style & CRMOD_AUTOSTATS)
	{
		if (elohim_playmode & ELOHIM_MATCH_MODE)
		{
			stats_show_teamstats();
			sprint(self, "\n");
		}
	}
};
