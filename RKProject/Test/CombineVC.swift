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
        naviSubView.backgroundColor = .clear
        naviLineL.isHidden = true
        // comOne()
        // comTwo()
        // comThree()
        // ts1()
        // ts2()
        // ts3()
        // ts4()
        // ts5()
        // ts6()
        // ts7()
        // ts8()
        // ts9()
        // ts10()
        // ts11()
        // ts12()
        // ts13()
        // ts14()
        ts15()
    }

    func ts15() {
        /*
         measureInterval 是一个用于测量时间间隔的操作符。它可以帮助开发者监测两次元素发出之间的时间间隔，以及订阅者接收到元素之间的时间间隔。这对于性能监控、调试和数据流分析非常有用。
         它接受一个调度器（Scheduler），返回一个 Publishers.MeasureInterval 类型的发布者。这个操作符会在每次接收到元素时记录当前时间，计算出与上次元素接收之间的时间间隔，并将间隔作为元素发出。

         scheduler: 用于计算时间间隔的调度器。通常情况下，可以使用 .main（主队列调度器）或者 .immediate（立即执行）等内置调度器。也可以传入自定义的调度器来控制时间间隔的计算行为。

         主要使用场景有

         监测数据流的速度和频率： 可以用来监测数据流中元素的发出速度，或者计算连续元素之间的时间间隔。
         性能监控和调试： 可以用来分析和优化 Combine 数据流的性能，以及查找可能存在的延迟或者频率问题。
         */
        let publisher = Timer.publish(every: 1, on: .main, in: .default)
            .autoconnect()
            .prefix(5)
        let cancellable = publisher
            .measureInterval(using: DispatchQueue.main)
            .sink { completion in
                debug.log("measureInterval-com", completion)
            } receiveValue: { val in
                debug.log("measureInterval-val", val)
            }
        cancellable.store(in: &cancelSet)

        // 当然如果有时候我们希望将时间间隔和发布者的value同时输出，那么就需要通过flatmap将两者结合起来转化成新的publisher
        // 创建一个简单的发布者，每隔一秒发出一个整数
        let publisher2 = Timer.publish(every: 1, on: .main, in: .default)
            .autoconnect() // 自动连接
            .prefix(5) // 限制只发出五个元素，用于示例简化

        // 记录上一个值接收的时间
        var lastReceivedTime: Date?

        let cancellable2 = publisher2
            // 使用 flatMap 操作符来转换每个原始值和时间间隔的元组 (Int, TimeInterval)。
            // 在 flatMap 的闭包中，我们计算了当前时间 currentTime，以及上一个值接收时间到当前时间的时间间隔 interval。
            // 然后将值和时间间隔封装成一个元组，并通过 Just 创建一个新的发布者。
            .flatMap { timestamp -> AnyPublisher<(value: String, interval: TimeInterval), Never> in
                let currentTime = Date()
                let interval: TimeInterval = lastReceivedTime.map { currentTime.timeIntervalSince($0) } ?? 0
                lastReceivedTime = currentTime
                return Just((timestamp.customFormatted(), interval)).eraseToAnyPublisher()
            }
            // 使用sink 订阅新的发布者发布的内容
            .sink(receiveCompletion: { completion in
                debug.log("Publisher finished with completion:", completion)
            }, receiveValue: { value, interval in
                debug.log("Received value:", value, ", Interval since last value:", interval)
            })

        // 取消订阅
        DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
            cancellable2.cancel()
        }
    }

    func ts14() {
        let publisher = PassthroughSubject<String, Never>()
        let cancellable = publisher
            .timeout(.seconds(3), scheduler: DispatchQueue.main, customError: nil)
            .sink { completaion in
                switch completaion {
                case .finished:
                    debug.log("timeout-finish")
                case .failure(let err):
                    debug.log("timeout-err", err)
                }
            } receiveValue: { val in
                debug.log("timeout", val)
            }
        cancellable.store(in: &cancelSet)

        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
            publisher.send("Some data - sent after a delay of \(3) seconds")
        }
    }

    func ts13() {
        let subject = PassthroughSubject<String, Never>()

        let cancellable = subject
            .delay(for: .seconds(1), scheduler: RunLoop.main)
            .sink { val in
                debug.log("delay", val)
            }
        cancellable.store(in: &cancelSet)
        subject.send("A")
    }

    func ts12() {
        // 指定时间间隔，只允许产生一个值
        let subject = PassthroughSubject<String, Never>()
        let cancellable = subject
            // .print("throttle")
            .throttle(for: .seconds(1), scheduler: RunLoop.main, latest: true)
            .sink { val in
                debug.log("throttle", val)
            }
        cancellable.store(in: &cancelSet)
        subject.send("A")
        subject.send("B")
        subject.send("C")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            subject.send("D")
        }
        /*
         首先，字符串 "A" , "B" 和 "C" 被发送到 subject，但在 1 秒内它们都被发送了，并且设置了latest = true ，throttle操作符只会接收最后一个值，即 "C"。
         在延迟 1.5 秒后，节流操作会接收到 "D" 并打印。
         */
    }

    func ts11() {
        // 指定时间间隔 只取最后一个值
        let subject = PassthroughSubject<String, Never>()
        let cancellable = subject
            .debounce(for: .seconds(1), scheduler: RunLoop.main)
            .sink { val in
                debug.log("debounce", val)
            }
        cancellable.store(in: &cancelSet)
        subject.send("A")
        subject.send("B")
        subject.send("C")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            subject.send("D")
        }
    }

    func ts10() {
        let publisher = [3, 4, 5].publisher
        let cancellable = publisher
            .prepend(1, 2)
            .sink { val in
                debug.log("prepend:", val)
            }
        cancellable.store(in: &cancelSet)
    }

    // 全部累加然后输出
    func ts9() {
        let numbers = [1, 2, 3, 4, 5]
        let publisher = numbers.publisher
        let cancellable = publisher
            .reduce(0) { accumulated, value in
                accumulated + value
            }
            .sink { val in
                debug.log("reduce-val", val)
            }
        cancellable.store(in: &cancelSet)
    }

    // 每次叠加上一个值
    func ts8() {
        let numbers = [1, 2, 3, 4, 5]
        let publisher = numbers.publisher
        let cancellable = publisher
            .scan(0) { accumulated, value in
                accumulated + value
            }
            .sink { val in
                debug.log("scan-val", val)
            }
        cancellable.store(in: &cancelSet)
    }

    func ts7() {
        let publisher = [1, 2, 3, 4, 5].publisher
        let cancelable = publisher
            .collect()
            .sink { val in
                debug.log("val:\(val)")
            }
        cancelable.store(in: &cancelSet)
    }

    // 必须全局
    var cancelSet = Set<AnyCancellable>()
    func ts6() {
        //
        func fetchDataPublisher(reqNum: Int) -> AnyPublisher<String, Error> {
            return Future<String, Error> { promise in
                DispatchQueue.global().asyncAfter(deadline: .now() + Double(reqNum)) {
                    promise(.success("response from request(reqNum)"))
                }
            }
            .eraseToAnyPublisher()
        }

        let seqPublisher = Publishers.Sequence(sequence: [1, 2, 3])
            .map { reqNum in
                fetchDataPublisher(reqNum: reqNum)
            }
            .switchToLatest()

        let cancellable = seqPublisher
            .print("abc")
            .sink { completion in
                switch completion {
                case .finished:
                    debug.log("finisah")
                    debug.log("completed")
                case .failure(let err):
                    debug.log("err:\(err)")
                }
            } receiveValue: { val in
                debug.log("val:\(val)")
            }
        cancellable.store(in: &cancelSet)
    }

    func ts5() {
        let publisher1 = PassthroughSubject<Int, Never>()
        let publisher2 = PassthroughSubject<String, Never>()
        let combinedPublisher = Publishers.Zip(publisher1, publisher2)
        let cancellable = combinedPublisher
            // .print("combine")
            .sink { val1, val2 in
                debug.log("Zip val: \(val1) and \(val2)")
            }
        publisher1.send(1)
        publisher2.send("A")
        publisher1.send(2)
        publisher2.send("B")
        cancellable.cancel()
    }

    func ts4() {
        let publisher1 = PassthroughSubject<Int, Never>()
        let publisher2 = PassthroughSubject<String, Never>()
        let combinedPublisher = Publishers.CombineLatest(publisher1, publisher2)
        let cancellable = combinedPublisher
            // .print("combine")
            .sink { val1, val2 in
                debug.log("combine val: \(val1) and \(val2)")
            }
        publisher1.send(1)
        publisher2.send("A")
        publisher1.send(2)
        publisher2.send("B")
        cancellable.cancel()
    }

    func ts3() {
        let publisher1 = [1, 2, 3].publisher
        let publisher2 = [4, 5, 6].publisher

        let mergePublisher = Publishers.Merge(publisher1, publisher2)
        let _ = mergePublisher
            .print("merge")
            .sink { completion in
                switch completion {
                case .finished:
                    debug.log("fffffnished")
                case .failure(let err):
                    debug.log("errrrrror", err)
                }
            } receiveValue: { value in
                debug.log("out:", value)
            }
    }

    private let titleLabel = UILabel()
    func ts2() {
        let publisher = NotificationCenter.Publisher(center: .default, name: .dataLoaded)
            .map { noti -> String? in
                return (noti.object as? ComItem)?.title
            }
        let subscriber = Subscribers.Assign(object: titleLabel, keyPath: \.text)
        publisher.subscribe(subscriber)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let data = ComItem(title: "我是一个标题")
        NotificationCenter.default.post(name: .dataLoaded, object: data)
        debug.log(titleLabel.text ?? "")
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

        let curSubject = CurrentValueSubject<Int, Never>(0)
        debug.log("CurrentValueSubject===")
        let cancellable = curSubject
            .print("cur=>")
            .map { $0 }
            .sink {
                debug.log("cur:", $0)
            }
        curSubject.value = 1
        curSubject.value = 2
        curSubject.send(completion: .finished)
        cancellable.cancel()
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
extension Date {
    func customFormatted() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        let formattedTime = formatter.string(from: self)
        return formattedTime
    }
}

///
extension Notification.Name {
    static let dataLoaded = Notification.Name("data_loaded")
}

struct ComItem {
    let title: String
}

///
class Weather {
    @Published var temperature: Double
    init(temperature: Double) {
        self.temperature = temperature
    }
}
