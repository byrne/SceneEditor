package editor.view.component
{
	import editor.EditorGlobal;
	import editor.dataeditor.IElement;
	import editor.dataeditor.impl.EditorBase;
	import editor.datatype.data.ComposedData;
	import editor.mgr.PopupMgr;
	import editor.view.component.window.PropertyEditorWindow;
	import editor.vo.Scene;
	
	import flash.display.DisplayObject;
	
	import mx.collections.ArrayCollection;
	import mx.collections.XMLListCollection;
	import mx.core.FlexGlobals;
	import mx.core.IFlexDisplayObject;
	import mx.events.ListEvent;
	import mx.managers.PopUpManager;

	public class SceneEntitiesTree extends TreeBase
	{
		public var scene:Scene;
		
		public function SceneEntitiesTree()
		{
			super();
			this.contextMenuEnabled = true;
		}
		
		override public function refreshView(data:Object=null):void {
			var scrollPosition:Number;
			var openedItems:Object;
			scene = data as Scene;
			var entityClassArr:Array = scene.template.entities;
			var dataProvider:ArrayCollection = new ArrayCollection(); // = <node/>;
			for each(var entityClassName:String in entityClassArr) {
				dataProvider.addItem(populateCategory(entityClassName, data as Scene));
//				dataProvider.appendChild(populateCategory(entityClassName, data as Scene));
			}
			this.dataProvider = dataProvider;
		}
		
		private function populateCategory(cate_name:String, scene:Scene):XML {
			var categoryTree:XML = <node />;
			var child:XML;
			categoryTree.@label = cate_name;
			categoryTree.@leaf = false;
			
			for each(var entity:ComposedData in scene.entities) {
				if(entity.$type.name != cate_name) continue;
				child = <node />;
				child.@label = entity['keyword'];
				child.@leaf = true;
				child.@template = cate_name;
				categoryTree.appendChild(child);
			}
			
			return categoryTree;
		}
		
		private function getEntiDataByXML(item:XML):ComposedData {
			if(item.@leaf != true)
				return null;
			var enti:ComposedData;
			for each(enti in scene.entities) {
				if(enti['keyword'] == item.@label) {
					return enti;
				}
			}
			return null;
		}
		
		override protected function itemClickHandler(evt:ListEvent):void {
			super.itemClickHandler(evt);
			var enti:ComposedData = getEntiDataByXML(this.selectedItem as XML);
			if(enti && enti.view) {
				enti.view.selected = true;
			}
		}
		
		override protected function itemDoubleClickHandler(evt:ListEvent):void {
			var enti:ComposedData = getEntiDataByXML(this.selectedItem as XML);
			if(enti != null) {
				EditorGlobal.PROPERTY_WND.title = "Editing "+enti.$type.name;
				EditorGlobal.PROPERTY_WND.target = enti;
				PopupMgr.getInstance().popupWindow(EditorGlobal.PROPERTY_WND);
			}
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