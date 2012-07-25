package editor.view.scene
{
	import editor.EditorGlobal;
	import editor.constant.EventDef;
	import editor.datatype.ReservedName;
	import editor.datatype.data.ComposedData;
	import editor.event.DataEvent;
	import editor.mgr.ResMgr;
	import editor.utils.CommonUtil;
	import editor.utils.swf.SWF;
	import editor.view.component.canvas.MainCanvas;
	import editor.view.component.canvas.PreviewCanvas;
	import editor.view.component.window.MainWindow;
	import editor.vo.ContextMenuData;
	import editor.vo.SceneLayer;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	public class EntityBaseView extends Sprite implements IDisplayElement
	{
		private static const DISPLAY_REFRESH_INTERVAL:int = 100;
		private var _vo:Object;
		private var _dataSyncTimer:Timer = new Timer(DISPLAY_REFRESH_INTERVAL, 1);
		
		private var _resKeyword:String;
		private var _rigidBody:DisplayObject;
		
		private var _indicator:Indicator;
		
		public var canSelect:Boolean;
		private var _hasSelectMouseDown:Boolean;
		
		private var _dragStartPos:Point;
		private var _layer:String;
		private var _lock:Boolean = false;
		
		public function EntityBaseView(vo:Object)
		{
			super();
			_indicator = new Indicator();
			this.addChild(_indicator);
			_vo = vo;
//			syncDataToView();
			var thisRef:EntityBaseView = this;
			this.addEventListener(MouseEvent.MOUSE_DOWN, function(evt:MouseEvent):void {
				if(!canSelect || lock)
					return;
				_hasSelectMouseDown = true;
				parentCanvas.startEntitiesDrag(thisRef);
				evt.stopPropagation();
			});
			this.addEventListener(MouseEvent.MOUSE_UP, function(evt:MouseEvent):void {
				if(!canSelect || lock)
					return;
				if(_hasSelectMouseDown)
					selected = true;
				parentCanvas.stopEntitiesDrag();
				evt.stopPropagation();
			})
		}
		
		protected function getResHandler(cls:Class):void {
			if(_rigidBody != null) {
				CommonUtil.unloadDisplay(_rigidBody);
			}
			_rigidBody = SWF.buildSymbolInstance(cls);
//			if(_rigidBody is MovieClip) {
//				(_rigidBody as MovieClip).gotoAndStop(1);
//			}
			this.addChildAt(_rigidBody, 0);
			_indicator.boundBox = _rigidBody.getBounds(this);
		}
		
		public function doAddToSceneJod():void {
			refreshContextMenu();
		}
		
		private function refreshContextMenu():void {
			EditorGlobal.APP.unregisterContextMenu(this);
			var contextMenuData:ContextMenuData = new ContextMenuData();
			var menuItems:Array = [
				{"label":"编辑", "enabled":true, "handler":editInstanceHandler}
				,{"type":"separator"}
				,{"label":"上移", "enabled":!this.lock, "handler":arrangeChangeHandler, "param":1}
				,{"label":"移到顶层", "enabled":!this.lock, "handler":arrangeChangeHandler, "param":2}
				,{"label":"下移", "enabled":!this.lock, "handler":arrangeChangeHandler, "param":-1}
				,{"label":"移到底层", "enabled":!this.lock, "handler":arrangeChangeHandler, "param":-2}
			];
			contextMenuData.menuItems = menuItems;
			EditorGlobal.APP.registerContextMenu(this, contextMenuData);
		}
		
		private function editInstanceHandler():void {
			MainWindow.editEntity(this.vo as ComposedData);
		}
		
		protected function arrangeChangeHandler(direcion:int):void {
			if(parentCanvas == null || lock)
				return;
			parentCanvas.arrangeItem(this, direcion);
		}
		
		public function doRemoveFromSceneJob():void {
			EditorGlobal.APP.unregisterContextMenu(this);
		}
		
		protected function clickHandler(evt:MouseEvent):void {
			if(canSelect) {
				selected = !selected;
				evt.stopPropagation();
			}
		}
		
		public function set layer(v:String):void {
			if(v == layer || lock)
				return;
			_layer = v;
			if(parentCanvas) {
				parentCanvas.setItemLayer(this, _layer);
			}
		}
		
		public function get layer():String {
			return _layer;
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
		
		public function get scenePos():Point {
			var parentCanvas:PreviewCanvas = this.parent as PreviewCanvas;
			if(parentCanvas)
				return parentCanvas.getItemPos(this);
			return null;
		}
		
		public function set scenePos(pos:Point):void {
			if(lock)
				return;
			var parentCanvas:PreviewCanvas = this.parent as PreviewCanvas;
			if(parentCanvas)
				parentCanvas.setItemPos(this, pos.x, pos.y);
		}
		
		public function beginDrag():Point {
			_dragStartPos = this.scenePos;
			return _dragStartPos;
		}
		
		public function endDrag():void {
			_dragStartPos = null;
			this.syncDataFromView();
		}
		
		public function get dragStartPos():Point {
			return _dragStartPos;
		}
		
		public function get vo():Object {
			return _vo;
		}
		
		public function syncDataFromView():void {
			if(_dataSyncTimer.running)
				return;
			_dataSyncTimer.addEventListener(TimerEvent.TIMER, doSyncDataFromView);
			_dataSyncTimer.start();
		}
		
		public function syncDataToView():void {
			// X and Y
			if(_vo.hasOwnProperty(ReservedName.X) && _vo.hasOwnProperty(ReservedName.Y)) {
				if(parentCanvas) {
					parentCanvas.setItemPos(this, _vo[ReservedName.X], _vo[ReservedName.Y]);
				}
			}
			
			// res
			if(_resKeyword != _vo[ReservedName.RESOURCE]) {
				_resKeyword = _vo[ReservedName.RESOURCE] as String;
				var resFileAndSymbol:Array = _resKeyword.split(" - "); 
				ResMgr.getSwfSymbolByName(EditorGlobal.APP.resLibraryWnd.baseDir + "/" + resFileAndSymbol[0], resFileAndSymbol[1] as String, getResHandler);
			}
			
			// visible
			if(_vo.hasOwnProperty(ReservedName.VISIBLE)) {
				this.visible = _vo[ReservedName.VISIBLE];
			}
			
			// layer
			if(_vo.hasOwnProperty(ReservedName.LAYER) && _vo[ReservedName.LAYER]!=layer) {
				layer = _vo[ReservedName.LAYER];
			}
		}
		
		protected function doSyncDataFromView(evt:TimerEvent):void {
			_dataSyncTimer.stop();
			if(_vo.hasOwnProperty(ReservedName.X) && _vo.hasOwnProperty(ReservedName.Y)) {
				var scenePos:Point = this.scenePos;
				_vo[ReservedName.X] = scenePos.x;
				_vo[ReservedName.Y] = scenePos.y;
			}
			
			if(_vo.hasOwnProperty(ReservedName.LAYER) && _vo[ReservedName.LAYER] != layer) {
//				if(parentCanvas)
//					parentCanvas.setItemLayer(this, layer);
				_vo[ReservedName.LAYER] = layer;
			}
		}
		
		public function get parentCanvas():MainCanvas {
			return this.parent as MainCanvas;
		}
		
		public function get lock():Boolean { return _lock; }
		public function set lock(v:Boolean):void {
			if(_lock != v) {
				_lock = v;
				refreshContextMenu();
			}
		}
	}
}