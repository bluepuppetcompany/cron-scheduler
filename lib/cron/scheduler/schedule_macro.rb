module Cron
  module Scheduler
    module ScheduleMacro
      def schedule_macro(cron_expression, callable=nil, &block)
        task_registry.register(cron_expression, callable, &block)
      end
      alias schedule schedule_macro

      def task_registry
        @task_registry ||= TaskRegistry.new
      end
    end
  end
end
