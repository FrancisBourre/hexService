package hex.service;

import hex.service.AbstractServiceTest;
import hex.service.stateful.MVCStatefulServiceSuite;
import hex.service.stateless.MVCStatelessServiceSuite;

/**
 * ...
 * @author Francis Bourre
 */
class ServiceServiceSuite
{
	@Suite( "Service" )
    public var list : Array<Class<Dynamic>> = [ MVCStatelessServiceSuite, MVCStatefulServiceSuite, AbstractServiceTest, ServiceConfigurationTest, ServiceURLConfigurationTest ];
}