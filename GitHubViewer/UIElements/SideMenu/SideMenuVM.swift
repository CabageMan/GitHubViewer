import UIKit

final class SideMenuVM {
    
    typealias Section = SideMenuTableView.Section
    typealias MenuItem = SideMenuTableView.MenuItem
    
    let router: GithubViewerRouter
    let menuTable: SideMenuTableView
    
    init(router: GithubViewerRouter) {
        self.router = router
        menuTable = SideMenuTableView()
        createMenuItems()
    }
    
    //MARK: - Actions
    private func createMenuItems() {
        var sections: [Section] = []
        if let ownUser = Global.apiClient.ownUser {
            let infoMenuItem: MenuItem = .info(ownUser.login)
            let sectionItem: Section = .info(infoMenuItem)
            sections.append(sectionItem)
        }
        sections.append(.appMenu([.firstFakeItem, .secondFakeItem, .thirdFakeItem]))
        sections.append(.appMenu([.settings, .logout]))
        
        menuTable.sections = sections
    }
}
