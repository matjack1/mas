class MasService
  def initialize(term)
    @term = term
    @agent = Mechanize.new
  end

  def search
    link_en = find_first_article
    article_en = get_article_data(link_en)
    article_cy = find_welsh_translation(link_en)

    {
      english: article_en,
      welsh: article_cy
    }
  end

  def find_first_article
    page = @agent.get("https://www.moneyadviceservice.org.uk/en/search?query=#{@term}")
    "https://www.moneyadviceservice.org.uk" + page.search('.result-box a').first[:href]
  end

  def get_article_data(link)
    page = @agent.get(link)

    {
      title: page.search('h1').first.content,
      link: page.uri.to_s
    }
  end

  def find_welsh_translation(link_en)
    page = @agent.get(link_en)

    cy_link = page.search('#language_toggle').first[:href]
    if cy_link !=~ /not_found/
      get_article_data("https://www.moneyadviceservice.org.uk" + cy_link)
    end
  end
end

