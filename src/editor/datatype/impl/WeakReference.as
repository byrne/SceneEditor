package editor.datatype.impl
{
	import flash.utils.Dictionary;

	public class WeakReference
	{
		private var reference:Dictionary = new Dictionary(true);
		
		public function WeakReference(object:Object) {
			reference[object] = null;
		}
		
		public function get object():Object {
			for (var object:Object in reference)
				return object;
			
			return null;
		}
	}
}