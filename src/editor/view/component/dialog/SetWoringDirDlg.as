package editor.view.component.dialog
{
	import editor.constant.EventDef;
	import editor.constant.NameDef;
	import editor.constant.ScreenDef;
	import editor.event.DataEvent;
	import editor.storage.GlobalStorage;
	import editor.view.mxml.SelectDirectorySkin;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.core.FlexGlobals;
	
	import spark.components.Button;
	import spark.components.Label;
	
	
	public class SetWoringDirDlg extends DialogBase
	{
		protected var confirmBtn:Button;
		
		protected var selectDirView:SelectDirectorySkin;
		
		public function SetWoringDirDlg()
		{
			super(NameDef.DLG_SET_WORKING_DIR_TITLE, true, true);
			this.width = ScreenDef.DLG_SET_WORKING_DIR_W;
			this.height = ScreenDef.DLG_SET_WORKING_DIR_H;
			
			confirmBtn = this.addButton("确定", confirmBtnClickHandler);
			confirmBtn.enabled = false;
			
			selectDirView = new SelectDirectorySkin();
			selectDirView.x = 50;
			selectDirView.y = 60;
			selectDirView.addEventListener(EventDef.DIRECTORY_SELECT, function(evt:DataEvent):void {
				var dir:String = evt.data as String;
				confirmBtn.enabled = dir && dir != "";
			});
			this.addElement(selectDirView);
		}
		
		private function confirmBtnClickHandler(evt:MouseEvent):void {
			GlobalStorage.getInstance().working_dir = selectDirView.directory;
			GlobalStorage.getInstance().save();
			FlexGlobals.topLevelApplication.switchWorkspace(selectDirView.directory);
		}
	}
}