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
			
			this.graphics.beginFill(0xffffff,1.0);
			this.graphics.drawCircle(0,0,5);
			this.graphics.endFill();
			
			//_sprite.addChild(_textField);
			//_sprite.blendMode = BlendMode.LAYER;
			//_sprite.addEventListener(MouseEvent.MOUSE_OVER, handleMouseOver);
			
			this.addChild(_textField);
			this.blendMode = BlendMode.LAYER;
			this.mouseChildren = false;
			this.addEventListener(MouseEvent.MOUSE_OVER, handleMouse);
			this.addEventListener(MouseEvent.MOUSE_OUT, handleMouse);
			
			label = name;
		}
		
		private function handleMouse(me:MouseEvent):void {
			switch(me.type) {
				case MouseEvent.MOUSE_OVER:
					_textFormat.bold = true;
					_textField.x += 2;
					this.graphics.clear();
					this.graphics.beginFill(0xffffff,1.0);
					this.graphics.drawCircle(0,0,7);
					this.graphics.endFill();
					break;
				case MouseEvent.MOUSE_OUT:
					_textFormat.bold = false;
					_textField.x -= 2;
					this.graphics.clear();
					this.graphics.beginFill(0xffffff,1.0);
					this.graphics.drawCircle(0,0,5);
					this.graphics.endFill();
					break;
				default: break;
			}
			_textField.setTextFormat(_textFormat);
		}
		
		// getters / setters
		
		public override function set label(value:String):void {
			super.label = value;
			_textField.text = value;
		}
		
	}
}