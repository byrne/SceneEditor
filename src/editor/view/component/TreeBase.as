package editor.view.component
{
	import editor.EditorGlobal;
	import editor.constant.EventDef;
	import editor.constant.NameDef;
	import editor.event.DataEvent;
	import editor.utils.LogUtil;
	import editor.utils.StringUtil;
	import editor.view.mxml.TreeItemRendererBase;
	
	import flash.filesystem.File;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Tree;
	import mx.controls.treeClasses.MXTreeItemRenderer;
	import mx.core.ClassFactory;
	import mx.events.ListEvent;
	import mx.utils.ObjectProxy;
	
	public class TreeBase extends Tree
	{
		protected var lastClickItem:XML;
		protected var lastClickTime:Number;
		
		public function TreeBase()
		{
			super();
			this.percentWidth = 100;
			this.percentHeight = 100;
			this.labelField = "@label";
			this.showRoot = false;
			this.addEventListener(ListEvent.ITEM_CLICK, itemClickHandler);
			this.addEventListener(EventDef.TREE_ITEM_DOUBLE_CLICK, itemDoubleClickHandler);
			this.itemRenderer = new ClassFactory(TreeItemRendererBase);
		}
		
		public function clearView():void {
			this.dataProvider = null;
		}
		
		public function buildView(data:Object):void {
		}
		
		protected function itemClickHandler(evt:ListEvent):void {
			var selectItem:XML = this.selectedItem as XML;
			var clickTime:Number = new Date().time; 
			if(selectItem == lastClickItem) {
				if(clickTime - lastClickTime < 300) {
					lastClickItem = null;
					lastClickTime = 0;
					this.dispatchEvent(new DataEvent(EventDef.TREE_ITEM_DOUBLE_CLICK, selectItem));
				} else {
					lastClickTime = clickTime;
				}
			} else {
				lastClickItem = selectItem;
				lastClickTime = clickTime;
			}
		}
		
		protected function itemDoubleClickHandler(evt:DataEvent):void {
			
		}
	}
}