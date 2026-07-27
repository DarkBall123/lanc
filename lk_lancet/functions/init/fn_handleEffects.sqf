private _ppGrain  = ppEffectCreate ["DynamicBlur",500];
_ppGrain ppEffectAdjust [0.2];
   
private _ppcolor = ppEffectCreate ["FilmGrain",2000]; 
_ppcolor ppEffectAdjust [0.19,1,1,0.5,0.5,true]; 



private _effects = [_ppGrain, _ppcolor];
{
	_x ppEffectCommit 0;
	_x ppEffectEnable true;
}forEach _effects;

uiNamespace setVariable ["lancet_effectsArr",  _effects];
