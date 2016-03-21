package hex.service.monitor;

import hex.service.Service;

/**
 * ...
 * @author Francis Bourre
 */
interface IServiceMonitor<StrategyType>
{
	function getStrategy<ServiceType:Service>( service : ServiceType ) : StrategyType;
	function mapStrategy<ServiceType:Service>( serviceClass : Class<ServiceType>, strategy : StrategyType ) : Bool;
}