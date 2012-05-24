package editor
{
	import editor.constant.CommandDef;
	import editor.controller.command.StartupCommand;
	
	import org.puremvc.as3.patterns.facade.Facade;
	
	public class ApplicationFacade extends Facade
	{		
		public function ApplicationFacade()
		{
			super();
		}
		
		/**
		 * Singleton ApplicationFacade Factory Method
		 */
		public static function getInstance():ApplicationFacade
		{
			if ( instance == null ) instance = new ApplicationFacade();
			return instance as ApplicationFacade;
		}
		
		override protected function initializeController():void {
			super.initializeController();
			registerCommand(CommandDef.STARTUP, StartupCommand);
		}
		
		/**
		 * The view hierarchy has been built, so start the application.
		 */
		public function startup(app:SceneEditor):void
		{
			sendNotification(CommandDef.STARTUP, app);
		}
	}
}