class BaseMeetup
  def initialize(token)
    @token = token
  end

  def self_events(desc = true)
    parse_json_array( get("/self/events?desc=#{desc}") )
  end

  def attendence(urlname, event_id)
    parse_json_array( get("/#{urlname}/events/#{event_id}/attendance") )
  end

  def event(urlname, event_id)
    parse_json( get("/#{urlname}/events/#{event_id}") )
  end

  def get(endpoint, headers = header)
    RestClient.get(meetup_url(endpoint), headers)
  end

  private
  def meetup_url(endpoint = '')
    'https://api.meetup.com' + endpoint
  end

  def header
    { Authorization: "Bearer #{@token}" }
  end

  def parse_json_array(response)
    JSON.parse(response.to_s).reduce([]) do |collection, item|
      collection.push(item.deep_symbolize_keys)
    end
  end

  def parse_json(response)
    JSON.parse(response.to_s).deep_symbolize_keys
  end
end
