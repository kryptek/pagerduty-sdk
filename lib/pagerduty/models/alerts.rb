class Alerts
  include Virtus.model

  attribute :alerts, Array[Alert]

end
