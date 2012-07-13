package editor.datatype.data
{
	import editor.EditorGlobal;
	import editor.datatype.ReservedName;
	import editor.datatype.error.InvalidPropertyNameError;
	import editor.datatype.error.UndefinedPropertyError;
	import editor.datatype.error.UnexpectedTypeError;
	import editor.datatype.impl.UtilDataType;
	import editor.datatype.type.ComposedType;
	import editor.datatype.type.DataConvertResult;
	import editor.datatype.type.IDataType;
	import editor.view.scene.EntityBaseView;
	
	import flash.utils.Dictionary;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	
	import mx.utils.StringUtil;
	
	public class ComposedData extends Proxy
	{
		private static const NAME_PATTERN:RegExp = new RegExp("^[a-z|A-Z][a-z|A-Z|0-9|_]+$", "ig");

		public var $type:IDataType;
		public var $uid:String;
		
		protected var _$cache:Dictionary = new Dictionary;
		protected var _$keys:Array;
		protected var _$vals:Array;
		protected var _$assignmentCount:Dictionary = new Dictionary;
		
		protected var _view:EntityBaseView;
		
		public function ComposedData() {
			super();
		}
		
		override flash_proxy function setProperty(name:*, value:*):void {
			var propertyType:IDataType = ($type as ComposedType).properties[name];
			
			if(name == null || name.toString().indexOf("$") == 0)
				throw new InvalidPropertyNameError(name);
			if(propertyType == null)	// property with the given name has been defined
				throw new UndefinedPropertyError(name, $type);
			
			value = forgeTypeValue(value, propertyType);
			var propertyChanged:Boolean = !_$cache.hasOwnProperty(name) || _$cache[name] != value;
			if(propertyChanged) {
				_$cache[name] = value;
				_$assignmentCount[name] =  numAssignments(name) + 1;
				if(ReservedName.isReservedName(name) && this.view != null) {
					if(name == ReservedName.KEYWORD)
						EditorGlobal.MAIN_WND.refreshEntitiesTree();
					else
						this.view.syncDataToView();
				}
			}
		}
		
		private function forgeTypeValue(value:*, propertyType:IDataType):* {
			if(propertyType.check(value))
				return value;
			 var i:DataConvertResult = propertyType.convert(value);
			 if(i.success)
				 return i.value;
			 else {
				 throw new UnexpectedTypeError(StringUtil.substitute("Expecting a {0}, got a {1} instead", propertyType.name, typeof value));
			 }
		}
		
		private function numAssignments(prop:String):int {
			return _$assignmentCount.hasOwnProperty(prop) ? _$assignmentCount[prop] : 0;
		}
		
		/**
		 * Whether a property has been assigned a value by the user. 
		 * @param property
		 * @return 
		 * 
		 */
		public function assigned(property:String):Boolean {
			return _$assignmentCount.hasOwnProperty(property) ? _$assignmentCount[property] > 1 : false;
		}
		
		/**
		 * Whether the ComposedData object has just been constructed, and has NOT been assigned any value to any of
		 * its property. 
		 * @return 
		 * 
		 */
		public function get isNew():Boolean {
			for each(var key:String in _$cache) {
				if(assigned(key))
					return false;
			}
			return true;
		}
		
		override flash_proxy function getProperty(name:*):* {
			return _$cache[name];
		}
		
		override flash_proxy function hasProperty(name:*):Boolean {
			return _$cache.hasOwnProperty(name);
		}
		
		override flash_proxy function deleteProperty(name:*):Boolean {
			delete _$assignmentCount[name];
			return delete _$cache[name];
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
		
		public function toString():String {
			return "[ComposedData " + $type.name + "]";
		}
		
		public function set view(v:EntityBaseView):void {
			this._view = v;
		}
		
		public function get view():EntityBaseView {
			return this._view;
		}
	}
}
