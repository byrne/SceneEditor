package editor.view.component.canvas
{
	import editor.constant.EventDef;
	import editor.constant.ScreenDef;
	import editor.event.DataEvent;
	import editor.view.scene.EntityBaseView;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.containers.Canvas;
	import mx.managers.DragManager;
	
	import spark.components.Label;
	
	public class MainCanvas extends PreviewCanvas
	{
		private var _fieldW:int;
		private var _fieldH:int;
		
		protected var _selectedEntities:Array = [];
		
		public function MainCanvas()
		{
			super(100, 100);
			this.gridOn = false;
			this.draggable = false;
			this.addEventListener(EventDef.ENTITY_SELECT_ON, function(evt:DataEvent):void {
				entitySelectedStatusChange(evt.data as EntityBaseView, true);				
			});
			this.addEventListener(EventDef.ENTITY_SELECT_OFF, function(evt:DataEvent):void {
				entitySelectedStatusChange(evt.data as EntityBaseView, true);				
			});
		}
		
		protected function entitySelectedStatusChange(enti:EntityBaseView, val):void {
			var entiIndex:int = _selectedEntities.indexOf(enti);
			if(val && entiIndex<0) {
				_selectedEntities.push(enti);
			}
			if(!val && entiIndex>=0) {
				_selectedEntities.splice(entiIndex, 1);
			}
		}
		
		public function startEntitiesDrag():void {
			trace("startEntitiesDrag "+_selectedEntities.length);
			for each(var enti:EntityBaseView in _selectedEntities) {
				enti.startDrag();
			}
		}
		
		public function stopEntitiesDrag():void {
			trace("stopEntitiesDrag "+_selectedEntities.length);
			for each(var enti:EntityBaseView in _selectedEntities) {
				enti.stopDrag();
			}
		}
	}
}