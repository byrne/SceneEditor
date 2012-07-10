package editor.mgr
{
	import editor.dataeditor.impl.ComponentPool;
	import editor.dataeditor.impl.EditorBase;
	import editor.datatype.type.*;
	
	import flash.utils.Dictionary;

	public class DataManager
	{
		public static const TYPE_INT:String = 'int';
		public static const TYPE_FLOAT:String = 'number';
		public static const TYPE_ARRAY:String = 'array';
		public static const TYPE_STRING:String = 'string';
		public static const TYPE_BOOLEAN:String = 'boolean';
		public static const TYPE_UNDEFINED:String = 'undefined';
		
		public function get types():DataTypeContext { return _typeContext; }
		private var _typeContext:DataTypeContext;
		
		private var _editors:Dictionary;
		
		public function DataManager() {
		}
		
		/**
		 * Initialize DataType Context with a piece of type definition document, and an initialization function.
		 * <p>
		 * @param typeDef a document of any form in which DataTypes are defined.
		 * @param initFunction a function which extracts DataTypes out of a definition document to a DataTypeContext,<br>
		 * takes two arguments: 1. typeDef, 2. a DataTypeContext object inwhich DataType objects to be stored, and returns no value.
		 * 
		 */
		public function initTypes(typeDef:Object, initFunction:Function):void {
			_typeContext = new DataTypeContext();
			_typeContext[TYPE_INT] = new IntType(TYPE_INT);
			_typeContext[TYPE_FLOAT] = new NumberType(TYPE_FLOAT);
			_typeContext[TYPE_BOOLEAN] = new BooleanType(TYPE_BOOLEAN);
			_typeContext[TYPE_STRING] = new StringType(TYPE_STRING);
			_typeContext[TYPE_ARRAY] = new ArrayType(TYPE_ARRAY);
			
			initFunction.apply(this, [typeDef, _typeContext]);
		}
		
		/**
		 * Initialize DataEditor Context with a piece of editor component definition document, and an initialization
		 * function.
		 * <p> 
		 * @param editorDef a document of any form in which Editors are defined.
		 * @param ctx a DataTypeContext containing all the DataTypes used in Editors
		 * @param initFunction a function which extracts Editor out of a definition document to a DataTypeContext,<br>
		 * takes two arguments: 1. editorDef, 2. ctx - the DataTypeContext. 3. a Dictionary inwhich Editor objects to
		 * be stored, and returns no value.
		 * 
		 */
		public function initEditors(editorDef:Object, ctx:DataTypeContext, initFunction:Function):void {
			_editors = new Dictionary();
			for (var name:String in ComponentPool.POOL)
				_editors[name] = ComponentPool.POOL[name];
			initFunction.apply(this, [editorDef, ctx, _editors]);
		}
		
		public function getType(typename:String):IDataType {
			return types[typename];
		}
		
		public function getEditorByName(editorname:String):EditorBase {
			return _editors[editorname];
		}
		
		public function getEditorByType(typename:String):EditorBase {
			return null;
		}
	}
}