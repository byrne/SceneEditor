package editor.utils.swf
{	
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	
	import mx.utils.ArrayUtil;

	public class SWF
	{
		private var _stream:SWFStream;
		
		private var _version:int;
		private var _swf_length:int;
		private var _frame_rate:int;
		private var _frames_count:int;
		
		private var _width:int;
		
		private var _height:int; 
		private var _tag_start_pos:int;
		private var _symbolClassNames:Array = [];
	
		public function SWF(data:ByteArray) : void
		{
			_stream = new SWFStream(data);
			_init();
		}
		
		public function process():void {
			startReadTags();				
			while(true) {
				var tag:SWFTag = read_tag() ;
				if (tag == null) {
					break;
				}
				if (tag is TagSymbolClass) {
					var symbols:Array =  (tag as TagSymbolClass).symbols;
					_symbolClassNames = _symbolClassNames.concat(symbols);
				}
			}
		}
		
		public function get symbolClassNames():Array {
			return _symbolClassNames;
		}
		
		private function _init():void {
			var b1:int = _stream.read_UI8();
			var b2:int = _stream.read_UI8();
			var b3:int = _stream.read_UI8();			
			
			_version = _stream.read_UI8();
			_swf_length = _stream.read_UI32();		
			
			if (b1 == 67) {
				//compressed
				this.uncompress();
			}
			_stream.pos = 8;
			
			//RECT
			var nbits:int = _stream.read_bits(5);
			//Debug.log("nbits=" + nbits);
			var xmin:int = _stream.read_bits(nbits);
			var xmax:int = _stream.read_bits(nbits);
			var ymin:int = _stream.read_bits(nbits);
			var ymax:int = _stream.read_bits(nbits);
			
			_width = (xmax - xmin) / 20;
			_height = (ymax - ymin) / 20;
			
			_frame_rate = _stream.read_UI16() / 256;
			_frames_count = _stream.read_UI16();
			
			_tag_start_pos = _stream.pos;
		}
		
		public function read_UI8() : int {
			return _stream.read_UI8();
		}
		
		public function read_UI16() : int {
			return _stream.read_UI16();
		}
		
		public function read_UI32() : int {
			return _stream.read_UI32();
		}
		
		public function uncompress() :Boolean {
			_stream.uncompress();
			
			return true;
		}
		
		public function startReadTags():void {
			_stream.pos = _tag_start_pos;
		}
		
		
		public function set pos(p:int): void {
			_stream.pos = p;
		}
		
		public function get pos(): int {
			return _stream.pos;
		}
		public function get length(): int {
			return _stream.length;
		}
		
		public function read_bits(nbits:int) :int {
			return _stream.read_bits(nbits);
		}
		
		public function read_tag( ): SWFTag {
			
			if (_stream.pos >= _stream.length) {
				return null;
			}			
			
			//Debug.log("pos:" + _stream.pos);		
			var tag_header:int = _stream.read_UI16();
			var type : int = tag_header >> 6;
			
			var tag_len :int = tag_header & 0x003f;
			if (tag_len  == 0x3f) {
				tag_len = _stream.read_UI32();
			}
			
			var destStream:SWFStream = _stream.read_bytes(tag_len); 
			if (destStream == null) {
				return null;
			}		
			
			var tag:SWFTag;
			if (type == TagSymbolClass.ID) {
				tag = new TagSymbolClass();
				tag.data = destStream;
			} else {
				tag = new TagUnknown();
				tag.id = type;
				tag.data = destStream;
			}
			
			return tag;
		}
	}
}