package editor
{
	import editor.view.IPopup;
	
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
			initContextMenuFeature();
//			addEventListener(MouseEvent.CONTEXT_MENU, contextMenuHandler);
		}
		
		protected function app_closeHandler(event:Event):void {
		}
		
		//-----------------------------------------------------------------------------------------------------
		// context menu support
		protected var contextMenuInfos:Dictionary = new Dictionary();
		protected var curMenuItemObject:Object;
		protected var curUIEventTarget:Object;
		protected var appContextMenu:Menu;
		protected var curMenuHideFunction:Function;
		
		protected function initContextMenuData():void {
			
		}
		
		protected function initContextMenuFeature():void {
			initContextMenuData();
			for (var key:* in contextMenuInfos) {
				var ed:IEventDispatcher = key as IEventDispatcher;
				ed.addEventListener(MouseEvent.CONTEXT_MENU, contextMenuHandler);
			}
		}
		
		private static function copyObjectProperty2XmlAttribute(obj:Object, xmlNode:XML, tag:String):void {
			if (undefined != obj[tag]) {
				xmlNode.@[tag] = obj[tag];
			}
		}
		private static const menuCopiedInfo:Array = ["type", "label", "toggled", "enabled", "accelerator"];
		private static function translateObjectToXML(obj:Object, menu_indices:Array = null):XML {
			if (!menu_indices) {
				menu_indices = new Array();
			}
			var xmlNode:XML = <menuitem/>;
			for each (var attr:String in menuCopiedInfo) {
				copyObjectProperty2XmlAttribute(obj, xmlNode, attr);
			}
			xmlNode.@["menu_indices"] = menu_indices.join(",");
			var submenuitems:Array = obj["menuitems"];
			if (submenuitems) {
				for (var i:uint=0;i<submenuitems.length;i++) {
					var menuitem:Object = submenuitems[i];
					xmlNode.appendChild(translateObjectToXML(menuitem, menu_indices.concat(i)));
				}
			}
			return xmlNode;
		}
		private static function fetchMenuIndices(xmlNode:XML):Array {
			var str_menu_indices:String = xmlNode.@["menu_indices"];
			return str_menu_indices.split(",");
		}
		private static function fetchMenuHandler(rootMenuData:Object, menu_indices:Array):Object {
			var menuItemArray:Array = rootMenuData["menuitems"];
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
			curMenuItemObject = contextMenuInfos[event.currentTarget];
			if (curMenuItemObject) {
				curUIEventTarget = event.currentTarget;
				event.stopPropagation();
				var beforeHandler:Function = curMenuItemObject["before_handler"] as Function;
				if (null!=beforeHandler) {
					beforeHandler.call(this, event);
				}
				var xmlData:XML = translateObjectToXML(curMenuItemObject);
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
				appContextMenu.dataProvider = xmlData;
				curMenuHideFunction = curMenuItemObject["onhide"] as Function;
				appContextMenu.show(event.stageX, event.stageY);
			}
		}
		
		protected function contextMenuItemClicked(event:MenuEvent):void {
			var curMenuItemArray:Array = curMenuItemObject["menuitems"];
			var menuHandler:Object = fetchMenuHandler(curMenuItemObject, fetchMenuIndices(event.item as XML));
			var handler:Function = menuHandler["handler"] as Function;
			if (null!=handler) {
				handler.call(this, menuHandler["param"]);
			}
		}
		
		protected function contextMenuShow(event:MenuEvent):void {
			
		}
		
		protected function contextMenuHide(event:MenuEvent):void {
			if (null!=curMenuHideFunction) {
				curMenuHideFunction.call(this);
			}
		}
		//-----------------------------------------------------------------------------------------------------
	}
}