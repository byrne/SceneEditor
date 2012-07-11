package editor
{
	
	import editor.mgr.DataManager;
	import editor.mgr.SceneDataMemory;
	import editor.view.component.window.MainWindow;
	import editor.view.component.window.PropertyEditorWindow;
	
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
		
		public static function get DATA_MANAGER():DataManager {
			return APP.dataManager;
		}
		
		public static function get MAIN_WND():MainWindow {
			return APP.mainWnd;
		}
		
		public static function get PROPERTY_WND():PropertyEditorWindow {
			return APP.propertyEditor;
		}
	}
}