package editor.view.component
{
	import editor.utils.LogUtil;
	
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	
	public class PreviewCanvas extends UIComponent
	{
		private var axisXbase:int;
		private var axisYbase:int;
		private var xBase:int;
		private var yBase:int;
		
		protected var items:Array = [];
		
		public var gridPrecision:int = 10; // in pixles
		public var gridOn:Boolean = true;
		
		private var maskSprite:Sprite;
		
		public function PreviewCanvas(axisXBase:int = 0, axisYBase:int = 0)
		{
			super();
			this.axisXbase = axisXBase
			this.axisYbase = axisYBase
			this.setStyle("backgroundColor" , 0xdddddd);
			this.addEventListener(FlexEvent.CREATION_COMPLETE, createCompleteHandler);
			this.addEventListener(Event.ADDED_TO_STAGE, addToStageHandler);
			maskSprite = new Sprite();
			this.addChild(maskSprite);
			this.mask = maskSprite;
		}
		
		protected function createCompleteHandler(evt:FlexEvent):void {
			
		}
		
		protected function addToStageHandler(evt:Event):void {
			this.addEventListener(MouseEvent.MOUSE_DOWN, function(evt:Event) {
				startDrag();
			});
			this.addEventListener(MouseEvent.MOUSE_UP, function(evt:Event) {
				stopDrag();
				updateBackground();
			});
			this.addEventListener(MouseEvent.MOUSE_MOVE, function(evt:Event) {
				updateBackground();
			});
		}
		
//		override protected function invalidateParentSizeAndDisplayList():void {
//			LogUtil.debug("invalidateParentSizeAndDisplayList");
//		}
//		
//		override protected function measure():void {
//			LogUtil.debug("measure");
//		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			LogUtil.debug("updateDisplayList");
			xBase = x;
			yBase = y;
			this.updateBackground();
			super.updateDisplayList(unscaledWidth, unscaledHeight);
		}
		
		protected function updateBackground():void {
			this.graphics.clear();
			this.graphics.beginFill(0);
			
			var offsetX:int = x - xBase;
			var offsetY:int = y - yBase;
//			LogUtil.debug("x:{0}, y:{1}, w:{2}, h:{3}, offsetX:{4}, offsetY:{5}", this.x, this.y, this.width, this.height, offsetX, offsetY);
			
			// draw mask
			if(maskSprite) {
				maskSprite.graphics.clear();
				maskSprite.graphics.beginFill(0xff0000, 0.5);
				maskSprite.graphics.drawRect(-offsetX, -offsetY, width, height);
				maskSprite.graphics.endFill();
			}
			
			// axis XY base
			this.graphics.lineStyle(2, 0);
			this.graphics.moveTo(-offsetX, axisYbase-1);
			this.graphics.lineTo(width-offsetX, axisYbase-1);
			this.graphics.moveTo(axisXbase-1, -offsetY);
			this.graphics.lineTo(axisXbase-1, height-offsetY);
			
			// grid
			this.graphics.lineStyle(1, 0.5);
			var tmp:int;
			if(gridOn) {
				tmp = gridPrecision;
				while(axisYbase-tmp+offsetY>=0) {
					this.graphics.moveTo(-offsetX, axisYbase-tmp);
					this.graphics.lineTo(width-offsetX, axisYbase-tmp);
					tmp += gridPrecision;
				}
				tmp = gridPrecision;
				while(axisYbase+tmp+offsetY<=height) {
					this.graphics.moveTo(-offsetX, axisYbase+tmp);
					this.graphics.lineTo(width-offsetX, axisYbase+tmp);
					tmp += gridPrecision;
				}
				tmp = gridPrecision;
				while(axisXbase-tmp+offsetX>=0) {
					this.graphics.moveTo(axisXbase-tmp, -offsetY);
					this.graphics.lineTo(axisXbase-tmp, height-offsetY);
					tmp += gridPrecision;
				}
				tmp = gridPrecision;
				while(axisXbase+tmp+offsetX<=width) {
					this.graphics.moveTo(axisXbase+tmp, -offsetY);
					this.graphics.lineTo(axisXbase+tmp, height-offsetY);
					tmp += gridPrecision;
				}
			}
			
			this.graphics.endFill();
		}
		
		public function addItem(obj:DisplayObject, x:int=0, y:int=0):void {
			if(!hasItem(obj)) {
				this.addChild(obj);
				items.push(obj);
			}
			obj.x = axisXbase + x;
			obj.y = axisYbase + y;
		}
		
		public function hasItem(obj:DisplayObject):Boolean {
			return items.indexOf(obj) >=0;
		}
		
		public function removeItem(obj:DisplayObject):Boolean {
			var itemIndex:int = items.indexOf(obj);
			if(itemIndex >= 0) {
				this.removeChild(obj);
				items.splice(itemIndex, 1);
				return true;
			}
			return false;
		}
		
		public function removeAllItems():void {
			for each(var obj:DisplayObject in items) {
				removeItem(obj);
			}
		}
	}
}