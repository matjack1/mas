require 'spec_helper'

describe SearchController do
  describe '#index' do
    before do
      get :index, { format: :json, term: 'car insurance' }
    end

    it 'reponds to index action and returns a JSON object' do
      expect { JSON.parse(response.body) }.to_not raise_error
    end
  end
end

