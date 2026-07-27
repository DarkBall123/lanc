#define GRID_W( num ) ( num * ( pixelGridNoUIScale * pixelW * 2 ))
#define GRID_H( num ) ( num * ( pixelGridNoUIScale * pixelH * 2 ))

class CfgPatches
{
	class lk_lancet
	{
		addonRootClass="A3_Drones_F";
		requiredAddons[]=
		{
			"A3_Weapons_F_Ammoboxes",
			"A3_Static_F",
			"A3_Characters_F",
			"A3_Data_F_AoW_Loadorder",
			"A3_Weapons_F",
			"A3_Supplies_F_Enoch_Ammoboxes",
			"sdreal_uav",
			"cba_settings"
		};
		requiredVersion=0.1;
		units[]=
		{
			"lancet_dummy_mag",
			"m_lancet_dummy",
			"m_izdelie_dummy",
			"izdelie_dummy_mag",
			"m_geran_dummy",
			"geran_dummy_mag",
			"Lancet_Tripod_Bag_Weapon",
			"Lancet_Tripod_Bag_Support",
			"lancet_tripod_launcher_o",
			"lancet_tripod_launcher_b",
			"lancet_tripod_launcher_i",
			"izdelie_tripod_launcher_o",
			"izdelie_tripod_launcher_b",
			"izdelie_tripod_launcher_i",
			"geran_tripod_launcher_o",
			"geran_tripod_launcher_b",
			"geran_tripod_launcher_i"
			
		};
		weapons[]=
		{
			"launch_B_Titan_F"
		};
	};
};

class cfgammo
{
	class M_Jian_AT;
	class m_lancet_dummy: M_Jian_AT
	{
		modelspecial="\lk_lancet\lancet_3.p3d";
		model="\lk_lancet\lancet_3.p3d";
		soundFly[]=
		{
			"",
			0.13095701,
			1
		};
		effectsMissile="EmptyEffect";
		effectsMissileInit="";
		effectsSmoke="";
		muzzleEffect="";
		hit=150;
		indirectHit=70;
		indirectHitRange=5;
		fuseDistance=0.1;
		manualControl=0;
		timeToLive=1800;
		flightProfiles[]=
		{
			"TopDown"
		};
		submunitionDirectionType="SubmunitionModelDirection";
		submunitionInitSpeed=1000;
		submunitionParentSpeedCoef=0;
		submunitionInitialOffset[]={0,0,-0.2};
		triggerOnImpact=1;
		deleteParentWhenTriggered=0;
		lancet_speedArray[]={75,43,7,1000,1};
	};

	class m_izdelie_dummy: M_Jian_AT
	{
		modelspecial="\lk_lancet\izdelie53\izdelie_53.p3d";
		model="\lk_lancet\izdelie53\izdelie_53.p3d";
		soundFly[]=
		{
			"",
			0.13095701,
			1
		};
		effectsMissile="EmptyEffect";
		effectsMissileInit="";
		effectsSmoke="";
		muzzleEffect="";
		fuseDistance=0.1;
		hit=150;
		indirectHit=70;
		indirectHitRange=5;
		manualControl=0;
		timeToLive=1800;
		flightProfiles[]=
		{
			"TopDown"
		};
		submunitionDirectionType="SubmunitionModelDirection";
		submunitionInitSpeed=1000;
		submunitionParentSpeedCoef=0;
		submunitionInitialOffset[]={0,0,-0.2};
		triggerOnImpact=1;
		deleteParentWhenTriggered=0;
		lancet_speedArray[]={75,43,7,1000,1};
	};

	class m_geran_dummy: m_lancet_dummy
	{
		modelspecial="\lk_lancet\shahed4.p3d";
		model="\lk_lancet\shahed4.p3d";
	};
};
class cfgMagazines
{
	class Titan_AT;
	class lancet_dummy_mag: Titan_AT
	{
		modelspecial="\lk_lancet\lancet_3.p3d";
		model="\lk_lancet\lancet_3.p3d";
		displayname="Lancet-3 Loitering Ammunition";
		ammo="m_lancet_dummy";
		mass=300;
		author="Z Virtual Ordnance";
		scope=2;
		picture="\lk_lancet\pictures\lancet.paa";
	};
	class izdelie_dummy_mag: Titan_AT
	{
		modelspecial="\lk_lancet\izdelie53\izdelie_53.p3d";
		model="\lk_lancet\izdelie53mag\izdelie_53mag.p3d";
		displayname="Izdlie-53";
		ammo="m_izdelie_dummy";
		mass=300;
		author="Z Virtual Ordnance";
		scope=2;
		picture="\lk_lancet\pictures\izdelie53.paa";
		count = 4;
	};
	class geran_dummy_mag: lancet_dummy_mag
	{
		modelspecial="\lk_lancet\shahed4.p3d";
		model="\lk_lancet\shahed4.p3d";
		displayname="Geran-2 Loitering Ammunition";
		ammo="m_geran_dummy";
		picture="\lk_lancet\textures\icon_ca.paa";
	};
};
class CfgWeapons
{
	class Default;
	class InventoryItem_Base_F;
	class ItemCore: Default
	{
	};
	class CBA_MiscItem_ItemInfo: InventoryItem_Base_F
	{
	};
	class CBA_MiscItem: ItemCore
	{
		class ItemInfo: CBA_MiscItem_ItemInfo
		{
		};
	};
	class fakeWeapon;
	class Lancet_launcher_weap: fakeWeapon
	{
		class GunParticles
		{
			class FirstEffect
			{
				directionName="konec hlavne";
				effectName="GrenadeLauncherCloud";
				positionName="usti hlavne";
			};
		};
		class BaseSoundModeType
		{
			closure1[]=
			{
				"A3\Sounds_F\arsenal\weapons\UGL\Closure_UGL",
				1,
				1,
				10
			};
			soundClosure[]=
			{
				"closure1",
				1
			};
		};
		class StandardSound
		{
			begin1[]=
			{
				"A3\Sounds_F\arsenal\weapons\UGL\UGL_01",
				0.707946,
				1,
				200
			};
			begin2[]=
			{
				"A3\Sounds_F\arsenal\weapons\UGL\UGL_02",
				0.707946,
				1,
				200
			};
			closure1[]=
			{
				"A3\Sounds_F\arsenal\weapons\UGL\Closure_UGL",
				1,
				1,
				10
			};
			soundBegin[]=
			{
				"begin1",
				0.5,
				"begin2",
				0.5
			};
			soundClosure[]=
			{
				"closure1",
				1
			};
			soundSetShot[]=
			{
				"DS_UGL_Closure_SoundSet",
				"DS_UGL_Shot_SoundSet",
				"DS_pistol1_Tail_SoundSet"
			};
		};
		magazineReloadTime=60;
		reloadTime=60;
	};

	class Izdelie_launcher_weap: fakeWeapon
	{
		class GunParticles
		{
			class FirstEffect
			{
				directionName="konec hlavne";
				effectName="GrenadeLauncherCloud";
				positionName="usti hlavne";
			};
		};
		class BaseSoundModeType
		{
			closure1[]=
			{
				"A3\Sounds_F\arsenal\weapons\UGL\Closure_UGL",
				1,
				1,
				10
			};
			soundClosure[]=
			{
				"closure1",
				1
			};
		};
		class StandardSound
		{
			begin1[]=
			{
				"A3\Sounds_F\arsenal\weapons\UGL\UGL_01",
				0.707946,
				1,
				200
			};
			begin2[]=
			{
				"A3\Sounds_F\arsenal\weapons\UGL\UGL_02",
				0.707946,
				1,
				200
			};
			closure1[]=
			{
				"A3\Sounds_F\arsenal\weapons\UGL\Closure_UGL",
				1,
				1,
				10
			};
			soundBegin[]=
			{
				"begin1",
				0.5,
				"begin2",
				0.5
			};
			soundClosure[]=
			{
				"closure1",
				1
			};
			soundSetShot[]=
			{
				"DS_UGL_Closure_SoundSet",
				"DS_UGL_Shot_SoundSet",
				"DS_pistol1_Tail_SoundSet"
			};
		};
		magazineReloadTime=5;
		reloadTime=5;
		magazines[] = {"izdelie_dummy_mag"};
	};
	class launch_Titan_base;
	class launch_B_Titan_F: launch_Titan_base
	{
		magazines[]+=
		{
			"lancet_dummy_mag",
			"izdelie_dummy_mag",
			"geran_dummy_mag"
		};
	};
};
class SensorTemplatePassiveRadar;
class SensorTemplateAntiRadiation;
class SensorTemplateActiveRadar;
class SensorTemplateIR;
class SensorTemplateVisual;
class SensorTemplateMan;
class SensorTemplateLaser;
class SensorTemplateNV;
class SensorTemplateDataLink;
class DefaultVehicleSystemsDisplayManagerLeft
{
	class components;
};
class DefaultVehicleSystemsDisplayManagerRight
{
	class components;
};
class CfgVehicles
{
	class All
	{
	};
	class AllVehicles: All
	{
		class NewTurret
		{
		};
	};
	class Land: AllVehicles
	{
	};
	class LandVehicle: Land
	{
	};
	class StaticWeapon: LandVehicle
	{
		class Turrets
		{
			class MainTurret: NewTurret
			{
			};
		};
	};
	class StaticMortar: StaticWeapon
	{
		class Turrets: Turrets
		{
			class MainTurret: MainTurret
			{
			};
		};
	};
	class Mortar_01_base_F: StaticMortar
	{
		class Turrets: Turrets
		{
			class MainTurret: MainTurret
			{
				class ViewOptics;
			};
		};
	};
	class lancet_tripod_launcher: Mortar_01_base_F
	{
		model="\lk_lancet\tripod\lancet_tripod.p3d";
		crew="O_Soldier_F";
		_generalmacro="lancet_tripod_launcher";
		displayName="Lancet Tripod Launcher";
		editorPreview = "\lk_lancet\pictures\prew_lancet.paa";
		scopecurator=0;
		scope=0;
		side=0;
		faction="OPF_R_F";
		artilleryScanner=0;
		destrType="DestructWreck";
		class Turrets: Turrets
		{
			class MainTurret: MainTurret
			{
				LODTurnedIn = 0;
				LODTurnedOut = 0;
				LODOpticsIn = 0;
				LODOpticsOut = 0;
				gunnerOpticsModel="\A3\weapons_f\reticle\optics_empty";
				turretInfoType="RscOptics_Offroad_01";
				weapons[]=
				{
					"Lancet_Launcher_Weap"
				};
				magazines[]=
				{
					"FakeMagazine"
				};
				cameraDir="look";
				gunnerAction="Mortar_Gunner";
				gunnergetInAction="";
				gunnergetOutAction="";
				elevationMode=1;
				initCamElev=0;
				minCamElev=-35;
				maxCamElev=35;
				initElev=0;
				minTurn=-180;
				maxTurn=180;
				initTurn=0;
				discreteDistance[]={100,200,300,400,500,700,1000,1600,2000,2400,2800};
				discreteDistanceCameraPoint[]=
				{
					"otocvez"
				};
				discreteDistanceInitIndex=5;
				gunnerForceOptics=0;
				memoryPointGunnerOptics="otocvez";
				disableSoundAttenuation=1;
				class ViewOptics: ViewOptics
				{
					initAngleX=0;
					minAngleX=-30;
					maxAngleX=30;
					initAngleY=0;
					minAngleY=-100;
					maxAngleY=100;
					initFov=0.17399999;
					minFov=0.0077777999;
					maxFov=0.14;
					visionMode[]=
					{
						"Normal",
						"NVG"
					};
				};
				minelev=-30;
				maxelev=13;
				ejectDeadGunner=1;
				usepip=2;
			};
		};
		class assembleInfo
		{
			primary=0;
			base="";
			assembleTo="";
			dissasembleTo[]=
			{
				"Lancet_Tripod_Bag_Weapon",
				"Lancet_Tripod_Bag_Support"
			};
			displayName="";
		};
		hiddenSelections[]={};
		hiddenSelectionsTextures[]={};
		class UserActions
		{
			class ReloadAction
			{
				displayName="Reload";
				priority=0.5;
				radius=7;
				position="";
				showWindow=0;
				onlyForPlayer=1;
				condition="(vehicle player == player) && (not (this getVariable ['lancet_isAssembleing', false])) && (not (someAmmo this)) && ((this call lancet_fnc_checkContainersForMag) || ('lancet_dummy_mag' in magazines player))";
				statement="current_tripod = this; this setVariable ['lancet_isAssembleing', true, true]; ['Assembling the Lancet', 30, {player playMoveNow 'AinvPknlMstpSnonWnonDnon_medic_1'; alive player}, {current_tripod call lancet_fnc_reload_tripod}, {current_tripod setVariable ['lancet_isAssembleing', false, true]}] call CBA_fnc_progressBar;";
				icon="";
			};
		};
		class AnimationSources
		{
			class Lancet_revolving
			{
				source="revolving";
				weapon="Lancet_launcher_weap";
			};
		};
		class EventHandlers
		{
			class Lancet_Handlers
			{
				init="_this spawn lancet_fnc_handleAnim;";
				fired="_this call lancet_fnc_init_launcher_tripod; playSound3D ['\lk_lancet\tripod\zapusk.ogg', _this # 0, false, getPosASL (_this # 0), 5]";
			};
		};
	};
		
	class lancet_tripod_launcher_o: lancet_tripod_launcher
	{
		model="\lk_lancet\tripod\lancet_tripod.p3d";
		crew="O_Soldier_F";
		_generalmacro="lancet_tripod_launcher";
		displayName="Lancet Tripod Launcher";
		editorPreview = "\lk_lancet\pictures\prew_lancet.paa";
		scopecurator=2;
		scope=2;
		side=0;
		faction="OPF_R_F";
	};
	
	class lancet_tripod_launcher_b: lancet_tripod_launcher
	{
		model="\lk_lancet\tripod\lancet_tripod.p3d";
		crew="B_Soldier_F";
		_generalmacro="lancet_tripod_launcher";
		displayName="Lancet Tripod Launcher";
		editorPreview = "\lk_lancet\pictures\prew_lancet.paa";
		scopecurator=2;
		scope=2;
		side=1;
		faction="BLU_F";
	};	
	
	class lancet_tripod_launcher_i: lancet_tripod_launcher
	{
		model="\lk_lancet\tripod\lancet_tripod.p3d";
		crew="I_soldier_F";
		_generalmacro="lancet_tripod_launcher";
		displayName="Lancet Tripod Launcher";
		editorPreview = "\lk_lancet\pictures\prew_lancet.paa";
		scopecurator=2;
		scope=2;
		side=2;
		faction="IND_F";
	};	

	class izdelie_tripod_launcher_o: Mortar_01_base_F
	{
		model="\lk_lancet\izdelie53_tripod\izdelie53_tripod.p3d";
		crew="O_Soldier_F";
		_generalmacro="izdelie_tripod_launcher";
		displayName="Izdelie Launcher";
		editorPreview = "\lk_lancet\pictures\prew_izdelie.paa";
		scopecurator=2;
		scope=2;
		side=0;
		faction="OPF_R_F";
		artilleryScanner=0;
		destrType="DestructWreck";
		class Turrets: Turrets
		{
			class MainTurret: MainTurret
			{
				LODTurnedIn = 0;
				LODTurnedOut = 0;
				LODOpticsIn = 0;
				LODOpticsOut = 0;
				gunnerOpticsModel="\A3\weapons_f\reticle\optics_empty";
				turretInfoType="RscOptics_Offroad_01";
				weapons[]=
				{
					"Izdelie_launcher_weap"
				};
				magazines[]=
				{
					"izdelie_dummy_mag"
				};
				cameraDir="look";
				gunnerAction="Mortar_Gunner";
				gunnergetInAction="";
				gunnergetOutAction="";
				elevationMode=1;
				initCamElev=0;
				minCamElev=-35;
				maxCamElev=35;
				initElev=0;
				minTurn=-180;
				maxTurn=180;
				initTurn=0;
				discreteDistance[]={100,200,300,400,500,700,1000,1600,2000,2400,2800};
				discreteDistanceCameraPoint[]=
				{
					"otocvez"
				};
				discreteDistanceInitIndex=5;
				gunnerForceOptics=0;
				memoryPointGunnerOptics="otocvez";
				disableSoundAttenuation=1;
				class ViewOptics: ViewOptics
				{
					initAngleX=0;
					minAngleX=-30;
					maxAngleX=30;
					initAngleY=0;
					minAngleY=-100;
					maxAngleY=100;
					initFov=0.17399999;
					minFov=0.0077777999;
					maxFov=0.14;
					visionMode[]=
					{
						"Normal",
						"NVG"
					};
				};
				minelev=-30;
				maxelev=13;
				ejectDeadGunner=1;
				usepip=2;
			};
		};
			
		class AnimationSources
		{
			class ammo_count
			{
			   animPeriod = 0.001;
			   source = "ammo";
			   weapon = "Izdelie_launcher_weap";
			};
		};	


		hiddenSelections[]={};
		hiddenSelectionsTextures[]={};
		class UserActions
		{
			class ReloadAction
			{
				displayName="Reload";
				priority=0.5;
				radius=7;
				position="";
				showWindow=0;
				onlyForPlayer=1;
				condition="(vehicle player == player) && (not (this getVariable ['lancet_isAssembleing', false])) && (((not someAmmo this) || {(((((magazinesAmmo this) # 0) # 1) / 4) < 1)})) && (this call lancet_fnc_checkContainersForMag)";
				statement="current_tripod = this; this setVariable ['lancet_isAssembleing', true, true]; ['Assembling the Lancet', 30, {player playMoveNow 'AinvPknlMstpSnonWnonDnon_medic_1'; alive player}, {current_tripod call lancet_fnc_reload_tripod}, {current_tripod setVariable ['lancet_isAssembleing', false, true]}] call CBA_fnc_progressBar;";
				icon="";
			};
		};
		class EventHandlers
		{
			class Lancet_Handlers
			{
				init="_this spawn lancet_fnc_handleAnim;";
				fired="_this call lancet_fnc_init_launcher_tripod; playSound3D ['\lk_lancet\tripod\zapusk.ogg', _this # 0, false, getPosASL (_this # 0), 5]";
			};
		};
	};
	
	class izdelie_tripod_launcher_b: izdelie_tripod_launcher_o
	{
		model="\lk_lancet\izdelie53_tripod\izdelie53_tripod.p3d";
		crew="B_Soldier_F";
		_generalmacro="izdelie_tripod_launcher";
		displayName="Izdelie Launcher";
		editorPreview = "\lk_lancet\pictures\prew_izdelie.paa";
		scopecurator=2;
		scope=2;
		side=1;
		faction="BLU_F";
	};
	
	class izdelie_tripod_launcher_i: izdelie_tripod_launcher_o
	{
		model="\lk_lancet\izdelie53_tripod\izdelie53_tripod.p3d";
		crew="I_soldier_F";
		_generalmacro="izdelie_tripod_launcher";
		displayName="Izdelie Launcher";
		editorPreview = "\lk_lancet\pictures\prew_izdelie.paa";
		scopecurator=2;
		scope=2;
		side=2;
		faction="IND_F";
	};	

	class geran_tripod_launcher: lancet_tripod_launcher
	{
		model="\lk_lancet\geran_tripod\geran_tripod.p3d";
		_generalmacro="geran_tripod_launcher";
		displayName="Geran-2 Tripod Launcher";
		editorPreview="\lk_lancet\textures\preview_shahed.jpg";
		class UserActions: UserActions
		{
			class ReloadAction: ReloadAction
			{
				condition="(vehicle player == player) && (not (this getVariable ['lancet_isAssembleing', false])) && (not (someAmmo this)) && ((this call lancet_fnc_checkContainersForMag) || ('geran_dummy_mag' in magazines player))";
			};
		};
	};

	class geran_tripod_launcher_o: geran_tripod_launcher
	{
		crew="O_Soldier_F";
		scopecurator=2;
		scope=2;
		side=0;
		faction="OPF_R_F";
	};

	class geran_tripod_launcher_b: geran_tripod_launcher
	{
		crew="B_Soldier_F";
		scopecurator=2;
		scope=2;
		side=1;
		faction="BLU_F";
	};

	class geran_tripod_launcher_i: geran_tripod_launcher
	{
		crew="I_soldier_F";
		scopecurator=2;
		scope=2;
		side=2;
		faction="IND_F";
	};
	
	class Bag_Base;
	class Weapon_Bag_Base;
	class Lancet_Tripod_Bag_Support: Bag_Base
	{
		scope=2;
		displayName="Folded Lancet Bipod";
		author="DarkBall";
		vehicleClass="Backpacks";
		class assembleInfo
		{
			assembleTo="";
			base="";
			displayName="";
			dissasembleTo[]={};
			primary=0;
		};
	};
	class Lancet_Tripod_Bag_Weapon: Weapon_Bag_Base
	{
		scope=2;
		displayName="Folded Lancet Tripod Tube";
		author="DarkBall";
		vehicleClass="Backpacks";
		class assembleInfo
		{
			assembleTo="lancet_tripod_launcher_o";
			base[]=
			{
				"Lancet_Tripod_Bag_Support"
			};
			displayName="Lancet Tripod";
			dissasembleTo[]={};
			primary=1;
		};
	};
	class Box_EAF_WpsSpecial_F;
	class Lancet_AmmoBox: Box_EAF_WpsSpecial_F
	{
		scope=2;
		scopecurator=2;
		author="DarkBall";
		displayName="Lancet disassembled";
		class EventHandlers
		{
			class LancetBox_Init
			{
				init="clearItemCargoGlobal (_this # 0); clearMagazineCargoGlobal (_this # 0); clearWeaponCargoGlobal (_this # 0); (_this # 0) addItemCargoGlobal ['lancet_dummy_mag', 1];";
			};
		};
	};
};
class CfgFunctions
{
	class lancet
	{
		class init
		{
			file="lk_lancet\functions\init";
			class handleAnim
			{
			};
			class init_launcher_tripod
			{
			};
			class checkContainersForMag
			{
			};
			class reload_tripod
			{
			};
			class handleSpeed
			{
			};
			class handleGuidance
			{
			};
			class handleMissile
			{
			};
			class manouverTime
			{
			};
			class handleEffects
			{
			};
			class handleMouse
			{
			};
			class centerCursor
			{
			};
			class handleText
			{
			};
			class addEventHandler
			{
			};
			class addMissile
			{
			};
			class camCreate
			{
			};
			class dialogEventHandlers
			{
			};
			class initMissile
			{
			};
			class cleanEffectsCam
			{
			};
			class setAngleOfAttack
			{
			};
			class findTarget
			{
			};
		};
		class autolock
		{
			file="lk_lancet\functions\autolock";
			class searchTarget
			{
			};
			class lockTarget
			{
			};
			class guideUAV
			{
			};
		};
	};
};
class cfgMods
{
	author="Lukin";
	timepacked="1690923530";
};

class Extended_preInit_EventHandlers
{
   class Lancet_serverInit
   {
       serverInit = "call compile preProcessFileLineNumbers '\lk_lancet\XEH_serverInit.sqf'";
   };
};


class RscPicture;
class RscText;
class ctrlMapEmpty;
class ctrlStaticBackground;

class lancet_seeker
{
	idd=3737;
	movingEnable="false";
	onMouseMoving="_this call lancet_fnc_handleMouse";
	class controls
	{
		class full_screenplus: RscPicture
		{
			text="lk_lancet\pictures\plus.paa";
			x="safeZoneX";
			y="safeZoneY";
			w="safeZoneW";
			h="safeZoneH";
			colorText[]={1,1,1,1};

			onLoad = "uiNameSpace setVariable ['DB_full_screenplus', _this # 0]";
		};
		class full_screen_picture: RscPicture
		{
			idc=1302;
			text="lk_lancet\pictures\targetCross.paa";
			x="safeZoneX";
			y="safeZoneY";
			w="safeZoneW";
			h="safeZoneH";
			colorText[]={1,1,1,1};

			onLoad = "uiNameSpace setVariable ['DB_targetCross', _this # 0]";
		};
		class AutoLockPicture : RscPicture
        {
            idc = -1;

            text = "\lk_lancet\pictures\cel.paa";

			onLoad = "uiNameSpace setVariable ['DB_AutoLockPicture', _this # 0]";

            x = 0.5 - GRID_W(10) / 2;
            y = safeZoneY + GRID_H(3);
            w = GRID_W(10);
            h = GRID_H(2);

			show = 0;
        };
		class seeker_lock: RscPicture
		{
			idc=1201;
			text="lk_lancet\pictures\targetLock.paa";
			x="0.5 - 0.25 / 2";
			y="0.5 - 0.25 / 2";
			w=0.25;
			h=0.25;

			colorText[]={1,1,1,1};
		};
		class tx_zoom: RscText
		{
			idc=1000;
			x="0.22 * safezoneW + safezoneX";
			y="0.45 * safezoneH + safezoneY";
			w="0.1 * safezoneW";
			h="0.1 * safezoneH";
			font="LCD14";
			fade=1;
		};
		class tx_camera: RscText
		{
			idc=1002;
			x="0.22 * safezoneW + safezoneX";
			y="0.49 * safezoneH + safezoneY";
			w="0.1 * safezoneW";
			h="0.1 * safezoneH";
			font="LCD14";
			fade=1;
		};
		class tx_azimuth: RscText
		{
			idc=1001;
			x="0.25 * safezoneW + safezoneX";
			y="0.87 * safezoneH + safezoneY";
			w="0.08 * safezoneW";
			h="0.06 * safezoneH";
			font="LCD14";
			fade=1;
		};
		class tx_time: RscText
		{
			idc=1003;
			x="0.61 * safezoneW + safezoneX";
			y="0.87 * safezoneH + safezoneY";
			w="1 * safezoneW";
			h="0.06 * safezoneH";
			font="LCD14";
			fade=1;
		};
		class tx_lock: RscText
		{
			idc=1004;
			x="0.66 * safezoneW + safezoneX";
			y="0.07  * safezoneH + safezoneY";
			w="1 * safezoneW";
			h="0.06 * safezoneH";
			font="LCD14";
			fade=1;
		};
		class tx_launchtime: RscText
		{
			idc=1005;
			x="0.5 * safezoneW + safezoneX";
			y="0.87  * safezoneH + safezoneY";
			w="1 * safezoneW";
			h="0.06 * safezoneH";
			style="ST_LEFT";
			font="LCD14";
			fade=1;
		};
	};
	class controlsBackground
	{
		class map_background: ctrlMapEmpty
		{
			idc=-1;
			x=0;
			y=0;
			w=1;
			h=1;
			onLoad="(_this # 0) ctrlMapCursor ['', 'BlankCursor']; (_this # 0) ctrlShow false;";
		};
	};
};
class CfgWrapperUI
{
	class Cursors
	{
		class Move;
		class BlankCursor: Move
		{
			texture="lk_lancet\pictures\blank_ca.paa";
		};
	};
};
