package editor.view.ui.window
{
	import editor.view.ui.MainCanvas;
	
	import flash.display.NativeMenu;
	import flash.display.NativeMenuItem;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.containers.Canvas;
	import mx.controls.MenuBar;
	import mx.events.DragEvent;
	import mx.events.FlexEvent;
	
	public class MainWindow extends Canvas
	{
		private var _menuData:Array = [
			["File", [["Open", "O", fileOpenHandler],["Save", "S"],[],["Quit", "Q"]]],
			["View", [["Open", "O"],["Save", "S"],["Quit", "Q"]]],
			["About", [["Open", "O"],["Save", "S"],["Quit", "Q"]]]
		]
		private var _mainCanvas:MainCanvas;
		
		public function MainWindow()
		{
			super();
			this.addEventListener(FlexEvent.CREATION_COMPLETE, createCompleteHandler);
			this.addEventListener(Event.ADDED_TO_STAGE, addToStageHandler);
		}
		
		private function createCompleteHandler(evt:Event):void {
			_mainCanvas = new MainCanvas();
			this.addChild(_mainCanvas);
		}
		
		protected function addToStageHandler(evt:Event):void {
			this.stage.nativeWindow.menu = createMenuBar();
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
		
		private function fileOpenHandler(evt:Event):void {
		}
	}
}