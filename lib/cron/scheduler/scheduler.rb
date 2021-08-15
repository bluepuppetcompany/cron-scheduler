module Cron
  module Scheduler
    def self.included(cls)
      cls.class_exec do
        include Actor
        include Log::Dependency

        extend ScheduleMacro

        def tasks
          @tasks ||= []
        end

        handle :start do
          logger.trace(tag: :scheduler) { "Starting scheduler... (#{Process.pid})" }

          logger.trace(tag: :scheduler) { "Starting tasks..." }

          self.class.task_registry.each do |cron_expression, callable|
            task_address = Task.start(cron_expression, callable)

            self.tasks << task_address
          end

          logger.debug(tag: :scheduler) { "Started tasks." }

          logger.debug(tag: :scheduler) { "Started scheduler. (#{Process.pid})" }
        end

        handle :dispatch do |dispatch|
          logger.trace(tag: :scheduler) { "Dispatching tasks... (Timestamp: #{dispatch.timestamp})"}

          logger.debug(tag: :scheduler) { "Dispatch tasks. (Timestamp: #{dispatch.timestamp})"}
        end
      end
    end

    Dispatch = Struct.new(:timestamp) do
      include Actor::Messaging::Message
    end
  end
end
