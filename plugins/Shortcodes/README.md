cfwheels-shortcodes
===================

A Shortcodes plugin for cfwheels

## Shortcodes v0.1
This is a port of Barney's [shortcodes](http://www.barneyb.com/barneyblog/projects/shortcodes) implementation for CFML (itself a port of the wordpress shortcodes concept). He wrote all the tricky stuff, I've just refactored into cfscript, stripped out all the CFC aspects and made into a cfWheels plugin. Note, I haven't bothered with the full cfc implementation with execute, as we're doing this within a cfwheels app.

Please note nested shortcodes aren't currently supported.

###Usage

	// Add a shortcode
	addShortcode("code", callback);

	// Process content with shortcodes in
	processShortcodes(content);

	// Quick dump to view existing shortcodes
	returnShortcodes();



###Example, adding a shortcode for [test]

To add a shortcode, such as ```[test]```, first, you should register the code in ```/events/onapplicationstart.cfm```

    addShortcode("test", test_shortcode_callback);

This basically registers ```[test]``` as a trigger for ```test_shortcode_callback()```. So next, we need to create that function.
In ```/events/functions.cfm```, add your callback:

    // Test Shortcode
    function test_shortcode_callback(attr) {
       return "foo";
    }

Lastly, wrap any content which you want to parse for shortcodes to with ```sc_process()```

    <cfsavecontent variable="mycontent">
      <p>I am [test], fear me.</p>
    </cfsavecontent>
    <cfoutput>
      #processShortcodes(mycontent)#
    </cfoutput>

###Using passed tag attributes

You can use any data passed by tag attributes via the ```attr``` struct.

    [test foo="bar"]

Will allow you to reference ```#attr.foo#``` in your shortcode function.


###Wrapping content with tags

To enable a tag to 'wrap' about content, you need to make sure the callback function has the content argument

    // Example shortcode to wrap content in a div
    function test_shortcode_callback(attr, content) {
      var result="";
      result="<div class='test'>" & content & "</div>";
      return result;
    }

    // Usage:
    [test]My Stuff[/test]

###More advanced example:
This example renders the markup needed for a bootstrap 3.x panel via including a partial


    // addShortcode("panel", panel_callback);

    /**
    * @hint Renders a bootstrap panel: usage [panel title="My Title"]Content[/panel]
     **/
    function panel_callback(attr, content) {
       param name="attr.title" default="";
       var result="";
       savecontent variable="result" {
         includePartial(partial="/common/widgets/panel", title=attr.title, content=content);
       }
       return result;
    }

Panel partial: ```/common/widgets/_panel.cfm```

    <cfoutput>
      <div class='panel panel-default clearfix'>
        <div class='panel-heading'>
          <h3 class='panel-title'>#arguments.title#</h3>
        </div>
      <div class='panel-body'>#arguments.content#</div>
    </div>
    </cfoutput>

The nice part about having this within wheels itself is that you can access any of the wheels functions and helpers, including the params struct (i.e, useful for paging numbers etc), whereas using Barney's cfc in the /miscellaneous/ folder (and then extending controller.cfc) caused various issues.

NB, shortcode references are stored in the application.shortcodes struct, so your application will need reloading after adding a new code.


###View Available Shortcodes
Check your shortcodes exist and are registered with ```returnShortcodes()```