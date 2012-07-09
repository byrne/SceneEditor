package editor.datatype.type
{
	import editor.datatype.error.UndefinedDataTypeError;
	import editor.datatype.error.UnexpectedTypeError;
	
	import flash.utils.Dictionary;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;

	public class DataTypeContext extends Proxy
	{
		private var _$cache:Dictionary = new Dictionary;
		private var _$keys:Array;
		private var _$vals:Array;
		private var $override:Boolean = false;
		
		public function DataTypeContext() {
		}
		
		override flash_proxy function setProperty(name:*, value:*):void {
			if(_$cache.hasOwnProperty(name) && !$override)
				throw new Error("Error: " + name.toString() + " exist already.");
			if(value is IDataType)
				_$cache[name] = value;
			else
				throw new UnexpectedTypeError("not a IDataType");
		}
		
		override flash_proxy function getProperty(name:*):* {
			return _$cache[name];
		}
		
		override flash_proxy function deleteProperty(name:*):Boolean {
			return delete _$cache[name];
		}
		
		override flash_proxy function hasProperty(name:*):Boolean {
			return _$cache.hasOwnProperty(name);
		}
		
		override flash_proxy function nextNameIndex(index:int):int {
			if(index == 0) {
				_$keys = new Array;
				_$vals = new Array;
				for(var key:String in _$cache) {
					_$keys.push(key);
					_$vals.push(_$cache[key]);
				}
			}
			
			return index < _$keys.length ? index+1 : 0;
		}
		
		override flash_proxy function nextName(index:int):String {
			return _$keys[index-1];
		}
		
		override flash_proxy function nextValue(index:int):* {
			return _$vals[index-1];
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
			if(_$cache.hasOwnProperty(key) == false || override == true) {
				_$cache[key] = type;
				return true;
			}
			else {
				return false;
			}
		}
	}
}