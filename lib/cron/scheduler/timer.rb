module Cron
  module Scheduler
    class Timer
      include Actor
      include Dependency
      include Log::Dependency

      SLEEP_TICK = 0.001
      THRESHOLD_NEAR_ZERO = 5000
      PRECISION = 2
      TICK_FREQUENCY = 1.0
      TICK_DELTA = 0.01

      attr_accessor :last_tick

      dependency :clock, Clock::UTC

      def self.build
        instance = new
        instance.configure
        instance
      end

      def configure
        Clock::UTC.configure(self)
      end

      handle :start do
        :tick
      end

      handle :tick do
        timestamp = clock.now

        return :next unless near_second?(timestamp)
        return :next unless elapsed?(timestamp)

        self.last_tick = timestamp

        logger.debug(tag: :tick) { "Tick!" }

        return :next unless near_zero_seconds?(timestamp)

        dispatch = Dispatch.new(timestamp)

        send.(dispatch, address)
      end

      handle :dispatch do |dispatch|
        logger.trace(tag: :heartbeat) { "Heartbeat!" }

        :next
      end

      handle :next do
        sleep(SLEEP_TICK)

        :tick
      end

      def near_second?(timestamp)
        timestamp.usec < THRESHOLD_NEAR_ZERO
      end

      def near_zero_seconds?(timestamp)
        timestamp.sec == 0
      end

      def elapsed?(timestamp)
        return true if last_tick.nil?

        time_elapsed = (timestamp.to_f - last_tick.to_f).round(PRECISION)

        (time_elapsed - TICK_FREQUENCY).abs <= TICK_DELTA
      end
    end
  end
end
