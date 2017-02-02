package hex.service;

import hex.di.IInjectorContainer;
import hex.error.VirtualMethodException;
import hex.event.MessageType;
import hex.service.IService;
import hex.service.ServiceConfiguration;

/**
 * ...
 * @author Francis Bourre
 */
class AbstractService implements IService implements IInjectorContainer
{
	var _configuration : ServiceConfiguration;
	
	function new() 
	{
		
	}

	public function getConfiguration() : ServiceConfiguration
	{
		return this._configuration;
	}
	
	@PostConstruct
	public function createConfiguration() : Void
	{
		throw new VirtualMethodException();
	}
	
	public function setConfiguration( configuration : ServiceConfiguration ) : Void
	{
		throw new VirtualMethodException();
	}
	
	public function addHandler( messageType : MessageType, callback : Dynamic ) : Bool
	{
		throw new VirtualMethodException();
	}
	
	public function removeHandler( messageType : MessageType, callback : Dynamic ) : Bool
	{
		throw new VirtualMethodException();
	}
	
	public function removeAllListeners( ):Void
	{
		throw new VirtualMethodException();
	}
	
	public function release() : Void
	{
		throw new VirtualMethodException();
	}
}