package editor.view.component.canvas
{
	import editor.constant.ScreenDef;
	
	public class ResPreviewCanvas extends PreviewCanvas
	{
		public function ResPreviewCanvas()
		{
			super(ScreenDef.RESLIBRARY_AXIS_X_BASE, ScreenDef.RESLIBRARY_AXIS_Y_BASE);
			draggable = true;
		}
	}
}