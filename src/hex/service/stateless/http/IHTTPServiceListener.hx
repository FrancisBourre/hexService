package hex.service.stateless.http;

import hex.service.ServiceConfiguration;

/**
 * ...
 * @author Francis Bourre
 */
interface IHTTPServiceListener
{
	function onServiceComplete( service : IHTTPService ) : Void;
	function onServiceFail( service : IHTTPService ) : Void;
	function onServiceCancel( service : IHTTPService ) : Void;
	function onServiceTimeout( service : IHTTPService ) : Void;
}