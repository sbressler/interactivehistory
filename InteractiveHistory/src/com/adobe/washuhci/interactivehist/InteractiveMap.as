package com.adobe.washuhci.interactivehist
{
	import com.adobe.washuhci.interactivehist.display.*;
	import com.adobe.wheelerstreet.fig.panzoom.ImageViewer;
	import com.degrafa.geometry.Path;
	import com.degrafa.paint.SolidFill;
	import com.degrafa.paint.SolidStroke;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.net.URLRequest;
	
	import mx.events.FlexEvent;
	import mx.events.ResizeEvent;

	public class InteractiveMap extends ImageViewer
	{
		public var latitudeMin:Number = 0;
		public var latitudeMax:Number = 180;
		public var longitudeMin:Number = 0;
		public var longitudeMax:Number = 360;
		
		[Bindable]
		public var timeMin:Number = -3200;
		[Bindable]
		public var timeMax:Number = 400;
		
		private var _cities:Array;
		private var _cityLayer:Sprite;
		private var _borders:Array;
		private var _borderLayer:Sprite;
		
		[Bindable]
		public var time:Number = timeMin;
		private var _timeResolution:Number = 20.0;
		[Bindable]
		public var selected:MapItem = null;

		private var _showOverlaysRainfall:Boolean = false;
		private var _showOverlaysClimate:Boolean = false;
		private var _showOverlaysTemperature:Boolean = false;
		private var _showOverlaysElevation:Boolean = false;
		private var _showPlacesCities:Boolean = true;
		private var _showPlacesBattles:Boolean = false;
		private var _showBorderCultural:Boolean = false;
		private var _showBorderPolitical:Boolean = false;
				
		private var _clippingPane:Sprite = null;
		 
		// ELEVATION
		private var _elevation:Bitmap = null;
		private var _elevationSprite:Sprite = null;
		private const ELEVATION_URL:URLRequest = new URLRequest("/images/Elevation.jpg");
		
		// TEMPERATURE
		private var _temperature:Bitmap = null;
		private var _temperatureSprite:Sprite = null;
		private const TEMPERATURE_URL:URLRequest = new URLRequest("/images/Temperature.gif");
		
		// CLIMATE
		private var _climate:Bitmap = null;
		private var _climateSprite:Sprite = null;
		private const CLIMATE_URL:URLRequest = new URLRequest("/images/Climate.jpg");
		
		// RAINFALL
		private var _rainfall:Bitmap = null;
		private var _rainfallSprite:Sprite = null;
		private const RAINFALL_URL:URLRequest = new URLRequest("/images/Rainfall.gif");
		
		// svg background
		//[Embed(source="/images/svg_blankmap.svg")]
		private var _SVGMap:Class;
		private var _svgBg:Sprite;
		private var _svgWidth:Number;
		private var _svgHeight:Number;
		
		/**
		private var _clippingPane:Sprite = null;
		
		// ELEVATION
		private var _elevation:Bitmap = null;
		private var _elevationSprite:Sprite = null;
		
		// svg background
		//[Embed(source="/images/svg_blankmap.svg")]
		private var _SVGMap:Class;
		private var _svgBg:Sprite;
		private var _svgWidth:Number;
		private var _svgHeight:Number;
		
		/**
		 * We can keep track of the contentRectangle's position,
		 * and know where to position the icons on the next paint job.
		 **/
		
		/////////////////////////////////////////////////////////
		//
		// constructor
		//
		/////////////////////////////////////////////////////////
		
		public function InteractiveMap()
		{
			super();
			
			_cities = new Array();
			_cityLayer = new Sprite();
			this.addChild(_cityLayer);
			_borders = new Array();
			_borderLayer = new Sprite();
			this.addChild(_borderLayer);
			
			injectCityData();
			
			for each(var city:City in _cities) {
				//city.mouseChildren = false;
				city.addEventListener(MouseEvent.CLICK,selectItem);
			}
			
			for each(var border:Border in _borders) {
				//border.blendMode = BlendMode.INVERT;
				//border.mouseChildren = false;
				border.addEventListener(MouseEvent.CLICK,selectItem);
			}
			
			// INIT OVERLAYS
			_elevationSprite = new Sprite();
			_temperatureSprite = new Sprite();
			_rainfallSprite = new Sprite();
			_climateSprite = new Sprite();
			var bitmapLoader:Loader = new Loader();
			trace("InteractiveMap:  loading overlays...");
			bitmapLoader.load(TEMPERATURE_URL);
			bitmapLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, handleBitmapLoad);
			function handleBitmapLoad(e:Event):void {
				var loadedURL:String = bitmapLoader.contentLoaderInfo.url;
				loadedURL = loadedURL.substring(loadedURL.lastIndexOf(":")+1,loadedURL.length);
				switch(loadedURL) {
					case TEMPERATURE_URL.url:
						_temperature = Bitmap(bitmapLoader.content);
						bitmapLoader.load(CLIMATE_URL); break;
					case CLIMATE_URL.url:
						_climate = Bitmap(bitmapLoader.content);
						bitmapLoader.load(RAINFALL_URL); break;	
					case RAINFALL_URL.url:
						_rainfall = Bitmap(bitmapLoader.content); 
						bitmapLoader.load(ELEVATION_URL); break;
					case ELEVATION_URL.url:
						_elevation = Bitmap(bitmapLoader.content); 
						trace("InteractiveMap:  overlays loaded."); break;
					default: break;
				}
			}
			
			addEventListener(FlexEvent.CREATION_COMPLETE, handleCreationComplete);
			function handleCreationComplete(e:FlexEvent):void
			{
				createClippingMask();
				_contentRectangle.centerToPoint(new Point(width/2,height));
			}
			
			addEventListener(ResizeEvent.RESIZE, handleResize);
			function handleResize(re:ResizeEvent):void {
				if(_clippingPane != null) {
					_clippingPane.width = width;
					_clippingPane.height = height;
				}
			}
			
			/**addEventListener(MouseEvent.CLICK, handleClick);
			function handleClick(me:MouseEvent):void {
				selected = null;
			}**/

		}
		
		private function createClippingMask():void {
			if(_clippingPane == null) {
				_clippingPane = new Sprite();
				this.mask = _clippingPane;
				this.addChild(_clippingPane);
				_clippingPane.graphics.beginFill(0x000000,1.0);
				_clippingPane.graphics.drawRect(0,0,this.width,this.height);
			}
		}
		
		private function injectCityData():void {
			addCitiesToArray("Athens",23.716647,37.97918,1,-1400);
//			addCitiesToArray("Corinth",22.930936,37.936326,-1000);
			addCitiesToArray("Sparta",22.42499,37.074009,1,-2000,-320);
//			addCitiesToArray("Megara",23.351562,37.996996,-1500);
//			addCitiesToArray("Thebes",23.319409,38.318873,-1100);
//			addCitiesToArray("Eleusis",23.53898,38.040808,-1700);
			addCitiesToArray("Thessalonica",22.972547,40.625034,4,-315);
			addCitiesToArray("Byzantium",28.975926,41.01237900000001,3,-677);
			addCitiesToArray("Syracuse",14.985618,37.063022,3,-734);
			addCitiesToArray("Rome",12.482324,41.895466,1,-753);
			addCitiesToArray("Tyre",35.19480900000001,33.274413,4,-2750);
			addCitiesToArray("Carthage",10.227771,36.851776,3,-1215,-160);
			addCitiesToArray("Jerusalem",35.20070000000001,31.7857,1,-3000);
//			addCitiesToArray("Ashkelon",34.559466,31.665944,-1350);
			addCitiesToArray("Paphos",32.405472,34.768295,5,-2500);
//			addCitiesToArray("Sidon",35.388969,33.570702,-4000);
			addCitiesToArray("Gaza",34.308826,31.314394,2,-3000);
			addCitiesToArray("Neapolis",14.252871,40.839997,4,-600);
			addCitiesToArray("Messana",15.556732,38.192188,5,-750);
			addCitiesToArray("Messalia",5.383221,43.298344,5,-600,300);
			addCitiesToArray("Cyrene",21.855004,32.825077,3,-630,250);
			addCitiesToArray("Tarsus",34.90010000000001,36.9201,4,-1500);
//			addCitiesToArray("Delphi",22.508669,38.480738,-1500);
//			addCitiesToArray("Mycenae",22.756092,37.730907,-1800);
//			addCitiesToArray("Argos",22.679458,37.59789600000001,-1700);
//			addCitiesToArray("Tiryns",22.799892,37.599461,-1400);
			addCitiesToArray("Knossos",25.178604,35.285424,2,-2000);
			addCitiesToArray("Halicarnassus",27.429043,37.037964,3,-800,0);
//			addCitiesToArray("Miletus",27.283333,37.516667,-1900);
			addCitiesToArray("Troy",26.236038,39.976067,1,-3000,-800);
			addCitiesToArray("Mytilene",26.599445,39.056667,3,-800,-450);
//			addCitiesToArray("Naxos",25.38109,37.108501,-1000);
			addCitiesToArray("Samos",26.980459,37.761539,5,-1000);
			addCitiesToArray("Nineveh",43.157265,36.364925,4,-1800);
			addCitiesToArray("Babylon",44.420883,32.536504,1,-3000);
//			addCitiesToArray("Damascus",36.2939,33.5158,-1800);
			addCitiesToArray("Susa",48.25093,32.19059,2,-3200, -330);
			addCitiesToArray("Persepolis",52.9,29.9333,2,-1250);

//			var athens:City = new City("Athens");
//			athens.location = new Point(203.71,52);
//			athens.timeStart = -1400;
//			athens.timeEnd = 2008;
//			_cities[0] = athens;
//			
//			var rome:City = new City("Rome");
//			rome.location = new Point(192.48,48.11);
//			rome.timeStart = -753;
//			rome.timeEnd = 2008;
//			_cities[1] = rome;
//			
//			var carthage:City = new City("Carthage");
//			carthage.location = new Point(190.22,53.15);
//			carthage.timeStart = -1215;
//			carthage.timeEnd = 2008;
//			_cities[2] = carthage;

			
			var macedonia:Border = new Border("Macedon");
			macedonia.location = new Point(230,41);
			macedonia.timeStart = -1020;
			macedonia.timeEnd = 400;
			var check1:Path = new Path();
			check1.data = "M195.82,89.084c-4.713,0-18.849-3.142-29.844-4.188" + 
					"c-10.994-1.047-48.69,23.561-33.507,29.32s24.083,38.22,44.502,17.801s48.168-2.094,60.733-0.523s31.413-45.55,10.471-40.838" + 
					"s-35.602,6.283-41.885,4.188S195.82,89.084,195.82,89.084z";
			macedonia.addCheckpoint(-1020,check1);
			var check2:Path = new Path();
			check2.data = "M167.548,53.482c-16.39,5.853-30.891-37.696-42.409-17.801s-4.712,41.361-11.518,47.12" + 
					"s-3.665,26.178,4.712,29.319s20.942,16.23,16.754,23.561s9.948,33.508,37.173,20.942s48.691-13.612,66.492-9.424" + 
					"s53.928-48.168,36.126-55.498s-50.262-4.188-61.78-15.183S174.878,50.865,167.548,53.482z";
			macedonia.addCheckpoint(-500,check2);
			var check3:Path = new Path();
			check3.data = "M123.569,12.645c-11.519-5.236-75.917-14.66-91.1-11.519S-13.081,30.97,7.338,36.205" + 
					"s54.974-8.377,61.256-2.094s-3.141,20.419-8.9,27.225s-49.738,48.168-26.702,61.257s34.031,49.738,79.581,47.12" + 
					"c45.549-2.618,63.875,9.424,72.251,9.424s92.67-16.231,100-40.838s28.271-58.638,1.57-64.397s-39.267,3.665-55.497-7.854" + 
					"s-51.309-47.12-72.775-48.691C136.658,15.786,123.569,12.645,123.569,12.645z";
			macedonia.addCheckpoint(300,check3);
			var stroke:SolidStroke = new SolidStroke();
			stroke.color = 0xffffff;
			stroke.alpha = 0.5;
			stroke.weight = 1;
			var fill:SolidFill = new SolidFill();
			fill.color = 0xffffff;
			fill.alpha = 0.0;
			macedonia.stroke = stroke;
			macedonia.fill = fill;
			_borders[0] = macedonia;
		}
		
		private function addCitiesToArray(name:String, longitude:Number, latitude:Number, zoomLevelView:Number, start:Number, end:Number = 2008):void {
			var city:City = new City(name);
			city.location = new Point(180+longitude,90-latitude);
			city.timeStart = start;
			city.timeEnd = end;
			city.zoomLevelView = zoomLevelView;
			_cities[_cities.length] = city;
		}
		
		private function selectItem(me:MouseEvent):void {
			if(selected != null) selected.selected = false;
			
			if(me.target is City) {
				var selectedCity:City = me.target as City;
				selected = selectedCity;
				selected.selected = true;
			}
			else if(me.target is Border) {
				var selectedBorder:Border = me.target as Border;
				selected = selectedBorder;
				selected.selected = true;
			}
			
			invalidateDisplayList();
		}
		
		[Bindable]
		public function get timeResolution():Number {
			return _timeResolution;
		}
		public function set timeResolution(zLevel:Number):void {
			_timeResolution = Math.round(36/(Math.pow(zLevel+1,2)));
		}
		
		[Bindable]
		public function get showOverlaysRainfall():Boolean {
			return _showOverlaysRainfall;
		}
		public function set showOverlaysRainfall(value:Boolean):void {
			_showOverlaysRainfall = value;
			invalidateDisplayList();
		}
		
		[Bindable]
		public function get showOverlaysClimate():Boolean {
			return _showOverlaysClimate;
		}
		public function set showOverlaysClimate(value:Boolean):void {
			_showOverlaysClimate = value;
			invalidateDisplayList();
		}
		
		[Bindable]
		public function get showOverlaysTemperature():Boolean {
			return _showOverlaysTemperature;
		}
		public function set showOverlaysTemperature(value:Boolean):void {
			_showOverlaysTemperature = value;
			invalidateDisplayList();
		}
		
		[Bindable]
		public function get showOverlaysElevation():Boolean {
			return _showOverlaysElevation;
		}
		public function set showOverlaysElevation(value:Boolean):void {
			_showOverlaysElevation = value;
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
					_cityLayer.addChild(city);
				}
			} else {
				for each(city in _cities) {
					if(_cityLayer.contains(city)) _cityLayer.removeChild(city);
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
		public function set showBorderPolitical(doShow:Boolean):void {
			_showBorderPolitical = doShow;
			
			var border:Border;
			if(doShow) {
				for each(border in _borders) {
					_borderLayer.addChild(border);
				}
			} else {
				for each(border in _borders) {
					if(_borderLayer.contains(border))_borderLayer.removeChild(border);
				}
			}
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
			var viewLoc:Point = null;
			if(showPlacesCities) {
				
				for each(var city:City in _cities) {
					city.updateDisplay(time,timeResolution);
				
					viewLoc = contentCoordstoViewCoords(geoCoordsToPixels(city.location));
					city.x = viewLoc.x;
					city.y = viewLoc.y;
					city.sizeTo(getZoom());
					
//					trace(city.label + " zoom: " + city.zoomLevelView + ", map zoom level: " + getZoom());
					if((city.x+city.width) < 0 || city.x >= viewRect.width || 
						(city.y+city.height) < 0 || city.y >= viewRect.height || 
						city.timeStart-timeResolution > time || city.timeEnd+timeResolution < time || 
						city.zoomLevelView/5.5 > getZoom()) {
							
						if(_cityLayer.contains(city))
							_cityLayer.removeChild(city);
					}
					else if(!_cityLayer.contains(city))
						_cityLayer.addChild(city);
				}
			}
			
			if(showBorderPolitical) {
				
				for each(var border:Border in _borders) {
					border.updateDisplay(time,timeResolution);
				
					viewLoc = contentCoordstoViewCoords(geoCoordsToPixels(border.location));
					border.x = viewLoc.x;
					border.y = viewLoc.y;
					
					border.scale = _contentRectangle.zoom*2.0;
					
					if((border.x+border.width) < 0 || border.x >= viewRect.width || (border.y+border.height) < 0 || border.y >= viewRect.height) {
						if(_borderLayer.contains(border)) _borderLayer.removeChild(border);
					} else if(!_borderLayer.contains(border)) _borderLayer.addChild(border);
				}
			}
			
			var __bitmapTransform:Matrix = null;
			if(showOverlaysElevation && _elevation != null) {
				if(__bitmapTransform == null) {
					__bitmapTransform = new Matrix(_contentRectangle.width / _elevation.width,
												  0,
												  0,
												  _contentRectangle.height / _elevation.height,
												  _contentRectangle.topLeft.x,
												  _contentRectangle.topLeft.y
												  );
				}

				// fill the component with the bitmap.
				_elevationSprite.graphics.clear();
				_elevationSprite.graphics.beginBitmapFill(_elevation.bitmapData,  // bitmapData
										 __bitmapTransform,   // matrix
										 true,                // tile?
										 false		  // smooth?
										 );	 
				
				_elevationSprite.graphics.drawRect(0,0,unscaledWidth, unscaledHeight);
				_elevationSprite.alpha = 0.7;
				
				if(!this.contains(_elevationSprite)) {
					this.addChild(_elevationSprite);
					this.swapChildren(_elevationSprite, _borderLayer);
					this.swapChildren(_borderLayer, _cityLayer); // keep cities on top
				}
			} else {
				if(this.contains(_elevationSprite)) {
					this.removeChild(_elevationSprite);
				}
			}
			
			if(showOverlaysTemperature && _temperature != null) {
				if(__bitmapTransform == null) {
					__bitmapTransform = new Matrix(_contentRectangle.width / _temperature.width,
												  0,
												  0,
												  _contentRectangle.height / _temperature.height,
												  _contentRectangle.topLeft.x,
												  _contentRectangle.topLeft.y
												  );
				}

				// fill the component with the bitmap.
				_temperatureSprite.graphics.clear();
				_temperatureSprite.graphics.beginBitmapFill(_temperature.bitmapData,  // bitmapData
										 __bitmapTransform,   // matrix
										 false,                // tile?
										 false		  // smooth?
										 );	 
				
				_temperatureSprite.graphics.drawRect(0,0,unscaledWidth, unscaledHeight);
				_temperatureSprite.alpha = 0.7;
				
				if(!this.contains(_temperatureSprite)) {
					this.addChild(_temperatureSprite);
					this.swapChildren(_temperatureSprite, _borderLayer);
					this.swapChildren(_borderLayer, _cityLayer); // keep cities on top
				}
			} else {
				if(this.contains(_temperatureSprite)) {
					this.removeChild(_temperatureSprite);
				}
			}
			
			if(showOverlaysClimate && _climate != null) {
				if(__bitmapTransform == null) {
					__bitmapTransform = new Matrix(_contentRectangle.width / _climate.width,
												  0,
												  0,
												  _contentRectangle.height / _climate.height,
												  _contentRectangle.topLeft.x,
												  _contentRectangle.topLeft.y
												  );
				}

				// fill the component with the bitmap.
				_climateSprite.graphics.clear();
				_climateSprite.graphics.beginBitmapFill(_climate.bitmapData,  // bitmapData
										 __bitmapTransform,   // matrix
										 false,                // tile?
										 false		  // smooth?
										 );	 
				
				_climateSprite.graphics.drawRect(0,0,unscaledWidth, unscaledHeight);
				_climateSprite.alpha = 0.7;
				
				if(!this.contains(_climateSprite)) {
					this.addChild(_climateSprite);
					this.swapChildren(_climateSprite, _borderLayer);
					this.swapChildren(_borderLayer, _cityLayer);
				}
			} else {
				if(this.contains(_climateSprite)) {
					this.removeChild(_climateSprite);
				}
			}
			
			if(showOverlaysRainfall && _rainfall != null) {
				if(__bitmapTransform == null) {
					__bitmapTransform = new Matrix(_contentRectangle.width / _rainfall.width,
												  0,
												  0,
												  _contentRectangle.height / _rainfall.height,
												  _contentRectangle.topLeft.x,
												  _contentRectangle.topLeft.y
												  );
				}

				// fill the component with the bitmap.
				_rainfallSprite.graphics.clear();
				_rainfallSprite.graphics.beginBitmapFill(_rainfall.bitmapData,  // bitmapData
										 __bitmapTransform,   // matrix
										 false,                // tile?
										 false		  // smooth?
										 );	 
				
				_rainfallSprite.graphics.drawRect(0,0,unscaledWidth, unscaledHeight);
				_rainfallSprite.alpha = 0.7;
				
				if(!this.contains(_rainfallSprite)) {
					this.addChild(_rainfallSprite);
					this.swapChildren(_rainfallSprite, _borderLayer);
					this.swapChildren(_borderLayer, _cityLayer);
				}
			} else {
				if(this.contains(_rainfallSprite)) {
					this.removeChild(_rainfallSprite);
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
		 	
		 	return new Point((geoPoint.x+longitudeMin)*geoScaleFactorX,(geoPoint.y+latitudeMin)*geoScaleFactorY);
		 }
		 
		 private function contentCoordstoViewCoords(contentCoords:Point):Point {
		 	// we need to find out where the view window is compared to the content rect. (or do we?)
		 	return new Point(contentCoords.x+_contentRectangle.x,contentCoords.y+_contentRectangle.y);
		 }
		
	}
}
