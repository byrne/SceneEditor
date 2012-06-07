package editor.datatype.type
{
	public interface IDataType {
		function get name():String;
		function set name(v:String):void;
		
		function get definition():Object;
		function set definition(v:Object):void;
		
		/**
		 * Construct an empty Object of the DataType. 
		 * @return 
		 * 
		 */
		function construct():*;
		
		/**
		 * Check whether a given value is of this DataType. 
		 * @param value value to be checked
		 * @return 
		 * 
		 */
		function check(value:*):Boolean;
		
		/**
		 * Try and convert a value of any type into this DataType 
		 * @param value
		 * @return 
		 * 
		 */
		function convert(value:*):DataConvertResult;
	}
}