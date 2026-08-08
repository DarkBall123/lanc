#include "geran_ui.hpp"

class CfgPatches
{
	class geran4
	{
		addonRootClass="A3_Drones_F";
		requiredAddons[]=
		{
			"A3_Weapons_F_Ammoboxes",
			"A3_Static_F",
			"A3_Characters_F",
			"A3_Data_F_AoW_Loadorder",
			"A3_Weapons_F",
			"A3_Weapons_F_Exp",
			"A3_Supplies_F_Enoch_Ammoboxes",
			"A3_Drones_F_Air_F_Gamma_UAV_01",
			"cba_settings"
		};
		requiredVersion=0.1;
		units[]=
		{
			"geran_uav_o",
			"geran_uav_b",
			"geran_uav_i",
			"Geran_AmmoBox",
			"geran_tripod_launcher_o",
			"geran_tripod_launcher_b",
			"geran_tripod_launcher_i"
		};
		weapons[]=
		{
			"Geran_launcher_weap"
		};
	};
};

class cfgammo
{
	class M_Jian_AT;
	class ammo_Penetrator_Jian;
	class m_geran_penetrator: ammo_Penetrator_Jian
	{
		hit=1700;
		indirectHit=1600;
		indirectHitRange=1;
		caliber=66;
		warheadName="TandemHEAT";
	};
	class m_geran_dummy: M_Jian_AT
	{
		modelspecial="\geran4\shahed4.p3d";
		model="\geran4\shahed4.p3d";
		effectsMissile="EmptyEffect";
		effectsMissileInit="";
		effectsSmoke="";
		muzzleEffect="";
		manualControl=0;
		timeToLive=1800;
		flightProfiles[]=
		{
			"TopDown"
		};
		submunitionAmmo="m_geran_penetrator";
		submunitionDirectionType="SubmunitionModelDirection";
		submunitionInitSpeed=1000;
		submunitionParentSpeedCoef=0;
		submunitionInitialOffset[]={0,0,-0.1};
		triggerOnImpact=1;
		deleteParentWhenTriggered=0;
		soundFly[]=
		{
			"A3\Sounds_F_Jets\vehicles\air\UAV_05\B_UAV_05_engine_low_ext",
			4.5,
			1,
			2000
		};
		soundHit1[]=
		{
			"A3\Sounds_F\weapons\Explosion\expl_big_1",
			2.5118864,
			1,
			2400
		};
		soundHit2[]=
		{
			"A3\Sounds_F\weapons\Explosion\expl_big_2",
			2.5118864,
			1,
			2400
		};
		soundHit3[]=
		{
			"A3\Sounds_F\weapons\Explosion\expl_big_3",
			2.5118864,
			1,
			2400
		};
		soundHit4[]=
		{
			"A3\Sounds_F\weapons\Explosion\expl_shell_1",
			2.5118864,
			1,
			2400
		};
		soundHit5[]=
		{
			"A3\Sounds_F\weapons\Explosion\expl_shell_2",
			2.5118864,
			1,
			2400
		};
		multiSoundHit[]=
		{
			"soundHit1",
			0.2,
			"soundHit2",
			0.2,
			"soundHit3",
			0.2,
			"soundHit4",
			0.2,
			"soundHit5",
			0.2
		};
		warheadName="HE";
		hit=2800;
		indirectHit=500;
		indirectHitRange=32;
		dangerRadiusHit=1250;
		explosionDir="explosionDir";
		explosionEffects="HeavyBombExplosion";
		explosionEffectsDir="explosionDir";
		explosionForceCoef=1;
		explosionPos="explosionPos";
		explosionSoundEffect="DefaultExplosion";
		explosionType="explosive";
		explosive=0.8;
		cost=1200;
		craterEffects="HeavyBombCrater";
		craterShape="";
		craterWaterEffects="ImpactEffectsWater";
		trackOversteer=1;
		trackLead=0.95;
		maneuvrability=20;
		explosionTime=0;
		fuseDistance=100;
		whistleDist=500;
		class CamShakeExplode
		{
			power=46;
			duration=3;
			frequency=20;
			distance=361.32599;
		};
		class CamShakeHit
		{
			power=230;
			duration=0.8;
			frequency=20;
			distance=1;
		};
		class CamShakeFire
		{
			power=3.89432;
			duration=3;
			frequency=20;
			distance=121.326;
		};
		class CamShakePlayerFire
		{
			power=5;
			duration=0.1;
			frequency=20;
			distance=1;
		};
		geranSpeedArray[]={150,90,10,1000,1};
		geranDetectionRange=1250;
		geranTerminalLockRange=200;
		geranGuidanceTurnRate=30;
	};
};
class CfgWeapons
{
	class fakeWeapon;
	class Geran_launcher_weap: fakeWeapon
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

};
class CfgVehicles
{
	class O_UAV_01_F;
	class B_UAV_01_F;
	class I_UAV_01_F;
	class geran_uav_o: O_UAV_01_F
	{
		scope=1;
		scopeCurator=0;
		displayName="Geran-2";
		model="\geran4\shahed4.p3d";
	};
	class geran_uav_b: B_UAV_01_F
	{
		scope=1;
		scopeCurator=0;
		displayName="Geran-2";
		model="\geran4\shahed4.p3d";
	};
	class geran_uav_i: I_UAV_01_F
	{
		scope=1;
		scopeCurator=0;
		displayName="Geran-2";
		model="\geran4\shahed4.p3d";
	};
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
	class geran_tripod_launcher: Mortar_01_base_F
	{
		model="\geran4\geran_tripod\geran_tripod.p3d";
		crew="O_Soldier_F";
		_generalmacro="geran_tripod_launcher";
		displayName="Geran-2 Tripod Launcher";
		editorPreview="\geran4\textures\preview_shahed.jpg";
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
					"Geran_launcher_weap"
				};
				magazines[]=
				{
					"FakeMagazine"
				};
				cameraDir="";
				gunnerAction="Mortar_Gunner";
				gunnergetInAction="";
				gunnergetOutAction="";
				elevationMode=0;
				initCamElev=0;
				minCamElev=0;
				maxCamElev=0;
				initElev=0;
				minTurn=-0;
				maxTurn=0;
				initTurn=0;
				discreteDistance[]={100};
				discreteDistanceCameraPoint[]=
				{
					"eye"
				};
				discreteDistanceInitIndex=0;
				gunnerForceOptics=0;
				memoryPointGunnerOptics="eye";
				disableSoundAttenuation=1;
				class ViewOptics: ViewOptics
				{
					initAngleX=0;
					minAngleX=0;
					maxAngleX=0;
					initAngleY=0;
					minAngleY=-0;
					maxAngleY=0;
					initFov=1.25;
					minFov=1.25;
					maxFov=1.25;
					visionMode[]=
					{
						"Normal",
						"NVG"
					};
				};
				minelev=0;
				maxelev=0;
				ejectDeadGunner=1;
				usepip=2;
			};
		};
		class assembleInfo
		{
			primary=0;
			base="";
			assembleTo="";
			dissasembleTo[]={};
			displayName="";
		};
		hiddenSelections[]={};
		hiddenSelectionsTextures[]={};
		class UserActions
		{
			class ReloadAction
			{
				displayName="Load Geran-2";
				priority=0.5;
				radius=7;
				position="";
				showWindow=0;
				onlyForPlayer=1;
				condition="(vehicle player == player) && (not (this getVariable ['geran4_isAssembling', false])) && (not (this getVariable ['geran4_launchPending', false])) && (not (someAmmo this)) && (this call geran4_fnc_checkContainersForMag)";
				statement="geran4_currentTripod = this; this setVariable ['geran4_isAssembling', true, true]; ['Loading the Geran-2', 30, {player playMoveNow 'AinvPknlMstpSnonWnonDnon_medic_1'; alive player}, {geran4_currentTripod call geran4_fnc_reload_tripod}, {geran4_currentTripod setVariable ['geran4_isAssembling', false, true]}] call CBA_fnc_progressBar;";
				icon="";
			};
		};
		class AnimationSources
		{
			class Geran4_revolving
			{
				source="revolving";
				weapon="Geran_launcher_weap";
			};
		};
		class EventHandlers
		{
			class Geran4_Handlers
			{
				init="_this spawn geran4_fnc_handleAnim;";
				fired="_this call geran4_fnc_init_launcher_tripod; playSound3D ['\geran4\geran_tripod\zapusk.ogg', _this # 0, false, getPosASL (_this # 0), 5]";
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
	
	class Box_IND_AmmoVeh_F;
	class Geran_AmmoBox: Box_IND_AmmoVeh_F
	{
		scope=2;
		scopecurator=2;
		author="DarkBall";
		displayName="Geran-2 Transport Crate";
		maximumLoad=0;
		transportAmmo=0;
		class EventHandlers
		{
			class GeranBox_Init
			{
				init="clearItemCargoGlobal (_this # 0); clearMagazineCargoGlobal (_this # 0); clearWeaponCargoGlobal (_this # 0); clearBackpackCargoGlobal (_this # 0);";
			};
		};
	};
};
class CfgFunctions
{
	class geran4
	{
		class init
		{
			file="geran4\functions\init";
			class handleAnim
			{
			};
			class init_launcher_tripod
			{
			};
			class launch_tripod_projectile
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
			class camCreate
			{
			};
			class initMissile
			{
			};
			class setAngleOfAttack
			{
			};
		};
		class guidance
		{
			file="geran4\functions\geran";
			class getGeranConfidence
			{
			};
			class findGeranTargets
			{
			};
			class selectGeranTarget
			{
			};
			class guideGeran
			{
			};
			class handleGeranMissile
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
	class Geran4_serverInit
	{
		serverInit="call compile preProcessFileLineNumbers '\geran4\XEH_serverInit.sqf'";
	};
};

class RscText;
class ctrlMapEmpty;
class RscControlsGroupNoScrollbars;
class RscMapControl;

class Geran4Line: RscText
{
	text="";
	x=0;
	y=0;
	w=0;
	h=0;
	colorText[]={1,0.78,0.05,0.9};
	colorBackground[]={1,0.78,0.05,0.9};
	shadow=0;
};
class geran_seeker
{
	idd=GERAN_IDD_SEEKER;
	movingEnable=0;
	enableSimulation=1;
	class controls
	{
		class FlightMapFrame: RscText
		{
			idc=GERAN_IDC_MAP_FRAME;
			x="safeZoneX + 0.135 * safeZoneW";
			y="safeZoneY + 0.13 * safeZoneH";
			w="0.73 * safeZoneW";
			h="0.74 * safeZoneH";
			colorBackground[]={0.015,0.025,0.02,0.96};
			show=0;
		};
		class FlightMap: RscMapControl
		{
			idc=GERAN_IDC_MAP;
			x="safeZoneX + 0.14 * safeZoneW";
			y="safeZoneY + 0.14 * safeZoneH";
			w="0.72 * safeZoneW";
			h="0.72 * safeZoneH";
			show=0;
		};
		class HudGroup: RscControlsGroupNoScrollbars
		{
			idc=GERAN_IDC_HUD_GROUP;
			x="safeZoneX";
			y="safeZoneY";
			w="safeZoneW";
			h="safeZoneH";
			class Controls
			{
				class AttackAngle: RscText
				{
					idc=GERAN_IDC_ATTACK_ANGLE;
					text="";
					x="0.43 * safeZoneW";
					y="0.035 * safeZoneH";
					w="0.14 * safeZoneW";
					h="0.045 * safeZoneH";
					style=2;
					font="RobotoCondensed";
					sizeEx="0.027 * safeZoneH";
					colorText[]={0.2,1,0.25,0.96};
					colorBackground[]={0,0,0,0};
					shadow=1;
				};
				class CursorShadowLeft: Geran4Line
				{
					idc=GERAN_IDC_CURSOR_SHADOW_LEFT;
					colorBackground[]={0.01,0.015,0.02,0.78};
				};
				class CursorShadowRight: CursorShadowLeft
				{
					idc=GERAN_IDC_CURSOR_SHADOW_RIGHT;
				};
				class CursorShadowTop: CursorShadowLeft
				{
					idc=GERAN_IDC_CURSOR_SHADOW_TOP;
				};
				class CursorShadowBottom: CursorShadowLeft
				{
					idc=GERAN_IDC_CURSOR_SHADOW_BOTTOM;
				};
				class CursorLeft: Geran4Line
				{
					idc=GERAN_IDC_CURSOR_LEFT;
					colorBackground[]={1,1,1,0.96};
				};
				class CursorRight: CursorLeft
				{
					idc=GERAN_IDC_CURSOR_RIGHT;
				};
				class CursorTop: CursorLeft
				{
					idc=GERAN_IDC_CURSOR_TOP;
				};
				class CursorBottom: CursorLeft
				{
					idc=GERAN_IDC_CURSOR_BOTTOM;
				};
				class SelectionTop: Geran4Line
				{
					idc=GERAN_IDC_SELECTION_TOP;
					show=0;
				};
				class SelectionRight: Geran4Line
				{
					idc=GERAN_IDC_SELECTION_RIGHT;
					show=0;
				};
				class SelectionBottom: Geran4Line
				{
					idc=GERAN_IDC_SELECTION_BOTTOM;
					show=0;
				};
				class SelectionLeft: Geran4Line
				{
					idc=GERAN_IDC_SELECTION_LEFT;
					show=0;
				};
				class TrackTop: Geran4Line
				{
					idc=GERAN_IDC_TRACK_TOP;
					show=0;
					colorBackground[]={0.25,1,0.25,0.95};
				};
				class TrackRight: TrackTop
				{
					idc=GERAN_IDC_TRACK_RIGHT;
				};
				class TrackBottom: TrackTop
				{
					idc=GERAN_IDC_TRACK_BOTTOM;
				};
				class TrackLeft: TrackTop
				{
					idc=GERAN_IDC_TRACK_LEFT;
				};
			};
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
			texture="geran4\textures\blank_ca.paa";
		};
	};
};
