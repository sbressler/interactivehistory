package com.adobe.washuhci.interactivehist
{
	import com.adobe.washuhci.interactivehist.display.*;
	import com.adobe.wheelerstreet.fig.panzoom.ImageViewer;
	
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
		 public var timeZoom:Number = 50.0;
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
				border.blendMode = BlendMode.INVERT;
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
			var athens:City = new City("Athens");
			athens.location = new Point(203.71,52);
			athens.timeStart = -1400;
			athens.timeEnd = 2008;
			_cities[0] = athens;
			
			var rome:City = new City("Rome");
			rome.location = new Point(192.48,48.11);
			rome.timeStart = -753;
			rome.timeEnd = 2008;
			_cities[1] = rome;
			
			var carthage:City = new City("Carthage");
			carthage.location = new Point(190.22,53.15);
			carthage.timeStart = -1215;
			carthage.timeEnd = 2008;
			_cities[2] = carthage;
			
			var border1:Border = new Border("Italy");
			border1.location = new Point(192,55);
			border1.timeStart = -500;
			border1.timeEnd = 200;
			_borders[0] = border1;
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