package editor.utils.storage
{
	import flash.net.SharedObject;

	public class SharedObjectStorage {

		protected var so:SharedObject;
		protected var default_data:Object;
		protected var version:Number;
		
		public function SharedObjectStorage(name:String, version:Number) {
			so = SharedObject.getLocal(name);
			this.version = version;
		}

		public function read():Boolean {
			if (!default_data) {
				default_data = new Object();
				doSave(default_data);
			}
			if (checkBeforeSerialization(so.data)) {
				doRead(so.data);
				return true;
			} else {
				so.clear();
				return false;
			}
		}
		
		protected function doRead(data:Object):void {
			
		}
		
		public function readDefault():void {
			if (default_data) {
				doRead(default_data);
			}
		}
		
		public function save():void {
			so.clear();
			so.data.version = version;
			doSave(so.data);
			so.flush();
		}
		
		protected function doSave(data:Object):void {
			
		}
		
		protected function checkBeforeSerialization(data:Object):Boolean {
			return data.version==version;
		}

//		public function serializeFromFile(fname:String):void {
//			if (fname.substr(fname.length - ".xml".length).toLowerCase() == ".xml") {
//				serializeFromXMLFile(fname);
//			} else {
//				if (fname.substr(fname.length - ".sxc".length).toLowerCase() == ".sxc") {
//				} else {
//					fname += ".sxc";
//				}
//				serializeFromAMFFile(fname);
//			}
//		}
//		
//		public function serializeIntoFile(fname:String):void {
//			if (fname.substr(fname.length - ".xml".length).toLowerCase() == ".xml") {
//				serializeIntoXMLFile(fname);
//			} else {
//				serializeIntoAMFFile(fname);
//			}
//		}
//		
//		public function serializeFromAMFFile(fname:String):void {
//			var data:Object = FileSerializer.readObjectFromFile(fname);
//			if (checkBeforeSerialization(data)) {
//				for (var attr:String in so.data) {
//					so.data[attr] = data[attr];
//				}
//			}
//			restore();
//		}
//		
//		public function serializeIntoAMFFile(fname:String):void {
//			so.clear();
//			snapshot();
//			FileSerializer.writeObjectToFile(so.data, fname);
//		}
//		
//		public function serializeFromXMLFile(fname:String):void {
//			var data:Object = XMLSerializer.readObjectFromXMLFile(fname);
//			if (checkBeforeSerialization(data)) {
//				for (var attr:String in so.data) {
//					so.data[attr] = data[attr];
//				}
//			}
//			restore();
//		}
//		
//		public function serializeIntoXMLFile(fname:String):void {
//			so.clear();
//			snapshot();
//			XMLSerializer.writeObjectToXMLFile(so.data, fname);
//		}
		
	}
}