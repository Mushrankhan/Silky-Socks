//
//  Operation.swift
//  Silky Socks
//
//  Created by Saurabh Jain on 8/3/15.
//  Copyright © 2015 Full Stak. All rights reserved.
//

import UIKit

class Operation: NSOperation {

    // MARK: KVO
    
    // Essential to managing the state on our own
    class func keyPathsForValuesAffectingIsReady() -> Set<NSObject> {
        return ["state"]
    }
    
    class func keyPathsForValuesAffectingIsExecuting() -> Set<NSObject> {
        return ["state"]
    }
    
    class func keyPathsForValuesAffectingIsFinished() -> Set<NSObject> {
        return ["state"]
    }
    
    class func keyPathsForValuesAffectingIsCancelled() -> Set<NSObject> {
        return ["state"]
    }
    
    // MARK: State Management
    
    // Managing the different states if the operation manually
    private enum State: Int, Comparable {
        case Initialized
        case Pending
        case EvaluatingConditions
        case Ready
        case Executing
        case Finishing
        case Finished
        case Cancelled
    }
    
    private var _state = State.Initialized
    
    private var state: State {
        get {
            return _state
        }
        set {
            willChangeValueForKey("state")
            _state = newValue
            didChangeValueForKey("state")
        }
    }
    
    func willEnqueue() {
        state = .Pending
    }
    
    override var ready: Bool {
        switch state {
            case .Pending:
                if super.ready {
                    evaluateConditions()
                }
                return false
            case .Ready:
                return super.ready
            default:
                return false
        }
    }
    
    override var executing: Bool {
        return state == .Executing
    }
    
    override var finished: Bool {
        return state == .Finished
    }
    
    override var cancelled: Bool {
        return state == .Cancelled
    }

    // MARK: Observers
    
    private var observers = [OperationObserver]()
    
    func addObserver(observer: OperationObserver) {
        if state < .EvaluatingConditions {
            observers.append(observer)
        }
    }
    
    func produceOperation(operation: NSOperation) {
        for observer in observers {
            observer.operation(self, didProduceOperation: operation)
        }
    }
    
    // MARK: Conditions
    
    private var conditions = [OperationCondition]()
    
    func addCondition(condition: OperationCondition) {
        if state < .EvaluatingConditions {
            conditions.append(condition)
        }
    }
    
    private func evaluateConditions() {
        
        state = .EvaluatingConditions
        
        var results = [NSError]()
        
        // Evaluate all conditions
        // Can only be done like this if syncchronous conditions
        for condition in conditions {
            condition.evaluateCondition { (result) in
                switch result {
                    case .Error(let error):
                        results.append(error)
                    default:
                        break
                }
            }
        }
        
        
        if !results.isEmpty {
            state = .Cancelled
            finish(results)
        } else  {
            state = .Ready
        }
    }
    
    // MARK: Execution
    
    override final func start() {
        state = .Executing
        for observer in observers {
            observer.operationWillBegin(self)
        }
        execute()
    }
    
    // Should be subclassed
    func execute() {
        finish()
    }
    
    override func cancel() {
        state = .Cancelled
    }
    
    // MARK: Finishing
    
    /**
    Most operations may finish with a single error, if they have one at all.
    This is a convenience method to simplify calling the actual `finish()`
    method. This is also useful if you wish to finish with an error provided
    by the system frameworks. As an example, see `DownloadEarthquakesOperation`
    for how an error from an `NSURLSession` is passed along via the
    `finishWithError()` method.
    */
    final func finishWithError(error: NSError?) {
        if let error = error {
            finish([error])
        }
        else {
            finish()
        }
    }
    
    /**
    A private property to ensure we only notify the observers once that the
    operation has finished.
    */
    private var hasFinishedAlready = false
    final func finish(errors: [NSError] = []) {
        if !hasFinishedAlready {
            hasFinishedAlready = true
            state = .Finishing
            
            finished(errors)
            
            for observer in observers {
                observer.operationDidFinish(self, withErrors: errors)
            }
            
            state = .Finished
        }
    }
    
    /**
    Subclasses may override `finished(_:)` if they wish to react to the operation
    finishing with errors. For example, the `LoadModelOperation` implements
    this method to potentially inform the user about an error when trying to
    bring up the Core Data stack.
    */
    func finished(errors: [NSError]) {
        // No op.
    }

}

// MARK: Operation.State Comparable Protocol

private func <(lhs: Operation.State, rhs: Operation.State) -> Bool {
    return lhs.rawValue < rhs.rawValue
}
private func ==(lhs: Operation.State, rhs: Operation.State) -> Bool {
    return lhs.rawValue == rhs.rawValue
}
