package core.data
{
	import core.impl.UtilDataType;
	
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
			}
			return dataObj;
		}
	}
}