package editor.view.component.window
{
	import editor.EditorGlobal;
	import editor.dataeditor.IElement;
	import editor.dataeditor.impl.EditorBase;
	import editor.datatype.data.ComposedData;
	
	import mx.core.IVisualElement;
	import mx.events.CloseEvent;

	public class PropertyEditorWindow extends TitleWindowBase
	{
		public var _content:IElement;
		public var _data:ComposedData;
		
		public function PropertyEditorWindow(title:String) {
			super(title, true, false);
		}
		
		public function set target(data:ComposedData):void {
			if(data == null)
				return;
			var editorBase:EditorBase = EditorGlobal.DATA_MANAGER.getEditorByType(data.templateName);
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
		
		override public function onClose(evt:CloseEvent=null):void {
			super.onClose(evt);
		}
	}
}
