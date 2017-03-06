package hex.service.stateless.http;

#if (!neko || haxe_ver >= "3.3")
import hex.service.stateless.http.HTTPService;

/**
 * ...
 * @author Francis Bourre
 */
class MockGithubService extends HTTPService
{
	public function new()
	{
		super();
	}
	
	@postConstruct
	override public function createConfiguration() : Void
	{
		this._configuration = new MockHTTPServiceConfiguration();
	}
}
#end