package editor.utils
{
	/**
	 * Contains a bunch of utility methods that parse string representations of primitive value into 
	 * the cooresponding primitive value.
	 * @author Rong.Cheng
	 * 
	 */
	public class StringRep
	{
		private static const WHITESPACE:String = " \t\n\r";
		
		/**
		 * Symbols having special meanings. When the parser sees an unquoted string, it will look it up in this table
		 * first, and return the special value associated with that symbol or the symbol itself literally if it could
		 * not be found in the table. 
		 */
		private static const SPECIAL_VALUES:Object = {
			"null":		null,
			"true":		true,
			"false":	false,
			"NaN":		Number.NaN
		};
		
		/**
		 * Read a string representation of a primitive value, return the cooresponding primitive value. 
		 * @param str
		 * @return 
		 * 
		 */
		public static function read(str:String):* {
			var result:ParseResult;
			var trimedStr:String = StringUtil.trim(str);
			
			switch(str.charAt(0)) {
				case "'":	result = readString(trimedStr); break;
				case "[":	result = readArray(trimedStr); break;
				case "-":
				case ".":
				case "0":
				case "1":
				case "2":
				case "3":
				case "4":
				case "5":
				case "6":
				case "7":
				case "8":
				case "9":	result = readNumber(trimedStr); break;
				default:	result = readSpecial(trimedStr);
			}
			
			return result == null ? str : result.value;
		}
		
		/*
		* Primitive readers, convert string representations of primitive value into corresponding primitive values. 
		*/		
		
		private static function readString(trimedStr:String):ParseResult {
			var head:int = trimedStr.indexOf("'") + 1;
			var tail:int = trimedStr.lastIndexOf("'");
			
			return (head > tail)  ? null : new ParseResult(tail, trimedStr.substring(head, tail));
		}
		
		private static function readNumber(trimedStr:String):ParseResult {
			var regex_nodecimal:RegExp = /[-+]?[0-9]+([Ee][-+]?[0-9]+)?/;
			var regex_decimal:RegExp = /[-+]?[0-9]*.[0-9]+([Ee][-+]?[0-9]+)?/;
			
			var test1:Array = trimedStr.match(regex_nodecimal);
			var test2:Array = trimedStr.match(regex_decimal);
			var test:Array = test2 ? test2 : test1;
			
			return test == null ? null : new ParseResult(test[0].length, parseFloat(test[0]));
		}
		
		private static function readSpecial(str:String):ParseResult {
			return SPECIAL_VALUES.hasOwnProperty(str) ? new ParseResult(str.length, SPECIAL_VALUES[str]) : null;
		}
		
		private static function readArray(trimedStr:String):ParseResult {
			return new ParseResult(trimedStr.length, consArray(tokenize(trimedStr)));
		}
		
		/**
		 * Construct an array of <i>primitive</i> values from an array of <i>string representations</i> of primitives. 
		 * @param tokens array of string representation of primitives
		 * @return 
		 * 
		 */
		private static function consArray(tokens:Array):Array {
			var result:Array = [];
			for each(var item:* in tokens) {
				if(item is String)
					result.push(read(item));
				else if(item is Array)
					result.push(consArray(item));
			}
			return result;
		}
		
		/**
		 * Extract element strings from the string representation of an array into an array.
		 * <p>
		 *  
		 * @param trimedStr the string representation of an array with leading whitespaces removed.
		 * @return array of element strings, elements stored are either string or array (for nested arrays).
		 * 
		 */
		private static function tokenize(trimedStr:String):Array {
			var tokens:Array = [];
			var token:* = "";
			
			for (var i:int = 1; i < trimedStr.length;) {
				switch(trimedStr.charAt(i)) {
					case ']': 
						tokens.push(token);
						token = "";
						while(i < trimedStr.length && WHITESPACE.indexOf(trimedStr.charAt(++i)) != -1) {}
						tokens.source_length = i;
						return tokens; 
					case ',':
						tokens.push(token);
						token = "";
						while(i < trimedStr.length && WHITESPACE.indexOf(trimedStr.charAt(++i)) != -1) {}
						break;
					case '[':
						token = tokenize(trimedStr.substr(i));
						i += token.source_length;
						break;
					default:
						token += trimedStr.charAt(i++);
				}
			}
			
			return tokens;
		}
	}
}

/**
 * Intermedia parse result, used in tracking parsing progress (ParseResult::length), indicating whether the parsing
 * succeed (null test), and storing the parse value (ParseResult::value). 
 * @author Rong.Cheng
 * 
 */
internal class ParseResult {
	public var length:int;
	public var value:*;
	
	public function ParseResult(length:int=0, value:* = null) {
		this.length = length; this.value = value;
	}
}