package editor.dataeditor.elements
{
	import editor.EditorGlobal;
	import editor.dataeditor.IEditorElement;
	import editor.datatype.data.Reference;
	
	import mx.collections.ArrayList;
	
	import spark.components.ComboBox;
	
	public class ReferenceChooser extends ComboBox implements IEditorElement
	{
		public static const DEFAULT_SOURCE:String = "EditorGlobal.DATA_MEMORY|*";
		public var showTips:Boolean = false;
		
		private var _source:String = DEFAULT_SOURCE;
		
		public function ReferenceChooser() {
			super();
			labelField = "keyword";
			labelToItemFunction = myLabelToItemFunction;
			var candidates:ArrayList = new ArrayList;
			EditorGlobal.DATA_MEMORY.foreach(function(key:String, value:Object):void {
				candidates.addItem(value);
			});
			
			dataProvider = candidates;
		}
		
		public function set source(v:String):void {
			if(_source == v)
				return;
			_source = v;
		}
		
		public function get source():String {
			return _source;
		}
		
		public function get bindingProperty():Object {
			return 'selectedItem';
		}
		
		public function set defaultValue(value:Object):void {
			this[bindingProperty] = value;
		}
		
		protected function myLabelToItemFunction(value:String):Object {
			for(var i:int = 0; i < dataProvider.length; i++)
				if(dataProvider.getItemAt(i)[labelField] == value)
					return dataProvider.getItemAt(i);
			return selectedItem;
		}
		
		override public function set selectedItem(value:*):void {
			if(value is String)
				super.selectedItem = myLabelToItemFunction(value);
			else if(value is Reference && value != null)
				super.selectedItem = myLabelToItemFunction((value as Reference).dereference()[labelField]);
		}
	}
}