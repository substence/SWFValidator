package com.cc.ui
{
	import com.cc.messenger.Message;
	import com.cc.messenger.Messenger;
	import com.cc.ui.messages.XMLPopupRequest;
	import com.cc.ui.properties.Property;
	
	import flash.utils.Dictionary;

	public class XMLPopupManager
	{
		private var _popupData:Dictionary;
		
		public function XMLPopupManager()
		{
			_popupData = new Dictionary();
			Message.messenger.add(XMLPopupRequest, onDataRequested);
		}
		
		private function onDataRequested(message:XMLPopupRequest):void
		{
			var loader:XMLtoPopupLoader = new XMLtoPopupLoader(message.name);
			loader.signalLoaded.addOnce(loadedContract);
			
			if (message.popup)
			{
				message.popup.properties = getDataForPopup(message.popup.name);
			}
		}
		
		private function loadedContract():void
		{
			// TODO Auto Generated method stub
			
		}
		
		private function getDataForPopup(popupName:String):Vector.<Property>
		{
			return _popupData[popupName]; 
		}
	}
}
import flash.display.Loader;
import flash.display.MovieClip;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.system.ApplicationDomain;
import flash.system.LoaderContext;

import org.osflash.signals.Signal;

class XMLtoPopupLoader
{
	private static const _CONTRACT_DIRECTORY:String = "";
	private var _contractURL:String;
	private var _contract:XMLtoPopupContract
	private var _swf:MovieClip;
	private var _signalLoaded:Signal;
	
	public function XMLtoPopupLoader(contractURL:String)
	{
		_contractURL = _CONTRACT_DIRECTORY + contractURL;
		loadXML();
	}

	private function loadXML():void
	{
		var loader:URLLoader = new URLLoader();
		loader.addEventListener(Event.COMPLETE, loadedXML);
		loader.addEventListener(IOErrorEvent.IO_ERROR, onLoadError);
		loader.load(new URLRequest(_contractURL));
	}
	
	protected function loadedXML(event:Event):void
	{
		_contract = new XMLtoPopupContract(new XML(event.target.data));
		if (_contract.swfPath)
		{
			loadSWF(_contract.swfPath);
		}
	}
	
	private function loadSWF(url:String):void
	{
		var loader:Loader = new Loader(); 
		loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadedSWF); 
		loader.addEventListener(IOErrorEvent.IO_ERROR, onLoadError);
		loader.load(new URLRequest(url), new LoaderContext(false, ApplicationDomain.currentDomain));		
	}
	
	protected function loadedSWF(event:Event):void
	{
		_swf = MovieClip(event.target.content);
		_signalLoaded.dispatch();
	}
	
	protected function onLoadError(event:Event):void
	{
		// TODO Auto-generated method stub
	}

	public function get signalLoaded():Signal
	{
		return _signalLoaded;
	}
}

class Contract
{
	private var _xml:XML;
	private var _swfPath:String;
	private var _symbols:Vector.<XMLtoPopupSymbol>;
	
	public function Contract(xml:XML)
	{
		_swfPath = xml.@path;
		for each (var symbolXML:XML in xml.symbol) 
		{
			var symbol:XMLtoPopupSymbol = new XMLtoPopupSymbol(symbolXML);
			const path:String = popupXML.@path;
			if (path)
			{
				if (swf.loaderInfo.applicationDomain.hasDefinition(path))
				{
					var mcClass:Class = swf.loaderInfo.applicationDomain.getDefinition( path ) as Class;
					var mc:MovieClip = new mcClass() as MovieClip;
					var properties:Vector.<Property> = _propertyFactory.getProperties(mc, popupXML.property);
					var name:String = popupXML.@name ? popupXML.@name : path;
					var popup:XMLtoPopup = new XMLtoPopup(name);
					popups.push(popup);
				}
				else
				{
					error("Popup(" + popupXML.@name + ") could not find '" + path + "' in the library");
				}
			}
			else
			{
				error("Popup(" + popupXML.@name + ") has no path.");
				return;
			}
		}	
	}

	public function get swfPath():String
	{
		return _swfPath;
	}
}

class XMLtoPopupSymbol
{
	private _path:String;
	
	public function XMLtoPopupSymbol(xml:XML)
	{
		_path = popupXML.@path;
	}
}

class Interpreter
{
	private var _contract:Contract;
	private var _xml:XML;
	
	public function Interpreter(xml:XML)
	{
		_xml = xml;
	}
	
	public function interpret()
	{
		_contract = new Contract();
		_contract.swfPath = _xml.@path;
		_contract.symbols = new Vector.<XMLtoPopupSymbol>();
		for each (var symbolXML:XML in xml.symbol) 
		{
			var symbol:XMLtoPopupSymbol = new XMLtoPopupSymbol(symbolXML);
			const path:String = popupXML.@path;
			if (path)
			{
				if (swf.loaderInfo.applicationDomain.hasDefinition(path))
				{
					var mcClass:Class = swf.loaderInfo.applicationDomain.getDefinition( path ) as Class;
					var mc:MovieClip = new mcClass() as MovieClip;
					var properties:Vector.<Property> = _propertyFactory.getProperties(mc, popupXML.property);
					var name:String = popupXML.@name ? popupXML.@name : path;
					var popup:XMLtoPopup = new XMLtoPopup(name);
					popups.push(popup);
				}
				else
				{
					error("Popup(" + popupXML.@name + ") could not find '" + path + "' in the library");
				}
			}
			else
			{
				error("Popup(" + popupXML.@name + ") has no path.");
				return;
			}
		}	
	}
}