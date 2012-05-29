package core.data
{
	public class PrimitiveDataType implements IDataType
	{
		public static const TYPE_INT:String = 'int';
		public static const TYPE_FLOAT:String = 'float';
		public static const TYPE_ARRAY:String = 'array';
		public static const TYPE_STRING:String = 'String';
		public static const TYPE_BOOLEAN:String = 'boolean';
		public static const TYPE_UNDEFINED:String = 'undefined';
		
		public var name:String;
		
		public function PrimitiveDataType(name:String = null) {
			this.name = name;
		}
		
		public function construct():Object {
			var value:Object;
			switch(name) {
				case TYPE_INT: value = 0; break;
				case TYPE_FLOAT: value = 0.0; break;
				case TYPE_STRING: value = ""; break;
				case TYPE_BOOLEAN: value = false; break;
				case TYPE_ARRAY: value = []; break;
				case TYPE_UNDEFINED: value = null; break;
			}
			return value;
		}
	}
}