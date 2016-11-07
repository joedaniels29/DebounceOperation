//
//  DebounceOperation.swift

import Foundation

public final class DebouncingOperation:BlockOperation{
    public var _ready:Bool
    public var timer:Timer
    public var delay:TimeInterval
    public init(delay: TimeInterval, block: @escaping () -> Void){
        _ready = false
        timer = Timer(timeInterval: delay, target: "", selector: #selector(noop(_:)), userInfo: nil, repeats: false)
//        timer = Timer(timeInterval: delay, repeats: false, block: {_ in ()/*noop*/})
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
    @objc func fire(_ t:Timer) -> (){

            self.willChangeValue(forKey: "isReady")
            self._ready = true
            self.didChangeValue(forKey: "isReady")
        
    }
    @objc func noop(_ t:Timer) -> (){
        
        
    }
    public var scheduleOperation:() -> (){
        return { [weak self] in
            //pick it back up.
            if let me = self {
                me.timer = Timer.scheduledTimer(timeInterval: me.delay, target: me, selector: #selector(me.fire(_:)), userInfo: nil, repeats: false)
                
            }
        }
    }
    
}
