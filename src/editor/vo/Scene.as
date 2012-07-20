package editor.vo
{
	import editor.EditorGlobal;
	import editor.datatype.data.ComposedData;
	
	import flash.utils.Dictionary;

	public class Scene extends ValueObjectBase
	{
		public var keyword:String;
		
		public var width:int;
		
		public var height:int;
		
		public var layers:Array;
		
		public var type:String;
		
		public var entities:Array;
		
		public function Scene(properties:Object=null)
		{
			super(properties);
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