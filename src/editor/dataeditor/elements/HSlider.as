package editor.dataeditor.elements
{
	import editor.dataeditor.IEditorElement;
	
	import spark.components.HSlider;
	
	public class HSlider extends spark.components.HSlider implements IEditorElement
	{
		public function HSlider() {
			super();
		}
		
		public function get bindingProperty():Object {
			return "value";
		}
	}
}