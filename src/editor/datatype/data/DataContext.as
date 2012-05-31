package editor.datatype.data
{
	import editor.datatype.error.UndefinedDataTypeError;
	
	import flash.utils.Dictionary;

	public class DataContext
	{
		private var _cache:Dictionary = new Dictionary;
		
		public function DataContext() {
		}
		
		/**
		 * Whether a key has been defined 
		 * @param key
		 * @return 
		 * 
		 */
		public function hasType(key:String):Boolean {
			return _cache.hasOwnProperty(key);
		}
		
		/**
		 * Get the DataType Object associated with the given key. 
		 * @param key
		 * @return 
		 * 
		 */
		public function getType(key:String):IDataType {
			if(_cache.hasOwnProperty(key) == false)
				throw new UndefinedDataTypeError(key);
			return _cache[key];
		}
		
		/**
		 * Register a DataType under a specific name to the context.
		 *  
		 * @param key name under which the DataType will be registered
		 * @param type DataType object to register
		 * @param override whether to replace an existing DataType of the same key
		 * @return true if DataType has been registered, false otherwise
		 * 
		 */
		public function setType(key:String, type:IDataType, override:Boolean = true):Boolean {
			if(_cache.hasOwnProperty(key) == false || override == true) {
				_cache[key] = type;
				return true;
			}
			else {
				return false;
			}
		}
		
		/**
		 * Iterate throught all DataType objects.
		 *  
		 * @param func function to call on each DataType
		 * 
		 */
		public function iterate(func:Function):void {
			for each(var item:Object in _cache) {
				func.apply(null, [item]);
			}
		}
	}
}