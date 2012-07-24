package editor.dataeditor.elements.container.layout
{
	import editor.dataeditor.ILayoutContainer;
	
	import flash.display.DisplayObject;
	
	import mx.core.IVisualElement;
	
	import spark.components.HGroup;
	
	public class HLayout extends HGroup implements ILayoutContainer
	{
		public function HLayout() {
			super();
		}
		
		override public function addChild(child:DisplayObject):DisplayObject {
			return addElement(child as IVisualElement) as DisplayObject; 
		}
		
		override public function removeChild(child:DisplayObject):DisplayObject {
			return removeElement(child as IVisualElement) as DisplayObject;
		}
		
		public function reset():void {
		}
	}
}