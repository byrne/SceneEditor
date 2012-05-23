package editor.view.mediator
{
	import editor.SceneEditorApp;
	import editor.constant.MediatorDef;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.multicore.utilities.air.desktopcitizen.DesktopCitizenConstants;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class ApplicationMediator extends Mediator
	{
		public function ApplicationMediator(viewComponent:Object=null)
		{
			super(MediatorDef.APPLICATION, viewComponent);
		}
		
		public function get app():SceneEditor {
			return this.viewComponent as SceneEditor;
		}
		
		override public function listNotificationInterests():Array {
			return [
				DesktopCitizenConstants.WINDOW_OPEN
			];
		}
		
		override public function handleNotification(notification:INotification):void {
			switch(notification.getName()) {
				case DesktopCitizenConstants.WINDOW_OPEN:
					app.initializeViews();
					break;
				
				default:
					trace("aa");
			}
		}
	}
}