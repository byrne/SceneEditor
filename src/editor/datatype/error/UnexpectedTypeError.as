package editor.datatype.error
{
	import editor.datatype.type.IDataType;

	public class UnexpectedTypeError extends Error
	{
		public function UnexpectedTypeError(message:*=null, id:*=0)
		{
			super("UnexpectedTypeError: " + message, id);
		}
	}
}