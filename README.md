# Wheelie CMS
 
##### Built on CFWheels and Lucee - Inspired by Wordpress and Xindi**

##### Demo: [https://wheeliecms.herokuapp.com](https://wheeliecms.herokuapp.com) 
##### Note: If you get an "Application Error" message just hit refresh, that's a Heroku bug caused by sleep mode

## Heroku Installation

[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://dashboard.heroku.com/new?button-url=https%3A%2F%2Fgithub.com%2Ftimsayshey%2Fwheelie-heroku&template=https%3A%2F%2Fgithub.com%2Ftimsayshey%2Fwheelie-heroku)

## Compatibility

Lucee and MySQL/PostgreSQL

## General Notes

* Settings Location: /models/services/global/settings.cfm
* Wheelie Admin: Email: admin@getwheelie.com Password: wheelie

### Requirements

- [Maven](http://maven.apache.org/) to build the project
- [Foreman](https://github.com/ddollar/foreman) to run locally

### Heroku Instructions

To get started, run the following commands in GitBash (or your terminal of preference):

```bash
$ git clone https://github.com/timsayshey/wheelie-heroku.git
$ cd wheelie
$ mvn package
$ foreman start
```

NOTE: On Windows, start foreman with the following command:

```bash
$ foreman start -f Procfile.dev
```

You should now have Lucee up and running at <http://localhost:5000>. Start adding your code.

To deploy your site to Heroku you need to setup a free Heroku account, install the Heroku toolbelt (Suggested reading: [Getting Started with Java on Heroku](https://devcenter.heroku.com/articles/getting-started-with-java)). Then...

```bash
$ heroku apps:create [NAME]
$ git push heroku master
$ heroku open
```

You should now be looking at your app running on Heroku.

### Heroku Notes:

* If you need access to the admin, disable the first rule in urlrewrite.xml.
* Default password for web admins is `password`. This should be changed to something secure before deploying your app.
* Make any settings (datasources, mail settings, etc.) changes you want locally via the web context, commit your changes and then deploy your app and they will also exist on Heroku.
* If you get a Heroku application error try reloading the page. This is a known issue. I think the Lucee dependencies aren't quite ready when this happens, I need to look into it further.

## Heroku Credits:

- Thanks to @mikesprague for https://github.com/mikesprague/lucee5-heroku

## Support

* [Github Issues](https://github.com/timsayshey/wheelie/issues)
* [Google Group](https://groups.google.com/forum/#!forum/wheelie-cms)
* [Twitter](http://twitter.com/wheeliecms)

## Wheelie Notes

* Settings:  /models/services/global/settings.cfm
* Custom Routes: /models/services/global/approutes.cfm
* Application helpers: /models/services/global/
* Themes: /views/themes - Use light-theme as a boilerplate
* Other layouts and admin theme: /views/layouts/..
* Static pages: /views/static/.. (Override a DB page by placing a cfm file in a site folder with the following name pattern: id_whatever.cfm, ex 4_about.cfm)
* Shortcode functions: /views/plugins/..
* Add your custom app code: /modules/adminapp and /modules/publicapp - look at existing models and controllers to get an idea of what controllers and models to extend.

## Contribute

Feel free to make changes and issue a pull request.

## LICENSE

MIT -- See the LICENSE file in the root
