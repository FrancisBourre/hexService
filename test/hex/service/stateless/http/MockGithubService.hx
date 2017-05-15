package hex.service.stateless.http;

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
	
	override public function createConfiguration() : Void
	{
		this._configuration = new MockHTTPServiceConfiguration();
	}
}