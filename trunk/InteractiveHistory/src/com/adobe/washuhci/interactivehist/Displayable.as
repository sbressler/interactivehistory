package com.adobe.washuhci.interactivehist
{
	import flash.geom.Point;
	
	public interface Displayable
	{	
		// need to be able to modify it based on current time
		function updateDisplay(time:Number, timeResolution:Number):void;
	}
}