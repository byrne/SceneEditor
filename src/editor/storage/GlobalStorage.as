package editor.storage
{
	import editor.constant.NameDef;
	import editor.utils.storage.SharedObjectStorage;
	
	public class GlobalStorage extends SharedObjectStorage
	{
		private static const NAME:String = NameDef.STORAGE_GLOBAL;
		private static const VERSION:Number = 0.11;
		
		private static var _instance:GlobalStorage; 
		
		public var working_dir:String = "";
		
		public function GlobalStorage()
		{
			super(NAME, VERSION);
		}
		
		public static function getInstance():GlobalStorage {
			if(_instance == null)
				_instance = new GlobalStorage();
			return _instance;
		}
		
		override protected function doRead(data:Object):void {
			working_dir = data.working_dir;
		}
		
		override protected function doSave(data:Object):void {
			data.working_dir = working_dir;
		}
	}
}