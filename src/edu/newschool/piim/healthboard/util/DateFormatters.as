package edu.newschool.piim.healthboard.util
{
	import mx.formatters.DateFormatter;

	public class DateFormatters
	{
		public static var dateFormatter:DateFormatter = new DateFormatter();
		dateFormatter.formatString = "MMM YY";
		
		public static var dateFormatterAbbreviated:DateFormatter = new DateFormatter();
		dateFormatterAbbreviated.formatString = "MMM DD, YYYY at J:NN";
		
		public static var dateFormatterAbbreviated2:DateFormatter = new DateFormatter();
		dateFormatterAbbreviated2.formatString = "EEE, MMM DD, J:NN hrs";
		
		public static var dateFormatterDay:DateFormatter = new DateFormatter();
		dateFormatterDay.formatString = "EEE, MMM D";
		
		public static var dateFormatterYear:DateFormatter = new DateFormatter();
		dateFormatterYear.formatString = "YYYY";
		
		public static var dateFormatterToday:DateFormatter = new DateFormatter();
		
		public static var dateFormatterDayOnly:DateFormatter = new DateFormatter();
		dateFormatterDayOnly.formatString = "EEE";
		
		public static var dateFormatterTimeOnly:DateFormatter = new DateFormatter();
		dateFormatterTimeOnly.formatString = "J:NN";
		
		public static var syncTime:DateFormatter = new DateFormatter();
		syncTime.formatString = "L:NNA MM/DD/YYYY";
		
		public static var dateOnlyBackslashDelimited:DateFormatter = new DateFormatter();
		dateOnlyBackslashDelimited.formatString = "MM/DD/YYYY";
		
		public static var dateTimeShort:DateFormatter = new DateFormatter();
		dateTimeShort.formatString = "MM/DD/YYYY L:NN:SS A";
		
		public static var monthShortDayNumberYearFull:DateFormatter = new DateFormatter();
		monthShortDayNumberYearFull.formatString = "MMM D, YYYY";
		
		public static var monthFullDayNumberYearFull:DateFormatter = new DateFormatter();
		monthFullDayNumberYearFull.formatString = "MMMM D, YYYY";
	}
}