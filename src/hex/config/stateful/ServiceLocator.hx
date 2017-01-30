package hex.config.stateful;

import hex.collection.HashMap;
import hex.collection.Locator;
import hex.config.stateful.IStatefulConfig;
import hex.di.IDependencyInjector;
import hex.error.IllegalArgumentException;
import hex.error.NoSuchElementException;
import hex.event.CompositeDispatcher;
import hex.event.IDispatcher;
import hex.module.IModule;
import hex.service.IService;
import hex.service.stateful.IStatefulService;

/**
 * ...
 * @author Francis Bourre
 * 
 * This class is deprecated. Use hex.ioc.di.MappingConfiguration class instead
 */
class ServiceLocator extends Locator<String, ServiceLocatorHelper> implements IStatefulConfig
{
	var _mapping = new HashMap<Class<Dynamic>, Dynamic>();
	
	public function new() 
	{
		super();
	}
	
	public function getService<ServiceType>( type : Class<ServiceType>, name : String = "" ) : ServiceType
	{
		var helper : ServiceLocatorHelper;

		if ( name.length > 0 )
		{
			helper = this.locate( name + "#" + Type.getClassName( type ) );
		}
		else
		{
			helper = this.locate( Type.getClassName( type ) );
		}

		var service : Dynamic = helper.value;

		if ( Std.is( service, Class ) )
		{
			service = Type.createInstance( service, [] );
		}

		if ( Std.is( service, IService ) )
		{
			return service;

		} else
		{
			throw new NoSuchElementException( this + ".getService failed to retrieve service with key '" + type + "'" );
		}
	}
	
	public function configure( injector : IDependencyInjector, dispatcher : IDispatcher<{}>, module : IModule ) : Void
	{
		var keys = this.keys();
        for ( className in keys )
        {
			var separatorIndex 	: Int = className.indexOf("#");
			var serviceClassKey : Class<Dynamic>;

			if ( separatorIndex != -1 )
			{
				serviceClassKey = Type.resolveClass( className.substr( separatorIndex+1 ) );
			}
			else
			{
				serviceClassKey = Type.resolveClass( className );
			}

			var helper 	: ServiceLocatorHelper 	= this.locate( className );
			var service : Dynamic = helper.value;

			if ( Std.is( service, Class ) )
			{
				injector.mapToType( serviceClassKey, service, helper.mapName );
			}
			else if ( Std.is( service, IStatefulService ) )
			{
				var serviceDispatcher : CompositeDispatcher = ( cast service ).getDispatcher();
				if ( serviceDispatcher != null )
				{
					serviceDispatcher.add( dispatcher );
				}

				injector.mapToValue( serviceClassKey, service, helper.mapName );
			}
			else
			{
				throw new IllegalArgumentException( "Mapping failed on '" + service + "' This instance is not a stateful service nor a service class." );
			}
			
			this._mapping.put( serviceClassKey, service );
		}
	}
	
	public function addService( service : Class<Dynamic>, value : Dynamic, ?mapName : String = "" ) : Bool
	{
		//TODO check 'service' class extends Class<IService<ServiceConfiguration>>
		return this._registerService( service, new ServiceLocatorHelper( value, mapName ), mapName );
	}
	
	public function getMapping() : HashMap<Class<Dynamic>, Dynamic>
	{
		return this._mapping;
	}
	
	function _registerService( type : Class<Dynamic>, service : ServiceLocatorHelper, ?mapName : String = "" ) : Bool
	{
		//TODO check 'type' class extends Class<IService<ServiceConfiguration>>
		var className : String = ( mapName != "" ? mapName + "#" : "" ) + Type.getClassName( type );
		return this.register( className, service );
	}
}

private class ServiceLocatorHelper
{
	public var value	: Dynamic;
	public var mapName	: String;

	public function new( value : Dynamic, mapName : String  )
	{
		this.value 		= value;
		this.mapName 	= mapName;
	}
	
	public function toString() : String
	{
		return 'ServiceLocatorHelper( value:$value, mapName:$mapName )';
	}
}