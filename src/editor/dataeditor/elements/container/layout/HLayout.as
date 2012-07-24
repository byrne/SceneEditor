package editor.dataeditor.elements.container.layout
{
	import editor.dataeditor.IElement;
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