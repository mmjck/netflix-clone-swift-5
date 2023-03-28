//
//  HomeViewController.swift
//  Netflix Clone
//
//  Created by Jackson Matheus on 18/03/23.
//

import UIKit

enum Sections: Int {
    case TredingMovies =  0
    case Popular =  1
    case TrendTV =  2
    case Upcomming =  3
    case TopRated =  4
}

class HomeViewController: UIViewController {
    
    let sectionTitles: [String] = [
        "Treding Movies",
        "Popular",
        "Treding Tv",
        "Upcoming Movies",
        "Top rated",
    ]
    
    
    private var randomTrendingMovie:Title?
    private var headerView: HeroHeaderUIView?
    
    
    
    private let homeFeedTable: UITableView = {
        let table = UITableView(frame: .zero, style:  .grouped)
        table.register(ColletionViewTableViewCell.self, forCellReuseIdentifier:  ColletionViewTableViewCell.identifier)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        self.view.addSubview(homeFeedTable)
        
        
        self.homeFeedTable.delegate = self
        self.homeFeedTable.dataSource = self
        
        
        configureNavibar()
        
        
        headerView = HeroHeaderUIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 500))
        self.homeFeedTable.tableHeaderView = headerView
        configureHeroHeaderView()
        
    }
    
    
    private func configureHeroHeaderView(){
        
        APICaller.shared.getTrendingMovies { [weak self] result in
            switch result {
            case .success(let titles):
                let selectedTitle = titles.randomElement()
                self?.randomTrendingMovie = selectedTitle
                self?.headerView?.configure(with: TitleViewModel(titleName: selectedTitle?.original_title ?? "", posterURL: selectedTitle?.poster_path ?? ""))
                
            case .failure(let erorr):
                print(erorr.localizedDescription)
            }
        }
    }
    
    private func configureNavibar(){
        var image = UIImage(named: "netflixLogo")
        image = image?.withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: nil)
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person" ), style: .done, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle" ), style: .done, target: self, action: nil)
        ]
        
        navigationController?.navigationBar.tintColor = .white
    }
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeFeedTable.frame = self.view.bounds
    }
    
    
    
    private func fetchData(){
        APICaller.shared.getTrendingMovies {results in
            switch results {
            case .success(let movies):
                print(movies)
            case .failure(let error):
                print(error)
            }
            
        }
    }
    
    
    
    
    
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ColletionViewTableViewCell.identifier , for: indexPath) as? ColletionViewTableViewCell else {
            return UITableViewCell()
        }
        
        cell.delegate = self
        
        switch indexPath.section {
        case Sections.TredingMovies.rawValue:
            APICaller.shared.getTrendingMovies { result in
                switch result {
                case .success(let _titles):
                    cell.configure(with: _titles)
                case .failure(let error):
                    print(error.localizedDescription)
                    
                }
                
            }
        case Sections.TrendTV.rawValue:
            APICaller.shared.getTrendingTvs{ result in
                switch result {
                case .success(let _titles):
                    cell.configure(with: _titles)
                case .failure(let error):
                    print(error.localizedDescription)
                    
                }
                
            }
            
        case Sections.Popular.rawValue:
            APICaller.shared.getPopularMovies{ result in
                switch result {
                case .success(let _titles):
                    cell.configure(with: _titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
                
            }
        case Sections.Upcomming.rawValue:
            APICaller.shared.getUpcomingMovies{ result in
                switch result {
                case .success(let _titles):
                    cell.configure(with: _titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
                
            }
        case Sections.TopRated.rawValue:
            APICaller.shared.getTopRated{ result in
                switch result {
                case .success(let _titles):
                    cell.configure(with: _titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
                
            }
        default:
            return UITableViewCell()
            
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else {
            return
        }
        
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        header.textLabel?.textColor = .white
        header.textLabel?.frame = CGRect(x: header.bounds.width + 20, y: header.bounds.height, width: 100, height: header.bounds.height)
        header.textLabel?.text = header.textLabel?.text?.capitalizeFirstLetter()
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaultOffset
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
    }
}


extension HomeViewController: ColletionViewTableViewCellDelegate {
    func colletionViewTableViewCellDidTapCell(_ cell: ColletionViewTableViewCell, viewModel: TitlePreviewViewModel) {
        DispatchQueue.main.async { [weak self] in  
            let vc = TitlePreviewViewController()
            vc.configure(with: viewModel )
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
}
