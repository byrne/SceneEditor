package editor.datatype
{
	public final class ReservedName
	{
		public static const RESOURCE:String = "resource";
		
		public static const X:String = "x";
		
		public static const Y:String = "y";
		
		public static const VISIBLE:String = "visible";
		
		private static const _nameArr:Array = [RESOURCE, X, Y, VISIBLE];
		
		public function ReservedName()
		{
		}
		
		public static function isReservedName(name:String):Boolean {
			return _nameArr.indexOf(name) >= 0;
		}
	}
}