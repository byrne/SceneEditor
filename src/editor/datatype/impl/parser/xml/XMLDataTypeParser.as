package editor.datatype.impl.parser.xml
{
	import editor.datatype.data.BasicDataType;
	import editor.datatype.data.DataContext;
	import editor.datatype.data.DataProperty;
	import editor.datatype.data.DataType;
	import editor.datatype.data.IDataType;
	import editor.datatype.impl.UtilDataType;

	public class XMLDataTypeParser
	{
		public static const QNAME_TYPE:String = "type";
		public static const QNAME_STYLE:String = "style";
		public static const QNAME_BASIC:String = "basic";
		public static const QNAME_INHERIT:String = "inherit";
		public static const QNAME_PROPERTY:String = "property";
		
		public function XMLDataTypeParser() {
		}
		
		/**
		 * Import DataType's from an XML into a DataContext object. 
		 *
		 * @param src DataType definition in XML
		 * @param ctx dataContext to which the created DataType objects will be stored
		 * 
		 */
		public static function importToContext(src:XML, ctx:DataContext):void {
			var type_element:XML;
			
			for each(type_element in src.children()) {
				buildPlaceHolder(type_element, ctx);
			}
			bindAttributes(ctx);
		}
		
		public static function bindAttributes(ctx:DataContext):void {
			ctx.iterate(function(element:IDataType):void {
				if(!(element is DataType))
					return;
				bindHierarchy(element.definition.elements(QNAME_INHERIT), element as DataType, ctx);
				bindProperty(element.definition.elements(QNAME_PROPERTY), element as DataType, ctx);
			});
		}
		
		/**
		 * @private 
		 * A DataType may reference other DataType defined after its very own definition in the XML,
		 * therefore, we have to make sure every DataType object exists before we actually link 
		 * those reference.
		 */
		private static function buildPlaceHolder(src:XML, ctx:DataContext):void {
			if(src.localName() != QNAME_TYPE)
				return;
			
			var type:IDataType;
			
			if(src.@style == QNAME_BASIC)
				type = new BasicDataType(src.@name);
			else
				type = new DataType(src.@name);
			type.definition = src;
			ctx.setType(type.name, type);
		}
		
		/**
		 * @private
		 * Link hierarchies of a DataType object with corresponding DataType's from a given 
		 * DataContext. Still need the xml document though.
		 * 
		 * @param src hierarchy xml documents
		 * @param dType the DataType object to be modified
		 * @param ctx the DataContext object given
		 * 
		 */
		private static function bindHierarchy(src:XMLList, dType:DataType, ctx:DataContext):void {
			for each(var element:XML in src) {
				dType.hierarchies.push(ctx.getType(element.@type));
			}
		}
		
		/**
		 * @private
		 * Link properties of a DataType object with corresponding DataType's from a given 
		 * DataContext. Still need the xml document also.
		 * 
		 * @param src property xml documents
		 * @param dType the DataType object to be modified
		 * @param ctx the DataContext object given
		 * 
		 */
		private static function bindProperty(src:XMLList, dType:DataType, ctx:DataContext):void {
			for each(var element:XML in src) {
				dType.properties.push(new DataProperty(element.@name, ctx.getType(element.@type)));
			}
		}
	}
}