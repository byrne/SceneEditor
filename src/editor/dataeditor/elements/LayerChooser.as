package editor.dataeditor.elements
{
	import editor.dataeditor.IEditorElement;
	
	import spark.components.ComboBox;
	
	public class LayerChooser extends ComboBox implements IEditorElement
	{
		public function LayerChooser()
		{
			super();
		}
		
		public function get bindingProperty():Object
		{
			return null;
		}
		
		public function set defaultValue(value:Object):void
		{
		}
	}
}