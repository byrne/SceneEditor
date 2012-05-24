/*
	Adobe Systems Incorporated(r) Source Code License Agreement
	Copyright(c) 2005 Adobe Systems Incorporated. All rights reserved.
	
	Please read this Source Code License Agreement carefully before using
	the source code.
	
	Adobe Systems Incorporated grants to you a perpetual, worldwide, non-exclusive, 
	no-charge, royalty-free, irrevocable copyright license, to reproduce,
	prepare derivative works of, publicly display, publicly perform, and
	distribute this source code and such derivative works in source or 
	object code form without any attribution requirements.  
	
	The name "Adobe Systems Incorporated" must not be used to endorse or promote products
	derived from the source code without prior written permission.
	
	You agree to indemnify, hold harmless and defend Adobe Systems Incorporated from and
	against any loss, damage, claims or lawsuits, including attorney's 
	fees that arise or result from your use or distribution of the source 
	code.
	
	THIS SOURCE CODE IS PROVIDED "AS IS" AND "WITH ALL FAULTS", WITHOUT 
	ANY TECHNICAL SUPPORT OR ANY EXPRESSED OR IMPLIED WARRANTIES, INCLUDING,
	BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
	FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  ALSO, THERE IS NO WARRANTY OF 
	NON-INFRINGEMENT, TITLE OR QUIET ENJOYMENT.  IN NO EVENT SHALL MACROMEDIA
	OR ITS SUPPLIERS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
	EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, 
	PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
	OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, 
	WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR 
	OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOURCE CODE, EVEN IF
	ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

package editor.utils
{
	import flash.utils.Dictionary;
	
	public class DictionaryUtil
	{
		
		/**
		*	Returns an Array of all keys within the specified dictionary.	
		* 
		* 	@param d The Dictionary instance whose keys will be returned.
		* 
		* 	@return Array of keys contained within the Dictionary
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/					
		public static function getKeys(d:Dictionary):Array
		{
			var a:Array = new Array();
			
			for (var key:Object in d)
			{
				a.push(key);
			}
			
			return a;
		}
		
		/**
		*	Returns an Array of all values within the specified dictionary.		
		* 
		* 	@param d The Dictionary instance whose values will be returned.
		* 
		* 	@return Array of values contained within the Dictionary
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/					
		public static function getValues(d:Dictionary):Array
		{
			var a:Array = new Array();
			
			for each (var value:Object in d)
			{
				a.push(value);
			}
			
			return a;
		}
		
		public static function clear(d:Dictionary):void {
			for (var key:Object in d)
			{
				delete d[key];
			}
		}
		
		/**
		 * Merges two dictionary.
		 * @param dict1 Dictionary to be merged with dict2.
		 * @param dict2 Dictionary to be merged with dict1.
		 * @param dict1Reserved If true, dict1's value will be reserved when dict1 encounters same key as dict2. While false, dict2's instead.
		 * @return Dictionary The outcoming dictionary after merged.
		 * 
		 */		
		public static function merge(dict1:Dictionary, dict2:Dictionary, dict1Reserved:Boolean = true) : Dictionary
		{
			var dict:Dictionary;
			var key:Object;
			if(dict1Reserved)
			{
				dict = DictionaryUtil.duplicate(dict2);
				for(key in dict1)
				{
					dict[key] = dict1[key];
				}
			}
			else
			{
				dict = DictionaryUtil.duplicate(dict1);
				for(key in dict2)
				{
					dict[key] = dict2[key];
				}
			}
			return dict;
		}
		
		/**
		 * Generate a copy of the source dictionary.
		 * @param source Dcitionary as the source.
		 * @return Dictionary The copy.
		 * 
		 */		
		public static function duplicate(source:Dictionary) : Dictionary
		{
			var copy:Dictionary = new Dictionary();
			for(var key:Object in source)
			{
				copy[key] = source[key];
			}
			return copy;
		}
		
	}
}