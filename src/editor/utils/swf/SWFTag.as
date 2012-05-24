package editor.utils.swf
{
	public class SWFTag
	{
		protected var _stream:SWFStream;
		protected var _id:int;
		protected var _unknownType:Boolean = true;
		
		public function get length():int {
			return _stream.length;
		}
		
		public function get id():int
		{
			return _id;
		}
		
		public function set data(byteStream:SWFStream):void {
			_stream = byteStream;
			_stream.pos = 0;
			
		}
		
		public function set id(ID:int) :void {
			_id = ID;
		}
		
	}
}