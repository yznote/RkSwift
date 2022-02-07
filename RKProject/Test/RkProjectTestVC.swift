//
//  RkProjectTestVC.swift
//  RKProject
//
//  Created by YB007 on 2020/11/24.
//

import UIKit

import RxSwift
import RxCocoa

class RkProjectTestVC: RKBaseVC {

    var thBtn1 = UIButton()
    var thBtn2 = UIButton()
    var thBtn3 = UIButton()
    func createBtn(_ title:String) -> UIButton {
        let btn = UIButton()
        btn.setTitle(title, for: .normal)
        btn.setTitleColor(.blue, for: .normal)
        btn.setTitleColor(.white, for: .selected)
        btn.layer.cornerRadius = 5;
        btn.layer.masksToBounds = true
        btn.setBackgroundImage(rkImageFromColor(color: .blue, viewSize: CGSize(width: 1, height: 1)), for: .selected)
        btn.setBackgroundImage(rkImageFromColor(color: .clear, viewSize: CGSize(width: 1, height: 1)), for: .normal)
        return btn
    }
    var testRedBtn:UIButton = {
        var btn = UIButton()
        btn.backgroundColor = .yellow
        btn.layer.cornerRadius = 5;
        btn.layer.masksToBounds = true
        return btn
    }()
    
    var testStr:String = ""
    
    var testTF:UITextField = {
        var tf = UITextField()
        tf.textColor = .black
        tf.font = .rkFont(ofSize: 15)
        tf.layer.borderWidth = 1
        tf.layer.masksToBounds = true
        tf.layer.borderColor = UIColor.black.cgColor
        tf.layer.cornerRadius = 5;
        tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 40))
        tf.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 40))
        tf.leftViewMode = .always
        tf.rightViewMode = .always
        return tf
    }()
    
    var showL:UILabel = {
        var la = UILabel()
        la.textAlignment = .center
        la.textColor = .black
        la.text = "初始值"
        la.font = UIFont.rkFont(ofSize: 15)
        la.backgroundColor = .yellow
        return la
    }()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let cor = "#123456".rkStringConvertColor()
//        let corW = UIColor(hexString: "ffffff", alpha: 1.0)
//        rkprint("corlor1:\(cor)===corlor2:\(corW)")
        
        let btn = UIButton()
        btn.backgroundColor = .red
        btn.addTarget(self, action: #selector(clikcBtn), for: .touchUpInside)
        self.view.addSubview(btn)
        btn.snp.makeConstraints { (make) in
            make.width.equalTo(60)
            make.height.equalTo(40)
            make.centerX.equalToSuperview()
            make.top.equalTo(self.view).offset(100)
        }
        
        //
        view.addSubview(showL)
        showL.snp.makeConstraints { (make) in
            make.centerX.equalTo(btn)
            make.top.equalTo(btn.snp.bottom).offset(rklayout(15))
        }
        
        //
        view.addSubview(testTF)
        testTF.snp.makeConstraints { (make) in
            make.width.equalTo(view.snp.width).multipliedBy(0.7)
            make.centerX.equalTo(view.snp.centerX)
            make.height.equalTo(rklayout(40))
            make.top.equalTo(showL.snp.bottom).offset(5)
        }
        
        view.addSubview(testRedBtn)
        testRedBtn.snp.makeConstraints { (make) in
            make.width.height.centerX.equalTo(btn);
            make.top.equalTo(testTF.snp.bottom).offset(rklayout(10))
        }
        
        thBtn2 = createBtn("测试2")
        view.addSubview(thBtn2)
        thBtn2.snp.makeConstraints { (make) in
            make.width.equalTo(rklayout(60))
            make.height.equalTo(rklayout(40))
            make.centerX.equalTo(view)
            make.top.equalTo(testRedBtn.snp.bottom).offset(rklayout(15))
        }
        
        thBtn1 = createBtn("测试1")
        view.addSubview(thBtn1)
        thBtn1.snp.makeConstraints { (make) in
            make.width.height.centerY.equalTo(thBtn2)
            make.right.equalTo(thBtn2.snp.left).offset(-10)
        }
        thBtn3 = createBtn("测试3")
        view.addSubview(thBtn3)
        thBtn3.snp.makeConstraints { (make) in
            make.width.height.centerY.equalTo(thBtn2)
            make.left.equalTo(thBtn2.snp.right).offset(10)
        }
        thBtn1.isSelected = true
        
        
        
        
        RxSwiftTest()
        
    }
    
    
    
    func RxSwiftTest() {
        /*
        let observable = Observable.of("A","B","C")

        let subscription = observable.subscribe{ event in
            rkprint(event)
        }
        subscription.dispose()
        */
        
        /*
        let disposeBag = DisposeBag()
        
        let observable1 = Observable.of("A","B","C")
        observable1.subscribe{event in
            rkprint(event)
        }.disposed(by: disposeBag)
        
        let observable2 = Observable.of(1,2,3)
        observable2.subscribe{event in
            rkprint(event)
        }.disposed(by: disposeBag)
        */
        
//        let disposeBag = DisposeBag()
//        let observable = Observable.of("A","B","C")
//
//        observable.subscribe { (element) in
//            rkprint(element)
//        } onError: { (error) in
//            rkprint(error)
//        } onCompleted: {
//            rkprint("completed")
//        }.disposed(by: disposeBag)

        
//        let observable = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
//        observable
//            .map{"当前索引数:\($0)"}
//            .bind {[weak self](text) in
//                self?.showL.text = text
//                rkprint("=====:\(text)")
//            }
//            .disposed(by:disposeBag)
//
        
        /*
        let observer: AnyObserver<String> = AnyObserver{[weak self](event) in
            switch event{
            case .next(let text):
                self?.showL.text = text
            default:
                break
            }
        }
        
        let observable = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
        observable
            .map{"当前索引:\($0)"}
            .bind(to: observer)
            .disposed(by: disposeBag)
        */
        
        /*
        let observer: Binder<String> = Binder(showL){(view,text) in
            view.text = text
        }
        
        let observable = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
        observable.map{"现在:\($0)"}
            .bind(to: observer)
            .disposed(by: disposeBag)
        
        */
        
        /*
        let observable = Observable<Int>.interval(.milliseconds(500), scheduler: MainScheduler.instance)
        observable
            .map{ CGFloat($0) }
            .bind(to: showL.fontSize)
            .disposed(by: disposeBag)
        */
        
        /*
        let observable = Observable<Int>.interval(.seconds(2), scheduler: MainScheduler.instance)
        observable
            .map{ "索引:\($0)" }
            .bind(to: showL.rx.text)
            .disposed(by: disposeBag)
        */
        
        /*
        let subject = PublishSubject<String>()
        subject.onNext("111")
        
        subject.subscribe { (string) in
            rkprint("第1次订阅:\(string)")
        }onCompleted: {
            rkprint("第1次订阅-completed")
        }.disposed(by: disposeBag)

        subject.onNext("222")
        
        subject.subscribe { (string) in
            rkprint("第2次订阅:",string)
        } onCompleted: {
            rkprint("第2次订阅-completed")
        }.disposed(by: disposeBag)
        
        subject.onNext("333")
        
        subject.onCompleted()
        
        subject.subscribe { (string) in
            rkprint("第三次订阅:",string)
        } onCompleted: {
            rkprint("第3次订阅-completed")
        }.disposed(by: disposeBag)

        */
        
        /*
        Observable.of(2,30,1,3,5,100,50,60)
            .filter{ $0 > 10 }
            .subscribe(onNext:{ print($0) })
            .disposed(by: disposeBag)
        */
        
        /*
        Observable.of(1,2,3,1,1,2,2,3,4,5,6,6,6)
            .distinctUntilChanged()
            .subscribe(onNext:{print($0)})
            .disposed(by: disposeBag)
        */
        
        /*
        Observable.of(1,2,3,4,5)
            .single({$0 == 2})
            .subscribe(onNext:{print($0)})
            .disposed(by: disposeBag)
        */
        
        /*
        Observable.of("A","B","C","D")
            .single()
            .subscribe(onNext:{print($0)})
            .disposed(by: disposeBag)
        */
        
        /*
        Observable.of(1,2,3,4,5)
            .element(at: 5)
            .subscribe(onNext:{
                print($0)
            })
            .disposed(by: disposeBag)
        */
        
        /*
        Observable.of(1,2,3,4,5)
            .take(6)
            .subscribe(onNext: {print($0)})
            .disposed(by: disposeBag)
        */
        
        /*
        let source = PublishSubject<Int>()
        let notifier = PublishSubject<String>()
        
        source.sample(notifier)
            .subscribe(onNext:{print($0)})
            .disposed(by: disposeBag)
        
        source.onNext(1)
        
//        notifier.onNext("A")
        
        source.onNext(2)
        
        notifier.onNext("B")
//        notifier.onNext("C")
        
        source.onNext(3)
        notifier.onCompleted()
        */
        
        /*
        let times = [["value":1,"time":0.1],
                    ["value":2,"time":1.1],
                    ["value":3,"time":1.2],
                    ["value":4,"time":1.2],
                    ["value":5,"time":1.4],
                    ["value":6,"time":2.1],
        ]
        
        Observable.from(times)
            .flatMap({item in
                return Observable.of(Int(item["value"]!))
                    .delaySubscription(.milliseconds(Int(item["time"]!)*1000), scheduler: MainScheduler.instance)
            })
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)//只发出与下一个间隔超过0.5秒的元素
            .subscribe(onNext:{print($0)})
            .disposed(by: disposeBag)
        */
        
        /*
        //先入为主
        let subject1 = PublishSubject<Int>()
        let subject2 = PublishSubject<Int>()
        let subject3 = PublishSubject<Int>()
         
        subject1
            .amb(subject2)
            .amb(subject3)
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
         
        subject3.onNext(111)
        subject1.onNext(0)
        subject2.onNext(1)
        subject1.onNext(20)
        subject2.onNext(2)
        subject1.onNext(40)
        subject3.onNext(0)
        subject2.onNext(3)
        subject1.onNext(60)
        subject3.onNext(0)
        subject3.onNext(0)
        */
        
        /*
        Observable.of(2,3,4)
            .startWith(2)
            .subscribe(onNext:{print($0)})
            .disposed(by: disposeBag)
        */
        
        /*
        Observable.of(1,2,3,4,5)
            .reduce(1, accumulator: +)
            .subscribe(onNext:{print($0)})
            .disposed(by: disposeBag)
        */
        rkprint("inter--");
        
        /*
        Observable.of(1,2,1)
            .delay(.seconds(3), scheduler: MainScheduler.instance)
            .subscribe(onNext:{print($0)})
            .disposed(by: disposeBag)
        */
        
        /*
        Observable.of(1,2,3,4)
//            .materialize()
//            .dematerialize()
//            .delay(.seconds(2), scheduler: MainScheduler.instance)
//            .delaySubscription(.seconds(2), scheduler: MainScheduler.instance)
            .debug()
            .subscribe(onNext:{print($0)})
            .disposed(by: disposeBag)
            
        */
    
        /*
        RKNetwork.rkloadData(target: RKHomeApi.homeConfig, model: HomeConfigModel.self, showHud: true)
        { (returnData, returnDic) in
            
        } failure: { (errorCode, errorDes) in
            
        }
        */

        /*
        testTF.rx.text
            .bind(to: showL.rx.text)
            .disposed(by: disposeBag)
        */
        
        /*
        testRedBtn.rx.tap
            .subscribe(onNext:{
                print("按钮被点击了")
            })
            .disposed(by: disposeBag)
        */
        
        /*
        testTF.rx.text.orEmpty.changed
            .subscribe(onNext:{print("输入:\($0)")})
            .disposed(by: disposeBag)
        */
        let buttons = [thBtn1,thBtn2,thBtn3].map({$0!})
        
        //创建一个可观察序列，它可以发送最后一次点击的按钮（也就是我们需要选中的按钮）
        let selBtn = Observable.from(buttons.map({ btn in
            btn.rx.tap.map({btn})
        })).merge()
        
        for btn in buttons {
            selBtn.map({$0 == btn})
                .bind(to: btn.rx.isSelected)
                .disposed(by: disposeBag)
        }
        

//        testTF.rx.textInput <-> self.showL.text
    
        
            
        
        
        
        
        
        
    }
    
    
    deinit {
        print("out==")
    }
    
    
    
    
    
    
    
    
    @objc func clikcBtn(){
        /*
        let alertV = RKAlertView(title: "", message: "2222", style: .alert)
        let cancelA = RKAlertAction(title: "取消", style: .cancel) { (action) in
            rkprint("clcik：\(action.actionTitleStr!)")
        }
        let sureA = RKAlertAction(title: "确认", style: .confirm) { (action) in
            rkprint("clcik：\(action.actionTitleStr!)")
        }
        let aaaa = RKAlertAction(title: "又一个", style: .normal) { (action) in
            rkprint("clcik：\(action.actionTitleStr!)")
        }
        alertV.addAction(action: cancelA)
        alertV.addAction(action: sureA)
        alertV.addAction(action: aaaa)
        alertV.show()
        */
        
//        rkLoadingHud(title: rkLocalized(key: "你好年后"))
//        DispatchQueue.main.asyncAfter(deadline: .now()+3) {
//            rkHideHud()
//        }
    
    }
    
    
    
}
/*
extension UILabel{
    public var fontSize :Binder<CGFloat> {
        return Binder(self){label,fontSize in
            rkprint("sss:\(fontSize)")
            label.font = UIFont.rkFont(ofSize: fontSize)
        }
    }
}
*/

extension Reactive where Base: UILabel {
    public var fontSize: Binder<CGFloat>{
        return Binder(self.base){(label,fontSize) in
            rkprint("sss:\(fontSize)")
            label.font = UIFont.rkFont(ofSize: fontSize)
        }
    }
}
