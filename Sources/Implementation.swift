//
//  DebounceOperation.swift

import Foundation
public final class DebouncingOperation:BlockOperation{
    public var _ready:Bool
    public var timer:Timer
    public var delay:TimeInterval
    public init(delay: TimeInterval, block: @escaping () -> Void){
        _ready = false
        timer = Timer(timeInterval: delay, repeats: false, block: {_ in ()/*noop*/})
        self.delay = delay
        super.init()
        addExecutionBlock(block)
        debounce()
    }
    
    public func debounce(){
        //drop it
        timer.invalidate();
        OperationQueue.main.addOperation(self.scheduleOperation)
    }
    
    override open var isReady: Bool{
        
        return _ready
    }
    deinit {
        self.timer.invalidate()
    }
    public var fireOperation: (Timer) -> (){
        return {[weak self] _ in
            self?.willChangeValue(forKey: "isReady")
            self?._ready = true
            self?.didChangeValue(forKey: "isReady")
        }
        
    }
    public var scheduleOperation:() -> (){
        return { [weak self] in
            //pick it back up.
            if let me = self {
                print("Deferred")
                me.timer = Timer.scheduledTimer(withTimeInterval: me.delay, repeats: false, block: me.fireOperation)
            }
        }
    }
    
}
