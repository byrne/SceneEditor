package editor.utils.keyboard
{
	import flash.ui.Keyboard;

	public class KeyShortcut
	{
		public var keyCode:uint;
		
		public var handler:Function;
		
		public var altKey:Boolean = false;
		public var ctrlKey:Boolean = false;
		public var shiftKey:Boolean = false;
		
		public var reactMode:String = KeyReactMode.KEY_DOWN;
		
		public var params:*;
		
		public function KeyShortcut(data:Object)
		{
			for(var key:String in data) {
				if(this.hasOwnProperty(key))
					this[key] = data[key];
			}
		}
		
		public function get functionalKeys():Array {
			var ret:Array = [];
			if(altKey) ret.push(Keyboard.ALTERNATE);
			if(ctrlKey) ret.push(Keyboard.CONTROL);
			if(shiftKey) ret.push(Keyboard.SHIFT);
			return ret;
		}
	}
}