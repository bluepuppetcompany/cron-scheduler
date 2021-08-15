#!/usr/bin/env ruby

require_relative './interactive_init'

scheduler_address = nil

Actor::Supervisor.start do |supervisor|
  scheduler_address = Controls::Schedule.example.start

  Signal.trap "INT" do
    puts "\n\n** Received SIGINT; shutting down supervisor...\n\n"
    Actor::Messaging::Send.(:shutdown, supervisor.address)
  end

  Signal.trap 'CONT' do
    puts "\n\n** CONT trapped; resuming... \n\n"

    dispatch_message = Cron::Scheduler::Dispatch.new(Clock::UTC.now)
    Actor::Messaging::Send.(dispatch_message, scheduler_address)

    Actor::Messaging::Send.(:resume, supervisor.address)
  end
end
