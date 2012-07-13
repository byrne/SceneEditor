package editor.dataeditor.util
{
	import editor.EditorGlobal;
	import editor.utils.FileSerializer;
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;

	public class VariableResolver
	{
		private static const TYPE_FILE:String = 'file';
		
		private static const PATH_APPLICATION:String = 'app';
		private static const PATH_WORKING:String = 'work';
		private static const PATH_USER:String = 'user';
		private static const PATH_DESKTOP:String = 'desktop';
		private static const PATH_DOCUMENT:String = 'doc';
		
		private static const SYMBOL_DELI:String = ':';
		private static const SYMBOL_WORKING:String = '.';
		private static const SYMBOL_APP:String = '/';
		private static const SYMBOL_LCURBRAC:String = '{';
		private static const SYMBOL_RCURBRAC:String = '}';
		
		public static function getValue(name:String):* {
			var result:* = null;
			var ios:Number = name.indexOf(SYMBOL_DELI);	// index of separation of type and path
			var type:String = TYPE_FILE;
			var path:String = name;
			if(ios != -1) {
				type = name.substr(0, ios);
				path = name.substr(ios+1);
			}
			switch(type) {
				case TYPE_FILE:
					var file:File = resolveFile(getRoot(path), getPath(path));
					if(file && file.exists) {
						var stream:FileStream = new FileStream;
						stream.open(file, FileMode.READ);
						result = stream.readUTFBytes(stream.bytesAvailable).split("\n");
					}
					break;
				default: 	// maybe we could add support for runtime variables some time? like TYPE_VAR
			}
			return result;
		}
		
		private static function getPath(path:String):String {
			var root_end:int = path.indexOf(SYMBOL_RCURBRAC);
			var relativePath:String;
			if(root_end == -1) {
				relativePath = path;
				switch(path.charAt(0)) {
					case SYMBOL_APP: 
					case SYMBOL_WORKING: relativePath = path.substr(1); break;
				}
			}
			else {
				relativePath = path.substr(root_end+1);
			}
			return path;
		}
		
		private static function getRoot(path:String):String {
			var start_pos:int = path.indexOf(SYMBOL_LCURBRAC);
			var end_pos:int = path.indexOf(SYMBOL_RCURBRAC);
			
			if(start_pos != -1 && end_pos != -1)
				return path.substring(start_pos + 1, end_pos);
			else if(path.charAt(0) == SYMBOL_APP)
				return PATH_APPLICATION;
			else if(path.charAt(0) == SYMBOL_WORKING)
				return PATH_WORKING;
			else
				return PATH_WORKING;
		}
		
		private static function resolveFile(root:String, path:String):File {
			var file:File;
			
			switch(root) {
				case PATH_APPLICATION:
					file = File.applicationDirectory.resolvePath(path);
					break;
				case PATH_DESKTOP:
					file = File.desktopDirectory.resolvePath(path);
					break;
				case PATH_DOCUMENT:
					file = File.documentsDirectory.resolvePath(path);
					break;
				case PATH_USER:
					file = File.userDirectory.resolvePath(path);
					break;
				case PATH_WORKING:
					var temp:String = EditorGlobal.APP.working_dir;
					var workingdir:File = new File(temp);
					file = workingdir.resolvePath(path);
					break;
				default:
					return null;
			}
			
			return file;
		}
	}
}
