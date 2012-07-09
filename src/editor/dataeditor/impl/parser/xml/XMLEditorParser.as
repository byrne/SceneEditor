package editor.dataeditor.impl.parser.xml
{
	import editor.dataeditor.impl.ComponentPool;
	import editor.dataeditor.impl.EditorBase;
	import editor.dataeditor.impl.ElementProperty;
	import editor.datatype.impl.parser.xml.XMLDataParser;
	import editor.datatype.type.DataTypeContext;
	import editor.utils.DictionaryUtil;
	import editor.utils.StringRep;
	
	import flash.utils.Dictionary;

	public class XMLEditorParser
	{
		public static const RESERVED_PROPERTIES:Array = ['component', 'property', 'view_label'];
		public static const TRANSLATION:Object = {
			'default': 'defaultValue'
		};
		
		public static function importFromXML(xml:XML, ctx:DataTypeContext, cache:Dictionary):void {
			var editorBase:EditorBase;
			for each(var editorXML:XML in xml.elements('editor')) {
				editorBase = new EditorBase(null, null);
				editorBase.definition = editorXML;
				cache[editorXML.@name.toString()] = editorBase;
			}
			for each(editorXML in xml.elements('editor')) {
				makeEditor(editorXML, ctx, cache, cache[editorXML.@name.toString()]);
			}
		}
		
		/* ***************************************
		 * Routins used in parsing Editor.
		 */
		private static function makeEditor(xml:XML, ctx:DataTypeContext, cache:Dictionary, haloEditor:EditorBase = null):EditorBase {
			if(xml.hasOwnProperty('@component') == false)
				throw new Error("Missing component attribute: " + xml.toString());
			var dataEditor:EditorBase;
			if(haloEditor == null)
				dataEditor = new EditorBase("__child__", cache[xml.@component.toString()]);
			else {
				dataEditor = haloEditor;
				dataEditor.name = xml.@name;
				dataEditor.componentClass = cache[xml.@component.toString()];
			}
			dataEditor.property = DictionaryUtil.merge(dataEditor.property, processPropertiesInAttribute(xml), false);
			dataEditor.property = DictionaryUtil.merge(dataEditor.property, processProperties(xml, ctx), false);
			dataEditor.children = processChildren(xml, ctx, cache);
			if(xml.hasOwnProperty('@view_label'))
				dataEditor.view_label = xml.@view_label;
			if(xml.hasOwnProperty('@property'))
				dataEditor.bindingTarget = xml.@property;
			return dataEditor;
		}
		
		private static function processPropertiesInAttribute(editorXml:XML):Dictionary {
			var props:Dictionary = new Dictionary;
			var prop_name:String;
			
			for each(var att:XML in editorXml.attributes()) {
				prop_name = att.name().toString();
				if(RESERVED_PROPERTIES.indexOf(prop_name) != -1)
					continue;
				if(TRANSLATION.hasOwnProperty(prop_name))
					prop_name = TRANSLATION[prop_name];
				props[prop_name] = new ElementProperty(prop_name, StringRep.read(att));
			}
			return props;
		}
		
		private static function processProperties(editorXml:XML, ctx:DataTypeContext):Dictionary {
			var props:Dictionary = new Dictionary;
			for each(var p:XML in editorXml.elements('property')) {
				var elemProp:ElementProperty = onProperty(p, ctx);
				props[elemProp.property] = elemProp;
			}
			return props;
		}
		
		private static function processChildren(editorXml:XML, ctx:DataTypeContext, cache:Dictionary):Vector.<EditorBase> {
			var children:Vector.<EditorBase> = new Vector.<EditorBase>;
			for each(var c:XML in editorXml.elements('child')) {
				children.push(makeEditor(c, ctx, cache));
			}
			return children;
		}
		
		private static function onProperty(xml:XML, ctx:DataTypeContext):ElementProperty {
			if(!xml.hasOwnProperty('@name'))
				throw new Error("ElementProperty must have the name of the property: " + xml.toString());
			var name:String = xml.@name;
			var value:Object = XMLDataParser.basicDataFromXML(xml.children()[0], ctx);
			return new ElementProperty(name, value);
		}
	}
}