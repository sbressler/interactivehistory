package com.adobe.washuhci.interactivehist
{
	import flash.display.Sprite;
	import flash.text.TextField;
	
	public class City extends MapItem
	{
		[Embed("assets/placeIcons.swf", symbol="CityIcon")]
		private const CitySprite:Class;
		
		private var _sprite:Sprite;
		private var _text:String;
		
		private const TEXTFIELD_NAME:String = "text";
		
		public function City()
		{
			super();
			
			_sprite = new CitySprite() as Sprite;
			this.addChild(_sprite);
		}
		
		public function get text():String {
			return _text;
		}
		public function set text(value:String):void {
			_text = value;
			
			var nameField:TextField = _sprite.getChildByName(TEXTFIELD_NAME) as TextField;
			if(nameField != null) {
				nameField.text = _text;
			}
		}
		
	}
}