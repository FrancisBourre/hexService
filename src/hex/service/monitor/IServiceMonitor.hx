package hex.service.monitor;

import hex.service.Service;

/**
 * ...
 * @author Francis Bourre
 */
interface IServiceMonitor
{
	function getStrategy<ServiceType:Service>( service : ServiceType ) : IServiceMonitorStrategy<ServiceType>;
	function mapStrategy<ServiceType:Service>( serviceClass : Class<ServiceType>, strategy : IServiceMonitorStrategy<ServiceType> ) : Bool;
}