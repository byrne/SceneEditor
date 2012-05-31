package editor.dataeditor
{
	import editor.datatype.impl.DataFactory;
	import editor.datatype.impl.parser.xml.XMLDataParser;
	
	import flash.utils.Dictionary;
	
	import mx.controls.ComboBox;
	
	import spark.components.CheckBox;
	import spark.components.HSlider;
	import spark.components.NumericStepper;
	import spark.components.Spinner;
	import spark.components.TextInput;

	public class DataEditorFactory
	{
		private static const importer:Array = [
			TextInput,
			ComboBox,
			CheckBox,
			HSlider,
			NumericStepper
		];
		
		public static const BINDING_PEOPERTIES:Object = {
			"spark.components::TextInput": "text", 
			"mx.controls::ComboBox": "dataProvider", 
			"spark.components::CheckBox": "selected", 
			"spark.components::HSlider": "value",
			"spark.components::NumericStepper":"value"
		};
		
		private static var _instance:DataEditorFactory;
		public static function get INSTANCE():DataEditorFactory {
			if(_instance == null)
				_instance = new DataEditorFactory;
			return _instance;
		}
		
		private var _editors:Dictionary = new Dictionary;
		
		public function DataEditorFactory() {
			if(_instance)
				throw new Error("Singleton Error");
		}
		
		public function getEditor(typename:String):EditorType {
			return _editors[typename];
		}
		
		public function initTable(src:XML):void {
			for each(var ed:XML in src..editor) {
				var edType:EditorType =  new EditorType(ed.@name, ed.@component);
				edType.constraint = buildConstraint(ed);
				_editors[ed.@name.toString()] = edType;
			}
		}
		
		public function buildConstraint(src:XML):Array {
			var result:Array = [];
			for each(var cons:XML in src..constraint) {
				result.push(new EditorConstraint(cons.@name, XMLDataParser.basicDataFromXML(cons.children()[0], DataFactory.INSTANCE.allTypes)));
			}
			return result;
		}
	}
}