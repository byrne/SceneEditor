package editor.view.component
{
	import editor.constant.ScreenDef;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.containers.Canvas;
	
	import spark.components.Label;
	
	public class MainCanvas extends PreviewCanvas
	{
		private var _fieldW:int;
		private var _fieldH:int;
		
		public function MainCanvas()
		{
			super();
			this.gridOn = false;
		}
		
//		protected function addToStageHandler(evt:Event):void {
//			
//			graphics.beginFill(0x333333, 0.5);
//			graphics.drawRect(0, 0, _fieldW, _fieldH);
//			graphics.endFill();
//			var label:Label = new Label();
//			label.text = "ABCDEFG";
//			this.addChild(label);
//		}
	}
}