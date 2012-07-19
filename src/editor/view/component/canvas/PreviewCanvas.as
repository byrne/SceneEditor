package editor.view.component.canvas
{
	import editor.constant.NameDef;
	import editor.utils.LogUtil;
	import editor.view.scene.EntityBaseView;
	import editor.view.scene.IDisplayElement;
	import editor.vo.SceneLayer;
	
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	
	public class PreviewCanvas extends UIComponent
	{
		protected var axisXbase:int;
		protected var axisYbase:int;
		private var xBase:int;
		private var yBase:int;
		
		protected var items:Array = [];
		
		public var gridPrecision:int = 10; // in pixles
		public var gridOn:Boolean = true;
		
		private var maskSprite:Sprite;
		
		public var draggable:Boolean;
		
		private var _layers:Array;
		
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
			this.addEventListener(MouseEvent.MOUSE_DOWN, function(evt:Event):void {
				if(draggable)
					startDrag();
			});
			this.addEventListener(MouseEvent.MOUSE_UP, function(evt:Event):void {
				if(draggable) {
					stopDrag();
					updateBackground();
				}
			});
			this.addEventListener(MouseEvent.MOUSE_MOVE, function(evt:Event):void {
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
			xBase = x;
			yBase = y;
			this.updateBackground();
			super.updateDisplayList(unscaledWidth, unscaledHeight);
		}
		
		protected function updateBackground():void {
			this.graphics.clear();
			
			var offsetX:int = x - xBase;
			var offsetY:int = y - yBase;
//			LogUtil.debug("x:{0}, y:{1}, w:{2}, h:{3}, offsetX:{4}, offsetY:{5}", this.x, this.y, this.width, this.height, offsetX, offsetY);

			
			this.graphics.beginFill(0xdddddd, 1);
			this.graphics.drawRect(-offsetX, -offsetY, width, height);
			// draw mask
			if(maskSprite) {
				maskSprite.graphics.clear();
				maskSprite.graphics.beginFill(0xff0000);
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
		
		public function itemsDo(func:Function):void {
			var obj:IDisplayElement;
			for each(obj in items) {
				func.call(null, obj);
			}
		}
		
		public function entitiesDo(func:Function):void {
			var obj:IDisplayElement;
			for each(obj in items) {
				func.call(null, obj as IDisplayElement);
			}
		}
		
		public function addItem(obj:IDisplayElement, x:int=0, y:int=0):void {
			if(!hasItem(obj)) {
				this.addChild(obj as DisplayObject);
				items.push(obj);
				obj.doAddToSceneJod();
			}
			setItemPos(obj, x, y);
		}
		
		public function setItemPos(obj:IDisplayElement, x:int, y:int):void {
			if(!hasItem(obj))
				return;
			(obj as DisplayObject).x = axisXbase + x;
			(obj as DisplayObject).y = axisYbase + y;
			if(obj is EntityBaseView)
				(obj as EntityBaseView).syncDataFromView();
		}
		
		public function getItemPos(obj:IDisplayElement):Point {
			if(!hasItem(obj))
				return null;
			return new Point((obj as DisplayObject).x - axisXbase, (obj as DisplayObject).y - axisYbase);
		}
		
		public function hasItem(obj:IDisplayElement):Boolean {
			return items.indexOf(obj) >=0;
		}
		
		public function removeItem(obj:IDisplayElement):Boolean {
			var itemIndex:int = items.indexOf(obj);
			if(itemIndex >= 0) {
				this.removeChild(obj as DisplayObject);
				items.splice(itemIndex, 1);
					obj.doRemoveFromSceneJob();
				return true;
			}
			return false;
		}
		
		public function removeAllItems():void {
			while(items.length > 0) {
				removeItem(items[0] as IDisplayElement);
			}
		}
		
		public function clearView():void {
			removeAllItems();
			_layers = null;
		}
		
		public function setItemLayer(obj:IDisplayElement, layer:String):Boolean {
			if(!hasItem(obj))
				return false;
			this.setChildIndex(obj as DisplayObject, lastItemIndexWithLayer(layer)+1); 
			return true;
		}
		
		public function set layers(arr:Array):void {
			_layers = arr;
		}
		
		protected function layerName2Index(layerName:String):int {
			for(var i:int=0; i<_layers.length; i++) {
				if((_layers[i] as SceneLayer).keyword == layerName)
					return i;
			}
			return -1;
		}
		
		public function arrangeItem(obj:IDisplayElement, direction:int):void {
			if(!hasItem(obj))
				return;
			var objIndex:int = this.getChildIndex(obj as DisplayObject);
			var destIndex:int;
			var destObj:IDisplayElement;
			if(Math.abs(direction) == 1) {
				destIndex = objIndex + direction;
				destObj = destIndex<0 || destIndex>=this.numChildren ? null : this.getChildAt(destIndex) as IDisplayElement;
				if(destObj && destObj.layer == obj.layer) {
					this.setChildIndex(obj as DisplayObject, destIndex);
					LogUtil.debug("arrange item index, from {0}, to {1}", objIndex, destIndex);
				}
			} else if(Math.abs(direction) == 2) {
			}
		}
		
		private function lastItemIndexWithLayer(layerName:String):int {
			if(_layers == null || layerName == null)
				items.length - 1;
			var obj:IDisplayElement;
			for(var i:int=this.numChildren-1; i>=0; i--) {
				obj = items[i] as IDisplayElement;
				if(obj && obj.layer==layerName)
					return i;
			}
			return items.length - 1;
		}
	}
}