package editor.event
{
	import flash.events.Event;
	
	public class DataEvent extends Event
	{
		public var data:Object;
		
		public function DataEvent(type:String, data:Object, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			this.data = data;
			super(type, bubbles, cancelable);
		}
	}
}