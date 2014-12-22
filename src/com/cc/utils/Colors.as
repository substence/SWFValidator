package com.cc.utils
{
	import flash.geom.ColorTransform;

	public class Colors
	{
		// Basic colors
		public static const RED:uint = 0xFF0000;
		public static const GREEN:uint = 0x00FF00;
		public static const BLUE:uint = 0x0000FF;
		public static const YELLOW:uint = 0xFFFF00;
		public static const CYAN:uint = 0x00FFFF;
		public static const MAGENTA:uint = 0xFF00FF;
		public static const WHITE:uint = 0xFFFFFF;
		public static const BLACK:uint = 0x000000;
		public static const GRAY:uint = 0x999999;
		public static const ORANGE:uint = 0xFF6600;
		public static const PURPLE:uint = 0x6600CC;
		
		// Specialized colors
		public static const GREY_BACKGROUND:uint = 0x485555;
		
		public static const GREEN_OUTLINE:uint = 0x07ce93;
		public static const GREEN_GRADIENT:uint = 0x1c5c3e
		public static const SCANLINE_GREEN:uint = 0x003333;
				
		public static const ORANGE_BAB_COUNTDOWN:uint = 0xcca732;
		
		public static const LOST_TECH_ORANGE:uint = 0xFFA500;
		public static const TECH_ITEM_CLASS_MILITARY:uint = 0x44CD8C;
		public static const TECH_ITEM_CLASS_THORIUM:uint = 0x6736AB;
		public static const TECH_ITEM_CLASS_EPIC:uint = 0xDAC18B;
		public static const TECH_ITEM_CLASS_LIMITED:uint = 0xE4351B;
		
		public static const LEVEL_BACKGROUND:uint = 0x293a41;
		public static const LEVEL_OUTLINE:uint = 0x7f7f7f;
		public static const LEVEL_COUNT:uint = 0xfdd406;
		
		public static const PVP_STORE_SHIMMER:uint = 0xDDEEFF;
		
		public static const UNIQUE_UNIT:uint = 0xDAC18B;

		public static const STORE_UNLOCKED:uint = 0x038770;
		public static const STORE_LOCKED:uint = 0x7b0d00;
		public static const STORE_SOLD_OUT:uint = 0xff0000;

		public static const STORE_ITEM_CURRENCY:int = 0x13473f;
		public static const STORE_ITEM_CURRENCY_2:int = 0x10785d;
		public static const STORE_ITEM_CURRENCY_UNLOCKED:int = 0x024575 ;
		public static const STORE_ITEM_CURRENCY_UNLOCKED_2:int = 0x316C9F;
		public static const STORE_ITEM_CURRENCY_BACK:int = 0x24353c;
		
		public static const STORE_ITEM_FRAME:int = 0x07ce93;
		public static const STORE_ITEM_FRAME_NEW:int = 0xffa200;//0xfff624;
		public static const STORE_ITEM_FRAME_UNLOCKED:int = 0x2C8FD6;
		
		public static const STORE_ITEM_SALE:int = 0xFBF619;
		
		public static const CONTEXT_MENU_LINE:int = 0x42ce8b;
		public static const CONTEXT_MENU_ERROR_LINE:int = 0xed8885;
		public static const CONTEXT_MENU_ERROR_FILL:int = 0x331b1b;
		
		public static const STAT_BAR_BACKGROUND:int = 0x18272b;
		public static const STAT_BAR_DARK:int = 0x10785d;
		public static const STAT_BAR_LIGHT:int = 0x13473f;
		public static const STAT_BAR_UPGRADE_DARK:int = 0x7f7f00;
		public static const STAT_BAR_UPGRADE_LIGHT:int = 0xbfbf00;
		public static const AMMO_BAR_OUTLINE:int = 0x6736AB;
		public static const AMMO_BAR_BACKGROUND:int = 0x2b182b;
		public static const AMMO_BAR_OUTLINE_LOW:int = 0x670000;
		public static const AMMO_BAR_BACKGROUND_LOW:int = 0x2b0000;
		
		public static const UNIT_SELECTION_RED:int = 0xFF3F36;
		public static const UNIT_SELECTION_BLUE:int = 0x36BDFF;
		
		// WidgetPlatoonButton outlines
		public static const PLATOON_BUTTON_BASE_DEFENDER:uint = 0xffa200;
		public static const PLATOON_BUTTON_AIRCRAFT:uint = 0x44bfff;
		public static const PLATOON_BUTTON_UNDEPLOYED:uint = 0x06ce92;
		public static const PLATOON_BUTTON_WORLD_MAP:uint = 0x07b4ce;
		public static const PLATOON_BUTTON_DEPOSIT:uint = 0xffa200;
		public static const PLATOON_BUTTON_LOCKED:uint = 0xff5151;
		public static const PLATOON_BUTTON_OVER_CAPACITY:uint = 0xffd74e;
		
		public static const PLATOON_DEAD:uint = 0xff6368;
		
		public static function createColorTintTransform(color:uint, tint:Number):ColorTransform
		{
			return createRGBTintTransform(extractRed(color),extractGreen(color),extractBlue(color),tint);
		}
		
		public static function createRGBTintTransform(red:uint,green:uint,blue:uint, tint:Number):ColorTransform
		{
			var ctMul:Number=(1-tint);
			var ctRedOff:Number=Math.round(tint*red);
			var ctGreenOff:Number=Math.round(tint*green);
			var ctBlueOff:Number=Math.round(tint*blue);
			
			return new ColorTransform(ctMul,ctMul,ctMul,1,ctRedOff,ctGreenOff,ctBlueOff,0);
		}
				
		public static function extractRed(color:uint):uint 
		{
			return (( color >> 16 ) & 0xFF);
		}
		
		public static function extractGreen(color:uint):uint 
		{
			return ( (color >> 8) & 0xFF );
		}
		
		public static function extractBlue(color:uint):uint 
		{
			return ( color & 0xFF );
		}
		
		public static function getHexColorString(color:uint):String
		{			
			var red:int = (color >> 16) & 0xff;
			var green:int =  (color >>  8) & 0xff;
			var blue:int =  color & 0xff;
			
			var string:String = '#';
			string += red>=10?red.toString(16):'0'+red.toString(16);
			string += green>=10?green.toString(16):'0'+green.toString(16);
			string += blue>=10?blue.toString(16):'0'+blue.toString(16);
			
			return string;
		}
	}
}