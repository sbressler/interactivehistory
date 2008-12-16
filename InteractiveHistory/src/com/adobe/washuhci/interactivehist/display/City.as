package com.adobe.washuhci.interactivehist.display
{
	import flash.display.BlendMode;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class City extends MapItem
	{
		/*[Embed("/icons/placeIcons.swf", symbol="CityIcon")]
		private const CitySprite:Class;
		
		private const TEXTFIELD_NAME:String = "text";*/
		private const DEFAULT_CITY_RADIUS:Number = 3;
		
		private var _cityRadius:Number;
		
		private var _textField:TextField;
		private var _textFormat:TextFormat;
		
		public function City(name:String = "City")
		{
			// pass in embedded sprite
			super(name);
			
			_textFormat = new TextFormat();
			_textFormat.color = 0xffffff;
			_textFormat.size = 14;
			
			_textField = new TextField();
			_textField.autoSize = TextFieldAutoSize.LEFT;
			_textField.x = 10;
			_textField.y = -8;
			_textField.defaultTextFormat = _textFormat;
			_textField.height = 14+4;
			
			_cityRadius = DEFAULT_CITY_RADIUS;
			
			//_sprite.addChild(_textField);
			//_sprite.blendMode = BlendMode.LAYER;
			//_sprite.addEventListener(MouseEvent.MOUSE_OVER, handleMouseOver);
			
			this.useHandCursor = true;
			this.buttonMode = true;
			this.addChild(_textField);
			this.blendMode = BlendMode.LAYER;
			this.mouseChildren = false;
			this.addEventListener(MouseEvent.MOUSE_OVER, handleMouse);
			this.addEventListener(MouseEvent.MOUSE_OUT, handleMouse);
			
			label = name;
			
			redrawCity();
		}
		
		private function handleMouse(me:MouseEvent):void {
			switch(me.type) {
				case MouseEvent.MOUSE_OVER:
					_textFormat.bold = true;
					redrawCity(_cityRadius + 2);
					break;
				case MouseEvent.MOUSE_OUT:
					_textFormat.bold = false;
					redrawCity();
					break;
				default: break;
			}
			_textField.setTextFormat(_textFormat);
		}
		
		private function redrawCity(radius:Number = Number.NEGATIVE_INFINITY):void {
			_textField.x = 5 + _cityRadius;
			this.graphics.clear();
			if(selected) {
				this.graphics.beginFill(0xffffff,0.9);
				this.graphics.drawRoundRect(-(5+_cityRadius),-(5+_cityRadius), 2*(_cityRadius) + 10 + _textField.x+_textField.width, 2*_cityRadius + 10, 15, 15);
				this.graphics.endFill();
				_textFormat.color = 0x000000;
				_textFormat.bold = true;
				_textField.setTextFormat(_textFormat);
			} else {
				_textFormat.color = 0xffffff;
				_textFormat.bold = false;
				_textField.setTextFormat(_textFormat);
			}
			this.graphics.beginFill((selected) ? 0x000000 : 0xffffff,1.0);
			this.graphics.drawCircle(0,0, (radius != Number.NEGATIVE_INFINITY) ? radius : _cityRadius);
			this.graphics.endFill();
		}
		
		public function sizeTo(zoomLevel:Number):void {
			if(zoomLevel) {
				_cityRadius = DEFAULT_CITY_RADIUS*(3*zoomLevel / this.zoomLevelView);
				redrawCity();
			}
		}
		
		// getters / setters
		
		public override function set label(value:String):void {
			super.label = value;
			_textField.text = value;
		}
		
		public override function set selected(value:Boolean):void {
			super.selected = value;
			this.mouseEnabled = !this.selected;
		}
		
	}
}