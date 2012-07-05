package editor.dataeditor.elements
{
	import editor.dataeditor.IEditorElement;
	
	import spark.components.TextInput;
	
	public class SingleLineText extends TextInput implements IEditorElement
	{
		public function SingleLineText() {
			super();
		}
		
		public function get bindingProperty():Object {
			return "text";
		}
		
		public function set defaultValue(v:Object):void {
			text = String(v);
		}
	}
}