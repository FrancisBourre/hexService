package hex.service.monitor;

#if (!neko || haxe_ver >= "3.3")
import hex.service.monitor.http.BasicHTTPServiceErrorStrategyTest;
#end
/**
 * ...
 * @author Francis Bourre
 */
class MVCMonitorSuite
{
	@Suite( "Monitor" )
    public var list : Array<Class<Dynamic>> = [ 
	#if (!neko || haxe_ver >= "3.3")
	BasicHTTPServiceErrorStrategyTest 
	#end
	];
}
