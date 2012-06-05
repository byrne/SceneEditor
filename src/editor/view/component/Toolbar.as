package editor.view.component
{
	import editor.constant.EventDef;
	import editor.event.DataEvent;
	import editor.view.mxml.skin.ToolbarSkin;
	
	import flash.events.MouseEvent;
	
	import mx.events.FlexEvent;
	
	import spark.components.VGroup;
	import spark.components.supportClasses.SkinnableComponent;
	
	public class Toolbar extends SkinnableComponent
	{
		[SkinPart(required="true")]
		public var iconsDisplay:VGroup;
		
		public function Toolbar()
		{
			super();
			this.setStyle("skinClass", ToolbarSkin);
			this.setStyle("backgroundColor", 0xffffff);
			this.addEventListener(FlexEvent.CREATION_COMPLETE, createCompleteHandler);
		}
		
		protected function createCompleteHandler(evt:FlexEvent):void {
			iconsDo(function(btn:ToolbarButton):void {
				btn.addEventListener(MouseEvent.CLICK, btnClickHandler);
			});
//			var btn:ToolbarButton;
//			var childNum:int = iconsDisplay.numChildren;
//			for(var i:int=0; i<childNum; i++) {
//				btn = iconsDisplay.getChildAt(i) as ToolbarButton;
//				if(btn) {
//					btn.addEventListener(MouseEvent.CLICK, btnClickHandler);
//				}
//			}
		}
		
		private function btnClickHandler(evt:MouseEvent):void {
			var btn:ToolbarButton = evt.currentTarget as ToolbarButton;
			if(btn && btn.enabled) {
				this.dispatchEvent(new DataEvent(EventDef.TOOLBAR_BUTTON_CLICK, btn));
			}
		}
		
		public function iconsDo(func:Function):void {
			var btn:ToolbarButton;
			var childNum:int = iconsDisplay.numChildren;
			for(var i:int=0; i<childNum; i++) {
				btn = iconsDisplay.getChildAt(i) as ToolbarButton;
				if(btn) {
					func.call(null, btn);
				}
			}
		}
		
//		public function addIcon(icon:ToolbarButton):void {
//			iconsDisplay.addElement(icon);
//		}
		
	}
}