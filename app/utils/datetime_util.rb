class DatetimeUtil
  def self.get_formatted_date(string=nil)
    unless string
      return Date.current.strftime("%Y/%m/%d")
    else
      return string.strftime("%Y/%m/%d")
    end
  end
end