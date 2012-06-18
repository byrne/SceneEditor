package editor.datatype.impl.parser.xml
{
	import editor.datatype.data.ComposedData;
	import editor.datatype.impl.DataTypeFactory;
	import editor.datatype.impl.UtilDataType;
	import editor.datatype.type.ComposedType;
	import editor.datatype.type.DataContext;
	import editor.datatype.type.IDataType;

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
		public static function toXML(obj:Object):XML {
			if(obj && (typeof obj) == "object" && obj.hasOwnProperty("$type"))
				return composedDataToXML(obj);
			else
				return basicDataToXML(obj);
		}
		
		private static function basicDataToXML(obj:Object):XML {
			var xml:XML = <value />;
			xml.setName(UtilDataType.typeOf(obj));
			if(obj.hasOwnProperty("source"))
				obj = obj["source"];
			if(obj is Array) {
				for(var i:int = 0; i < (obj as Array).length; i++)
					xml.appendChild(toXML(obj[i]));
			}
			else
				xml.appendChild(obj);
			return xml;
		}
		
		private static function composedDataToXML(obj:Object):XML {
			var xml:XML = <value />;
			xml.setName(UtilDataType.typeOf(obj));
			
			for(var key:String in obj) {
				if(obj[key] == null)
					continue;
				var childXML:XML = toXML(obj[key]);
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
		public static function fromXML(xml:XML, ctx:DataContext):Object {
			var data:Object;
			var type:IDataType = ctx[xml.localName()];
			if(type is ComposedType)
				data = composedDataFromXML(xml, ctx);
			else
				data = basicDataFromXML(xml, ctx);
			return data;
		}
		
		public static function basicDataFromXML(xml:XML, ctx:DataContext):Object {
			var value:Object;
			
			switch(xml.localName()) {
				case DataTypeFactory.TYPE_UNDEFINED:
					value = null;
					break;
				case DataTypeFactory.TYPE_BOOLEAN:
					value = xml.text().toLowerCase() == "false" ? false : true;
					break;
				case DataTypeFactory.TYPE_FLOAT:
					value = parseFloat(xml.text());
					break;
				case DataTypeFactory.TYPE_INT:
					value = parseInt(xml.text());
					break;
				case DataTypeFactory.TYPE_STRING:
					value = xml.text().toString();
					break;
				case DataTypeFactory.TYPE_ARRAY:
					value = arrayFromXML(xml, ctx);
					break;
			}
			
			return value;
		}
		
		private static function arrayFromXML(xml:XML, ctx:DataContext):Object {
			var array:Array = [];
			for each(var element:XML in xml.children()) {
				array.push(fromXML(element, ctx));
			}
			return array;
		}
		
		private static function composedDataFromXML(xml:XML, ctx:DataContext):ComposedData {
			var type:IDataType = ctx[xml.name()];
			var data:ComposedData = type.construct();
			for each(var element:XML in xml.children()) {
				data[element.@property] = fromXML(element, ctx);
			}
			return data;
		}
	}
}