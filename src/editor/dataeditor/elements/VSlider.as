package editor.dataeditor.elements
{
	import editor.dataeditor.IEditorElement;
	
	import spark.components.VSlider;
	
	public class VSlider extends spark.components.VSlider implements IEditorElement
	{
		public function VSlider() {
			super();
		}
		
		public function get bindingProperty():Object {
			return "value";
		}
		
		public function set defaultValue(v:Object):void {
			if(v is Number)
				this[bindingProperty] = v;
		}
	}
}