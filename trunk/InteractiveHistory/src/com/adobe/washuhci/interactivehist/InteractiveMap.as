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
		 public var timeMin:Number = -1200;
		 [Bindable]
		 public var timeMax:Number = 500;
		 
		 private var _cities:Array;
		 private var _borders:Array;
		 
		 [Bindable]
		 public var time:Number = timeMin;
		 [Bindable]
		 public var timeZoom:Number = 20.0;
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
				city.blendMode = BlendMode.INVERT;
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
			addCitiesToArrayNoEnd("Athens",23.716647,37.97918,-1400);
			addCitiesToArrayNoEnd("Corinth",22.930936,37.936326,-1000);
			addCitiesToArrayNoEnd("Sparta",22.42499,37.074009,-2000);
			addCitiesToArrayNoEnd("Megara",23.351562,37.996996,-1500);
			addCitiesToArrayNoEnd("Thebes",23.319409,38.318873,-1100);
			addCitiesToArrayNoEnd("Eleusis",23.53898,38.040808,-1700);
			addCitiesToArrayNoEnd("Thessalonica",22.972547,40.625034,-315);
			addCitiesToArrayNoEnd("Byzantium",28.975926,41.01237900000001,-677);
			addCitiesToArrayNoEnd("Syracuse",14.985618,37.063022,-734);
			addCitiesToArrayNoEnd("Rome",12.482324,41.895466,-753);
			addCitiesToArrayNoEnd("Tyre",35.19480900000001,33.274413,-2750);
			addCitiesToArrayNoEnd("Carthage",10.227771,36.851776,-1215);
			addCitiesToArrayNoEnd("Jerusalem",35.20070000000001,31.7857,-3000);
			addCitiesToArrayNoEnd("Ashkelon",34.559466,31.665944,-1350);
			addCitiesToArrayNoEnd("Paphos",32.405472,34.768295,-2500);
			addCitiesToArrayNoEnd("Sidon",35.388969,33.570702,-4000);
			addCitiesToArrayNoEnd("Gaza",34.308826,31.314394,-3000);
			addCitiesToArrayNoEnd("Neapolis",14.252871,40.839997,-600);
			addCitiesToArrayNoEnd("Messana",15.556732,38.192188,-750);
			addCitiesToArrayNoEnd("Messalia",5.383221,43.298344,-600);
			addCitiesToArrayNoEnd("Cyrene",21.855004,32.825077,-630);
			addCitiesToArrayNoEnd("Tarsus",34.90010000000001,36.9201,-1500);
			addCitiesToArrayNoEnd("Delphi",22.508669,38.480738,-1500);
			addCitiesToArrayNoEnd("Mycenae",22.756092,37.730907,-1800);
			addCitiesToArrayNoEnd("Argos",22.679458,37.59789600000001,-1700);
			addCitiesToArrayNoEnd("Tiryns",22.799892,37.599461,-1400);
			addCitiesToArrayNoEnd("Knossos",25.178604,35.285424,-2000);
			addCitiesToArrayNoEnd("Halicarnassus",27.429043,37.037964,-800);
			addCitiesToArrayNoEnd("Miletus",27.283333,37.516667,-1900);
			addCitiesToArrayNoEnd("Troy",26.236038,39.976067,-3000);
			addCitiesToArrayNoEnd("Mytilene",26.599445,39.056667,-800);
			addCitiesToArrayNoEnd("Naxos",25.38109,37.108501,-1000);
			addCitiesToArrayNoEnd("Samos",26.980459,37.761539,-1000);
			addCitiesToArrayNoEnd("Nineveh",43.157265,36.364925,-1800);
			addCitiesToArrayNoEnd("Babylon",44.420883,32.536504,-3000);
			addCitiesToArrayNoEnd("Damascus",36.2939,33.5158,-1800);
			addCitiesToArrayNoEnd("Susa",48.25093,32.19059,-4200);
			addCitiesToArrayNoEnd("Persepolis",52.9,29.9333,-1250);

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
			macedonia.location = new Point(200,31);
			macedonia.timeStart = -300;
			macedonia.timeEnd = 129;
			var begin:Path = new Path();
			begin.data = "M89.697,3.657c-5-1.333-42.668-6.667-49.334-1.333S9.03,16.657,9.03,16.657s-3.667,4.667-3,5.667s1.334,1.667,0.667,3" + 
					"s-3,8-2.667,9.333s-3.333,7-4,8.667c-0.667,1.666,9.666,20.666,28.333,20C47.03,62.657,61.364,52.99,76.697,41.657" + 
					"c15.333-11.333,26-22.667,34.333-23.667s-4-2.667-4-2.667L89.697,3.657z";
			macedonia.addCheckpoint(-340,begin);
			var end:Path = new Path();
			end.data = "M210.644,89.983c-2.666-15.667-44.667-39-49-20.667c-3.812,16.126-6.593,10.591-10.382,8.343" + 
					"c0.583-0.158,1.155-0.275,1.716-0.343c8.333-1-4-2.667-4-2.667l-17.333-11.667c-0.492-0.131-1.31-0.302-2.373-0.497" + 
					"c2.628-3.674,8.852-10.833,7.706-12.837c-1.334-2.333-26-31.333-29.667-37.667s-39.666-20-42.333-5.667s-6.667,17-6.667,17" + 
					"c2.667,1.333,3.334,0.667,8.667,3s6.332,7.333,7.666,7.333s13,4,12.667,7.667s-3.667,9-8,9.333s-17.666-2.667-23.333-3.667" + 
					"s-14-9-23.667-6.667S12.312,47.983,7.978,47.65S-5.356,62.317,4.311,63.983s7.667,4,13.667,7.667s15.999,7.667,18.666,3.667" + 
					"s13.334-1.333,14.334,0.667c0,0-3.667,4.667-3,5.667s1.334,1.667,0.667,3c-0.667,1.333-3,8-2.667,9.333s-3.333,7-4,8.667" + 
					"c-0.15,0.375,0.264,1.637,1.201,3.351c-4.676,2.873-7.021,4.982-10.201,4.982c-4,0-4,15.666,7,14.333s0.666,4.334,6.666,11.334" + 
					"s57.668,36.333,71.334,15c13.666-21.334,13.333-19.001,11.333-25.334s-3.999-9.666,5.667-10.333s8.999,7.667,12.666,10" + 
					"S213.31,105.65,210.644,89.983z";
			macedonia.addCheckpoint(100,end);
			var stroke:SolidStroke = new SolidStroke();
			stroke.color = 0xffffff;
			stroke.alpha = 0.5;
			stroke.weight = 3;
			macedonia.stroke = stroke;
			_borders[0] = macedonia;
		}
		
		private function addCitiesToArray(name:String, longitude:Number, latitude:Number, start:Number, end:Number):void {
			var city:City = new City(name);
			city.location = new Point(180+longitude,90-latitude);
			city.timeStart = start;
			city.timeEnd = end;
			_cities[_cities.length] = city;
		}
		
		private function addCitiesToArrayNoEnd(name:String, longitude:Number, latitude:Number, start:Number):void {
			addCitiesToArray(name, longitude, latitude, start, 2008);			
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
					city.updateDisplay(time,timeZoom);
				
					viewLoc = contentCoordstoViewCoords(geoCoordsToPixels(city.location));
					city.x = viewLoc.x;
					city.y = viewLoc.y;
					
					if((city.x+city.width) < 0 || city.x >= viewRect.width || (city.y+city.height) < 0 || city.y >= viewRect.height) {
						if(this.contains(city)) this.removeChild(city);
					} else if(!this.contains(city)) this.addChild(city);
				}
			}
			
			if(showBorderPolitical) {
				
				for each(var border:Border in _borders) {
					border.updateDisplay(time,timeZoom);
				
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