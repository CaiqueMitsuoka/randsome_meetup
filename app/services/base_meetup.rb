class BaseMeetup
  def initialize(session = nil, options = {})
    if session || !options.empty?
      @session = session
      @token = session[:token] || options[:token]
      @refresh_token = session[:refresh_token] || options[:refresh_token]
    end
  end

  def self_events(desc = true)
    events_json = get("/self/events?desc=#{desc}&fields=event_hosts")
    events_hash = parse_json_array(events_json)
    events_hash.map { |c| Meetup::Event.new(c) }
  end

  def attendance(urlname, event_id)
    responses_json = get("/#{urlname}/events/#{event_id}/attendance")
    responses_hash = parse_json_array( responses_json )
    responses_hash.map { |response| Meetup::Attendee.new(response[:member]) }
  end

  def event(urlname, event_id)
    event_hash = parse_json( get("/#{urlname}/events/#{event_id}") )
    Meetup::Event.new(event_hash)
  end

  def profile_image (member_id)
    parse_json( get("/members/#{member_id}") )
  end

  def get(endpoint)
    Rails.cache.fetch(endpoint, expires: 5.minutes) do
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
