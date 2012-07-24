package editor.dataeditor
{
	import mx.core.IUIComponent;
	
	/**
	 * Component used to construct data editors. <p>
	 * Our version of IUIComponent.
	 * 
	 * @author Rong.Cheng
	 * 
	 */
	public interface IElement extends IUIComponent
	{
		function reset():void;
	}
}