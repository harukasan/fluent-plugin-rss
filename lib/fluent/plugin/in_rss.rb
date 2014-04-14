require 'rss'

module Fluent
  class RSSInput < Fluent::Input
    Plugin.register_input 'rss', self

    config_param :tag, :string
    config_param :url, :string
    config_param :interval, :time, default: '1m'
    config_param :attrs, :string, default: 'about, date, title, description, link, content_encoded'

    def configure(conf)
      super

      @attrs = @attrs.split(',').map {|attr| attr.strip }
      @current_time = Time.now
    end

    def start
      @thread = Thread.new(&method(:run))
    end

    def shutdown
      Thread.kill(@thread)
    end

    def run
      loop do
        Thread.new(&method(:emit_rss))
        sleep @interval
      end
    end

    def emit_rss
      next_current_time = @current_time
      rss = RSS::Parser.parse(@url)
      rss.items.each do |item|
        record = {}
        @attrs.each do |attr|
          record[attr] = item.send(attr) if item.send(attr)
        end
        time = Time.parse item.date.to_s
        if time > @current_time
          Fluent::Engine.emit @tag, Time.parse(item.date.to_s), record
          next_current_time = time if time > next_current_time
        end
      end
      @current_time = next_current_time
    end
  end
end
