package editor.mgr
{
	import editor.datatype.data.ComposedData;
	import editor.datatype.data.Reference;
	import editor.vo.SceneTemplate;
	import editor.vo.ValueObjectBase;
	
	import flash.utils.Dictionary;
	
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
		public function getEntity(keyword:String):ComposedData {
			return hasKey(keyword) ? _entitiesCache[keyword] : null;
		}
		
		/**
		 * Store an entity under a given key.
		 *  
		 * @param data entity to store
		 * @param keyword keyword under which the entity is stored
		 * @param update whether to update the entity of the given keyword if there is one in the memory already.
		 */
		public function setEntity(data:ComposedData, keyword:String, update:Boolean = false):ComposedData {
			if(data == null)
				throw new Error("can not store null");
			else if(hasKey(keyword)  == true && update == false)
				throw new Error("there is a data with keyword " + keyword + " already.");
			else {
				_entitiesCache[keyword] = data;
				_entityKeyMap[data] = keyword;
			}
			return _entitiesCache[keyword];
		}
		
		
		/**
		 * Try and add a ComposedData object to the memory using its uid as key. <p>
		 * If there is already a ComposedData object under that key in the memory, that object will be returned only 
		 * when both of the two ComposedData objects are of the same ComposedType and the existing one has not been 
		 * assigned after creation. Otherwise the existing one will be either replaced by the one passed in, or an Error
		 * will be thrown depending on the <code>update</code>
		 * parameter. 
		 * @param data ComposedData object to be added to memory
		 * @param update whether to override existing one having the same uid
		 * @return see function description
		 * 
		 */
		public function trySetEntity(data:ComposedData, update:Boolean = false):ComposedData {
			var existingData:ComposedData = getEntity(data.$uid);
			if(existingData && existingData.isNew) {
				if(existingData.$type == data.$type)
					return existingData;
				else
					throw Error("There are two ComposedData objects of different types having the same UID.");
			}
			else
				return setEntity(data, data.$uid, update);
		}
		
		public function deleteEntity(data:ComposedData):Boolean {
			var keyword:String = getKey(data);
			if(keyword != null) {
				delete _entityKeyMap[data];
				delete _entitiesCache[keyword];
				updateReferences(data.$uid);
				return true;
			}
			else
				return false;
		}
		
		private function updateReferences(uid:String):void {
			for each(var data:ComposedData in _entitiesCache) {
				clearReferenceTo(data, uid);
			}
		}
		
		private function clearReferenceTo(data:ComposedData, uid:String):void {
			for(var prop:String in data) {
				if(data[prop] is Reference && data[prop].key == uid)
					data[prop] = new Reference;
				else if(data[prop] is ComposedData)
					clearReferenceTo(data[prop], uid);
			}
			return;
		}
		
		public function hasKey(keyword:String):Boolean {
			return _entitiesCache.hasOwnProperty(keyword);
		}
		
		/**
		 * Get the keyword under which a given data has been stored, 
		 * return null if the data does not present in the memory.
		 */
		public function getKey(data:*):String {
			if(data == null || _entityKeyMap[data] == false)
				return null;
			else
				return _entityKeyMap[data];
		}
		
		/**
		 * Apply a given function to every entity stored in the memory one at a time. <p>
		 * @param fun function to apply must have the signature of: <br>
		 * <code>function(key:String, value:Object):void</code>
		 */
		public function foreach(fun:Function):void {
			if(fun == null)
				return;
			for(var key:String in _entitiesCache)
				fun.apply(_entitiesCache, [key, _entitiesCache[key]]);
			return;
		}
	}
}