﻿package com.adobe.washuhci.interactivehist.timeline {	
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;		public class TimelineMarker extends Sprite {				private var _timeStart:Number;		private var _timeEnd:Number;		private var _text:String;				protected var _textField:TextField;		protected var _textFormat:TextFormat;				public function TimelineMarker() {			super();			_textField = new TextField();						_textFormat = new TextFormat();			_textFormat.italic = true;			_textFormat.color = 0x777777;			_textField.defaultTextFormat = _textFormat;						init();		}				private function init():void {			// add text format here			//_textField.autoSize = TextFieldAutoSize.LEFT;			this.addChild(_textField);		}				public function redraw():void {			// do nothing		}				// getters/setters				public function get timeStart():Number {			return _timeStart;		}		public function set timeStart(value:Number):void {			_timeStart = value;		}				public function get timeEnd():Number {			return _timeEnd;		}		public function set timeEnd(value:Number):void {			_timeEnd = value;		}				public function get text():String {			return _text;		}		public function set text(value:String):void {			_text = value;			_textField.text = _text;			_textField.width = _textField.textWidth*value.length;		}			}	}