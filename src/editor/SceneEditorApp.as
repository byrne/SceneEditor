package editor
{
	import editor.view.ui.window.TitleWindowBase;
	import editor.view.ui.window.MainWindow;
	
	import flash.display.NativeMenu;
	import flash.display.NativeMenuItem;
	import flash.events.Event;
	
	import mx.core.IFlexDisplayObject;
	import mx.managers.PopUpManager;
	
	import spark.components.WindowedApplication;
	
	public class SceneEditorApp extends WindowedApplication
	{
		public var facade:ApplicationFacade = ApplicationFacade.getInstance();
		
		private var _mainWindow:MainWindow;
		
		private var _menuData:Array = [
			["文件", [["新建", "N", fileNewHandler],["打开", "O", fileOpenHandler],["保存", "S", fileSaveHandler],[],["切换工作路径", "P", switchWorkspaceHandler],["退出", "Q", quitHandler]]],
			["查看", [["Open", "O"],["Save", "S"],["Quit", "Q"]]],
			["关于", [["Open", "O"],["Save", "S"],["Quit", "Q"]]]
		];
		
		public function SceneEditorApp()
		{
			super();
		}
		
		public function initializeViews():void {
			this.stage.nativeWindow.menu = createMenuBar();
			
//			_mainWindow = new MainWindow();
//			this.addElement(_mainWindow);
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
			popupWindow(wnd);
		}
		private function fileOpenHandler(evt:Event):void {
		}
		private function fileSaveHandler(evt:Event):void {
		}
		private function switchWorkspaceHandler(evt:Event):void {
		}
		private function quitHandler(evt:Event):void {
		}
		
		public function popupWindow(wnd:IFlexDisplayObject, modal:Boolean=false):void {
			PopUpManager.addPopUp(wnd, this, modal);
			PopUpManager.centerPopUp(wnd);
		}
	}
}