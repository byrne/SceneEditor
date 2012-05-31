package editor.view.component.dialog
{
	import editor.mgr.PopupMgr;
	import editor.view.component.window.TitleWindowBase;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import spark.components.Button;
	
	public class DialogBase extends TitleWindowBase
	{
		private var btns:Array = [];
		
		public function DialogBase(title:String, showCloseBtn:Boolean=true, modal:Boolean=false)
		{
			super(title, showCloseBtn, modal);
		}
		
		public function addButton(label:String, clickHandler:Function):Button {
			var btn:Button = new Button();
			btn.label = label;
			var thisRef:* = this;
			btn.addEventListener(MouseEvent.CLICK, function(evt:MouseEvent):void {
				PopupMgr.getInstance().closeWindow(thisRef);
				clickHandler.call(null, evt);
			});
			btns.push(btn);
			this.addElement(btn);
			return btn;
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			var btnW:int = 80;
			var btnH:int = 35;
			var btnY:int = this.height * 0.8 - btnH;
			
			var marginX:int = btns.length>1 ? this.width * 0.15 : (width-btnW)*0.5;
			var intervalX:Number = btns.length>1 ? (this.width - marginX*2)/(btns.length - 1) : 0;
			for(var i:int=0; i<btns.length; i++) {
				var btn:Button = btns[i] as Button;
				btn.width = btnW;
				btn.height = btnH;
				btn.x = marginX + i*(btnW + intervalX);
				btn.y = btnY;
			}
			super.updateDisplayList(unscaledWidth, unscaledHeight);
		}
		
		override protected function createCompleteHandler(evt:Event):void {
			super.createCompleteHandler(evt);
			
		}
	}
}