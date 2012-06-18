package editor.dataeditor
{
	import flash.display.DisplayObject;

	/**
	 * A display component to which other display component can be added.
	 * <p>
	 * If the component implementing this interface inherits from a spark component, it shall 
	 * override the <code>addChild()</code> and <code>removeChild()</code> methods since spark 
	 * components disabled these two methods to encourage using of <code>addElement()</code> 
	 * and <code>removeElement()</code> methods.
	 * <p>  
	 * However, IContainer is not sufficent enough to be used in display, use ILayoutContainer 
	 * or IFeaturedContainer instead.
	 * 
	 * @author Rong.Cheng
	 * 
	 */
	public interface IContainer extends IElement
	{
		function addChild(child:DisplayObject):DisplayObject;
		function removeChild(child:DisplayObject):DisplayObject;
	}
}