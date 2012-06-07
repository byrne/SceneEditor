package editor.view.scene
{
	import editor.constant.EventDef;
	import editor.event.DataEvent;
	import editor.mgr.ResMgr;
	import editor.view.component.canvas.MainCanvas;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	public class EntityBaseView extends Sprite
	{
		private var _vo:Object;
		
		private var _rigidBody:DisplayObject;
		
		private var _indicator:Indicator;
		
		public var canSelect:Boolean;
		
		public function EntityBaseView(vo:Object)
		{
			super();
			_indicator = new Indicator();
			this.addChild(_indicator);
			_vo = vo;
			ResMgr.getSwfSymbolByName(vo["res"], "saybotmc", getResHandler);
			this.addEventListener(MouseEvent.CLICK, clickHandler);
			this.addEventListener(MouseEvent.MOUSE_DOWN, function(evt:MouseEvent):void {
				(parent as MainCanvas).startEntitiesDrag();
				evt.stopPropagation();
			});
			this.addEventListener(MouseEvent.MOUSE_UP, function(evt:MouseEvent):void {
				(parent as MainCanvas).stopEntitiesDrag();
				evt.stopPropagation();
			})
		}
		
		protected function getResHandler(cls:Class):void {
			_rigidBody = new cls as DisplayObject;
			if(_rigidBody is MovieClip) {
				(_rigidBody as MovieClip).gotoAndStop(1);
			}
			this.addChildAt(_rigidBody, 0);
			_indicator.boundBox = _rigidBody.getBounds(this);
		}
		
		protected function clickHandler(evt:MouseEvent):void {
			if(canSelect) {
				selected = !selected;
				evt.stopPropagation();
			}
		}
		
		public function get selected():Boolean {
			return _indicator.showSelector;
		}
		public function set selected(val:Boolean):void {
			if(val != _indicator.showSelector) {
				_indicator.showSelector = val;
				this.dispatchEvent(new DataEvent(val?EventDef.ENTITY_SELECT_ON:EventDef.ENTITY_SELECT_OFF, this, true));
			}
		}
		public function get showBoundBox():Boolean {
			return _indicator.showBoundBox;
		}
		public function set showBoundBox(val:Boolean):void {
			_indicator.showBoundBox = val;
		}
		
	}
}