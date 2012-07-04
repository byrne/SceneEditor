package editor.mgr
{
	import editor.datatype.impl.WeakReference;
	import editor.vo.SceneTemplate;
	import editor.vo.ValueObjectBase;
	
	import flash.utils.Dictionary;
	
	import mx.utils.UIDUtil;
	
	public class SceneDataMemory
	{
		private var _entitiesCache:Dictionary = new Dictionary;
		private var _entityKeyMap:Dictionary = new Dictionary(true);
		
		private var _sceneTemplates:Dictionary;
		
		public function SceneDataMemory() {
			super();
		}
		
		public function initializeSceneTemplates(data:Object):void {
			_sceneTemplates = new Dictionary();
			var sceneTemplatesArr:Array = data["sceneTemplate"] as Array;
			var sceneTemplate:SceneTemplate;
			for each(var st:Object in sceneTemplatesArr) {
				sceneTemplate = ValueObjectBase.translateObject2VO(st) as SceneTemplate;
				_sceneTemplates[sceneTemplate.name] = sceneTemplate;
			}
		}
		
		public function get sceneTemplates():Dictionary {
			return _sceneTemplates;
		}
		
		public function getSceneTeamplate(templateName:String):SceneTemplate {
			return _sceneTemplates[templateName] as SceneTemplate;
		}
		
		/**
		 * Get the entity stored under the given keyword,
		 * return null if nothing has been stored under this keyword.
		 */
		public function getEntity(keyword:String):* {
			return hasKey(keyword) ? _entitiesCache[keyword] : null;
		}
		
		/**
		 * Store an entity under a given key.
		 *  
		 * @param data entity to store
		 * @param keyword keyword under which the entity is stored
		 * @param update whether to update the entity of the given keyword if there is one in the memory already.
		 */
		public function setEntity(data:*, keyword:String, update:Boolean = false):void {
			if(data == null)
				throw new Error("can not store null");
			else if(hasKey(keyword)  == true && update == false)
				throw new Error("there is a data with keyword " + keyword + " already.");
			else {
				_entitiesCache[keyword] = data;
				_entityKeyMap[data] = keyword;
			}
		}
		
		public function deleteEntity(data:*):Boolean {
			var keyword:String = getKey(data);
			if(keyword != null) {
				delete _entityKeyMap[data];
				delete _entitiesCache[keyword];
				return true;
			}
			else
				return false;
		}
		
		public function hasKey(keyword:String):Boolean {
			return _entitiesCache.hasOwnProperty(keyword);
		}
		
		/**
		 * Get the keyword under which a given data has been stored, 
		 * return null if the data does not present in the memory.
		 */
		public function getKey(data:*):String {
			if(data == null || _entitiesCache.hasOwnProperty(data) == false)
				return null;
			else
				return _entityKeyMap[data];
		}
	}
}