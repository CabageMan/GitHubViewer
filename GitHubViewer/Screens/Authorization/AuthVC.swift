import UIKit

final class AuthVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .cyan
        Global.showComingSoon()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        findIssue()
    }
    
    private func findIssue() {
        GitHubViewerApollo.shared.client.fetch(query: FindIssueIdQuery()) { result in
            log("Result: \(result)")
        }
    }
}
