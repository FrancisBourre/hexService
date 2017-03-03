package hex.service.stateless.http;

/**
 * ...
 * @author Francis Bourre
 */
class MockHTTPServiceConfiguration extends HTTPServiceConfiguration
{
	public function new()
	{
		super( "https://raw.githubusercontent.com/DoclerLabs/hexService/master/README.md" );
	}
}