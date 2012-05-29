package editor.utils
{
	import flash.display.BitmapData;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import json.JParser;
	
	import mx.graphics.codec.PNGEncoder;
	import mx.utils.ObjectProxy;

	public class CommonUtil {
		
		public static function dumpObject(obj:Object):String {
			var arr:Array = new Array();
			for (var attr:* in obj) {
				arr.push(attr + ":" + obj[attr]);
			}
			return arr.join(";");
		}
		
		public static function translateObjectProxy(data:ObjectProxy):Object {
			if (data.item) {
				return translateObjectProxyArray(data);
			}
			var obj:Object = new Object();
			for (var attr:String in data) {
				obj[attr] = data[attr] is ObjectProxy ? translateObjectProxy(data[attr]) : data[attr];
			}
			return obj;
		}
		
		protected static function translateObjectProxyArray(data:ObjectProxy):Array {
			var rawArray:Array = data.item.source;
			return rawArray.map(function(ele:*, index:int, arr:Array):Object {
				if (ele is ObjectProxy) {
					return translateObjectProxy(ele);
				}
				return ele;
			});
		}
		
		public static function generateIntVector(begin:int, end:int, step:int=1):Vector.<int> {
			var vec:Vector.<int> = new Vector.<int>();
			for (;begin<end;begin+=step) {
				vec.push(begin);
			}
			return vec;
		}
		
		public static function string2Dictionary(str:String, useObject:Boolean = false):* {
			var dict:* = useObject ? new Object() : new Dictionary();
			for each (var line:String in str.split('\n')) {
				var pos:int = line.indexOf("=");
				if (pos>=0) {
					dict[line.substr(0, pos)] = line.substr(pos + 1);
				}
			}
			return dict;
		}
		
		public static function dictionary2String(dict:*):String {
			var strs:Array = new Array();
			for (var key:String in dict) {
				strs.push(key + "=" + dict[key]);
			}
			return strs.join("\n");
		}
		
		public static function dictionaryKeys(dict:*):Array {
			var keys:Array = [];
			for (var key:* in dict) {
				keys.push(key);
			}
			return keys;
		}
		
		public static function mergeInto(source:Object, target:Object):Object {
			for (var key:* in source) {
				target[key] = source[key];
			}
			return target;
		}
		
		public static function merge(source:Object, target:Object):Object {
			var res:Object = new Object();
			var key:*;
			for (key in target) {
				res[key] = target[key];
			}
			for (key in source) {
				res[key] = source[key];
			}
			return res;
		}
		
		public static function supplementMerge(source:Object, target:Object):Object {
			for (var key:* in source) {
				if (undefined==target[key]) {
					target[key] = source[key];
				}
			}
			return target;
		}
		
		public static function getExportClassDetail(text:String):Object {
			var detail:Object = new Object();
			var index:int = text.indexOf(';');
			if (index>=0) {
				detail.name = text.substring(0, index);
				detail.args = text.substring(index + 1).split(',');
			} else {
				detail.name = text;
				detail.args = [];
			}
			return detail;
		}
		
		public static function createObject(clazz:Class, args:Array):* {
			switch (args.length) {
				case 0:
					return new clazz();
				case 1:
					return new clazz(args[0]);
				case 2:
					return new clazz(args[0], args[1]);
				case 3:
					return new clazz(args[0], args[1], args[2]);
				case 4:
					return new clazz(args[0], args[1], args[2], args[3]);
				case 5:
					return new clazz(args[0], args[1], args[2], args[3], args[4]);
				case 6:
					return new clazz(args[0], args[1], args[2], args[3], args[4], args[5]);
				case 7:
					return new clazz(args[0], args[1], args[2], args[3], args[4], args[5], args[6]);
				case 8:
					return new clazz(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7]);
				case 9:
					return new clazz(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8]);
				case 10:
					return new clazz(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9]);
				default:
					throw "too many arguments";
			}
		}
		
		public static function bitmapDataToPNG(bmd:BitmapData, path:String):void {
			var encoder:PNGEncoder = new PNGEncoder();
			var bytes:ByteArray = encoder.encode(bmd);
			var file:File = new File(path);
			var fileStream:FileStream = new FileStream();
			fileStream.open(file, FileMode.WRITE);
			fileStream.writeBytes(bytes);
			fileStream.close();
		}
		
		public static function decodeJSON(str:String):* {
			str = removeJSONComment(str);
			return JParser.decode(str);
		}
		
		public static function encodeJSON(obj:Object):String {
			var jsonStr:String;
			try {
				jsonStr = JParser.encode(obj);
			} catch (e:Error) {
				if (null == obj) {
					jsonStr = "null";
				} else {
					jsonStr = obj.toString();
				}
			}
			return jsonStr;
		}
		
		public static function removeJSONComment(str:String):String {
			var regExp:RegExp = /\/\/.*\r\n/g;
			var strOut:String = str.replace(regExp, "");
			strOut = strOut.replace(":NaN",":0");
			return strOut;
		}
		
		public static function objectToDictionary(object:Object):Dictionary {
			var result:Dictionary = null;
			if (object != null) {
				result = new Dictionary();
				for (var key:String in object) {
					result[key] = object[key];
				}
			}
			return result;
		}
		
		public static function appendArray(main:Array, appending:Array):void {
			for each (var e:* in appending) {
				main.push(e);
			}
		}

	}
}