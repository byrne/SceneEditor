package editor.view.scene
{
	import editor.mgr.ResMgr;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	public class EntityBaseView extends Sprite
	{
		private var _vo:Object;
		
		private var _rigidBody:DisplayObject;
		
		public function EntityBaseView(vo:Object)
		{
			super();
			_vo = vo;
			ResMgr.getSwfSymbolByName(vo["res"], "saybotmc", getResHandler);	
		}
		
		protected function getResHandler(cls:Class):void {
			_rigidBody = new cls as DisplayObject;
			this.addChild(_rigidBody);
		}
		
	}
}