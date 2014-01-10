<h2>Description</h2>
<p>This plugin allows multiple modules under a single wheels application. </p>
<p>A module is a group of models, controllers and views stored under a single folder per module. The main benefit is each module can be made self-contained (with models, controllers, views, javascripts, etc..) and can be deployed independently from other modules.</p>

<h2>Usage/Examples</h2>
<p>In /config/app.cfm:</p>
<p>
<pre>
&lt;cfscript&gt;
	this.name = &quot;MultiModuleExample&quot;;
	this.mappings[&quot;/controllers&quot;] = getDirectoryFromPath(getBaseTemplatePath()) &amp; &quot;controllers&quot;;
	this.mappings[&quot;/models&quot;] = getDirectoryFromPath(getBaseTemplatePath()) &amp; &quot;models&quot;;
&lt;/cfscript&gt;</pre>
In your /modules/module1/controllers/Say.cfc: </p>
<p>
<pre>
&lt;cfcomponent extends=&quot;controllers.Controller&quot;&gt;
	&lt;cffunction name=&quot;hello&quot;&gt;&lt;/cffunction&gt;
&lt;/cfcomponent&gt;
</pre>
In your /modules/module1/views/say/hello.cfm:</p>
<p>
  <pre>&lt;h1&gt;Hello World!&lt;/h1&gt;</pre>
</p>
<p>
This URL will access the module (for example if you use <a href="http://www.getrailo.org/index.cfm/download/">Railo Express</a>):</p>
<pre><a href="http://localhost:8888/index.cfm/say/hello">http://localhost:8888/index.cfm/say/hello</a></pre>
<p>
