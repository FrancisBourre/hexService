package hex.service;

/**
 * ...
 * @author Francis Bourre
 */
class MockServiceWithConfigurationSetter extends MockService
{
	public function new()
	{
		super();
	}
	
	override public function setConfiguration( configuration : ServiceConfiguration ) : Void
	{
		this._configuration = configuration;
	}
}