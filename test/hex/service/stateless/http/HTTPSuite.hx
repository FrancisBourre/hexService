package hex.service.stateless.http;

/**
 * ...
 * @author Francis Bourre
 */
class HTTPSuite
{
	@Suite("HTTP suite")
    public var list : Array<Class<Dynamic>> = [
	#if (!neko || haxe_ver >= "3.3")
	HTTPServiceTest, DefaultHTTPServiceParameterFactoryTest
	#end
	];
}