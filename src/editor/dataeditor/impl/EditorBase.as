package editor.dataeditor.impl
{
	import editor.dataeditor.IContainer;
	import editor.dataeditor.IEditorElement;
	import editor.dataeditor.IElement;
	import editor.dataeditor.elements.container.layout.HLayout;
	import editor.dataeditor.elements.container.layout.VLayout;
	import editor.datatype.data.ComposedData;
	
	import flash.display.DisplayObject;
	import flash.utils.Dictionary;
	
	import mx.binding.utils.BindingUtils;
	import mx.core.IVisualElement;
	
	import spark.components.FormItem;
	import spark.primitives.Rect;
	
	/**
	 * EditorBase stores the structure of and rountines to create an editor to edit ComposedData objects. <p>
	 * 
	 * Unlike DataType, EditorBase does NOT have a hierarchy mechanism, the only hierarchy it has is through its 
	 * componentClass property, which gives the editor every thing from that componentClass to use/override.
	 * 
	 * @author Rong
	 * 
	 */
	public class EditorBase
	{
		/** Definition of the Editor in human editable form, i.e. XML, JSON, etc. */
		public var definition:Object;
		public var name:String;
		/** Class used to create the editor, could be either an AS Class or another EditorBase in case of inheritance */
		public var componentClass:Object;
		/** property of editor, such as width, height, label, etc. */
		public var property:Dictionary;
		public var children:Vector.<EditorBase>;
		/** property whose value this EditorBase will edit */
		public var bindingTarget:String;
		/** Label text when this EditorBase's component is used in a form */
		public var view_label:String = null;
		/** infomathion about binding of property on data object to editor elements */
		private var _bindings:Dictionary = new Dictionary;
		/** the actual display object used to edit */
		private var _view:IElement;
		private var fieldDefaults:Array = [];
		
		public function EditorBase(name:String, componentClass:Object) {
			this.name = name;
			this.componentClass = componentClass;
		}
		
		public function lock(v:Boolean):void {
			for each(var item:Object in _bindings) {
				item.ed_comp.locked = v;
			}
		}
		
		/**
		 * Get the editor for a data object. 
		 * @param target the data object to modify
		 * @return editor component
		 * 
		 */
		public function getEditorFor(data:Object):IElement {
			if(_view)
				removeBinding();
			else
				_view = buildView(data);
			applyBindings(data);
			return _view;
		}
		
		/**
		 * Build an editor component for a target. <br>
		 * <b>WARNINNG: </b> DO NOT use this method when you need an editor for a piece of data, you will risk
		 * memory leak due to data binding. 
		 * @param target data object to modify
		 * @param bindingMap dictionary containing binding infomation
		 * @return editor component
		 * 
		 */
		public function buildView(target:Object, bindingMap:Dictionary = null):IElement {
			if(bindingMap == null)
				bindingMap = _bindings;
			var view:IElement
			if(componentClass is Class)
				view = new componentClass;
			else if(componentClass is EditorBase)
				view = (componentClass as EditorBase).buildView(target, bindingMap);
			if(view is IContainer)
				processChildren(view as IContainer, target, bindingMap);
			view.percentHeight = view.percentWidth = 100;
			applyProperties(view);
			return view;
		}
		
		/**
		 * Build and configure every child for an IContainer.  
		 * @param container the IContainer object
		 * @param target data object to modify
		 * @param bindingMap dictionary containing binding infomation
		 * 
		 */
		private function processChildren(container:IContainer, target:Object, bindingMap:Dictionary):void {
			var view:IElement;
			var formItem:FormItem;
			if(container is HLayout) {
//				(container as HLayout).setStyle("borderStyle", "solid");
			}
			for(var i:int = 0; i < children.length; i++) {
				view = children[i].buildView(target, bindingMap);
				if(view is IEditorElement) {
					formItem = makeEditor(target, children[i], view as IEditorElement, bindingMap);
					formItem.label = children[i].view_label;
					container.addChild(formItem);
				}
				else if(children[i].view_label != null) {
					formItem = new FormItem;
					formItem.addElement(view as IVisualElement);
					formItem.label  = children[i].view_label;
					container.addChild(formItem);
				}
				else
					container.addChild(view as DisplayObject);
			}
		}
		
		/**
		 * Wrap a field editor in a FormItem, for a property on the data object, which is used to modifiy its value. <p>
		 * 
		 * @param data data object
		 * @param prop property of the data object to be modified
		 * @param component field editor component
		 * @param bindingMap dictionary to store the binding infomation
		 * @return the wrapping FormItem 
		 * 
		 */
		private function makeEditor(data:Object, edBase:EditorBase, component:IEditorElement, bindingMap:Dictionary):FormItem {
			var prop:String = edBase.bindingTarget;
			var formItem:FormItem = new FormItem();
			bindingMap[prop] = new PEBinding(component, edBase);
			formItem.addElement(component as IVisualElement);
			return formItem;
		}
		
		public function applyProperties(target:IElement):void {
			for(var key:String in property)
				property[key].apply(target);
		}
		
		/**
		 * One way binding only, view -> data only. 
		 * @param target data
		 * 
		 */
		private function applyBindings(target:Object):void {
			var component:IEditorElement;
			for(var prop:String in _bindings) {
				component = _bindings[prop].ed_comp;
				if(target is ComposedData && target.assigned(prop))
					component[component.bindingProperty] = target[prop];
				_bindings[prop].watchers.push(BindingUtils.bindProperty(target, prop, component, component.bindingProperty, true));
			}
		}
		
		private function removeBinding():void {
			for each (var pair:PEBinding in _bindings) {
				pair.reset();
			}
		}
	}
}

import editor.dataeditor.IEditorElement;
import editor.dataeditor.impl.EditorBase;

import mx.binding.utils.ChangeWatcher;

/**
 * A structure containing a property_name and an IEditorElement to which it shall be bound.
 *   
 * @author Rong
 * 
 */
internal class PEBinding {
	public var editor_base:EditorBase;  // we need this to reset field editor to its default value
	public var ed_comp:IEditorElement;	// we need this to do binding
	public var watchers:Vector.<ChangeWatcher> = new Vector.<ChangeWatcher>; // we need this to manage ChangeWatchers
	
	public function PEBinding(ed_comp:IEditorElement, editor_base:EditorBase) {
		this.ed_comp = ed_comp; this.editor_base = editor_base;
	}
	
	public function discard():void {
		reset();
		ed_comp = null;
		editor_base = null;
	}
	
	public function reset():void {
		while(watchers.length > 0)
			watchers.pop().unwatch();
		ed_comp.reset();
		// In case the next data to modify has not assigned values to all of its properties, if we do not
		// clear the field editors, it would get the value from previous data during data binding.
		if(editor_base.property.hasOwnProperty('defaultValue'))
			editor_base.property['defaultValue'].apply(ed_comp);	
		else
			ed_comp.defaultValue = null;
	}
}