package editor.datatype.data
{
	import editor.mgr.SceneDataMemory;

	public class Reference
	{
		public static var MEM:SceneDataMemory;
		
		public function get key():String { return _key; }
		private var _key:String;
		
		private var types:Array = [];
		
		public function Reference(key:String = null, types:Array = null) {
			_key = key;
			this.types = types ? types : [];
		}
		
		public function dereference():ComposedData {
			return MEM.getEntity(key);
		}
		
		/**
		 * <b>WARNING:</b> Can only be assigned a value once. 
		 * @param v
		 */
		public function set key(v:String):void {
			if(_key != null)
				throw new Error("Reference is read-only. Violated property: key");
			_key = v;
		}
	}
}