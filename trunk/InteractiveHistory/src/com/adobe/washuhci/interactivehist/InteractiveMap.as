package com.adobe.washuhci.interactivehist
{
	import com.adobe.wheelerstreet.fig.panzoom.ImageViewer;
	
	import flash.display.BlendMode;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Label;
	import mx.events.FlexEvent;

	public class InteractiveMap extends ImageViewer
	{
		
		[Embed("assets/placeIcons.swf", symbol="City")]
		public const City:Class;
		public var testCity:Sprite = new City() as Sprite;
		public var testText:TextField = testCity.getChildByName("city_name_txt") as TextField;
		private var loc:Point = new Point(201.5,51);
		private var timeStart:Number = -1100;
		private var timeEnd:Number = 146;
		
		/** What does this need to hold?
		 * Arrays (maps?) of these items:
		 * nations
		 * cities
		 * battles
		 * events
		 * borders
		 * 
		 * ... photos?
		 * */
		 private const DEFAULT_TIME_MIN:Number = -1200;
		 private const DEFAULT_TIME_MAX:Number = 500;
		 
		 public var latitudeMin:Number = 0;
		 public var latitudeMax:Number = 180;
		 public var longitudeMin:Number = 0;
		 public var longitudeMax:Number = 360;
		 
		 [Bindable]
		 public var timeMin:Number = -1200;
		 [Bindable]
		 public var timeMax:Number = 500;
		 
		 // this is where all the data goes
		 // how do we check which ones are displayed?
		 // keep sorted list of all cities (based on intial time)
		 // when user changes time, look at any new cities to be added 
		 //		(timeline val + resolution > start time and timeline val - resolution < end time)
		 private var _cities:Array;
		 // small display window for which cities are currently displayed
		 private var _citiesDisplayed:ArrayCollection;
		 
		// need to define icon classes so we can dynamically add instances
		// and change icon size, text (and fade in/out)
		 
		 // these affect whether or not we display any item
		 [Bindable]
		 public var time:Number = timeMin;
		 [Bindable]
		 public var timeZoom:Number = 25.0;
		 [Bindable]
		 public var selected:String = "";

		 private var _showBorderCultural:Boolean = false;
		 private var _showBorderPolitical:Boolean = false;
		 private var _showPlacesCities:Boolean = false;
		 private var _showPlacesBattles:Boolean = false;

		 private var _timeResolution:Number = (DEFAULT_TIME_MAX-DEFAULT_TIME_MIN)/(timeMax-timeMin);
		 private var _timeResolutionLabel:Label;
		 
		 /**
		 * We can keep track of the contentRectangle's position,
		 * and know where to position the icons on the next paint job.
		 * */
		
		/////////////////////////////////////////////////////////
		//
		// constructor
		//
		/////////////////////////////////////////////////////////
		
		public function InteractiveMap()
		{
			super();
			
			testText.text = "Greece";
			testCity.blendMode = BlendMode.INVERT;
			this.addChild(testCity);
			
			addEventListener(FlexEvent.CREATION_COMPLETE, handleCreationComplete);
			function handleCreationComplete(e:FlexEvent):void
			{
				//_xOffset = _contentRectangle.x;
				//_yOffset = _contentRectangle.y;
				//_zoom = _contentRectangle.zoom;
				
				// center map to greece
				var viewLoc:Point = contentCoordstoViewCoords(geoCoordsToPixels(loc));
				_contentRectangle.centerToPoint(viewLoc);
				
				testCity.addEventListener(MouseEvent.CLICK,selectItem);
			}

		}
		
		private function selectItem(me:MouseEvent):Boolean {
			selected = testText.text;	
			return false;
		}
		
		[Bindable]
		public function get showBorderCultural():Boolean {
			return _showBorderCultural;
		}
		public function set showBorderCultural(value:Boolean):void {
			_showBorderCultural = value;
			invalidateDisplayList();
		}
		
		[Bindable]
		public function get showBorderPolitical():Boolean {
			return _showBorderPolitical;
		}
		public function set showBorderPolitical(value:Boolean):void {
			_showBorderPolitical = value;
			invalidateDisplayList();
		}
		
		[Bindable]
		public function get showPlacesCities():Boolean {
			return _showPlacesCities;
		}
		public function set showPlacesCities(value:Boolean):void {
			_showPlacesCities = value;
			invalidateDisplayList();
		}
		
		[Bindable]
		public function get showPlacesBattles():Boolean {
			return _showPlacesBattles;
		}
		public function set showPlacesBattles(value:Boolean):void {
			_showPlacesBattles = value;
			invalidateDisplayList();
		}
		
		/////////////////////////////////////////////////////////
		//
		// protected overrides
		//		
		/////////////////////////////////////////////////////////

		/**
		 * When the display list is updated the bitmap is drawn via a bitmapFill
		 * applied to the UIComponents graphics layer. The size and position of the bitmap 
		 * are determined by the bitmapData's transform matrix, which is derived by parsing
		 * the _contentRectangle's properties.   
		 * 
		 */
		 
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			// now we need to reposition/scale the icons.
			if(showPlacesCities) {
				//testCity.x = _xLoc+(_contentRectangle.x-((_contentRectangle.scaleX/_zoom)*_xOffset));
				//testCity.y = _yLoc+(_contentRectangle.y-((_contentRectangle.scaleY/_zoom)*_yOffset));
				
				var viewLoc:Point = contentCoordstoViewCoords(geoCoordsToPixels(loc));
				testCity.x = viewLoc.x;
				testCity.y = viewLoc.y;
				
				var alpha:Number = 1.0;
				var scale:Number = 1.0;
				if(time < timeStart) {
					alpha = Math.max((time-timeStart+timeZoom)/timeZoom,0);
				} else if(time > timeEnd) {
					alpha = Math.max((timeEnd-time+timeZoom)/timeZoom,0);
				} else {
					// scale?
				}
				testCity.alpha = Math.min(alpha,1);
				
				if(!this.contains(testCity)) {
					this.addChild(testCity);
				}
			} else if(!showPlacesCities && this.contains(testCity)) {
				this.removeChild(testCity);
			}
			
			trace(_contentRectangle.x);		
		}
		
		/////////////////////////////////////////////////////////
		//
		// protected overrides
		//		
		/////////////////////////////////////////////////////////
		
		/**
		 * Compute the x,y coordinates on the rectangle from latitude and longitude
		 * */
		 
		 private function geoCoordsToPixels(geoPoint:Point):Point
		 {
		 	// find pixel dimensions
		 	var xPixelRange:Number = _contentRectangle.width;
		 	var yPixelRange:Number = _contentRectangle.height;
		 	
		 	// what are the min/max latitude and longitude?
		 	var longitudeRange:Number = longitudeMax - longitudeMin;
		 	var latitudeRange:Number = latitudeMax - latitudeMin;
		 	
		 	// smoothly map lat/long ranges on to map
		 	var geoScaleFactorX:Number = xPixelRange/longitudeRange; // degrees per pixel
		 	var geoScaleFactorY:Number = yPixelRange/latitudeRange;
		 	
		 	return new Point(geoPoint.x*geoScaleFactorX,geoPoint.y*geoScaleFactorY);
		 }
		 
		 private function contentCoordstoViewCoords(contentCoords:Point):Point {
		 	// we need to find out where the view window is compared to the content rect. (or do we?)
		 	return new Point(contentCoords.x+_contentRectangle.x,contentCoords.y+_contentRectangle.y);
		 }
		
	}
}