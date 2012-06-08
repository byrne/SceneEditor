package editor.datatype.error
{
	public class InvalidPropertyNameError extends Error
	{
		public function InvalidPropertyNameError(name:String, id:*=0)
		{
			super("InvalidPropertyNameError: '" + name + "' is not a valid property name", id);
		}
	}
}