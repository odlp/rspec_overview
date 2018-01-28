# RspecOverview

[![Build Status](https://travis-ci.org/odlp/rspec_overview.svg?branch=master)](https://travis-ci.org/odlp/rspec_overview)

Take `RspecOverview::Formatter` a spin when you're new to a project & need an
overview:

- How are the tests structured?
- How many tests are there by meta-type (feature, model, controller)?
- Which tests are taking the most time?

## Usage

In your `Gemfile`:

```ruby
group :test do
  gem "rspec_overview"
end
```

Then `bundle`. The overview formatter can be used standalone, or mix & match
with other formatters:

```sh
# With the progress formatter:
bundle exec rspec --format progress --format RspecOverview::Formatter

# With the documentation formatter:
bundle exec rspec --format documentation --format RspecOverview::Formatter
```

## Example output

Run against [thoughtbot/administrate][administrate]:

[administrate]: https://github.com/thoughtbot/administrate

```
Randomized with seed 40301
................................................................................
................................................................................
................................................................................
................................................................................
...........................................

Finished in 19.36 seconds (files took 3.99 seconds to load)
363 examples, 0 failures

Summary by Type or Subfolder
+---------------------+---------------+--------------+-------------------------+
| Type or Subfolder   | Example count | Duration (s) | Average per example (s) |
+---------------------+---------------+--------------+-------------------------+
| feature             | 83            | 9.88         | 0.11905                 |
| controller          | 46            | 3.56         | 0.07738                 |
| generator           | 73            | 2.49         | 0.03408                 |
| ./spec/lib          | 95            | 1.02         | 0.0107                  |
| ./spec/i18n_spec.rb | 2             | 0.93344      | 0.46672                 |
| view                | 15            | 0.75198      | 0.05013                 |
| model               | 28            | 0.33824      | 0.01208                 |
| ./spec/administrate | 5             | 0.06623      | 0.01325                 |
| helper              | 7             | 0.02385      | 0.00341                 |
| ./spec/dashboards   | 9             | 0.01684      | 0.00187                 |
+---------------------+---------------+--------------+-------------------------+

Summary by File
+-------------------------------------------------------------+---------------+--------------+-------------------------+
| File                                                        | Example count | Duration (s) | Average per example (s) |
+-------------------------------------------------------------+---------------+--------------+-------------------------+
| ./spec/features/index_page_spec.rb                          | 11            | 2.09         | 0.1899                  |
| ./spec/controllers/admin/blog/posts_controller_spec.rb      | 16            | 1.64         | 0.1025                  |
| ./spec/features/orders_form_spec.rb                         | 7             | 1.28         | 0.1825                  |
| ./spec/i18n_spec.rb                                         | 2             | 0.93344      | 0.46672                 |
| ./spec/generators/routes_generator_spec.rb                  | 8             | 0.87447      | 0.10931                 |
| ./spec/controllers/admin/log_entries_controller_spec.rb     | 6             | 0.84819      | 0.14137                 |
| ./spec/generators/dashboard_generator_spec.rb               | 21            | 0.8094       | 0.03854                 |
| ./spec/features/show_page_spec.rb                           | 9             | 0.79038      | 0.08782                 |
| ./spec/lib/fields/date_time_spec.rb                         | 8             | 0.703        | 0.08787                 |
| ./spec/features/orders_index_spec.rb                        | 6             | 0.67226      | 0.11204                 |
| ./spec/features/log_entries_index_spec.rb                   | 6             | 0.66303      | 0.11051                 |
| ./spec/features/search_spec.rb                              | 3             | 0.6555       | 0.2185                  |
| <abridged>                                                  | <abridged>    | <abridged>   | <abridged>              |
+-------------------------------------------------------------+---------------+--------------+-------------------------+

Randomized with seed 40301
```
