class Timefly

  attr_accessor :origin_time

  TIME_UNIT_MAPPER = {
    second: { short: 's', full: 'second' },
    minute: { short: 'm', full: 'minute' },
    hour: { short: 'h', full: 'hour' },
    day: { short: 'd', full: 'day' },
    week: { short: 'w', full: 'week' },
    month: { short: 'mo', full: 'month' },
    year: { short: 'y', full: 'year' },
  }

  DEFAULT_FORMAT = '%n %U ago'

  # initialize with either String, Time or Date instance
  # Arguments:
  #   origin_time: (String/Time/Date)
  def initialize(origin_time)
    self.origin_time = origin_time
    process
  end

  # returns the age in years from the date of birth
  #
  # Example:
  #   >> dob = Time.new(1987,8,2)
  #   >> Timefly.new(dob).age
  #   => 27
  #   >> Timefly.new('1987.08.02').age # dob can be of format YYYY.MM.DD, YYYY-MM-DD and YYYY/MM/DD
  #   => 27
  #   >> Timefly.new('1987.08.02').age({ format: '%y years, %m months' })
  #   => 27 years, 10 months
  #
  # Arguments:
  #   options: (Hash) { format  :(String) }
  #                             eg, '%y years, %m months'. %y will give years, and %m will give months
  def age(options = {})
    if options[:format].nil?
      years_from_origin_time
    else
      options[:format]
        .gsub(/\%y/, years_from_origin_time.to_s)
        .gsub(/\%m/, months_diff_from_origin_time_month.to_s)
    end
  end

  # returns the time elapsed in a readable format
  #
  # Example:
  #   >> Timefly.new(origin_time).time_elapsed
  #   => '4 hours ago'
  def elapsed_time(options = {})
    if time_elapsed_in_seconds?
      elapsed_time_in_seconds(options)
    elsif time_elapsed_in_minutes?
      elapsed_time_in_minutes(options)
    elsif time_elapsed_in_hours?
      elapsed_time_in_hours(options)
    elsif time_elapsed_in_days?
      elapsed_time_in_days(options)
    elsif time_elapsed_in_weeks?
      elapsed_time_in_weeks(options)
    elsif time_elapsed_in_months?
      elapsed_time_in_months(options)
    else
      elapsed_time_in_years(options)
    end
  end

  private

  # This method tries to convert the origin_time to Time
  def process
    if origin_time.is_a? String
      convert_string_origin_time
    elsif !origin_time.is_a?(Time) && !origin_time.is_a?(Date)
      fail("#{origin_time.class.name} is not a supported origin_time")
    end
  end

  #convert dob to Time if it is in String
  def convert_string_origin_time
    #TODO: improve this method
    separator = '.'
    if origin_time.include?('/')
      separator = '/'
    elsif origin_time.include?('-')
      separator = '-'
    end
    dob_arr = origin_time.split(separator).map{ |d| d.to_i }
    self.origin_time = Time.new(dob_arr[0], dob_arr[1], dob_arr[2])
  end

  # This method gets the months difference since the origin_time month
  def months_diff_from_origin_time_month
    origin_time_month = origin_time.strftime('%m').to_i
    now_month = Time.now.strftime('%m').to_i
    if origin_time_month == now_month
      0
    elsif origin_time_month > now_month
      12-(origin_time_month-now_month).abs
    else
      now_month-origin_time_month
    end
  end

  # This method gets the years elapsed since origin_time
  def years_from_origin_time
    origin_time_years = origin_time.strftime('%Y').to_i
    now_years = Time.now.strftime('%Y').to_i
    origin_time_month = origin_time.strftime('%m').to_i
    now_month = Time.now.strftime('%m').to_i
    if origin_time_month == now_month
      dob_date = origin_time.strftime('%d').to_i
      now_date = Time.now.strftime('%d').to_i
      if now_date > dob_date
        now_years - origin_time_years - 1
      else
        now_years - origin_time_years
      end
    elsif origin_time_month > now_month
      now_years - origin_time_years - 1
    else
      now_years - origin_time_years
    end
  end

  # START time_elapsed helper methods --------------------------------

  def time_diff_in_secs
    @time_diff_in_secs ||= (Time.now - origin_time).to_i.abs
  end

  def time_elapsed_in_seconds?
    time_diff_in_secs < 60
  end

  def time_elapsed_in_minutes?
    (time_diff_in_secs / 60) < 60
  end

  def time_elapsed_in_hours?
    (time_diff_in_secs / (60 * 60)) < 24
  end

  def time_elapsed_in_days?
    (time_diff_in_secs / (60 * 60 * 24)) < 7
  end

  def time_elapsed_in_weeks?
    (time_diff_in_secs / (60 * 60 * 24 * 30)) < 1 && (time_diff_in_secs / (60 * 60 * 24 )) >= 7
  end

  def time_elapsed_in_months?
    (time_diff_in_secs / (60 * 60 * 24 * 30)) < 12
  end

  def elapsed_time_in_seconds(options = {})
    if options[:format].nil?
      'a few seconds ago'
    else
      elapsed_time_in_unit(time_diff_in_secs, :second, options)
    end
  end

  def elapsed_time_in_minutes(options = {})
    time_diff = time_diff_in_secs / 60
    elapsed_time_in_unit(time_diff, :minute, options)
  end

  def elapsed_time_in_hours(options = {})
    time_diff = time_diff_in_secs / (60 * 60)
    elapsed_time_in_unit(time_diff, :hour, options)
  end

  def elapsed_time_in_days(options = {})
    time_diff = time_diff_in_secs / (60 * 60 * 24)
    elapsed_time_in_unit(time_diff, :day, options)
  end

  def elapsed_time_in_weeks(options = {})
    time_diff = time_diff_in_secs / (60 * 60 * 24 * 7)
    elapsed_time_in_unit(time_diff, :week, options)
  end

  def elapsed_time_in_months(options = {})
    time_diff = time_diff_in_secs / (60 * 60 * 24 * 30)
    elapsed_time_in_unit(time_diff, :month, options)
  end

  def elapsed_time_in_years(options = {})
    time_diff = time_diff_in_secs / (60 * 60 * 24 * 30 * 12)
    elapsed_time_in_unit(time_diff, :year, options)
  end

  def elapsed_time_in_unit(time_diff, unit_type, options = {})
    options[:format] = DEFAULT_FORMAT if options[:format].nil?
    unit = ''
    if options[:format].include?('%u')
      unit = TIME_UNIT_MAPPER[unit_type][:short]
    elsif options[:format].include?('%U')
      unit = TIME_UNIT_MAPPER[unit_type][:full]
      unit += 's' if time_diff > 1
    end
    options[:format].gsub(/\%u/i, unit).gsub(/\%n/, time_diff.to_s)
  end

  # END time_elapsed helper methods --------------------------------
end