package editor.datatype.type
{
	public class BooleanType extends NativeType
	{
		public function BooleanType(name:String=null) {
			super(name);
		}
		
		override public function construct():* {
			return false;
		}
		
		override public function check(value:*):Boolean {
			return value is Boolean;
		}
		
		override public function convert(v:*):DataConvertResult {
			var result:DataConvertResult = new DataConvertResult;
			
			if(v == null || v == undefined) {
				result.value = false;
				result.success = true;
			}
			else if(v is Boolean) {
				result.value = v;
				result.success = true;
			}
			else {
				result.success = false;
				result.value = false;
			}
			
			return result;
		}
	}
}