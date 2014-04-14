require 'helper'

class RSSInputTest < Test::Unit::TestCase
  def setup
    Fluent::Test.setup
  end

  def create_driver(conf)
    Fluent::Test::InputTestDriver.new(Fluent::RSSInput).configure(conf)
  end

  def test_configure_full
    d = create_driver %q{
      tag test
      url http://example.com/example.rss
      interval 10m
      attrs date, title
    }

    assert_equal 'test', d.instance.tag
    assert_equal 'http://example.com/example.rss', d.instance.url
    assert_equal 10 * 60, d.instance.interval
    assert_equal ['date', 'title'], d.instance.attrs
  end

  def test_configure_error_when_config_is_empty
    assert_raise(Fluent::ConfigError) do
      create_driver ''
    end
  end
end

