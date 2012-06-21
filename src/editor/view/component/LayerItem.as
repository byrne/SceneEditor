package editor.view.component
{
	import editor.constant.EventDef;
	import editor.event.DataEvent;
	import editor.view.mxml.skin.LayerItemSkin;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	
	import spark.components.Image;
	import spark.components.TextArea;
	import spark.components.TextInput;
	import spark.components.supportClasses.SkinnableComponent;
	
	[SkinState("normal")]
	public class LayerItem extends SkinnableComponent
	{
		[SkinPart(required="true")]
		public var layerNameLabel:TextInput;
		
		[SkinPart(required="true")]
		public var btnSelected:Image;
		[SkinPart(required="true")]
		public var btnSelectedLocked:Image;
		
		[SkinPart(required="true")]
		public var btnInvisible:Image;
		[SkinPart(required="true")]
		public var btnInvisibleSelect:Image;
		[SkinPart(required="true")]
		public var btnInvisibleUnselect:Image;
		
		[SkinPart(required="true")]
		public var btnLock:Image;
		[SkinPart(required="true")]
		public var btnLockSelect:Image;
		[SkinPart(required="true")]
		public var btnLockUnselect:Image;
		
		[SkinPart(required="true")]
		public var btnDelete:Image;
		
		private var _layerName:String;
		
		private var _isLayerLock:Boolean;
		
		private var _isLayerVisible:Boolean = true;
		
		private var _isSelected:Boolean;
		
		public function LayerItem()
		{
			super();
			setStyle("skinClass", LayerItemSkin);
			this.addEventListener(FlexEvent.CREATION_COMPLETE, createCompleteHandler);
		}
		
		protected function createCompleteHandler(evt:FlexEvent):void {
			this.addEventListener(MouseEvent.CLICK, itemClickHandler);
			
			btnInvisible.addEventListener(MouseEvent.CLICK, btnClickHandler);
			btnInvisibleSelect.addEventListener(MouseEvent.CLICK, btnClickHandler);
			btnInvisibleUnselect.addEventListener(MouseEvent.CLICK, btnClickHandler);
			
			btnLock.addEventListener(MouseEvent.CLICK, btnClickHandler);
			btnLockSelect.addEventListener(MouseEvent.CLICK, btnClickHandler);
			btnLockUnselect.addEventListener(MouseEvent.CLICK, btnClickHandler);
			
			btnDelete.addEventListener(MouseEvent.CLICK, btnClickHandler);
		}
		
		protected function itemClickHandler(evt:MouseEvent):void {
			this.layerSelected = true;
		}
		
		protected function btnClickHandler(evt:MouseEvent):void {
			var btn:Image = evt.currentTarget as Image;
			switch(btn) {
				case btnLock:
					this.layerLock = false;
					this.dispatchEvent(new DataEvent(EventDef.LAYER_ITEM_LOCK_CLICK, this, true));
					break;
				
				case btnLockSelect:
				case btnLockUnselect:
					this.layerLock = true;
					this.dispatchEvent(new DataEvent(EventDef.LAYER_ITEM_LOCK_CLICK, this, true));
					break;
					
				case btnInvisible:
					this.layerVisible = true;
					this.dispatchEvent(new DataEvent(EventDef.LAYER_ITEM_INVISIBLE_CLICK, this, true));
					break;
				
				case btnInvisibleSelect:
				case btnInvisibleUnselect:
					this.layerVisible = false;
					this.dispatchEvent(new DataEvent(EventDef.LAYER_ITEM_INVISIBLE_CLICK, this, true));
					break;
				
				case btnDelete:
					this.dispatchEvent(new DataEvent(EventDef.LAYER_ITEM_DELETE, this, true));
					break;
			}
			evt.stopImmediatePropagation();
		}
		
		override protected function commitProperties():void {
			if(layerNameLabel != null && _layerName != layerNameLabel.text) {
				layerNameLabel.text = _layerName;
			}
			super.commitProperties();
		}
		
		override protected function getCurrentSkinState():String
		{
			var state:String = "";
			var hasSpecialState:Boolean = false;
			if(!_isLayerVisible) {
				state = "invisible";
				hasSpecialState = true;
			}
			if(_isLayerLock) {
				state += hasSpecialState ? "_lock" : "lock";
				hasSpecialState = true;
			}
			if(_isSelected) {
				state += hasSpecialState ? "_selected" : "selected";
				hasSpecialState = true;
			}
			return hasSpecialState ? state : "normal";
		}
		
		public function get layerName():String {
			return _layerName;
		}
		
		public function set layerName(name:String):void {
			if(name != _layerName) {
				_layerName = name;
				invalidateSkinState();
			}
		}
		
		public function get layerLock():Boolean {
			return _isLayerLock;
		}
		
		public function set layerLock(val:Boolean):void {
			if(val != _isLayerLock) {
				_isLayerLock = val;
				invalidateSkinState();
			}
		}
		
		public function get layerVisible():Boolean {
			return _isLayerVisible;
		}
		
		public function set layerVisible(val:Boolean):void {
			if(val != _isLayerVisible) {
				_isLayerVisible = val;
				invalidateSkinState();
			}
		}
		
		public function get layerSelected():Boolean {
			return _isSelected;
		}
		
		public function set layerSelected(val:Boolean):void {
			if(val != _isSelected) {
				_isSelected = val;
				invalidateSkinState();
				if(_isSelected)
					this.dispatchEvent(new DataEvent(EventDef.LAYER_ITEM_SELECT_ON, this, true));
			}
		}
	}
}