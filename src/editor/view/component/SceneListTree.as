package editor.view.component
{
	import editor.EditorGlobal;
	import editor.constant.EventDef;
	import editor.constant.NameDef;
	import editor.event.DataEvent;
	import editor.mgr.SceneDataMemory;
	import editor.utils.LogUtil;
	import editor.utils.StringUtil;
	import editor.vo.ContextMenuData;
	import editor.vo.SceneTemplate;
	
	import flash.filesystem.File;
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	import mx.collections.XMLListCollection;
	import mx.controls.Tree;
	import mx.events.ListEvent;
	import mx.utils.ObjectProxy;
	
	public class SceneListTree extends TreeBase
	{
		private var filesBaseDir:String;
		
		public function SceneListTree()
		{
			super();
			this.contextMenuEnabled = true;
		}
		
		override public function refreshView(data:Object=null):void {
			clearView();
			var sceneTemplates:Dictionary = EditorGlobal.DATA_MEMORY.sceneTemplates;
			filesBaseDir = EditorGlobal.APP.getGlobalConfig(NameDef.CFG_SCENE_FILES_DIR) as String;
			var dataProvider:ArrayCollection = new ArrayCollection();
			for each(var st:SceneTemplate in sceneTemplates) {
				var xml:XML = <node/>;
				var dir:String = StringUtil.substitute("{0}/{1}", filesBaseDir, st.name);
				xml.@label = st.name;
				xml.@leaf = false;
				dataProvider.addItem(xml);
				fetachDirectoyFiles(dir, xml);
			}
			this.dataProvider = dataProvider;
		}
		
		override protected function itemDoubleClickHandler(evt:ListEvent):void {
			var selectItem:XML = this.selectedItem as XML;
			if(selectItem && selectItem.@leaf == true) {
				var fileName:String = StringUtil.substitute("{0}/{1}/{2}{3}"
					, filesBaseDir
					, selectItem.@sceneType
					, selectItem.@label
					, NameDef.FILE_SUFFIX);
				LogUtil.info("open scene {0}", fileName);
				EditorGlobal.APP.statusMessage.text = fileName;
				EditorGlobal.MAIN_WND.openScene(EditorGlobal.DATA_MEMORY.getSceneTeamplate(selectItem.@sceneType), fileName);
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
		
//		override public function get contextMenuItems():Array {
//			var ret:Array = [];
//			var selectItem:XML = this.selectedItem as XML;
//			if(selectItem) {
//				if(selectItem.@leaf == true) {
//					ret = ret.concat([{"label":"克隆实例", "enabled":true, "handler":ctmNewInstance}
//								,{"label":"删除实例", "enabled":true, "handler":ctmNewInstance}]);
//				} else {
//					ret = ret.concat([{"label":"新建实例", "enabled":true, "handler":ctmNewInstance}]);
//				}
//			}
//			return ret;
//		}
		
		private function ctmNewInstance():void {
			
		}
	}
}