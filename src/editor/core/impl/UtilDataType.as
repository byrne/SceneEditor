package core.impl
{
	public class UtilDataType
	{
		public function UtilDataType() {
		}
		
		/**
		 * Copy every property from a provider Object to the receiver Object.
		 *  
		 * @param receiver
		 * @param provider
		 * @param override whether to update an existing property of the receiver with the same property of the provider.
		 * 
		 */
		public static function mergeObjs(receiver:Object, provider:Object, override:Boolean = true):void {
			for(var key:String in provider) {
				if(receiver[key] == undefined || override)
					receiver[key] = provider[key]
			}
		}
		
		public static function typeOf(obj:Object):String {
			var typename:String = typeof obj;
	
			switch(typename.toLowerCase()) {
				case "object":
					typename = obj.$type ? obj.$type.name : (obj is Array) ? "array" : null;
					break;
				case "number":
					var isInt:Boolean = obj is int;
					typename = isInt ? "int" : typename;
					break;
			}
			
			return typename;
		}
	}
}