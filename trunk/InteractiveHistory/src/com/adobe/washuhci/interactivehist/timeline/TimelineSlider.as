﻿package com.adobe.washuhci.interactivehist.timeline {		import flash.display.Sprite;	import flash.events.Event;	import flash.events.MouseEvent;	import flash.geom.Point;		import mx.core.UIComponent;		[Event(name="change", type="flash.events.Event")]	public class TimelineSlider extends UIComponent {				private var _isDragging:Boolean = false;				private var _time:Number;		public var timeMin:Number = -2000;		public var timeMax:Number = 1000;		public var zoomLevel:Number = ZOOM_MIN_LEVEL;				// slider graphical elements				[Embed("icons/timelineIcons.swf", symbol="SliderHeadIcon")]		private var SliderHead:Class;		private var _sliderHead:Sprite;		[Embed("icons/timelineIcons.swf", symbol="SliderBarShape")]		private var SliderBar:Class;		private var _sliderBar:Sprite;				private var _clipMin:Number;		private var _clipMax:Number;				private var _labelYears:Array;		private var _markers:Array;				private const ZOOM_FACTOR:Number = 100;		private const ZOOM_MIN_LEVEL:Number = 0;		private const ZOOM_MAX_LEVEL:Number = 4;		private const TICK_INTERVALS:Array = new Array(1000, 500, 100, 50, 10);		private const TIME_RANGES:Array = new Array(10000, 3000, 1000, 500, 100);		private const MAX_YEAR:Number = 2008;		private const MIN_YEAR:Number = -4000;				public function TimelineSlider() {			super();			init();		}				public function init():void {			// create graphics objects			_sliderBar = new SliderBar() as Sprite;			_sliderBar.y = 100;			this.addChild(_sliderBar);			_sliderHead = new SliderHead() as Sprite;			_sliderHead.y = 70;			_sliderHead.buttonMode = true;			_sliderHead.useHandCursor = true;			this.addChild(_sliderHead);						// initialize clip bounds			_clipMin = 1.5*_sliderHead.width;			_clipMax = this.width;			_sliderBar.x = _clipMin;									// setup intial state			_time = 0;			moveSliderTo(_time);						// set up mouse events			_sliderHead.addEventListener(MouseEvent.MOUSE_DOWN, initDrag);						// extend hitArea of head?						// place labels			recomputeYearLabels();						// set up markers			_markers = new Array();		}				public function addMarker(text:String, time:Number, isSpecific:Boolean = false):void {			var marker:TimelineMarker;			if(!isSpecific) {				marker = new GenericMarker();				marker.time = time;				marker.text = text;				marker.mouseChildren = false;				marker.x = timeToPosition(marker.time);				marker.y = -30;				_markers[_markers.length] = marker;				this.addChild(marker);			} else {							}		}				public function redrawTimeline():void {			recomputeYearLabels(false);			redrawMarkers();			moveSliderTo(_time);		}				private function redrawMarkers():void {			for each(var marker:TimelineMarker in _markers) {				marker.x = timeToPosition(marker.time);			}		}				private function recomputeYearLabels(recenter:Boolean = false):void {			if(_labelYears != null && _labelYears.length > 0) {				for each(var label:TimeLabel in _labelYears) {					if(this.contains(label)) {						this.removeChild(label);					}				}			}						// figure out new labels			// keep slider head at constant location			_labelYears = new Array();			var tmpLabel:TimeLabel;			var timeRange:Number = TIME_RANGES[zoomLevel];			var t:Number = 0.5;			if(!recenter) t = (_time-timeMin)/(timeMax-timeMin);			timeMin = Math.round(_time - (t*timeRange));			//timeMin = timeMin - (timeMin%TICK_INTERVALS[zoomLevel]);			timeMin = Math.max(timeMin, MIN_YEAR);			timeMax = Math.min(timeMin+timeRange, MAX_YEAR);						var labelYear:Number = timeMin - (timeMin%TICK_INTERVALS[zoomLevel]);			while(labelYear <= timeMax) {				tmpLabel = new TimeLabel();				tmpLabel.time = labelYear;				tmpLabel.x = timeToPosition(labelYear);				tmpLabel.y = 20;				_labelYears[_labelYears.length] = tmpLabel;				this.addChild(tmpLabel);				this.swapChildren(tmpLabel, _sliderHead);					labelYear = labelYear + TICK_INTERVALS[zoomLevel];			}		}				private function moveSliderTo(time:Number):void {			_sliderHead.x = timeToPosition(_time) + 2 - (_sliderHead.width/2);		}				private function timeToPosition(value:Number):Number {			var t:Number = (value - timeMin)/(timeMax - timeMin);			return Math.round(_clipMin + (t*(_clipMax-_clipMin)));		}				private function positionToTime(value:Number):Number {			var t:Number = (value - _clipMin)/(_clipMax - _clipMin);			return Math.round(timeMin + (t*(timeMax-timeMin)));		}				public function zoomIn():void {			if(zoomLevel < ZOOM_MAX_LEVEL) {				zoomLevel ++;				recomputeYearLabels();				redrawMarkers();				moveSliderTo(_time);			}		}				public function zoomOut():void {			if(zoomLevel > ZOOM_MIN_LEVEL) {				zoomLevel --;				recomputeYearLabels();				redrawMarkers();				moveSliderTo(_time);			}		}				public function initDrag(me:MouseEvent):void {			_isDragging = true;			this.mouseChildren = false;			this.stage.addEventListener(MouseEvent.MOUSE_MOVE, dragTo);			this.stage.addEventListener(MouseEvent.MOUSE_UP, finishDrag);		}				public function dragTo(me:MouseEvent):void {			if(_isDragging) {				var mPoint:Point = new Point(me.localX, me.localY);				if(me.target != this) { // convert mouse coords					mPoint = this.globalToLocal(me.target.localToGlobal(mPoint));				}				_sliderHead.x = Math.max(Math.min(mPoint.x - (_sliderHead.width/2), _clipMax - (_sliderHead.width/2)), _clipMin - (_sliderHead.width/2));				time = positionToTime(_sliderHead.x + (_sliderHead.width/2) - 2);			}		}				public function finishDrag(me:MouseEvent):void {			_isDragging = false;			this.mouseChildren = true;			this.stage.removeEventListener(MouseEvent.MOUSE_MOVE, dragTo);			this.stage.removeEventListener(MouseEvent.MOUSE_UP, finishDrag);		}				// getters/setters				[Bindable]		public function get time():Number {			return _time;		}		public function set time(value:Number):void {			_time = value;			moveSliderTo(_time);			dispatchEvent(new Event("change"));		}				public function get sliderWidth():Number {			return this.width;		}		public function set sliderWidth(value:Number):void {			this.width = value;			_clipMax = value - (1.5*_sliderHead.width);			_sliderBar.width = _clipMax-_clipMin;						redrawTimeline();		}	}	}