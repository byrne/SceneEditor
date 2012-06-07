package editor.view.component.window
{
	import editor.EditorGlobal;
	import editor.constant.EventDef;
	import editor.constant.NameDef;
	import editor.event.DataEvent;
	import editor.utils.LogUtil;
	import editor.view.component.Toolbar;
	import editor.view.component.ToolbarButton;
	import editor.view.component.canvas.MainCanvas;
	import editor.view.mxml.skin.ToolbarSkin;
	import editor.view.scene.EntityBaseView;
	
	import flash.display.NativeMenu;
	import flash.display.NativeMenuItem;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.containers.Canvas;
	import mx.containers.DividedBox;
	import mx.containers.HBox;
	import mx.containers.TabNavigator;
	import mx.containers.VBox;
	import mx.controls.MenuBar;
	import mx.events.DragEvent;
	import mx.events.FlexEvent;
	
	import spark.components.NavigatorContent;
	
	public class MainWindow extends Canvas
	{
		private var sceneCanvas:MainCanvas;
		
		private var tabMenu:TabNavigator;
		
		private var tabSceneList:NavigatorContent;
		private var tabSceneEntities:NavigatorContent;
		
		private var toolbar:Toolbar;
		
		private var operateMode:String;
		
		public function MainWindow()
		{
			super();
			this.addEventListener(FlexEvent.CREATION_COMPLETE, createCompleteHandler);
			this.addEventListener(Event.ADDED_TO_STAGE, addToStageHandler);
			this.percentWidth = 100;
			this.percentHeight = 100;
		}
		
		private function createCompleteHandler(evt:Event):void {
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
			
			sceneCanvas = new MainCanvas();
			sceneCanvas.percentWidth = 85;
			sceneCanvas.percentHeight = 100;
			dividedBox.addElement(sceneCanvas);
			
			tabMenu = new TabNavigator();
			tabMenu.percentWidth = 15;
			tabMenu.percentHeight = 100;
			dividedBox.addElement(tabMenu);
			tabSceneList = new NavigatorContent();
			tabSceneList.label = "场景列表";
			tabMenu.addItem(tabSceneList);
			tabSceneEntities = new NavigatorContent();
			tabSceneEntities.label = "场景物件";
			tabMenu.addItem(tabSceneEntities);
			hbox.addElement(dividedBox);
			
			this.addElement(hbox);
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
					var testEntities:Array = ["win.swf", "idle.swf", "lose.swf", "dodge.swf", "attack_prepare.swf", "hurt.swf"];
					var randIndex:int = Math.random()*testEntities.length;
					var vo:Object = new Object();
					vo["res"] = EditorGlobal.APP.resLibraryWnd.baseDir + "/" + testEntities[randIndex];
					var enti:EntityBaseView = new EntityBaseView(vo);
					enti.canSelect = operateMode == NameDef.TBTN_SELECT;
					sceneCanvas.addItem(enti);
					sceneCanvas.setItemPos(enti, Math.random()* 800, Math.random()* 600);
					break;
			}
		}
		
		protected function addToStageHandler(evt:Event):void {

		}
	}
}