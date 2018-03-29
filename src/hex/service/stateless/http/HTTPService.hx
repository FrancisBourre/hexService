package hex.service.stateless.http;

import haxe.Http;
import hex.control.async.AsyncCallback;
import hex.control.async.Handler;
import hex.core.IAnnotationParsable;
import hex.error.Exception;
import hex.error.NullPointerException;
import hex.util.Stringifier;
import hex.service.stateless.AsyncStatelessService;

/**
 * ...
 * @author Francis Bourre
 */
class HTTPService extends AsyncStatelessService implements IHTTPService implements IURLConfigurable implements IAnnotationParsable
{
	function new() 
	{
		super();
	}
	
	var _request 			: Http;
	var _excludedParameters : Array<String>;
	var _timestamp 			: Float;
	var httpConfig(get, never):HTTPServiceConfiguration;
	inline function get_httpConfig() return (cast this._configuration:HTTPServiceConfiguration);
	override public function call() : Void
	{
		this._timestamp = Date.now().getTime ();
		
		if ( this._configuration == null || httpConfig.serviceUrl == null )
		{
			this._status = StatelessService.IS_RUNNING;
			this._onException( new NullPointerException( "call method call failed. ServiceConfiguration.serviceUrl shouldn't be null @" + Stringifier.stringify( this ) ) );
			return;
		}
		
		this.timeoutDuration = this._configuration.serviceTimeout;

		super.call();

		//
		this._request = new Http( httpConfig.serviceUrl );
		
		httpConfig.parameterFactory.setParameters( this._request, httpConfig.parameters, _excludedParameters );
		
		
		#if (js && !nodejs)
			this._request.async 					= httpConfig.async;
			untyped this._request.withCredentials 	= httpConfig.withCredentials;
		#end
		this._request.onData 		= this._onData;
		this._request.onError 		= this._onError;
		this._request.onStatus 		= this._onStatus;
		
		var requestHeaders : Array<HTTPRequestHeader> = httpConfig.requestHeaders;
		if ( requestHeaders != null )
		{
			for ( header in requestHeaders )
			{
				this._request.addHeader ( header.name, header.value );
			}
		}
		//
		
		this._request.request( httpConfig.requestMethod == HTTPRequestMethod.POST );
	}
	
	public function execute<ResultType>() : AsyncCallback<ResultType>
	{
		return AsyncCallback.get
		(
			function ( handler : Handler<ResultType> )
			{
				try
				{
					this.addHandler( StatelessServiceMessage.COMPLETE, function (service) handler(Result.DONE(service.getResult())) );
					this.addHandler( StatelessServiceMessage.FAIL, function (service) handler(Result.FAILED(new Exception('HttpService call fails'))) );
					this.call();
				}
				catch ( e : Exception )
				{
					handler( Result.FAILED( e ) );
				}
			}
		);
	}

	public function setExcludedParameters( excludedParameters : Array<String> ) : Void
	{
		this._excludedParameters = excludedParameters;
	}

	public var url( get, null ) : String;
	public function get_url() : String
	{
		return httpConfig.serviceUrl;
	}
	
	public var method( get, null ) : HTTPRequestMethod;
	public function get_method() : HTTPRequestMethod
	{
		return httpConfig.requestMethod;
	}
	
	public var dataFormat( get, null ) : String;
	public function get_dataFormat() : String
	{
		return httpConfig.dataFormat;
	}
	
	public var timeout( get, null ) : UInt;
	public function get_timeout() : UInt
	{
		return this._configuration.serviceTimeout;
	}

	public function setParameters( parameters : HTTPServiceParameters ) : Void
	{
		httpConfig.parameters = parameters;
	}

	public function getParameters() : HTTPServiceParameters
	{
		return httpConfig.parameters;
	}

	public function addHeader( header : HTTPRequestHeader ) : Void
	{
		httpConfig.requestHeaders.push( header );
	}

	function _onData( result : String ) : Void
	{
		this._onResultHandler( result );
	}

	function _onError( msg : String ) : Void
	{
		this._onException( new Exception( msg ) );
	}
	
	function _onStatus( status : Int ) : Void
	{
		
	}

	public function setURL( url : String ) : Void
	{
		httpConfig.serviceUrl = url;
	}
}
