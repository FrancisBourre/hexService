package hex.service.stateless.http;

#if (!neko || haxe_ver >= "3.3")
import haxe.Http;
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

	override public function call() : Void
	{
		this._timestamp = Date.now().getTime ();
		
		if ( this._configuration == null || ( cast this._configuration ).serviceUrl == null )
		{
			this._status = StatelessService.IS_RUNNING;
			this._onException( new NullPointerException( "call method call failed. ServiceConfiguration.serviceUrl shouldn't be null @" + Stringifier.stringify( this ) ) );
			return;
		}
		
		this.timeoutDuration = this._configuration.serviceTimeout;

		super.call();

		//
		this._request = new Http( ( cast this._configuration ).serviceUrl );
		
		( cast this._configuration ).parameterFactory.setParameters( this._request, ( cast this._configuration ).parameters, _excludedParameters );
		
		
		#if (js && !nodejs)
			this._request.async 					= ( cast this._configuration ).async;
			untyped this._request.withCredentials 	= ( cast this._configuration ).withCredentials;
		#end
		this._request.onData 		= this._onData;
		this._request.onError 		= this._onError;
		this._request.onStatus 		= this._onStatus;
		
		var requestHeaders : Array<HTTPRequestHeader> = ( cast this._configuration ).requestHeaders;
		if ( requestHeaders != null )
		{
			for ( header in requestHeaders )
			{
				this._request.addHeader ( header.name, header.value );
			}
		}
		//
		
		this._request.request( ( cast this._configuration ).requestMethod == HTTPRequestMethod.POST );
	}

	public function setExcludedParameters( excludedParameters : Array<String> ) : Void
	{
		this._excludedParameters = excludedParameters;
	}

	public var url( get, null ) : String;
	public function get_url() : String
	{
		return ( cast this._configuration ).serviceUrl;
	}
	
	public var method( get, null ) : HTTPRequestMethod;
	public function get_method() : HTTPRequestMethod
	{
		return ( cast this._configuration ).requestMethod;
	}
	
	public var dataFormat( get, null ) : String;
	public function get_dataFormat() : String
	{
		return ( cast this._configuration ).dataFormat;
	}
	
	public var timeout( get, null ) : UInt;
	public function get_timeout() : UInt
	{
		return this._configuration.serviceTimeout;
	}

	override public function release() : Void
	{
		#if (js || flash)
		if ( this._request != null )
		{
			if ( this._status == StatelessService.WAS_NEVER_USED )
			{
				this._request.cancel();
			}
		}
		#end
		
		super.release();
	}

	public function setParameters( parameters : HTTPServiceParameters ) : Void
	{
		( cast this._configuration ).parameters = parameters;
	}

	public function getParameters() : HTTPServiceParameters
	{
		return ( cast this._configuration ).parameters;
	}

	public function addHeader( header : HTTPRequestHeader ) : Void
	{
		( cast this._configuration ).requestHeaders.push( header );
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
		( cast this._configuration ).serviceUrl = url;
	}
}
#end
