package hex.service.stateless;
import hex.service.ServiceConfiguration;

/**
 * @author Francis Bourre
 */

interface IAsyncStatelessService<ServiceConfigurationType:ServiceConfiguration> extends IStatelessService<ServiceConfigurationType>
{
	var timeoutDuration( get, set ) : UInt;
}