package editor.datatype.type
{
	public class DataConvertResult
	{
		public var value:*;
		public var success:Boolean;
		
		public function DataConvertResult(val:* = null, suc:Boolean = false) {
			value = val;
			success = suc;
		}
	}
}