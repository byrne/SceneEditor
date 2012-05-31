package editor
{
	import editor.constant.NameDef;
	import editor.dataeditor.ComposedDataEditor;
	import editor.dataeditor.DataEditorFactory;
	import editor.datatype.impl.DataFactory;
	import editor.datatype.impl.parser.xml.XMLDataParser;
	import editor.mgr.PopupMgr;
	import editor.utils.FileSerializer;
	import editor.view.IPopup;
	import editor.view.mxml.MainWindowSkin;
	import editor.view.window.ResLibraryWindow;
	import editor.view.window.TitleWindowBase;
	
	import flash.display.DisplayObject;
	import flash.display.NativeMenu;
	import flash.display.NativeMenuItem;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import mx.core.FlexGlobals;
	import mx.core.IFlexDisplayObject;
	import mx.events.CloseEvent;
	import mx.events.FlexEvent;
	import mx.managers.PopUpManager;
	
	import spark.components.TitleWindow;
	import spark.components.WindowedApplication;
	
	public class SceneEditorApp extends WindowedApplicationBase
	{
		private var _mainWnd:MainWindowSkin;
		private var _resLibraryWnd:ResLibraryWindow;
		
		private var _global_config:Object;
		
		public static function get BIN_PATH():String { return "D:\\saybot/git/scene-editor/bin-debug/";}
		
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
			
			_mainWnd = new MainWindowSkin();
			this.addElement(_mainWnd);
			
			_resLibraryWnd = new ResLibraryWindow(getGlobalConfig(NameDef.CFG_RES_LIBRARY) as String);
			_resLibraryWnd.width = 800;
			_resLibraryWnd.height = 600;
			super.app_creationCompleteHandler(event);
			dataTypeTest();
		}
		
		/**
		 * 演示方法，随便删 
		 * 
		 */
		public function dataTypeTest():void {
			var loader:URLLoader = new URLLoader;
			loader.addEventListener(Event.COMPLETE, function(e:Event):void {
				e.target.removeEventListener(e.type, arguments.callee);
				var src:XML = XML(loader.data);
				DataFactory.INSTANCE.initTable(src);
				DataEditorFactory.INSTANCE.initTable(src);
				
				var dataLoader:URLLoader = new URLLoader;
				dataLoader.addEventListener(Event.COMPLETE, function(edata:Event):void {
					edata.target.removeEventListener(edata.type, arguments.callee);
					var data:Object = XMLDataParser.fromXML(XML(edata.target.data), DataFactory.INSTANCE.allTypes);
					var wind:TitleWindow = new TitleWindow;
					var ed:ComposedDataEditor = new ComposedDataEditor();
					ed.buildFromData(data.minion);
					wind.addElement(ed);
					wind.addEventListener(CloseEvent.CLOSE, function(e:Event):void {
						wind.parent.removeChild(wind);
						trace(XMLDataParser.toXML(data));
					});
					PopUpManager.addPopUp(wind, FlexGlobals.topLevelApplication as DisplayObject);
				});
				dataLoader.load(new URLRequest(BIN_PATH+"sample-data.xml"));
			});
			loader.load(new URLRequest(BIN_PATH + "sample-templates.xml"));
		}
		
		public function initializeViews():void {
			
		}
		
		private function readGlobalConfig():void {
			_global_config = FileSerializer.readJsonFile(BIN_PATH + "editor_config.json");
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