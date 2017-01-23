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
    public var list : Array<Class<Dynamic>> = [AsyncStatelessServiceTest, 
	#if (!neko || haxe_ver >= "3.3")
	HTTPSuite, 
	#end
	StatelessServiceTest];
}