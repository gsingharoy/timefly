# Timefly


A simple library which makes it easier to get time related data, eg, age from Date of birth, elapsed time in beautiful format, etc.

## Installation
```shell
gem install timefly
```

## Usage
To initialize you can pass an instance of Time, Date or a String
```shell
require 'timefly'

Timefly.new(Time.new(1987, 8, 2))
#str_origin_time can be String or formats YYYY.MM.DD, YYYY-MM-DD, YYYY/MM/DD
Timefly.new(str_origin_time)
```
To get the age from origin time
```shell
# dob is the date of birth
Timefly.new(dob).age
# => 27
```
If you want to retrieve age in years and months then
```shell
Timefly.new(dob).age({ format: '%y years, %m months' })
# => 27 years, 10 months
```



## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-awesome-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-awesome-feature`)
5. Create new Pull Request
6. Relax and enjoy a beer

