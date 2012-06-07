package editor.datatype.type
{
	public class StringType extends NativeType
	{
		public function StringType(name:String=null) {
			super(name);
		}
		
		override public function construct():* {
			return null;
		}
		
		override public function check(value:*):Boolean {
			return (value is String) || (value == null);
		}
		
		override public function convert(v:*):DataConvertResult {
			var result:DataConvertResult = new DataConvertResult(null, true);
			
			if(v == null) {
				result.value = null;
			}
			else {
				result.value = String(v);
			}
			
			return result;
		}
	}
}