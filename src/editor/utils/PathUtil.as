package editor.utils
{
	import flash.filesystem.File;

	public class PathUtil {
		
		public static function makeShortPath(path:String, length:int = 100):String {
			var slashindex1:int = path.lastIndexOf('\\');
			var slashindex2:int = path.lastIndexOf('/');
			slashindex1 = Math.max(slashindex1, slashindex2); {
				path = path.substr(slashindex1 + 1);
			}
			if (path.length>length) {
				var erase:int = path.length - length + 3;
				var eraseBegin:int = (path.length - erase)/2;
				var eraseEnd:int = (path.length + erase)/2;
				path = path.substring(0, eraseBegin) + '...' + path.substr(eraseEnd);
			}
			return path;
		}
		
		public static function translateLoadingUrl(rawUrl:String):String {
			const excludedHeaders:Array = ["http://", "file:///"];
			for each (var excludedHeader:String in excludedHeaders) {
				if (rawUrl.substr(0, excludedHeader.length).toLowerCase()==excludedHeader) {
					return rawUrl;
				}
			}
			return "file:///" + rawUrl;
		}
		
		public static function getSpecifiedExtFilePathList(fileList:Array, exts:Array):Array {
			var filePaths:Array = new Array();
			for each (var file:File in fileList) {
				var filepath:String = file.nativePath;
				if(file.isDirectory)
					continue;
				for each (var ext:String in exts) {
					if (filepath.substr(filepath.length - ext.length).toLowerCase()==ext) {
						filePaths.push(filepath);
						break;
					}
				}
			}
			return filePaths;
		}
		
		public static function getSpecifiedExtPathList(pathList:Array, exts:Array):Array {
			var filePaths:Array = new Array();
			for each (var path:String in pathList) {
				for each (var ext:String in exts) {
					if (path.substr(path.length - ext.length).toLowerCase()==ext) {
						filePaths.push(path);
						break;
					}
				}
			}
			return filePaths;
		}
		
		public static function getDevelopmentSourceDirectory():String {
			var file:File = File.applicationDirectory.resolvePath(".");
			return file.nativePath + "/../src/";
		}
		
		public static function replaceRubyString(format:String, dict:*):String {
			for (var key:String in dict) {
				format = format.replace("#{" + key + "}", dict[key]);
			}
			return format;
		}
			
		public static function getFileByPath(path:String = null):File {
			try {
				return new File(path);
			} catch (error:Error) {
			}
			return new File();
		}
		
	}
}