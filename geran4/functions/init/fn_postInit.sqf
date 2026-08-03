[player] call lancet_fnc_addEventHandler;

//every 10 seconds it adds the event handler for fired to all players
if(isServer) then {
	missionNamespace setVariable ["lancet_weaponsArr", ['M_Titan_MIL_AP','M_Titan_MIL_AT','M_Titan_MIL_KE','M_Lancet_MIL_AP','M_Lancet_MIL_AT','M_Lancet_MIL_KE'], true];

/*
	Postinit is allegedly called on each player, so I guess I don't need this...
	lancet_frameIndex = 0;
	private _id = ["lancet_addEHGlobal", "onEachFrame", {
		if(lancet_frameIndex == 600) then {
			lancet_frameIndex = 0;
			{
				[[_x], lancet_fnc_addEventHandler] remoteExec ["spawn", owner _x];
			}forEach allPlayers;
		};
		lancet_frameIndex = lancet_frameIndex + 1;
	}] call BIS_fnc_addStackedEventHandler;
*/
};

