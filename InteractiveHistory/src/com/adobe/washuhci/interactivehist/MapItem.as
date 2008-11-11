package com.adobe.washuhci.interactivehist
{
	import flash.display.Sprite;
	import flash.geom.Point;
	
	public class MapItem extends Sprite implements Displayable
	{
		private var _timeStart:Number;
		private var _timeEnd:Number;
		private var _location:Point;
		
		private var _startProperties:PropertyList;
		private var _endProperties:PropertyList;
		
		private var _checkpoints:Array;
		
		public function MapItem()
		{
			_checkpoints = new Array();
			_startProperties = new PropertyList(this);
			_endProperties = new PropertyList(this);
			
			// TESTING:
			_endProperties.alpha = 0.5;
		}
		
		public function get timeStart():Number {
			return _timeStart;
		}
		public function set timeStart(tStart:Number):void {
			_timeStart = tStart;
			_startProperties.time = _timeStart;
		}
		
		public function get timeEnd():Number {
			return _timeEnd;
		}
		public function set timeEnd(tEnd:Number):void {
			_timeEnd = tEnd;
			_endProperties.time = _timeEnd;
		}
		
		public function get location():Point {
			return _location;
		}
		public function set location(loc:Point):void {
			_location = loc;
			_startProperties.location = _location;
			_endProperties.location = _location;
		}

		public function updateDisplay(time:Number, timeResolution:Number):void
		{
			var interpolateStart:PropertyList = _startProperties;
			var interpolateEnd:PropertyList = _endProperties;
			
			for each(var checkpointProps:PropertyList in _checkpoints) {
				if(checkpointProps.time <= time) {
					interpolateStart = checkpointProps;
				}
				else {
					interpolateEnd = checkpointProps;
					break;
				}
			}
			
			applyProperties(interpolateStart.interpolate(interpolateEnd, time));
		}
		
		private function applyProperties(props:PropertyList):void {
			this.location = props.location;
			this.scaleX = props.scaleX;
			this.scaleY = props.scaleY;
			this.rotation = props.rotation;
			// this.transform = props.transform;
			this.alpha = props.alpha;
		}
		
	}
}