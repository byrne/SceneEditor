package editor.mgr
{
	import editor.utils.FileSerializer;
	import editor.utils.LogUtil;
	import editor.utils.swf.SWF;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	public class ResMgr extends EventDispatcher
	{
		public function ResMgr()
		{
			throw new Error("Singleton class can't new instance!");
		}
		
		private static var resCache:Dictionary = new Dictionary();
		
		public static function getSwfSymbolByName(swfFile:String, symbol:String, successHandler:Function, errorHandler:Function=null) {
			var ret:* = fetchFromCache(swfFile, symbol);
			if(ret != null) {
				successHandler.call(null, ret as Class);
				return;
			}
			loadSWFFile(swfFile, function():void {
				ret = fetchFromCache(swfFile, symbol);
				successHandler.call(null, ret as Class);
			});
		}
		
		public static function getSwfSymbols(swfFile:String, successHandler:Function, errorHandler:Function=null) {
			var ret:* = fetchFromCache(swfFile);
			if(ret != null) {
				successHandler.call(null, ret as Array);
				return;
			}
			loadSWFFile(swfFile, function():void {
				ret = fetchFromCache(swfFile);
				successHandler.call(null, ret as Array);
			});
		}
		
		private static function fetchFromCache(swfFile:String, symbol:String=null):* {
			var symbols:Dictionary = resCache[swfFile] as Dictionary;
			if(symbols == null)
				return null;
			return symbol!=null ? symbols[symbol] : symbols;
		}
		
		private static function loadSWFFile(swfFile:String, successHandler:Function, errorHandler:Function=null):void {
			var ba:ByteArray = FileSerializer.readBytesFromFile(swfFile);
			var swf:SWF = new SWF(ba);
			swf.addEventListener(Event.COMPLETE, function(evt:Event):void {
				var symbols:Dictionary = swf.symbolClassNamesDic;
				if(resCache[swfFile] != null)
					LogUtil.warn("swf file already loaded: {0}", swfFile);
				resCache[swfFile] = symbols;
				LogUtil.info("load swf file: {0}", swfFile);
				successHandler.call();
			});
			swf.process();
		}
	}
}