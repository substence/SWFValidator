package
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.xml.XMLNode;

	public class DataDrivenSWF extends Sprite
	{
		private var _xml:XML;
		
		public function DataDrivenSWF(swf:DisplayObject, xml:XML)
		{
			addChild(swf);
			_xml = xml;
			validate();
		}
		
		private function validate():void
		{
			for each (var node:* in _xml.popup) 
			{
				trace(node);	
			}			
		}
	}
}