//
// Userdefs.qc
//
// This file contains customizations for the Elohim mod.
// The strings are all buffers that are written to by crmake.
//
// All code by J.P. Grossman unless otherwise commented.
//

float (string s) utils_stof;

// Maximum number of suicides allowed per level in normal and match modes
float ELOHIM_MAX_SUICIDES;

// Intro message
string USER_MOTD1_1, USER_MOTD2_1, USER_MOTD3_1, USER_MOTD4_1, USER_MOTD5_1;
string USER_MOTD1_2, USER_MOTD2_2, USER_MOTD3_2, USER_MOTD4_2, USER_MOTD5_2;
string USER_MOTD1_3, USER_MOTD2_3, USER_MOTD3_3, USER_MOTD4_3, USER_MOTD5_3;
string USER_MOTD1_4, USER_MOTD2_4, USER_MOTD3_4, USER_MOTD4_4, USER_MOTD5_4;
string USER_MOTD1_5, USER_MOTD2_5, USER_MOTD3_5, USER_MOTD4_5, USER_MOTD5_5;
string USER_MOTD1_6, USER_MOTD2_6, USER_MOTD3_6, USER_MOTD4_6, USER_MOTD5_6;
float NUM_USER_MOTD_LINES;

// QSmack password
float QSMACK1, QSMACK2, QSMACK3, QSMACK4, QSMACK5;

//
//  I N I T  W O R L D
//
//  Create all string constants
//
void () userdefs_init_world =
{
	local string temp;

	// Number of suicides
	temp = "3 stag";
	ELOHIM_MAX_SUICIDES = utils_stof(temp);

	// QSMACK
	temp = "100 qtag1";
	QSMACK1 = utils_stof(temp);
	temp = "100 qtag2";
	QSMACK2 = utils_stof(temp);
	temp = "100 qtag3";
	QSMACK3 = utils_stof(temp);
	temp = "100 qtag4";
	QSMACK4 = utils_stof(temp);
	temp = "100 qtag5";
	QSMACK5 = utils_stof(temp);

	// User defined maps
	array_set_user_map(0, "                ltag0");
	array_set_user_map(1, "                ltag1");
	array_set_user_map(2, "                ltag2");
	array_set_user_map(3, "                ltag3");
	array_set_user_map(4, "                ltag4");
	array_set_user_map(5, "                ltag5");
	array_set_user_map(6, "                ltag6");
	array_set_user_map(7, "                ltag7");
	array_set_user_map(8, "                ltag8");
	array_set_user_map(9, "                ltag9");

	// Intro message
	temp = "0 ntag";
	NUM_USER_MOTD_LINES = utils_stof(temp);

	// frame 1
	USER_MOTD1_1 = "                                         mtag11";
	USER_MOTD2_1 = "                                         mtag21";
	USER_MOTD3_1 = "                                         mtag31";
	USER_MOTD4_1 = "                                         mtag41";
	USER_MOTD5_1 = "                                         mtag51";

	// frame 2
	USER_MOTD1_2 = "                                         mtag12";
	USER_MOTD2_2 = "                                         mtag22";
	USER_MOTD3_2 = "                                         mtag32";
	USER_MOTD4_2 = "                                         mtag42";
	USER_MOTD5_2 = "                                         mtag52";

	// frame 3
	USER_MOTD1_3 = "                                         mtag13";
	USER_MOTD2_3 = "                                         mtag23";
	USER_MOTD3_3 = "                                         mtag33";
	USER_MOTD4_3 = "                                         mtag43";
	USER_MOTD5_3 = "                                         mtag53";

	// frame 4
	USER_MOTD1_4 = "                                         mtag14";
	USER_MOTD2_4 = "                                         mtag24";
	USER_MOTD3_4 = "                                         mtag34";
	USER_MOTD4_4 = "                                         mtag44";
	USER_MOTD5_4 = "                                         mtag54";

	// frame 5
	USER_MOTD1_5 = "                                         mtag15";
	USER_MOTD2_5 = "                                         mtag25";
	USER_MOTD3_5 = "                                         mtag35";
	USER_MOTD4_5 = "                                         mtag45";
	USER_MOTD5_5 = "                                         mtag55";

	// frame 6
	USER_MOTD1_6 = "                                         mtag16";
	USER_MOTD2_6 = "                                         mtag26";
	USER_MOTD3_6 = "                                         mtag36";
	USER_MOTD4_6 = "                                         mtag46";
	USER_MOTD5_6 = "                                         mtag56";
};

