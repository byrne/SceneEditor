package editor.view.scene
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	import spark.primitives.Rect;
	
	public class Indicator extends Sprite
	{
		private var _showAxis:Boolean;
		
		private var _showSelector:Boolean;
		
		private var _showBoundBox:Boolean;
		
		private var _aabb:Rectangle;
		
		
		public function Indicator()
		{
			super();
		}
		
		public function set boundBox(rect:Rectangle):void {
			_aabb = rect;
			refresh();
		}
		
		private function refresh():void {
			var g:Graphics = this.graphics;
			g.clear();
			if(_showAxis) {
				g.lineStyle(1, 0xff0000, 0.3);
				g.moveTo(-20, 0);
				g.lineTo(20, 0);
				g.lineStyle(1, 0x00ff00, 0.8);
				g.moveTo(0, -20);
				g.lineTo(0, 20);
			}
			
			if(_aabb != null) {
				if(_showSelector) {
					var len:int = Math.min(_aabb.width/4, _aabb.height/4);
					len = Math.min(len, 20);
					g.lineStyle(2, 0xffff00, 0.7);
					g.moveTo(_aabb.left, _aabb.top);
					g.lineTo(_aabb.left+len, _aabb.top);
					g.moveTo(_aabb.right-len, _aabb.top);
					g.lineTo(_aabb.right, _aabb.top);
					g.lineTo(_aabb.right, _aabb.top+len);
					g.moveTo(_aabb.right, _aabb.bottom - len);
					g.lineTo(_aabb.right, _aabb.bottom);
					g.lineTo(_aabb.right-len, _aabb.bottom);
					g.moveTo(_aabb.left+len, _aabb.bottom);
					g.lineTo(_aabb.left, _aabb.bottom);
					g.lineTo(_aabb.left, _aabb.bottom-len);
					g.moveTo(_aabb.left, _aabb.top+len);
					g.lineTo(_aabb.left, _aabb.top);
				} else if(_showBoundBox) {
					g.lineStyle(1, 0x00ff00, 0.5);
					g.moveTo(_aabb.left, _aabb.top);
					g.lineTo(_aabb.right, _aabb.top);
					g.lineTo(_aabb.right, _aabb.bottom);
					g.lineTo(_aabb.left, _aabb.bottom);
					g.lineTo(_aabb.left, _aabb.top);			
				}
			}
		}
		
		public function get showAxis():Boolean { return _showAxis; }
		public function set showAxis(val:Boolean):void {
			_showAxis = val;
			refresh();
		}
		
		public function get showSelector():Boolean { return _showSelector; }
		public function set showSelector(val:Boolean):void {
			_showSelector = val;
			refresh();
		}
		
		public function get showBoundBox():Boolean { return _showBoundBox; }
		public function set showBoundBox(val:Boolean):void {
			_showBoundBox = val;
			refresh();
		}
	}
}