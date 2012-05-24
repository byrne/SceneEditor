package editor.utils
{
	public class LogUtil
	{
		public function LogUtil()
		{
		}
		
		private static function _trace(str:String):void {
			trace(str);
		}
			
		public static function debug(msg:String, ... rest):void {
			for(var i:int=0; i<rest.length; i++) {
				msg = msg.replace(new RegExp("\\{"+i+"\\}", "g"), rest[i]);
			}
			_trace("DEBUG: " + msg);
		}
		
		public static function info(msg:String, ... rest):void {
			for(var i:int=0; i<rest.length; i++) {
				msg = msg.replace(new RegExp("\\{"+i+"\\}", "g"), rest[i]);
			}
			_trace("INFO: " + msg);
		}
		
		public static function warn(msg:String, ... rest):void {
			for(var i:int=0; i<rest.length; i++) {
				msg = msg.replace(new RegExp("\\{"+i+"\\}", "g"), rest[i]);
			}
			_trace("WARN: " + msg);
		}
		
		public static function error(msg:String, ... rest):void {
			for(var i:int=0; i<rest.length; i++) {
				msg = msg.replace(new RegExp("\\{"+i+"\\}", "g"), rest[i]);
			}
			_trace("ERROR: " + msg);
		}
	}
}