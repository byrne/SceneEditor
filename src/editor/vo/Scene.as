package editor.vo
{
	import editor.EditorGlobal;

	public class Scene extends ValueObjectBase
	{
		public var name:String;
		
		public var width:int;
		
		public var height:int;
		
		public var layers:Array;
		
		public var type:String;
		
		public var entities:Object;
		
		public function Scene(properties:Object=null)
		{
			super(properties);
		}
		
		public function get template():SceneTemplate {
			return EditorGlobal.DATA_MEMORY.getSceneTeamplate(type);
		}
	}
}