package editor
{
	import editor.constant.EventDef;
	import editor.constant.NameDef;
	import editor.constant.ScreenDef;
	import editor.dataeditor.ComposedDataEditor;
	import editor.dataeditor.DataEditorFactory;
	import editor.datatype.impl.DataFactory;
	import editor.datatype.impl.parser.xml.XMLDataParser;
	import editor.event.DataEvent;
	import editor.mgr.PopupMgr;
	import editor.storage.GlobalStorage;
	import editor.utils.FileSerializer;
	import editor.utils.StringUtil;
	import editor.view.IPopup;
	import editor.view.component.CustomMenuBar;
	import editor.view.component.dialog.SetWoringDirDlg;
	import editor.view.component.window.MainWindow;
	import editor.view.component.window.ResLibraryWindow;
	import editor.view.component.window.TitleWindowBase;
	import editor.view.mxml.skin.CustomAppSkin;
	
	import flash.display.DisplayObject;
	import flash.display.NativeMenu;
	import flash.display.NativeMenuItem;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import mx.collections.XMLListCollection;
	import mx.controls.menuClasses.MenuBarItem;
	import mx.core.FlexGlobals;
	import mx.events.CloseEvent;
	import mx.events.FlexEvent;
	import mx.events.MenuEvent;
	import mx.managers.PopUpManager;
	
	import spark.components.Label;
	import spark.components.TitleWindow;

	
	public class SceneEditorApp extends WindowedApplicationBase
	{
		private var _mainWnd:MainWindow;
		private var _resLibraryWnd:ResLibraryWindow;
		
		private var _global_config:Object;
		
		public static function get BIN_PATH():String { return "D:\\saybot/git/scene-editor/bin-debug/";}
		
		[Bindable]
		private var menuBarXml:XMLList = 
			<>
				<menu label="文件" event="mce_file">
					<item label="新建" event="mce_file_new"/>
					<item label="打开" event="mce_file_open"/>
					<item label="切换工作路径" event="mce_switch_workspcae"/>
					<item type="separator" event=""/>
					<item label="退出" event="mce_quit"/>
				</menu>	
				<menu label="查看" event="mce_view">
					<item label="素材库面板" event="mce_view_res_wnd" type="check" toggled="false"/>
					<item label="属性面板" event="mce_view_property_wnd" type="check" toggled="false"/>
					<item type="separator" event=""/>
					<item label="menu2" event="aa"/>
				</menu>	
				<menu label="关于" event="mce_about">
					<item label="menu1" event="aa" type="check"/>
					<item type="separator" event=""/>
					<item label="menu2" event="aa"/>
				</menu>
			</>
		
		public function SceneEditorApp()
		{
			super();
		}
		
		override protected function app_creationCompleteHandler(event:FlexEvent):void {
//			this.stage.nativeWindow.menu = createMenuBar();
			createMenuBar(menuBarXml);
			_mainWnd = new MainWindow();
			this.addElement(_mainWnd);
			
			_resLibraryWnd = new ResLibraryWindow();
			_resLibraryWnd.width = ScreenDef.RESLIBRARY_W;
			_resLibraryWnd.height = ScreenDef.RESLIBRARY_H;
			
			var hasStorage:Boolean = GlobalStorage.getInstance().read();
			if(!hasStorage) {
				menuTriggerSwitchWorkspace();
			} else {
				switchWorkspace(GlobalStorage.getInstance().working_dir);
			}
			
			statusMessage.text = "ABCDEFG";
			cursorMessage.text = "120,338";
			
//			dataTypeTest();
			super.app_creationCompleteHandler(event);
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
					ed.buildFromData(data);
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
		
		public function switchWorkspace(dir:String):void {
			_global_config = FileSerializer.readJsonFile(StringUtil.substitute("{0}/editor_config.json", dir));
			if(_global_config == null) {
				
				return;	
			}
			var str:String = getGlobalConfig(NameDef.CFG_RES_LIBRARY) as String;
			str = str.replace("{working_dir}", dir);
			_resLibraryWnd.configFile = str;
		}
		
		public function getGlobalConfig(key:String):Object {
			return _global_config[key];
		}
		
		private function createMenuBar(xmlData:XMLList):void {
			// this function will be called before menubar shown
			var menuShowHandler:Function = function(evt:MenuEvent):void {
				menuBarXml.item.(@event=="mce_view_res_wnd").@toggled = _resLibraryWnd.isPopup;
			};
			
			var menuClickHandler:Function = function(evt:DataEvent):void {
				var key:String = evt.data.@["event"];
				switch(key) {
					case "mce_view":
						break;
				}
			};
			
			var menuItemClickHandler:Function = function(evt:DataEvent):void {
				var key:String = evt.data.@["event"];
				switch(key) {
					case "mce_switch_workspcae":
						menuTriggerSwitchWorkspace();
						break;
					
					case "mce_view_res_wnd":
						toggleWindowPopup(_resLibraryWnd);
						break;
					
					case "mce_view_property_wnd":
						break;
				}
			};
			
			if(menuBar) {
				menuBar.dataProvider = xmlData;
				menuBar.labelField = "@label";
				menuBar.iconField = "@icon";
				menuBar.addEventListener(EventDef.MENU_CLICK, menuClickHandler);
				menuBar.addEventListener(EventDef.MENU_ITEM_CLICK, menuItemClickHandler);
				menuBar.addEventListener(MenuEvent.MENU_SHOW, menuShowHandler);
			}
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
		private function menuTriggerSwitchWorkspace():void {
			var dlg:SetWoringDirDlg = new SetWoringDirDlg();
			PopupMgr.getInstance().popupWindow(dlg);
		}
		private function quitHandler(evt:Event):void {
		}
		
		private var mainWndContextMenu:Object = {"type":"check", "label":NameDef.WND_RES_LIBRARY, "toggled":true, "handler":toggleWindowPopup}; 
		private var appContextMenuData:Array = [
			mainWndContextMenu,
			{"type":"separator"}
		];
		
		override protected function initContextMenuData():void {
			mainWndContextMenu["param"] = _resLibraryWnd;
			contextMenuInfos[this] = {"menuitems":appContextMenuData, "before_handler":appBeforeContextMenuHandler, "onhide":appHideContextMenuHandler};
		}
		
		protected function appBeforeContextMenuHandler(event:* = null):void {
			mainWndContextMenu["toggled"] = _resLibraryWnd.isPopup;
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
		
		public function get menuBar():CustomMenuBar {
			return (this.skin as CustomAppSkin).menuBar;
		}
		
		public function get statusMessage():Label {
			return (this.skin as CustomAppSkin).information;
		}
		
		public function get cursorMessage():Label {
			return (this.skin as CustomAppSkin).cursor;
		}
	}
}