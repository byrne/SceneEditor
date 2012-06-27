package editor
{
	import editor.constant.EventDef;
	import editor.constant.NameDef;
	import editor.constant.ScreenDef;
	import editor.dataeditor.DataEditorFactory;
	import editor.dataeditor.IElement;
	import editor.dataeditor.impl.EditorBase;
	import editor.datatype.impl.DataTypeFactory;
	import editor.datatype.impl.parser.xml.XMLDataParser;
	import editor.datatype.type.IDataType;
	import editor.event.DataEvent;
	import editor.mgr.PopupMgr;
	import editor.storage.GlobalStorage;
	import editor.utils.FileSerializer;
	import editor.utils.LogUtil;
	import editor.utils.StringUtil;
	import editor.utils.XMLSerializer;
	import editor.utils.keyboard.KeyBoardMgr;
	import editor.view.IPopup;
	import editor.view.component.CustomMenuBar;
	import editor.view.component.dialog.SetWoringDirDlg;
	import editor.view.component.window.MainWindow;
	import editor.view.component.window.ResLibraryWindow;
	import editor.view.component.window.TitleWindowBase;
	import editor.view.mxml.skin.CustomAppSkin;
	import editor.vo.ContextMenuData;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import mx.core.FlexGlobals;
	import mx.core.IFlexDisplayObject;
	import mx.core.IVisualElement;
	import mx.events.CloseEvent;
	import mx.events.FlexEvent;
	import mx.events.MenuEvent;
	import mx.managers.PopUpManager;
	
	import spark.components.Label;
	import spark.components.TitleWindow;

	
	public class SceneEditorApp extends WindowedApplicationBase
	{
		public var working_dir:String;
		public var proj_dir:String;
		
		public var mainWnd:MainWindow;
		public var resLibraryWnd:ResLibraryWindow;
		
		private var _global_config:Object;
		
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
			KeyBoardMgr.initialize(this);
//			this.stage.nativeWindow.menu = createMenuBar();
			createMenuBar(menuBarXml);
			mainWnd = new MainWindow();
			this.addElement(mainWnd);
			
			resLibraryWnd = new ResLibraryWindow();
			resLibraryWnd.width = ScreenDef.RESLIBRARY_W;
			resLibraryWnd.height = ScreenDef.RESLIBRARY_H;
			
			var hasStorage:Boolean = GlobalStorage.getInstance().read();
			if(!hasStorage) {
				menuTriggerSwitchWorkspace();
			} else {
				switchWorkspace(GlobalStorage.getInstance().working_dir);
			}
			
			statusMessage.text = "";
			prepareContextMenu();
			
			dataTypeTest();
			super.app_creationCompleteHandler(event);
		}
		
		/**
		 * 演示方法，随便删 
		 */
		public function dataTypeTest():void {
			var typeXML:XML = XML(FileSerializer.readFromFile(working_dir+"/sample-templates.xml"));
			var editorXML:XML = XML(FileSerializer.readFromFile(working_dir+"/sample-editor.xml"));
			DataTypeFactory.INSTANCE.initDB(typeXML);
			DataEditorFactory.INSTANCE.initTable(editorXML, DataTypeFactory.INSTANCE.dataContext);
			var a:IDataType = DataTypeFactory.INSTANCE.dataContext['NPC'];
			var carl:Object = a.construct();
			var ed:EditorBase = DataEditorFactory.INSTANCE.getEditor('SimpleNPCEditor');
			var view:IElement = ed.buildView(carl);
			var window:TitleWindow = new TitleWindow(); 
			var dataXML:XML;
			window.addElement(view as IVisualElement);
			window.addEventListener(CloseEvent.CLOSE, function(e:Event):void {
				dataXML = XMLDataParser.toXML(carl);
				PopUpManager.removePopUp(e.target as IFlexDisplayObject);
				var clone:* = XMLDataParser.fromXML(dataXML, DataTypeFactory.INSTANCE.dataContext);
			});
			PopUpManager.addPopUp(window as IFlexDisplayObject, FlexGlobals.topLevelApplication as DisplayObject, true);
			PopUpManager.centerPopUp(window as IFlexDisplayObject);
		}
		
		public function switchWorkspace(dir:String):void {
			_global_config = FileSerializer.readJsonFile(StringUtil.substitute("{0}/editor_config.json", dir));
			if(_global_config == null) {
				return;	
			}
			if(working_dir != dir) {
				// first close and destroy current workspace
				resLibraryWnd.onClose();
				mainWnd.onClose();
				
				// rebuild view
				working_dir = dir;
				proj_dir = replaceWorkingDir(getGlobalConfig(NameDef.CFG_PROJ_DIR) as String);
				resLibraryWnd.configFile = getGlobalConfig(NameDef.CFG_RES_LIBRARY) as String;
				
//				var viewStruct:XML = XML(FileSerializer.readFromFile(getGlobalConfig(NameDef.CFG_PROJ_VIEW_STRUCTURE) as String));
				var viewStruct:Object = XMLSerializer.readObjectFromXMLFile(getGlobalConfig(NameDef.CFG_PROJ_VIEW_STRUCTURE) as String);
				mainWnd.buildSceneList(viewStruct);
				KeyBoardMgr.focusTarget = mainWnd;
			}
		}
		
		public function getGlobalConfig(key:String):Object {
			var ret:* = _global_config[key];
			if(ret is String && working_dir != null) {
				ret = replaceWorkingDir(ret);
			}
			return ret;
		}
		
		
		private function createMenuBar(xmlData:XMLList):void {
			// this function will be called before menubar shown
			var menuShowHandler:Function = function(evt:MenuEvent):void {
				menuBarXml.item.(@event=="mce_view_res_wnd").@toggled = resLibraryWnd.isPopup;
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
						toggleWindowPopup(resLibraryWnd);
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
		
		private var resLibraryMenuItem:Object = {"type":"check", "label":NameDef.WND_RES_LIBRARY, "toggled":true, "handler":toggleWindowPopup}; 
		private function prepareContextMenu():void {
			resLibraryMenuItem["param"] = [resLibraryWnd];
			var menuData:ContextMenuData = new ContextMenuData();
			menuData.menuItems = mainWndMenuData;
			menuData.beforeHandler = appBeforeContextMenuHandler;
			menuData.hideHandler = appHideContextMenuHandler;
			this.registerContextMenu(mainWnd, menuData);
		}
		private var mainWndMenuData:Array = [
			resLibraryMenuItem
		];
		
		protected function appBeforeContextMenuHandler(event:* = null):void {
			resLibraryMenuItem["toggled"] = resLibraryWnd.isPopup;
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
		
		public function replaceWorkingDir(strin:String):String {
			if(working_dir)
				return strin.replace("{working_dir}", working_dir);
			else {
				LogUtil.error("working dir not initialized!");
				return strin;
			}
		}
		
		public function replaceProjDir(strin:String):String {
			if(proj_dir)
				return strin.replace("{proj_dir}", proj_dir);
			else {
				LogUtil.error("project dir not initialized!");
				return strin;
			}
		}

	}
}
