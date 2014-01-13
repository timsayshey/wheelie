# Wheelie CMS
v0.0.1 (Pre-Alpha 0.1)
 
A CFML CMS built on CFWheels - Inspired by Wordpress and Xindi

## [Quick video tour](http://youtu.be/7AAMkGP-y3E)

## Compatibility

Tested on Railo 4, Coldfusion 10, MySQL and MSSQL.

## Installation

Extract the contents to the root of your site. Set up a mysql datasource and import the wheelie.sql file. Then edit the config/settings.cfm and set the name of your datasource and any other settings. You should be up in running. Keep in mind we are in pre-alpha so you will most likely hit a few snags. 

## Other tips

* If you want to convert videos, you will need to copy the lib folder from https://github.com/sebtools/Video-Converter and paste it to models/services/videoconverter/lib/
* I also suggest changing the user password encryption salt in settings.cfm

### v0.0.1 (Pre-Alpha 0.2) Roadmap

* Posts - Integrate into a frontend blog section
* Posts - Categories
* Bulk Publish/Draft
* Lockdown CKEditor Filemanager
* Need to Local scope function variables
* Update menu when pages urls are changed or deleted
* Users: Filter by role
* Multisite, every table has a siteid column which will be related to the sites tables
* DB Migrate (To replace vanilla sql file)

### This is opensource

I am posting this work in an effort to help improve and evolve this code and to give back to the community. *So please contribute :)*

### Documentation

I wish I had time to better comment the code, I will probably do this if demand grows or if someone else wants to take this on, feel free :)

### Contribute

I'm an expert at a few things, and a hack at most. Feel free to make changes and issue a pull request.

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