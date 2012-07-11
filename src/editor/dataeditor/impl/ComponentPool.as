package editor.dataeditor.impl
{
	import editor.dataeditor.elements.*;
	import editor.dataeditor.elements.container.featured.*;
	import editor.dataeditor.elements.container.layout.*;
	
	import flash.utils.Dictionary;

	/**
	 * Maintain a name resolution, also make sure every element is linked into the executable. 
	 * <p>
	 * Whenever a new component class is added, you will also need to add an entry for it in here,
	 * otherwise this new component will not be available to the user.
	 * 
	 * @author Rong.Cheng
	 * 
	 */
	public class ComponentPool
	{
		public function ComponentPool() {
		}
		
		public static const POOL:Object = {
			'CheckBox': CheckBox,
			'HSlider': HSlider,
			'ItemSelector': ItemSelector,
			'NumericStepper': NumericStepper,
			'Panel': Panel,
			'SingleLineText': SingleLineText,
			'VLayout': VLayout,
			'HLayout': HLayout,
			'VSlider': VSlider,
			'Form': Form,
			'TitleWindow': TitleWindow,
			'Accordion': Accordion,
			'AccordionContent': AccordionContent,
			'TabNavigator': TabNavigator
		};
	}
}