package editor.datatype.impl
{
	import editor.datatype.data.BasicDataType;
	import editor.datatype.data.DataContext;
	import editor.datatype.impl.parser.xml.XMLDataTypeParser;

	public class DataFactory
	{
		private static var _instance:DataFactory;
		public static function get INSTANCE():DataFactory {
			if(_instance == null)
				_instance = new DataFactory;
			return _instance;
		}
		
		public var allTypes:DataContext = new DataContext;
		
		public function DataFactory() {
			if(_instance)
				throw new Error("Singleton Error");
			setPrimitives();
		}
		
		private function setPrimitives():void {
			for each(var type:String in BasicDataType.PRIMITIVES) {
				allTypes.setType(type, new BasicDataType(type));
			}
		}
		
		public function initTable(src:XML):void {
			XMLDataTypeParser.constructTable(src, allTypes);
		}
	}
}