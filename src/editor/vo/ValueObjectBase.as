package editor.vo
{
	import flash.utils.getDefinitionByName;
	
	import mx.utils.ObjectUtil;

	public class ValueObjectBase
	{
		protected var _properties:Object;
		
		public function ValueObjectBase(properties:Object=null)
		{
			initProperties(properties);
		}
		
		private function initProperties(properties:Object):void {
			var val:*;
			var valtype:String;
			_properties = properties;
			properties = ObjectUtil.copy(_properties);
			for(var p:String in properties) {
				if(this.hasOwnProperty(p)) {
					val = properties[p];
					valtype = typeof val;
					if(valtype == "string" && (val as String).indexOf(",")>=0) {
						val = (val as String).split(",");
					} else if(val is Array) {
						for(var i:int=0; i<(val as Array).length; i++) {
							val[i] = translateObject2VO(val[i]);
						}
					} else if(valtype == "object") {
						val = translateObject2VO(val);
					}
					try {
						this[p] = val;
					} catch(e:Error) {
						this[p] = [val];
					}
				}
			}
		}
		
		public static function translateObject2VO(obj:Object):Object {
			if(!obj.hasOwnProperty("class")) {
				return obj;
			}
			var importCls:Array = [SceneTemplate, SceneLayer];
			var clsName:String = "editor.vo."+obj["class"];
			var cls:Class = getDefinitionByName(clsName) as Class;
			return new cls(obj);
		}
		
		public function clone():ValueObjectBase {
			var myClass:Class = Object(this).constructor() as Class;
			return new myClass(ObjectUtil.copy(this._properties));
		}
	}
}