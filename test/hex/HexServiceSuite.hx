package hex;

import hex.config.stateful.ServiceLocatorTest;
import hex.service.ServiceServiceSuite;

/**
 * ...
 * @author Francis Bourre
 */
class HexServiceSuite
{
	@Suite( "HexService" )
    public var list : Array<Class<Dynamic>> = [ ServiceLocatorTest, ServiceServiceSuite ];
}