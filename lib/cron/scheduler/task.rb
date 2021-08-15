module Cron
  module Scheduler
    class Task
      include Actor
      include Log::Dependency
      include Dependency

      attr_reader :cron_expression
      attr_reader :callable

      dependency :scheduler, Scheduler

      def initialize(cron_expression, callable, &block)
        @cron_expression = cron_expression
        @callable = callable
        @callable = block if block_given?
      end

      def self.build(scheduler, cron_expression, callable, &block)
        instance = new(cron_expression, callable, &block)
        instance.scheduler = scheduler
        instance
      end

      handle :start do
        logger.trace { "Starting task..." }
      end

      handle :dispatch do |dispatch|
        if callable.is_a?(Proc)
          scheduler.instance_exec(&callable)
        else
          callable.()
        end
      end
    end
  end
end
