package editor.vo
{
	import editor.EditorGlobal;
	
	import mx.utils.ObjectUtil;

	public class SceneTemplate extends ValueObjectBase
	{
		public var name:String;
		
		public var width:int;
		
		public var height:int;
		
		public var layers:Array;
		
		public var entities:Array;
		
		public function SceneTemplate(properties:Object=null)
		{
			super(properties);
		}
		
		public function buildScene(name:String=null):Scene {
			var properties:Object = ObjectUtil.copy(this._properties);
			properties.type = this.name;
			properties.name = name ? name : "untitled";
			var scene:Scene = new Scene(properties);
			return scene;
		}
		
	}
}