package editor.datatype.impl
{
	import flash.utils.Dictionary;
	
	import mx.utils.UIDUtil;
	
	public class DataMemory
	{
		private var _cache:Dictionary = new Dictionary;
		
		public function DataMemory() {
			super();
		}
		
		/**
		 * Get the object from a specific UID.
		 * @param uid
		 * @return 
		 * 
		 */
		public function getData(uid:String):* {
			var data:* = undefined;
			
			if(_cache.hasOwnProperty(uid) && _cache[uid] != null) {
				if(_cache[uid].object != null)
					data = _cache[uid].object;
				else
					delete _cache[uid];
			}
			
			return data;
		}
		
		/**
		 * Store a data under a specific UID (a new one will be created if not specified in paramter)
		 *  
		 * @param data data to store
		 * @param uid UID associated to this data
		 * @return UID under which the data has been stored
		 * 
		 */
		public function setData(data:*, uid:String = null):String {
			if(data == null)
				throw new Error("can not store null");
			if(uid == null)
				uid = UIDUtil.getUID(data);
			_cache[uid] = new WeakReference(data);
			
			return uid;
		}
	}
}