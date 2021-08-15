module Cron
  module Scheduler
    module Controls
      module Schedule
        def self.example
          Example
        end

        class Example
          include Cron::Scheduler

          schedule "* * * * *", -> { logger.info { "Hello, world!" } }
        end
      end
    end
  end
end
