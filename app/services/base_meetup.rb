class BaseMeetup
  def initialize(token)
    @token = token
  end

  def self_events(desc = true)
    get "/self/events?desc=#{desc}"
  end

  def attendence(urlname, event_id)
    get("/#{urlname}/events/#{event_id}/attendance")
  end

  def event(urlname, event_id)
    get("/#{urlname}/events/#{event_id}")
  end

  def get(endpoint, headers = header)
    parse_json( RestClient.get(meetup_url(endpoint), headers) )
  end

  private
  def meetup_url(endpoint = '')
    'https://api.meetup.com' + endpoint
  end

  def header
    { Authorization: "Bearer #{@token}" }
  end

  def parse_json(response)
    JSON.parse(response.to_s)
  end
end
