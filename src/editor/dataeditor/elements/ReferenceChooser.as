package editor.dataeditor.elements
{
	import editor.EditorGlobal;
	import editor.dataeditor.IEditorElement;
	import editor.datatype.data.ComposedData;
	import editor.datatype.data.Reference;
	import editor.utils.StringRep;
	import editor.utils.StringUtil;
	
	import mx.collections.ArrayList;
	
	import spark.components.ComboBox;
	
	public class ReferenceChooser extends ComboBox implements IEditorElement
	{
		public static const DEFAULT_SOURCE:String = "EditorGlobal.DATA_MEMORY|*";
		public var showTips:Boolean = false;
		private var _types:Array;
		private var _source:String = DEFAULT_SOURCE;
		
		public function ReferenceChooser() {
			super();
			labelField = "keyword";
			labelToItemFunction = myLabelToItemFunction;
			updateCandidates();
		}
		
		public function set type(v:String):void {
			if(v == null || StringUtil.trim(v) == '')
				return;
			
			if(v.charAt(0) == '[' && v.charAt(v.length-1) == ']')
				_types = StringRep.read(v);
			else
				_types = StringRep.read('[' + v + ']');
			
			updateCandidates();
		}
		
		protected function updateCandidates():void {
			if(dataProvider != null)
				dataProvider.removeAll();
			
			var candidates:Array = []
			EditorGlobal.DATA_MEMORY.foreach(function(key:String, value:Object):void {
				if(_types == null || _types.length == 0)
					candidates.push(value);
				for each(var t:String in _types) {
					if(value is ComposedData && (value as ComposedData).$type.isa(t))
						candidates.push(value);
				}
			});
			
			dataProvider = new ArrayList(candidates);
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
			if(value == null)
				return null;
			for(var i:int = 0; i < dataProvider.length; i++)
				if(dataProvider.getItemAt(i)[labelField] == value)
					return dataProvider.getItemAt(i);
			return selectedItem;
		}
		
		override public function set selectedItem(value:*):void {
			if(value is String)
				super.selectedItem = myLabelToItemFunction(value);
			else if(value is Reference && value != null) {
				var refEnti:ComposedData = (value as Reference).dereference();
				super.selectedItem = myLabelToItemFunction(refEnti ? refEnti[labelField] : null);
			}
		}
	}
}