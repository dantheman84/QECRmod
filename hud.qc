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
    if (elohim_state & ELOHIM_TIMER_STARTED)
    {
        cur_sec = elohim_match_timer.count;
        cur_min = elohim_match_timer.lip;
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

	// Reminder: centerprint can do 7 strings, 40 lines, 50 characters wide
    msg_entity = self;
    WriteByte (MSG_ONE, SVC_CENTERPRINT);

    // 1 base(?) + 1 format string + 18 format parameters
    WriteShort (MSG_ONE, 20); // QE reserved

    // Print newlines to push hud to bottom of screen
    local float newlines;
    if (cvar("cl_hud") == 3) // Quake HUD full
    {
        if (cvar("scr_usekfont") == 0)
        {
            newlines = 19;
        }
        else
        {
            newlines = 15;
        }
    }
    else if (cvar("cl_hud") == 2) // Quake HUD standard
    {
        if (cvar("scr_usekfont") == 0)
        {
            newlines = 20;
        }
        else
        {
            newlines = 16;
        }
    }
    else if (cvar("cl_hud") == 0) // Quake HUD off
    {
        if (cvar("scr_usekfont") == 0)
        {
            newlines = 21;
        }
        else
        {
            newlines = 17;
        }
    }
    else // Quake HUD or minimal
    {
        newlines = 17;
    }
    local float i;
    for(i = 0; i < newlines; i = i + 1)
    {
        WriteByte (MSG_ONE, '\n');
    }

    // Write format string
    if (cvar("scr_usekfont") == 0)
    {
        WriteString(MSG_ONE,
            // Timer
            "\x10{}{}:{}{}\x11                                          \n"
            // Frags, Cells
            "\x10   {}{}\x11                                   {}\x10{}{}\x11\n"
            // Rockets
            "                                           {}\x10{}{}\x11\n"
            // Nails
            "                                           {}\x10{}{}\x11\n"
            // Shells
            "                                           {}\x10{}{}\x11\n"
        );
    }
    else
    {
        WriteString(MSG_ONE,
            // Timer
            " {}{}:{}{}                                         \n"
            // Frags, Cells
            "    {}{}                                 {} {}{} \n"
            // Rockets
            "                                        {} {}{} \n"
            // Nails
            "                                        {} {}{} \n"
            // Shells
            "                                        {} {}{} \n"
        );
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
    // Padding
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

    // LG, Cells
    if (self.items & IT_LIGHTNING)
    {
        if (cvar("scr_usekfont") == 0)
        {
            WriteString(MSG_ONE, " \xec"); // red l
        }
        else
        {
            WriteString(MSG_ONE, " l"); // white l
        }
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
        if (cvar("scr_usekfont") == 0)
        {
            WriteString(MSG_ONE, "\xe7\xf2"); // red gl
        }
        else
        {
            WriteString(MSG_ONE, "gl"); // white gl
        }
    }
    else if (self.items & IT_GRENADE_LAUNCHER)
    {
        if (cvar("scr_usekfont") == 0)
        {
            WriteString(MSG_ONE, " \xe7"); // red g
        }
        else
        {
            WriteString(MSG_ONE, " g"); // white g
        }
    }
    else if (self.items & IT_ROCKET_LAUNCHER)
    {
        if (cvar("scr_usekfont") == 0)
        {
            WriteString(MSG_ONE, " \xf2"); // red r
        }
        else
        {
            WriteString(MSG_ONE, " r"); // white r
        }
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
        if (cvar("scr_usekfont") == 0)
        {
            WriteString(MSG_ONE, "\xee\xf3"); // red ns
        }
        else
        {
            WriteString(MSG_ONE, "ns"); // white ns
        }
    }
    else if (self.items & IT_NAILGUN)
    {
        if (cvar("scr_usekfont") == 0)
        {
            WriteString(MSG_ONE, " \xee"); //red n
        }
        else
        {
            WriteString(MSG_ONE, " n"); //white n
        }
    }
    else if (self.items & IT_SUPER_NAILGUN)
    {
        if (cvar("scr_usekfont") == 0)
        {
            WriteString(MSG_ONE, " \xf3"); // red s
        }
        else
        {
            WriteString(MSG_ONE, " s"); // white s
        }
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
        if (cvar("scr_usekfont") == 0)
        {
            WriteString(MSG_ONE, "\xf3\xf3"); // red ss
        }
        else
        {
            WriteString(MSG_ONE, "ss"); // white ss
        }
    }
    else if (self.items & IT_SHOTGUN)
    {
        if (cvar("scr_usekfont") == 0)
        {
            WriteString(MSG_ONE, " \xf3"); //red s
        }
        else
        {
            WriteString(MSG_ONE, " s"); //white s
        }
    }
    else if (self.items & IT_SUPER_SHOTGUN)
    {
        if (cvar("scr_usekfont") == 0)
        {
            WriteString(MSG_ONE, " \xf3"); // red s
        }
        else
        {
            WriteString(MSG_ONE, " s"); // white s
        }
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
