package editor.datatype.type
{
	import editor.datatype.data.ComposedData;
	import editor.datatype.impl.UtilDataType;
	
	import flash.utils.Dictionary;
	
	import mx.utils.UIDUtil;

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
			data.$uid = UIDUtil.createUID();
			for(var key:String in properties)
				data[key] = (properties[key] is ComposedType) ? null : (properties[key] as IDataType).construct();
			return data;
		}
		
		public function check(value:*):Boolean {
			if(value == null) // really need to think on this one
				return true;
			else if(!(value is ComposedData)) 
				return false;
			else if((value as ComposedData).$type == this)
				return true;
			else {
				// value is a ComposedData, but its explicit type is not this ComposedType, so it is valid only if its
				// type inherits this ComposedType.
				for each(var dType:IDataType in (value.$type as ComposedType).hierarchies) {
					if(dType.check(value))
						return true;
				}
				return false;
			}
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
		
		/**
		 * Whether this ComposedType is also another ComposedType with the given typename. has strict or general mode.
		 * <p> 
		 * Test rules: (recursively)<br>
		 * <li>Rule 1. Any ComposedType is also itself, i.e. <code> n.isa(n.name) == true </code> </li>
		 * <li>Rule 2. An ComposedType <code>a</code> is considered to be another ComposedType <code>b</code> 
		 * if any ComposedType <code>x</code> from which <code>a</code> inherits <code>isa(b.name)</code>.</li> <p>
		 * 
		 * Strict mode uses Rule 1 only; general uses both rules and will return true if any is satisfied. <p>
		 * 
		 * @param typename name of the ComposedType to check against. <br>
		 * <b>NOTE</b>: if the typename has no suffix, strict mode will be used; 
		 * if the typename has a suffixing asterisk, general mode will be used. 
		 * 
		 * @return
		 * 
		 */
		public function isa(typeName:String):Boolean {
			switch (typeName.charAt(typeName.length-1)) {
				case '*':
					typeName = typeName.substr(0, typeName.length-1);
					if(typeName == this.name)
						return true;
					else if(hierarchies.length > 0) {
						for each(var item:IDataType in hierarchies) {
							if(item is ComposedType && (item as ComposedType).isa(typeName))
								return true;
						}
					}
					break;
				default:
					return typeName == this.name;
			}
			return false;
		}
	}
}