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
		private var _zoomLevelView:Number;
		private var _selected:Boolean;
		
		// any time-dependent property shifts attached to item
		private var _checkpoints:Array; // of PropertyList
		
		// the display for the item
		private var _label:String;
		
		// add links for article, search terms
		
		public function MapItem(name:String)
		{
			_checkpoints = new Array();
			_checkpoints[0] = new PropertyList(this);
			_checkpoints[length] = new PropertyList(this);

			_label = name;
			_zoomLevelView = 0;
			_selected = false;
		}
		
		public function get selected():Boolean {
			return _selected;
		}
		public function set selected(value:Boolean):void {
			_selected = value;
		}
		
		[Bindable]
		public function get timeStart():Number {
			return _timeStart;
		}
		public function set timeStart(tStart:Number):void {
			_timeStart = tStart;
			_checkpoints[0].time = _timeStart;
		}
		
		[Bindable]
		public function get timeEnd():Number {
			return _timeEnd;
		}
		public function set timeEnd(tEnd:Number):void {
			_timeEnd = tEnd;
			_checkpoints[length].time = _timeEnd;
		}
		
		public function get location():Point {
			return _location;
		}
		public function set location(loc:Point):void {
			_location = loc;
			_checkpoints[0].location = _location;
			_checkpoints[length].location = _location;
		}
		
		[Bindable]
		public function get zoomLevelView():Number {
			return _zoomLevelView;
		}
		public function set zoomLevelView(zLevel:Number):void {
			_zoomLevelView = zLevel;
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
			var interpolateStart:PropertyList = _checkpoints[0];
			var interpolateEnd:PropertyList = _checkpoints[length];
			
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
		
			if(Math.abs(time-_timeStart) <= timeResolution)
				// alpha goes from 0->1 at time timeStart-timeZoom -> timeStart+timeZoom
				this.alpha *= ((time-(_timeStart-timeResolution))/(2*timeResolution));
			else if(Math.abs(time-_timeEnd)<= timeResolution)
				// alpha goes from 1->0 at time (timeEnd-timeZoom) -> timeEnd+timeZoom
				this.alpha *= (1-(time-(_timeEnd-timeResolution))/(2*timeResolution));
			else if(time+timeResolution < _timeStart || time-timeResolution > _timeEnd)
				this.alpha = 0;
		}
		
		private function applyProperties(props:PropertyList):void {
			this.location = props.location;
			this.scaleX = props.scaleX;
			this.scaleY = props.scaleY;
			this.rotation = props.rotation;
			// this.transform = props.transform;
			this.alpha = props.alpha;
			//this.zoomLevelView = props.zoomLevelView;
		}
		
//		public function addCheckpoint(propList:PropertyList):void {
//			_checkpoints[_checkpoints.length-1] = propList;	
//		}
		
	}
}