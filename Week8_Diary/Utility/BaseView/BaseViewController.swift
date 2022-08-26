//
//  BaseViewController.swift
//  SeSAC2DiaryRealm
//
//  Created by 황호 on 2022/08/21.
//

import UIKit

class BaseViewController: UIViewController {
    
    
    // MARK: Initializing
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    deinit {
        print("❤️❤️❤️❤️ DEINIT: \(Self.reuseIdentifier) ❤️❤️❤️❤️")
    }
    
    
    // MARK: Life Cycle Views
    
    override func viewDidLoad() {
        
        setupAttributes()
        setupLayout()
//        setupLocalization()
//        setupBinding()
        setData()
//        self.view.setNeedsUpdateConstraints()
    }
    
    
    // MARK: Setup
    
    /**
     code로 Layout 잡을 때 해당 함수 내부에서 작성
     */
    func setupLayout() {
        // Override Layout
    }
    
    /**
     기본 속성(Attributes) 관련 정보 (ex Background Color,  Font Color ...)
     */
    func setupAttributes() {
        // Override Attributes
        view.backgroundColor = .clear
    }
    
    /**
     서버 통신 or 데이터 관련
     */
    func setData() {
        // Override Set Data
    }
    
    //    /**
    //     setupLocalization
    //    */
    //    func setupLocalization() {
    //        // Override Localization
    //    }
    //
    //    /**
    //     setupLifeCycleBinding
    //    */
    //    func setupLifeCycleBinding() {
    //        // Override Binding for Lify Cycle Views
    //    }
    //
    //    /**
    //     setupBinding
    //    */
    //    func setupBinding() {
    //        // Override Binding
    //    }
    //
    
    
}
