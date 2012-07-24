package editor.dataeditor.elements.container.featured
{
	import editor.dataeditor.IFeaturedContainer;
	import editor.dataeditor.ILayoutContainer;
	
	import flash.display.DisplayObject;
	
	import mx.core.IVisualElement;
	
	import spark.components.Panel;
	import editor.dataeditor.elements.container.layout.VLayout;
	
	public class Panel extends spark.components.Panel implements IFeaturedContainer
	{
		public function Panel() {
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
		
		/* This chunck of code should be common to all containers implemented IFeaturedContainer. */
		override public function addChild(child:DisplayObject):DisplayObject {
			return layoutContainer.addChild(child);
		}
		
		override public function removeChild(child:DisplayObject):DisplayObject {
			return layoutContainer.removeChild(child);
		}
		
		public function reset():void {
		}
	}
}