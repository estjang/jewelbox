require 'time'
class Time
  def iso_8601
    strftime("%FT%T%z")
  end
end

