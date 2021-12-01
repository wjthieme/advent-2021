//
//  Auth.swift
//  Advent
//
//  Created by Wilhelm Thieme on 01/12/2021.
//

import Cocoa
import WebKit
import Combine

fileprivate let frame = NSRect(x: 0, y: 0, width: 1024, height: 768)

class AuthController: NSViewController {
    
    static func show() -> AnyPublisher<String, Error> {
        return Future<String, Error> { promise in
            DispatchQueue.main.async {
                let controller = AuthController(promise)
                let window = NSWindow(contentViewController: controller)
                window.styleMask = [.titled, .closable, .miniaturizable]
                window.delegate = controller
                window.title = "Github"
                window.makeKeyAndOrderFront(self)
            }
        }.eraseToAnyPublisher()
    }
    
    private var webView: WKWebView? { return view as? WKWebView }
    private let completion: (Result<String, Error>) -> Void
    
    override func loadView() {
        view = WKWebView(frame: frame)
    }
    
    private init(_ completion: @escaping ((Result<String, Error>) -> Void)) {
        self.completion = completion
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let url = URL(string: "https://github.com/login/oauth/authorize?client_id=7bb0a7ec13388aa67963&duration=temporary") else { return }
        webView?.navigationDelegate = self
        webView?.load(URLRequest(url: url))

    }
    
}

extension AuthController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.request.url?.host == "adventofcode.com" {
            if let url = navigationAction.request.url,
               let components = URLComponents(string: url.absoluteString),
               let code = components.queryItems?.first(where: { $0.name == "code" })?.value {
                completion(.success(code))
               } else {
                   completion(.failure(AuthErorr.invalidResponse))
               }
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
}

extension AuthController: NSWindowDelegate {
    func windowWillClose(_ notification: Notification) {
        completion(.failure(AuthErorr.cancelled))
    }
}

enum AuthErorr: LocalizedError {
    case cancelled
    case invalidResponse
}
