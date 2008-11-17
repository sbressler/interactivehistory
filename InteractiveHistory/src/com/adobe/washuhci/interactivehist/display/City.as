package com.adobe.washuhci.interactivehist.display
{
	import flash.display.Sprite;
	import flash.text.TextField;
	
	public class City extends MapItem
	{
		[Embed("/icons/placeIcons.swf", symbol="CityIcon")]
		private const CitySprite:Class;
		
		private const TEXTFIELD_NAME:String = "text";
		
		public function City(name:String = "City")
		{
			// pass in embedded sprite
			super(CitySprite, name);
			label = name;
		}
		
		public override function set label(value:String):void {
			super.label = value;
			
			var nameField:TextField = sprite.getChildByName(TEXTFIELD_NAME) as TextField;
			if(nameField != null) {
				nameField.text = value;
			}
		}
		
	}
}