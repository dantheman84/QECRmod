// Next time to update hud
float hud_next_think;

// Think function for game timer
void HudThink(entity client) =
{
    // Let the welcome message print, CRmod takes about 16-17 seconds
	if (time < 17)
		return;

	// Only update once per second
	if (time < hud_next_think)
	{
        return;
    }

    // Set next think time
    hud_next_think = time + 0.1;

    // Calculate time values for display
    local float cur_sec = elohim_match_timer.count;
    local float cur_min = elohim_match_timer.lip;

	// Reminder: centerprint can do 7 strings, 40 lines, 50 characters wide
    msg_entity = client;
    WriteByte (MSG_ONE, SVC_CENTERPRINT);

    // 1 base(?) + 1 format string + 18 format parameters
    WriteShort (MSG_ONE, 20); // QE reserved

    // Print 17 newlines to push hud to bottom of screen
    local float i;
    for(i = 0; i < 17; i = i + 1)
    {
        WriteByte (MSG_ONE, '\n');
    }

    // Write format string
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
    if (client.frags < -9)
    {
        WriteString(MSG_ONE, "");
    }
    else if (client.frags < 0)
    {
        WriteString(MSG_ONE, " ");
    }
    else if (client.frags < 10)
    {
        WriteString(MSG_ONE, "  ");
    }
    else if (client.frags < 100)
    {
        WriteString(MSG_ONE, " ");
    }
    else // >= 100
    {
        WriteString(MSG_ONE, "");
    }
    // Value
    WriteString(MSG_ONE, ftos(client.frags));

    // LG, Cells
    if (self.items & IT_LIGHTNING)
    {
        WriteString(MSG_ONE, " \xec"); // red l
    }
    else
    {
        WriteString(MSG_ONE, "  ");
    }
    // Padding
    if (client.ammo_cells < 10)
    {
        WriteString(MSG_ONE, "  ");
    }
    else if (client.ammo_cells < 100)
    {
        WriteString(MSG_ONE, " ");
    }
    else // >= 100
    {
        WriteString(MSG_ONE, "");
    }
    // Value
    WriteString(MSG_ONE, ftos(client.ammo_cells));

    // RL/GL, Rockets
    if ((client.items & IT_GRENADE_LAUNCHER) && (client.items & IT_ROCKET_LAUNCHER))
    {
        WriteString(MSG_ONE, "\xe7\xf2"); // red gl
    }
    else if (client.items & IT_GRENADE_LAUNCHER)
    {
        WriteString(MSG_ONE, " \xe7"); // red g
    }
    else if (client.items & IT_ROCKET_LAUNCHER)
    {
        WriteString(MSG_ONE, " \xf2"); // red r
    }
    else
    {
        WriteString(MSG_ONE, "  ");
    }
    // Padding
    if (client.ammo_rockets < 10)
    {
        WriteString(MSG_ONE, "  ");
    }
    else if (client.ammo_rockets < 100)
    {
        WriteString(MSG_ONE, " ");
    }
    else // >= 100
    {
        WriteString(MSG_ONE, "");
    }
    // Value
    WriteString(MSG_ONE, ftos(client.ammo_rockets));

    // NG/SNG, Nails
    if ((client.items & IT_NAILGUN) && (client.items & IT_SUPER_NAILGUN))
    {
        WriteString(MSG_ONE, "\xee\xf3"); // red ns
    }
    else if (client.items & IT_NAILGUN)
    {
        WriteString(MSG_ONE, " \xee"); //red n
    }
    else if (client.items & IT_SUPER_NAILGUN)
    {
        WriteString(MSG_ONE, " \xf3"); // red s
    }
    else
    {
        WriteString(MSG_ONE, "  ");
    }
    // Padding
    if (client.ammo_nails < 10)
    {
        WriteString(MSG_ONE, "  ");
    }
    else if (client.ammo_nails < 100)
    {
        WriteString(MSG_ONE, " ");
    }
    else // >= 100
    {
        WriteString(MSG_ONE, "");
    }
    // Value
    WriteString(MSG_ONE, ftos(client.ammo_nails));

    // SG/SSG, Shells
    if ((client.items & IT_SHOTGUN) && (client.items & IT_SUPER_SHOTGUN))
    {
        WriteString(MSG_ONE, "\xf3\xf3"); // red ss
    }
    else if (client.items & IT_SHOTGUN)
    {
        WriteString(MSG_ONE, " \xf3"); //red s
    }
    else if (client.items & IT_SUPER_SHOTGUN)
    {
        WriteString(MSG_ONE, " \xf3"); // red s
    }
    else
    {
        WriteString(MSG_ONE, "  ");
    }
    // Padding
    if (client.ammo_shells < 10)
    {
        WriteString(MSG_ONE, "  ");
    }
    else if (client.ammo_shells < 100)
    {
        WriteString(MSG_ONE, " ");
    }
    else // >= 100
    {
        WriteString(MSG_ONE, "");
    }
    // Value
    WriteString(MSG_ONE, ftos(client.ammo_shells));

    // Everything after the format string parameters gets eaten

    // Terminating null byte
    WriteByte (MSG_ONE, 0);
}
