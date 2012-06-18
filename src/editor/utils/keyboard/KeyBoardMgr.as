package editor.utils.keyboard
{
	import editor.utils.LogUtil;
	
	import flash.display.InteractiveObject;
	import flash.display.Stage;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;
	
	import spark.components.WindowedApplication;
	
	public class KeyBoardMgr extends EventDispatcher
	{
		private static var _targetStage:Stage;
		private static var _focusTarget:InteractiveObject;
		private static var _mappingPool:Dictionary = new Dictionary();
		
		private static var _keyStatus:Dictionary = new Dictionary();
		private static var _keyDownTime:Dictionary = new Dictionary();
		
		private static var _keys:Array = [
			Keyboard.CONTROL,		Keyboard.SHIFT,			Keyboard.ALTERNATE,		Keyboard.TAB,
			Keyboard.A,				Keyboard.B,				Keyboard.C,				Keyboard.D,
			Keyboard.E,				Keyboard.F,				Keyboard.G,				Keyboard.H,
			Keyboard.I,				Keyboard.J,				Keyboard.K,				Keyboard.L,
			Keyboard.M,				Keyboard.N,				Keyboard.O,				Keyboard.P,
			Keyboard.Q,				Keyboard.R,				Keyboard.S,				Keyboard.T,
			Keyboard.U,				Keyboard.V,				Keyboard.W,				Keyboard.X,
			Keyboard.Y,				Keyboard.Z,				Keyboard.NUMBER_0,		Keyboard.NUMBER_1,
			Keyboard.NUMBER_2,		Keyboard.NUMBER_3,		Keyboard.NUMBER_4,		Keyboard.NUMBER_4,
			Keyboard.NUMBER_5,		Keyboard.NUMBER_6,		Keyboard.NUMBER_7,		Keyboard.NUMBER_8,
			Keyboard.NUMBER_9,		Keyboard.NUMPAD_0,		Keyboard.NUMPAD_1,		Keyboard.NUMPAD_2,
			Keyboard.NUMPAD_3,		Keyboard.NUMPAD_4,		Keyboard.NUMPAD_5,		Keyboard.NUMPAD_6,
			Keyboard.NUMPAD_7,		Keyboard.NUMPAD_8,		Keyboard.NUMPAD_9,		Keyboard.LEFT,
			Keyboard.RIGHT,			Keyboard.UP,			Keyboard.DOWN,			Keyboard.DELETE
		];
		
		public static const KEY_UP:int = 0;
		public static const KEY_DOWN:int = 1;
		
		public function KeyBoardMgr()
		{
			super(null);
		}
		
		public static function initialize(app:WindowedApplication):void {
			_targetStage = app.stage;
			for each(var key:uint in _keys) {
				_keyStatus[key] = KEY_UP;
				_keyDownTime[key] = 0;
			}
			_targetStage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			_targetStage.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
			focusTarget = null;
		}
		
		private static function keyDownHandler(evt:KeyboardEvent):void {
			LogUtil.debug("key down, code:{0}, charCode:{1}, alt:{2}, ctrl:{3}, shift:{4}", evt.keyCode, evt.charCode, evt.altKey, evt.controlKey, evt.shiftKey);
			var key:uint = evt.keyCode;
			_keyStatus[key] = KEY_DOWN;
			_keyDownTime[key] = new Date().time;
			processKeyEvents(key, KeyReactMode.KEY_DOWN);
		}
		
		private static function keyUpHandler(evt:KeyboardEvent):void {
			LogUtil.debug("key up, code:{0}, charCode:{1}, alt:{2}, ctrl:{3}, shift:{4}", evt.keyCode, evt.charCode, evt.altKey, evt.controlKey, evt.shiftKey);
			var key:uint = evt.keyCode;
			_keyStatus[key] = KEY_UP;
			var duration:uint = new Date().time - _keyDownTime[key];
			_keyDownTime[key] = 0;
			if(duration <= 500)
				processKeyEvents(key, KeyReactMode.KEY_CLICK);
		}
		
		private static function processKeyEvents(key:uint, reactMode:String):void {
			for each(var item:RegisterItem in _mappingPool) {
				if(item.target == _focusTarget || item.focusOnly == false) {
					var shortcuts:Array = item.shortcuts;
					for each(var shortcut:KeyShortcut in shortcuts) {
						if(shortcut.reactMode != reactMode)
							continue;
						if(key == shortcut.keyCode && isKeyDown(shortcut.functionalKeys)) {
							var params:* = shortcut.params;
							shortcut.handler.apply(null, params is Array ? params : [params]);
						}
					}
				}
			}
		}
		
		public static function registerKeyShortcuts(shortcuts:Array, target:InteractiveObject=null, focusOnly:Boolean=true):void {
			if(target == null)
				target = _targetStage;
			var item:RegisterItem = _mappingPool[target] as RegisterItem; 
			if(item == null)
				_mappingPool[target] = new RegisterItem(target, shortcuts, focusOnly);
			else {
				item.focusOnly = focusOnly;
				item.shortcuts = item.shortcuts.concat(shortcuts);
			}
		}
		
		public static function clearKeyShortcuts(target:InteractiveObject):void {
			delete _mappingPool[target];
		}
		
		public static function isKeyDown(keys:*):Boolean {
			if(!(keys is Array))
				return _keyStatus[keys] != null && _keyStatus[keys] == KEY_DOWN;
			for each(var key:uint in keys) {
				if(_keyStatus[key] == KEY_UP)
					return false;
			}
			return true;
		}
		
		public static function get focusTarget():InteractiveObject {
			return _focusTarget;
		}
		
		public static function set focusTarget(target:InteractiveObject):void {
			_focusTarget = target;
			if(_focusTarget == null)
				_focusTarget = _targetStage;
		}
	}
}
import flash.display.InteractiveObject;

internal class RegisterItem {
	public var target:InteractiveObject;
	
	public var shortcuts:Array;
	
	public var focusOnly:Boolean;
	
	public function RegisterItem(target:InteractiveObject, shortcuts:Array, focusOnly:Boolean=true):void {
		this.target = target;
		this.shortcuts = shortcuts;
		this.focusOnly = focusOnly;
	}
}