module Cron
  module Scheduler
    class TaskRegistry
      include Log::Dependency

      def tasks
        @tasks ||= []
      end

      def each(&block)
        tasks.each(&block)
      end

      def register(cron_expression, callable, &block)
        logger.trace(tag: :registry) { "Registering task..." }

        tasks << [cron_expression, callable, block]

        logger.debug(tag: :registry) { "Registered task." }
      end
    end
  end
end
