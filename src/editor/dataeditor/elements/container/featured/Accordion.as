package editor.dataeditor.elements.container.featured
{
	import editor.dataeditor.IElement;
	import editor.dataeditor.IFeaturedContainer;
	import editor.dataeditor.ILayoutContainer;
	import editor.dataeditor.elements.container.layout.AccordionContent;
	import editor.dataeditor.elements.container.layout.VLayout;
	
	import flash.display.DisplayObject;
	
	import mx.containers.Accordion;
	import mx.core.IVisualElement;
	
	public class Accordion extends mx.containers.Accordion implements IFeaturedContainer
	{
		public function Accordion()
		{
			super();
		}
		
		public function set layoutContainer(v:ILayoutContainer):void {
			return;
		}
		public function get layoutContainer():ILayoutContainer {
			return null;
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