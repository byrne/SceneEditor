package editor.view.window
{
	import editor.constant.NameDef;
	import editor.utils.CommonUtil;
	import editor.utils.FileSerializer;
	
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	import mx.containers.Canvas;
	import mx.containers.DividedBox;
	import mx.containers.TabNavigator;

	public class ResLibraryWindow extends TitleWindowBase
	{
		private var baseDir:String;
		
		private var symbolClasses:Dictionary;
		
		public function ResLibraryWindow(configFile:String)
		{
			super(NameDef.WND_RES_LIBRARY);
			var allRes:Object = FileSerializer.readJsonFile(configFile);
			baseDir = allRes["base_dir"];
			symbolClasses = CommonUtil.objectToDictionary(allRes["symbol_classes"]);
		}
		
		override protected function createCompleteHandler(evt:Event):void {
			super.createCompleteHandler(evt);
			
			var dividedBox:DividedBox = new DividedBox();
			dividedBox.direction = "horizontal";
			dividedBox.percentWidth = 100;
			dividedBox.percentHeight = 100;
			
			var tab:TabNavigator = new TabNavigator();
			tab.percentWidth = 20;
			tab.percentHeight = 100;
			dividedBox.addElement(tab);
			var can:Canvas = new Canvas();
			can.percentWidth = 80;
			can.percentHeight = 100;
			dividedBox.addElement(can);
			
			this.addElement(dividedBox);
		}
	}
}