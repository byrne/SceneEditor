package core.error
{
	public class UndefinedDataTypeError extends Error
	{
		public function UndefinedDataTypeError(message:*="", id:*=0) {
			super("Undefined DataType: " + message, id);
		}
	}
}