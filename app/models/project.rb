class Project
  def initialize(hash)
    @hash = hash
  end

  def self.all
    conn = Faraday.new(:url => 'https://www.pivotaltracker.com/') do |faraday|
      faraday.request :url_encoded
      faraday.response :logger
      faraday.adapter Faraday.default_adapter
    end


    response = conn.get do |req|
      req.url 'services/v5/projects'
      req.headers['X-TrackerToken'] = ENV['TRACKERTOKEN']
    end
    array_of_hashes = JSON.parse(response.body)
    array_of_hashes.map do |hash|
      Project.new(hash)

    end
  end

  def name
    @hash['name'].upcase
  end

  def self.find(id)
    conn = Faraday.new(:url => 'https://www.pivotaltracker.com/') do |faraday|
      faraday.request :url_encoded
      faraday.response :logger
      faraday.adapter Faraday.default_adapter
    end


    response = conn.get do |req|
      req.url "services/v5/projects/#{id}"
      req.headers['X-TrackerToken'] = ENV['TRACKERTOKEN']
    end

    result = JSON.parse(response.body)
    Project.new(result)

  end

  def id
    @hash['id']
  end

  def to_param
    id.to_s
  end

  def stories
    Story.where(project_id: id)
  end

end
