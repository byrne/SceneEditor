package editor
{
	import editor.utils.DictionaryUtil;
	import editor.view.IPopup;
	import editor.vo.ContextMenuData;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	import mx.controls.Menu;
	import mx.core.FlexGlobals;
	import mx.core.IFlexDisplayObject;
	import mx.events.FlexEvent;
	import mx.events.MenuEvent;
	import mx.managers.PopUpManager;
	
	import spark.components.WindowedApplication;
	
	public class WindowedApplicationBase extends WindowedApplication
	{
		public function WindowedApplicationBase()
		{
			super();
			addEventListener(FlexEvent.APPLICATION_COMPLETE, app_creationCompleteHandler);
			addEventListener(Event.CLOSE, app_closeHandler);
		}
		
		protected function app_creationCompleteHandler(event:FlexEvent):void {
//			initContextMenuFeature();
			addEventListener(MouseEvent.CONTEXT_MENU, contextMenuHandler);
		}
		
		protected function app_closeHandler(event:Event):void {
		}
		
		//-----------------------------------------------------------------------------------------------------
		// context menu support
		protected var contextMenuInfos:Dictionary = new Dictionary();
		protected var curHitMenuDatas:Array;
		protected var appContextMenu:Menu;
		
		public function registerContextMenu(target:DisplayObject, menuData:ContextMenuData):void {
			if(menuData.menuItems.length > 0)
				contextMenuInfos[target] = menuData;
		}
		
		public function unregisterContextMenu(target:DisplayObject):void {
			delete contextMenuInfos[target];
		}
		
		private static function copyObjectProperty2XmlAttribute(obj:Object, xmlNode:XML, tag:String):void {
			if (obj.hasOwnProperty(tag)) {
				xmlNode.@[tag] = obj[tag];
			}
		}
		private static const menuCopiedInfo:Array = ["type", "label", "toggled", "enabled", "accelerator"];
		private static function translateMenudataArrayToXML(menuDataArr:Array):XML {
			var xmlNode:XML = <menuitem/>;
			var menuData:ContextMenuData;
			var xml:XML;
			var addSeparator:Boolean = false;
			for each(menuData in menuDataArr) {
				if(addSeparator) {
					xml = <menuitem/>;
					xml.@type = "separator";
					xmlNode.appendChild(xml);
				}
				translateMenuDataToXML(menuData, xmlNode);
				addSeparator = true;
			}
			return xmlNode;
		}
		private static function translateMenuDataToXML(menuData:Object, parentXML:XML, menu_indices:Array = null):XML {
			if (!menu_indices) {
				menu_indices = new Array();
			}
			var xmlNode:XML = <menuitem/>;
			if(parentXML!=null)
				xmlNode = parentXML;
			for each (var attr:String in menuCopiedInfo) {
				copyObjectProperty2XmlAttribute(menuData, xmlNode, attr);
			}
			xmlNode.@["menu_indices"] = menu_indices.join(",");
			var submenuitems:Array = menuData.menuItems;
			if (submenuitems) {
				for (var i:uint=0;i<submenuitems.length;i++) {
					var menuitem:Object = submenuitems[i];
					xmlNode.appendChild(translateMenuDataToXML(menuitem, null, menu_indices.concat(i)));
				}
			}
			return xmlNode;
		}

		private static function fetchMenuIndices(xmlNode:XML):Array {
			var str_menu_indices:String = xmlNode.@["menu_indices"];
			return str_menu_indices.split(",");
		}
		private static function fetchMenuHandler(rootMenuData:Object, menu_indices:Array):Object {
			var menuItemArray:Array = rootMenuData.menuItems;
			if (menuItemArray) {
				var index:uint = menu_indices[0];
				if (index<menuItemArray.length) {
					var menuData:Object = menuItemArray[index];
					var sub_indices:Array = menu_indices.slice(1);
					if (sub_indices.length>0) {
						return fetchMenuHandler(menuData, sub_indices);
					}
					return menuData;
				}
			}
			return null;
		}
		
		protected function contextMenuHandler(event:MouseEvent):void {
			var obj:DisplayObject = event.target as DisplayObject;
			var targets:Array = DictionaryUtil.getKeys(contextMenuInfos);
			var curHitTargets:Array = [];
			while(true) {
				if(targets.indexOf(obj) >= 0) {
					curHitTargets.push(obj);
				}
				if(obj == this.stage)
					break;
				obj = obj.parent;
			}
			event.stopPropagation();
			if (curHitTargets.length > 0) {
				if (!appContextMenu) {
					appContextMenu = Menu.createMenu(this, null, false);
					appContextMenu.labelField="@label";
					appContextMenu.variableRowHeight = true;
					appContextMenu.addEventListener(MenuEvent.ITEM_CLICK, contextMenuItemClicked);
					appContextMenu.addEventListener(MenuEvent.MENU_SHOW, contextMenuShow);
					appContextMenu.addEventListener(MenuEvent.MENU_HIDE, contextMenuHide);
				} else {
					appContextMenu.hide();
				}
				
				var menuData:ContextMenuData;
				var beforeHandler:Function;
				curHitMenuDatas = [];
				for each(obj in curHitTargets) {
					menuData = contextMenuInfos[obj] as ContextMenuData;
					curHitMenuDatas.push(menuData);
					if(menuData.beforeHandler != null)
						menuData.beforeHandler.call(this);
				}
				
				var xmlData:XML = translateMenudataArrayToXML(curHitMenuDatas);
				appContextMenu.dataProvider = xmlData;
				appContextMenu.show(event.stageX, event.stageY);
			}
		}
		
		protected function contextMenuItemClicked(event:MenuEvent):void {
			var menuHandler:Object;
			for each(var menuData:ContextMenuData in curHitMenuDatas) {
				menuHandler = fetchMenuHandler(menuData, fetchMenuIndices(event.item as XML));
				if(menuHandler)
					break;
			}
			var handler:Function = menuHandler["handler"] as Function;
			if (null!=handler) {
				if(menuHandler["param"] != null)
					handler.apply(this, menuHandler["param"]);
				else
					handler.call(this);
			}
		}
		
		protected function contextMenuShow(event:MenuEvent):void {
			
		}
		
		protected function contextMenuHide(event:MenuEvent):void {
			var menuData:ContextMenuData;
			var beforeHandler:Function;
			var menuData:ContextMenuData;
			for each(menuData in curHitMenuDatas) {
				if(menuData.hideHandler != null)
					menuData.hideHandler.call(this);
			}
		}
		//-----------------------------------------------------------------------------------------------------
	}
}