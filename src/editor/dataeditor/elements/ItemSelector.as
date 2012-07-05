package editor.dataeditor.elements
{
	import editor.dataeditor.IEditorElement;
	
	import mx.controls.ComboBox;
	
	public class ItemSelector extends ComboBox implements IEditorElement
	{
		public function ItemSelector() {
			super();
		}
		
		public function get bindingProperty():Object {
			return "selectedItem";
		}
		
		public function set defaultValue(v:Object):void {
			if(v is int)
				this[bindingProperty] = v;
		}
		
		override public function set selectedItem(value:Object):void {
			if(value == null)
				selectedIndex = 0;
			else
				super.selectedIndex = value as int;
		}
	}
}