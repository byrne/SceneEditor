package editor.dataeditor.elements
{
	import editor.dataeditor.IEditorElement;
	import editor.dataeditor.util.VariableResolver;
	
	import mx.collections.ArrayList;
	
	import spark.components.ComboBox;
	
	public class TextSelector extends ComboBox implements IEditorElement
	{
		private var _source:String;
		
		public function TextSelector() {
			super();
		}
		
		public function get bindingProperty():Object {
			return "selectedItem";
		}
		
		/**
		 * Set a source for the list candidates.
		 *  
		 * @param v of the form
		 * 
		 */
		public function set source(v:String):void {
			if(v == _source)
				return;
			_source = v;
			var candidates:* = VariableResolver.getValue(source);
			if(candidates is Array)
				dataProvider = new ArrayList(candidates);
			else
				dataProvider = new ArrayList([candidates]);
		}
		
		public function get source():String {
			return _source;
		}
		
		public function set defaultValue(v:Object):void {
			if(v is int)
				this[bindingProperty] = v;
		}
		
		override public function set selectedItem(value:*):void {
			if(value == null)
				selectedIndex = 0;
			else
				super.selectedIndex = value as int;
		}
	}
}