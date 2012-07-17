package editor.datatype.data
{
	import editor.EditorGlobal;
	import editor.mgr.SceneDataMemory;

	public class Reference
	{
		public static var MEM:SceneDataMemory = EditorGlobal.DATA_MEMORY;
		
		public function get key():String { return _key; }
		private var _key:String;
		
		public function Reference(key:String = null) {
			_key = key;
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
		
		public function clone():Reference {
			return new Reference(key);
		}
	}
}