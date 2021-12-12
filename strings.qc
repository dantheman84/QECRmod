//
// Strings.qc
//
// A bunch of routines for returning various strings.
// Several routines were inspired by the clanring server mod.
//
// All code by J.P. Grossman unless otherwise commented.
//

//
//  F T O S
//
//  Some numbers have been hard-coded to avoid the problems associated with
//  a single ftos buffer.
//
string (float n) strings_ftos =
{
    if (n == 1)
        return "1 ";
    if (n == 2)
        return "2 ";
    if (n == 3)
        return "3 ";
    if (n == 4)
        return "4 ";
    if (n == 5)
        return "5 ";
    if (n == 6)
        return "6 ";
    if (n == 7)
        return "7 ";
    if (n == 8)
        return "8 ";
    if (n == 9)
        return "9 ";
    if (n == 10)
        return "10";
    if (n == 11)
        return "11";
    if (n == 12)
        return "12";
    if (n == 13)
        return "13";
    if (n == 14)
        return "14";
    if (n == 15)
        return "15";
    if (n == 20)
        return "20";
    if (n == 25)
        return "25";
    if (n == 30)
        return "30";
    return "???";
};

//
//  F T O S  G O L D
//
//  Return some gold number strings.
//
string (float n) strings_ftos_gold =
{
    if (n == 0)
        return "’";
    if (n == 1)
        return "“";
    if (n == 2)
        return "”";
    if (n == 3)
        return "•";
    if (n == 4)
        return "–";
    if (n == 5)
        return "—";
    if (n == 6)
        return "˜";
    if (n == 7)
        return "™";
    if (n == 8)
        return "š";
    if (n == 9)
        return "›";
    return "?";
};

//
//  G E T  A R M O U R  V A L
//
//  Returns a string containing the amount of armour the player has.
//  Used for observer mode heads-up display.
//
string (entity e) strings_get_armour_val =
{
    if (e.items & IT_INVULNERABILITY)
        return "˜˜˜Ÿ";
    if (e.armorvalue <= 100)
    {
        if (e.armorvalue <= 0) return "None ";
        if (e.armorvalue <= 5) return "5  ";
        if (e.armorvalue <= 10) return "10 ";
        if (e.armorvalue <= 20) return "20 ";
        if (e.armorvalue <= 30) return "30 ";
        if (e.armorvalue <= 40) return "40 ";
        if (e.armorvalue <= 50) return "50 ";
        if (e.armorvalue <= 60) return "60 ";
        if (e.armorvalue <= 70) return "70 ";
        if (e.armorvalue <= 80) return "80 ";
        if (e.armorvalue <= 90) return "90 ";
        return "100";
    }
    else
    {
        if (e.armorvalue <= 110) return "110";
        if (e.armorvalue <= 120) return "120";
        if (e.armorvalue <= 130) return "130";
        if (e.armorvalue <= 140) return "140";
        if (e.armorvalue <= 150) return "150";
        if (e.armorvalue <= 160) return "160";
        if (e.armorvalue <= 170) return "170";
        if (e.armorvalue <= 180) return "180";
        if (e.armorvalue <= 190) return "190";
        if (e.armorvalue <= 200) return "200";
        return "???";
    }
};

//
//  G E T  A R M O U R  T Y P E
//
//  Returns one of
//
//     "Armour: R "
//     "Armour: Y "
//     "Armour: G "
//     "Armour: "
//
//  Used for observer mode heads-up display.
//
string (entity e) strings_get_armour_type =
{

    if (e.items & IT_INVULNERABILITY) return "Áòíïòº ";
    if (e.armortype == 0.8) return "Áòíïòº R ";
    if (e.armortype == 0.6) return "Áòíïòº Y ";
    if (e.armortype == 0.3) return "Áòíïòº G ";
    return "Áòíïòº ";
};

//
//  G E T  W E A P O N
//
//  Returns "[QOR] <weapon>\n" where [QOR] are the quad, ring and
//  suit flags (either present or absent) and <weapon> is the player's
//  weapon (I'm sure you were having trouble figuring that one out).
//  Used for observer mode heads-up display.
//
string (entity e) strings_get_weapon =
{
    if (e.items & IT_SUIT)
    {
        if (e.items & IT_QUAD)
        {
            if (e.items & IT_INVISIBILITY)
            {
                if (e.weapon == 32) return " Q’ƒ‘ Rocket Launcher\n";
                if (e.weapon == 64) return " Q’ƒ‘ Lightning Gun\n";
                if (e.weapon == 16) return " Q’ƒ‘ Grenade Launcher\n";
                if (e.weapon == 8) return " Q’ƒ‘ Super Nailgun\n";
                if (e.weapon == 2) return " Q’ƒ‘ Super Shotgun\n";
                if (e.weapon == 4) return " Q’ƒ‘ Nailgun\n";
                if (e.weapon == 1) return " Q’ƒ‘ Shotgun\n";
                if (e.weapon == 4096) return " Q’ƒ‘ Axe\n";
                return " Q’ƒ‘ No Weapon\n";
            }
            else
            {
                if (e.weapon == 32) return " Q ƒ‘ Rocket Launcher\n";
                if (e.weapon == 64) return " Q ƒ‘ Lightning Gun\n";
                if (e.weapon == 16) return " Q ƒ‘ Grenade Launcher\n";
                if (e.weapon == 8) return " Q ƒ‘ Super Nailgun\n";
                if (e.weapon == 2) return " Q ƒ‘ Super Shotgun\n";
                if (e.weapon == 4) return " Q ƒ‘ Nailgun\n";
                if (e.weapon == 1) return " Q ƒ‘ Shotgun\n";
                if (e.weapon == 4096) return " Q ƒ‘ Axe\n";
                return " Q ƒ‘ No Weapon\n";
            }
        }
        else
        {
            if (e.items & IT_INVISIBILITY)
            {
                if (e.weapon == 32) return "  ’ƒ‘ Rocket Launcher\n";
                if (e.weapon == 64) return "  ’ƒ‘ Lightning Gun\n";
                if (e.weapon == 16) return "  ’ƒ‘ Grenade Launcher\n";
                if (e.weapon == 8) return "  ’ƒ‘ Super Nailgun\n";
                if (e.weapon == 2) return "  ’ƒ‘ Super Shotgun\n";
                if (e.weapon == 4) return "  ’ƒ‘ Nailgun\n";
                if (e.weapon == 1) return "  ’ƒ‘ Shotgun\n";
                if (e.weapon == 4096) return "  ’ƒ‘ Axe\n";
                return "    ’ƒ‘ No Weapon\n";
            }
            else
            {
                if (e.weapon == 32) return "   ƒ‘ Rocket Launcher\n";
                if (e.weapon == 64) return "   ƒ‘ Lightning Gun\n";
                if (e.weapon == 16) return "   ƒ‘ Grenade Launcher\n";
                if (e.weapon == 8) return "   ƒ‘ Super Nailgun\n";
                if (e.weapon == 2) return "   ƒ‘ Super Shotgun\n";
                if (e.weapon == 4) return "   ƒ‘ Nailgun\n";
                if (e.weapon == 1) return "   ƒ‘ Shotgun\n";
                if (e.weapon == 4096) return "   ƒ‘ Axe\n";
                return "     ƒ‘ No Weapon\n";
            }
        }
    }
    else
    {
        if (e.items & IT_QUAD)
        {
            if (e.items & IT_INVISIBILITY)
            {
                if (e.weapon == 32) return " Q’ ‘ Rocket Launcher\n";
                if (e.weapon == 64) return " Q’ ‘ Lightning Gun\n";
                if (e.weapon == 16) return " Q’ ‘ Grenade Launcher\n";
                if (e.weapon == 8) return " Q’ ‘ Super Nailgun\n";
                if (e.weapon == 2) return " Q’ ‘ Super Shotgun\n";
                if (e.weapon == 4) return " Q’ ‘ Nailgun\n";
                if (e.weapon == 1) return " Q’ ‘ Shotgun\n";
                if (e.weapon == 4096) return " Q’ ‘ Axe\n";
                return " Q’ ‘ No Weapon\n";
            }
            else
            {
                if (e.weapon == 32) return " Q  ‘ Rocket Launcher\n";
                if (e.weapon == 64) return " Q  ‘ Lightning Gun\n";
                if (e.weapon == 16) return " Q  ‘ Grenade Launcher\n";
                if (e.weapon == 8) return " Q  ‘ Super Nailgun\n";
                if (e.weapon == 2) return " Q  ‘ Super Shotgun\n";
                if (e.weapon == 4) return " Q  ‘ Nailgun\n";
                if (e.weapon == 1) return " Q  ‘ Shotgun\n";
                if (e.weapon == 4096) return " Q  ‘ Axe\n";
                return " Q  ‘ No Weapon\n";
            }
        }
        else
        {
            if (e.items & IT_INVISIBILITY)
            {
                if (e.weapon == 32) return "  ’ ‘ Rocket Launcher\n";
                if (e.weapon == 64) return "  ’ ‘ Lightning Gun\n";
                if (e.weapon == 16) return "  ’ ‘ Grenade Launcher\n";
                if (e.weapon == 8) return "  ’ ‘ Super Nailgun\n";
                if (e.weapon == 2) return "  ’ ‘ Super Shotgun\n";
                if (e.weapon == 4) return "  ’ ‘ Nailgun\n";
                if (e.weapon == 1) return "  ’ ‘ Shotgun\n";
                if (e.weapon == 4096) return "  ’ ‘ Axe\n";
                return "    ’ ‘ No Weapon\n";
            }
            else
            {
                if (e.weapon == 32) return "    ‘ Rocket Launcher\n";
                if (e.weapon == 64) return "    ‘ Lightning Gun\n";
                if (e.weapon == 16) return "    ‘ Grenade Launcher\n";
                if (e.weapon == 8) return "    ‘ Super Nailgun\n";
                if (e.weapon == 2) return "    ‘ Super Shotgun\n";
                if (e.weapon == 4) return "    ‘ Nailgun\n";
                if (e.weapon == 1) return "    ‘ Shotgun\n";
                if (e.weapon == 4096) return "    ‘ Axe\n";
                return "      ‘ No Weapon\n";
            }
        }
    }
};

//
//  G E T  H E A L T H  A M M O
//
//  Returns "  Health: <amount>   Ammo: "
//
//  The nested ifs are to speed things up.  Used for observer mode
//  heads-up display.
//
string (entity e) strings_get_health_ammo =
{
    if (e.health <= 125)
    {
        if (e.health <= 65)
        {
            if (e.health <= 30)
            {
                if (e.health <= 0)
                    return "  Èåáìôèº 0    Áííïº ";
                if (e.health <= 5)
                    return "  Èåáìôèº 5    Áííïº ";
                if (e.health <= 10)
                    return "  Èåáìôèº 10   Áííïº ";
                if (e.health <= 15)
                    return "  Èåáìôèº 15   Áííïº ";
                if (e.health <= 20)
                    return "  Èåáìôèº 20   Áííïº ";
                if (e.health <= 25)
                    return "  Èåáìôèº 25   Áííïº ";
                return "  Èåáìôèº 30   Áííïº ";
            }
            else
            {
                if (e.health <= 35)
                    return "  Èåáìôèº 35   Áííïº ";
                if (e.health <= 40)
                    return "  Èåáìôèº 40   Áííïº ";
                if (e.health <= 45)
                    return "  Èåáìôèº 45   Áííïº ";
                if (e.health <= 50)
                    return "  Èåáìôèº 50   Áííïº ";
                if (e.health <= 55)
                    return "  Èåáìôèº 55   Áííïº ";
                if (e.health <= 60)
                    return "  Èåáìôèº 60   Áííïº ";
                return "  Èåáìôèº 65   Áííïº ";
            }
        }
        else
        {
            if (e.health <= 95)
            {
                if (e.health <= 70)
                    return "  Èåáìôèº 70   Áííïº ";
                if (e.health <= 75)
                    return "  Èåáìôèº 75   Áííïº ";
                if (e.health <= 80)
                    return "  Èåáìôèº 80   Áííïº ";
                if (e.health <= 85)
                    return "  Èåáìôèº 85   Áííïº ";
                if (e.health <= 90)
                    return "  Èåáìôèº 90   Áííïº ";
                return "  Èåáìôèº 95   Áííïº ";
            }
            else
            {
                if (e.health <= 100)
                    return "  Èåáìôèº 100  Áííïº ";
                if (e.health <= 105)
                    return "  Èåáìôèº 105  Áííïº ";
                if (e.health <= 110)
                    return "  Èåáìôèº 110  Áííïº ";
                if (e.health <= 115)
                    return "  Èåáìôèº 115  Áííïº ";
                if (e.health <= 120)
                    return "  Èåáìôèº 120  Áííïº ";
                return "  Èåáìôèº 125  Áííïº ";
            }
        }
    }
    else
    {
        if (e.health <= 195)
        {
            if (e.health <= 160)
            {
                if (e.health <= 130)
                    return "  Èåáìôèº 130  Áííïº ";
                if (e.health <= 135)
                    return "  Èåáìôèº 135  Áííïº ";
                if (e.health <= 140)
                    return "  Èåáìôèº 140  Áííïº ";
                if (e.health <= 145)
                    return "  Èåáìôèº 145  Áííïº ";
                if (e.health <= 150)
                    return "  Èåáìôèº 150  Áííïº ";
                if (e.health <= 155)
                    return "  Èåáìôèº 155  Áííïº ";
                return "  Èåáìôèº 160  Áííïº ";
            }
            else
            {
                if (e.health <= 165)
                    return "  Èåáìôèº 165  Áííïº ";
                if (e.health <= 170)
                    return "  Èåáìôèº 170  Áííïº ";
                if (e.health <= 175)
                    return "  Èåáìôèº 175  Áííïº ";
                if (e.health <= 180)
                    return "  Èåáìôèº 180  Áííïº ";
                if (e.health <= 185)
                    return "  Èåáìôèº 185  Áííïº ";
                if (e.health <= 190)
                    return "  Èåáìôèº 190  Áííïº ";
                return "  Èåáìôèº 195  Áííïº ";
            }
        }
        else
        {
            if (e.health <= 225)
            {
                if (e.health <= 200)
                    return "  Èåáìôèº 200  Áííïº ";
                if (e.health <= 205)
                    return "  Èåáìôèº 205  Áííïº ";
                if (e.health <= 210)
                    return "  Èåáìôèº 210  Áííïº ";
                if (e.health <= 215)
                    return "  Èåáìôèº 215  Áííïº ";
                if (e.health <= 220)
                    return "  Èåáìôèº 220  Áííïº ";
                return "  Èåáìôèº 225  Áííïº ";
            }
            else
            {
                if (e.health <= 230)
                    return "  Èåáìôèº 230  Áííïº ";
                if (e.health <= 235)
                    return "  Èåáìôèº 235  Áííïº ";
                if (e.health <= 240)
                    return "  Èåáìôèº 240  Áííïº ";
                if (e.health <= 245)
                    return "  Èåáìôèº 245  Áííïº ";
                if (e.health <= 600)
                    return "  Èåáìôèº 250  Áííïº ";
                return "  Èåáìôèº 666  Áííïº ";
            }
        }
    }
};

//
//  G E T  T E A M N A M E
//
//  Return the colour string corresponding to a given team.
//
string (float num) strings_get_teamname =
{
    if (num == 1)
        return "Brown team";
    if (num == 2)
        return "Light Blue team";
    if (num == 3)
        return "Green team";
    if (num == 4)
        return "Red team";
    if (num == 5)
        return "Olive team";
    if (num == 6)
        return "Gold team";
    if (num == 7)
        return "Flesh team";
    if (num == 8)
        return "Lavender team";
    if (num == 9)
        return "Purple team";
    if (num == 10)
        return "Beige team";
    if (num == 11)
        return "Aqua team";
    if (num == 12)
        return "Yellow team";
    if (num == 13)
        return "Blue team";
    return "???? team"; // shouldn't happen
};

//
//  G E T  T E A M N A M E  B R O N Z E
//
//  Same as above, but in bronze letters.
//  My God, I've gone insane.
//
string (float num) strings_get_teamname_bronze =
{
    if (num == 1)
        return "Âòï÷î ôåáí";
    if (num == 2)
        return "Ìéçèô Âìõå ôåáí";
    if (num == 3)
        return "Çòååî ôåáí";
    if (num == 4)
        return "Òåä ôåáí";
    if (num == 5)
        return "Ïìéöå ôåáí";
    if (num == 6)
        return "Çïìä ôåáí";
    if (num == 7)
        return "Æìåóè ôåáí";
    if (num == 8)
        return "Ìáöåîäåò ôåáí";
    if (num == 9)
        return "Ğõòğìå ôåáí";
    if (num == 10)
        return "Âåéçå ôåáí";
    if (num == 11)
        return "Áñõá ôåáí";
    if (num == 12)
        return "Ùåììï÷ ôåáí";
    if (num == 13)
        return "Âìõå ôåáí";
    return "¿¿¿¿ ôåáí"; // shouldn't happen
};

//
//  G E T  T E A M N A M E 2
//
//  Return the colour string corresponding to a given team.
//  The string contains EXACTLY 10 characters.
//
string (float num) strings_get_teamname2 =
{
    if (num == 1)
        return "Brown     ";
    if (num == 2)
        return "Light Blue";
    if (num == 3)
        return "Green     ";
    if (num == 4)
        return "Red       ";
    if (num == 5)
        return "Olive     ";
    if (num == 6)
        return "Gold      ";
    if (num == 7)
        return "Flesh     ";
    if (num == 8)
        return "Lavender  ";
    if (num == 9)
        return "Purple    ";
    if (num == 10)
        return "Beige     ";
    if (num == 11)
        return "Aqua      ";
    if (num == 12)
        return "Yellow    ";
    if (num == 13)
        return "Blue      ";
    return "????      "; // shouldn't happen
};

//
//  G E T  T E A M N A M E 3
//
//  For when 10 characters is too many.. I can't believe I'm doing this.
//
string (float num) strings_get_teamname3 =
{
    if (num == 1)
        return "Brown    ";
    if (num == 2)
        return "Lite Blue";
    if (num == 3)
        return "Green    ";
    if (num == 4)
        return "Red      ";
    if (num == 5)
        return "Olive    ";
    if (num == 6)
        return "Gold     ";
    if (num == 7)
        return "Flesh    ";
    if (num == 8)
        return "Lavender ";
    if (num == 9)
        return "Purple   ";
    if (num == 10)
        return "Beige    ";
    if (num == 11)
        return "Aqua     ";
    if (num == 12)
        return "Yellow   ";
    if (num == 13)
        return "Blue     ";
    return "????     "; // shouldn't happen
};

//
//  G E T  T E A M N A M E  U P  B Y
//
//  Return the "colour up by " string corresponding to a given team.
//
string (float num) strings_get_teamname_up_by =
{
    if (num == 1)
        return "        Brown up by ";
    if (num == 2)
        return "   Light Blue up by ";
    if (num == 3)
        return "        Green up by ";
    if (num == 4)
        return "          Red up by ";
    if (num == 5)
        return "        Olive up by ";
    if (num == 6)
        return "         Gold up by ";
    if (num == 7)
        return "        Flesh up by ";
    if (num == 8)
        return "     Lavender up by ";
    if (num == 9)
        return "       Purple up by ";
    if (num == 10)
        return "        Beige up by ";
    if (num == 11)
        return "         Aqua up by ";
    if (num == 12)
        return "       Yellow up by ";
    if (num == 13)
        return "         Blue up by ";
    return "         ???? up by "; // shouldn't happen
};

//
//  G E T  M A P N A M E
//
//  Return the nth map name.
//
string (float mapnum) strings_get_mapname =
{
    if (mapnum < 10)
    {
        if (mapnum == 0)
            return "start";
        if (mapnum == 1)
            return "start0";
        if (mapnum == 2)
            return "start1";
        if (mapnum == 3)
            return "end";
        if (mapnum == 4)
            return "aerowalk";
        if (mapnum == 5)
            return "ztndm3";
        if (mapnum == 6)
            return "ztndm4";
	if (mapnum == 7)
            return "ultrav";
	if (mapnum == 8)
            return "q3dm6ish";   
	if (mapnum == 9)
            return "aggressr";                                                            
        return "";
    }
    if (mapnum < 20)
    {
        if (mapnum == 11)
            return "e1m1";
        if (mapnum == 12)
            return "e1m2";
        if (mapnum == 13)
            return "e1m3";
        if (mapnum == 14)
            return "e1m4";
        if (mapnum == 15)
            return "e1m5";
        if (mapnum == 16)
            return "e1m6";
        if (mapnum == 17)
            return "e1m7";
        if (mapnum == 18)
            return "e1m8";
        return "";
    }
    if (mapnum < 30)
    {
        if (mapnum == 21)
            return "e2m1";
        if (mapnum == 22)
            return "e2m2";
        if (mapnum == 23)
            return "e2m3";
        if (mapnum == 24)
            return "e2m4";
        if (mapnum == 25)
            return "e2m5";
        if (mapnum == 26)
            return "e2m6";
        if (mapnum == 27)
            return "e2m7";
        return "";
    }
    if (mapnum < 40)
    {
        if (mapnum == 31)
            return "e3m1";
        if (mapnum == 32)
            return "e3m2";
        if (mapnum == 33)
            return "e3m3";
        if (mapnum == 34)
            return "e3m4";
        if (mapnum == 35)
            return "e3m5";
        if (mapnum == 36)
            return "e3m6";
        if (mapnum == 37)
            return "e3m7";
        return ""; 
    }
    if (mapnum < 50)
    {
        if (mapnum == 41)
            return "e4m1";
        if (mapnum == 42)
            return "e4m2";
        if (mapnum == 43)
            return "e4m3";
        if (mapnum == 44)
            return "e4m4";
        if (mapnum == 45)
            return "e4m5";
        if (mapnum == 46)
            return "e4m6";
        if (mapnum == 47)
            return "e4m7";
        if (mapnum == 48)
            return "e4m8";
        return ""; 
    }
    if (mapnum < 60)
    {
        if (mapnum == 51)
            return "dm1";
        if (mapnum == 52)
            return "dm2";
        if (mapnum == 53)
            return "dm3";
        if (mapnum == 54)
            return "dm4";
        if (mapnum == 55)
            return "dm5";
        if (mapnum == 56)
            return "dm6";
        if (mapnum == 57)
            return "dm7";  
        if (mapnum == 58)
            return "dm8";
        if (mapnum == 59)
            return "death32c";  
        return "";
    }
    return array_get_user_map(mapnum - 60);
};

//
//  G E T  M O D E
//
//  Returns "Normal", "Practice", or "Match".
//
string (float mode) strings_get_mode =
{
    if (mode == 0)
        return "Normal";
    if (mode == 1)
        return "Practice";
    return "Match";
};

//
//  S Z P L U R A L
//
//  Helper string for printing.
//
string (float n) strings_szplural =
{
    if (n == 1)
        return "\n";
    return "s\n";
};


