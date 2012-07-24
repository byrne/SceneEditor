package editor.dataeditor.elements
{
	import editor.dataeditor.IEditorElement;
	
	import spark.components.TextInput;
	
	public class SingleLineText extends TextInput implements IEditorElement
	{
		private var _user_enabled:Boolean;
		private var _locked:Boolean;
		public function SingleLineText() {
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
			return "text";
		}
		
		public function set defaultValue(v:Object):void {
			this[bindingProperty] = (v == null) ? "" : String(v);
		}
		
		public function reset():void {
			text = null;
		}
	}
}