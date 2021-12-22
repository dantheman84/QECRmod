
// For QETWEAK_GAME_TIMER
float qetweaks_game_timer_last_tick;



// Run function for game timer
void QETweaksGameTimerRun(entity client) =
{
    // Let the welcome message print
	if (time < 5)
		return;

    // Get current time as a whole (truncated) number
    local float cur_time = floor(elohim_match_timer.count);

	// Only update once per second
	if (cur_time <= (qetweaks_game_timer_last_tick))
	{
        return;
    }

    // Store last tick
    qetweaks_game_timer_last_tick = cur_time;

    // Calculate time values for display
    local float cur_sec = cur_time % 60;
    local float cur_min = floor(cur_time / 60);

	// centerprint can do 7 strings, 40 lines, 50 characters wide

    msg_entity = client;
    WriteByte (MSG_ONE, SVC_CENTERPRINT);

    // 1 base(?) + 1 format string + 7 format parameters
    WriteShort (MSG_ONE, 9); // QE reserved

    // Print 16 newlines to push "hud" to bottom of screen
    local float i;
    for(i = 0; i < 16; i = i + 1)
    {
        WriteByte (MSG_ONE, '\n');
    }

    // Write format string
    WriteString(MSG_ONE, "{}:{}{}  s {}   n {}   r {}   c {}\n");

    WriteString(MSG_ONE, ftos(cur_min));
    if (cur_sec < 10)
    {
        // Leading zero on seconds
        WriteString(MSG_ONE, "0");
    }
    else
    {
        WriteString(MSG_ONE, "");
    }
    WriteString(MSG_ONE, ftos(cur_sec));

    WriteString(MSG_ONE, ftos(client.ammo_shells));
    WriteString(MSG_ONE, ftos(client.ammo_nails));
    WriteString(MSG_ONE, ftos(client.ammo_rockets));
    WriteString(MSG_ONE, ftos(client.ammo_cells));

    // Everything after the format string parameters gets eaten

    WriteByte (MSG_ONE, 0);
}