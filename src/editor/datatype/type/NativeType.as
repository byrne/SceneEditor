package editor.datatype.type
{
	/**
	 * NativeType represents DataTypes that generate native ActionScript data values, i.e. one of: 
	 * <code>int</code>, <code>number</code>, <code>string</code>, <code>boolean</code>, 
	 * and <code>array</code>.
	 * 
	 * @author Rong.Cheng
	 * 
	 */
	public class NativeType implements IDataType
	{
		private var _name:String;
		public function get name():String { return _name; }
		public function set name(v:String):void { _name = v; }
		
		private var _definition:Object;
		public function get definition():Object { return _definition; }
		public function set definition(v:Object):void { _definition = v; }
		
		public function NativeType(name:String = null) {
			_name = name;
		}

		public function construct():* {
			return null;
		}
		
		public function check(value:*):Boolean {
			return false;
		}
		
		public function convert(v:*):DataConvertResult {
			return new DataConvertResult;
		}
	}
}