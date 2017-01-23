package hex.service.stateless.http;

/**
 * ...
 * @author Francis Bourre
 */
class HTTPSuite
{
	@Suite("HTTP suite")
    public var list : Array<Class<Dynamic>> = [HTTPServiceTest
	#if (!neko || haxe_ver >= "3.3")
	, DefaultHTTPServiceParameterFactoryTest
	#end
	];
}