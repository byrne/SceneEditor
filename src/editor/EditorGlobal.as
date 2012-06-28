package editor
{
	
	import editor.mgr.SceneDataMemory;
	import editor.view.component.window.MainWindow;
	
	import mx.core.FlexGlobals;

	public class EditorGlobal
	{
		public function EditorGlobal()
		{
		}
		
		public static function get APP():SceneEditorApp {
			return FlexGlobals.topLevelApplication as SceneEditorApp;
		}
		
		public static function get DATA_MEMORY():SceneDataMemory {
			return APP.dataMemory;
		}
		
		public static function get MAIN_WND():MainWindow {
			return APP.mainWnd;
		}
	}
}