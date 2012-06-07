package editor.datatype.type
{
	public class IntType extends NativeType
	{
		public function IntType(name:String = null) {
			super(name);
		}
		
		override public function construct():* {
			return 0;
		}
		
		override public function check(value:*):Boolean {
			return value is int;
		}
		
		override public function convert(v:*):DataConvertResult {
			var result:DataConvertResult = new DataConvertResult(null, true);;
			var tmp:int;
			
			if(v is Number) {
				tmp = v; 	// this way we could convert Number.NaN into int(0)
				result.value = tmp;
			}
			else {
				tmp = parseInt(String(v));
				result.value = tmp;
			}
			
			return result;
		}
	}
}