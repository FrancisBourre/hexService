package hex.service.stateless;

#if (!neko || haxe_ver >= "3.3")
import hex.service.stateless.http.HTTPSuite;
#end
/**
 * ...
 * @author Francis Bourre
 */
class MVCStatelessServiceSuite
{
	@Suite("Stateless")
    public var list : Array<Class<Dynamic>> = [ 
	#if (!neko || haxe_ver >= "3.3")
	AsyncStatelessServiceTest, HTTPSuite, 
	#end
	StatelessServiceTest];
}