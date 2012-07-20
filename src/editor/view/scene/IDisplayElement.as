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
		function set lock(v:Boolean):void;
		function get lock():Boolean;
		
		function doAddToSceneJod():void;
		function doRemoveFromSceneJob():void;
		
		function get x():Number;
		function set x(v:Number):void;
		function get y():Number;
		function set y(v:Number):void;
		function get width():Number;
		function set width(v:Number):void;
		function get height():Number;
		function set height(v:Number):void;
		function get visible():Boolean;
		function set visible(v:Boolean):void;
	}
}