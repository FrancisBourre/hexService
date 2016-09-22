package hex.service.stateful;

/**
 * ...
 * @author Francis Bourre
 */
class MockStatefulService extends StatefulService
{
	public function new() 
	{
		super();
		
	}
	
	public function run()
	{
		this._lock();
	}
	
	public function stop()
	{
		this._release();
	}
}
