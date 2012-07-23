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
		private var _content:IElement;
		private var _data:ComposedData;
		private var _editorBase:EditorBase;
		private var _editable:Boolean;
		
		public function PropertyEditorWindow(title:String) {
			super(title, true, false);
		}
		
		public function set target(data:ComposedData):void {
			if(data == null)
				return;
			_editorBase = EditorGlobal.DATA_MANAGER.getEditorByType(data.templateName);
			_data = data;
			content = _editorBase.getEditorFor(data);
		}
		
		public function get editable():Boolean {
			return _editable;
		}
		public function set editable(v:Boolean):void {
			if(v == _editable)
				return;
			_editable = v;
			if(_editorBase)
				_editorBase.lock(!v);
		}
		
		public function set content(view:IElement):void {
			if(_content != null && _content.parent == this.contentGroup)
				removeElement(_content as IVisualElement);
			_content = view;
			_content.percentHeight = 100;
			_content.percentWidth = 100;
			addElement(_content as IVisualElement);
		}
		
		override public function onClose(evt:CloseEvent=null):void {
			super.onClose(evt);
			removeElement(_content as IVisualElement);
		}
	}
}
