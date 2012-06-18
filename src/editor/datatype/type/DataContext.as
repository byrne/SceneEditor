package editor.datatype.type
{
	import editor.datatype.error.UndefinedDataTypeError;
	import editor.datatype.error.UnexpectedTypeError;
	
	import flash.utils.Dictionary;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;

	public class DataContext extends Proxy
	{
		private var _cache:Dictionary = new Dictionary;
		private var _keys:Array;
		private var _vals:Array;
		private var override:Boolean = false;
		
		public function DataContext() {
		}
		
		override flash_proxy function setProperty(name:*, value:*):void {
			if(_cache.hasOwnProperty(name) && !override)
				throw new Error("Error: " + name.toString() + " exist already.");
			if(value is IDataType)
				_cache[name] = value;
			else
				throw new UnexpectedTypeError("not a IDataType");
		}
		
		override flash_proxy function getProperty(name:*):* {
			return _cache[name];
		}
		
		override flash_proxy function deleteProperty(name:*):Boolean {
			return delete _cache[name];
		}
		
		override flash_proxy function hasProperty(name:*):Boolean {
			return _cache.hasOwnProperty(name);
		}
		
		override flash_proxy function nextNameIndex(index:int):int {
			if(index == 0) {
				_keys = new Array;
				_vals = new Array;
				for(var key:String in _cache) {
					_keys.push(key);
					_vals.push(_cache[key]);
				}
			}
			
			return index < _keys.length ? index+1 : 0;
		}
		
		override flash_proxy function nextName(index:int):String {
			return _keys[index-1];
		}
		
		override flash_proxy function nextValue(index:int):* {
			return _vals[index-1];
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
	}
}