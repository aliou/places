module ApplicationHelper
  # Public: Get the class(es) from basscss depending on the alert type.
  #
  # alert_type - The type of alert.
  #
  # Returns a string.
  def basscss_class_for_alert(alert_type = 'notice')
    { success: 'bg-green white',
      error:   'bg-red white',
      alert:   'bg-yellow',
      notice:  'bg-blue white'
    }.fetch(alert_type.to_sym)
  end
end
