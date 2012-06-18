package editor.dataeditor.impl.parser.xml
{
	import editor.dataeditor.impl.ComponentPool;
	import editor.dataeditor.impl.EditorBase;
	import editor.dataeditor.impl.ElementProperty;
	import editor.datatype.impl.parser.xml.XMLDataParser;
	import editor.datatype.type.DataContext;
	
	import flash.utils.Dictionary;

	public class XMLEditorParser
	{
		public function XMLEditorParser() {
		}
		
		public static function importFromXML(xml:XML, ctx:DataContext, cache:Dictionary):void {
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
		private static function makeEditor(xml:XML, ctx:DataContext, cache:Dictionary, haloEditor:EditorBase = null):EditorBase {
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
			dataEditor.property = processProperties(xml, ctx);
			dataEditor.children = processChildren(xml, ctx, cache);
			if(xml.hasOwnProperty('@label'))
				dataEditor.label = xml.@label;
			if(xml.hasOwnProperty('@property'))
				dataEditor.bindingTarget = xml.@property;
			return dataEditor;
		}
		
		private static function processProperties(editorXml:XML, ctx:DataContext):Vector.<ElementProperty> {
			var props:Vector.<ElementProperty> = new Vector.<ElementProperty>;
			for each(var p:XML in editorXml.elements('property')) {
				props.push(onProperty(p, ctx));
			}
			return props;
		}
		
		private static function processChildren(editorXml:XML, ctx:DataContext, cache:Dictionary):Vector.<EditorBase> {
			var children:Vector.<EditorBase> = new Vector.<EditorBase>;
			for each(var c:XML in editorXml.elements('child')) {
				children.push(makeEditor(c, ctx, cache));
			}
			return children;
		}
		
		private static function onProperty(xml:XML, ctx:DataContext):ElementProperty {
			if(!xml.hasOwnProperty('@name'))
				throw new Error("ElementProperty must have the name of the property: " + xml.toString());
			var name:String = xml.@name;
			var value:Object = XMLDataParser.basicDataFromXML(xml.children()[0], ctx);
			return new ElementProperty(name, value);
		}
	}
}