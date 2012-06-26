package editor.dataeditor
{
	import editor.dataeditor.impl.ComponentPool;
	import editor.dataeditor.impl.EditorBase;
	import editor.dataeditor.impl.parser.xml.XMLEditorParser;
	import editor.datatype.type.DataContext;
	
	import flash.utils.Dictionary;

	public class DataEditorFactory
	{
		private static var _instance:DataEditorFactory;
		public static function get INSTANCE():DataEditorFactory {
			if(_instance == null)
				_instance = new DataEditorFactory;
			return _instance;
		}
		
		private var _editors:Dictionary;
		
		public function DataEditorFactory() {
			if(_instance)
				throw new Error("Singleton Error");
			addPredefinedComponents();
		}
		
		private function addPredefinedComponents():void {
			for (var name:String in ComponentPool.POOL) {
				_editors[name] = ComponentPool.POOL[name];
			}
		}
		
		public function initTable(src:Object, ctx:DataContext):void {
			_editors = new Dictionary();
			XMLEditorParser.importFromXML(src as XML, ctx, _editors);
		}
		
		public function getEditor(typename:String):EditorBase {
			return _editors[typename];
		}
	}
}