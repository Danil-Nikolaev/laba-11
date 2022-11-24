# frozen_string_literal: true

# This class contoller for work our application
class CalcController < ApplicationController
  def input; end

  def view
    check_params
    return unless @digit

    params_to_i
    res = CalcResult.find_by(value_one: @v1, value_two: @v2)
    p res
    check_res res

    results if params[:tag]["<id></id>"] == "1"
  end

  def evklid(num_one, num_two)
    while num_one != 0 && num_two != 0
      if num_one >= num_two
        num_one %= num_two
      else
        num_two %= num_one
      end
    end
    return num_one if num_one != 0

    num_two
  end

  def parse_params
    @v1 = params[:v1]
    @v2 = params[:v2]
    @digit = true
  end

  def check_params
    parse_params
    return unless /^\d+$/.match(@v1).nil? || /^\d+$/.match(@v2).nil?

    @result_one = 'Unknow'
    @result_two = 'Unknow'
    @digit = false
  end

  def params_to_i
    @v1 = @v1.to_i
    @v2 = @v2.to_i
  end

  def res_true(res)
    hash_result = ActiveSupport::JSON.decode(res.result)
    @result_one = hash_result['result_SCM']
    @result_two = hash_result['result_LCD']
    p hash_result
  end

  def res_false
    @result_one = evklid(@v1, @v2)
    @result_two = (@v1 * @v2) / @result_one
    local_res = CalcResult.create value_one: @v1, value_two: @v2, result: ActiveSupport::JSON.encode(
      result_SCM: @result_one,
      result_LCD: @result_two
    )
    local_res.save
  end

  def check_res(res)
    if res
      res_true res
    else
      res_false
    end
  end

  def results
    @result = CalcResult.all
   render json: @result
    end

end
