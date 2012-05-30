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
			super(100, 100);
			this.gridOn = false;
		}
	}
}