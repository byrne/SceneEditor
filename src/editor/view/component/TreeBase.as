package editor.view.component
{
	import editor.EditorGlobal;
	import editor.constant.EventDef;
	import editor.constant.NameDef;
	import editor.event.DataEvent;
	import editor.utils.LogUtil;
	import editor.utils.StringUtil;
	import editor.view.mxml.TreeItemRendererBase;
	import editor.vo.ContextMenuData;
	
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Tree;
	import mx.controls.listClasses.ListBaseContentHolder;
	import mx.controls.treeClasses.MXTreeItemRenderer;
	import mx.core.ClassFactory;
	import mx.events.ListEvent;
	import mx.utils.ObjectProxy;
	
	public class TreeBase extends Tree
	{
		protected var contextMenuData:ContextMenuData;
		
		public function TreeBase()
		{
			super();
			this.percentWidth = 100;
			this.percentHeight = 100;
			this.labelField = "@label";
			this.showRoot = false;
			this.doubleClickEnabled = true;
			this.addEventListener(ListEvent.ITEM_CLICK, itemClickHandler);
			this.addEventListener(ListEvent.ITEM_DOUBLE_CLICK, itemDoubleClickHandler);
			this.itemRenderer = new ClassFactory(TreeItemRendererBase);
		}
		
		public function set contextMenuEnabled(val:Boolean):void {
			if(val) {
				contextMenuData = new ContextMenuData();
				contextMenuData.menuItems = contextMenuItems;
				contextMenuData.beforeHandler = contextMenuShowHandler;
				contextMenuData.hideHandler = contextMenuHideHandler;
				EditorGlobal.APP.registerContextMenu(this, contextMenuData);
			} else {
				contextMenuData = null;
				EditorGlobal.APP.unregisterContextMenu(this);
			}
		}
		
		public function get contextMenuEnabled():Boolean {
			return contextMenuData != null;
		}
		
		public function get contextMenuItems():Array {
			return [];
		}
		
		protected function contextMenuShowHandler():void {
		}
		
		protected function contextMenuHideHandler():void {
		}
		
		public function clearView():void {
			if(this.contextMenuEnabled)
				EditorGlobal.APP.unregisterContextMenu(this);
			this.dataProvider = null;
		}
		
		public function refreshView(data:Object=null):void {
		}
		
		protected function itemClickHandler(evt:ListEvent):void {
			if(contextMenuEnabled) {
				contextMenuData.menuItems = contextMenuItems;
				EditorGlobal.APP.registerContextMenu(this, contextMenuData);
			}
		}
		
		protected function itemDoubleClickHandler(evt:ListEvent):void {
			
		}
	}
}