package editor
{
	import editor.constant.NameDef;
	import editor.constant.ScreenDef;
	import editor.mgr.PopupMgr;
	import editor.utils.FileSerializer;
	import editor.view.IPopup;
	import editor.view.window.MainWindow;
	import editor.view.window.ResLibraryWindow;
	import editor.view.window.TitleWindowBase;
	
	import flash.display.NativeMenu;
	import flash.display.NativeMenuItem;
	import flash.events.Event;
	
	import mx.core.IFlexDisplayObject;
	import mx.events.FlexEvent;
	import mx.managers.PopUpManager;
	
	import spark.components.WindowedApplication;
	
	public class SceneEditorApp extends WindowedApplicationBase
	{
		private var _mainWnd:MainWindow;
		private var _resLibraryWnd:ResLibraryWindow;
		
		private var _global_config:Object;
		
		private var _menuData:Array = [
			["文件", [["新建", "N", fileNewHandler],["打开", "O", fileOpenHandler],["保存", "S", fileSaveHandler],[],["切换工作路径", "P", switchWorkspaceHandler],["退出", "Q", quitHandler]]],
			["查看", [["Open", "O"],["Save", "S"],["Quit", "Q"]]],
			["关于", [["Open", "O"],["Save", "S"],["Quit", "Q"]]]
		];
		
		public function SceneEditorApp()
		{
			super();
		}
		
		override protected function app_creationCompleteHandler(event:FlexEvent):void {
			readGlobalConfig();
			this.stage.nativeWindow.menu = createMenuBar();
			
			_mainWnd = new MainWindow();
			this.addElement(_mainWnd);
			
			_resLibraryWnd = new ResLibraryWindow(getGlobalConfig(NameDef.CFG_RES_LIBRARY) as String);
			_resLibraryWnd.width = ScreenDef.RESLIBRARY_W;
			_resLibraryWnd.height = ScreenDef.RESLIBRARY_H;
			super.app_creationCompleteHandler(event);
		}
		
		public function initializeViews():void {
			
		}
		
		private function readGlobalConfig():void {
			_global_config = FileSerializer.readJsonFile("C:\\workspace/scene-editor/bin-debug/editor_config.json");
		}
		
		public function getGlobalConfig(key:String):Object {
			return _global_config[key];
		}
		
		private function createMenuBar():NativeMenu {
			var menuBar:NativeMenu = new NativeMenu();
			for each(var subMenu:Array in _menuData) {
				var subMenuName:String = subMenu[0] as String;
				var subMenuItems:Array = subMenu[1] as Array;
				if(subMenuItems.length > 0) {
					var menu:NativeMenu = new NativeMenu();
					for each(var d:Array in subMenuItems) {
						if(d.length > 0) {
							var item:NativeMenuItem = new NativeMenuItem(d[0] as String);
							var handler:Function = d.length > 2 ? d[2] as Function : null;
							item.keyEquivalent = d[1] as String;
							menu.addItem(item);
							if(handler != null)
								item.addEventListener(Event.SELECT, handler);
						} else {
							menu.addItem(new NativeMenuItem("", true)); //separator
						}
					}
					menuBar.addSubmenu(menu, subMenuName);
				}
			}
			return menuBar;
		}
		
		private function fileNewHandler(evt:Event):void {
			var wnd:TitleWindowBase = new TitleWindowBase("Test");
			wnd.width = 400;
			wnd.height = 400;
			PopupMgr.getInstance().popupWindow(wnd);
		}
		private function fileOpenHandler(evt:Event):void {
		}
		private function fileSaveHandler(evt:Event):void {
		}
		private function switchWorkspaceHandler(evt:Event):void {
		}
		private function quitHandler(evt:Event):void {
		}
		
		private var resLibarayContextMenu:Object = {"type":"check", "label":NameDef.WND_RES_LIBRARY+"面板", "toggled":true, "handler":toggleWindowPopup}; 
		private var appContextMenuData:Array = [
			resLibarayContextMenu,
			{"type":"separator"}
		];
		
		override protected function initContextMenuData():void {
			resLibarayContextMenu["param"] = _resLibraryWnd;
			contextMenuInfos[this] = {"menuitems":appContextMenuData, "before_handler":appBeforeContextMenuHandler, "onhide":appHideContextMenuHandler};
		}
		
		protected function appBeforeContextMenuHandler(event:* = null):void {
			resLibarayContextMenu["toggled"] = _resLibraryWnd.isPopup;
		}
		
		protected function appHideContextMenuHandler():void {
			setFocus();
		}
		
		private function toggleWindowPopup(wnd:IPopup):void {
			if(wnd.isPopup) {
				PopupMgr.getInstance().closeWindow(wnd);
			} else {
				PopupMgr.getInstance().popupWindow(wnd);
			}
		}
	}
}