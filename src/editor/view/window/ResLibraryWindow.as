package editor.view.window
{
	import editor.constant.NameDef;
	import editor.utils.CommonUtil;
	import editor.utils.FileSerializer;
	
	import flash.utils.Dictionary;

	public class ResLibraryWindow extends TitleWindowBase
	{
		private var baseDir:String;
		
		private var symbolClasses:Dictionary;
		
		public function ResLibraryWindow(configFile:String)
		{
			super(NameDef.WND_RES_LIBRARY);
			var allRes:Object = FileSerializer.readJsonFile(configFile);
			baseDir = allRes["base_dir"];
			symbolClasses = CommonUtil.objectToDictionary(allRes["symbol_classes"]);
		}
	}
}