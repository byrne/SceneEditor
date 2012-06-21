package editor.view.component.widget
{
	import editor.view.mxml.skin.WgtPanelSkin;
	
	import spark.components.supportClasses.SkinnableComponent;
	
	public class WgtPanel extends SkinnableComponent
	{
		public function WgtPanel()
		{
			super();
			this.setStyle("skinClass", WgtPanelSkin);
		}
	}
}