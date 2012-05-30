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
	
	public class MainWindow extends Canvas
	{
		public var sceneCanvas:MainCanvas;
		
		public var tabMenu:TabNavigator;
		
		public function MainWindow()
		{
			super();
			this.addEventListener(FlexEvent.CREATION_COMPLETE, createCompleteHandler);
			this.addEventListener(Event.ADDED_TO_STAGE, addToStageHandler);
		}
		
		private function createCompleteHandler(evt:Event):void {
			trace("ccc "+this.sceneCanvas);
		}
		
		protected function addToStageHandler(evt:Event):void {

		}
	}
}