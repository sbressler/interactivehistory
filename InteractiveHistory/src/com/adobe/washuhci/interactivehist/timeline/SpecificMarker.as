package com.adobe.washuhci.interactivehist.timeline
{
	import flash.display.Shape;
	
	public class SpecificMarker extends TimelineMarker
	{
		private var _color:uint = 0x3333aa;
		
		private var _width:Number;
		private var _height:Number;
		
		public function SpecificMarker()
		{
			super();

			_height = 30;
		}
		
		private function init():void {
			// format text here
			redraw();
		}
		
		public override function redraw():void {
			this.graphics.clear();
			this.graphics.beginFill(_color,0.5);
			this.graphics.drawRect(0,0,_width,_height);
			this.graphics.endFill();
		}
		
		public override function set width(value:Number):void {
			_textField.width = value;
			_width = value;
			redraw();
		}
		
	}
}