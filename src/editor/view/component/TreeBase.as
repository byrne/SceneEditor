package editor.view.component
{
	import editor.EditorGlobal;
	import editor.constant.EmbededRes;
	import editor.constant.EventDef;
	import editor.constant.NameDef;
	import editor.event.DataEvent;
	import editor.utils.LogUtil;
	import editor.utils.StringUtil;
	import editor.view.mxml.TreeItemRendererBase;
	import editor.vo.ContextMenuData;
	
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Tree;
	import mx.controls.listClasses.ListBaseContentHolder;
	import mx.controls.treeClasses.MXTreeItemRenderer;
	import mx.core.ClassFactory;
	import mx.events.ListEvent;
	import mx.utils.ObjectProxy;
	
	import spark.collections.Sort;
	import spark.collections.SortField;
	
	public class TreeBase extends Tree
	{
		protected var contextMenuData:ContextMenuData;
		
		public var rememberOpenState:Boolean;
		protected var _scrollPosition:Number;
		protected var _openedItems:Array;
		
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
			rememberOpenState = true;
//			this.iconFunction = myIconFunction;
		}
		
		override protected function keyDownHandler(event:KeyboardEvent):void {
		}
		
//		protected function myIconFunction(obj:Object):Class {
//			var isLeaf:Boolean = XML(obj).@leaf == true;
//			if(isLeaf)
//				return EmbededRes.ICON;
//			else
//				return EmbededRes.MOVE;
//		}
		
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
			if(this.dataProvider != null)
				this.dataProvider = null;
		}
		
		public function refreshView(data:Object=null):void {
		}
		
		protected function itemClickHandler(evt:ListEvent):void {
			updateContextMenu();
		}
		
		public function updateContextMenu():void {
			if(contextMenuEnabled) {
				contextMenuData.menuItems = contextMenuItems;
				EditorGlobal.APP.registerContextMenu(this, contextMenuData);
			}
		}
		
		protected function itemDoubleClickHandler(evt:ListEvent):void {
			
		}
		
		override public function set dataProvider(value:Object):void {
			var i:int;
			var hasOldData:Boolean = dataProvider != null;
			var item:Object;
			var oldSelectedIndex:int;
			if(hasOldData && rememberOpenState) {
				_scrollPosition = this.verticalScrollPosition;
				_openedItems = [];
				oldSelectedIndex = this.selectedIndex;
				var labelVal:Object;
				for(i=0; i<this.openItems.length; i++) {
					item = this.openItems[i];
					with(item) {
						labelVal = String(@label);
					}
					_openedItems.push(labelVal);
				}
			}
			if(value != null) {
				var sortField:SortField = new SortField("@label");
				var sort:Sort = new Sort();
				sort.fields = [sortField];
				value.sort = sort;
				value.refresh();
			}
			super.dataProvider = value;
			this.validateNow();
			if(hasOldData && rememberOpenState) {
				for(i=0; i<this.dataProvider.length; i++) {
					item = this.dataProvider.getItemAt(i);
					openTreeItems(item);
				}
				this.verticalScrollPosition = _scrollPosition;
				this.selectedIndex = oldSelectedIndex;
			}
		}
		
		private function openTreeItems(obj:Object):void {
			var i:int;
			var label:String = obj.@label;
			for(i=0; i<_openedItems.length; i++) {
				if(_openedItems[i] == label) {
					this.expandItem(obj, true);
					break;
				}		
			}
//			var children:Object = obj.children(); 
//			if(children) {
//				for(i=0; i<children.length; i++) {
//					openTreeItems(children[i]);
//				}
//			}
		}
	}
}