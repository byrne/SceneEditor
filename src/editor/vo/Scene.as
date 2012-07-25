package editor.vo
{
	import editor.EditorGlobal;
	import editor.datatype.ReservedName;
	import editor.datatype.data.ComposedData;
	import editor.utils.LogUtil;
	
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
			updateLayer2IndexDict();
		}
		
		private function updateLayer2IndexDict():void {
			_layer2IndexDict = new Dictionary();
			for(var i:int=0; i<layers.length; i++) {
				_layer2IndexDict[(layers[i] as SceneLayer).keyword] = i;
			}
		}
		
		public function addLayer(layer:SceneLayer):void {
			this.layers.push(layer);
			updateLayer2IndexDict();
			EditorGlobal.DATA_MEMORY.trySetEntity(layer as ComposedData);
		}
		
		public function deleteLayer(layerName:String):void {
			var layerIndex:int = getLayerIndex(layerName);
			if(layerIndex >= 0) {
				EditorGlobal.DATA_MEMORY.deleteEntity(layers[layerIndex] as ComposedData);
				this.layers.splice(layerIndex, 1);
				updateLayer2IndexDict();
			}
		}
		
		public function getLayerIndex(layerName:String):int {
			if(_layer2IndexDict.hasOwnProperty(layerName))
				return _layer2IndexDict[layerName] as int;
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