package editor.dataeditor.impl
{
	import editor.dataeditor.IContainer;
	import editor.dataeditor.IEditorElement;
	import editor.dataeditor.IElement;
	import editor.datatype.data.ComposedData;
	
	import flash.display.DisplayObject;
	import flash.utils.Dictionary;
	
	import mx.binding.utils.BindingUtils;
	import mx.core.IVisualElement;
	
	import spark.components.FormItem;
	
	public class EditorBase
	{
		public var definition:Object;
		public var name:String;
		public var componentClass:Object;
		public var property:Dictionary;
		public var hierarchy:EditorBase;
		public var children:Vector.<EditorBase>;
		public var bindingTarget:String;
		public var view_label:String;
		
		public function EditorBase(name:String, componentClass:Object) {
			this.name = name;
			this.componentClass = componentClass;
		}
		
		public function buildView(target:Object = null):IElement {
			var view:IElement
			if(componentClass is Class)
				view = new componentClass;
			else if(componentClass is EditorBase)
				view = (componentClass as EditorBase).buildView(target);
			applyProperties(view);
			
			if(view is IContainer)
				processChildren(view as IContainer, target);
			
			return view;
		}
		
		private function processChildren(container:IContainer, target:Object):void {
			var view:IElement;
			
			for(var i:int = 0; i < children.length; i++) {
				view = children[i].buildView(target);
				if(view is IEditorElement) {
					var formItem:FormItem = makeEditor(target, children[i].bindingTarget, view as IEditorElement);
					formItem.label = children[i].view_label;
					container.addChild(formItem);
				}
				else
					container.addChild(view as DisplayObject);
			}
		}
		
		private function makeEditor(data:Object, bindingTarget:String, component:IEditorElement):FormItem {
			var formItem:FormItem = new FormItem();
//			if(data[bindingTarget] != null)
			if(data is ComposedData && (data as ComposedData).assigned(bindingTarget))
				component[component.bindingProperty] = data[bindingTarget];
			BindingUtils.bindProperty(data, bindingTarget, component, component.bindingProperty);
			formItem.addElement(component as IVisualElement);
			return formItem;
		}
		
		public function applyProperties(target:IElement):void {
			if(hierarchy != null)
				hierarchy.applyProperties(target);
			for(var key:String in property)
				property[key].apply(target);	
		}
	}
}