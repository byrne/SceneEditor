package editor.datatype.data
{
	public interface IDataType
	{
		/**
		 * Construct an empty Object of the DataType. 
		 * @return 
		 * 
		 */
		function construct():Object;
		
		function get name():String;
		function set name(v:String):void;
		
		function get isPrimitive():Boolean;
		
		function get definition():Object;
		function set definition(v:Object):void;
	}
}