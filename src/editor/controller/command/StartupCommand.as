package editor.controller.command
{
	import editor.SceneEditorApp;
	import editor.view.mediator.ApplicationMediator;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.multicore.utilities.air.desktopcitizen.DesktopCitizenConstants;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class StartupCommand extends SimpleCommand
	{
		public function StartupCommand()
		{
			super();
		}
		
		override public function execute( note:INotification ) :void	{
			
			var app:SceneEditorApp = note.getBody() as SceneEditorApp;
			facade.registerMediator(new ApplicationMediator(app));
			sendNotification( DesktopCitizenConstants.WINDOW_OPEN, app.stage );
		}
	}
}