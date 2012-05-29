package editor.mgr
{
	import editor.view.IPopup;
	
	import flash.display.DisplayObject;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import mx.core.FlexGlobals;
	import mx.core.IFlexDisplayObject;
	import mx.managers.PopUpManager;
	
	public class PopupMgr extends EventDispatcher
	{
		private var _parent:DisplayObject;
		
		private static var _instance:PopupMgr;
		
		public function PopupMgr(parent:DisplayObject)
		{
			_parent = parent;
			super(null);
		}
		
		public static function getInstance():PopupMgr {
			if(_instance == null) {
				_instance = new PopupMgr(FlexGlobals.topLevelApplication as DisplayObject);
			}	
			return _instance;
		}
		
		//-----------------------------------------------------------------------------------------------------
		// window popup
		public function popupWindow(wnd:IPopup):void {
			if(!wnd.isPopup) {
				PopUpManager.addPopUp(wnd as IFlexDisplayObject, _parent, wnd.needModal);
				PopUpManager.centerPopUp(wnd as IFlexDisplayObject);
				wnd.onPopup();
			}
		}
		
		public function closeWindow(wnd:IPopup):void {
			if(wnd.isPopup) {
				PopUpManager.removePopUp(wnd as IFlexDisplayObject);
				wnd.onClose();
			}
		}
	}
}