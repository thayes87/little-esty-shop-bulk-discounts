class GitHub
  attr_reader :title

  def initialize(data)
    @title = data[:title]
  end
end
