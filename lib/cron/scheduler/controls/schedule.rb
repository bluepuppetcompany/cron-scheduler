module Cron
  module Scheduler
    module Controls
      module Schedule
        def self.example
          Example
        end

        class Foo
          include Log::Dependency

          def self.call
            instance = new
            instance.()
          end

          def call
            logger.info { "Foo!" }
          end
        end

        class Bar
          include Log::Dependency

          def call
            logger.info { "Bar!" }
          end
        end

        class Example
          include Cron::Scheduler

          schedule "* * * * *", -> { logger.info { "Proc!" } }
          schedule "* * * * *", lambda{ logger.info { "Lambda!" } }
          schedule "* * * * *" do
            logger.info { "Block!" }
          end
          schedule "* * * * *", Foo
          schedule "* * * * *", Bar.new
          schedule "43 * * * *", -> { logger.info { "Hourly!" } }
        end
      end
    end
  end
end
