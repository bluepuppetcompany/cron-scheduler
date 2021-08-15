module Cron
  module Scheduler
    class Task
      include Actor
      include Log::Dependency
      include Dependency

      attr_reader :cron_expression
      attr_reader :callable
      attr_accessor :next_timestamp

      dependency :scheduler, Scheduler
      dependency :clock, Clock::UTC

      def initialize(cron_expression, callable, &block)
        @cron_expression = cron_expression
        @callable = callable
        @callable = block if block_given?
      end

      def self.build(scheduler, cron_expression, callable, &block)
        instance = new(cron_expression, callable, &block)
        instance.scheduler = scheduler
        instance.configure
        instance
      end

      def configure
        Clock::UTC.configure(self)
      end

      handle :start do
        logger.trace { "Starting task..." }

        set_next_timestamp(clock.now)
      end

      handle :dispatch do |dispatch|
        return unless matches?(dispatch.timestamp)

        if callable.is_a?(Proc)
          scheduler.instance_exec(&callable)
        else
          callable.()
        end

        set_next_timestamp(clock.now)
      end

      def set_next_timestamp(timestamp)
        cron_parser = CronParser.new(cron_expression)

        self.next_timestamp = cron_parser.next(timestamp)

        logger.debug(tag: :task) { "Next timestamp (#{next_timestamp})" }
      end

      def matches?(timestamp)
        logger.debug(tag: :task) { "Comparing... (Timestamp: #{timestamp}, Next: #{next_timestamp})" }

        timestamp.year == next_timestamp.year &&
          timestamp.month == next_timestamp.month &&
          timestamp.day == next_timestamp.day &&
          timestamp.hour == next_timestamp.hour &&
          timestamp.min == next_timestamp.min
      end
    end
  end
end
