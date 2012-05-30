package editor.view.window
{
	import editor.view.component.MainCanvas;
	
	import flash.display.NativeMenu;
	import flash.display.NativeMenuItem;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.containers.Canvas;
	import mx.containers.DividedBox;
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
			
			this.addElement(dividedBox);
		}
		
		protected function addToStageHandler(evt:Event):void {

		}
	}
}