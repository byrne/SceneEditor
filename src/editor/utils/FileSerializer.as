
package editor.utils
{
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	
	public class FileSerializer
	{
		public static function writeObjectToFile(object:Object, fname:String):void
		{
			var file:File = new File(fname);
			
			var fileStream:FileStream = new FileStream();
			fileStream.open(file, FileMode.WRITE);
			fileStream.writeObject(object);
			fileStream.close();
		}
		
		public static function readObjectFromFile(fname:String):Object
		{
			var file:File = new File(fname);
			
			if(file.exists) {
				var obj:Object;
				var fileStream:FileStream = new FileStream();
				fileStream.open(file, FileMode.READ);
				obj = fileStream.readObject();
				fileStream.close();
				return obj;
			}
			return null;
		}
		
		public static function readBytesFromFile(fname:String):ByteArray
		{
			var file:File = new File(fname);
			if(file.exists) {
				var ret:ByteArray = new ByteArray();
				var obj:Object;
				var fileStream:FileStream = new FileStream();
				fileStream.open(file, FileMode.READ);
				fileStream.readBytes(ret);
				fileStream.close();
				return ret;
			}
			return null;
		}
		
		public static function writeToFile(data:*, fname:String):void
		{
			var file:File = new File(fname);
			
			var fileStream:FileStream = new FileStream();
			fileStream.open(file, FileMode.WRITE);
			if (data is String) {
				fileStream.writeUTFBytes(data);
			} else if (data is ByteArray) {
				fileStream.writeBytes(data);
			} else if (null == data) {
			} else {
				throw "data content not supported!";
			}
			fileStream.close();
		}
		
		public static function readFromFile(fname:String):String
		{
			return readFromFileHandle(new File(fname));
		}
		
		public static function readJsonFile(filename:String):Object {
			var file:File = new File("file:///" + filename);
			if (file.exists) {
				var content:String = FileSerializer.readFromFileHandle(file);
				return  CommonUtil.decodeJSON(content);
			}
			return null;
		}
		
		public static function writeJsonFile(object:Object, filename:String):void {
			var jsonStr:String = CommonUtil.encodeJSON(object);
			writeToFile(jsonStr, "file:///" + filename);
		}
		
		public static function writeListFile(arr:Array, filename:String):void {
			var file:File = new File(filename);
			var fileStream:FileStream = new FileStream();
			fileStream.open(file, FileMode.WRITE);
			var str:String;
			for(var i:int=0; i<arr.length; i++) {
				str = arr[i];
				if (str is String) {
					fileStream.writeUTFBytes(i==arr.length-1 ? str : str+"\n");
				} else {
					throw "data content not supported!";
				}	
			}
			fileStream.close();
		}
		
		public static function readFromFileHandle(file:File):String {
			if(file.exists) {
				var fileStream:FileStream = new FileStream();
				fileStream.open(file, FileMode.READ);
				var data:String = fileStream.readUTFBytes(fileStream.bytesAvailable);
				fileStream.close();
				return data;
			}
			return null;
		}
	}
}