package com.cc.utils
{
	import flash.display.Sprite;
	import flash.geom.Point;

	public class GraphUtils
	{
		//the wedgeData is an array of objects with 'val' (degrees) and 'color' propteries.
		//Ex: [{val:51,color:0x00CCFF},{val:31,color:0xCC0000},{val:10,color:0x00CC66},{val:4,color:0xFF9966},{val:3,color:0x999999];
		//each wedge has a 'val' and the sum of all these vals consitutes all 360 degrees of the pie.  So, if you only supply two slices
		// with vals of 10 and 20, the pie will still be filled.  If you don't want to fill the whole pie, then override the 'totalValue'
		// parameter with a custom sum of the slices
		static public function drawPieGraph(drawShape:Sprite, centerX:Number, centerY:Number, radius:Number, wedgeData:Array, totalValue:Number = 0):void
		{
			drawShape.graphics.clear();
			drawShape.x = centerX;
			drawShape.y = centerY;
			drawShape.graphics.lineStyle(1, 0xFFFFFF);
			
			if (totalValue == 0)
			{
				for (var u:int = 0; u<wedgeData.length; u++)
				{
					totalValue += wedgeData[u].val;
				}
			}
			var degreesPerVal:Number = 360 / totalValue;
			var previousDegree:Number = 0;
			for (var l:int = 0; l<wedgeData.length; l++)
			{
				drawWedge(drawShape, radius, previousDegree, degreesPerVal * wedgeData[l].val + previousDegree, wedgeData[l].color);
				previousDegree = degreesPerVal * wedgeData[l].val + previousDegree;
			}
		}
		
		static private function drawWedge(drawShape:Sprite, radius:Number, startDeg:Number, endDeg:Number, color:int):void
		{
			drawShape.graphics.beginFill(color);
			drawShape.graphics.moveTo(0, 0);
			for (var i:int = startDeg; i<=endDeg; i++)
			{
				var rad:Number = i / 180 * Math.PI - Math.PI / 2.0;
				drawShape.graphics.lineTo(radius * Math.cos(rad), radius * Math.sin(rad));
			}
			drawShape.graphics.endFill();
		}
	}
}