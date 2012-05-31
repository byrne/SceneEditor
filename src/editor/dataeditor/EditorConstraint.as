package editor.dataeditor
{
	public class EditorConstraint
	{
		private var _property:String;
		private var _value:Object;
		
		public function EditorConstraint(prop:String, val:Object) {
			_property = prop;
			_value = val;
		}
		
		public function apply(target:Object):void {
			if(target.hasOwnProperty(_property))
				target[_property] = _value;
		}
	}
}