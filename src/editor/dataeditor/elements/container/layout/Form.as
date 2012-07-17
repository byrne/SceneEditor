package editor.dataeditor.elements.container.layout
{
	import editor.dataeditor.IContainer;
	
	import flash.display.DisplayObject;
	
	import mx.core.IVisualElement;
	
	import spark.components.Form;
	import spark.layouts.HorizontalLayout;
	import spark.layouts.VerticalLayout;
	
	public class Form extends spark.components.Form implements IContainer
	{
		public function Form() {
			super();
		}
		
		override public function addChild(child:DisplayObject):DisplayObject {
			return addElement(child as IVisualElement) as DisplayObject; 
		}
		
		override public function removeChild(child:DisplayObject):DisplayObject {
			return removeElement(child as IVisualElement) as DisplayObject;
		}
		
		public function set gap(v:int):void {
			if(layout.hasOwnProperty('gap'))
				layout['gap'] == v;
		}
	}
}