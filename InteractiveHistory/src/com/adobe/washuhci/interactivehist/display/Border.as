package com.adobe.washuhci.interactivehist.display
{
	import flash.display.Sprite;
	import flash.text.TextField;
	
	public class Border extends MapItem
	{
		[Embed("/icons/placeIcons.swf", symbol="BorderIcon")]
		private const BorderSprite:Class;
		
		private const TEXTFIELD_NAME:String = "text";
		
		public function Border(name:String = "Border")
		{
			// pass in embedded sprite
			super(BorderSprite, name);
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