package hex.service.stateless;

/**
 * @author Francis Bourre
 */

interface IAsyncStatelessService extends IStatelessService
{
	var timeoutDuration( get, set ) : UInt;
	function addListener( listener : IAsyncStatelessServiceListener ) : Void;
	function removeListener( listener : IAsyncStatelessServiceListener ) : Void;
}