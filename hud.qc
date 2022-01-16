// Update player HUD with match timer, current score, weapon and ammo count info
void hud_update() =
{
    // Let the welcome message print, CRmod takes about 16-17 seconds
	if (time < 17)
		return;

	// Only update after delay time has been reached
	if (time < self.delay)
	{
        return;
    }

    // Only update every 0.1 seconds
    self.delay = time + 0.1;

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

	// Reminder: centerprint can do 7 strings, 40 lines, 50 characters wide
    msg_entity = self;
    WriteByte (MSG_ONE, SVC_CENTERPRINT);

    // 1 base(?) + 1 format string + 21 format parameters
    WriteShort (MSG_ONE, 23); // QE reserved

    // Print newlines to push hud to bottom of screen
    local float newlines = 17;
    local float i;
    for(i = 0; i < newlines; i = i + 1)
    {
        WriteByte (MSG_ONE, '\n');
    }

    // Write format string
    WriteString(MSG_ONE,
        // Timer
        "\x10  {}{}:{}{}\x11                                        \n"
        // Frags, Cells
        "\x10{}{}{}{}{}\x11                                 {}\x10{}{}\x11\n"
        // Rockets
        "                                           {}\x10{}{}\x11\n"
        // Nails
        "                                           {}\x10{}{}\x11\n"
        // Shells
        "                                           {}\x10{}{}\x11\n"
    );

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
