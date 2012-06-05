package error
{
	public class SingletonError extends Error
	{
		public function SingletonError(message:*="", id:*=0) {
			super("Singleton Error: " + message, id);
		}
	}
}