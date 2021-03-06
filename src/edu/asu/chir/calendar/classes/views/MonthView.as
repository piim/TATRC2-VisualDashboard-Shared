package edu.asu.chir.calendar.classes.views
{
	import edu.newschool.piim.healthboard.Constants;
	
	import edu.newschool.piim.healthboard.view.components.appointments.monthViewLinkButton;
	
	import edu.newschool.piim.healthboard.enum.AppointmentType;
	
	import edu.newschool.piim.healthboard.events.AppointmentEvent;
	
	import edu.asu.chir.calendar.classes.events.CustomEvents;
	import edu.asu.chir.calendar.classes.model.DataHolder;
	import edu.asu.chir.calendar.classes.utils.CommonUtils;
	import edu.asu.chir.calendar.mxml_views.monthCell;
	
	import flash.events.MouseEvent;
	
	import edu.newschool.piim.healthboard.model.module.appointments.PatientAppointment;
	
	import mx.containers.ApplicationControlBar;
	import mx.containers.Canvas;
	import mx.containers.Grid;
	import mx.containers.GridItem;
	import mx.containers.GridRow;
	import mx.containers.HBox;
	import mx.controls.Alert;
	import mx.controls.Button;
	import mx.controls.Label;
	import mx.controls.LinkButton;
	import mx.managers.PopUpManager;
	import mx.utils.ObjectUtil;
	
	import edu.newschool.piim.healthboard.view.skins.appointments.ToggleableLinkButtonSkin;
	
	import spark.components.TitleWindow;
	
	import edu.newschool.piim.healthboard.util.DateUtil;
	
	/**
	 * THIS CLASS WILL ALLOW TO GENERATE A GRID OF CURRENT MONTH
	 *
	 * THIS CLASS USES monthCell TO REPRESENT A SINGLE DAY.
	 *
	 * ADDITIONALLY IT CONNECTS WITH DATA HOLDER AND CHECK FOR EVENT EXISTENSE FOR A PARTICULAR
	 * DATE AND GENERATE THE VIEW ACCORDINGLY.
	 *
	 * THIS CLASS IS EXTENDED TO CANVAS SO IT COULD BE USED A DISPLAY OBJECT IN MXML FILES AS WELL.
	 */
	
	public class MonthView extends Canvas
	{
		
		private var m_intCurrentMonth:int;
		private var m_intCurrentYear:int;
		
		private var m_monthViewGrid:Grid;
		private var m_appBar:ApplicationControlBar
		private var m_lblDaysNames:Label;
		private var m_monthName:Label;		//added DB
		
		public function MonthView()
		{
			super();
			createIntialChildren();
		}
		
		// function responsible for generating the view
		private function createIntialChildren():void
		{
			// add a new grid
			m_monthViewGrid = new Grid();
			m_monthViewGrid.styleName = "grdMonthView";
			m_monthViewGrid.y = 55;
			
			// add application bar which will show days name on the top of the view
			m_appBar = new ApplicationControlBar();
			m_appBar.width = 800;
			m_appBar.height = 22;
			m_appBar.styleName = "appBarDayCell";
			
			m_lblDaysNames = new Label();
			m_lblDaysNames.y = 33;
			m_lblDaysNames.width = 775;
			m_lblDaysNames.height = 16;
			m_lblDaysNames.styleName = "lblDaysNames";
			m_lblDaysNames.text = "            Sunday                        Monday                       Tuesday                    Wednesday                   Thursday                        Friday                        Saturday";
			
			m_monthName = new Label();
			m_monthName.styleName = "subtitles";
			m_monthName.horizontalCenter = 0;
			m_monthName.y = 2;
			
			this.addChild(m_monthName);
			this.addChild(m_lblDaysNames);
			this.addChild(m_monthViewGrid);
		}
		
		override protected function updateDisplayList(unscaledWidth:Number,
													  unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
		}
		
		// create grid of days in current month as per current date provided
		public function redraw():void
		{
			// always assume that first day of a month will have date as 1
			// currentMonth and currentYear are supplied by main.mxml file
			var objDate:Date = new Date(currentYear, currentMonth, 1);
			
			// get total days count for currentMonth in currentYear
			var intTotalDaysInMonth:int = CommonUtils.getDaysCount(currentMonth, currentYear);
			var i:int;
			
			m_monthName.text = getMonthName(objDate.month) + " " + currentYear;
			
			/**
			 * Add Total number of Grid items in a Array
			 *
			 **/
			
			// add empty items in case first day is not Sunday
			// i.e. MonthView always shows 7 columns starting from Sunday and ending to Saturday
			// so if it suppose Wednesday is the date 1 of this month that means we need to
			// add 3 empty cells at start
			var arrDays:Array = new Array();
			for(i=0; i<objDate.getDay(); i++)
			{
				arrDays.push(-1);
			}
			
			// now loop through total number of days in this month and save values in array
			for(i=0; i<intTotalDaysInMonth; i++)
			{
				var objDate1:Date = new Date(currentYear, currentMonth, (i+1));
				var strStartDayName:String = CommonUtils.getDayName(objDate1.getDay());
				arrDays.push({data:i+1, label:strStartDayName});
			}
			
			// if first day of the month is Friday and it is not a leap year then we need to show 7 rows
			// there could be max 42 items in a calendar grid for a month with 6 rows
			// so add blank values in case still some cells are pending as per count of 7 cols x 6 rows = 42
			if(objDate.getDay() >= 5 && arrDays.length <= 32)
			{
				for(i=arrDays.length; i<42; i++)
				{
					arrDays.push(-1);
				}
			}
			else
			{
				for(i=arrDays.length; i<35; i++)
				{
					arrDays.push(-1);
				}
			}
			
			m_monthViewGrid.removeAllChildren();
			
			var objGridRow:GridRow;
			
			// once array is created now loop through the array and generate the Grid
			var cellHeight:int = arrDays.length == 35 ? 106 : 88;
			for(i=0; i<arrDays.length; i++)
			{
				if(i % 7 == 0)
				{
					objGridRow = new GridRow();
					m_monthViewGrid.addChild(objGridRow);
				}
				
				var objGridItem:GridItem = new GridItem();
				var objDayCell:monthCell = new monthCell();
				
				var myCount:uint = 1;
				
				objDayCell.height = cellHeight;
				
				objGridItem.addChild(objDayCell);
				objGridRow.addChild(objGridItem);
				
				//objDayCell.txtDesc.visible = false;
				
				if(arrDays[i] == -1) //if it's one of the "empty days" (either before or after the 28-31 days in the month)
				{
					objDayCell.canHeader.visible = false;		//COMMENTING THIS LINE OUT WAS CREATING THE ERROR THAT THE DAYS DON'T SHOW PROPERLY...	
					//objDayCell.visible = false;
				}
				else
				{
					objDayCell.lblDate.text = arrDays[i].data;
					//objDayCell.addEventListener(MouseEvent.CLICK, onDayCellClick);	//commented out DB
					objDayCell.data = {date: new Date(currentYear, currentMonth, arrDays[i].data)};
					
					var today:Date = new Date();
					today.setHours(0,0,0,0);
					if(DateUtil.dateCompare(today,objDayCell.data.date)) {
						objDayCell.lblDate.styleName = "calendarSelectedDay";
						objDayCell.styleName = "calendarSelectedCell";
					}

					// check if current date has some event stored in DataHolder
					// if YES then display event description
					for(var j:int=0; j<DataHolder.getInstance().dataProvider.length; j++)
					{
						var obj:PatientAppointment = DataHolder.getInstance().dataProvider[j];
						
						if(DateUtil.dateCompare(obj.date, objDayCell.data.date)) 
						{
							var myLinkButton:LinkButton = new monthViewLinkButton();
							myLinkButton.data = obj;
							myLinkButton.label = (obj.meridiem != "pm" ? obj.hour : int(obj.hour) + 12) + ":" + (obj.mins == 0 ? '00' : obj.mins) + " " + (obj.type == AppointmentType.MEDICAL ? obj.provider.lastNameAbbreviated : obj.description);
							myLinkButton.selected = obj.selected;
							myLinkButton.top = 25 + 15*(myCount-1);	//	here we're setting the top margin equal to 25, 40, 55, 70, etc respectively...
							myLinkButton.addEventListener( MouseEvent.CLICK, onLinkClick );
							objDayCell.addChild(myLinkButton);
							
							myCount++;
						}
					}
				}
			}
		}
		
		/**
		 * Custom Properties
		 *
		 **/
		public function set currentMonth(_intCurrentMonth:int):void
		{
			m_intCurrentMonth = _intCurrentMonth;
			
			redraw();
		}
		
		public function get currentMonth():int
		{
			return m_intCurrentMonth;
		}
		
		public function set currentYear(_intCurrentYear:int):void
		{
			m_intCurrentYear = _intCurrentYear;
			
			redraw();
		}
		
		public function get currentYear():int
		{
			return m_intCurrentYear;
		}
		
		private function onLinkClick( event:MouseEvent ):void
		{
			var evt:AppointmentEvent = new AppointmentEvent( AppointmentEvent.VIEW_CLASS, true );
			evt.data = LinkButton(event.currentTarget).data;
			dispatchEvent( evt );	
		}
		
		/*DB*/
		private function getMonthName(month:int):String 
		{
			return Constants.MONTHS[month];
		}
	}
}
