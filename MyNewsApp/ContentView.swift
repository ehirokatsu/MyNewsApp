import SwiftUI
import Combine


struct News: Codable {
    let articles: [Article]
}

struct Article: Codable {
    let title: String
}

struct ContentView: View {
    @State private var articles: [Article] = []

    var body: some View {
        List(articles, id: \.title) { article in
            Text(article.title)
        }
        .onAppear(perform: loadNews)
    }

    func loadNews() {
        let urlString = "https://newsapi.org/v2/top-headlines?country=jp&apiKey=7b2095031fa64f83b6aaf34169dc870e"
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
                let decoder = JSONDecoder()
                if let news = try? decoder.decode(News.self, from: data) {
                    DispatchQueue.main.async {
                        self.articles = news.articles
                    }
                }
            }
        }.resume()
    }
}


#Preview {
    ContentView()
}
