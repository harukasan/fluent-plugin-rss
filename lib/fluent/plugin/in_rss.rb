require 'rss'
require 'fluent/input'

module Fluent
  class RSSInput < Fluent::Input
    Plugin.register_input 'rss', self

    # Define `router` method of v0.12 to support v0.10 or earlier
    unless method_defined?(:router)
      define_method("router") { Fluent::Engine }
    end

    config_param :tag, :string
    config_param :url, :string
    config_param :interval, :time, default: '5m'
    config_param :attrs, :string, default: 'date, title, description'

    def configure(conf)
      super

      @attrs = @attrs.split(',').map {|attr| attr.strip }
      @current_time = Time.now
    end

    def start
      super
      @thread = Thread.new(&method(:run))
    end

    def shutdown
      Thread.kill(@thread)
      super
    end

    def run
      loop do
        Thread.new(&method(:emit_rss))
        sleep @interval
      end
    end

    def emit_rss
      begin
        next_current_time = @current_time
        rss = RSS::Parser.parse(@url)
        rss.items.each do |item|
          record = {}
          @attrs.each do |attr|
            record[attr] = item.send(attr) if item.send(attr)
          end
          time = Time.parse item.date.to_s
          if time > @current_time
            router.emit @tag, Time.parse(item.date.to_s), record
            next_current_time = time if time > next_current_time
          end
        end
        @current_time = next_current_time
      rescue => e
        log.error e
      end
    end
  end
end
