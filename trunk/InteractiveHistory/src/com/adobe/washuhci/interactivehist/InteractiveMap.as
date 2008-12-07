package com.adobe.washuhci.interactivehist
{
	import com.adobe.washuhci.interactivehist.display.*;
	import com.adobe.wheelerstreet.fig.panzoom.ImageViewer;
	import com.degrafa.geometry.Path;
	import com.degrafa.paint.SolidStroke;
	
	import flash.display.BlendMode;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
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
		 private var _borders:Array;
		 
		 [Bindable]
		 public var time:Number = timeMin;
		 [Bindable]
		 public var timeResolution:Number = 20.0;
		 [Bindable]
		 public var selected:MapItem = null;

		 private var _showBorderCultural:Boolean = false;
		 private var _showBorderPolitical:Boolean = false;
		 private var _showPlacesCities:Boolean = false;
		 private var _showPlacesBattles:Boolean = false;
		 
		 private var _clippingPane:Sprite = null;
		 
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
			_borders = new Array();
			
			injectCityData();
			
			for each(var city:City in _cities) {
				city.blendMode = BlendMode.LIGHTEN;
				city.mouseChildren = false;
				city.addEventListener(MouseEvent.CLICK,selectItem);
			}
			
			for each(var border:Border in _borders) {
				//border.blendMode = BlendMode.INVERT;
				border.mouseChildren = false;
				border.addEventListener(MouseEvent.CLICK,selectItem);
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
			
			addEventListener(MouseEvent.CLICK, handleClick);
			function handleClick(me:MouseEvent):void {
				selected = null;
			}

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

			
			var macedonia:Border = new Border("MACEDON");
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
			stroke.weight = 3;
			macedonia.stroke = stroke;
			_borders[0] = macedonia;
		}
		
		private function addCitiesToArray(name:String, longitude:Number, latitude:Number, zoomLevelView:Number, start:Number, end:Number = 2008):void {
			var city:City = new City(name);
			city.location = new Point(180+longitude,90-latitude);
			city.timeStart = start;
			city.timeEnd = end;
			city.zoomLevelView = zoomLevelView;
//			trace(city.label + " zoom: " + city.zoomLevelView + ", arg: " + zoomLevelView);
			_cities[_cities.length] = city;
		}
		
		private function selectItem(me:MouseEvent):void {
			if(me.target is City) {
				var selectedCity:City = me.target as City;
				selected = selectedCity;
			}
			else if(me.target is Border) {
				var selectedBorder:Border = me.target as Border;
				selected = selectedBorder;
			}
			
			// quick fix, should handle this in the other mouse handler
			me.stopImmediatePropagation();
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
					this.addChild(border);
				}
			} else {
				for each(border in _borders) {
					if(this.contains(border)) this.removeChild(border);
				}
			}
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
			var viewLoc:Point = null;
			if(showPlacesCities) {
				
				for each(var city:City in _cities) {
					city.updateDisplay(time,timeResolution);
				
					viewLoc = contentCoordstoViewCoords(geoCoordsToPixels(city.location));
					city.x = viewLoc.x;
					city.y = viewLoc.y;
//					trace(city.label + " zoom: " + city.zoomLevelView + ", map zoom level: " + getZoom());
					if((city.x+city.width) < 0 || city.x >= viewRect.width || (city.y+city.height) < 0 || city.y >= viewRect.height || city.timeStart-timeResolution > time || city.timeEnd+timeResolution < time || city.zoomLevelView/5.5 > getZoom()) {
						if(this.contains(city))
							this.removeChild(city);
					}
					else if(!this.contains(city))
						this.addChild(city);
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
						if(this.contains(border)) this.removeChild(border);
					} else if(!this.contains(border)) this.addChild(border);
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
