package editor.datatype.type
{
	public class DataProperty
	{
		public var name:String;
		public var value:IDataType;
		
		public function DataProperty(name:String=null, value:IDataType=null) {
			this.name = name;
			this.value = value;
		}
	}
}