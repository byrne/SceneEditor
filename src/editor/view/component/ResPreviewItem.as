package editor.view.component
{
	import editor.view.scene.IDisplayElement;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	public class ResPreviewItem extends Sprite implements IDisplayElement
	{
		public function ResPreviewItem(content:DisplayObject)
		{
			super();
			this.addChild(content);
		}
		
		public function get scenePos():Point
		{
			return new Point(x, y);
		}
		
		public function set scenePos(pos:Point):void
		{
			x = pos.x;
			y = pos.y;
		}
		
		public function get vo():Object
		{
			return null;
		}
		
		public function set layer(v:String):void
		{
		}
		
		public function get layer():String
		{
			return null;
		}
		
		public function doAddToSceneJod():void
		{
		}
		
		public function doRemoveFromSceneJob():void
		{
		}
	}
}