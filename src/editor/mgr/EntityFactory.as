package editor.mgr
{
	import editor.EditorGlobal;
	import editor.datatype.data.ComposedData;
	import editor.datatype.type.DataTypeContext;
	import editor.datatype.type.IDataType;
	
	import mx.utils.UIDUtil;

	public class EntityFactory
	{
		public function EntityFactory()
		{
		}
		
		public static function buildEntityByTemplate(templateName:String, uid:String=null):ComposedData {
			var type:IDataType = EditorGlobal.DATA_MANAGER.getType(templateName);
			if(!type)
				return null;
			var data:ComposedData = type.construct();
			data.$uid = uid!=null ? uid : UIDUtil.createUID();
			data = EditorGlobal.DATA_MEMORY.trySetEntity(data);
			return data;
		}
		
		public static function cloneEntity(enti:ComposedData):ComposedData {
			enti = enti.clone();
			enti.$uid = UIDUtil.createUID();
			enti = EditorGlobal.DATA_MEMORY.trySetEntity(enti);
			return enti;
		} 
		
		public static function buildKeyword(templateName:String, count:int):String {
			var ret:String = templateName + "_";
			count += 1;
			if(count < 10)
				ret += "00" + count.toString();
			else if(count < 100)
				ret += "0" + count.toString();
			else
				ret += count.toString();
			return ret;
		}
	}
}