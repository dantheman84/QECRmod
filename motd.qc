//
// Motd.qc
//
// Message of the day code.  I created a whole new file so that it would
// be easier to beef up the motd.
//
// All code by J.P. Grossman unless otherwise commented.
//

string motd_top1;
string motd_top2;
string motd_top3;
string motd_top4;
string motd_top5;
string motd_top6;
string motd_top7_1;
string motd_top7_2;
string motd_top7_3;
string motd_top7_4;
string motd_top7_5;
string motd_top7_6;
string motd_bottom;

//
//  I N I T  W O R L D
//
//  Initialize the motd strings
//
void () motd_init_world =
{
    motd_top1 = "€‚ΓμαξÒιξη ΓÒΝοδ«« Φ–®’€‚\n";
    motd_top2 = "€‚ΓμαξÒιξη ΓÒΝοδ«« Φ–®’€‚\n\n";
    motd_top3 = "€‚ΓμαξÒιξη ΓÒΝοδ«« Φ–®’€‚\nBug reports   crbug@mpog.com \n\n";
    motd_top4 = "€‚ΓμαξÒιξη ΓÒΝοδ«« Φ–®’€‚\nhttp://www.mpog.com/clanring/crmod\nBug reports   crbug@mpog.com \n\n";
    motd_top5 = "€‚ΓμαξÒιξη ΓÒΝοδ«« Φ–®’€‚\n       and Παυμ Βαλες   pbaker@mpog.com\nhttp://www.mpog.com/clanring/crmod\nBug reports   crbug@mpog.com \n\n";
    motd_top6 = "€‚ΓμαξÒιξη ΓÒΝοδ«« Φ–®’€‚\nWritten by Κ®Π® Ηςοσσναξ jpg@ai.mit.edu\n       and Παυμ Βαλες   pbaker@mpog.com\nhttp://www.mpog.com/clanring/crmod\nBug reports   crbug@mpog.com \n\n";
    motd_top7_1 = "€‚ΓμαξÒιξη ΓÒΝοδ«« Φ–®’€‚\n\nWritten by Κ®Π® Ηςοσσναξ jpg@ai.mit.edu\n       and Παυμ Βαλες   pbaker@mpog.com\nhttp://www.mpog.com/clanring/crmod\nBug reports   crbug@mpog.com \n\n";
    motd_top7_2 = "€‚ClanRing CRMod++ Φ΄®°€‚\n\nWritten by κ.π. ηÒ’σσν–ξ jpgΐai.mit.edu\n       and ΠΑΥΜ ΒΑΛΕÒ   pbaker@mpog.com\nhttpΊ――www.mpog.com/clanring/crmod\nBug reports  ­crbug@mpog.com­\n\n";
    motd_top7_3 = "€‚ClanRing ΓÒΝοδ«« V4®0€‚\n\nWritten by Κπ. ης’Σσν–ξ jpgΐai.mit.edu\n       and P–υl B–λ•r   pbakerΐmpog.com\nhttpΊ――www®mpog®com/clanring/crmod\nBug reports  άcrbug@mpog.com―\n\n";
    motd_top7_4 = "€‚ΐΜ–Ξς“ΞΗ CRMod++ Φ–®’€‚\n\nWritten by κ.Π ης’σΣν–ξ jpgΐai®mit®edu\n       and p–ΥL b–Λ•R   pbakerΐmpog®com\nhttpΊ――www®mpog®com―clanring―crmod\nBug reports  Ιcrbug@mpog.comΙ\n\n";
    motd_top7_5 = "€‚ΐΜ–Ξς“ΞΗ ΓÒΝοδ«« V΄.°€‚\n\nWritten by κ.π. ης’σσΝ–ξ jpg@ai®mit®edu\n       and πAuL βAkEr   pbakerΐmpog®com\nhttp://www.mpog.com.clanring.crmod\nBug reports  ―crbug@mpog.comά\n\n";
    motd_top7_6 = "€‚ΓμαξÒιξη CRMod++ Φ4.0€‚\n\nWritten by Κ®Π® ης’σσν–Ξ jpg@ai®mit®edu\n       and ΠaUl ΒaKeR   pbaker@mpog®com\nhttp://www.mpog.com―clanring―crmod\nBug reports  ­crbug@mpog.com­\n\n";
    motd_bottom = "€‚";
};

void () motd_think =
{
		
    if ((self.count == 0) && (self.owner.style & ELOHIM_MOTD))
    {
	remove(self);
	return;
    }
    self.owner.style = self.owner.style | ELOHIM_MOTD;

    if (self.count < 26)
    {
	
	if (self.count == 0)
	{
	    centerprint(self.owner, "no bots"); // to kick stoogebots
	    centerprint(self.owner, "€‚\n\n\n\n");
	}

	else if (self.count == 1)
	    centerprint(self.owner, "€‚\n\n\n\n");
	else if (self.count == 2)
	    centerprint(self.owner, "€‚\n\n\n\n");
	else if (self.count == 3)
	    centerprint(self.owner, "€‚\n\n\n\n");
	else if (self.count == 4)
	    centerprint(self.owner, "€‚\n\n\n\n");
	else if (self.count == 5)
	    centerprint(self.owner, "€‚\n\n\n\n");
	else if (self.count == 6)
	    centerprint(self.owner, "€‚\n\n\n\n");
	else if (self.count == 7)
	    centerprint(self.owner, "€‚\n\n\n\n");
	else if (self.count == 8)
	    centerprint(self.owner, "€‚\n\n\n\n");
	else if (self.count == 9)
	    centerprint(self.owner, "€‚Ò€‚\n\n\n\n");
	else if (self.count == 10)
	    centerprint(self.owner, "€‚ ΓÒΝο€‚\n\n\n\n");
	else if (self.count == 11)
	    centerprint(self.owner, "€‚ξη ΓÒΝοδ«€‚\n\n\n\n");
	else if (self.count == 12)
	    centerprint(self.owner, "€‚Òιξη ΓÒΝοδ«« €‚\n\n\n\n");
	else if (self.count == 13)
	    centerprint(self.owner, "€‚αξÒιξη ΓÒΝοδ«« Φ–€‚\n\n\n\n");
	else if (self.count == 14)
	    centerprint2(self.owner, motd_top1, "\n\n\n");
	else if (self.count == 15)
	    centerprint3(self.owner, motd_top1, motd_bottom, "\n\n\n");
	else if (self.count == 16)
	    centerprint4(self.owner, motd_top1, USER_MOTD5_1, motd_bottom, "\n\n");
	else if (self.count == 17)
	    centerprint5(self.owner, motd_top1, USER_MOTD4_1, USER_MOTD5_1, motd_bottom, "\n");
	else if (self.count == 18)
	    centerprint5(self.owner, motd_top1, USER_MOTD3_1, USER_MOTD4_1, USER_MOTD5_1, motd_bottom);
	else if (self.count == 19)
	    centerprint6(self.owner, motd_top1, USER_MOTD2_1, USER_MOTD3_1, USER_MOTD4_1, USER_MOTD5_1, motd_bottom);
	else if (self.count == 20)
	    centerprint7(self.owner, motd_top1, USER_MOTD1_1, USER_MOTD2_1, USER_MOTD3_1, USER_MOTD4_1, USER_MOTD5_1, motd_bottom);
	else if (self.count == 21)
	    centerprint7(self.owner, motd_top2, USER_MOTD1_1, USER_MOTD2_1, USER_MOTD3_1, USER_MOTD4_1, USER_MOTD5_1, motd_bottom);
	else if (self.count == 22)
	    centerprint7(self.owner, motd_top3, USER_MOTD1_1, USER_MOTD2_1, USER_MOTD3_1, USER_MOTD4_1, USER_MOTD5_1, motd_bottom);
	else if (self.count == 23)
	    centerprint7(self.owner, motd_top4, USER_MOTD1_1, USER_MOTD2_1, USER_MOTD3_1, USER_MOTD4_1, USER_MOTD5_1, motd_bottom);
	else if (self.count == 24)
	    centerprint7(self.owner, motd_top5, USER_MOTD1_1, USER_MOTD2_1, USER_MOTD3_1, USER_MOTD4_1, USER_MOTD5_1, motd_bottom);
	else if (self.count == 25)
	    centerprint7(self.owner, motd_top6, USER_MOTD1_1, USER_MOTD2_1, USER_MOTD3_1, USER_MOTD4_1, USER_MOTD5_1, motd_bottom);

	self.nextthink = time + 0.1;
	if (self.count == 15 + NUM_USER_MOTD_LINES)
	    self.count = 21;
	else
	    self.count = self.count + 1;
    }
    else
    {
	// CRMOD - so people can stop motd
	if (self.owner.button0 != 0 || self.owner.button2 != 0)
		self.cnt = 5;
	// CRMOD END

	if (self.cnt == 5)
	{
	    self.owner.style = self.owner.style - ELOHIM_MOTD;
			centerprint(self.owner, " ");
		remove (self);
	}
	else
	{
	    if (self.count == 26)
	    {
		centerprint7(self.owner, motd_top7_1, USER_MOTD1_1, USER_MOTD2_1, USER_MOTD3_1, USER_MOTD4_1, USER_MOTD5_1, motd_bottom);
		self.cnt = self.cnt + 1;
	    }
	    else if (self.count == 27)
		centerprint7(self.owner, motd_top7_2, USER_MOTD1_2, USER_MOTD2_2, USER_MOTD3_2, USER_MOTD4_2, USER_MOTD5_2, motd_bottom);
	    else if (self.count == 28)
		centerprint7(self.owner, motd_top7_3, USER_MOTD1_3, USER_MOTD2_3, USER_MOTD3_3, USER_MOTD4_3, USER_MOTD5_3, motd_bottom);
	    else if (self.count == 29)
		centerprint7(self.owner, motd_top7_4, USER_MOTD1_4, USER_MOTD2_4, USER_MOTD3_4, USER_MOTD4_4, USER_MOTD5_4, motd_bottom);
	    else if (self.count == 30)
		centerprint7(self.owner, motd_top7_5, USER_MOTD1_5, USER_MOTD2_5, USER_MOTD3_5, USER_MOTD4_5, USER_MOTD5_5, motd_bottom);
	    else if (self.count == 31)
		centerprint7(self.owner, motd_top7_6, USER_MOTD1_6, USER_MOTD2_6, USER_MOTD3_6, USER_MOTD4_6, USER_MOTD5_6, motd_bottom);

	    if (self.count == 31)
		self.count = 26;
	    else
		self.count = self.count + 1;

	    self.nextthink = time + 0.5;
	}
    }
};

//
//  C R E A T E
//
//  Create an entity to display the MOTD for 5 seconds (plus a bit).
//
void () motd_create =
{
    local entity intro;

    intro = utils_make_scheduled_event(motd_think, 0.5);
    intro.count = 0;
    intro.cnt = 0;
};


