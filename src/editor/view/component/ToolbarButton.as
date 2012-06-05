package editor.view.component
{
	import editor.view.mxml.skin.ToolbarButtonSkin;
	
	import flash.events.MouseEvent;
	
	import mx.events.FlexEvent;
	
	import spark.components.supportClasses.SkinnableComponent;
	import spark.primitives.BitmapImage;
	
	[SkinState("up")]
	public class ToolbarButton extends SkinnableComponent
	{
		[SkinPart(required="true")]
		public var icon:BitmapImage;
		
		private var _isMouseDown:Boolean = false;
		private var _isMouseOver:Boolean = false;
		
		public var iconSource:String;
		
		// there is at most one button pressed which has the same group name 
		public var group:String;
		
		public function ToolbarButton()
		{
			super();
			this.setStyle("skinClass", ToolbarButtonSkin);
			this.setStyle("cornerRadius", 4);
			this.addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
			this.addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
			this.addEventListener(MouseEvent.CLICK, mouseClickHandler);
			this.addEventListener(FlexEvent.CREATION_COMPLETE, createCompleteHandler);
		}
		
		protected function createCompleteHandler(evt:FlexEvent):void {
			if(iconSource != null) {
				this.icon.source = iconSource;
			}
		}
		
//		override protected function partAdded(partName:String, instance:Object):void {
//		}
//		
//		override protected function partRemoved(partName:String, instance:Object):void {
//		}
		
		private function mouseOverHandler(evt:MouseEvent):void {
			if(enabled) {
				_isMouseOver = true;
				invalidateSkinState();
			}
		}
		
		private function mouseOutHandler(evt:MouseEvent):void {
			if(enabled) {
				_isMouseOver = false;
				invalidateSkinState();
			}
		}
		
		private function mouseClickHandler(evt:MouseEvent):void {
			if(enabled) {
				pressed = !_isMouseDown;
			}
		}
		
		override protected function getCurrentSkinState():String
		{
			if(!enabled)
				return "disabled";
			return (_isMouseDown ? "down" : "up") + (_isMouseOver ? "_over" : "");
		}
		
		public function set pressed(val:Boolean):void {
			if(_isMouseDown != val) {
				_isMouseDown = val;
				invalidateSkinState();
			}
		}
		
		public function get pressed():Boolean {
			return _isMouseDown;
		}
	}
}