require 'time'
class Time
  def iso8601
    strftime("%FT%T%z")
  end
end
