package editor.view
{
	import mx.events.CloseEvent;

	public interface IPopup
	{
		function get isPopup():Boolean;
		
		function set isPopup(val:Boolean):void;
		
		function get needModal():Boolean;
		
		function onPopup():void;
		
		function onClose(evt:CloseEvent=null):void;
	}
}