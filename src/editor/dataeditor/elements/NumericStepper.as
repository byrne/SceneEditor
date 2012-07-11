package editor.dataeditor.elements
{
	import editor.dataeditor.IEditorElement;
	
	import spark.components.NumericStepper;
	
	public class NumericStepper extends spark.components.NumericStepper implements IEditorElement
	{
		public function NumericStepper() {
			super();
		}
		
		public function get bindingProperty():Object {
			return "value";
		}
		
		public function set defaultValue(v:Object):void {
			this[bindingProperty] = (v is Number) ? v : 0;
		}
	}
}