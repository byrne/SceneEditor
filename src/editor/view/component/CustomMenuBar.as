package editor.view.component
{
	import editor.constant.EventDef;
	import editor.event.DataEvent;
	import editor.utils.LogUtil;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.controls.MenuBar;
	import mx.controls.menuClasses.MenuBarItem;
	import mx.events.FlexEvent;
	import mx.events.MenuEvent;
	
	public class CustomMenuBar extends MenuBar
	{
		public function CustomMenuBar()
		{
			super();
			this.showRoot = false;
			this.addEventListener(MouseEvent.CLICK, menuClickHandler);
			this.addEventListener(MenuEvent.ITEM_CLICK, menuItemClickHandler);
		}
		
		protected function menuClickHandler(evt:MouseEvent):void {
			var mbi:MenuBarItem = evt.target as MenuBarItem;
			if(mbi) {
				var itemData:XML = mbi.data as XML;
				this.dispatchEvent(new DataEvent(EventDef.MENU_CLICK, itemData));
				LogUtil.debug("menu click: "+itemData.@["label"] +", "+itemData.@["event"]);
			}
		}
		
		protected function menuItemClickHandler(evt:MenuEvent):void {
			var itemData:XML = evt.item as XML;
			this.dispatchEvent(new DataEvent(EventDef.MENU_ITEM_CLICK, itemData));
			LogUtil.debug("menu item click: "+itemData.@["label"] +", "+itemData.@["event"]);
		}
	}
}