package editor.view.component.canvas
{
	import editor.EditorGlobal;
	import editor.constant.EventDef;
	import editor.constant.ScreenDef;
	import editor.event.DataEvent;
	import editor.utils.LogUtil;
	import editor.utils.StringUtil;
	import editor.utils.keyboard.KeyBoardMgr;
	import editor.view.scene.EntityBaseView;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	
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
				entitySelectedStatusChange(evt.data as EntityBaseView, false);				
			});
			this.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			this.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
		}
		
		protected function mouseDownHandler(evt:MouseEvent):void {
			var enti:EntityBaseView;
			while(_selectedEntities.length > 0) {
				enti = _selectedEntities[0] as EntityBaseView;
				enti.selected = false;
			}
			_selectedEntities = [];
		}
		
		protected function mouseMoveHandler(evt:MouseEvent):void {
			var p:Point = this.globalToLocal(new Point(evt.stageX, evt.stageY));
			EditorGlobal.APP.cursorMessage.text = StringUtil.substitute("{0}:{1}", int(p.x - axisXbase), int(p.y - axisYbase));
		}
		
		protected function entitySelectedStatusChange(enti:EntityBaseView, val:*):void {
			var entiIndex:int = _selectedEntities.indexOf(enti);
			if(val && entiIndex<0) {
				_selectedEntities.push(enti);
			}
			if(!val && entiIndex>=0) {
				_selectedEntities.splice(entiIndex, 1);
			}
		}
		
		private var _dragTarget:EntityBaseView;
		private var _dragStartPos:Point;
		
		public function startEntitiesDrag(mouseTarget:EntityBaseView):void {
			var enti:EntityBaseView;
			if(!KeyBoardMgr.isKeyDown(Keyboard.CONTROL) && !mouseTarget.selected) {
				for(var i:int=_selectedEntities.length-1; i>=0; i--) {
					enti = _selectedEntities[i] as EntityBaseView;
					if(enti != mouseTarget)
						enti.selected = false;
				}
			}
			if(_dragTarget != null) {
				LogUtil.warn("MainCanvas already has drag target, this operation will cancel");
				return;
			}
			_dragTarget = mouseTarget;
			_dragStartPos = _dragTarget.scenePos;
			_dragTarget.addEventListener(MouseEvent.MOUSE_MOVE, dragAndMoveHandler);
			for each(enti in _selectedEntities) {
				if(enti != _dragTarget)
					enti.beginDrag();
			}
			_dragTarget.startDrag();
			LogUtil.debug("startEntitiesDrag, mouseTarget: {0}, current selected item count {1}", _dragTarget, _selectedEntities.length);
		}
		
		private function dragAndMoveHandler(evt:MouseEvent):void {
			if(_dragTarget && _dragStartPos) {
				var crtPos:Point = _dragTarget.scenePos; 
				var ox:Number = crtPos.x - _dragStartPos.x;
				var oy:Number = crtPos.y - _dragStartPos.y;
				var pos:Point;
				for each(var enti:EntityBaseView in _selectedEntities) {
					if(enti != _dragTarget) {
						pos = enti.scenePos;
						this.setItemPos(enti, enti.dragStartPos.x+ox, enti.dragStartPos.y+oy);
					}
				}
			}
		}
		
		public function stopEntitiesDrag():void {
			LogUtil.debug("stopEntitiesDrag "+_selectedEntities.length);
			for each(var enti:EntityBaseView in _selectedEntities) {
				enti.endDrag();
				if(enti == _dragTarget)
					enti.stopDrag();
			}
			_dragStartPos = null;
			_dragTarget = null;
		}
	}
}