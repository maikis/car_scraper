# CarStalker

Scraper for popular Lithuanian car ad websites.

Currently supported sites:

  * autoplius.lt

Future plans are to support all popular Lithuanian (and maybe some European) car ad sites. The idea is to make a neat gem, which would allow to see wanted car ads from multiple sites in one place.

## Installation

This gem is currently available only on github and it is more of my programming learning / afterwork hobby product.

To install it go to your console and do:

```bash
  $ git clone git@github.com:Maikis/car_scraper.git
```

Then swithch to the folder:

```bash
  $ cd car_scraper
```

And bundle install:

```bash
  $ bundle install
```

You can read more about [rvm/gemsets](https://rvm.io) and [bundler](http://bundler.io).

## Usage

Currently you can try it out by adding a local gem repository with bundler and adding it to your Gemfile. Or you can write specific test with preferred car specs and play with it using rspec.

Gem currently fetches links only from autoplius.lt website. You can use it like this:

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
#   "http://autoplius.lt/skelbimai/volkswagen-golf-2-0-l-hecbekas-2012-dyzelinas-5027870.html"
# ]
```

*You can find available search options in further section.*

Currently it is only possible to provide car specs by autoplius search form's selector id's, but my first task in TODO list is to write proper translator from human language to html id's.

## Available search options

```
  make,
  model,
  engine_capacity_from,
  engine_capacity_to,
  power_from,
  power_to,
  kilometrage_from,
  kilometrage_to,
  damaged: [
    :no,
    :yes
  ],
  year_from,
  year_to,
  price_from,
  price_to,
  fuel_type: [
    diesel: 'Diesel',
    petrol: 'Petrol',
    petrol_lpg: 'Petrol / LPG',
    petrol_ev:  'Petrol / electricity',
    ev: 'Electricity',
    diesel_ev: 'Diesel / electricity',
    other: 'Other'
  ],
  gearbox: [
    :automatic,
    :manual
  ],
  body_type: [
    sedan: 'Saloon / sedan',
    hatchback: 'Hatchback',
    coupe: 'Coupe',
    minivan: 'MPV / minivan',
    suv: 'SUV / off-road',
    wagon: 'Wagon',
    convertible: 'Convertible / Roadster',
    limousine: 'Limousine',
    other: 'Other'
  ],
  driven_wheels: [
    fwd: 'Front wheel drive (FWD)',
    rwd: 'Rear wheel drive (RWD)',
    awd: 'All wheel (4x4)'
  ],
  steering_wheel_side [
    lhd: 'Left hand drive (LHD)',
    rhd: 'Right hand drive (RHD)'
  ]
```

## TODO

  * Write proper translation layer from human language to html selector id's
  * Add support for another web sites (brc.lt?)
  * Possibility to receive more information as a result than just a link (Picture link, model years, engine, etc.)
  * Add possibility to scrape more than one car model at the time
  * Add possibility to use other fields in autoplius than selectors only
  * Add value checking method for price, kilometrage and other number select fields (e.g. possibility to enter any price, like 1500 and if site select field has 1000, 2000, 3000 values, it should match the closest one, like 1000)

Enjoy :)
