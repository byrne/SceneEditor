package editor.view.component
{
	import editor.EditorGlobal;
	import editor.vo.Scene;

	public class SceneEntitiesTree extends TreeBase
	{
		public function SceneEntitiesTree()
		{
			super();
			this.contextMenuEnabled = true;
		}
		
		override public function refreshView(data:Object=null):void {
			var scene:Scene = EditorGlobal.MAIN_WND.curScene;
			var entityClassArr:Array = scene.template.entities;
			var dataProvider:XML = <node/>;
			for each(var entityClassName:String in entityClassArr) {
				var xml:XML = <node/>;
				xml.@label = entityClassName;
				xml.@leaf = false;
				dataProvider.appendChild(xml);
				var childXML:XML;
				for(var i:int=0; i<3; i++) {
					childXML = <node/>;
					childXML.@label = entityClassName+"_00"+(i+1).toString();
					childXML.@leaf = true;
					xml.appendChild(childXML);
				}
			}
			this.dataProvider = dataProvider;
		}
		
		override public function get contextMenuItems():Array {
			var ret:Array = [];
			var selectItem:XML = this.selectedItem as XML;
			if(selectItem) {
				if(selectItem.@leaf == true) {
					ret = ret.concat([{"label":"克隆实例", "enabled":true, "handler":ctmNewInstance}
						,{"label":"删除实例", "enabled":true, "handler":ctmNewInstance}]);
				} else {
					ret = ret.concat([{"label":"新建实例", "enabled":true, "handler":ctmNewInstance}]);
				}
			}
			return ret;
		}
		
		private function ctmNewInstance():void {
			
		}
	}
}