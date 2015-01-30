if ENV['RAILS_ENV'] == 'production'
  Analytics = Segment::Analytics.new({
    write_key: ENV['segment_io'],
    on_error: Proc.new { |status, msg| print msg }
  })
end