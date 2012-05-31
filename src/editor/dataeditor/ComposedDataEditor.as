package editor.dataeditor
{
	import avmplus.getQualifiedClassName;
	
	import editor.datatype.data.DataType;
	import editor.datatype.impl.DataFactory;
	
	import flash.utils.getDefinitionByName;
	
	import mx.binding.utils.BindingUtils;
	import mx.core.UIComponent;
	
	import spark.components.Form;
	import spark.components.FormItem;

	public class ComposedDataEditor extends Form
	{
		public function ComposedDataEditor() {
			super();
		}
		
		public function buildFromData(dataObject:Object):void {
			if(dataObject == null || dataObject.$type == null)
				return;
			var rows:Array = getComponents(dataObject.$type);
			var row:Array;
			
			while(rows.length > 0) {
				row = rows.shift();
				var target_property:String = DataEditorFactory.BINDING_PEOPERTIES[getQualifiedClassName(row[2])];
				row[2][target_property] = dataObject[row[0]];
				BindingUtils.bindProperty(dataObject, row[0], row[2], target_property);
				addElement(row[1]);
			}
		}
		
		private function getComponents(type:DataType):Array {
			var result:Array = [];
			
			for each(var hierarchy:DataType in type.hierarchies) {
				result = result.concat(getComponents(hierarchy));
			}
			
			for each(var prop:XML in type.definition.children()) {
				if(!prop.hasOwnProperty('@editor'))
					continue;
				var row:FormItem = new FormItem();
				row.percentWidth = 100;
				row.label = prop.@label.toString();
				var renderer:UIComponent = DataEditorFactory.INSTANCE.getEditor(prop.@editor.toString()).buildView();
				renderer.percentWidth = 100;
				row.addElement(renderer);
				result.push([prop.@name.toString(), row, renderer]);
			}
			
			return result;
		}
	}
}