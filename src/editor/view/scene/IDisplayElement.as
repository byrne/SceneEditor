package editor.view.scene
{
	import flash.geom.Point;

	public interface IDisplayElement
	{
		function get scenePos():Point;
		function set scenePos(pos:Point):void;
		
		function get vo():Object;
		
		function set layer(v:String):void;
		function get layer():String;
		
		function doAddToSceneJod():void;
		function doRemoveFromSceneJob():void;
	}
}