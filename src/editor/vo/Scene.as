package editor.vo
{
	import editor.EditorGlobal;
	import editor.constant.EventDef;
	import editor.datatype.ReservedName;
	import editor.datatype.data.ComposedData;
	import editor.event.DataEvent;
	import editor.utils.LogUtil;
	
	import flash.events.Event;
	import flash.utils.Dictionary;

	public class Scene extends ValueObjectBase
	{
		public var keyword:String;
		
		public var width:int;
		
		public var height:int;
		
		public var layers:Array;
		
		public var type:String;
		
		public var entities:Array;
		
		private var _layer2IndexDict:Dictionary;
		
		public function Scene(properties:Object=null)
		{
			super(properties);
			
			var template:SceneTemplate = EditorGlobal.DATA_MEMORY.getSceneTeamplate(this.type);
			for(var i:int=entities.length-1; i>=0; i--) {
				var enti:ComposedData = entities[i] as ComposedData;
				if(template.entities.indexOf(enti.templateName) < 0) {
					LogUtil.warn("{0} don't display in scene {1}, {2} will be deleted when save scene", enti.templateName, this.keyword, enti[ReservedName.KEYWORD]);
					entities.splice(i, 1);
					EditorGlobal.DATA_MEMORY.deleteEntity(enti);
				}
			}
		}
		
		public function addLayer(layer:SceneLayer):void {
			this.layers.push(layer);
			EditorGlobal.DATA_MEMORY.trySetEntity(layer.properties as ComposedData);
			EditorGlobal.MAIN_WND.dispatchEvent(new Event(EventDef.LAYER_COUNT_CHANGE));
		}
		
		public function deleteLayer(layerName:String):void {
			var layerIndex:int = getLayerIndex(layerName);
			if(layerIndex >= 0) {
				EditorGlobal.DATA_MEMORY.deleteEntity((layers[layerIndex] as SceneLayer).properties as ComposedData);
				this.layers.splice(layerIndex, 1);
				EditorGlobal.MAIN_WND.dispatchEvent(new Event(EventDef.LAYER_COUNT_CHANGE));
			}
		}
		
		private function getLayerIndex(layerName:String):int
		{
			for(var i:int=0; i<this.layers.length; i++) {
				if((this.layers[i] as SceneLayer).keyword == layerName)
					return i;
			}
			return -1;
		}		
		
		public function get template():SceneTemplate {
			return EditorGlobal.DATA_MEMORY.getSceneTeamplate(type);
		}
		
		public function hasEntity(enti:ComposedData):Boolean {
			return entities.indexOf(enti) >= 0;
		}
		
		public function getEntityCntByTemplate(templateName:String):int {
			var ret:int = 0;
			for each(var enti:ComposedData in entities) {
				if(enti.templateName == templateName)
					ret += 1;
			}
			return ret;
		}
		
		// sort all entities before save scene
		public function sortEntities():void {
			var displayEntiDict:Dictionary = new Dictionary();
			var displayEntiIndexs:Array = [];
			var otherEntiArr:Array = [];
			var index:int;
			for each(var enti:ComposedData in entities) {
				if(enti.view && enti.view.parent) {
					index = enti.view.parent.getChildIndex(enti.view);
					displayEntiIndexs.push(index);
					displayEntiDict[index] = enti;
				} else {
					otherEntiArr.push(enti);
				}
			}
			displayEntiIndexs.sort();
			entities = [];
			for each(index in displayEntiIndexs) {
				entities.push(displayEntiDict[index]);
			}
			entities = entities.concat(otherEntiArr);
		}
	}
}