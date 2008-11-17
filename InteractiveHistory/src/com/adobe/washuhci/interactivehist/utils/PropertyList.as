package com.adobe.washuhci.interactivehist.utils
{
	import com.adobe.washuhci.interactivehist.display.MapItem;
	
	import flash.geom.Point;
	import flash.geom.Transform;
	
	public class PropertyList
	{
		public var location:Point;
		public var scaleX:Number;
		public var scaleY:Number;
		public var rotation:Number;
		public var transform:Transform;
		public var alpha:Number;
		
		public var time:Number;
		
		public function PropertyList(_caller:MapItem = null, _time:Number = 0)
		{
			if(_caller != null) {
				location = _caller.location;
				scaleX = _caller.scaleX;
				scaleY = _caller.scaleY;
				rotation = _caller.rotation;
				transform = _caller.transform;
				alpha = _caller.alpha;
			} else {
				location = new Point(0,0);
				scaleX = 1.0;
				scaleY = 1.0;
				rotation = 0;
				// transform = new Transform(null);
				alpha = 1.0;
			}
			
			time = _time;
		}
		
		public function interpolate(otherProps:PropertyList, t:Number):PropertyList
		{
			var tStart:Number = time;
			var tEnd:Number = otherProps.time;
			
			if(tStart != tEnd) {
				var interpolated:PropertyList = new PropertyList();
				var weight:Number = (t-tStart)/(tEnd-tStart);
				
				interpolated.location.x = ((1-weight)*this.location.x)+(weight*otherProps.location.x);
				interpolated.location.y = ((1-weight)*this.location.y)+(weight*otherProps.location.y);
				interpolated.scaleX = ((1-weight)*this.scaleX)+(weight*otherProps.scaleX);
				interpolated.scaleY = ((1-weight)*this.scaleY)+(weight*otherProps.scaleY);
				interpolated.rotation = ((1-weight)*this.rotation)+(weight*otherProps.rotation);
				// interpolated.transform = ((1-weight)*this.transform)+(weight*otherProps.transform);
				interpolated.alpha = ((1-weight)*this.alpha)+(weight*otherProps.alpha);
				
				return interpolated;
			} else {
				return this;
			}	
		}

	}
}