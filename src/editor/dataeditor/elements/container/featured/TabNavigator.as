package editor.dataeditor.elements.container.featured
{
	import editor.dataeditor.IFeaturedContainer;
	import editor.dataeditor.ILayoutContainer;
	
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
	}
}