## [0.1.1] - 2017-03-20

Added support for handling JSON keys that start with integers. Previously this was attempting to use an invalid instance variable ("@1234"). New behavior prepends instance variables and method access calls with an underscore: `obj._1234` or `obj.instance_variable_get("_@1234")`.

## [0.1.0] - 2017-03-06

Initial version released.
