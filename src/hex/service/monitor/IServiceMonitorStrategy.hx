package hex.service.monitor;

import hex.error.Exception;
import hex.service.Service;

/**
 * @author Francis Bourre
 */

interface IServiceMonitorStrategy<ServiceType:Service> 
{
	function retry( service : ServiceType ) : Void;
	function handleError( service : ServiceType, error : Exception ) : Bool;
}