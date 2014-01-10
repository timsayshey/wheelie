= DefaultScope

* http://cfwheels.org/plugins/listing/23
* http://github.com/illuminerdi/DefaultScope
* http://cfwheels.org
* http://illuminerdi.com

== DESCRIPTION:

The DefaultScope plugin seeks to add the functionality of Rails' ActiveRecord::Base&#35;default_scope to Wheels. While you can use set() right now in Wheels to alter the global defaults of the findAll() method, you can't set a scope for individual models. With this plugin, you can specify default values for the findAll() method on a specific model.

== FEATURES/PROBLEMS:

Features:
* Adds the functionality of ActiveRecord::Base#default_scope to Wheels
* defaultScope() takes all of the same options as findAll() and stores them for a specific model
* findAll() now pulls in defaultScope values and uses them if not manually overridden

Problems:
* If for some reason you decide to use ordered arguments rather than named arguments, then it won't work. The new findAll() expects named arguments only.
* The plugin could do with some testing and better documentation. Also, it would probably be good to steer away from my ... unorthodox method of defining arguments for methods.
* There's no consideration for environment at this time. It might be a good idea to cache the values from defaultScope() if you're in production mode. I need to learn how to do that.
* findAll() is used by the calculations methods (count, sum, average, etc.), which due to the SQL methods they use can't take an 'order' parameter. These methods are not making sure this parameter isn't being passed to findAll(), so this plugin now strips out the 'order' parameter before the calculations methods run. (Thanks, andybellenie, and you can see his path request for CFWheels to fix this at http://code.google.com/p/cfwheels/issues/detail?id=366)

== SYNOPSIS:

<!--- in any model --->
<cffunction name="init">
  <!--- assume we have a model containing user information, and
    you want to sort by the last name then first for most of your
    findAll() requests.  --->
  <cfset defaultScope(order="last_name, first_name") />
</cffunction>

== REQUIREMENTS:

* ColdFusion 8+
* CFWheels 1.0+

== INSTALL:

* download DefaultScope-0.6.3.zip from the plugin listing above and place it in /plugins and then Reload the framework

== LICENSE:

(The MIT License)

Copyright (c) 2010 Joshua Clingenpeel

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
