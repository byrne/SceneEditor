package editor.view.component.window
{
	import editor.EditorGlobal;
	import editor.dataeditor.IElement;
	import editor.dataeditor.impl.EditorBase;
	import editor.datatype.data.ComposedData;
	import editor.datatype.impl.parser.xml.XMLDataParser;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.core.IVisualElement;
	import mx.managers.PopUpManager;

	public class PropertyEditorWindow extends TitleWindowBase
	{
		public var _content:IElement;
		public var _data:ComposedData;
		
		public function PropertyEditorWindow(title:String, showCloseBtn:Boolean=true, modal:Boolean=false) {
			super(title, showCloseBtn, modal);
		}
		
		public function set target(data:ComposedData):void {
			if(data == null)
				return;
			var editorBase:EditorBase = EditorGlobal.DATA_MANAGER.getEditorByType(data.$type.name);
			_data = data;
			content = editorBase.getEditorFor(data);
		}
		
		public function set content(view:IElement):void {
			if(_content != null && _content.parent == this)
				removeElement(_content as IVisualElement);
			_content = view;
			_content.percentHeight = 100;
			_content.percentWidth = 100;
			addElement(_content as IVisualElement);
		}
		
		override protected function closeButton_clickHandler(event:MouseEvent):void {
			PopUpManager.removePopUp(_content);
			trace(_data);
			var a:* = XMLDataParser.toXML(_data, EditorGlobal.DATA_MANAGER.types);
		}
	}
}
