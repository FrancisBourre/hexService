package hex.service.monitor.http;

import haxe.Timer;
import hex.di.Injector;
import hex.error.NullPointerException;
import hex.service.monitor.IServiceErrorStrategy;
import hex.service.stateless.http.IHTTPService;
import hex.unittest.assertion.Assert;
import hex.unittest.runner.MethodRunner;

#if js
import js.Browser;
#end

/**
 * ...
 * @author Francis Bourre
 */
class BasicHTTPServiceErrorStrategyTest
{
	@Async( "Test that BasicHTTPServiceErrorStrategy instance recalls service 3 times" )
	public function testStrategyRetry() : Void
	{
		#if js
		if ( Browser.supported )
		{
		#end
		
		var serviceMonitor = new BasicServiceMonitor<IServiceErrorStrategy<MockHTTPService>>();
		serviceMonitor.mapStrategy( MockHTTPService, new BasicHTTPServiceErrorStrategy( 3, 100 ) );
		
		var injector = new Injector();
		injector.mapClassName( "hex.service.monitor.IServiceMonitor<hex.service.monitor.IServiceErrorStrategy<hex.service.monitor.http.MockHTTPService>>" ).toValue( serviceMonitor );
		injector.mapToType( MockHTTPService, MockHTTPService );
		
		MockHTTPService.serviceCallCount = 0;
		MockHTTPService.errorThrown = null;
		
		var service : IHTTPService = injector.getOrCreateNewInstance( MockHTTPService );
		service.call();
		
		Timer.delay( MethodRunner.asyncHandler( this._onCompleteTestStrategyRetry ), 400 );
		
		#if js
		}
		else
		{
			Timer.delay( MethodRunner.asyncHandler( this._bypassTest ), 10 );
		}
		#end
	}
	
	function _bypassTest() : Void
	{
		//Do nothing, just bypass the test. Allows Node.js to run the tests without failing.
	}
	
	function _onCompleteTestStrategyRetry() : Void
	{
		Assert.equals( 4, MockHTTPService.serviceCallCount, "service should have been called 3 times. One normal and 3 retry calls" );
		Assert.isInstanceOf( MockHTTPService.errorThrown, NullPointerException, "Error thrown after retries should be an instance of 'NullPointerException'" );
	}
	
	@Async( "Test two different BasicHTTPServiceErrorStrategy instances at the same time" )
	public function testTwoStrategyRetryAtTheSameTime() : Void
	{
		#if js
		if ( Browser.supported )
		{
		#end
		
		var serviceMonitor = new BasicServiceMonitor<IServiceErrorStrategy<MockHTTPService>>();
		serviceMonitor.mapStrategy( MockHTTPService, new BasicHTTPServiceErrorStrategy( 3, 100 ) );
		serviceMonitor.mapStrategy( AnotherMockHTTPService, new BasicHTTPServiceErrorStrategy( 6, 50 ) );
		
		var injector = new Injector();
		injector.mapClassName( "hex.service.monitor.IServiceMonitor<hex.service.monitor.IServiceErrorStrategy<hex.service.monitor.http.MockHTTPService>>" ).toValue( serviceMonitor );
		injector.mapClassName( "hex.service.monitor.IServiceMonitor<hex.service.monitor.IServiceErrorStrategy<hex.service.monitor.http.AnotherMockHTTPService>>" ).toValue( serviceMonitor );
		injector.mapToType( MockHTTPService, MockHTTPService );
		injector.mapToType( AnotherMockHTTPService, AnotherMockHTTPService );
		
		MockHTTPService.serviceCallCount = 0;
		MockHTTPService.errorThrown = null;
		
		AnotherMockHTTPService.serviceCallCount = 0;
		AnotherMockHTTPService.errorThrown = null;
		
		var service : IHTTPService = injector.getOrCreateNewInstance( MockHTTPService );
		var anotherService : IHTTPService = injector.getOrCreateNewInstance( AnotherMockHTTPService );
		service.call();
		anotherService.call();
		
		Timer.delay( MethodRunner.asyncHandler( this._onCompleteTestTwoStrategyRetryAtTheSameTime ), 500 );
		
		#if js
		}
		else
		{
			Timer.delay( MethodRunner.asyncHandler( this._bypassTest ), 10 );
		}
		#end
	}
	
	function _onCompleteTestTwoStrategyRetryAtTheSameTime() : Void
	{
		Assert.equals( 4, MockHTTPService.serviceCallCount, "service should have been called 3 times. One normal and 3 retry calls" );
		Assert.isInstanceOf( MockHTTPService.errorThrown, NullPointerException, "Error thrown after retries should be an instance of 'NullPointerException'" );
		
		Assert.equals( 7, AnotherMockHTTPService.serviceCallCount, "service should have been called 7 times. One normal and 6 retry calls" );
		Assert.isInstanceOf( AnotherMockHTTPService.errorThrown, NullPointerException, "Error thrown after retries should be an instance of 'NullPointerException'" );
	}
}