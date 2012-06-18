package editor.dataeditor
{
	/**
	 * Components to be used to edit values.
	 * 
	 * @author Rong.Cheng
	 * 
	 */
	public interface IEditorElement extends IElement
	{
		/**
		 * Which property to bind. Could be a property name (String), or a property chain (Array).
		 */
		function get bindingProperty():Object;
	}
}