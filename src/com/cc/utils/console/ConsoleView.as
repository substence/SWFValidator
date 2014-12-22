package com.cc.utils.console
{
	import com.cc.display.Fonts;
	import com.cc.display.ScrollBox;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.TextEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	import flash.utils.Timer;

	public class ConsoleView extends Sprite
	{
		private static var OUTPUT_W:Number =	700;
		private static var OUTPUT_H:Number =	400;
		
		private static var INPUT_W:Number =		700;
		private static var INPUT_H:Number =		12;
		
		private static var SCROLLER_W:Number =	6;
		
		private static var PAD_W:Number =		4;
		private static var PAD_H:Number =		4;
		
		
		private var _OutputLayer:Sprite;
		private var _OutputLayerMask:Sprite;
		
		private var _Scrollbox:ScrollBox;
		
		private var _tfOutput:TextField;
		private var _tfInput:TextField;
		
		private var _isOutputThrottled:Boolean = false; // It's expensive to update the scrollbox; if we're getting logspammed, this will allow the console to remain responsive		
		private var _minThrottleTime:int = 250; // Minimum output throttle delay (ms)
		private var _maxThrottleTime:int = 1000; // Maximum output hrottle delay (ms)
		private var _minThrottleTimer:Timer = new Timer(_minThrottleTime, 1);
		private var _maxThrottleTimer:Timer = new Timer(_maxThrottleTime, 1);
		private var _isOutputUpdatePending:Boolean = false;
		
		public function ConsoleView()
		{
			super();
			
			CONFIG::debug
			{
				InitView();
			} //CONFIG::debug
		}
		
		public function Cleanup() : void
		{
			CONFIG::debug
			{
				_Scrollbox.CleanUp();
				
				_tfInput.removeEventListener(KeyboardEvent.KEY_UP, OnKeyDown);
				_tfInput.removeEventListener(Event.CHANGE, OnInputChange)
					
				_minThrottleTimer.removeEventListener(TimerEvent.TIMER, StopThrottling);
				_maxThrottleTimer.removeEventListener(TimerEvent.TIMER, StopThrottling);
					
			} //CONFIG::debug
		}
		
		public function drawBackground(alpha:Number = 1):void
		{	
			graphics.clear();
			
			var outputW:Number = PAD_W + OUTPUT_W + PAD_W + SCROLLER_W;
			var outputH:Number = OUTPUT_H + PAD_H;
			var outputX:Number = 0;
			var outputY:Number = 0;
			
			var inputW:Number = PAD_W + OUTPUT_W + PAD_W + SCROLLER_W;
			var inputH:Number = PAD_H + INPUT_H + PAD_H;
			var inputX:Number = 0;
			var inputY:Number = outputH;
			
			// Draw the frames
			graphics.lineStyle(1,0xFFFFFF, 1.0);
			graphics.beginFill(0x000000, alpha);
			graphics.drawRect(0, 0, outputW, outputH);				// Draw the Output frame
			graphics.drawRect(inputX, inputY, inputW, inputH);		// Draw the Input frame
			graphics.endFill();
		}
		
		private function InitView() : void
		{
			CONFIG::debug
			{
				/*this.tabEnabled = false;
				this.tabChildren = true;*/
				
				drawBackground();				
			
				// Add the Output layer
				_OutputLayer = new Sprite();
				
				
				// Add TextField: Output
				var format:TextFormat = new TextFormat();
				format.size = 10;
				format.font = Fonts.VERDANA;
				format.color = 0xFFFFFF;
				_tfOutput = new TextField();
				_tfOutput.defaultTextFormat = format;
				_tfOutput.wordWrap = true;			
				_tfOutput.embedFonts = false;
				_tfOutput.multiline = true;
				_tfOutput.autoSize = TextFieldAutoSize.LEFT;
				_tfOutput.width = OUTPUT_W;
				_tfOutput.setTextFormat(format);
				_tfOutput.tabEnabled = true;
				_OutputLayer.addChild(_tfOutput);
				
				
				// Add the Scrollbox
				_Scrollbox = new ScrollBox(_OutputLayer, OUTPUT_W, OUTPUT_H + PAD_H - 1, ScrollBox.COLOR_RED);
				addChild(_Scrollbox);
				_Scrollbox.x = PAD_W;
				_Scrollbox.y = 1;
				_Scrollbox.AddBorder(0x000000, 0xFFFFFF);
				_Scrollbox.tabEnabled = false;
				_Scrollbox.tabChildren = false;
				
				
				// Add TextField: Input
				_tfInput = new TextField();
				_tfInput.type = TextFieldType.INPUT;
				_tfInput.defaultTextFormat = format;
				_tfInput.wordWrap = false;			
				_tfInput.embedFonts = false;
				_tfInput.multiline = false;
				_tfInput.width = INPUT_W;
				_tfInput.height = _tfInput.textHeight + 4;
				_tfInput.x = PAD_W;
				_tfInput.y = OUTPUT_H + PAD_H + PAD_H;
				_tfInput.setTextFormat(format);
				_tfInput.text = "";
				_tfInput.tabEnabled = false;
				_tfInput.restrict = "^`";
				_tfInput.addEventListener(KeyboardEvent.KEY_DOWN, OnKeyDown);
				_tfInput.addEventListener(Event.CHANGE, OnInputChange)
				addChild(_tfInput);
				
				
				this.addEventListener(Event.ADDED_TO_STAGE, OnAddedToStage);
				_minThrottleTimer.addEventListener(TimerEvent.TIMER, StopThrottling);
				_maxThrottleTimer.addEventListener(TimerEvent.TIMER, StopThrottling);				
				
				UpdateInput();
				UpdateOutput();
				
			} //CONFIG::debug
		}
		
		private function OnAddedToStage(event:Event = null) : void
		{
			CONFIG::debug
			{
				this.removeEventListener(Event.ADDED_TO_STAGE, OnAddedToStage);
				this.addEventListener(Event.REMOVED_FROM_STAGE, OnRemovedFromStage);
				
				stage.focus = _tfInput;
				
				_Scrollbox.ScrollToBottom(true);
			} //CONFIG::debug
		}
		
		private function OnRemovedFromStage(event:Event = null) : void
		{
			CONFIG::debug
			{
				this.removeEventListener(Event.REMOVED_FROM_STAGE, OnRemovedFromStage);
				
				stage.focus = stage;
			} //CONFIG::debug
		}
		
		private var _triedAutoComplete:Boolean = false;
		
		private function OnKeyDown(event:KeyboardEvent = null) : void
		{
			CONFIG::debug
			{
				if (event == null)
				{
					return;
				}
				
				switch (event.keyCode)
				{
					case Keyboard.ENTER:
					{
						ConsoleController.Instance.CommitInput();
						_Scrollbox.ScrollToBottom(true);
						_triedAutoComplete = false;
					}
					break;
					
					case Keyboard.TAB:
					{
						ConsoleController.Instance.TryAutocomplete(_triedAutoComplete);
						_Scrollbox.ScrollToBottom(true);
						_triedAutoComplete = true;
					}
					break;
					
					case Keyboard.UP:
					{
						ConsoleController.Instance.CycleEntryPrev();
					}
					break;
					
					case Keyboard.DOWN:
					{
						ConsoleController.Instance.CycleEntryNext();
					}
					break;
				}
			} //CONFIG::debug
		}
		
		private function OnInputChange(event:Event = null) : void
		{
			CONFIG::debug
			{
				// Keep the output throttled while we're typing
				_isOutputThrottled = true;
				_minThrottleTimer.reset();
				_minThrottleTimer.start();
				
				ConsoleController.Instance.CurrentInput = _tfInput.text;
			} //CONFIG::debug
		}
		
		public function UpdateOutput() : void
		{
			CONFIG::debug
			{	
				if (_isOutputThrottled)
				{
					// Updating too fast. Try again in a little while.
					_isOutputUpdatePending = true;
					_minThrottleTimer.reset(); // Perpetually update the minThrottleTimer while we are getting new output
					_minThrottleTimer.start();
					_maxThrottleTimer.start(); // If we are throttled by logspam for too long, this timer will still permit the output window to update periodically
					return;
				}
				
				_tfOutput.text = ConsoleController.Instance.OutputText.slice(ConsoleController.Instance.OutputText.length - 50000);
				_Scrollbox.ContentChanged();
				
				_isOutputUpdatePending = false;
				_isOutputThrottled = true;
				_minThrottleTimer.reset(); // Perpetually update the minThrottleTimer while we are getting new output
				_minThrottleTimer.start();
				_maxThrottleTimer.start(); // If we are throttled by logspam for too long, this timer will still permit the output window to update periodically
			} //CONFIG::debug
		}
		
		private function StopThrottling(event:TimerEvent) : void
		{
			_isOutputThrottled = false;
			_maxThrottleTimer.reset();
			
			if (_isOutputUpdatePending)
			{
				UpdateOutput();
			}
		}
		
		public function UpdateInput() : void
		{
			CONFIG::debug
			{
				var input:String = ConsoleController.Instance.CurrentInput;
				
				_tfInput.text = input;
				
				var lastIndex:int = input.length;
				_tfInput.setSelection(lastIndex, lastIndex);
			} //CONFIG::debug
		}
	}
}