//
//  CombineVC.swift
//  RKProject
//
//  Created by yunbao02 on 2025/1/23.
//

import Combine
import UIKit

class CombineVC: RKBaseVC {
    private var rootView: CombineView {
        return view as! CombineView
    }

    override func loadView() {
        view = CombineView()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        rootView.layoutIfNeeded()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        titleL.text = "Flex&Combine"
        // comOne()
        // comTwo()
        // comThree()
        ts1()
    }

    func ts1() {
        let publisher = Just("hello,combine!")
        let cancellable = publisher
            .map { "\($0) world!" }
            .sink { completion in
                switch completion {
                case .finished:
                    debug.log("finished")
                case .failure(let err):
                    debug.log("err:\(err)", type: .error)
                }
            } receiveValue: { val in
                debug.log("val", val)
            }
        cancellable.cancel()
    }

    func comThree() {
        let weather = Weather(temperature: 20)
        let cancellable = weather.$temperature
            .sink {
                debug.log("val:", weather.temperature, "Temperature now: \($0)")
            }
        weather.temperature = 25
        cancellable.cancel()
        // weather.temperature = 35
    }

    /*
      立即开始的 Just 和 Future
      对于大部分的 Publisher来说，它们在订阅后才会开始生产事件，但也有一些例外。Just 和 Future 在初始化完成后会立即执行闭包生产事件，这可能会让一些耗时长的操作在不符合预期的时机提前开始，也可能会让第一个订阅错过一些太早开始的事件。
      一个可行的解法是在这类 Publisher 外封装一层 Defferred，让它在接收到订阅之后再开始执行内部的闭包。

     func makeMyPublisher() -> AnyPublisher<Int, Never> {
         Just(calculateTimeConsumingResult())
             .eraseToAnyPublisher()
     }

     func makeMyFuture2() -> AnyPublisher<Int, Never> {
         Deferred {
             Just(calculateTimeConsumingResult())
         }.eraseToAnyPublisher()
     }
     */

    func comTwo() {
        let greetings = PassthroughSubject<String, Never>()
        let names = PassthroughSubject<String, Never>()
        let years = PassthroughSubject<String, Never>()

        let greetingNames = Publishers.CombineLatest(greetings, names)
            .map { "\($1),\($0)" }
        let wholeSentence = Publishers.CombineLatest(greetingNames, years)
            .map { ">:\($0),\($1)" }
            .sink {
                debug.log("out", $0)
            }

        years.send("2025")
        names.send("combine")
        greetings.send("hello")
        wholeSentence.cancel()
    }

    func comOne() {
        //
        let cancellable = [1, 2, 3, 4, 5].publisher
            .print("第一个")
            .sink { completion in
                debug.log(completion)
            } receiveValue: { value in
                debug.log(value)
            }
        cancellable.cancel()
        //
        let cancellable2 = [1, 2, 3, 4, 5].publisher
            .print("第二个")
            .sink { value in
                debug.log(value)
            }
        cancellable2.cancel()
    }
}

///
class Weather {
    @Published var temperature: Double
    init(temperature: Double) {
        self.temperature = temperature
    }
}
