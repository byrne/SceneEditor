package editor.datatype.error
{
	import editor.datatype.type.IDataType;

	public class UndefinedPropertyError extends Error
	{
		public function UndefinedPropertyError(name:String, type:IDataType, id:*=0) {
			super("UndefinedPropertyError: property '" + name + "' is not defined on type " + type.name, id);
		}
	}
}