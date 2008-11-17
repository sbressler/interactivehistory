package com.adobe.washuhci.interactivehist.display
{
	import com.adobe.washuhci.interactivehist.utils.BorderProperty;
	import com.degrafa.GeometryGroup;
	import com.degrafa.core.IGraphicsFill;
	import com.degrafa.core.IGraphicsStroke;
	import com.degrafa.geometry.Path;
	import com.degrafa.paint.SolidFill;
	
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
		private var _fill:IGraphicsFill;
		private var _stroke:IGraphicsStroke;
		
		public function Border(name:String = "Border")
		{
			// pass in embedded sprite
			super(BorderSprite, name);
			label = name;
			
			_borderDisplay = new GeometryGroup();
			_borderDisplay.target = this;
			_borderData = new Array();
			
			sprite.blendMode = BlendMode.INVERT;
			this.swapChildren(sprite,_borderDisplay);
			
			_borderDisplay.x = -sprite.width/2;
			_borderDisplay.y = -sprite.height/2;
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
				if(border.time <= time) start = border;
				else {
					end = border;
					break;
				}
			}
			
			if(start != null && end != null) {
				var timeRange:Number = end.time - start.time;
				var t:Number = (time-start.time)/timeRange;
				start.fillAlpha = (1-t);
				end.fillAlpha = t;
				start.strokeAlpha = (1-t);
				end.strokeAlpha = t;
			}
		}
		
		public function get fill():IGraphicsFill {
			return _fill;
		}
		public function set fill(value:IGraphicsFill):void {
			_fill = value;
			
			for each(var border:BorderProperty in _borderData) {
				border.fill = value;
			}
		}
		
		public function get stroke():IGraphicsStroke {
			return _stroke;
		}
		public function set stroke(value:IGraphicsStroke):void {
			_stroke = value;
			
			for each(var border:BorderProperty in _borderData) {
				border.stroke = value;
				trace(border.time);
			}
		}
		
		public function set scale(scaleUniform:Number):void {
			_borderDisplay.scaleX = scaleUniform;
			_borderDisplay.scaleY = scaleUniform;
		}
		
	}
}