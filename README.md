# RspecOverview

[![Build Status](https://travis-ci.org/odlp/rspec_overview.svg?branch=master)](https://travis-ci.org/odlp/rspec_overview)

Take `RspecOverview::Formatter` for a spin when you're new to a project and need
an overview:

- How are the tests structured?
- How many tests are there by type (feature, model, controller)?
- Which tests are taking the most time?

## Usage

Add the gem to your `Gemfile` and run `bundle`:

```ruby
group :test do
  gem "rspec_overview"
end
```

You can use the overview formatter standalone, or mix & match with other
formatters:

```sh
# With the progress formatter:
bundle exec rspec --format progress --format RspecOverview::Formatter

# With the documentation formatter:
bundle exec rspec --format documentation --format RspecOverview::Formatter
```

### CSV format

You can also produce a CSV for further analysis:

```sh
bundle exec rspec --format RspecOverview::FormatterCsv --out overview.csv
```

## Example output

Run against [thoughtbot/administrate][administrate]:

[administrate]: https://github.com/thoughtbot/administrate

```
Randomized with seed 16132
................................................................................
................................................................................
................................................................................
......................................................................

Finished in 15.03 seconds (files took 6.02 seconds to load)
310 examples, 0 failures

# Summary by Type or Subfolder

| Type or Subfolder   | Example count | Duration (s) | Average per example (s) |
|---------------------|---------------|--------------|-------------------------|
| feature             | 72            | 9.28         | 0.12889                 |
| generator           | 65            | 1.83         | 0.0282                  |
| controller          | 32            | 1.69         | 0.05293                 |
| view                | 14            | 0.68246      | 0.04875                 |
| ./spec/i18n_spec.rb | 2             | 0.58921      | 0.2946                  |
| ./spec/lib          | 79            | 0.33908      | 0.00429                 |
| model               | 28            | 0.29078      | 0.01038                 |
| ./spec/administrate | 5             | 0.03813      | 0.00763                 |
| ./spec/dashboards   | 9             | 0.024        | 0.00267                 |
| helper              | 4             | 0.01062      | 0.00265                 |


# Summary by File

| File                                                        | Example count | Duration (s) | Average per example (s) |
|-------------------------------------------------------------|---------------|--------------|-------------------------|
| ./spec/features/index_page_spec.rb                          | 11            | 2.76         | 0.25125                 |
| ./spec/controllers/admin/customers_controller_spec.rb       | 15            | 1.11         | 0.07432                 |
| ./spec/features/form_errors_spec.rb                         | 2             | 1.1          | 0.54813                 |
| ./spec/generators/dashboard_generator_spec.rb               | 20            | 1.06         | 0.05293                 |
| ./spec/features/orders_form_spec.rb                         | 7             | 1.01         | 0.14472                 |
| ./spec/features/show_page_spec.rb                           | 10            | 0.67528      | 0.06753                 |
| ./spec/i18n_spec.rb                                         | 2             | 0.58921      | 0.2946                  |
| ./spec/features/search_spec.rb                              | 3             | 0.57751      | 0.1925                  |
| ./spec/features/orders_index_spec.rb                        | 6             | 0.57129      | 0.09521                 |
| ./spec/features/products_index_spec.rb                      | 4             | 0.54049      | 0.13512                 |
| <abridged>                                                  |               |              |                         |

Randomized with seed 40301
```
