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
	
	public class MemoryDataChooser extends ComboBox implements IEditorElement
	{
		public var showTips:Boolean = false;
		private var _types:Array;
		private var _locked:Boolean;
		private var _user_enabled:Boolean;
		
		public function MemoryDataChooser() {
			super();
			labelField = "keyword";
			labelToItemFunction = myLabelToItemFunction;
			updateCandidates();
		}
		
		public function get locked():Boolean { return _locked; }
		public function set locked(v:Boolean):void {
			if(_locked == v)
				return;
			else if(v)
				super.enabled = !v;
			else
				super.enabled = _user_enabled;
		}
		
		override public function set enabled(value:Boolean):void {
			if(value == enabled)
				return;
			super.enabled = value;
			_user_enabled = value;
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