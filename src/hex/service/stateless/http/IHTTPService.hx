package hex.service.stateless.http;

import hex.service.ServiceConfiguration;
import hex.service.stateless.IAsyncStatelessService;
import hex.service.stateless.http.HTTPServiceParameters;

/**
 * @author Francis Bourre
 */
interface IHTTPService extends IAsyncStatelessService
{
	var url( get, null ) : String;
	var method( get, null ) : HTTPRequestMethod;
	var dataFormat( get, null ) : String;
	var timeout( get, null ) : UInt;
	
	function addHeader( header : HTTPRequestHeader ) : Void;
	function setParameters( parameters : HTTPServiceParameters ) : Void;
}