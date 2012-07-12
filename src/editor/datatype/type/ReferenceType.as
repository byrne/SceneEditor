package editor.datatype.type
{
	import editor.datatype.data.ComposedData;
	import editor.datatype.data.Reference;

	public class ReferenceType implements IDataType
	{
		public function set name(v:String):void { _name = v;} 
		public function get name():String { return _name; }
		private var _name:String;
		
		public function get definition():Object { return _definition; }
		public function set definition(v:Object):void { _definition = v; }
		private var _definition:Object;
		
		public function ReferenceType(name:String = null) {
			_name = name;
		}
		
		public function construct():* {
			return new Reference();
		}
		
		public function check(value:*):Boolean {
			return value is Reference;
		}
		
		public function convert(value:*):DataConvertResult {
			var result:DataConvertResult = new DataConvertResult(null, false);

			if(value is ComposedData && Reference.MEM.hasKey(value.$uid))
				result.value = new Reference(value.$uid, [value.$type]);
			
			return result;
		}
	}
}