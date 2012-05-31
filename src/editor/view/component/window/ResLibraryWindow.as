package editor.view.component.window
{
	import editor.constant.NameDef;
	import editor.constant.ScreenDef;
	import editor.mgr.ResMgr;
	import editor.utils.CommonUtil;
	import editor.utils.FileSerializer;
	import editor.utils.LogUtil;
	import editor.view.component.canvas.PreviewCanvas;
	import editor.view.component.canvas.ResPreviewCanvas;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	import mx.containers.Canvas;
	import mx.containers.DividedBox;
	import mx.containers.TabNavigator;
	import mx.controls.Tree;
	import mx.core.IVisualElement;
	import mx.core.UIComponent;
	import mx.events.CloseEvent;
	import mx.events.ListEvent;

	public class ResLibraryWindow extends TitleWindowBase
	{
		private var _configFile:String;
		
		private var baseDir:String;
		
		private var tabNavi:TabNavigator;
		
		private var previewField:ResPreviewCanvas;
		
		private var resTreeXML:XML;
		private var resTree:Tree;
		
		private var curPreviewItem:DisplayObject;
		
		public function ResLibraryWindow()
		{
			super(NameDef.WND_RES_LIBRARY);
			var dividedBox:DividedBox = new DividedBox();
			dividedBox.direction = "horizontal";
			dividedBox.percentWidth = 100;
			dividedBox.percentHeight = 100;
			
			resTree = new Tree();
			resTree.percentWidth = ScreenDef.RESLIBRARY_TREE_W_PERCENT;
			resTree.percentHeight = 100;
//			resTree.dataProvider = resTreeXML;
			resTree.labelField = "@label";
			resTree.showRoot = false;
			resTree.addEventListener(ListEvent.ITEM_CLICK, resTreeClickHandler);
			dividedBox.addElement(resTree);
			
			previewField = new ResPreviewCanvas();
			previewField.percentWidth = 100 - ScreenDef.RESLIBRARY_TREE_W_PERCENT;;
			previewField.percentHeight = 100;
			dividedBox.addElement(previewField);
			
			this.addElement(dividedBox);
		}
		
		public function set configFile(fn:String):void {
			if(_configFile != fn) {
				_configFile = fn;
				var allRes:Object = FileSerializer.readJsonFile(_configFile);
				baseDir = allRes["base_dir"];
				resTreeXML = buildResTreeXML(allRes["symbol_classes"]);
				
				clearPreview();
				resTree.dataProvider = resTreeXML;
			}
		}
		
		override protected function createCompleteHandler(evt:Event):void {
			super.createCompleteHandler(evt);
		}
		
		private function resTreeClickHandler(evt:ListEvent):void {
			var tree:Tree = evt.target as Tree;
			var selectXML:XML = tree.selectedItem as XML;
			var isLeaf:Boolean = selectXML.@["leaf"] == true;
			if(isLeaf) {
				var swfFile:String = baseDir + "/" + selectXML.@["path"];
				var symbol:String = selectXML.@["label"];
				LogUtil.debug("select {0} {1}", swfFile, symbol);
				ResMgr.getSwfSymbolByName(swfFile, symbol, function(cls:Class):void {
					var previewItem:DisplayObject = new cls as DisplayObject;
					refreshPreview(previewItem);
				});
			}
		}
		
		override public function onClose(evt:CloseEvent=null):void {
			clearPreview();
			super.onClose(evt);
		}
		
		public function clearPreview():void {
			previewField.removeAllItems();
			curPreviewItem = null;
		}
		
		private function refreshPreview(item:DisplayObject):void {
			clearPreview();
			previewField.addItem(item);
			curPreviewItem = item;
		}
		
		private function buildResTreeXML(sourceData:Object):XML {
			var treeObj:Object = new Object();
			var key:String;
			var depthArr:Array;
			for(key in sourceData) {
				depthArr =key.split("/");
				var curDepthObj:Object = treeObj;
				for(var i:int=0; i<depthArr.length-1; i++) {
					var curPath:String = depthArr[i] as String;
					if(!curDepthObj.hasOwnProperty(curPath))
						curDepthObj[curPath] = new Object();
					curDepthObj = curDepthObj[curPath];
				}
				var swfName:String = depthArr[depthArr.length-1] as String;
				curDepthObj[swfName] = sourceData[key] as Array;
			}
			
			var ret:XML = convertObj2XML(treeObj);
			return ret;
		}
		
		private function convertObj2XML(obj:Object, label:String=null, fullPath:String=null):XML {
			var xml:XML = <node/>;
			var child:Object;
			var key:String;
			if(obj is String) {
				xml.@["label"] = obj as String;
				xml.@["leaf"] = true;
				xml.@["path"] = fullPath;
			} else if(obj is Array) {
				xml.@["label"] = label!=null ? label : "root";
				xml.@["leaf"] = false;
				xml.@["path"] = fullPath ? fullPath : "";
				for each(child in obj) {
					xml.appendChild(convertObj2XML(child, null, fullPath));
				}
			} else {
				xml.@["label"] = label!=null ? label : "root";
				xml.@["leaf"] = false;
				xml.@["path"] = fullPath ? fullPath : "";
				var keys:Array = [];
				for(key in obj) {
					keys.push(key);
				}
				keys.sort();
				for each(key in keys) {
					child = obj[key];
					xml.appendChild(convertObj2XML(child, key, fullPath ? fullPath+"/"+key : key));
				}
			}
			return xml;
		}
	}
}