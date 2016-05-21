package hex.service.stateless;

import hex.service.stateless.IAsyncStatelessService;

/**
 * ...
 * @author Francis Bourre
 */
interface IAsyncStatelessServiceListener
{
	function onServiceComplete( service : IAsyncStatelessService ) : Void;
	function onServiceFail( service : IAsyncStatelessService ) : Void;
	function onServiceCancel( service : IAsyncStatelessService ) : Void;
	function onServiceTimeout( service : IAsyncStatelessService ) : Void;
}