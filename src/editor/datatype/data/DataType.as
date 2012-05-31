package editor.datatype.data
{
	import editor.datatype.impl.UtilDataType;
	
	import mx.binding.utils.BindingUtils;
	
	public class DataType extends BasicDataType
	{
		public var hierarchies:Vector.<IDataType> = new Vector.<IDataType>;
		public var properties:Vector.<DataProperty> = new Vector.<DataProperty>;
		
		override public function get isPrimitive():Boolean { return false; }
		public function DataType(name:String=null) {
			super(name);
		}
		
		override public function construct():Object {
			var dataObj:Object = {"$type": this};
			dataObj.setPropertyIsEnumerable("$type", false);
			// Apply hierarchies
			for(var i:int = 0; i < hierarchies.length; i++) {
				UtilDataType.mergeObjs(dataObj, hierarchies[i].construct());
			}
			// Apply properties
			for each(var property:DataProperty in properties){
				dataObj[property.name] = property.value.construct();
				switch(UtilDataType.typeOf(dataObj[property.name])) {
					case BasicDataType.TYPE_INT:
						intGuard(dataObj, property.name);
						break;
					case BasicDataType.TYPE_FLOAT:
						floatGuard(dataObj, property.name);
						break;
				}
			}
			return dataObj;
		}
		
		private function floatGuard(dataObj:Object, name:String):void
		{
			BindingUtils.bindSetter(function(data:*):void {
				dataObj[name] = parseFloat(data.toString());
			}, dataObj, name, false, true);
		}
		
		private function intGuard(obj:Object, prop:Object):void {
			BindingUtils.bindSetter(function(data:*):void {
				obj[prop] = parseInt(data.toString());
			}, obj, prop, false, true);
		}
	}
}