class Pagerduty
  class Schedules
    class Schedule
      include Virtus.model

      attribute :id
      attribute :name
      attribute :time_zone
      attribute :today
      attribute :escalation_policies, Array[EscalationPolicy]
    end
  end
end

class Pagerduty
  class Schedules
    class ScheduleLayer
      class User
        include Virtus.model

        attribute :member_order
        attribute :user, Pagerduty::User
      end
    end
  end
end

class Pagerduty
  class Schedules
    class Restriction
      include Virtus.model

      attribute :start_time_of_day
      attribute :duration_seconds
    end
  end
end

class Pagerduty
  class Schedules
    class ScheduleLayer
      include Virtus.model

      attribute :name
      attribute :rendered_schedule_entries, Array
      attribute :id
      attribute :priority
      attribute :start
      attribute :end
      attribute :restriction_type
      attribute :rotation_virtual_start
      attribute :rotation_turn_length_seconds
      attribute :users, Array[Pagerduty::Schedules::ScheduleLayer::User]
      attribute :restrictions, Array[Pagerduty::Schedules::Restriction]
      attribute :rendered_coverage_percentage

    end
  end
end

class Pagerduty
  class Schedules
    include Virtus.model

    attribute :schedules, Array[Pagerduty::Schedules::Schedule]
    attribute :limit
    attribute :offset
    attribute :total
  end
end

class Pagerduty
  class Schedules
    class Override
      include Virtus.model

      attribute :name
      attribute :rendered_schedule_entries, Array[Pagerduty::Schedules::ScheduleLayer]
    end
  end
end

class Pagerduty
  class Schedules
    class FinalSchedule
      include Virtus.model

      attribute :name
      attribute :rendered_schedule_entries, Array[Pagerduty::Schedules::ScheduleLayer]
      attribute :rendered_coverage_percentage
    end
  end
end

class Pagerduty
  class ScheduleInfo
    include Virtus.model

    attribute :id
    attribute :name
    attribute :time_zone
    attribute :today
    attribute :escalation_policies, Array[EscalationPolicy]
    attribute :schedule_layers, Array[Pagerduty::Schedules::ScheduleLayer]
    attribute :overrides_subschedule, Pagerduty::Schedules::Override
    attribute :final_schedule, Pagerduty::Schedules::FinalSchedule

  end
end
