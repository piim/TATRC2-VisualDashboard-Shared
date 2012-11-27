package models
{
	import enum.ColorSchemeType;
	import enum.DateFormatType;
	import enum.TimeFormatType;
	import enum.UnitType;
	import enum.ViewModeType;
	
	import flash.utils.describeType;
	
	import mx.collections.ArrayCollection;

	public class Preferences
	{
		//	general
		public var colorScheme:String = ColorSchemeType.BLACK;
		public var dateFormat:String = DateFormatType.FORMAT_1;
		public var fontSize:int = 0;
		public var language:String = "en_US";
		public var restrictedModules:ArrayCollection;
		public var timeFormat:String = TimeFormatType.FORMAT_1;
		public var timeZone:String = "EST";
		public var unit:String = UnitType.AMERICAN;
		public var viewMode:String = ViewModeType.BUTTON;
		
		//	security
		public var autoLockIntervalMinutes:Number = 5;	//	minutes
		
		public function Preferences()
		{
		}
		
		[Bindable]
		public function setPasswordRequiredForModule( id:String, required:Boolean ):void
		{
			if( required && (!restrictedModules || restrictedModules.getItemIndex( id ) == -1 ) )
			{
				if( !restrictedModules ) restrictedModules = new ArrayCollection();
				
				restrictedModules.addItem( id );
			}
			else if( !required && restrictedModules && restrictedModules.getItemIndex( id ) > -1 )
			{
				restrictedModules.removeItemAt( restrictedModules.getItemIndex( id ) );
			}
		}
		
		[Bindable]
		public function getPasswordRequiredForModule( id:String ):Boolean
		{
			return restrictedModules && restrictedModules.getItemIndex( id ) > -1;
		}
		
		public function clone():Preferences
		{
			var val:Preferences = new Preferences();
			
			var definition:XML = describeType(this);
			
			for each(var prop:XML in definition..accessor)
			{
				if( prop.@access == "readonly" ) continue;
				
				val[prop.@name] = this[prop.@name];
			}
			
			return val;
		}
		
		public function copy( from:Preferences ):void
		{
			var definition:XML = describeType(this);
			
			for each(var prop:XML in definition..accessor)
			{
				if( prop.@access == "readonly" ) continue;
				
				this[prop.@name] = from[prop.@name];
			}
		}
	}
}