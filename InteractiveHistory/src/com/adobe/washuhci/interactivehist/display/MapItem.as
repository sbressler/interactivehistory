package com.adobe.washuhci.interactivehist.display
{
	import com.adobe.washuhci.interactivehist.interfaces.Displayable;
	import com.adobe.washuhci.interactivehist.utils.PropertyList;
	
	import flash.display.Sprite;
	import flash.geom.Point;
	
	public class MapItem extends Sprite implements Displayable
	{
		// basic data for timeline and map
		private var _timeStart:Number;
		private var _timeEnd:Number;
		private var _location:Point;
		
		// any time-dependent property shifts attached to item
		private var _startProperties:PropertyList;
		private var _endProperties:PropertyList;
		private var _checkpoints:Array; // of PropertyList
		
		// the display for the item
		private var _sprite:Sprite;
		private var _label:String;
		
		public function MapItem(SpriteClass:Class, name:String)
		{
			_checkpoints = new Array();
			_startProperties = new PropertyList(this);
			_endProperties = new PropertyList(this);
			
			_sprite = new SpriteClass() as Sprite;
			_label = name;
			
			this.addChild(_sprite);
		}
		
		[Bindable]
		public function get timeStart():Number {
			return _timeStart;
		}
		public function set timeStart(tStart:Number):void {
			_timeStart = tStart;
			_startProperties.time = _timeStart;
		}
		
		[Bindable]
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
		
		public function get sprite():Sprite {
			return _sprite;
		}
		
		[Bindable]
		public function get label():String {
			return _label;
		}
		public function set label(value:String):void {
			_label = value;
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
			
			if(Math.abs(time-_timeStart) <= timeResolution) {
				// alpha goes from 0->1 at time timeStart-timeZoom -> timeStart+timeZoom
				this.alpha *= ((time-(_timeStart-timeResolution))/(2*timeResolution));
				
			} else if(Math.abs(time-_timeEnd)<= timeResolution) {
				// alpha goes from 1->0 at time (timeEnd-timeZoom) -> timeEnd+timeZoom
				this.alpha *= (1-(time-(_timeEnd-timeResolution))/(2*timeResolution));
				
			} else if(time+timeResolution < _timeStart || time-timeResolution > _timeEnd) {
				this.alpha = 0;
			}
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