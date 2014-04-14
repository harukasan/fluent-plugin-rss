# fluent-plugin-rss

fetch RSS feed items and emit to fluentd stream.

## Usage

```
<source>
  tag rss.nytimes                                     # Required: tag to emit
  url http://example.com/input-your-rss-feed-here.rdf # Required: feed url
  interval 10m                                        # Optional: fetch interval (default: 5 min.)
  attrs date, title                                   # Optional: attributes to emit stream
</source>
```

## Todo

- more tests
- more documentation (if you needed)

* * *

## Copyright

Copyright &copy; 2014 Shunsuke Michii.
All rights reserved.

This software is released under MIT License (see LICENCE file).

## Contributing

Patches Welcome!

1. Fork it ( http://github.com/<my-github-username>/fluent-plugin-rss/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

