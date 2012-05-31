package editor.datatype.data
{
	public class BasicDataType implements IDataType
	{
		public static const TYPE_INT:String = 'int';
		public static const TYPE_FLOAT:String = 'number';
		public static const TYPE_ARRAY:String = 'array';
		public static const TYPE_STRING:String = 'string';
		public static const TYPE_BOOLEAN:String = 'boolean';
		public static const TYPE_UNDEFINED:String = 'undefined';
		
		private var _name:String;
		public function get name():String { return _name; }
		public function set name(v:String):void { _name = v; }
		
		public function get isPrimitive():Boolean { return true; }
		
		private var _def:Object;
		public function get definition():Object { return _def; }
		public function set definition(v:Object):void { _def = v; }
		
		public function BasicDataType(name:String = null) {
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
		
		public static function get PRIMITIVES():Array {
			return [TYPE_INT, TYPE_FLOAT, TYPE_STRING, TYPE_BOOLEAN, TYPE_ARRAY, TYPE_UNDEFINED];
		}
	}
}