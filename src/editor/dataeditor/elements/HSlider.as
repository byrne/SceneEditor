package editor.dataeditor.elements
{
	import editor.dataeditor.IEditorElement;
	
	import spark.components.HSlider;
	
	public class HSlider extends spark.components.HSlider implements IEditorElement
	{
		private var _locked:Boolean;
		private var _user_enabled:Boolean;
		public function HSlider() {
			super();
		}
		
		public function get locked():Boolean { return _locked; }
		public function set locked(v:Boolean):void {
			if(_locked == v)
				return;
			else if(v)
				super.enabled = !v;
			else
				super.enabled = _user_enabled;
		}
		
		override public function set enabled(value:Boolean):void {
			if(value == enabled)
				return;
			super.enabled = value;
			_user_enabled = value;
		}
		
		public function get bindingProperty():Object {
			return "value";
		}
		
		public function set defaultValue(v:Object):void {
			this[bindingProperty] = (v is Number) ? v : 0;
		}
		
		public function reset():void {
			value = 0;
		}
	}
}