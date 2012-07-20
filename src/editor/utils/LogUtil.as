package editor.utils
{
	public class LogUtil
	{
		public static const LOG_LEVEL_ERROR:int = 1;
		public static const LOG_LEVEL_WARN:int = 2;
		public static const LOG_LEVEL_INFO:int = 3;
		public static const LOG_LEVEL_DEBUG:int = 4;
		
		public static var LOG_LEVEL:int = 4;
		
		public function LogUtil()
		{
		}
		
		private static function _trace(str:String):void {
			trace(str);
		}
			
		public static function debug(msg:String, ... rest):void {
			if(LOG_LEVEL < LOG_LEVEL_DEBUG)
				return;
			for(var i:int=0; i<rest.length; i++) {
				msg = msg.replace(new RegExp("\\{"+i+"\\}", "g"), rest[i]);
			}
			_trace("DEBUG: " + msg);
		}
		
		public static function info(msg:String, ... rest):void {
			if(LOG_LEVEL < LOG_LEVEL_INFO)
				return;
			for(var i:int=0; i<rest.length; i++) {
				msg = msg.replace(new RegExp("\\{"+i+"\\}", "g"), rest[i]);
			}
			_trace("INFO: " + msg);
		}
		
		public static function warn(msg:String, ... rest):void {
			if(LOG_LEVEL < LOG_LEVEL_WARN)
				return;
			for(var i:int=0; i<rest.length; i++) {
				msg = msg.replace(new RegExp("\\{"+i+"\\}", "g"), rest[i]);
			}
			_trace("WARN: " + msg);
		}
		
		public static function error(msg:String, ... rest):void {
			if(LOG_LEVEL < LOG_LEVEL_ERROR)
				return;
			for(var i:int=0; i<rest.length; i++) {
				msg = msg.replace(new RegExp("\\{"+i+"\\}", "g"), rest[i]);
			}
			_trace("ERROR: " + msg);
		}
	}
}