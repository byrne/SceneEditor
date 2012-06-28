
package editor.utils
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.xml.XMLDocument;
	
	import mx.rpc.xml.SimpleXMLDecoder;
	import mx.rpc.xml.SimpleXMLEncoder;
	
	
	public class XMLSerializer
	{
		public static function writeXMLToFile(xml:XML, fname:String):void {
			var file:File = new File(fname);
			var fileStream:FileStream = new FileStream();
			fileStream.open(file, FileMode.WRITE);
			
			var outputString:String = '<?xml version="1.0" encoding="utf-8"?>\n';
			outputString += xml.toXMLString();
			
			fileStream.writeUTFBytes(outputString);
			fileStream.close();
		}
		
		public static function readXMLFromFile(fname:String):XML {
			var file:File = new File(fname);
			var fileStream:FileStream = new FileStream();
			fileStream.open(file, FileMode.READ);
			var xml:XML = XML(fileStream.readUTFBytes(fileStream.bytesAvailable));
			fileStream.close();
			return xml;
		}
		
		public static function writeObjectToXMLFile(object:Object, fname:String, rootTag:String="xml_root"):void
		{
			var xmlDoc:XMLDocument = new XMLDocument();
			xmlDoc.xmlDecl = '<?xml version="1.0" encoding="utf-8"?>\n';
			var encoder:SimpleXMLEncoder = new SimpleXMLEncoder(xmlDoc);
			encoder.encodeValue(object, new QName(null, rootTag), xmlDoc);
			var xml:XML = new XML(xmlDoc.toString());
			FileSerializer.writeToFile(xmlDoc.xmlDecl + xml.toString(), fname);
		}
		
		public static function readObjectFromXMLFile(fname:String, rootTag:String="xml_root"):Object
		{
			var data:String = FileSerializer.readFromFile(fname);
			var xmlDoc:XMLDocument = new XMLDocument(data);
			var decoder:SimpleXMLDecoder = new SimpleXMLDecoder(false);
			return decoder.decodeXML(xmlDoc)[rootTag];
//			return CommonUtil.translateObjectProxy(decoder.decodeXML(xmlDoc)["xml_root"]);
		}
	}
}