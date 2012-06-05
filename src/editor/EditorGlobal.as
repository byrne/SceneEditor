package editor
{
	
	import mx.core.FlexGlobals;

	public class EditorGlobal
	{
		public function EditorGlobal()
		{
		}
		
		public static function get APP():SceneEditorApp {
			return FlexGlobals.topLevelApplication as SceneEditorApp;
		}
	}
}