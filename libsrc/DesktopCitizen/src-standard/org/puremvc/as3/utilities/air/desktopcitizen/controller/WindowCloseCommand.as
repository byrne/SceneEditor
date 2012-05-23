/*
  PureMVC Utility for AS3 / AIR - Desktop Citizen
  Copyright(c) 2007-08 Cliff Hall <clifford.hall@puremvc.org>
  Your reuse is governed by the Creative Commons Attribution 3.0 License
 */
package org.puremvc.as3.utilities.air.desktopcitizen.controller
{
	import org.puremvc.as3.interfaces.*;
	import org.puremvc.as3.patterns.command.*;
	import org.puremvc.as3.utilities.air.desktopcitizen.*;
	import org.puremvc.as3.utilities.air.desktopcitizen.model.*;
	import org.puremvc.as3.utilities.air.xmldb.controller.*;

	/**
	 * Write the window metrics when the application exits
	 *
	 * <P>
	 * Persist the Desktop Citizen XML Database</P>
	 */
	public class WindowCloseCommand extends SimpleCommand
	{
		public static const NAME:String = DesktopCitizenConstants.UTIL+"WindowCloseCommand";
		
		/**
		 * Persist the DesktopCitizenDB and alert the app that the window is closed. 
		 *
		 */
		override public function execute( note:INotification ) :void	
		{
			sendNotification( PersistDataCommand.NAME, DesktopCitizenDBProxy.NAME  );
			sendNotification( DesktopCitizenConstants.WINDOW_CLOSED );
		}
		
	}
}