package hex.service.stateless.http;

import haxe.Http;
import hex.core.IAnnotationParsable;
import hex.error.Exception;
import hex.error.NullPointerException;
import hex.log.Stringifier;
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
			trace("NULL configuration");
			this._status = StatelessService.IS_RUNNING;
			this._onException( new NullPointerException( "_createRequest call failed. ServiceConfiguration.serviceUrl shouldn't be null @" + Stringifier.stringify( this ) ) );
			return;
		}
		
		this._createRequest();
		super.call();
		this._request.request( ( cast this._configuration ).requestMethod == HTTPRequestMethod.POST );
	}
	
	function _createRequest() : Void
	{
		this._request = new Http( ( cast this._configuration ).serviceUrl );
		
		( cast this._configuration ).parameterFactory.setParameters( this._request, ( cast this._configuration ).parameters, _excludedParameters );
		this.timeoutDuration = this._configuration.serviceTimeout;
		
		#if js
			this._request.async 		= true; //TODO: check with flash
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
			
			/*this._request.onData 	= null;
			this._request.onError 	= null;
			this._request.onStatus 	= null;*/
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

	override function _getRemoteArguments() : Array<Dynamic>
	{
		this._createRequest();
		return [ this._request ];
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