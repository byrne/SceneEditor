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
		
		override public function set selectedItem(value:Object):void {
			if(value == null)
				selectedIndex = 0;
		}
	}
}