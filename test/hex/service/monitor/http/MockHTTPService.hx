package hex.service.monitor.http;

import hex.error.Exception;
import hex.service.monitor.IServiceErrorStrategy;
import hex.service.stateless.http.HTTPService;
import hex.service.stateless.http.HTTPServiceConfiguration;

/**
 * ...
 * @author Francis Bourre
 */
class MockHTTPService extends HTTPService<HTTPServiceConfiguration>
{
	public static var serviceCallCount 	: UInt 		= 0;
	public static var errorThrown 		: Exception = null;
	
	@Inject
	public var serviceMonitor : IServiceMonitor<IServiceErrorStrategy<MockHTTPService>>;
	
	public function new() 
	{
		super();
		
	}
	
	override function _onError( msg : String ) : Void
	{
		var e : Exception = new MockHTTPServiceException( msg );
		
		if ( this.serviceMonitor.getStrategy( this ).handleError( this, e ) )
		{
			this._reset();
			this.serviceMonitor.getStrategy( this ).retry( this );
		}
		else
		{
			MockHTTPService.errorThrown = e;
			
			//In real case the line below should be uncommented
			//super._onError( msg );
		}
	}
	
	override public function call() : Void
	{
		try
		{
			MockHTTPService.serviceCallCount++;
			super.call();
		}
		catch( e : Exception )
		{
			if ( this.serviceMonitor.getStrategy( this ).handleError( this, new MockHTTPServiceException( e.message ) ) )
			{
				this.serviceMonitor.getStrategy( this ).retry( this );
			}
			else
			{
				MockHTTPService.errorThrown = e;
			}
		}
	}
}