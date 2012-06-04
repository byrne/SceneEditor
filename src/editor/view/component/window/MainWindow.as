package editor.view.component.window
{
	import editor.constant.EventDef;
	import editor.event.DataEvent;
	import editor.view.component.Toolbar;
	import editor.view.component.ToolbarButton;
	import editor.view.component.canvas.MainCanvas;
	import editor.view.mxml.skin.ToolbarSkin;
	
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
			
			var toolbar:Toolbar = new Toolbar();
			toolbar.width = 36;
			toolbar.percentHeight = 100;
			toolbar.addEventListener(EventDef.TOOLBAR_BUTTON_CLICK, toolbarBtnClickHandler);
//			var btn:ToolbarButton;
//			var iconResNames:Array = ["vect.png", "move.png", "text.png", "scale.png", "icon.PNG"];
//			for each(var iconRes:String in iconResNames) {
//				btn = new ToolbarButton();
//				btn.iconSource = iconRes;
//				toolbar.addIcon(btn);
//			}
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
			var btn:ToolbarButton = evt.data as ToolbarButton;
			trace("cc: "+btn.id);
		}
		
		protected function addToStageHandler(evt:Event):void {

		}
	}
}