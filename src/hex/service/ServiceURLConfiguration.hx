package hex.service;
import hex.service.ServiceConfiguration;

/**
 * ...
 * @author Francis Bourre
 */
class ServiceURLConfiguration extends ServiceConfiguration
{
	public var serviceUrl : String;

	public function new( url : String = null, timeout : UInt = 5000 ) 
	{
		super( timeout );
        this.serviceUrl = url;
	}
}