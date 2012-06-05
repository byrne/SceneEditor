package editor.datatype.impl
{
	import editor.datatype.data.BasicDataType;
	import editor.datatype.data.DataContext;
	import editor.datatype.data.IDataType;
	import editor.datatype.impl.parser.xml.XMLDataTypeParser;

	public class DataFactory
	{
		private static var _instance:DataFactory;
		public static function get INSTANCE():DataFactory {
			if(_instance == null)
				_instance = new DataFactory;
			return _instance;
		}
		
		private var _dataContext:DataContext = new DataContext;
		public function get dataContext():DataContext { return _dataContext; }
		
		public function DataFactory() {
			if(_instance)
				throw new Error("Singleton Error");
			setPrimitives();
		}
		
		private function setPrimitives():void {
			for each(var type:String in BasicDataType.PRIMITIVES) {
				_dataContext.setType(type, new BasicDataType(type));
			}
		}
		
		public function initDB(typeDef:XML):void {
			XMLDataTypeParser.importToContext(typeDef, _dataContext);
		}
	}
}