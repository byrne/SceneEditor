package editor.datatype.impl.parser.xml
{
	import editor.EditorGlobal;
	import editor.datatype.data.ComposedData;
	import editor.datatype.data.Reference;
	import editor.datatype.impl.UtilDataType;
	import editor.datatype.type.ComposedType;
	import editor.datatype.type.DataTypeContext;
	import editor.datatype.type.IDataType;
	import editor.mgr.DataManager;
	
	import mx.utils.ObjectUtil;

	public class XMLDataParser
	{
		public function XMLDataParser() {
		}
		
		/**
		 * Create an XML representation of an object constructed by a DataType.
		 * 
		 * @param obj an object constructed by a DataType
		 * @return XML representation of the object
		 * 
		 */
		public static function toXML(obj:Object, ctx:DataTypeContext):XML {
			if(obj && obj is ComposedData)
				return composedDataToXML(obj, ctx);
			if(obj && (typeof obj) == "object" && !(obj is Array))
				return genericDataToXML(obj, ctx);
			else
				return simpleDataToXML(obj, ctx);
		}
		
		private static function simpleDataToXML(obj:Object, ctx:DataTypeContext):XML {
			var xml:XML = <value />;
			xml.setName(UtilDataType.typeOf(obj));
			if(obj.hasOwnProperty("source"))
				obj = obj["source"];
			if(obj is Array)
				for(var i:int = 0; i < (obj as Array).length; i++)
					xml.appendChild(toXML(obj[i], ctx));
			else
				xml.appendChild(obj);
			return xml;
		}
		
		private static function composedDataToXML(obj:Object, ctx:DataTypeContext):XML {
			var xml:XML = <value />;
			xml.setName(UtilDataType.typeOf(obj));
			
			for (var key:String in obj) {
				if(obj[key] == null)
					continue;
				var childXML:XML = toXML(obj[key], ctx);
				childXML.@property = key;
				xml.appendChild(childXML);
			}
			
			return xml;
		}
		
		/**
		 * Convert explicitly defined vo's into XML using associated ComposedType's infomation. <p>
		 * There must exist a ComposedType with exactly the same name as the vo Class, otherwise it will not be
		 * translated into XML.
		 * <p>
		 * @param obj vo object to be translated
		 * @param ctx DataTypeContext inwhich ComposedType has been defined
		 * @return XML representation of the vo object, parsable using XMLDataParser
		 * 
		 */
		private static function genericDataToXML(obj:Object, ctx:DataTypeContext):XML {
			var xml:XML = <value />;
			xml.setName(UtilDataType.typeOf(obj));
			
			var type_name:String = UtilDataType.guessType(obj);
			var type:ComposedType = ctx[type_name];
			if(type == null)
				throw new Error("Cannot found propotype for " + ObjectUtil.toString(obj));
			
			var desc:Object = ObjectUtil.getClassInfo(obj);
			for (var key:String in type.properties) {
				if(!obj.hasOwnProperty(key) ||obj[key] == null)
					continue;
				var childXML:XML = toXML(obj[key], ctx);
				childXML.@property = key;
				xml.appendChild(childXML);
			}
			
			return xml;
		}
		
		/**
		 * Create a data object from an XML using DataTypes defined in a DataContext.
		 * 
		 * @param xml XML representation of a data object
		 * @param ctx DataContext containing defined DataTypes
		 * @return a data object
		 * 
		 */
		public static function fromXML(xml:XML, ctx:DataTypeContext):Object {
			var data:Object;
			var type:IDataType = ctx[xml.localName()];
			if(type is ComposedType)
				data = composedDataFromXML(xml, ctx);
			else
				data = basicDataFromXML(xml, ctx);
			return data;
		}
		
		private static function basicDataFromXML(xml:XML, ctx:DataTypeContext):Object {
			var value:Object;
			
			switch(xml.localName()) {
				case DataManager.TYPE_UNDEFINED:
					value = null;
					break;
				case DataManager.TYPE_BOOLEAN:
					value = xml.text().toLowerCase() == "false" ? false : true;
					break;
				case DataManager.TYPE_FLOAT:
					value = parseFloat(xml.text());
					break;
				case DataManager.TYPE_INT:
					value = parseInt(xml.text());
					break;
				case DataManager.TYPE_STRING:
					value = xml.text().toString();
					break;
				case DataManager.TYPE_ARRAY:
					value = arrayFromXML(xml, ctx);
					break;
				case DataManager.TYPE_REFERENCE:
					value = referenceFromXML(xml, ctx);
			}
			
			return value;
		}
		
		private static function referenceFromXML(xml:XML, ctx:DataTypeContext):Object {
			var ref:Reference = new Reference;
			return ref;
		}
		
		private static function arrayFromXML(xml:XML, ctx:DataTypeContext):Object {
			var array:Array = [];
			for each(var element:XML in xml.children()) {
				array.push(fromXML(element, ctx));
			}
			return array;
		}
		
		private static function composedDataFromXML(xml:XML, ctx:DataTypeContext):ComposedData {
			var type:IDataType = ctx[xml.name()];
			var data:ComposedData = type.construct();
			
			if(xml.hasOwnProperty('@uid')) {
				data.$uid = xml.@uid.toString();
				data = EditorGlobal.DATA_MEMORY.trySetEntity(data);
			}
			
			for each(var element:XML in xml.children()) {
				data[element.@property] = fromXML(element, ctx);
			}
			
			return data;
		}
	}
}