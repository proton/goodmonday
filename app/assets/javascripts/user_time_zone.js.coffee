$ ->
  tz_info = jstz.determine_timezone()
  timezone = tz_info.timezone
  unless timezone is "undefined"
    timezone.ambiguity_check()
    $('.datetime').each ->
      timestamp = $(this).data('timestamp')
      if timestamp
        dts = timestamp.split('/')
        dt = new Date(Date.UTC(dts[0],dts[1],dts[2],dts[3],dts[4]))
        dt_day = dt.getDate()
        dt_day = '0'+dt_day if dt_day<10
        dt_month = dt.getMonth()
        dt_month = '0'+dt_month if dt_month<10
        dt_year = dt.getFullYear()
        dt_hours = dt.getHours()
        dt_hours = '0'+dt_hours if dt_hours<10
        dt_minutes = dt.getMinutes()
        dt_minutes = '0'+dt_minutes if dt_minutes<10
        date_string = "#{dt_day}/#{dt_month}/#{dt_year} #{dt_hours}:#{dt_minutes}"
        $(this).html(date_string)