require 'spec_helper'

describe MasService do
  let(:term) { 'car' }

  let(:mas) { MasService.new(term) }

  describe '#execute' do
    let(:title_en) { 'Title EN' }
    let(:link_en) { 'http://MAS.en' }

    let(:article_en) do
      {
        title: title_en,
        link: link_en
      }
    end

    let(:title_cy) { 'Title CY' }
    let(:link_cy) { 'http://MAS.cy' }

    let(:article_cy) do
      {
        title: title_cy,
        link: link_cy
      }
    end

    let(:sample_hash) do
      {
        english: article_en,
        welsh: article_cy
      }
    end

    before do
      allow_any_instance_of(MasService).to receive(:find_first_article).and_return(link_en)
      allow_any_instance_of(MasService).to receive(:get_article_data).with(link_en).and_return(article_en)
      allow_any_instance_of(MasService).to receive(:find_welsh_translation).with(link_en).and_return(article_cy)
    end

    it 'returns a results hash following a search on MAS website' do
      hash = mas.search

      expect(hash).to eq(sample_hash)
    end
  end

  describe '#find_first_article' do
    it 'fetches the search page from MAS and extracts the first result link' do
      link_en = mas.find_first_article

      expect(link_en).to eq('https://www.moneyadviceservice.org.uk/en/articles/car-insurance-for-young-drivers')
    end
  end

  describe '#get_article_data' do
    it 'builds a hash with article title and link' do
      article_hash = mas.get_article_data('https://www.moneyadviceservice.org.uk/en/articles/car-insurance-for-young-drivers')

      expect(article_hash).to eq({
        title: 'Car insurance for young drivers - the key facts',
        link: 'https://www.moneyadviceservice.org.uk/en/articles/car-insurance-for-young-drivers'
      })
    end
  end

  describe '#find_welsh_translation' do
    it 'gets the welsh article translation of an english page' do
      article_hash = mas.find_welsh_translation('https://www.moneyadviceservice.org.uk/en/articles/car-insurance-for-young-drivers')

      expect(article_hash).to eq({
        title: 'Yswiriant car i yrwyr ifanc - y ffeithiau allweddol',
        link: 'https://www.moneyadviceservice.org.uk/cy/articles/yswiriant-car-i-yrwyr-ifanc---y-ffeithiau-allweddol'
      })
    end
  end
end

