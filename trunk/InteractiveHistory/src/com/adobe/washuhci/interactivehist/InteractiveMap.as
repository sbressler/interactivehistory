package com.adobe.washuhci.interactivehist
{
	import com.adobe.wheelerstreet.fig.panzoom.ImageViewer;
	
	import flash.display.BlendMode;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Label;
	import mx.events.FlexEvent;

	public class InteractiveMap extends ImageViewer
	{
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
		 public var selected:MapItem = null;

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
			
			_cities = new Array();
			
			injectCityData();
			
			for each(var city:City in _cities) {
				city.blendMode = BlendMode.INVERT;
				city.mouseChildren = false;
				city.addEventListener(MouseEvent.CLICK,selectItem);
			}
			
			addEventListener(FlexEvent.CREATION_COMPLETE, handleCreationComplete);
			function handleCreationComplete(e:FlexEvent):void
			{
				//_xOffset = _contentRectangle.x;
				//_yOffset = _contentRectangle.y;
				//_zoom = _contentRectangle.zoom;
				
				// center map to greece?
			}

		}
		
		private function injectCityData():void {
			var athens:City = new City();
			athens.location = new Point(203.71,52);
			athens.timeStart = -1400;
			athens.timeEnd = 2008;
			athens.text = "Athens";
			_cities[0] = athens;
			
			var rome:City = new City();
			rome.location = new Point(192.48,48.11);
			rome.timeStart = -753;
			rome.timeEnd = 2008;
			rome.text = "Rome";
			_cities[1] = rome;
			
			var carthage:City = new City();
			carthage.location = new Point(190.22,53.15);
			carthage.timeStart = -1215;
			carthage.timeEnd = 2008;
			carthage.text = "Carthage";
			_cities[2] = carthage;
		}
		
		private function selectItem(me:MouseEvent):void {
			if(me.target is City) {
				var selectedCity:City = me.target as City;
				selected = selectedCity;
				
				// dont want to pan, just select
				me.stopImmediatePropagation();
			}
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
		public function set showPlacesCities(doShow:Boolean):void {
			_showPlacesCities = doShow;
			
			var city:City;
			if(doShow) {
				for each(city in _cities) {
					this.addChild(city);
				}
			} else {
				for each(city in _cities) {
					if(this.contains(city)) this.removeChild(city);
				}
			}
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
				
				for each(var city:City in _cities) {
					city.updateDisplay(time,timeZoom);
				
					var viewLoc:Point = contentCoordstoViewCoords(geoCoordsToPixels(city.location));
					city.x = viewLoc.x;
					city.y = viewLoc.y;
					
					if(city.x < 0 || (city.x+city.width) >= viewRect.width || city.y < 0 || (city.y+city.height) >= viewRect.height) {
						if(this.contains(city)) this.removeChild(city);
					} else if(!this.contains(city)) this.addChild(city);
				}
			}
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