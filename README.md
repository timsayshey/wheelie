# Wheelie CMS
v1.0-RC-1.0.1
 
##### Built on CFWheels and Railo - Inspired by Wordpress and Xindi**

##### Watch a quick [video tour](http://youtu.be/7AAMkGP-y3E) (Old demo of initial release)

## Compatibility

Railo 4.2 with MySQL on Windows and Ubuntu

## Installation

* Extract the contents to the root of your site. Set up a mysql datasource named 'wheelie' and import the wheelie_mysql.sql file. 
* Then edit the /models/services/global/settings.cfm and set the name of your datasource and any other settings.
* If using Railo, make sure you Log into your server admin:
http://{your domain}/railo-context/admin/server.cfm?action=security.access then Change "Access Read" to "Open" and save.
* Login at http://localhost/manager - email: admin@getwheelie.com - password: wheelie

## Support

[Github Issues](https://github.com/timsayshey/wheelie/issues)
[Google Group](https://groups.google.com/forum/#!forum/wheelie-cms)
[Twitter](http://twitter.com/wheeliecms)

## Notes

* **Set Password Salt, Datasource, Error Email, Environment:**  /models/services/global/settings.cfm
* **Custom Routes:** /models/services/global/approutes.cfm
* **Everything thing else in /models/services/global/...** is pretty much global scoped functions, feel free to add more.
* **Themes:** /views/themes - look at the default light-theme
* **Other layouts and admin theme:** /views/layouts/..
* **Static pages: (Override a DB page by placing a cfm file in a site folder with the following name pattern (id_whatever.cfm, ex 4_about.cfm)** /views/static/..
* **Shortcode functions:** /views/plugins/..
* **Put custom app code in:** /modules/adminapp and /modules/publicapp - look at existing models and controllers to get an idea of what controllers and models to extend.


## Roadmap

To-do
* Expand notes and documentation
* Need to Local scope function variables to prevent possible race conditions
* Users: Filter by role
* DB Migrate (To replace vanilla sql file)

## Contribute

Feel free to make changes and issue a pull request.

## LICENSE

>**The MIT License (MIT)**
>
>Copyright (c) 2014 Tim Badolato and Contributors
>
>Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
>
>The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
>
>THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

**What does that mean?**

It means you can use this pretty much any way you like. You can fork it. You can include it in a proprietary product, sell it, and not give us a dime. Pretty much the only thing you can't do is hold us accountable if anything goes wrong.
