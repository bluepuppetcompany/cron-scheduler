module Cron
  module Scheduler
    class Task
      include Actor
      include Log::Dependency

      attr_reader :cron_expression
      attr_reader :callable

      def initialize(cron_expression, callable)
        @cron_expression = cron_expression
        @callable = callable
      end

      def self.build(cron_expression, callable)
        instance = new(cron_expression, callable)
        instance
      end

      handle :start do
        logger.trace { "Starting task..." }
      end
    end
  end
end
