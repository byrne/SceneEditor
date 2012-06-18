package editor.dataeditor
{
	/**
	 * A container with display features. 
	 * <p>
	 * A IFeaturedContainer provides display features such as tab, folding, and grouping, but does
	 * not take care of element layout, which shall be taken care of by its layoutContainer member.
	 * 
	 * @author Rong.Cheng
	 * 
	 */
	public interface IFeaturedContainer extends IContainer
	{
		function get layoutContainer():ILayoutContainer;
		function set layoutContainer(v:ILayoutContainer):void;
	}
}