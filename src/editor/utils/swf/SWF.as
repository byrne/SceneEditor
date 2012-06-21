package editor.utils.swf
{	
	import editor.utils.DictionaryUtil;
	import editor.utils.LogUtil;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.FileReference;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import mx.utils.ArrayUtil;

	public class SWF extends EventDispatcher
	{
		private var _stream:SWFStream;
		
		private var _version:int;
		private var _swf_length:int;
		private var _frame_rate:int;
		private var _frames_count:int;
		
		private var _width:int;
		
		private var _height:int; 
		private var _tag_start_pos:int;
		private var _symbolClassNames:Dictionary = new Dictionary();
		
		private var _loader:Loader;
		private var _rawData:ByteArray;
	
		public function SWF(data:ByteArray) : void
		{
			_rawData = new ByteArray();
			data.readBytes(_rawData);
			_stream = new SWFStream(data);
		}
		
		// loadSwf() must call before process()
		private function loadSwf():void {
			_loader = new Loader();
			var lc : LoaderContext = new LoaderContext();
			lc.allowCodeImport = true;
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadSwfCompleteHandler);
			_loader.loadBytes(_rawData, lc);
		}
		
		private function loadSwfCompleteHandler(evt:Event):void {
			for(var clsName:String in _symbolClassNames) {
				_symbolClassNames[clsName] = _getSwfClass(clsName);
			}
			_rawData = null;
			_loader.unload();
			_loader = null;
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
		
		public function process():void {
			readSwfHead();
			pos = _tag_start_pos;			
			while(true) {
				var tag:SWFTag = read_tag() ;
				if (tag == null) {
					break;
				}
				if (tag is TagSymbolClass) {
					var symbols:Array =  (tag as TagSymbolClass).symbols;
					for each(var clsName:String in symbols) {
						_symbolClassNames[clsName] = null;
					}
				}
			}
			_stream = null;
			loadSwf();
		}
		
		private function _getSwfClass(clsName:String):Class {
			try {
				return _loader.contentLoaderInfo.applicationDomain.getDefinition(clsName)  as  Class;
			} catch (e:Error) {
				trace("class " + clsName + " definition not found");
//				throw new Error("class " + clsName + " definition not found");
			}
			return null;
		}
		
		public function get symbolClassNamesArr():Array {
			return DictionaryUtil.getKeys(_symbolClassNames);
		}
		
		public function get symbolClassNamesDic():Dictionary {
			return _symbolClassNames;
		}
		
		public function getClassByName(clsName:String):Class {
			var cls:Class = _symbolClassNames[clsName] as Class;
			if(cls == null) {
				LogUtil.warn("Class not found symbol class: "+clsName);
			}
			return cls;
		}
		
		public static function buildSymbolInstance(itemClass:Class):DisplayObject {
			var item:DisplayObject;
			try {
				item = new itemClass();
			} catch(e:Error) {
				var bmd:BitmapData = new itemClass(2048, 2048);
				item = new Bitmap();
				(item as Bitmap).bitmapData = bmd;
			}
			return item;
		}
		
		private function readSwfHead():void {
			pos = 0;
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