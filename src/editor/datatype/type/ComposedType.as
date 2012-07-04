package editor.datatype.type
{
	import editor.datatype.data.ComposedData;
	import editor.datatype.impl.UtilDataType;
	
	import flash.utils.Dictionary;

	public class ComposedType implements IDataType
	{
		private var _name:String;
		public function get name():String { return _name; }
		public function set name(v:String):void { _name = v; }
		
		private var _definition:Object;
		public function get definition():Object { return _definition; }
		public function set definition(v:Object):void { _definition = v; }
		
		public var hierarchies:Vector.<IDataType> = new Vector.<IDataType>;
		/**
		 * ONLY those properties defined in definition, but not those inherited properties. 
		 */
		public var nativeProperties:Vector.<DataProperty> = new Vector.<DataProperty>;
		/**
		 * A look-up table of property_names and the cooresponding IDataType objects.
		 */
		private var property_cache:Dictionary;
		
		public function ComposedType(name:String = null) {
			this.name = name;
		}
		
		public function construct():* {
			var data:ComposedData = new ComposedData();
			data.$type = this;
			for(var key:String in properties)
				data[key] = (properties[key] is ComposedType) ? null : (properties[key] as IDataType).construct();
			return data;
		}
		
		public function check(value:*):Boolean {
			if(value == null) // really need to think on this one
				return true;
			else if(!(value is ComposedData)) 
				return false;
			else if((value as ComposedData).$type != this)
				return false;
			return checkProperty(value as ComposedData);
		}
		
		public function convert(v:*):DataConvertResult {
			var result:DataConvertResult = new DataConvertResult;
			return result;
		}
		
		public function get properties():Dictionary {
			if(property_cache == null) {
				property_cache = new Dictionary;
				var i:int = 0;
				for(i = 0; i < hierarchies.length; i++)
					UtilDataType.mergeObjs(property_cache, (hierarchies[i] as ComposedType).properties);
				for(i = 0; i < nativeProperties.length; i++)
					property_cache[nativeProperties[i].name] = nativeProperties[i].value;
			}
			return property_cache;
		}
		
		private function checkProperty(value:ComposedData):Boolean {
			// TO be implemented
			return true;
		}
	}
}