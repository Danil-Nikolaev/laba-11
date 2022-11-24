# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Calcs', type: :request do
  describe 'GET /input' do
    it 'returns http success' do
      get '/calc/input'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /view' do
    it 'returns http success' do
      get '/calc/view'
      expect(response).to have_http_status(:success)
    end
    it 'returns for values 2 and 3 - 1' do
      get '/calc/view', params: { :v1 => '2', :v2 => '3', 'commit' => 'Calc result' }
      expect(controller.instance_variable_get(:@result_one)).to eq(1)
    end
    it 'returns for values 2 and 3 - 6' do
      get '/calc/view', params: { :v1 => '2', :v2 => '3', 'commit' => 'Calc result' }
      expect(controller.instance_variable_get(:@result_two)).to eq(6)
    end
    it 'check model' do
      res = CalcResult.find_by(value_one: @v1, value_two: @v2)
      res&.destroy
      v1 = 2
      v2 = 3
      result_one = 1
      result_two = 6
      local_res = CalcResult.create value_one: v1, value_two: v2, result: ActiveSupport::JSON.encode(
        result_SCM: result_one,
        result_LCD: result_two
      )
      local_res.save
      res = CalcResult.find_by(value_one: v1, value_two: v2)
      hash_result = ActiveSupport::JSON.decode(res.result)
      result_one = hash_result['result_SCM']
      result_two = hash_result['result_LCD']
      expect(result_one).to eq(1)
      expect(result_two).to eq(6)
    end
  end
end
