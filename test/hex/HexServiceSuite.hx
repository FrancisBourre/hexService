package hex;

import hex.di.mapping.MappingConfigurationWithServiceTest;
import hex.service.ServiceServiceSuite;

/**
 * ...
 * @author Francis Bourre
 */
class HexServiceSuite
{
	@Suite( "HexService" )
    public var list : Array<Class<Dynamic>> = [ MappingConfigurationWithServiceTest, ServiceServiceSuite ];
}