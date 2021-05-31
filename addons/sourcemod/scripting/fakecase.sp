#pragma semicolon 1

#include <sourcemod>
#include <sdktools>
#include <sdkhooks>
#include <morecolors>

Handle SelectedKnife;
Handle SelectedWeapon;
Handle sm_notify_enable = INVALID_HANDLE;
Handle sm_fakecase_flag = INVALID_HANDLE;

Menu g_MainMenu = null;
Menu g_WeaponMenu = null;
Menu g_KnifeMenu = null;
Menu g_KnifeSkinMenu = null;

Menu g_AWPSkinsMenu = null;
Menu g_M4A1SkinsMenu = null;
Menu g_M4A4SkinsMenu = null;
Menu g_AK47SkinsMenu = null;

public Plugin myinfo =
{
	name = "[CSGO] Fake Case",
	author = "Edited & Fixed: Levi2288 | Main idea + Plugin: Tommie113",
	description = "Ability to open fake cases ingame",
	version = "2.0",
	url = "https://github.com/Bufika2288"
};

public void OnPluginStart()
{
	LoadTranslations("fakecase.phrases");
	LoadTranslations("common.phrases");

	RegConsoleCmd("sm_fakecase", FakeCaseCMD, "Open the FakeCase menu");
	RegConsoleCmd("sm_casefake", FakeCaseCMD, "Open the FakeCase menu");
	RegConsoleCmd("sm_case", FakeCaseCMD, "Open the FakeCase menu");
	RegConsoleCmd("sm_cases", FakeCaseCMD, "Open the FakeCase menu")
	
	sm_fakecase_flag = CreateConVar("sm_fakecase_flag", "a", "admin flag for fakecase (empty for all players)");
	sm_notify_enable = CreateConVar("sm_notify_enable", "1","Notify admins on fakecase opening");
	
	AutoExecConfig(true, "FakeCase");

	SelectedKnife = CreateArray(32);
	for(new i = 0; i < MAXPLAYERS; i++)
	{
		PushArrayString(SelectedKnife, "null");
	}
	
	SelectedWeapon = CreateArray(32);
	for(new i = 0; i < MAXPLAYERS; i++)
	{
		PushArrayString(SelectedWeapon, "null");
	}
}

public void OnMapStart()
{
	
	g_MainMenu = BuildMainMenu();
	g_WeaponMenu = BuildWeaponMenu();
	g_KnifeMenu = BuildKnifeMenu();
	g_KnifeSkinMenu = BuildSkinMenu();
	
	g_AWPSkinsMenu = BuildAWPMenu();
	g_M4A1SkinsMenu = BuildM4A1Menu();
	g_M4A4SkinsMenu = BuildM4A4Menu();
	g_AK47SkinsMenu = BuildAK47Menu();
}

public void OnMapEnd()
{
	if(g_KnifeMenu != INVALID_HANDLE)
	{
		delete(g_KnifeMenu);
		g_KnifeMenu = null;
	}

	if(g_KnifeSkinMenu != INVALID_HANDLE)
	{
		delete(g_KnifeSkinMenu);
		g_KnifeSkinMenu = null;
	}
	
	if(g_MainMenu != INVALID_HANDLE)
	{
		delete(g_MainMenu);
		g_MainMenu = null;
	}
	
	if(g_WeaponMenu != INVALID_HANDLE)
	{
		delete(g_WeaponMenu);
		g_WeaponMenu = null;
	}
}

public Action FakeCaseCMD(client, int args)
{	
	char sBuffer[32];
	GetConVarString(sm_fakecase_flag, sBuffer, sizeof(sBuffer));

	if (!CheckAdminFlags(client, ReadFlagString(sBuffer)))
	{
		PrintToChat(client, "%t", "No Access");
		return Plugin_Handled;
	}
	
	g_MainMenu.Display(client, MENU_TIME_FOREVER);
	
	return Plugin_Handled;
}

////////////////////////////////////////////////////
////////////////////MAIN_MEHU///////////////////////
////////////////////////////////////////////////////

Menu BuildMainMenu()
{
	char buffer[128];
	Menu menu = new Menu(Menu_Main);
	
	Format(buffer, sizeof(buffer), "%T", "Weapons", LANG_SERVER);
	menu.AddItem("Weapons", buffer);
	Format(buffer, sizeof(buffer), "%T", "Knifes", LANG_SERVER);
	menu.AddItem("Knifes", buffer);
	
	Format(buffer, sizeof(buffer), "%T", "Weapons Menu:", LANG_SERVER);
	menu.SetTitle(buffer);
	return menu;
	
}

public int Menu_Main(Menu menu, MenuAction action, int param1, int param2)
{
	if(action == MenuAction_Select)
	{
		char item[32];
		menu.GetItem(param2, item, sizeof(item));
		
		if (StrEqual(item, "Weapons")) 
			{
				g_WeaponMenu.Display(param1, MENU_TIME_FOREVER);
			}
				
		if (StrEqual(item, "Knifes")) 
			{
				g_KnifeMenu.Display(param1, MENU_TIME_FOREVER);
			}
	}
}
////////////////////////////////////////////////////
//////////////////////WEAPONS///////////////////////
////////////////////////////////////////////////////
Menu BuildWeaponMenu()
{
	char buffer[128];
	Menu menu = new Menu(Menu_Weapon);
	
	Format(buffer, sizeof(buffer), "%T", "AWP", LANG_SERVER);
	menu.AddItem("AWP", buffer);
	Format(buffer, sizeof(buffer), "%T", "M4A1", LANG_SERVER);
	menu.AddItem("M4A1", buffer);
	Format(buffer, sizeof(buffer), "%T", "M4A4", LANG_SERVER);
	menu.AddItem("M4A4", buffer);
	Format(buffer, sizeof(buffer), "%T", "AK-47", LANG_SERVER);
	menu.AddItem("AK-47", buffer);

	
	Format(buffer, sizeof(buffer), "%T", "Select weapon:", LANG_SERVER);
	menu.SetTitle(buffer);
	return menu;
}

public int Menu_Weapon(Menu menu, MenuAction action, int param1, int param2)
{
	if(action == MenuAction_Select)
	{
		char weapon_id[32];
		menu.GetItem(param2, weapon_id, sizeof(weapon_id));

		SetArrayString(SelectedWeapon, param1, weapon_id);
		
		if (StrEqual(weapon_id, "AWP")) 
			{
				g_AWPSkinsMenu.Display(param1, MENU_TIME_FOREVER);
			}
			
		if (StrEqual(weapon_id, "M4A1")) 
		{
			g_M4A1SkinsMenu.Display(param1, MENU_TIME_FOREVER);
		}
		
		if (StrEqual(weapon_id, "M4A4")) 
		{
			g_M4A4SkinsMenu.Display(param1, MENU_TIME_FOREVER);
		}
		
		if (StrEqual(weapon_id, "AK-47")) 
		{
			g_AK47SkinsMenu.Display(param1, MENU_TIME_FOREVER);
		}
	}
}

////////////////////////////////////////////////////
///////////////////////KNIFES///////////////////////
////////////////////////////////////////////////////

Menu BuildKnifeMenu()
{
	char buffer[128];
	Menu menu = new Menu(Menu_Knife);
	
	Format(buffer, sizeof(buffer), "%T", "Bayonet", LANG_SERVER);
	menu.AddItem("Bayonet", buffer);
	Format(buffer, sizeof(buffer), "%T", "Butterfly", LANG_SERVER);
	menu.AddItem("Butterfly", buffer);
	Format(buffer, sizeof(buffer), "%T", "Classic", LANG_SERVER);
	menu.AddItem("Classic", buffer);
	Format(buffer, sizeof(buffer), "%T", "Falchion knife", LANG_SERVER);
	menu.AddItem("Falchion knife", buffer);
	Format(buffer, sizeof(buffer), "%T", "Flip knife", LANG_SERVER);
	menu.AddItem("Flip knife", buffer);
	Format(buffer, sizeof(buffer), "%T", "Gut knife", LANG_SERVER);
	menu.AddItem("Gut knife", buffer);
	Format(buffer, sizeof(buffer), "%T", "Huntsman knife", LANG_SERVER);
	menu.AddItem("Huntsman knife", buffer);
	Format(buffer, sizeof(buffer), "%T", "Karambit", LANG_SERVER);
	menu.AddItem("Karambit", buffer);
	Format(buffer, sizeof(buffer), "%T", "M9 Bayonet", LANG_SERVER);
	menu.AddItem("M9 Bayonet", buffer);
	Format(buffer, sizeof(buffer), "%T", "Shadow Daggers", LANG_SERVER);
	menu.AddItem("Shadow Daggers", buffer);
	Format(buffer, sizeof(buffer), "%T", "Bowie", LANG_SERVER);
	menu.AddItem("Bowie", buffer);
	Format(buffer, sizeof(buffer), "%T", "Ursus", LANG_SERVER);
	menu.AddItem("Ursus", buffer);
	Format(buffer, sizeof(buffer), "%T", "Navaja", LANG_SERVER);
	menu.AddItem("Navaja", buffer);
	Format(buffer, sizeof(buffer), "%T", "Stiletto", LANG_SERVER);
	menu.AddItem("Stiletto", buffer);
	Format(buffer, sizeof(buffer), "%T", "Talon", LANG_SERVER);
	menu.AddItem("Talon", buffer);
	Format(buffer, sizeof(buffer), "%T", "Nomad", LANG_SERVER);
	menu.AddItem("Nomad", buffer);
	Format(buffer, sizeof(buffer), "%T", "Skeleton", LANG_SERVER);
	menu.AddItem("Skeleton", buffer);
	Format(buffer, sizeof(buffer), "%T", "Survival", LANG_SERVER);
	menu.AddItem("Survival", buffer);
	Format(buffer, sizeof(buffer), "%T", "Paracord", LANG_SERVER);
	menu.AddItem("Paracord", buffer);
	
	Format(buffer, sizeof(buffer), "%T", "Select knife:", LANG_SERVER);
	menu.SetTitle(buffer);
	return menu;
}

public int Menu_Knife(Menu menu, MenuAction action, int param1, int param2)
{
	if(action == MenuAction_Select)
	{
		char knife_id[32];
		menu.GetItem(param2, knife_id, sizeof(knife_id));

		SetArrayString(SelectedKnife, param1, knife_id);
		g_KnifeSkinMenu.Display(param1, MENU_TIME_FOREVER);
	}
}

////////////////////////////////////////////////////
//////////////////KNIFE SKINS///////////////////////
////////////////////////////////////////////////////

Menu BuildSkinMenu()
{
	char buffer[128];
	Menu menu = new Menu(Menu_Skin);
	Format(buffer, sizeof(buffer), "%T", "Blue Steel", LANG_SERVER);
	menu.AddItem("Blue Steel", buffer);
	Format(buffer, sizeof(buffer), "%T", "Boreal Forest", LANG_SERVER);
	menu.AddItem("Boreal Forest", buffer);
	Format(buffer, sizeof(buffer), "%T", "Case Hardened", LANG_SERVER);
	menu.AddItem("Case Hardened", buffer);
	Format(buffer, sizeof(buffer), "%T", "Damascus Steel", LANG_SERVER);
	menu.AddItem("Damascus Steel", buffer);
	Format(buffer, sizeof(buffer), "%T", "Doppler", LANG_SERVER);
	menu.AddItem("Doppler", buffer);
	Format(buffer, sizeof(buffer), "%T", "Fade", LANG_SERVER);
	menu.AddItem("Fade", buffer);
	Format(buffer, sizeof(buffer), "%T", "Forest DDPAT", LANG_SERVER);
	menu.AddItem("Forest DDPAT", buffer);
	Format(buffer, sizeof(buffer), "%T", "Marble Fade", LANG_SERVER);
	menu.AddItem("Marble Fade", buffer);
	Format(buffer, sizeof(buffer), "%T", "Safari Mesh", LANG_SERVER);
	menu.AddItem("Safari Mesh", buffer);
	Format(buffer, sizeof(buffer), "%T", "Scorched", LANG_SERVER);
	menu.AddItem("Scorched", buffer);
	Format(buffer, sizeof(buffer), "%T", "Slaughter", LANG_SERVER);
	menu.AddItem("Slaughter", buffer);
	Format(buffer, sizeof(buffer), "%T", "Stained", LANG_SERVER);
	menu.AddItem("Stained", buffer);
	Format(buffer, sizeof(buffer), "%T", "Tiger Tooth", LANG_SERVER);
	menu.AddItem("Tiger Tooth", buffer);
	Format(buffer, sizeof(buffer), "%T", "Urban Masked", LANG_SERVER);
	menu.AddItem("Urban Masked", buffer);
	Format(buffer, sizeof(buffer), "%T", "Crimson Web", LANG_SERVER);
	menu.AddItem("Crimson Web", buffer);
	Format(buffer, sizeof(buffer), "%T", "Night Stripe", LANG_SERVER);
	menu.AddItem("Night Stripe", buffer);
	Format(buffer, sizeof(buffer), "%T", "Ultraviolet", LANG_SERVER);
	menu.AddItem("Ultraviolet", buffer);
	Format(buffer, sizeof(buffer), "%T", "Rust Coat", LANG_SERVER);
	menu.AddItem("Rust Coat", buffer);
	Format(buffer, sizeof(buffer), "%T", "Gamma Doppler", LANG_SERVER);
	menu.AddItem("Gamma Doppler", buffer);
	Format(buffer, sizeof(buffer), "%T", "Black Laminate", LANG_SERVER);
	menu.AddItem("Black Laminate", buffer);
	Format(buffer, sizeof(buffer), "%T", "Bright Water", LANG_SERVER);
	menu.AddItem("Bright Water", buffer);
	Format(buffer, sizeof(buffer), "%T", "Night", LANG_SERVER);
	menu.AddItem("Night", buffer);
	
	
	Format(buffer, sizeof(buffer), "%T", "Select knife skin:", LANG_SERVER);
	menu.SetTitle(buffer);
	return menu;
}


Menu BuildAWPMenu()
{
	char buffer[128];
	Menu menu = new Menu(Menu_AwpSkin);
	
	Format(buffer, sizeof(buffer), "%T", "Dragon Lore", LANG_SERVER);
	menu.AddItem("Dragon Lore", buffer);
	
	Format(buffer, sizeof(buffer), "%T", "Medusa", LANG_SERVER);
	menu.AddItem("Medusa", buffer);
	
	Format(buffer, sizeof(buffer), "%T", "WildFire", LANG_SERVER);
	menu.AddItem("WildFire", buffer);
	
	Format(buffer, sizeof(buffer), "%T", "Gungnir", LANG_SERVER);
	menu.AddItem("Gungnir", buffer);
	
	Format(buffer, sizeof(buffer), "%T", "The Prince", LANG_SERVER);
	menu.AddItem("The Prince", buffer);
	
	Format(buffer, sizeof(buffer), "%T", "Containment Breach", LANG_SERVER);
	menu.AddItem("Containment Breach", buffer);
	
	Format(buffer, sizeof(buffer), "%T", "Fade AWP", LANG_SERVER);
	menu.AddItem("Fade AWP", buffer);
	
	
	Format(buffer, sizeof(buffer), "%T", "Neo-Noir AWP", LANG_SERVER);
	menu.AddItem("Neo-Noir AWP", buffer);
	
	Format(buffer, sizeof(buffer), "%T", "Oni Taiji", LANG_SERVER);
	menu.AddItem("Oni Taiji", buffer);
	
	Format(buffer, sizeof(buffer), "%T", "Lightning Strike", LANG_SERVER);
	menu.AddItem("Lightning Strike", buffer);
	
	Format(buffer, sizeof(buffer), "%T", "Asiimov AWP", LANG_SERVER);
	menu.AddItem("Asiimov AWP", buffer);
	
	Format(buffer, sizeof(buffer), "%T", "Hyper Beast AWP", LANG_SERVER);
	menu.AddItem("Hyper Beast AWP", buffer);
	
	Format(buffer, sizeof(buffer), "%T", "Man-o'-war", LANG_SERVER);
	menu.AddItem("Man-o'-war", buffer);
	
	
	
	Format(buffer, sizeof(buffer), "%T", "Select awp skin:", LANG_SERVER);
	menu.SetTitle(buffer);
	return menu;
}

Menu BuildM4A1Menu()
{
	char buffer[128];
	Menu menu = new Menu(Menu_M4A1Skin);
	
	Format(buffer, sizeof(buffer), "%T", "Printstream", LANG_SERVER);
	menu.AddItem("Printstream", buffer);

	Format(buffer, sizeof(buffer), "%T", "Player Two", LANG_SERVER);
	menu.AddItem("Player Two", buffer);
	
	Format(buffer, sizeof(buffer), "%T", "Welcome to the Jungle", LANG_SERVER);
	menu.AddItem("Welcome to the Jungle", buffer);
	
	Format(buffer, sizeof(buffer), "%T", "Mecha Industries", LANG_SERVER);
	menu.AddItem("Mecha Industries", buffer);
	
	Format(buffer, sizeof(buffer), "%T", "Chantico's Fire", LANG_SERVER);
	menu.AddItem("Chantico's Fire", buffer);
	
	Format(buffer, sizeof(buffer), "%T", "Golden Coil", LANG_SERVER);
	menu.AddItem("Golden Coil", buffer);
	
	Format(buffer, sizeof(buffer), "%T", "Hyper Beast M4A1", LANG_SERVER);
	menu.AddItem("Hyper Beast M4A1", buffer);
	
	Format(buffer, sizeof(buffer), "%T", "Cyrex", LANG_SERVER);
	menu.AddItem("Cyrex", buffer);
	
	
	Format(buffer, sizeof(buffer), "%T", "Select m4a1 skin:", LANG_SERVER);
	menu.SetTitle(buffer);
	return menu;
}

Menu BuildM4A4Menu()
{
	char buffer[128];
	Menu menu = new Menu(Menu_M4A4Skin);
	
	Format(buffer, sizeof(buffer), "%T", "Asiimov M4A4", LANG_SERVER);
	menu.AddItem("Asiimov M4A4", buffer);
		
	Format(buffer, sizeof(buffer), "%T", "Neo-Noir M4A4", LANG_SERVER);
	menu.AddItem("Neo-Noir M4A4", buffer);
	
	Format(buffer, sizeof(buffer), "%T", "The Emperor", LANG_SERVER);
	menu.AddItem("The Emperor", buffer);
	
	Format(buffer, sizeof(buffer), "%T", "In Living Color", LANG_SERVER);
	menu.AddItem("In Living Color", buffer);
	
	Format(buffer, sizeof(buffer), "%T", "X-Ray", LANG_SERVER);
	menu.AddItem("X-Ray", buffer);
	
	Format(buffer, sizeof(buffer), "%T", "The Battlestar", LANG_SERVER);
	menu.AddItem("The Battlestar", buffer);
	
	Format(buffer, sizeof(buffer), "%T", "Royal Paladin", LANG_SERVER);
	menu.AddItem("Royal Paladin", buffer);
	
	Format(buffer, sizeof(buffer), "%T", "Bullet Rain", LANG_SERVER);
	menu.AddItem("Bullet Rain", buffer);
	
	Format(buffer, sizeof(buffer), "%T", "Desert-Strike", LANG_SERVER);
	menu.AddItem("Desert-Strike", buffer);
	
	Format(buffer, sizeof(buffer), "%T", "Buzz Kill", LANG_SERVER);
	menu.AddItem("Buzz Kill", buffer);
	
	Format(buffer, sizeof(buffer), "%T", "Select m4a4 skin:", LANG_SERVER);
	menu.SetTitle(buffer);
	return menu;
}

Menu BuildAK47Menu()
{
	char buffer[128];
	Menu menu = new Menu(Menu_AK47Skin);
	
	Format(buffer, sizeof(buffer), "%T", "Legion of Anubis", LANG_SERVER);
	menu.AddItem("Legion of Anubis", buffer);
	
	Format(buffer, sizeof(buffer), "%T", "Fire Serpent", LANG_SERVER);
	menu.AddItem("Fire Serpent", buffer);
	
	Format(buffer, sizeof(buffer), "%T", "X-Ray", LANG_SERVER);
	menu.AddItem("X-Ray", buffer);
	
	Format(buffer, sizeof(buffer), "%T", "Asiimov AK47", LANG_SERVER);
	menu.AddItem("Asiimov AK47", buffer);
	
	Format(buffer, sizeof(buffer), "%T", "Neon Rider", LANG_SERVER);
	menu.AddItem("Neon Rider", buffer);
	
	Format(buffer, sizeof(buffer), "%T", "The Empress", LANG_SERVER);
	menu.AddItem("The Empress", buffer);
	
	Format(buffer, sizeof(buffer), "%T", "Bloodsport", LANG_SERVER);
	menu.AddItem("Bloodsport", buffer);
	
	Format(buffer, sizeof(buffer), "%T", "Neon Revolution", LANG_SERVER);
	menu.AddItem("Neon Revolution", buffer);
	
	Format(buffer, sizeof(buffer), "%T", "Fuel Injector", LANG_SERVER);
	menu.AddItem("Fuel Injector", buffer);
	
	Format(buffer, sizeof(buffer), "%T", "Wild Lotus", LANG_SERVER);
	menu.AddItem("Wild Lotus", buffer);
	
	Format(buffer, sizeof(buffer), "%T", "Aquamarine Revenge", LANG_SERVER);
	menu.AddItem("Aquamarine Revenge", buffer);
	
	Format(buffer, sizeof(buffer), "%T", "Wasteland Rebel", LANG_SERVER);
	menu.AddItem("Wasteland Rebel", buffer);
	
	Format(buffer, sizeof(buffer), "%T", "Jaguar", LANG_SERVER);
	menu.AddItem("Jaguar", buffer);
	
	Format(buffer, sizeof(buffer), "%T", "Vulcan", LANG_SERVER);
	menu.AddItem("Vulcan", buffer);
	

	
	Format(buffer, sizeof(buffer), "%T", "Select ak47 skin:", LANG_SERVER);
	menu.SetTitle(buffer);
	return menu;
}

//////////////////////////////////////
////////////Menu Handlers/////////////
//////////////////////////////////////

public int Menu_AwpSkin(Menu menu, MenuAction action, int param1, int param2)
{
	if(action == MenuAction_Select)
	{
		char skin_id[32];
		menu.GetItem(param2, skin_id, sizeof(skin_id));

		char weapon[32];
		GetArrayString(SelectedWeapon, param1, weapon, sizeof(weapon));

		char name[32];
		GetClientName(param1, name, sizeof(name));

		char buffer[128]; char buffer1[128]; char buffer2[128]; char buffer3[128];

		for(new i = 1; i < MAXPLAYERS; i++)
		{
			if(IsClientConnected(i) && IsClientInGame(i) && !IsFakeClient(i))
			{
				Format(buffer1, sizeof(buffer1), "%T", weapon, i);
				Format(buffer2, sizeof(buffer2), "%T", skin_id, i);
				Format(buffer, sizeof(buffer), " %s | %s", buffer1, buffer2);
				Format(buffer3, sizeof(buffer3), "%T", "Chat message", i);
				CPrintToChat(i, " %s{default} %s \x07%s", name, buffer3, buffer);
			}
			
			if ((GetConVarBool(sm_notify_enable)) && IsClientInGame(i) && CheckCommandAccess(i, "admin_msgs", ADMFLAG_ROOT, true))
			{
				char bfr1[128]; char bfr2[128]; char bfr3[128];
				
				Format(bfr1, sizeof(bfr1), "%T", "Notify", LANG_SERVER);
				Format(bfr3, sizeof(bfr3), "%T", "Chat Tag", LANG_SERVER);
				Format(bfr2, sizeof(bfr2), "%s \x07%s %s", bfr3, name, bfr1);
				PrintToChat(i, "%s", bfr2);
			}
		}
	}
}

public int Menu_M4A1Skin(Menu menu, MenuAction action, int param1, int param2)
{
	if(action == MenuAction_Select)
	{
		char skin_id[32];
		menu.GetItem(param2, skin_id, sizeof(skin_id));

		char weapon[32];
		GetArrayString(SelectedWeapon, param1, weapon, sizeof(weapon));

		char name[32];
		GetClientName(param1, name, sizeof(name));

		char buffer[128]; char buffer1[128]; char buffer2[128]; char buffer3[128];

		for(new i = 1; i < MAXPLAYERS; i++)
		{
			if(IsClientConnected(i) && IsClientInGame(i) && !IsFakeClient(i))
			{
				Format(buffer1, sizeof(buffer1), "%T", weapon, i);
				Format(buffer2, sizeof(buffer2), "%T", skin_id, i);
				Format(buffer, sizeof(buffer), " %s | %s", buffer1, buffer2);
				Format(buffer3, sizeof(buffer3), "%T", "Chat message", i);
				CPrintToChat(i, " %s{default} %s \x07%s", name, buffer3, buffer);
			}
			
			if ((GetConVarBool(sm_notify_enable)) && IsClientInGame(i) && CheckCommandAccess(i, "admin_msgs", ADMFLAG_ROOT, true))
			{
				char bfr1[128]; char bfr2[128]; char bfr3[128];
				
				Format(bfr1, sizeof(bfr1), "%T", "Notify", LANG_SERVER);
				Format(bfr3, sizeof(bfr3), "%T", "Chat Tag", LANG_SERVER);
				Format(bfr2, sizeof(bfr2), "%s \x07%s %s", bfr3, name, bfr1);
				PrintToChat(i, "%s", bfr2);
			}
		}
	}
}

public int Menu_M4A4Skin(Menu menu, MenuAction action, int param1, int param2)
{
	if(action == MenuAction_Select)
	{
		char skin_id[32];
		menu.GetItem(param2, skin_id, sizeof(skin_id));

		char weapon[32];
		GetArrayString(SelectedWeapon, param1, weapon, sizeof(weapon));

		char name[32];
		GetClientName(param1, name, sizeof(name));

		char buffer[128]; char buffer1[128]; char buffer2[128]; char buffer3[128];

		for(new i = 1; i < MAXPLAYERS; i++)
		{
			if(IsClientConnected(i) && IsClientInGame(i) && !IsFakeClient(i))
			{
				Format(buffer1, sizeof(buffer1), "%T", weapon, i);
				Format(buffer2, sizeof(buffer2), "%T", skin_id, i);
				Format(buffer, sizeof(buffer), " %s | %s", buffer1, buffer2);
				Format(buffer3, sizeof(buffer3), "%T", "Chat message", i);
				CPrintToChat(i, " %s{default} %s \x07%s", name, buffer3, buffer);
			}
			
			if ((GetConVarBool(sm_notify_enable)) && IsClientInGame(i) && CheckCommandAccess(i, "admin_msgs", ADMFLAG_ROOT, true))
			{
				char bfr1[128]; char bfr2[128]; char bfr3[128];
				
				Format(bfr1, sizeof(bfr1), "%T", "Notify", LANG_SERVER);
				Format(bfr3, sizeof(bfr3), "%T", "Chat Tag", LANG_SERVER);
				Format(bfr2, sizeof(bfr2), "%s \x07%s %s", bfr3, name, bfr1);
				PrintToChat(i, "%s", bfr2);
			}
		}
	}
}

public int Menu_AK47Skin(Menu menu, MenuAction action, int param1, int param2)
{
	if(action == MenuAction_Select)
	{
		char skin_id[32];
		menu.GetItem(param2, skin_id, sizeof(skin_id));

		char weapon[32];
		GetArrayString(SelectedWeapon, param1, weapon, sizeof(weapon));

		char name[32];
		GetClientName(param1, name, sizeof(name));

		char buffer[128]; char buffer1[128]; char buffer2[128]; char buffer3[128];

		for(new i = 1; i < MAXPLAYERS; i++)
		{
			if(IsClientConnected(i) && IsClientInGame(i) && !IsFakeClient(i))
			{
				Format(buffer1, sizeof(buffer1), "%T", weapon, i);
				Format(buffer2, sizeof(buffer2), "%T", skin_id, i);
				Format(buffer, sizeof(buffer), " %s | %s", buffer1, buffer2);
				Format(buffer3, sizeof(buffer3), "%T", "Chat message", i);
				CPrintToChat(i, " %s{default} %s \x07%s", name, buffer3, buffer);
			}
			
			if ((GetConVarBool(sm_notify_enable)) && IsClientInGame(i) && CheckCommandAccess(i, "admin_msgs", ADMFLAG_ROOT, true))
			{
				char bfr1[128]; char bfr2[128]; char bfr3[128];
				
				Format(bfr1, sizeof(bfr1), "%T", "Notify", LANG_SERVER);
				Format(bfr3, sizeof(bfr3), "%T", "Chat Tag", LANG_SERVER);
				Format(bfr2, sizeof(bfr2), "%s \x07%s %s", bfr3, name, bfr1);
				PrintToChat(i, "%s", bfr2);
			}
		}
	}
}

public int Menu_Skin(Menu menu, MenuAction action, int param1, int param2)
{
	if(action == MenuAction_Select)
	{
		char skin_id[32];
		menu.GetItem(param2, skin_id, sizeof(skin_id));

		char knife[32];
		GetArrayString(SelectedKnife, param1, knife, sizeof(knife));

		char name[32];
		GetClientName(param1, name, sizeof(name));

		char buffer[128]; char buffer1[128]; char buffer2[128]; char buffer3[128];

		for(new i = 1; i < MAXPLAYERS; i++)
		{
			if(IsClientConnected(i) && IsClientInGame(i) && !IsFakeClient(i))
			{
				Format(buffer1, sizeof(buffer1), "%T", knife, i);
				Format(buffer2, sizeof(buffer2), "%T", skin_id, i);
				Format(buffer, sizeof(buffer), "★ %s | %s", buffer1, buffer2);
				Format(buffer3, sizeof(buffer3), "%T", "Chat message", i);
				CPrintToChat(i, " %s{default} %s \x07%s", name, buffer3, buffer);
			}
				
			if ((GetConVarBool(sm_notify_enable)) && IsClientInGame(i) && CheckCommandAccess(i, "admin_msgs", ADMFLAG_ROOT, true))
			{
				char bfr1[128]; char bfr2[128]; char bfr3[128];
				
				Format(bfr1, sizeof(bfr1), "%T", "Notify", LANG_SERVER);
				Format(bfr3, sizeof(bfr3), "%T", "Chat Tag", LANG_SERVER);
				Format(bfr2, sizeof(bfr2), "%s \x07%s %s", bfr3, name, bfr1);
				PrintToChat(i, "%s", bfr2);
			}
		}
	}
}
//////////////////////////////////////
/////////////////Etc//////////////////
//////////////////////////////////////

bool CheckAdminFlags(int client, int iFlag)
{
	int iUserFlags = GetUserFlagBits(client);
	return (iUserFlags & ADMFLAG_ROOT || (iUserFlags & iFlag) == iFlag);
}

