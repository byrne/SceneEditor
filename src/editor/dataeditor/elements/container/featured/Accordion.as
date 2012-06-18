package editor.dataeditor.elements.container.featured
{
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
	}
}