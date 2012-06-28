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
		 * Get the entity from a specific UID.
		 * @param uid
		 * @return 
		 * 
		 */
		public function getEntity(uid:String):* {
			var data:* = undefined;
			
			if(_entitiesCache.hasOwnProperty(uid) && _entitiesCache[uid] != null) {
				if(_entitiesCache[uid].object != null)
					data = _entitiesCache[uid].object;
				else
					delete _entitiesCache[uid];
			}
			
			return data;
		}
		
		/**
		 * Store a entity under a specific UID (a new one will be created if not specified in paramter)
		 *  
		 * @param data data to store
		 * @param uid UID associated to this data
		 * @return UID under which the data has been stored
		 * 
		 */
		public function setEntity(data:*, uid:String = null):String {
			if(data == null)
				throw new Error("can not store null");
			if(uid == null)
				uid = UIDUtil.getUID(data);
			_entitiesCache[uid] = new WeakReference(data);
			
			return uid;
		}
	}
}