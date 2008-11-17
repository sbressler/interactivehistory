package com.adobe.washuhci.interactivehist.utils
{
	import com.degrafa.core.IGraphicsFill;
	import com.degrafa.core.IGraphicsStroke;
	import com.degrafa.geometry.Path;
	import com.degrafa.paint.SolidFill;
	
	public class BorderProperty
	{
		public var time:Number;
		
		private var _path:Path;
		
		public function BorderProperty(time:Number, data:Path)
		{
			this.time = time;
			this.data = data;
		}

		public function set data(path:Path):void {
			_path = path;
		}
		
		public function set fill(fill:IGraphicsFill):void {
			_path.fill = fill;
		}
		
		public function set fillAlpha(alpha:Number):void {
			if(_path.fill is SolidFill) {
				var fill:SolidFill = _path.fill as SolidFill;
				fill.alpha = alpha;
			}
		}
		
		public function set stroke(stroke:IGraphicsStroke):void {
			_path.stroke = stroke;
		}
	}
}