package editor.dataeditor.elements.container.featured
{
	import editor.dataeditor.IElement;
	import editor.dataeditor.IFeaturedContainer;
	import editor.dataeditor.ILayoutContainer;
	import editor.dataeditor.elements.container.layout.VLayout;
	
	import flash.display.DisplayObject;
	
	import mx.core.IVisualElement;
	
	import spark.components.TitleWindow;
	
	public class TitleWindow extends spark.components.TitleWindow implements IFeaturedContainer
	{
		public function TitleWindow()
		{
			super();
		}
		
		private var _layoutContainer:ILayoutContainer;
		public function set layoutContainer(v:ILayoutContainer):void {
			if(_layoutContainer != null)
				removeChild(_layoutContainer as DisplayObject);
			_layoutContainer = v;
			_layoutContainer.percentHeight = _layoutContainer.percentWidth = 100;
			super.addElement(_layoutContainer as IVisualElement);
		}
		public function get layoutContainer():ILayoutContainer {
			if(_layoutContainer == null)
				layoutContainer = new VLayout;
			return _layoutContainer;
		}
		
		override public function addChild(child:DisplayObject):DisplayObject {
			return layoutContainer.addChild(child);
		}
		
		override public function removeChild(child:DisplayObject):DisplayObject {
			return layoutContainer.removeChild(child);
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