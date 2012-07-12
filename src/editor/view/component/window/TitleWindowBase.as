package editor.view.component.window
{
	import editor.SceneEditorApp;
	import editor.mgr.PopupMgr;
	import editor.view.IPopup;
	
	import flash.events.Event;
	
	import mx.containers.Tile;
	import mx.core.FlexGlobals;
	import mx.events.CloseEvent;
	import mx.events.FlexEvent;
	import mx.managers.PopUpManager;
	
	import spark.components.TitleWindow;
	
	public class TitleWindowBase extends TitleWindow implements IPopup
	{
		protected var showCloseBtn:Boolean;
		
		private var _isPopup:Boolean;
		
		private var _modal:Boolean;
		
		public function TitleWindowBase(title:String, showCloseBtn:Boolean=true, modal:Boolean=false)
		{
			super();
			this.title = title;
			this.showCloseBtn = showCloseBtn;
			this._modal = modal;
			this.addEventListener(FlexEvent.CREATION_COMPLETE, createCompleteHandler);
		}
		
		protected function createCompleteHandler(evt:Event):void {
			var thisRef:TitleWindowBase = this;
			if(showCloseBtn) {
				this.addEventListener(CloseEvent.CLOSE, function(evt:CloseEvent):void {
					PopupMgr.getInstance().closeWindow(thisRef);
				});
			} else {
				this.closeButton.visible = false;
			}
		}
		
		public function get isPopup():Boolean {
			return _isPopup;
		}
		public function set isPopup(val:Boolean):void {
			_isPopup = val;
		}
		public function get needModal():Boolean {
			return _modal;
		}
		
		public function onPopup():void {
			_isPopup = true;
		}
		
		public function onClose(evt:CloseEvent=null):void {
			_isPopup = false;
		}
	}
}