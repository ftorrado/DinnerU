# Class for retrieving data from the Zomato API
# https://developers.zomato.com/documentation
class ZomatoController < ApplicationController
  API_HOST = 'https://developers.zomato.com/api/v2.1/'

  def locations
    request_params = { query: params[:q] }
    if params[:lat] && params[:lon]
      request_params.merge!(lat: params[:lat], lon: params[:lon])
    end
    req_result = api_get_request 'locations', request_params
    @locations = JSON.parse(req_result)
    respond_to do |format|
      format.json { render json: req_result }
    end
  end

  def restaurants
    request_params = { query: params[:q] }
    if params[:city_id]
      request_params.merge!(entity_id: params[:city_id], entity_type: 'city')
    end
    req_result = api_get_request 'search', request_params
    @restaurants = JSON.parse(req_result)
    respond_to do |format|
      format.html { render '_restaurant_list' }
      format.json { render json: req_result }
    end
  end

  private

    def api_get_request(endpoint, query_params = {})
      uri_str = URI.escape("#{API_HOST}#{endpoint}")
      uri_str += '?' if query_params.length > 0
      query_params.each do |key, value|
        uri_str += URI.escape("#{key}=#{value}")
      end
      uri_str.chomp if query_params.length > 0

      uri = URI.parse(uri_str)
      request = Net::HTTP::Get.new(uri)
      request['Accept'] = 'application/json'
      request['user-key'] = '32358c30e1e96103a5da0147d503d8ef'
      response = Net::HTTP.start(uri.host, uri.port,
                                 :use_ssl => uri.scheme == 'https') do |http|
        http.request request
      end

      return response.value unless response.is_a? Net::HTTPSuccess
      response.body
    end
end
