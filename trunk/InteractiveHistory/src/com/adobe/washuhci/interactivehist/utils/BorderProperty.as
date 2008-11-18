package com.adobe.washuhci.interactivehist.utils
{
	import com.degrafa.core.IGraphicsFill;
	import com.degrafa.core.IGraphicsStroke;
	import com.degrafa.geometry.Path;
	import com.degrafa.paint.SolidFill;
	import com.degrafa.paint.SolidStroke;
	
	public class BorderProperty
	{
		public var time:Number;
		
		private var _path:Path;
		
		public function BorderProperty(time:Number, data:Path)
		{
			this.time = time;
			this.data = data;
		}

		public function get data():Path {
			return _path;
		}
		public function set data(path:Path):void {
			_path = path;
		}
		
		public function set fill(fill:SolidFill):void {
			_path.fill = fill;
		}
		
		public function get fillAlpha():Number {
			if(_path.fill is SolidFill) {
				var fill:SolidFill = _path.fill as SolidFill;
				return fill.alpha;
			}
			return -1;
		}
		public function set fillAlpha(alpha:Number):void {
			if(_path.fill is SolidFill) {
				var fill:SolidFill = _path.fill as SolidFill;
				fill.alpha = alpha;
			}
		}
		
		public function set stroke(stroke:SolidStroke):void {
			_path.stroke = stroke;
		}
		
		public function get strokeAlpha():Number {
			if(_path.stroke is SolidStroke) {
				var stroke:SolidStroke = _path.stroke as SolidStroke;
				return stroke.alpha;
			}
			return -1;
		}
		public function set strokeAlpha(alpha:Number):void {
			if(_path.stroke is SolidStroke) {
				var stroke:SolidStroke = _path.stroke as SolidStroke;
				stroke.alpha = alpha;
			}
		}
	}
}