package editor.datatype.impl
{
	import editor.datatype.data.ComposedData;
	import editor.datatype.data.Reference;
	
	import flash.utils.getQualifiedClassName;
	
	import mx.collections.ArrayCollection;
	import mx.collections.ArrayList;
	
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
					receiver[key] = provider[key];
			}
		}
		
		public static function typeOf(obj:Object):String {
			var typename:String = typeof obj;
			
			switch(typename.toLowerCase()) {
				case "object":
					typename = obj.hasOwnProperty("$type") ? obj.$type.name : (obj is Array || obj is ArrayCollection || obj is ArrayList) ? "array" : guessType(obj);
					break;
				case "number":
					var isInt:Boolean = obj is int;
					typename = isInt ? "int" : typename;
					break;
			}
			
			return typename;
		}
		
		
		public static function guessType(obj:Object):String {
			var typeName:String;
			
			if(obj.hasOwnProperty("$type"))
				typeName = obj.$type.name;
			else {
				var qClassName:String = getQualifiedClassName(obj); 
				var spliterIndex:int = qClassName.lastIndexOf(":") + 1;
				typeName = qClassName.substr(spliterIndex);
			}
			
			return typeName;
		}
		
		public static function copy(source:*):* {
			if(source == null)
				return source;
			else if(source is Array)
				return copyArray(source as Array);
			else if(source is ComposedData)
				return (source as ComposedData).clone();
			else if(source is Reference)
				return (source as Reference).clone();
			else 
				return source;
		}
		
		private static function copyArray(source:Array):Array {
			var dup:Array = [];
			for(var i:int = 0; i < source.length; i++)
				dup.push(copy(source[i]));
			return dup;
		}
	}
}