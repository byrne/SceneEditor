package editor.dataeditor.elements.container.featured
{
	import editor.dataeditor.IElement;
	import editor.dataeditor.IFeaturedContainer;
	import editor.dataeditor.ILayoutContainer;
	
	import flash.display.DisplayObject;
	
	import mx.containers.TabNavigator;
	
	public class TabNavigator extends mx.containers.TabNavigator implements IFeaturedContainer
	{
		public function TabNavigator() {
			super();
		}
		
		public function get layoutContainer():ILayoutContainer {
			return null;
		}
		
		public function set layoutContainer(v:ILayoutContainer):void {
		}
		
		public function reset():void {
		}
		
		public function destroy():void {
			var child:DisplayObject;
			var childrenToRemove:Array = [];
			
			for(var i:int = 0; i < numChildren; i++) {
				child = getChildAt(i);
				if(child is IElement)
					childrenToRemove.push(child);
			}
			
			for each(var item:IElement in childrenToRemove) {
				removeChild(item as DisplayObject);
				item.destroy();
			}
		}
	}
}