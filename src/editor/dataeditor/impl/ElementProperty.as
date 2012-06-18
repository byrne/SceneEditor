package editor.dataeditor.impl
{
	public class ElementProperty
	{
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