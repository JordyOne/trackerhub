class Story

  def initialize(hash)
    @hash = hash
  end

  def name
    @hash['name']
  end

  def self.where(hash)
    conn = Faraday.new(:url => 'https://www.pivotaltracker.com/') do |faraday|
      faraday.request :url_encoded
      faraday.response :logger
      faraday.adapter Faraday.default_adapter
    end


    response = conn.get do |req|
      req.url "services/v5/projects/#{hash[:project_id]}/stories"
      req.headers['X-TrackerToken'] = ENV['TRACKERTOKEN']
    end

    array_of_hashes = JSON.parse(response.body)
    array_of_hashes.map do |hash|
      Story.new(hash)
    end
  end
end