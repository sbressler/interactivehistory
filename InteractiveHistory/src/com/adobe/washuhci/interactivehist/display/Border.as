package com.adobe.washuhci.interactivehist.display
{
	import com.adobe.washuhci.interactivehist.utils.BorderProperty;
	import com.degrafa.GeometryGroup;
	import com.degrafa.geometry.Path;
	import com.degrafa.paint.SolidFill;
	import com.degrafa.paint.SolidStroke;
	
	import flash.display.BlendMode;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class Border extends MapItem
	{
		/*[Embed("/icons/placeIcons.swf", symbol="BorderIcon")]
		private const BorderSprite:Class;
		
		private const TEXTFIELD_NAME:String = "text";*/
		private var _textField:TextField;
		private var _textFormat:TextFormat;
		
		private var _borderLayer:Sprite;
		private var _borderDisplay:GeometryGroup;
		private var _borderData:Array;
		
		private var _startBorder:BorderProperty = null;
		private var _endBorder:BorderProperty = null;
		
		private var _fill:SolidFill;
		private var _stroke:SolidStroke;
		
		public function Border(name:String = "Border")
		{
			// pass in embedded sprite
			super(name);
			
			_borderLayer = new Sprite();
			_borderDisplay = new GeometryGroup();
			_borderDisplay.target = _borderLayer;
			_borderData = new Array();
			
			_textFormat = new TextFormat();
			_textFormat.color = 0xffffff;
			_textFormat.size = 14;
			_textFormat.letterSpacing = 4;
			
			_textField = new TextField();
			_textField.autoSize = TextFieldAutoSize.LEFT;
			_textField.defaultTextFormat = _textFormat;
			_textField.height = 14+4;
			
			this.addChild(_borderLayer);
			this.addChild(_textField);
			this.blendMode = BlendMode.LAYER;
			this.mouseChildren = false;
			_borderLayer.mouseEnabled = false;
			//_textField.mouseEnabled = false;
			//sprite.blendMode = BlendMode.INVERT;
			//this.swapChildren(sprite,_borderDisplay); // push graphics below labels
			
			label = name;
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
			_textField.text = value;
			
			//var nameField:TextField = sprite.getChildByName(TEXTFIELD_NAME) as TextField;
			/*if(nameField != null) {
				var _textFormat:TextFormat = nameField.getTextFormat();
				nameField.text = value;
				nameField.setTextFormat(_textFormat);
			}*/
		}
		
		public override function updateDisplay(time:Number, timeResolution:Number):void {
			super.updateDisplay(time,timeResolution);
			
			_textField.x = this.width/2;
			_textField.y = this.height/2;
			
			// find which border we need to render now, and what opacity?
			var start:BorderProperty = _startBorder;
			var end:BorderProperty = _endBorder;
			start.strokeAlpha = 0;
			end.strokeAlpha = 0;
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
				if(selected) {
					start.fillAlpha = 0.5 * (1-t);
					end.fillAlpha = 0.5 * t;
				} else {
					start.fillAlpha = fill.alpha * (1-t);
					end.fillAlpha = fill.alpha * t;
				}
				start.strokeAlpha = (1-t);
				end.strokeAlpha = t;
				
			}
			
			// center border graphic?
		}
		
		public override function set selected(value:Boolean):void {
			super.selected = value;
			
			if(selected) _textFormat.color = 0x000000;
			else _textFormat.color = 0xffffff;
			_textField.setTextFormat(_textFormat);
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