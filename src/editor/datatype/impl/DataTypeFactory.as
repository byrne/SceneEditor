package editor.datatype.impl
{
	import editor.datatype.impl.parser.xml.XMLTypeParser;
	import editor.datatype.type.ArrayType;
	import editor.datatype.type.BooleanType;
	import editor.datatype.type.DataContext;
	import editor.datatype.type.IntType;
	import editor.datatype.type.NumberType;
	import editor.datatype.type.StringType;

	public class DataTypeFactory
	{
		public static const TYPE_INT:String = 'int';
		public static const TYPE_FLOAT:String = 'number';
		public static const TYPE_ARRAY:String = 'array';
		public static const TYPE_STRING:String = 'string';
		public static const TYPE_BOOLEAN:String = 'boolean';
		public static const TYPE_UNDEFINED:String = 'undefined';
		
		private static var _instance:DataTypeFactory;
		public static function get INSTANCE():DataTypeFactory {
			if(_instance == null)
				_instance = new DataTypeFactory;
			return _instance;
		}
		
		private var _dataContext:DataContext = new DataContext;
		public function get dataContext():DataContext { return _dataContext; }
		
		public function DataTypeFactory() {
			if(_instance)
				throw new Error("Singleton Error");
			setPrimitives();
		}
		
		private function setPrimitives():void {
			dataContext[TYPE_INT] = new IntType(TYPE_INT);
			dataContext[TYPE_FLOAT] = new NumberType(TYPE_FLOAT);
			dataContext[TYPE_BOOLEAN] = new BooleanType(TYPE_BOOLEAN);
			dataContext[TYPE_STRING] = new StringType(TYPE_STRING);
			dataContext[TYPE_ARRAY] = new ArrayType(TYPE_ARRAY);
		}
		
		public function initDB(typeDef:XML):void {
			XMLTypeParser.importToContext(typeDef, _dataContext);
		}
	}
}