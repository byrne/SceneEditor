package editor.dataeditor.elements
{
	import editor.dataeditor.IEditorElement;
	import editor.dataeditor.util.VariableResolver;
	import editor.utils.StringUtil;
	
	import mx.collections.ArrayList;
	import mx.collections.IList;
	
	import spark.components.ComboBox;
	
	public class TextSelector extends ComboBox implements IEditorElement
	{
		private var _source:String;
		private var _filter:RegExp;
		
		private var sourceChanged:Boolean;
		private var filterChanged:Boolean;
		
		public function TextSelector() {
			super();
		}
		
		public function get bindingProperty():Object {
			return "selectedItem";
		}
		
		/**
		 * Set a source for the list candidates.
		 * @param v path to the list
		 */
		public function set source(v:String):void {
			if(v == _source)
				return;
			_source = v;
			sourceChanged = true;
			updateList();
		}
		
		/**
		 * Set a filter regular expression for the list candidates, any candidates that do not match the filter will
		 * be removed from the list.  
		 * @param v string represntation of a regular expression.
		 */
		public function set filter(v:String):void {
			if(_filter && v && v != _filter.source)
				return;
			_filter = new RegExp(v);
			filterChanged = true;
			updateList();
		}
		
		private function updateList():void {
			if(sourceChanged == true && _source != null) {
				var candidates:* = VariableResolver.getValue(_source);
				if(!(candidates is Array))
					candidates = [candidates];
				dataProvider = new ArrayList(candidates);
				sourceChanged = false;
			}
			else if(dataProvider == null)
				return;
			
			var newDataProvider:IList = new ArrayList();
			if(filterChanged == true && _filter != null ) {
				for (var i:int = 0; i < dataProvider.length; i++)
					if(dataProvider.getItemAt(i).search(_filter) != -1)
						newDataProvider.addItem(dataProvider.getItemAt(i));
				
				filterChanged = false;
				dataProvider = newDataProvider;
			}
		}
		
		public function set defaultValue(v:Object):void {
			if(v is int)
				this[bindingProperty] = v;
		}
		
		override public function set selectedItem(value:*):void {
			if(value == null)
				selectedIndex = 0;
			else
				super.selectedIndex = value as int;
		}
	}
}