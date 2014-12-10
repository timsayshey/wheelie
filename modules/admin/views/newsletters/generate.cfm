<cfoutput><!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">
<html lang="en">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="initial-scale=1.0">    <!-- So that mobile webkit will display zoomed in -->
    <meta name="format-detection" content="telephone=no"> <!-- disable auto telephone linking in iOS -->

    <title>Antwort - responsive Email Layout</title>
    <style type="text/css">

        /* Resets: see reset.css for details */
        .ReadMsgBody { width: 100%; background-color: ##eaf0f1;}
        .ExternalClass {width: 100%; background-color: ##eaf0f1;}
        .ExternalClass, .ExternalClass p, .ExternalClass span, .ExternalClass font, .ExternalClass td, .ExternalClass div {line-height:100%;}
        body {-webkit-text-size-adjust:none; -ms-text-size-adjust:none;}
        body {margin:0; padding:0;}
        table {border-spacing:0;}
        table td {border-collapse:collapse;}
        .yshortcuts a {border-bottom: none !important;}

        /* Constrain email width for small screens */
        @media screen and (max-width: 600px) {
            table[class="container"] {
                width: 95% !important;
            }
        }

        /* Give content more room on mobile */
        @media screen and (max-width: 480px) {
            td[class="container-padding"] {
                padding-left: 12px !important;
                padding-right: 12px !important;
            }
         }

    </style>
</head>
<body style="margin:0; padding:10px 0;" bgcolor="##eaf0f1" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<br>

<table border="0" width="100%" height="100%" cellpadding="0" cellspacing="0" bgcolor="##eaf0f1">
  <tr>
    <td align="center" valign="top" bgcolor="##eaf0f1" style="background-color: ##eaf0f1;">
	
      <table border="0" width="600" cellpadding="0" cellspacing="0" class="container" bgcolor="##ffffff">
        <tr>
          <td class="container-padding" bgcolor="##ffffff" style="background-color: ##ffffff; padding-left: 30px; padding-right: 30px; font-size: 14px; line-height: 20px; font-family: Helvetica, sans-serif; color: ##333; padding-bottom:20px;">
		  	
			<br><img src="http://#request.site.domain#/assets/img/newsletter/newsletter_header.jpg" width="100%">		

          </td>
        </tr>
      </table>
	  <br>
	  
	  <cfloop query="sections">
	  
	  <table border="0" width="600" cellpadding="0" cellspacing="0" class="container" bgcolor="##ffffff">
        <tr>
          <td class="container-padding" bgcolor="##ffffff" style="background-color: ##ffffff; padding-left: 30px; padding-right: 30px; font-size: 14px; line-height: 20px; font-family: Helvetica, sans-serif; color: ##333; padding-bottom:20px;">
			<br>
            <div style="font-weight: bold; font-size: 18px; line-height: 24px; color: ##dd7924">
            #sections.title#
            </div><br>
			
			#sections.content#	

          </td>
        </tr>
      </table>	  
	  <br>		
	  </cfloop>
	  
	  <table border="0" width="600" cellpadding="0" cellspacing="0" class="container" bgcolor="##ffffff">
        <tr>
          <td bgcolor="##ffffff" style="background-color: ##ffffff; padding-left: 30px; padding-right: 30px; font-size: 14px; line-height: 20px; font-family: Helvetica, sans-serif; color: ##333; padding-top:0; padding-bottom:20px;" valign="top">
			<br><div style="font-weight: bold; font-size: 18px; line-height: 24px; color: ##dd7924">
            Contact Info:
            </div><br>			
			Phone: 555-555-5555<br>
			Email: contact@#request.site.domain#
          </td>
		  <td bgcolor="##ffffff" style="background-color: ##ffffff; padding-left: 30px; padding-right: 30px; font-size: 14px; line-height: 20px; font-family: Helvetica, sans-serif; color: ##333; padding-top:0; padding-bottom:20px;" valign="top">
			<br><div style="font-weight: bold; font-size: 18px; line-height: 24px; color: ##dd7924">
            Connect with Us:
            </div><br>
			<a href="https://facebook.com/#ListFirst(request.site.domain,'.')#">Facebook</a><br>
			<a href="https://twitter.com/#ListFirst(request.site.domain,'.')#">Twitter</a></td>
        </tr>
      </table>
	  
    </td>
  </tr>
</table>
<!--/100% wrapper-->
<br>
<br>
</body>
</html>
</cfoutput>