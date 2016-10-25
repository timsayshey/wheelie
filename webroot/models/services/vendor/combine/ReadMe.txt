License
-------

   Copyright 2009 Joe Roberts

   Licensed under the Apache License, Version 2.0 (the &quot;License&quot;);
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an &quot;AS IS&quot; BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.


Combine.CFC
-----------

Combine multiple javascript or CSS files into a single, compressed, HTTP request.

Allows you to change this:

	<script src='file1.js' type='text/javascript'></script>
	<script src='file2.js' type='text/javascript'></script>
	<script src='file3.js' type='text/javascript'></script>
	
To this:

	<script src='combine.cfm?files=file1.js,file2.js,file3.js' type='text/javascript'></script>

...combining and compressing multiple javascript or css files into one http request.


How do I use it?
----------------
- Place combine.cfm and Combine.cfc somewhere under your webserver
- Modify the combine.cfm with your preferred combine options, and error handling if required.
- Update your <script> and <link> urls for JS and CSS respectively, e.g:
  - <script src="combine.cfm?type=js&files=monkey.js,jungle.js" type="text/javascript"></script>
  - <link href="combine.cfm?type=css&files=monkey.css,jungle.css" type="text/css" rel="stylesheet" media="screen" />
- If you want to use the CSS or Javascript compression, you need to add the required Java to your classpath. See "How to add the Java to your classpath" below...


Caching
-------
Combine caches the generated 


How much?
---------
Nowt! If you find this project worthy of a donation, please visit my Amazon wishlist http://www.amazon.co.uk/gp/registry/3JVC6BNDZP81B


Using JavaLoader to load the Java objects
-----------------------------------------
By using Mark Mandel's JavaLoader, you can avoid having to place the .jar files in the class path, which can be fiddly, or even restricted on some shared hosting platforms.
1. Download JavaLoader http://javaloader.riaforge.org/
2. Tweak combine.cfm to pass in an instance of JavaLoader.cfc, and the path to the directory where you have placed the .jar files included with Combine.


How to add the Java to your classpath [required for css and js compression, unless you use JavaLoader]
------------------------------------------------------------------------------------------------------
1. Determine where you will place your Java, it must go in a directory in your Coldfusion class path. This could either be cf_install_dir\lib, or a custom directory path which has been added to the Coldfusion class path (through Coldfusion's admin/config)
2. Add the code to the class_path_dir as determined in step 1. Copy combine.jar and yuicompressor.x.x.x.jar to your class_path_dir.
3. Restart your CFML server


Why?
----
- Reduces the number of HTTP requests required to load your page. All your javascript files can be combined into a single <script> request in your html file.
- Compressing the CSS/JS reduces the filesize, therefore reduces the bandwidth overhead
- Keep separate CSS and JS files for easier development


How does it work?
-----------------
- [optional] Uses the dependable JSMin method to reduce redundancy from the JavaScript, without obfuscation. In my experience, it's very dependable.
- [optional] Uses the YUI CSS compressor to reduce redundancy from the CSS, not just white-space removal, see http://developer.yahoo.com/yui/compressor/
- [optional] Caches merged files to avoid having to rebuild on each request
- [optional] Uses Etags (file hash/fingerprints) to allow browsers to make conditional requests. E.g. browser says to server, only give me the javascript to download if your etag is different to mine (i.e. only if it has changed since my last visit). Otherwise, browser uses it's locally cached version (304 NOT MODIFIED).
- [optional] Specify HTTP caching headers (such as Cache-Control) to instruct browsers and proxies how they should (or maybe shouldn't!) cache the files. A couple of articles I highly recommend reading: http://symkat.com/45/understanding-http-caching/ & http://palisade.plynt.com/issues/2008Jul/cache-control-attributes/


Real Stats - an example of the benefits of ETags
------------------------------------------------
Real statistics from one of our sites (obtained via Fusion Reactor). Note how many 304 status codes are returned. These mean that the request instantly ends, and the browser uses its local version. This happens when the browser's version is the same as the server version, and results in less load on your server!

200 OK: 10346 (normal response, returns content)
304 Not Modified: 3038 (server load reduced!)
500 Internal Server Error: 11 (my bugs?!) 
301 Moved Permanently: 187 
302 Found: 48 
404 Not Found: 58 


More
----
- You are likely to also see benefits from enabling gzip compression on your webserver. Compressing something twice is generally pointless (ever tried zipping a JPEG?). However, combine.cfc strips out white space, comments, etc, Gzip is lossless; therefore the combination of the 2 can be quite effective.
- YSlow is a great Firefox extension which can help you determine what optimisations you can make to improve your site's performance (requires Firebug)
- Yahoo's best practices document (linked to from YSlow) is worth a read if you are serious about optimisation: http://developer.yahoo.com/performance/rules.html
- Firebug - It's pains me to think of the days I spent as a web developer without this Firefox extension!
- The following post contains useful information about the Java class path: http://weblogs.macromedia.com/cantrell/archives/2004/07/the_definitive.html
- Understanding HTTP caching can really help you optimise delivery, and reduce server load. Checkout http://symkat.com/45/understanding-http-caching/ & http://palisade.plynt.com/issues/2008Jul/cache-control-attributes/ & experiment with something like Charles Proxy or HTTPFox to debug the effects of different caching configurations. 


Contact
-------
Please feel free to contact me with any issues, ideas and experiences you have with Combine.cfc. jroberts1{at}gmail{dot}com


Credits
-------
All I have done here is pulled together some other peoples' clever work, into a workable solution for Coldfusion apps. So loads of credit to the following:

- Combine.php
  - A lot of ideas came from this project. Ed Eliot (www.ejeliot.com), Thanks!
- JSMin:
  - Originally written by Douglas Crockford www.crockford.com
  - Ported to Java by John Reilly http://www.inconspicuous.org/projects/jsmin/JSMin.java
- YUI CSS Compressor:
  - Part of the impressive YUI Compressor library http://developer.yahoo.com/yui/compressor/
  