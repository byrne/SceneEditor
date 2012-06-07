package editor.datatype.impl.parser.xml
{
	import editor.datatype.type.ComposedType;
	import editor.datatype.type.DataContext;
	import editor.datatype.type.DataProperty;
	import editor.datatype.type.IDataType;
	import editor.datatype.type.NativeType;

	public class XMLTypeParser
	{
		public static const QNAME_TYPE:String = "type";
		public static const QNAME_STYLE:String = "style";
		public static const QNAME_BASIC:String = "basic";
		public static const QNAME_INHERIT:String = "inherit";
		public static const QNAME_PROPERTY:String = "property";
		
		public function XMLTypeParser() {
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
			for each(var e:IDataType in ctx) {
				if(!(e is ComposedType))
					continue;
				bindHierarchy(e.definition.elements(QNAME_INHERIT), e as ComposedType, ctx);
				bindProperty(e.definition.elements(QNAME_PROPERTY), e as ComposedType, ctx);
			}
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
				type = new NativeType(src.@name);
			else
				type = new ComposedType(src.@name);
			type.definition = src;
			ctx[type.name] = type;
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
		private static function bindHierarchy(src:XMLList, dType:ComposedType, ctx:DataContext):void {
			for each(var element:XML in src) {
				dType.hierarchies.push(ctx[element.@type]);
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
		private static function bindProperty(src:XMLList, dType:ComposedType, ctx:DataContext):void {
			for each(var element:XML in src) {
				dType.nativeProperties.push(new DataProperty(element.@name, ctx[element.@type]));
			}
		}
	}
}