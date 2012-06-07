package editor.datatype.type
{
	public class NumberType extends NativeType
	{
		public function NumberType(name:String=null) {
			super(name);
		}
		
		override public function construct():* {
			return 0;
		}
		
		override public function check(value:*):Boolean {
			return value is Number;
		}
		
		override public function convert(v:*):DataConvertResult {
			var result:DataConvertResult = new DataConvertResult(null, true);
			if(v == null) {
				result.value = Number.NaN;
			}
			else if(v is Number) {
				result.value = v;
			}
			else if(v is String) {
				result.value = parseFloat(v);
			}
			return result;
		}
	}
}