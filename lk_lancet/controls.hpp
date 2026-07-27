#define txtSize 0.7
#define borderSize 0.21

class RscPicture;
class RscText;
class ctrlMapEmpty;
class ctrlStaticBackground;
class lancet_seeker {
    idd = 3737;
    movingEnable = false;

    onMouseMoving = "_this call lancet_fnc_handleMouse";
    
    class controls {
        //["0.15 * safezoneW + safezoneX","0.15 * safezoneH + safezoneY","0.7 * safezoneW","0.7 * safezoneH"]


        class seeker_lock: RscPicture
        {
            idc = 1201;
            text = "lk_lancet\pictures\targetLock.paa";
            //style = ST_MULTI + ST_TITLE_BAR + ST_KEEP_ASPECT_RATIO;
            x = 0.5 - 0.25 / 2; // * safezoneW + safezoneX;
            y = 0.5 - 0.25 / 2; // * safezoneH + safezoneY;
            w = 0.25;
            h = 0.25;
            fade = 1;
            show = 0;

            colorText[] = {1,1,1,0.6};
            //colorBackground[] = {0,0,0,0};

            onLoad = "uiNameSpace setVariable [""DB_seeker_lock"", (_this # 0)]";
        };

        class tx_zoom: RscText
        {
            idc = 1000;
            x = 0.22 * safezoneW + safezoneX;
            y = 0.45 * safezoneH + safezoneY;
            w = 0.1 * safezoneW;
            h = 0.1 * safezoneH;
            font = "LCD14";
            fade = 1;
        };
        class tx_camera: RscText
        {
            idc = 1002;
            x = 0.22 * safezoneW + safezoneX;
            y = 0.49 * safezoneH + safezoneY;
            w = 0.1 * safezoneW;
            h = 0.1 * safezoneH;
            font = "LCD14";
            fade = 1;
        };
        class tx_azimuth: RscText
        {
            idc = 1001;
            x = 0.25 * safezoneW + safezoneX;
            y = 0.87 * safezoneH + safezoneY;
            w = 0.08 * safezoneW;
            h = 0.06 * safezoneH;
            font = "LCD14";
            fade = 1;
        };
        class tx_time: RscText
        {
            idc = 1003;
            x = 0.61 * safezoneW + safezoneX;
            y = 0.87 * safezoneH + safezoneY;
            w = 1 * safezoneW;
            h = 0.06 * safezoneH;
            font = "LCD14";
            fade = 1;
        };
        class tx_lock: RscText
        {
            idc = 1004;
            x = 0.66 * safezoneW + safezoneX;
            y = 0.07  * safezoneH + safezoneY;
            w = 1 * safezoneW;
            h = 0.06 * safezoneH;
            font = "LCD14";
            fade = 1;
        };
        class tx_launchtime: RscText
        {
            idc = 1005;
            x = 0.5 * safezoneW + safezoneX;
            y = 0.87  * safezoneH + safezoneY;
            w = 1 * safezoneW;
            h = 0.06 * safezoneH;
            style = ST_LEFT;
            font = "LCD14";
            fade = 1;
        };
    };

    class controlsBackground {
        class map_background: ctrlMapEmpty 
        {
            idc = -1;
            x = 0;
            y = 0;
            w = 1;
            h = 1;

            onLoad = "(_this # 0) ctrlMapCursor ['', 'BlankCursor']; (_this # 0) ctrlShow false;";
        };
    };
};

