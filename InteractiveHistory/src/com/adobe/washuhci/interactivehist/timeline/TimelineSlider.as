﻿package com.adobe.washuhci.interactivehist.timeline {		import flash.display.Sprite;	import flash.events.Event;	import flash.events.MouseEvent;	import flash.geom.Point;		import mx.core.UIComponent;		[Event(name="change", type="flash.events.Event")]	public class TimelineSlider extends UIComponent {				private var _isDragging:Boolean = false;				private var _time:Number;		public var timeMin:Number = -2000;		public var timeMax:Number = 1000;		public var zoomLevel:Number = ZOOM_MIN_LEVEL;		[Bindable]		public var canZoomIn:Boolean = (zoomLevel < ZOOM_MAX_LEVEL);		[Bindable]		public var canZoomOut:Boolean = (zoomLevel > ZOOM_MIN_LEVEL);				// slider graphical elements				[Embed("icons/timelineIcons.swf", symbol="SliderHeadIcon")]		private var SliderHead:Class;		private var _sliderHead:Sprite;		[Embed("icons/timelineIcons.swf", symbol="SliderBarShape")]		private var SliderBar:Class;		private var _sliderBar:Sprite;		private var _graphicsClippingPane:Sprite;				private var _clipMin:Number;		private var _clipMax:Number;		private var _highlightTimeMin:Number;		private var _highlightTimeMax:Number;				private var _labelYears:Array;		private var _markers:Array;				//private const ZOOM_FACTOR:Number = 100;		public const ZOOM_MIN_LEVEL:Number = 0;		public const ZOOM_MAX_LEVEL:Number = 4;		private const TICK_INTERVALS:Array = new Array(1000, 500, 100, 50, 10);		private const TIME_RANGES:Array = new Array(10000, 3000, 1000, 500, 100);		private const MAX_YEAR:Number = 2008;		private const MIN_YEAR:Number = -4000;				public function TimelineSlider() {			super();			init();		}				public function init():void {			// create graphics objects			_sliderBar = new SliderBar() as Sprite;			_sliderBar.y = 100;			this.addChild(_sliderBar);			_sliderHead = new SliderHead() as Sprite;			_sliderHead.y = 70;			_sliderHead.buttonMode = true;			_sliderHead.useHandCursor = true;			this.addChild(_sliderHead);						// set up clipping pane			_graphicsClippingPane = new Sprite();			this.addChild(_graphicsClippingPane);			this.mask = _graphicsClippingPane;						// initialize clip bounds			_clipMin = 1.5*_sliderHead.width;			_clipMax = this.width;			_sliderBar.x = _clipMin;									// setup intial state			_time = 0;			moveSliderTo(_time);			_highlightTimeMin = 0;			_highlightTimeMax = 0;						// set up mouse events			_sliderHead.addEventListener(MouseEvent.MOUSE_DOWN, initDrag);						// extend hitArea of head?						// place labels			recomputeYearLabels();						// set up markers			_markers = new Array();					}				public function highlightRegion(timeStart:Number, timeEnd:Number):void {			_highlightTimeMin = timeStart;			_highlightTimeMax = timeEnd;			redrawHighlight();		}				public function addGenericMarker(text:String, timeStart:Number, timeEnd:Number = Number.MIN_VALUE):void {			var marker:TimelineMarker;			marker = new GenericMarker();			marker.timeStart = timeStart;			if(timeEnd != Number.MIN_VALUE) marker.timeEnd = timeEnd;			else marker.timeEnd = timeStart;			marker.text = text;			marker.mouseChildren = false;			marker.x = timeToPosition(marker.timeStart);			marker.y = 5;			_markers[_markers.length] = marker;			this.addChild(marker);			this.swapChildren(marker, _sliderHead);		}				public function addSpecificMarker(text:String, timeStart:Number, timeEnd:Number = Number.MIN_VALUE):void {			var marker:TimelineMarker;			marker = new SpecificMarker();			marker.timeStart = timeStart;			if(timeEnd != Number.MIN_VALUE) marker.timeEnd = timeEnd;			else marker.timeEnd = timeStart;			marker.text = text;			marker.mouseChildren = false;			marker.x = timeToPosition(marker.timeStart);			marker.y = 35;			if(marker.timeStart != marker.timeEnd) {				marker.width = timeToPosition(marker.timeEnd) - marker.x;			}			_markers[_markers.length] = marker;			this.addChild(marker);			this.swapChildren(marker, _sliderHead); // keep slider on top		}				public function zoomIn():void {			if(canZoomIn) {				zoomLevel ++;				redrawTimeline();				if(zoomLevel == ZOOM_MAX_LEVEL) canZoomIn = false;				canZoomOut = true;			}		}				public function zoomOut():void {			if(canZoomOut) {				zoomLevel --;				redrawTimeline();				if(zoomLevel == ZOOM_MIN_LEVEL) canZoomOut = false;				canZoomIn = true;			}		}				public function redrawTimeline():void {			_graphicsClippingPane.width = this.width;			_graphicsClippingPane.height = this.height;			_graphicsClippingPane.graphics.beginFill(0x000000,1.0);			_graphicsClippingPane.graphics.drawRect(0,0,this.width,this.height);			_graphicsClippingPane.graphics.endFill();						recomputeYearLabels(false);			redrawMarkers();			redrawHighlight();			moveSliderTo(_time);		}				// private functions				private function redrawHighlight():void {			if(_highlightTimeMin != _highlightTimeMax) {				this.graphics.clear();				this.graphics.beginFill(0xaaaa00,0.5);				var __highlightX:Number = timeToPosition(_highlightTimeMin);				var __highlightWidth:Number = timeToPosition(_highlightTimeMax) - __highlightX;				this.graphics.drawRect(__highlightX, _sliderHead.y, __highlightWidth, _sliderHead.height);				this.graphics.endFill();			}		}				private function redrawMarkers():void {			for each(var marker:TimelineMarker in _markers) {				marker.x = timeToPosition(marker.timeStart);				if(marker.timeEnd != marker.timeStart) {					marker.width = timeToPosition(marker.timeEnd) - marker.x;				}			}		}				private function recomputeYearLabels(recenter:Boolean = false):void {			if(_labelYears != null && _labelYears.length > 0) {				for each(var label:TimeLabel in _labelYears) {					if(this.contains(label)) {						this.removeChild(label);					}				}			}						// figure out new labels			var timeRange:Number = TIME_RANGES[zoomLevel];			var t:Number = 0.5;			if(!recenter) t = (_time-timeMin)/(timeMax-timeMin);			timeMin = Math.max(Math.round(_time - (t*timeRange)), MIN_YEAR);			timeMax = Math.min(timeMin+timeRange, MAX_YEAR);						// figure out new labels			_labelYears = new Array();			var tmpLabel:TimeLabel;			var labelYear:Number = timeMin - (timeMin%TICK_INTERVALS[zoomLevel]);			while(labelYear <= timeMax) {				tmpLabel = new TimeLabel();				tmpLabel.time = labelYear;				tmpLabel.x = timeToPosition(labelYear);				tmpLabel.y = 20;								_labelYears[_labelYears.length] = tmpLabel;				this.addChild(tmpLabel);				this.swapChildren(tmpLabel, _sliderHead); // keep slider head on top								labelYear = labelYear + TICK_INTERVALS[zoomLevel];			}		}				private function moveSliderTo(time:Number):void {			_sliderHead.x = timeToPosition(_time) + 2 - (_sliderHead.width/2);		}				private function timeToPosition(value:Number):Number {			var t:Number = (value - timeMin)/(timeMax - timeMin);			return Math.round(_clipMin + (t*(_clipMax-_clipMin)));		}				private function positionToTime(value:Number):Number {			var t:Number = (value - _clipMin)/(_clipMax - _clipMin);			return Math.round(timeMin + (t*(timeMax-timeMin)));		}				// mouse handlers				private function initDrag(me:MouseEvent):void {			_isDragging = true;			this.mouseChildren = false;			this.stage.addEventListener(MouseEvent.MOUSE_MOVE, dragTo);			this.stage.addEventListener(MouseEvent.MOUSE_UP, finishDrag);		}				private function dragTo(me:MouseEvent):void {			if(_isDragging) {				var mPoint:Point = new Point(me.localX, me.localY);				if(me.target != this) { // convert mouse coords					mPoint = this.globalToLocal(me.target.localToGlobal(mPoint));				}				_sliderHead.x = Math.max(Math.min(mPoint.x - (_sliderHead.width/2), _clipMax - (_sliderHead.width/2)), _clipMin - (_sliderHead.width/2));				time = positionToTime(_sliderHead.x + (_sliderHead.width/2) - 2);			}		}				private function finishDrag(me:MouseEvent):void {			_isDragging = false;			this.mouseChildren = true;			this.stage.removeEventListener(MouseEvent.MOUSE_MOVE, dragTo);			this.stage.removeEventListener(MouseEvent.MOUSE_UP, finishDrag);		}				// getters/setters				[Bindable]		public function get time():Number {			return _time;		}		public function set time(value:Number):void {			_time = value;			moveSliderTo(_time);			dispatchEvent(new Event("change"));		}				public function get sliderWidth():Number {			return this.width;		}		public function set sliderWidth(value:Number):void {			this.width = value;			_clipMax = value - (1.5*_sliderHead.width);			_sliderBar.width = _clipMax-_clipMin;						redrawTimeline();		}	}	}