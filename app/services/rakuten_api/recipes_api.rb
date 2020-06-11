module RakutenApi
  class RecipesApi
    def self.get(small_category_id)
      # 基本の設定
      conn = Faraday::Connection.new(:url => 'https://app.rakuten.co.jp') do |conn|
        conn.use Faraday::Request::UrlEncoded  # リクエストパラメータを URL エンコードする
        conn.use Faraday::Response::Logger     # リクエストを標準出力に出力する
      end

      # レシピAPIに必要なパラメータ
      params = {
        applicationId: '1032640051563308270',
        categoryId: category_id(small_category_id)
      }

      # 実際にリクエストを送る部分
      # GET https://app.rakuten.co.jp/services/api/Recipe/CategoryRanking/20170426?applicationId=_application_id_&categoryType=large
      response = conn.get do |req|
        req.url "/services/api/Recipe/CategoryRanking/20170426?", params
      end
    end

    private

    def self.category_id(small_category_id)
      category = Category.find_by(category_id: small_category_id)

      category_id = category.category_id
      category = category.parent_category
      while category
        category_id = "#{category.category_id}-#{category_id}"
        category = category.parent_category
      end

      category_id
    end
  end
end