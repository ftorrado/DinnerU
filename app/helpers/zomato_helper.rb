module ZomatoHelper
  def url_full_list params
    return '' unless params.has_key? :entity_type
    "https://www.zomato.com/index.php?entity_type=#{params[:entity_type]}&" +
      "entity_id=#{params[:entity_id]}&" +
      "#{params[:entity_type]}=#{params[:entity_id]}&" +
      "q=#{params[:q].gsub('&','&amp;').gsub('<','&lt;').gsub('>','&gt;')}"
  end
end
