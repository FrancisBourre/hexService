package hex.service.stateful;

import hex.event.CompositeDispatcher;
import hex.service.IService;
import hex.service.ServiceConfiguration;

/**
 * @author Francis Bourre
 */
interface IStatefulService<ServiceConfigurationType:ServiceConfiguration> extends IService<ServiceConfigurationType>
{
	function inUse():Bool;
	function getDispatcher() : CompositeDispatcher;
}