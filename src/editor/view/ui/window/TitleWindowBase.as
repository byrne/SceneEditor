package editor.view.ui.window
{
	import flash.events.Event;
	
	import mx.events.CloseEvent;
	import mx.events.FlexEvent;
	import mx.managers.PopUpManager;
	
	import spark.components.TitleWindow;
	
	public class TitleWindowBase extends TitleWindow
	{
		protected var showCloseBtn:Boolean;
		
		public function TitleWindowBase(title:String, showCloseBtn:Boolean=true)
		{
			super();
			this.title = title;
			this.showCloseBtn = showCloseBtn;
			this.addEventListener(FlexEvent.CREATION_COMPLETE, createCompleteHandler);
		}
		
		protected function createCompleteHandler(evt:Event):void {
			if(showCloseBtn) {
				this.addEventListener(CloseEvent.CLOSE, onCloseHandler);
			} else {
				this.closeButton.visible = false;
			}
		}
		
		protected function onCloseHandler(evt:CloseEvent):void {
			PopUpManager.removePopUp(this);	
		}
	}
}