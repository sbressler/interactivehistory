package com.adobe.washuhci.interactivehist
{
	import com.adobe.wheelerstreet.fig.panzoom.ImageViewer;
	
	import flash.geom.Point;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Label;

	public class InteractiveMap extends ImageViewer
	{
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
		 public var latitudeMax:Number = 0;
		 public var longitudeMin:Number = 0;
		 public var longitudeMax:Number = 0;
		 
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
		 public var timeZoom:Number = 1.0;
		 [Bindable]
		 public var showBorderCultural:Boolean = false;
		 [Bindable]
		 public var showBorderPolitical:Boolean = false;
		 [Bindable]
		 public var showPlacesCities:Boolean = false;
		 [Bindable]
		 public var showPlacesBattles:Boolean = false;

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
		 	return new Point(0,0);
		 }
		
	}
}