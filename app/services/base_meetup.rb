class BaseMeetup
  def initialize(session)
    @session = session
    @token = session[:token]
    @refresh_token = session[:refresh_token]
  end

  def self_events(desc = true)
    parse_json_array( get("/self/events?desc=#{desc}&fields=event_hosts") )
  end

  def attendance(urlname, event_id)
    parse_json_array( get("/#{urlname}/events/#{event_id}/attendance") )
  end

  def event(urlname, event_id)
    parse_json( get("/#{urlname}/events/#{event_id}") )
  end

  def profile_image (member_id)
    member = parse_json ( get("/members/#{member_id}") )
    if member[:photo]
      return member[:photo][:photo_link]
    end
    ['brown-egg.jpg','white-egg.jpg'].sample
  end

  def get(endpoint)
    attempts ||= 0
    begin
      RestClient.get(meetup_url(endpoint), header)
    rescue RestClient::Unauthorized
      if !(attempts > 0)
        attempts += 1
        puts "Trying to refresh the session token..."
        refresh_session_token
        retry
      end
    end
  end

  def refresh_session_token
    credentials =
    parse_json( RestClient.post('https://secure.meetup.com/oauth2/access?' +
    "client_id=#{ENV['MEETUP_KEY']}" +
    "&client_secret=#{ENV['MEETUP_SECRET']}" +
    '&grant_type=refresh_token' +
    "&refresh_token=#{@refresh_token}", nil) )

    @token = @session[:token] = credentials[:access_token]
    @refresh_token = @session[:refresh_token] = credentials[:refresh_token]
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
