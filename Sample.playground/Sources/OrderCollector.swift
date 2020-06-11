import Foundation

public class OrderCollector {

    public typealias OrderResultCallback = (Result<Burgers, GenericError>) -> Void

    private var availableBurgers: Queue<Burgers> = Queue()
    private var pendingOrders: Queue<OrderResultCallback> = Queue()
    private let kitchen = Kitchen()

    public func getHamburger(_ orderCompletionCallback: @escaping OrderResultCallback) {
        print("W: Thank you sir for your order")
        pendingOrders.enqueue(orderCompletionCallback)
        processPendingRequests()
    }

    private func processPendingRequests() {

        // Loop over the requests that are fulfillable
        while availableBurgers.count > 0 && pendingOrders.count > 0 {

            let burger = availableBurgers.dequeue()!
            let order = pendingOrders.dequeue()!
            order(.success(burger))
        }

        // Do we still have pending request?
        if pendingOrders.count > 0 {
            switch kitchen.currentState {
            case .busy:
                break;
            case .free:
                kitchen.makeMoreBurgers { [weak self] result in
                    guard let self = self else { return }
                    switch result {
                    case .success(let burgers):
                        print("(Received \(burgers.count) burgers from the kitchen)")
                        burgers.forEach { self.availableBurgers.enqueue($0) }
                        self.processPendingRequests()
                    case .failure:
                        print("(Kitchen is on fire, cancel all the pending orders)")
                        self.emptyRequestQueueWithError()
                    }
                }
            }
        }
    }

    private func emptyRequestQueueWithError() {
        while let element = pendingOrders.dequeue() {
            print("W: Sorry sir, your order is canceled")
            element(.failure(.someError))
        }
    }

    public init() { }
}

public enum GenericError: Error {
    case someError
}
