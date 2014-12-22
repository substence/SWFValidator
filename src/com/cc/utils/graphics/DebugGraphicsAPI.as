package com.cc.utils.graphics
{
	import com.adverserealms.log.Logger;
	import com.cc.battle.AIBox2;
	import com.cc.chat.Channel;
	import com.cc.utils.Colors;
	import com.cc.utils.console.ConsoleController;
	
	import flash.display.Sprite;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.Dictionary;

	public class DebugGraphicsAPI
	{
CONFIG::debug
{
		private static var _channelByName:Dictionary = new Dictionary();
		private static var _layerNameByChannelName:Dictionary = new Dictionary();
		private static var _channelAutoFlush:Dictionary = new Dictionary();		
		
		public static const SUB_CHANNEL_NONE:String = "";
		public static const LAYER_TOP:String = "top";
		public static const LAYER_UI:String = "ui";
		
		
		public static function recreateAllChannels():void
		{
			// If the MAP object has reset the graphics layers (for example, when switching from scouting a base to attacking it), we need
			// to recreate all debug draw channels.
			for (var channelName:String in _channelByName)
			{
				var layerName:String = _layerNameByChannelName[channelName];
				removeChannel(channelName);
				addChannel(channelName, layerName);
			}
		}
		
		public static function getChannel(channelName:String, subChannelName:String = SUB_CHANNEL_NONE):GraphicsChannel
		{
			var graphicsChannel:GraphicsChannel = _channelByName[channelName] as GraphicsChannel;
			
			if (subChannelName != null && subChannelName != SUB_CHANNEL_NONE )
			{
				graphicsChannel = graphicsChannel.getSubChannel(subChannelName);
			}
			
			return graphicsChannel;
		}
		
		public static function addChannel(channelName:String, layerName:String = LAYER_TOP):GraphicsChannel
		{
			// Remove duplicates
			if (_channelByName[channelName] != null)
			{
				if (_layerNameByChannelName[channelName] == layerName)
				{
					Logger.console("Warning: DebugGraphicsAPI channel '" + channelName + "' already exists; cannot add the same channel to the same layer multiple times.");
					return _channelByName[channelName];
				}
				
				Logger.console("Warning: DebugGraphicsAPI channel '" + channelName + "' already exists on a different layer; overwriting with new channel.");
				removeChannel(channelName);
			}
			
			var channel:GraphicsChannel =  new GraphicsChannel(channelName)
			_channelByName[channelName] = channel;
			_layerNameByChannelName[channelName] = layerName;
			
			var layer:Sprite = null;
			
			if(layerName != LAYER_UI)
			{
				layer = MAP.getDebugGraphicsLayer(layerName);
			}
			else
			{
				layer = GLOBAL._layerDebug;
			}
			
			if (layer != null && !layer.contains(channel.canvas))
			{
				layer.addChild(channel.canvas);
			}

			AIBox2.instance.debugGraphicsAPISetIsEnabled(channelName, SUB_CHANNEL_NONE, channel.enabled); // Sychronize state with AIBox
			
			return channel;
		}
		
		public static function addSubChannel(channelName:String, subChannelName:String, layerName:String = LAYER_TOP):void
		{
			var graphicsChannel:GraphicsChannel = getChannel(channelName);
			if(graphicsChannel)
			{
				graphicsChannel.addSubChannel(subChannelName);
				enableChannel(channelName,subChannelName);
			}
		}
		
		public static function removeSubChannel(channelName:String, subChannelName:String):void
		{
			var graphicsChannel:GraphicsChannel = getChannel(channelName);
			if(graphicsChannel)
			{
				graphicsChannel.removeSubChannel(subChannelName);
				disableChannel(channelName,subChannelName);
			}
		}
		
		public static function removeChannel(channelName:String):void
		{
			var graphicsChannel:GraphicsChannel = getChannel(channelName, SUB_CHANNEL_NONE);
			if(graphicsChannel)
			{
				var layer:Sprite = MAP.getDebugGraphicsLayer(_layerNameByChannelName[channelName]);
				if(graphicsChannel.canvas != null && layer != null && layer.contains(graphicsChannel.canvas))
				{
					layer.removeChild(graphicsChannel.canvas);
				}
				
				delete _channelByName[channelName];
				delete _layerNameByChannelName[channelName];				
				
				AIBox2.instance.debugGraphicsAPISetIsEnabled(channelName,SUB_CHANNEL_NONE, false); // Sychronize state with AIBox
			}
			else
			{
				Logger.console("Warning: Cannot remove DebugGraphicsAPI channel '" + channelName + "' because it does not exist.");
			}
		}
		
		public static function removeAllChannels():void
		{
			for (var channel:String in _channelByName)
			{
				removeChannel(channel);
			}
		}
		
		public static function enableChannel(channelName:String, subChannel:String = SUB_CHANNEL_NONE):void
		{
			var graphicsChannel:GraphicsChannel = getChannel(channelName,subChannel);
			if (graphicsChannel)
			{
				graphicsChannel.enabled = true;
				
				AIBox2.instance.debugGraphicsAPISetIsEnabled(channelName, subChannel, graphicsChannel.enabled); // Sychronize state with AIBox
			}
		}
		
		public static function disableChannel(channelName:String, subChannel:String = SUB_CHANNEL_NONE):void
		{
			var graphicsChannel:GraphicsChannel = getChannel(channelName,subChannel);
			if (graphicsChannel)
			{
				graphicsChannel.enabled = false;
				AIBox2.instance.debugGraphicsAPISetIsEnabled(channelName, subChannel, graphicsChannel.enabled); // Sychronize state with AIBox
			}
		}
		
		public static function disableAllChannels():void
		{
			for (var channelName:String in _channelByName)
			{
				disableChannel(channelName);
			}
		}	
				
		public static function toggleChannel(channelName:String, subChannel:String = SUB_CHANNEL_NONE):void
		{
			var graphicsChannel:GraphicsChannel = getChannel(channelName,subChannel);
			if (graphicsChannel)
			{
				graphicsChannel.enabled = !graphicsChannel.enabled;
				AIBox2.instance.debugGraphicsAPISetIsEnabled(channelName, subChannel, graphicsChannel.enabled); // Sychronize state with AIBox
			}
		}
		
		public static function isChannelEnabled(channelName:String, subChannelName:String = SUB_CHANNEL_NONE):Boolean
		{
			var channel:GraphicsChannel = getChannel(channelName,subChannelName);
			if(channel != null)
			{
				return channel.enabled;
			}
			return false;
		}
				
		public static function flushChannel(channelName:String, subChannelName:String = SUB_CHANNEL_NONE):void
		{
			var graphicsChannel:GraphicsChannel = getChannel(channelName, subChannelName);

			if(graphicsChannel && graphicsChannel.enabled)
			{
				graphicsChannel.flush();
			}
		}
		
		public static function autoFlushChannel(channelName:String, subChannelName:String, frameSkip:int):void
		{
			var graphicsChannel:GraphicsChannel = getChannel(channelName, subChannelName);
			if(graphicsChannel)
			{
				graphicsChannel.setAutoFlush(frameSkip);
			}
		}
		
		public static function drawLine(channelName:String, subChannelName:String, x1:Number, y1:Number, x2:Number, y2:Number, thickness:Number, color:uint, alpha:Number):void
		{
			var graphicsChannel:GraphicsChannel = getChannel(channelName,subChannelName);
			if(graphicsChannel && graphicsChannel.enabled)
			{
				graphicsChannel.drawLine(x1,y1,x2,y2, thickness,color,alpha);
			}
		}
		
		public static function drawCircle(channelName:String, subChannelName:String, x:Number, y:Number,radius:Number, thickness:Number, color:uint, alpha:Number, fillColor:uint = 0, fillAlpha:Number = 0):void
		{
			var graphicsChannel:GraphicsChannel = getChannel(channelName,subChannelName);
			if(graphicsChannel && graphicsChannel.enabled)
			{
				graphicsChannel.drawCircle(x, y, radius, thickness, color, alpha, fillColor, fillAlpha);
			}
		}

		public static function drawEllipse(channelName:String, subChannelName:String, x:Number, y:Number, width:Number, height:Number, thickness:Number, color:uint, alpha:Number, fillColor:uint = 0, fillAlpha:Number = 0):void
		{
			var graphicsChannel:GraphicsChannel = getChannel(channelName,subChannelName);
			if(graphicsChannel && graphicsChannel.enabled)
			{
				graphicsChannel.drawEllipse(x, y, width, height, thickness, color, alpha, fillColor, fillAlpha);
			}
		}
		
		public static function drawText(channelName:String, subChannelName:String, x:Number, y:Number, text:String, fontSize:Number, fontColour:Number = Colors.WHITE, startAlpha:Number = 1.0, alignment:String = TextFormatAlign.LEFT, endAlpha:Number = 1.0, time:Number = Number.MAX_VALUE, endX:Number = Number.MAX_VALUE, endY:Number = Number.MAX_VALUE ):void
		{
			var graphicsChannel:GraphicsChannel = getChannel(channelName,subChannelName);
			if(graphicsChannel && graphicsChannel.enabled)
			{
				graphicsChannel.drawText(x,y,text,fontSize,fontColour, startAlpha, alignment, endAlpha, time, endX, endY);
			}
		}
		
		public static function drawTriangles(channelName:String, subChannelName:String,vertices:Vector.<Number>, edgeColour:uint, edgeAlpha:Number, edgeThickness:Number, fillColor:uint, fillAlpha:Number):void
		{
			var graphicsChannel:GraphicsChannel = getChannel(channelName,subChannelName);
			if(graphicsChannel && graphicsChannel.enabled)
			{
				graphicsChannel.drawTriangles(vertices, edgeColour, edgeAlpha, edgeThickness, fillColor, fillAlpha);
			}
		}
		
		public static function drawRoundedRectangleISO(channelName:String, subChannelName:String, x:Number, y:Number, width:Number, height:Number, ellipseWidth:Number, ellipseHeight:Number, thickness:Number, color:uint, alpha:Number, fillColor:uint = 0, fillAlpha:Number = 0):void
		{
			var graphicsChannel:GraphicsChannel = getChannel(channelName,subChannelName);
			if(graphicsChannel && graphicsChannel.enabled)
			{
				graphicsChannel.drawRoundedRectangleISO(x, y, width, height, ellipseWidth, ellipseHeight, thickness, color, alpha, fillColor, fillAlpha);
			}
		}
		
		public static function tickFast():void
		{
			for each(var channel:GraphicsChannel in _channelByName)
			{
				channel.tickFast();
			}		
		}
		
		public static function activeChannels():Boolean
		{
			var activeChannels:int = 0;
			for each(var channel:GraphicsChannel in _channelByName)
			{
				if(channel.enabled)
				{
					return true;
				}
			}	
			
			return false;
		}
		
		public static function registerConsoleCommands():void
		{
			// User friendly aliases for the original commands. If we like these better, delete the old debug commands.
			ConsoleController.Instance.RegisterCommand("debugDraw", DebugToggleChannel, "debugDraw channelName - Enables the requested debug draw channel, or disables it if it is alreayd active");	
			ConsoleController.Instance.RegisterCommand("debugDrawList", DebugShowChannels, "debugDrawList - Lists all active channels and indicates if they are enabled");	
			ConsoleController.Instance.RegisterCommand("debugDrawStop", DebugDisableAllChannels, "debugDrawStop - Disables all active debug draw channels");	
			
			ConsoleController.Instance.RegisterCommand("gChannelList", DebugShowChannels, "graphicsChannelList - Lists all active channels and indicates if they are enabled");	
			ConsoleController.Instance.RegisterCommand("gChannelAdd", DebugAddChannel, "graphicsChannelAdd channelName - Adds the channel to the scene");	
			ConsoleController.Instance.RegisterCommand("gChannelRemove", DebugRemoveChannel, "graphicsChannelRemove channelName - remove the channel from the scene ");	
			ConsoleController.Instance.RegisterCommand("gChannelFlush", DebugFlush, "gChannelFlush channelName - Flushes the channel");	
			ConsoleController.Instance.RegisterCommand("gChannelEnable", DebugEnableChannel, "graphicsChannelEnable channelName - enables the channel");	
			ConsoleController.Instance.RegisterCommand("gChannelDisable", DebugDisableChannel, "graphicsChannelDisable channelName - disables the channel");	
			ConsoleController.Instance.RegisterCommand("gChannelDisableAll", DebugDisableAllChannels, "graphicsChannelDisableAll disables all channels");	
			ConsoleController.Instance.RegisterCommand("gDrawLine", DebugDrawLine, "debugDrawLine - channelName x1 y1 x2 y2 thickness color alpha");	
			ConsoleController.Instance.RegisterCommand("gDrawCircle", DebugDrawCircle, "debugDrawCircle - channelName x y radius thickness color alpha fillColor fillAlpha ");	
			ConsoleController.Instance.RegisterCommand("gDrawEllipse", DebugDrawCircle, "debugDrawEllipse - channelName x y width height thickness color alpha fillColor fillAlpha ");	
			ConsoleController.Instance.RegisterCommand("gDrawText", DebugDrawText, "graphicsDrawText - channelName x y text font size ");	
			ConsoleController.Instance.RegisterCommand("gDrawRoundRectISO", DebugDrawRoundedISO, "debugDrawRoundedRectangleISO - channelName x y ellipseHight ellipseWidth thickness color alpha fillColor fillAlpha ");	
			
			ConsoleController.Instance.RegisterCommand("gChannelAutoFlush", DebugAutoFlushChannel, "gChannelAutoFlush - channelName frameskip ");	
		}
		
		public static function DebugAddChannel(args:Array = null):void
		{
			if (args != null && args.length == 1)
			{
				addChannel(args[0]);
			}
			else if (args != null && args.length == 2)
			{
				addChannel(args[0], args[1]);
			}
		}
		
		public static function DebugRemoveChannel(args:Array = null):void
		{
			if (args != null && args.length == 1)
			{
				removeChannel(args[0]);
			}
		}
		
		public static function DebugEnableChannel(args:Array = null):void
		{
			if (args != null && args.length == 1)
			{
				enableChannel(args[0]);
			}
		}
		
		public static function DebugDisableChannel(args:Array = null):void
		{
			if (args != null && args.length == 1)
			{
				disableChannel(args[0]);
			}
		}
		
		public static function DebugToggleChannel(args:Array = null):void
		{
			if (args != null && args.length == 1)
			{
				if (isChannelEnabled(args[0]))
				{
					disableChannel(args[0]);
				}
				else
				{
					enableChannel(args[0]);
				}
			}
			else
			{
				// If no arguments were specified, show the list of available channels
				ConsoleController.Instance.ParseInput("debugDrawList");
			}
		}
		
		public static function DebugDisableAllChannels(args:Array = null):void
		{
			if (args == null)
			{
				disableAllChannels();
			}
		}
		
		public static function DebugFlush(args:Array = null):void
		{
			if (args != null && args.length == 1)
			{
				flushChannel(args[0]);
			}
		}
		
		public static function DebugDrawLine(args:Array = null):void
		{
			if (args != null && args.length == 9)
			{
				var index:int = 0;
				drawLine(args[index++], args[index++]/*subchannel*/, Number(args[index++]), Number(args[index++]), Number(args[index++]), Number(args[index++]), Number(args[index++]), uint(args[index++]),Number(args[index++]));
			}
		}
		
		public static function DebugDrawCircle(args:Array = null):void
		{
			if (args != null && args.length == 10)
			{
				var index:int = 0;
				drawCircle(args[index++], args[index++]/*subchannel*/, Number(args[index++]) /*x*/, Number(args[index++])/*y*/, Number(args[index++])/*radius*/, Number(args[index++])/*thickness*/, uint(args[index++])/*color*/,Number(args[index++])/*alpha*/,Number(args[index++])/*fillColor*/,Number(args[index++])/*FillAlpha*/);
			}
		}
		
		public static function DebugDrawRoundedISO(args:Array = null):void
		{
			if (args != null && args.length == 13)
			{
				var index:int = 0;
				drawRoundedRectangleISO(args[index++], args[index++]/*subchannel*/, Number(args[index++]) /*x*/, Number(args[index++])/*y*/, Number(args[index++])/*width*/, Number(args[index++])/*height*/,Number(args[index++])/*ellispeWidth*/, Number(args[index++])/*ellipseHeight*/, Number(args[index++])/*thickness*/, uint(args[index++])/*color*/,Number(args[index++])/*alpha*/,uint(args[index++])/*fillColor*/,Number(args[index++])/*FillAlpha*/);
			}
		}
		
		public static function DebugDrawText(args:Array = null):void
		{
			if (args != null && args.length == 6)
			{
				var index:int = 0;
				drawText(args[index++]/*channel*/,args[index++]/*subchannel*/, Number(args[index++]) /*x*/, Number(args[index++])/*y*/, args[index++]/*text*/, args[index++]/*fontsize*/);
			}
		}
	
		public static function DebugShowChannels(args:Array = null):void
		{
			for each( var channelName:GraphicsChannel in  _channelByName)
			{
				if(channelName)
				{
					var state:String = channelName.enabled ? "+ ":"  ";
					Logger.console(state + channelName.name + " (layer: " + _layerNameByChannelName[channelName.name] + ")");
				}
			}
		}
		
		public static function DebugAutoFlushChannel(args:Array = null):void
		{
			if(args != null && args.length == 3)
			{
				autoFlushChannel(args[0], args[1]/*subchannel*/,int(args[2]));
			}
		}
				
}//CONFIG::debug
	}
}