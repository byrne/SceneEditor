package editor.dataeditor.elements
{
	import editor.dataeditor.IEditorElement;
	
	import spark.components.CheckBox;
	
	public class CheckBox extends spark.components.CheckBox implements IEditorElement
	{
		public function CheckBox() {
			super();
		}
		
		public function get bindingProperty():Object
		{
			return 'selected';
		}
		
		public function set defaultValue(v:Object):void {
			selected = v ? true : false;
		}
	}
}