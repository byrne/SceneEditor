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
		private var _valueProperty:String;
		
		private var _valuePropertyChanged:Boolean;
		private var _typesChanged:Boolean;
		private var _dataChanged:Boolean;
		private var _pendingSelectedItem:Object;
		private var _hasPendingSelectedItem:Boolean;
		
		public function MemoryDataChooser() {
			super();
			labelToItemFunction = myLabelToItemFunction;
			reset();
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
		
		public function get valueProperty():String { return _valueProperty; }
		public function set valueProperty(v:String):void {
			if(v == _valueProperty)
				return;
			_valueProperty = v;
			_valuePropertyChanged = true;
			invalidateSkinState();
		}
		
		override public function set enabled(value:Boolean):void {
			if(value == enabled)
				return;
			super.enabled = value;
			_user_enabled = value;
		}
		public function get type():String {return _types.join(",");}
		public function set type(v:String):void {
			if(v == null || StringUtil.trim(v) == '')
				return;
			
			if(v.charAt(0) == '[' && v.charAt(v.length-1) == ']')
				_types = StringRep.read(v);
			else
				_types = StringRep.read('[' + v + ']');
			
			_typesChanged = true;
			invalidateSkinState();
		}
		
		override protected function commitProperties():void {
			if(_typesChanged) {
				_typesChanged = false;
				_dataChanged = true;
			}
			
			if(_valuePropertyChanged) {
				_valuePropertyChanged = false;
				_dataChanged = true;
			}
			
			if(_dataChanged) {
				updateCandidates();
				_dataChanged = false;
			}
			if(_hasPendingSelectedItem) {
				selectedItem = _pendingSelectedItem;
				_hasPendingSelectedItem = false;
			}
			super.commitProperties();	// 这行太坑了，一定要把它放在自己的commit后边，要不此次渲染不会刷新，要到下次才会.
		}
		
		protected function updateCandidates():void {
			if(dataProvider != null)
				dataProvider.removeAll();
			
			var candidates:Array = []
			EditorGlobal.DATA_MEMORY.foreach(function(key:String, value:Object):void {
				if(_types == null || _types.length == 0)
					candidates.push(value);
				for each(var t:String in _types) {
					if(value is ComposedData && (value as ComposedData).$type.isa(t)) {
						if(_valueProperty == null)
							candidates.push(value);
						else 
							candidates.push(value[_valueProperty] ? value[_valueProperty] : "null");
					}
				}
			});
			
			dataProvider = new ArrayList(candidates);
		}
				
		public function get bindingProperty():Object {
			return 'selectedItem';
		}
		
		public function set defaultValue(value:Object):void {
			selectedItem = value;
		}
		
		protected function myLabelToItemFunction(value:String):Object {
			if(value == null)
				return null;
			var itemValue:String;
			var item:Object;
			for(var i:int = 0; i < dataProvider.length; i++) {
				item = dataProvider.getItemAt(i);
				itemValue = (item is String) ? item as String : (labelField != null && item.hasOwnProperty(labelField)) ? item[labelField] : String(item);
				if(itemValue == value)
					return item;
			}
			return selectedItem;
		}
		
		override public function set selectedItem(value:*):void {
			if(dataProvider == null) {
				_pendingSelectedItem = value;
				_hasPendingSelectedItem = true;
				return;
			}
			
			if(value is String)
				super.selectedItem = myLabelToItemFunction(value);
			else if(value is Reference && value != null) {
				var refEnti:ComposedData = (value as Reference).dereference();
				super.selectedItem = myLabelToItemFunction(refEnti ? refEnti[labelField] : null);
			}
		}
		
		public function reset():void {
			labelField = null;
			selectedItem = null;
			dataProvider = null;
			valueProperty = null;
			type = null;
		}
		
		public function destroy():void {
			reset();
			_pendingSelectedItem = null;
		}
	}
}