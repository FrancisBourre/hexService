package hex.service.stateless;

import hex.data.ServiceParser;
import hex.error.Exception;
import hex.error.IllegalStateException;
import hex.error.UnsupportedOperationException;
import hex.event.ClosureDispatcher;
import hex.event.MessageType;
import hex.util.Stringifier;
import hex.service.AbstractService;
import hex.service.ServiceConfiguration;
import hex.service.stateless.IStatelessService;
import hex.service.stateless.StatelessServiceMessage;

/**
 * ...
 * @author Francis Bourre
 */
class StatelessService extends AbstractService implements IStatelessService
{
	public static inline var WAS_NEVER_USED     : String = "WAS_NEVER_USED";
    public static inline var IS_RUNNING         : String = "IS_RUNNING";
    public static inline var IS_COMPLETED       : String = "IS_COMPLETED";
    public static inline var IS_FAILED          : String = "IS_FAILED";
    public static inline var IS_CANCELLED       : String = "IS_CANCELLED";
	
	var _ed            					: ClosureDispatcher;
	
	var _result                     	: Dynamic;
    var _rawResult                		: Dynamic;
	var _parser                    		: ServiceParser;
    var _status                     	: String = StatelessService.WAS_NEVER_USED;
	
	function new() 
	{
		super();
		this._ed = new ClosureDispatcher();
	}

	override public function setConfiguration( configuration : ServiceConfiguration ) : Void
	{
		if ( this.wasUsed )
		{
			throw new IllegalStateException( "'setConfiguration' can't be called after service call @" + Stringifier.stringify( this ) );
		}
		else
		{
			this._configuration = configuration;
		}
	}
	
	override public function addHandler( messageType : MessageType, callback : Dynamic ) : Bool
	{
		return this._ed.addHandler( messageType, callback );
	}

	override public function removeHandler( messageType : MessageType, callback : Dynamic ) : Bool
	{
		return this._ed.removeHandler( messageType, callback );
	}
	
	override public function release() : Void
	{
		if ( !this.wasUsed )
		{
			this.cancel();
		}
		else 
		{
			this._release();
		}
	}
	
	public function call() : Void
	{
		this.wasUsed && this._throwExecutionIllegalStateError( "call" );
		this._status = StatelessService.IS_RUNNING;
	}

	public function cancel() : Void
	{
		this.handleCancel();
	}
	
	public var wasUsed( get, null ) : Bool;
	@:final 
    public function get_wasUsed() : Bool
    {
        return this._status != StatelessService.WAS_NEVER_USED;
    }

	public var isRunning( get, null ) : Bool;
	@:final 
    public function get_isRunning() : Bool
    {
        return this._status == StatelessService.IS_RUNNING;
    }

	public var hasCompleted( get, null ) : Bool;
	@:final 
    public function get_hasCompleted() : Bool
    {
        return this._status == StatelessService.IS_COMPLETED;
    }

	public var hasFailed( get, null ) : Bool;
	@:final 
    public function get_hasFailed() : Bool
    {
        return this._status == StatelessService.IS_FAILED;
    }

	public var isCancelled( get, null ) : Bool;
	@:final 
    public function get_isCancelled() : Bool
    {
        return this._status == StatelessService.IS_CANCELLED;
    }
	
	function _throwExecutionIllegalStateError( methodName : String ) : Bool
	{
		var msg : String = "";

		if ( this.isRunning )
		{
			msg = "'" + methodName + "' call failed. This service is running and can't be called twice ";
		}
		else if ( this.isCancelled )
		{
			msg = "'" + methodName + "' call failed. This service is cancelled and can't be called twice ";
		}
		else if ( this.hasCompleted )
		{
			msg = "'" + methodName + "' call failed. This service is completed and can't be called twice ";
		}
		else if ( this.hasFailed )
		{
			msg = "'" + methodName + "' call failed. This service has failed and can't be called twice ";
		}

		this._release();
		return this._throwIllegalStateError( msg + "@" + Stringifier.stringify( this )  );
	}

	function _throwIllegalStateError( msg : String ) : Bool 
	{
		throw new IllegalStateException( msg );
	}

	function _release() : Void
	{
		this.removeAllListeners();
		this._result = null;
		this._parser = null;
	}
	
	function _onResultHandler( result : Dynamic ) : Void
	{
		if ( this._status == StatelessService.IS_RUNNING )
		{
			this._setResult( result );
			this.handleComplete();
		}
	}

	function _onErrorHandler( result : Dynamic ) : Void
	{
		this._rawResult = null;
		this._result = null;
		this.handleFail();
	}
	
	function _onException( e : Exception ) : Void
	{
		if ( this._ed.hasHandler( StatelessServiceMessage.FAIL ) )
		{
			this._onErrorHandler( null );
		}
		else
		{
			throw e;
		}
	}
	
	@:final 
	public function getResult() : Dynamic
	{
		return this._result;
	}
	
	function _setResult( response : Dynamic ) : Dynamic
	{
		this._rawResult = response;
		this._result = this._parser != null ? this._parser.parse( this._rawResult ) : this._rawResult;
		return this._result;
	}
	
	public function getRawResult() : Dynamic
	{
		return this._rawResult;
	}

	public function setParser( parser : ServiceParser ) : Void
	{
		this._parser = parser;
	}

	@:final 
	public function handleComplete() : Void
	{
		this.wasUsed && this._status != StatelessService.IS_RUNNING && this._throwIllegalStateError( "handleComplete failed" );
		this._status = StatelessService.IS_COMPLETED;
		this._ed.dispatch( StatelessServiceMessage.COMPLETE, [this] );
		this._release();
	}

	@:final 
	public function handleFail() : Void
	{
		this.wasUsed && this._status != StatelessService.IS_RUNNING && this._throwIllegalStateError( "handleFail failed" );
		this._status = StatelessService.IS_FAILED;
		this._ed.dispatch( StatelessServiceMessage.FAIL, [this] );
		this._release();
	}

	@:final 
	public function handleCancel() : Void
	{
		this.wasUsed && this._status != StatelessService.IS_RUNNING && this._throwIllegalStateError( "handleCancel failed" );
		this._status = StatelessService.IS_CANCELLED;
		this._ed.dispatch( StatelessServiceMessage.CANCEL, [this] );
		this._release();
	}
	
	@:final
	override public function removeAllListeners( ) : Void
	{
		this._ed.removeAllListeners( );
	}
	
	//
	function _getRemoteArguments() : Array<Dynamic>
	{
		throw new UnsupportedOperationException( this + ".getRemoteArguments is unsupported." );
	}

	function _reset() : Void
	{
		this._status = StatelessService.WAS_NEVER_USED;
	}
}