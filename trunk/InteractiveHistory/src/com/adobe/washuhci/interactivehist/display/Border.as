package com.adobe.washuhci.interactivehist.display
{
	import com.degrafa.geometry.Path;
	import com.degrafa.paint.SolidStroke;
	
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class Border extends MapItem
	{
		[Embed("/icons/placeIcons.swf", symbol="BorderIcon")]
		private const BorderSprite:Class;
		
		private const TEXTFIELD_NAME:String = "text";
		
		private const SVG_DATA:String = "M271.616,493.561c-1.114-0.696-2-2.332-2-3.695c0-1.346-1.146-3.592-2.545-4.992\n" + 
											"c-2.105-2.104-3.489-2.545-8-2.545c-5.231,0-5.455,0.108-5.455,2.646c5.972,5.035,12.717,9.272,20.012,12.781\n" + 
											"c-0.003-0.065-0.012-0.129-0.012-0.194C273.616,495.893,272.829,494.317,271.616,493.561z";
		private var basicStroke:SolidStroke;
		private var _textFormat:TextFormat;
		
		private var _border:Path;
		
		public function Border(name:String = "Border")
		{
			// pass in embedded sprite
			super(BorderSprite, name);
			label = name;
			
			basicStroke = new SolidStroke();
			basicStroke.color = 0x000000;
			
			_border = new Path(SVG_DATA);
			_border.stroke = basicStroke;
			_border.graphicsTarget[0] = this;
		}
		
		public override function set label(value:String):void {
			super.label = value;
			
			var nameField:TextField = sprite.getChildByName(TEXTFIELD_NAME) as TextField;
			if(nameField != null) {
				_textFormat = nameField.getTextFormat();
				nameField.text = value;
				nameField.setTextFormat(_textFormat);
			}
		}
		
	}
}