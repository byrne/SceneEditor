package editor.dataeditor.impl
{
	public class ElementProperty
	{
		public function get property():String {return _property;}
		private var _property:String;
		private var _value:Object;
		
		public function ElementProperty(prop:String, val:Object) {
			_property = prop;
			_value = val;
		}
		
		public function apply(target:Object):void {
			if(target.hasOwnProperty(_property))
				target[_property] = _value;
		}
	}
}