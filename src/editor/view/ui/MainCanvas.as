package editor.view.ui
{
	import editor.constant.ScreenDef;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.containers.Canvas;
	
	import spark.components.Label;
	
	public class MainCanvas extends Canvas
	{
		private var _fieldW:int;
		private var _fieldH:int;
		
		public function MainCanvas(w:int=ScreenDef.DEFAULT_CANVAS_W, h:int=ScreenDef.DEFAULT_CANVAS_H)
		{
			super();
			_fieldW = w;
			_fieldH = h;
			this.setStyle("backgroundColor" , 0xdddddd);
			this.addEventListener(Event.ADDED_TO_STAGE, addToStageHandler);
		}
		
		protected function addToStageHandler(evt:Event):void {
			this.addEventListener(MouseEvent.MOUSE_DOWN, function(evt:Event) {
				startDrag()}
			);
			this.addEventListener(MouseEvent.MOUSE_UP, function(evt:Event) {
				stopDrag()}
			);
//			graphics.beginFill(0x333333, 0.5);
//			graphics.drawRect(0, 0, _fieldW, _fieldH);
//			graphics.endFill();
//			var label:Label = new Label();
//			label.text = "ABCDEFG";
//			this.addChild(label);
		}
	}
}