# CarStalker

Scraper for popular Lithuanian car ad websites.

Currently supported sites:

  * autoplius.lt
  * autogidas.lt

Future plans are to support all popular Lithuanian (and some European) car ad sites. The idea is to make a neat gem, which would allow to see wanted car ads from multiple sites in one place.

## Installation

This gem is currently available only on github and it is intendet to be my programming learning / afterwork hobby product.

To install it go to your console, navigate to your preferred location and do:

```bash
  $ git clone git@github.com:maikis/car_scraper.git
```

Then swithch to the folder:

```bash
  $ cd car_scraper
```

And bundle install:

```bash
  $ bundle install
```

In case you are not familiar with Ruby ecosystem, you can read more about [rvm/gemsets](https://rvm.io) and [bundler](http://bundler.io).

## Usage

Currently you can try it out by adding a local gem repository with bundler and adding it to your Gemfile. Or you can write specific test with preferred car specs and play with it using rspec.

Gem currently fetches links from autoplius.lt and autogidas.lt websites. You can use it like this:

```ruby
car_specs = { make: 'Volkswagen',
              model: 'Golf',
              kilometrage_to: '70000',
              year_from: 2012,
              price_to: '10000',
              damaged: 'No damages' }

results = CarStalker.get_links(car_specs)

# [
#   "http://autoplius.lt/skelbimai/volkswagen-golf-1-6-l-universalas-2012-dyzelinas-5217831.html",
#   "http://www.autogidas.lt/volkswagen-golf-vii-tdi-bmt-highline-universalas-2014-0129134959.html"
# ]
```

## Available search options

```
  make:
    You can find available makes in car_stalker/data/*_models.rb,
    where * is website's name (currently `autogidas` or `autoplius`)
  model:
    You can find available makes in car_stalker/data/*_models.rb,
    where * is website's name (currently `autogidas` or `autoplius`)
  engine_capacity_from:
    (800..5600)
  engine_capacity_to:
    (800..5600)
  power_from:
    '44 kW (60 AG)'
    '55 kW (75 AG)'
    '66 kW (90 AG)'
    '74 kW (100 AG)'
    '85 kW (116 AG)'
    '96 kW (130 AG)'
    '110 kW (150 AG)'
    '147 kW (200 AG)'
    '184 kW (250 AG)'
    '223 kW (303 AG)'
    '263 kW (358 AG)'
    '296 kW (402 AG)'
    '334 kW (454 AG)'
  power_to:
    '44 kW (60 AG)'
    '55 kW (75 AG)'
    '66 kW (90 AG)'
    '74 kW (100 AG)'
    '85 kW (116 AG)'
    '96 kW (130 AG)'
    '110 kW (150 AG)'
    '147 kW (200 AG)'
    '184 kW (250 AG)'
    '223 kW (303 AG)'
    '263 kW (358 AG)'
    '296 kW (402 AG)'
    '334 kW (454 AG)'
  kilometrage_from:
    (0..250_000)
  kilometrage_to:
    (0..250_000)
  damaged:
    :no
    :yes
  year_from:
    (1985..Date.today.year)
  year_to:
    (1985..Date.today.year)
  price_from:
    (150..60_00)
  price_to:
    (150..60_00)
  fuel_type:
    :diesel
    :petrol
    :petrol_lpg
    :petrol_ev
    :ev
    :diesel_ev
    :other
  gearbox:
    :automatic
    :manual
  body_type:
    :sedan
    :hatchback
    :coupe
    :minivan
    :suv
    :wagon
    :convertible
    :limousine
    :other
  driven_wheels:
    :fwd
    :rwd
    :awd
  steering_wheel_side:
    :lhd
    :rhd
```

## TODO

  * Add support for another web sites (brc.lt?)
  * Possibility to receive more information as a result than just a link (Picture link, model years, engine, etc.)
  * Add possibility to scrape more than one car model at the time
  * Add possibility to use other fields in autoplius than selectors only
  * Add value matching method for price, kilometrage and other number select fields (e.g. possibility to enter any price, like 1500 and if site select field has 1000, 2000, 3000 values, it should match the closest one, like 1000)

## DONE

#### v0.1.1
  * Written proper translation layer from human language to html selector id's
  * Added support for autogidas.lt
  * Added spec validation for translator

Enjoy :)
