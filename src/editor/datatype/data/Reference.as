package editor.datatype.data
{
	import editor.mgr.SceneDataMemory;

	public class Reference
	{
		public var ref_key:String;
		public var ref_type:String;
		public var ref_target:ComposedData;
		
		public function Reference()
		{
		}
		
		public function dereference(mem:SceneDataMemory):ComposedData {
			return mem.getEntity(ref_key) as ComposedData;
		}
	}
}