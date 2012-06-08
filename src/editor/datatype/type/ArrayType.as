package editor.datatype.type
{
	import mx.collections.ArrayCollection;
	import mx.collections.ArrayList;

	public class ArrayType extends NativeType
	{
		public function ArrayType(name:String=null) {
			super(name);
		}
		
		override public function construct():* {
			return null;
		}
		
		override public function check(value:*):Boolean {
			return (value is Array) || (value == null);
		}
		
		override public function convert(v:*):DataConvertResult {
			var result:DataConvertResult = new DataConvertResult(null, true);
			
			if(v is ArrayCollection)
				result.value = (v as ArrayCollection).source;
			else if(v is ArrayList)
				result.value = (v as ArrayList).source;
			else
				result.success = false;
				
			return result;
		}
	}
}