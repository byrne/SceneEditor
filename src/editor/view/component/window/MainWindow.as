package editor.view.component.window
{
	import editor.EditorGlobal;
	import editor.constant.EventDef;
	import editor.constant.NameDef;
	import editor.datatype.ReservedName;
	import editor.datatype.impl.parser.xml.XMLDataParser;
	import editor.datatype.type.IDataType;
	import editor.event.DataEvent;
	import editor.utils.FileSerializer;
	import editor.utils.LogUtil;
	import editor.utils.keyboard.KeyBoardMgr;
	import editor.utils.keyboard.KeyShortcut;
	import editor.view.component.SceneEntitiesTree;
	import editor.view.component.SceneListTree;
	import editor.view.component.Toolbar;
	import editor.view.component.ToolbarButton;
	import editor.view.component.canvas.MainCanvas;
	import editor.view.component.widget.WgtPanel;
	import editor.view.scene.EntityBaseView;
	import editor.vo.Scene;
	import editor.vo.SceneTemplate;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	import mx.containers.Canvas;
	import mx.containers.DividedBox;
	import mx.containers.HBox;
	import mx.containers.TabNavigator;
	
	import spark.components.NavigatorContent;
	
	public class MainWindow extends Canvas
	{
		private var sceneCanvas:MainCanvas;
		
		private var tabMenu:TabNavigator;
		private var parameterPanel:WgtPanel;
		
		private var tabSceneList:NavigatorContent;
		private var sceneListTree:SceneListTree;
		private var tabSceneEntities:NavigatorContent;
		private var sceneEntitiesTree:SceneEntitiesTree;
		
		private var toolbar:Toolbar;
		
		private var operateMode:String;
		
		public var curScene:Scene;
		
		public function MainWindow()
		{
			super();
//			this.addEventListener(FlexEvent.CREATION_COMPLETE, createCompleteHandler);
			this.addEventListener(Event.ADDED_TO_STAGE, addToStageHandler);
			this.percentWidth = 100;
			this.percentHeight = 100;
			
			var hbox:HBox = new HBox();
			hbox.percentWidth = 100;
			hbox.percentHeight = 100;
			
			toolbar = new Toolbar();
			toolbar.width = 36;
			toolbar.percentHeight = 100;
			toolbar.addEventListener(EventDef.TOOLBAR_BUTTON_CLICK, toolbarBtnClickHandler);
			hbox.addElement(toolbar);
			
			var dividedBox:DividedBox = new DividedBox();
			dividedBox.direction = "horizontal";
			dividedBox.percentWidth = 100;
			dividedBox.percentHeight = 100;
			
			var vbox:DividedBox = new DividedBox();
			vbox.direction = "vertical";
			vbox.percentWidth = 85;
			vbox.percentHeight = 100;
			
			sceneCanvas = new MainCanvas();
			sceneCanvas.percentWidth = 100;
			sceneCanvas.percentHeight = 80;
			vbox.addElement(sceneCanvas);
			parameterPanel = new WgtPanel();
			parameterPanel.percentWidth = 100;
			parameterPanel.percentHeight = 20;
			vbox.addElement(parameterPanel);
			dividedBox.addElement(vbox);
			
			tabMenu = new TabNavigator();
			tabMenu.percentWidth = 15;
			tabMenu.percentHeight = 100;
			dividedBox.addElement(tabMenu);
			tabSceneList = new NavigatorContent();
			tabSceneList.label = "场景列表";
			sceneListTree = new SceneListTree();
			tabSceneList.addElement(sceneListTree);
			
			tabMenu.addItem(tabSceneList);
			tabSceneEntities = new NavigatorContent();
			tabSceneEntities.label = "场景物件";
			sceneEntitiesTree = new SceneEntitiesTree();
			tabSceneEntities.addElement(sceneEntitiesTree);
			tabMenu.addItem(tabSceneEntities);
			hbox.addElement(dividedBox);
			
			this.addElement(hbox);
			
			var keyShortcuts:Array = [];
			keyShortcuts.push(new KeyShortcut({"keyCode":Keyboard.S, "handler":mockToolbarbtnClick, "params":NameDef.TBTN_SELECT}));
			keyShortcuts.push(new KeyShortcut({"keyCode":Keyboard.M, "handler":mockToolbarbtnClick, "params":NameDef.TBTN_MOVE}));
			keyShortcuts.push(new KeyShortcut({"keyCode":Keyboard.T, "handler":mockToolbarbtnClick, "params":NameDef.TBTN_TEST}));
			KeyBoardMgr.registerKeyShortcuts(keyShortcuts, this);
		}
		
		private function mockToolbarbtnClick(btnName:String):void {
			var btn:ToolbarButton = this.toolbar.getBtnByName(btnName);
			btn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
		}
		
		private function toolbarBtnClickHandler(evt:DataEvent):void {
			var clickBtn:ToolbarButton = evt.data as ToolbarButton;
			LogUtil.debug("click button: {0}, pressed: {1}", clickBtn.id, clickBtn.pressed);
			if(clickBtn.pressed && clickBtn.group) {
				toolbar.iconsDo(function(btn:ToolbarButton):void {
					if(btn != clickBtn && btn.group == clickBtn.group)
						btn.pressed = false;
				});
				switchOperateMode(clickBtn.id);
			}
		}
		
		private function switchOperateMode(mode:String):void {
			var oldOperateMode:String = operateMode;
			operateMode = mode;
			sceneCanvas.entitiesDo(function(enti:EntityBaseView):void {
				enti.canSelect = operateMode == NameDef.TBTN_SELECT;
			});
			sceneCanvas.draggable = operateMode == NameDef.TBTN_MOVE;
			switch(operateMode) {
				case NameDef.TBTN_TEST:
					var testEntities:Array = [
						"idle.swf - saybotmc"
						,"lose.swf - saybotmc"
						,"test.swf - layers"
						,"test.swf - move"
						,"test.swf - saybotmc"
						,"test1/idle.swf - saybotmc"
						,"test1/win.swf - saybotmc"
						,"test2/idle.swf - saybotmc"
						,"test2/test3/lose.swf - saybotmc"
						,"test2/test3/win.swf - saybotmc"
						,"test2/win.swf - saybotmc"
						,"win.swf - saybotmc"
					];
					var randIndex:int = Math.random()*testEntities.length;
					var a:IDataType = EditorGlobal.DATA_MANAGER.types['NPC'];
					var npc:Object = a.construct();
					npc[ReservedName.RESOURCE] = testEntities[randIndex];
					var enti:EntityBaseView = new EntityBaseView(npc);
					enti.canSelect = operateMode == NameDef.TBTN_SELECT;
					sceneCanvas.addItem(enti);
					sceneCanvas.setItemPos(enti, Math.random()* 800, Math.random()* 600);
					break;
			}
		}
		
		protected function addToStageHandler(evt:Event):void {

		}
		
		public function onClose():void {
			sceneListTree.clearView();
			sceneEntitiesTree.clearView();
			if(parameterPanel.wgtLayers)
				parameterPanel.wgtLayers.clearView();
		}
		
		public function buildTabNavigateView():void {
			sceneListTree.refreshView();
		}
		
		public function openScene(st:SceneTemplate, fName:String):void {
			var data:XML = XML(FileSerializer.readFromFile(fName));
			var sceneData:Object = XMLDataParser.fromXML(data, EditorGlobal.DATA_MANAGER.types);
			curScene = new Scene(sceneData);
			parameterPanel.wgtLayers.initLayers(curScene);
			sceneEntitiesTree.refreshView(curScene);
			tabNavigateTo(1);
		}
		
		public function tabNavigateTo(index:int):void {
			tabMenu.selectedIndex = index;
		}
	}
}
