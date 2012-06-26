package editor.view.component
{
	import editor.EditorGlobal;
	import editor.constant.EventDef;
	import editor.constant.NameDef;
	import editor.event.DataEvent;
	import editor.utils.LogUtil;
	import editor.utils.StringUtil;
	
	import flash.filesystem.File;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Tree;
	import mx.events.ListEvent;
	import mx.utils.ObjectProxy;
	
	public class SceneListTree extends TreeBase
	{
		private var sceneTypesArr:ArrayCollection;
		private var filesBaseDir:String;
		
		public function SceneListTree()
		{
			super();
		}
		
		override public function clearView():void {
			sceneTypesArr = null;
			super.clearView();
		}
		
		override public function buildView(data:Object):void {
			sceneTypesArr = data["sceneType"] as ArrayCollection;
			filesBaseDir = data["baseDir"].value as String;
			var dataProvider:XML = <node/>;
			for each(var d:ObjectProxy in sceneTypesArr) {
				var xml:XML = <node/>;
				var sceneType:String = d.name;
				var dir:String = StringUtil.substitute("{0}/{1}/{2}", EditorGlobal.APP.working_dir, filesBaseDir, sceneType);
				xml.@label = sceneType;
				xml.@leaf = false;
				dataProvider.appendChild(xml);
				fetachDirectoyFiles(dir, xml);
			}
			this.dataProvider = dataProvider;
		}
		
		override protected function itemDoubleClickHandler(evt:DataEvent):void {
			var selectItem:XML = this.selectedItem as XML;
			if(selectItem.@leaf == true) {
				var fileName:String = StringUtil.substitute("{0}/{1}/{2}/{3}{4}", EditorGlobal.APP.working_dir
					, filesBaseDir
					, selectItem.@sceneType
					, selectItem.@label
					, NameDef.FILE_SUFFIX);
				LogUtil.info("open scene {0}", fileName);
				EditorGlobal.APP.statusMessage.text = fileName;
			}
		}
		
		private function fetachDirectoyFiles(dir:String, parentXML:XML):void {
			var file:File = new File(dir);
			if(!file.isDirectory)
				return;
			var arr:Array = file.getDirectoryListing();
			for each(var f:File in arr) {
				if(f.isDirectory)
					continue;
				if(f.name.indexOf(NameDef.FILE_SUFFIX) < 0)
					continue;
				
				var xml:XML = <node/>;
				xml.@label = f.name.substr(0, f.name.length - NameDef.FILE_SUFFIX.length);
				xml.@leaf = true;
				xml.@sceneType = parentXML.@label;
				parentXML.appendChild(xml);
			}
		}
	}
}