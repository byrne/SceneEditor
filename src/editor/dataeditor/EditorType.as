package editor.dataeditor
{
	import flash.utils.getDefinitionByName;
	
	import mx.core.UIComponent;

	public class EditorType
	{
		public var name:String;
		public var componentName:String;
		public var constraint:Array;
		
		public function EditorType(name:String, compName:String) {
			this.name = name;
			this.componentName = compName;
		}
		
		public function buildView():UIComponent {
			var view:UIComponent;
			
			if(compClass != null) {
				view = new compClass;
				view.percentWidth = 100;
				format(view);
				for each(var cons:EditorConstraint in constraint) {
					cons.apply(view);
				}
			}
			
			return view;
		}
		
		private function format(target:Object):void {
		}
		
		private function get compClass():Class {
			return getDefinitionByName(componentName) as Class;
		}
	}
}