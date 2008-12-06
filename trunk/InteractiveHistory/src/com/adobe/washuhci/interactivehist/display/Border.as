package com.adobe.washuhci.interactivehist.display
{
	import com.adobe.washuhci.interactivehist.utils.BorderProperty;
	import com.degrafa.GeometryGroup;
	import com.degrafa.geometry.Path;
	import com.degrafa.paint.SolidFill;
	import com.degrafa.paint.SolidStroke;
	
	import flash.display.BlendMode;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class Border extends MapItem
	{
		[Embed("/icons/placeIcons.swf", symbol="BorderIcon")]
		private const BorderSprite:Class;
		
		private const TEXTFIELD_NAME:String = "text";
		
		private var _borderDisplay:GeometryGroup;
		private var _borderData:Array;
		
		private var _startBorder:BorderProperty = null;
		private var _endBorder:BorderProperty = null;
		
		private var _fill:SolidFill;
		private var _stroke:SolidStroke;
		
		public function Border(name:String = "Border")
		{
			// pass in embedded sprite
			super(BorderSprite, name);
			label = name;
			
			_borderDisplay = new GeometryGroup();
			_borderDisplay.target = this;
			_borderData = new Array();
			
			sprite.blendMode = BlendMode.INVERT;
			this.swapChildren(sprite,_borderDisplay); // push graphics below labels
		}
		
		public function addCheckpoint(time:Number, path:Path):void {
			path.fill = _fill;
			path.stroke = _stroke;
			var border:BorderProperty = new BorderProperty(time,path);
			
			if(_startBorder == null) _startBorder = border;
			_endBorder = border;
			
			_borderData[_borderData.length] = border;
			_borderDisplay.geometryCollection.addItem(path);
		}
		
		public override function set label(value:String):void {
			super.label = value;
			
			var nameField:TextField = sprite.getChildByName(TEXTFIELD_NAME) as TextField;
			if(nameField != null) {
				var _textFormat:TextFormat = nameField.getTextFormat();
				nameField.text = value;
				nameField.setTextFormat(_textFormat);
			}
		}
		
		public override function updateDisplay(time:Number, timeResolution:Number):void {
			super.updateDisplay(time,timeResolution);
			
			// find which border we need to render now, and what opacity?
			var start:BorderProperty = _startBorder;
			var end:BorderProperty = _endBorder;
			for each(var border:BorderProperty in _borderData) {
				if(border.time <= time) {
					if(start != null) start.strokeAlpha = 0;
					start = border;
				}
				else {
					end = border;
					break;
				}
			}
						
			if(start != null && end != null && start != end) {
				var timeRange:Number = end.time - start.time;
				var t:Number = (time-start.time)/timeRange;
				start.fillAlpha = (1-t);
				end.fillAlpha = t;
				start.strokeAlpha = (1-t);
				end.strokeAlpha = t;
			}
			
			// center border graphic?
		}
		
		public function get fill():SolidFill {
			return _fill;
		}
		public function set fill(value:SolidFill):void {
			_fill = value;
			
			for each(var border:BorderProperty in _borderData) {
				var fillCopy:SolidFill = new SolidFill();
				fillCopy.alpha = value.alpha;
				fillCopy.color = value.color;
				border.fill = fillCopy;
			}
		}
		
		public function get stroke():SolidStroke {
			return _stroke;
		}
		public function set stroke(value:SolidStroke):void {
			_stroke = value;
			
			for each(var border:BorderProperty in _borderData) {
				var strokeCopy:SolidStroke = new SolidStroke();
				strokeCopy.alpha = value.alpha;
				strokeCopy.color = value.color;
				strokeCopy.weight = value.weight;
				border.stroke = strokeCopy;
			}
		}
		
		public function set scale(scaleUniform:Number):void {
			_borderDisplay.scaleX = scaleUniform;
			_borderDisplay.scaleY = scaleUniform;
		}
		
	}
}