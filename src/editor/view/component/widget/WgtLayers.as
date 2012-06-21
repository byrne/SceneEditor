package editor.view.component.widget
{
	import editor.constant.EventDef;
	import editor.event.DataEvent;
	import editor.view.component.LayerItem;
	import editor.view.mxml.skin.WgtLayersSkin;
	
	import flash.events.MouseEvent;
	
	import mx.events.FlexEvent;
	
	import spark.components.Group;
	import spark.components.Image;
	import spark.components.VGroup;
	import spark.components.supportClasses.SkinnableComponent;
	import spark.primitives.BitmapImage;
	
	public class WgtLayers extends SkinnableComponent
	{
		private static const DEFAULT_LAYER_ITEM_HEIGHT:int = 24;
		
		[SkinPart(required="true")]
		public var btnLayerNew:Image;
		
		[SkinPart(required="true")]
		public var btnLayerVisible:Image;
		
		[SkinPart(required="true")]
		public var btnLayerLock:Image;
		
		[SkinPart(required="true")]
		public var btnLayerDelete:Image;
		
		[SkinPart(required="true")]
		public var layersContainer:Group;
		
		private var _layers:Array = [];
		
		private var _crtLayer:LayerItem;
		
		private var _makeAllLayersInvisible:Boolean = true;
		private var _makeAllLayersLock:Boolean = true;
		
		public function WgtLayers()
		{
			super();
			setStyle("skinClass", WgtLayersSkin);
			this.addEventListener(FlexEvent.CREATION_COMPLETE, createCompleteHandler);
			this.addEventListener(EventDef.LAYER_ITEM_INVISIBLE_CLICK, function(evt:DataEvent):void {
				_makeAllLayersInvisible = true;
			});
			this.addEventListener(EventDef.LAYER_ITEM_LOCK_CLICK, function(evt:DataEvent):void {
				_makeAllLayersLock = true;
			});
		}
		
		protected function createCompleteHandler(evt:FlexEvent):void {
			btnLayerNew.addEventListener(MouseEvent.CLICK, function(evt:MouseEvent):void {
				addLayer();
			});	
			btnLayerVisible.addEventListener(MouseEvent.CLICK, function(evt:MouseEvent):void {
				for each(var layer:LayerItem in _layers) {
					layer.layerVisible = !_makeAllLayersInvisible;
				}
				_makeAllLayersInvisible = !_makeAllLayersInvisible;
			});	
			btnLayerLock.addEventListener(MouseEvent.CLICK, function(evt:MouseEvent):void {
				for each(var layer:LayerItem in _layers) {
					layer.layerLock = _makeAllLayersLock;
				}
				_makeAllLayersLock = !_makeAllLayersLock;
			});	
			this.addEventListener(EventDef.LAYER_ITEM_SELECT_ON, function(evt:DataEvent):void {
				selectLayer(evt.data as LayerItem);
			});
			this.addEventListener(EventDef.LAYER_ITEM_DELETE, function(evt:DataEvent):void {
				deleteLayer(evt.data as LayerItem);
			});
		}
		
		public function addLayer(name:String=null):void {
			if(name == null)
				name = "Layer "+(layersNumber+1).toString();
			var layer:LayerItem = new LayerItem();
			layer.percentWidth = 100;
			layer.height = DEFAULT_LAYER_ITEM_HEIGHT;
			layer.layerName = name;
			layersContainer.addElement(layer);
			_layers.push(layer);
			refreshLayersView();
		}
		
		public function selectLayer(layerSelect:LayerItem):void {
			for each(var layer:LayerItem in _layers) {
				if(layer != layerSelect)
					layer.layerSelected = false;
			}
		}
		
		public function deleteLayer(layer:LayerItem):void {
			var layerIndex:int = _layers.indexOf(layer);
			if(layerIndex >= 0) {
				layersContainer.removeElement(layer);
				_layers.splice(layerIndex, 1);
				refreshLayersView();
			}
		}
		
		protected function refreshLayersView():void {
			var layer:LayerItem;
			for(var index:int=0; index<layersNumber; index++) {
				layer = _layers[index] as LayerItem;
				layer.y = index * DEFAULT_LAYER_ITEM_HEIGHT;
			}
		}
		
		public function get layersNumber():int {
			return _layers.length;
		}
	}
}