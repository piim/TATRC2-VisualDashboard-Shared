package controllers
{
	import ASclasses.Constants;
	
	import components.popups.myAppointmentsWindow;
	import components.popups.myClassesWindow;
	
	import events.ApplicationDataEvent;
	import events.ApplicationEvent;
	import events.AppointmentEvent;
	
	import external.TabBarPlus.plus.TabBarPlus;
	import external.TabBarPlus.plus.TabPlus;
	
	import flash.display.DisplayObject;
	
	import models.ApplicationModel;
	import models.modules.ImmunizationsModel;
	import models.modules.MedicalRecordsModel;
	import models.modules.MedicationsModel;
	
	import mx.core.FlexGlobals;
	import mx.events.ListEvent;
	import mx.managers.PopUpManager;
	import mx.states.State;
	
	import spark.components.Application;
	import spark.components.TitleWindow;
	
	public class Controller
	{
		[Bindable] public var appointmentsController:AppointmentsController;
		[Bindable] public var exerciseController:ExerciseController;
		[Bindable] public var immunizationsController:ImmunizationsController;
		[Bindable] public var medicalRecordsController:MedicalRecordsController;
		[Bindable] public var medicationsController:MedicationsController;
		[Bindable] public var nutritionController:NutritionController;
		[Bindable] public var vitalSignsController:VitalSignsController;
		
		[Bindable] public var model:ApplicationModel;
		
		public var application:Application;
		
		public function Controller()
		{
			appointmentsController = new AppointmentsController();
			exerciseController = new ExerciseController();
			immunizationsController = new ImmunizationsController();
			medicalRecordsController = new MedicalRecordsController();
			medicationsController = new MedicationsController();
			nutritionController = new NutritionController();
			vitalSignsController = new VitalSignsController();
			
			application = FlexGlobals.topLevelApplication as Application;
			
			application.addEventListener( ApplicationDataEvent.LOAD, onLoadDataRequest );
			application.addEventListener( ApplicationEvent.NAVIGATE, onNavigate );
			application.addEventListener( ApplicationEvent.SET_STATE, onSetState );
			application.addEventListener( AppointmentEvent.REQUEST_APPOINTMENT, onHandleAppointmentRequest );
			application.addEventListener( AppointmentEvent.REQUEST_CLASS, onHandleAppointmentRequest );
			application.addEventListener( TabPlus.CLOSE_TAB_EVENT, onTabClose );
		}
		
		protected function onLoadDataRequest(event:ApplicationDataEvent):void
		{
			loadData( event.data );
		}
		
		protected function onNavigate( event:ApplicationEvent ):void
		{
			if( event.data == 0 )
			{
				application.currentState = Constants.STATE_LOGGED_IN;
			}
		}
		
		protected function onSetState( event:ApplicationEvent ):void
		{
			for each( var states:State in application.states )
			{
				if( states.name == event.data )
				{
					application.currentState = event.data;
				}
			}
		}
		
		protected function onHandleAppointmentRequest( event:AppointmentEvent ):void 
		{
			if( event.type == AppointmentEvent.REQUEST_APPOINTMENT )
			{
				var myAppointment:myAppointmentsWindow = myAppointmentsWindow( PopUpManager.createPopUp( application, myAppointmentsWindow ) as TitleWindow );
				myAppointment.addEventListener( AppointmentEvent.VIEW_AVAILABILITY, onViewAvailability );
				
				PopUpManager.centerPopUp( myAppointment );
			}
			else
			{
				var classID:String = event.data;
				
				//if( !appointmentsController.model.initialized ) this.onApplicationStart();
				
				if( event.data == 'Gentle Chair Yoga Class' ) 
				{
					classID = 'yogaGentle';
				}
				else if( event.data == 'Nutrition Workshop') 
				{
					classID = 'hLifeWeight';
				}
				
				var evt:ApplicationEvent = new ApplicationEvent( ApplicationEvent.SET_STATE );
				evt.data = Constants.MODULE_APPOINTMENTS;
				application.dispatchEvent( evt );
				
				var myClass:myClassesWindow = myClassesWindow( PopUpManager.createPopUp( application, myClassesWindow ) as TitleWindow );
				PopUpManager.centerPopUp( myClass );
				
				if( classID ) myClass.showClass( classID );
			}
		}
		
		protected function onTabClose( event:ListEvent ):void
		{
		}
		
		protected function onViewAvailability( event:AppointmentEvent ):void
		{
			appointmentsController.setAvailable( 'set2', event.data.toString() );
		}
		
		public function loadData( id:String ):Boolean
		{
			if( id == ImmunizationsModel.ID )
			{
				if( !immunizationsController.model.dataLoaded ) 
				{
					immunizationsController.model.dataService.send();
					
					return true;
				}
			}
			else if( id == MedicationsModel.ID )
			{
				if( !medicationsController.model.dataLoaded ) 
				{
					medicationsController.model.dataService.send();
					
					return true;
				}
			}
			else if( id == MedicalRecordsModel.ID )
			{
				if( !medicalRecordsController.model.dataLoaded ) 
				{
					medicalRecordsController.model.dataService.send();
					
					return true;
				}
			}
			
			return false;
		}
	}
}