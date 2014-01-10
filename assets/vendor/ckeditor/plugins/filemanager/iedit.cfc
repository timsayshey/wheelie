<cfcomponent displayname="iedit" hint="image resize and edie using (javax.imageio)" output="no">


<!--- ************************************************************************** ---->
<!--- Read The Image First                                                       ---->
<!--- ************************************************************************** ---->

	<cffunction name="SelectImage" 
		access="public" 
		output="false" 
		returntype="any" 
		hint="Get the image in">
	
	<cfargument name="file" hint="Image File file to read" required="yes" type="string">

	<!--- first check if the file excist in the server                            --->
	<cfif NOT fileExists(arguments.file)>
		<cfthrow 
			errorcode="1" 
			detail="Could not find the file (#arguments.file#). Make sure the file to the file is correct and file exists"
			type="iedit.FileNotFount"
			message="Image Not Found in iEdit. (#arguments.file#)">
	</cfif>
	
	<!--- first check the extention of the image and the image type.              --->
	<!--- process only if this is a image                                         --->
	
	<!--- get the last Characters set after the final period                      --->
	<cfset fileExt = Reverse(Listgetat(Reverse(arguments.file),1,'.'))>
	<!--- <cfset fileExt = fileExt>
	<cfset fileExt = fileExt> --->
	
	<cfif NOT len(fileExt)>
		<cfthrow 
			errorcode="2" 
			detail="The selected file does not have an extension to be found."
			type="iedit.NoExtension"
			message="No File Extension. (#arguments.file#) [iEdit]">
	</cfif>
	
	<!--- get the image reader for this file Extension                           --->
	<cfset ImageIO = CreateObject("Java", "javax.imageio.ImageIO")>
	<cfset Iter = ImageIO.getImageReadersByFormatName("#fileExt#")>
	
	<cfif Iter.hasNext()>
		<!--- ImageReader --->
		<cfset reader = Iter.next()>
	<cfelse>
		<!--- we couldn't find a valid image reader, throw an error             --->
		<cfthrow 
			errorcode="3" 
			detail="No Java image reader found for the file type (#Ucase(fileExt)#). Select JPG, PNG, GIF file format only for the input file."
			type="iedit.NoReader"
			message="Unable to Process the File type (#fileExt#).  [iEdit]">
	</cfif>
	
		<cftry>
			<cfset InputStream = CreateObject("Java", "java.io.FileInputStream")>
			<!--- grab an input stream for the image we're reading              --->
			<cfset InputStream.init(arguments.file)>
			
			<cfcatch>
				<cfthrow
					type="iEdit.Image.ErrorOpeningFile"
					message="There was an error opening the file #arguments.file#.  [iEdit]">
			</cfcatch>
		</cftry>

		<!---<cftry>--->
			<cfset ImageStream = ImageIO.createImageInputStream(InputStream)>
			<cfset Reader.setInput(ImageStream)>
			<cfset this.Image = Reader.read(JavaCast("int", 0))>
			<cfset ImageStream.close()>
			<cfset Reader.dispose()>
<!---			<cfcatch>

				<cfset ImageInputStream.close()>
				
				<cfif IsDefined("arguments.ImageReader")>
					<cfset arguments.ImageReader.dispose()>
				</cfif>
			
				<cfthrow
				type="iedit.NotImageData" 
				detail="File may be not a correct image file or file is corrupted.<br>Supported File types: JPG, GIF, PNG"
				message="File not seems to be a valid image type support by iEdit">
			</cfcatch>
		</cftry>--->

		<cfset InputStream.close()>
		
	</cffunction>


<!--- ************************************************************************** ---->
<!--- Image Output                                                               ---->
<!--- ************************************************************************** ---->


	<cffunction 
		name="output" 
		access="public" 
		output="false" 
		returntype="void" 
		hint="Output image">
		
		<cfargument name="file" hint="output file name" required="yes" type="string"/>
		<cfargument name="type" hint="output format (JPG,PNG)" required="yes" type="string">
		<cfargument name="quality" hint="Qualit of the JPG gile" required="no" type="numeric" default="90">
		
		<cfset var OutputStream = CreateObject("Java", "java.io.FileOutputStream")> 
		
		<!--- Check do the user have provided a file path                         --->
		<cfif not len(arguments.file)>
			<cfthrow
				type="iedit.OutPutPathError"
				message="Output file name not provided.  [iEdit]">	
		</cfif>

		<!--- Check If the format is correct                                       --->
		<cfif not ListFindNoCase(ArrayToList(ImageIO.getWriterFormatNames()),arguments.type)>
			<cfthrow
				type="iedit.WrongType" 
				detail="Supported image types are #ArrayToList(ImageIO.getWriterFormatNames())#."
				message="The image type (#arguments.type#) not supported by iEdit.">
		</cfif>
		
		<!--- Check If Qulity value provided is correct                             --->
		<cfif arguments.quality gt 100 or arguments.quality lt 1>
			<cfthrow
				type="iedit.WrongType" 
				detail="Use a number between 1 to 100."
				message="Wrong image compression value (#arguments.quality#). [iEdit]">
		</cfif>
		
		<cftry>
		<cfset OutputStream = OutputStream.init(arguments.file)>
				
		<!--- If could not write in the given path, give and error                --->
			<cfcatch>
				<cfthrow
					type="iEdit.Image.Invalidfile" 
					detail="Output path provided seems to be wrong or write protected. Please provide the correct absolute path.<br>#cfcatch.Message#"
					message="Error writing the image to the provided path (#file#). [iEdit]">
			</cfcatch>
		</cftry>
	
		<!--- Get at image writer                                                  --->
		<cfset iter = ImageIO.getImageWritersByFormatName(arguments.type)>

		<cfif iter.hasNext()>
			<cfset writer = iter.next()>
		<cfelse>
		
		<!--- No image write found                                                --->
			<cfthrow
				type="iEdit.NoImageWriter"
				message="No image writer found for the file type (#arguments.type#). [iEdit]">
		</cfif>

		<!--- We set the image write                                            --->
		<cfset WriteParam = writer.getDefaultWriteParam()>


		<!--- Compress the image                                                --->
		<cfif WriteParam.canWriteCompressed()>
			<cfset WriteParam.setCompressionMode(WriteParam.MODE_EXPLICIT)>
			<cfset WriteParam.setCompressionQuality(arguments.quality/100)>
		</cfif>

		<!--- image data to write                                                --->
		<cfset imageMetadata = CreateObject('Java', "javax.imageio.IIOImage").init(this.Image, JavaCast("null", ""), JavaCast("null", ""))>
		<cfset ImageOutputStream = ImageIO.createImageOutputStream(OutputStream)>
		<cfset writer.setOutput(ImageOutputStream)>

		<!--- output the image                                                   --->
		<cfset dummy = CreateObject('java', 'java.lang.Object')>
		<cfset writer.write( dummy, imageMetadata, WriteParam)>

		<!--- Clean the memory                                                   --->
		<cfset this.Image.flush()>
		<cfset ImageOutputStream.flush()>
		<cfset writer.dispose()>
		<cfset ImageOutputStream.close()>
		<cfset OutputStream.close()>
			
	</cffunction>


<!--- ************************************************************************** ---->
<!--- Get image Property                                                         ---->
<!--- ************************************************************************** ---->

 	<cffunction name="getWidth" access="public" output="false" returntype="numeric">
		<cfset imageloaded()>
		<cfreturn this.Image.getWidth()>	
	</cffunction>
	
	<cffunction name="getHeight" access="public" output="false" returntype="numeric">
		<cfset imageloaded()>
		<cfreturn this.Image.getHeight()>	
	</cffunction> 

<!--- ************************************************************************** ---->
<!--- Edit  Image                                                                ---->
<!--- ************************************************************************** ---->

	<cffunction 
		name="Edit" 
		access="private" 
		output="false" 
		returntype="void">
	
		<cfargument name="Width" 	required="yes" type="numeric" 	default="100">
		<cfargument name="Height" 	required="yes" type="numeric" 	default="100">
		<cfargument name="quality" 	required="yes" type="any" 		default="smooth">
		
		<cfset imageloaded()>
		
		<!--- Get New Blank Image in the size we want                             --->
		<cfset NewImage = createNewImage(arguments.Width, arguments.Height)>
		<cfset BlankImage = NewImage.createGraphics()>

		<!--- Now Set Rendering Hints for the Image                               --->
		<cfswitch expression="#arguments.quality#">
			<cfcase value="fast">
				<cfset scalingQuality = createObject("java","java.awt.Image").SCALE_FAST>
			</cfcase>
			<cfdefaultcase>
				<cfset scalingQuality = createObject("java","java.awt.Image").SCALE_SMOOTH>
			</cfdefaultcase>
		</cfswitch>
		
		<!--- Scale the image                                                     --->
		<cfset ResizedImage = this.image.getScaledInstance(JavaCast("int", arguments.Width), JavaCast("int", arguments.Height), scalingQuality)>
	
		<cftry>	
			<!--- Write the resized image on to the new image                     --->
			<cfset BlankImage.drawImage(ResizedImage, JavaCast("int", 0), JavaCast("int", 0), createObject("java","java.awt.Canvas").init())>
		
			<cfcatch type="any">
				<cfthrow 
					type="iedit.ResizeError" 
					detail="#cfcatch.Message#"
					message="Error Resizing Image in iEdit.">
			</cfcatch>
			
		</cftry>
		
		<cfset this.image = NewImage>
		
		<!--- Clean the memory                                                   --->
		<cfset BlankImage.dispose()>
		<cfset ResizedImage.flush()>
		<cfset NewImage.flush()>
		
	</cffunction>

<!--- ************************************************************************** ---->
<!--- Create Blank Image                                                         ---->
<!--- ************************************************************************** ---->

	<cffunction 
		name="createNewImage" 
		access="private" 
		output="false" 
		hint="Create Blank Image in given size">
	
		<cfargument name="Width" type="numeric" required="yes" default="100">
		<cfargument name="Height" type="numeric" required="yes" default="100">
		
		<cfreturn createObject("java","java.awt.image.BufferedImage").init(JavaCast("int", arguments.Width), JavaCast("int", arguments.Height), JavaCast("int", 1))>

	</cffunction>
	
<!--- ************************************************************************** ---->
<!--- Ccheck if image loaded                                                     ---->
<!--- ************************************************************************** ---->

	<cffunction 
		name="imageloaded" 
		access="private" 
		output="false" 
		hint="Check image loaded before do anything eles">
	
		<cfargument name="image" type="numeric" required="yes" default="100">
		
		<cfif not IsDefined("this.image")>
			<cfthrow
				type="iedit.ImageNotFound" 
				detail="You must select input image using SelectImage () before call any other functions. Refer the iEdit manual."
				message="Error locating Input image image in iEdit.">
		</cfif>

	</cffunction>

<!--- ************************************************************************** ---->
<!--- Image Resize Calculations                                                  ---->
<!--- ************************************************************************** ---->

	<cffunction 
		name="scaleWidth" 
		access="public"
		output="false" 
		returntype="void" 
		hint="Calculate the image size by the given width">
		
		<cfargument name="Width" type="numeric" required="yes" default="100">
		
		<cfset OrginalWidth = getWidth()>
		<cfset OrginalHeight = getHeight()>
		<cfset ratio = arguments.Width / OrginalWidth>
		
		<cfset NewHeight = int(ratio*OrginalHeight)>
		
		<cfset edit(arguments.Width, NewHeight)>
		
	</cffunction>
	
	<!--- ********************************************************************** --->
	
	<cffunction 
		name="scaleHeight" 
		access="public"
		output="false" 
		returntype="void" 
		hint="Calculate the image size by the given Height">
		
		<cfargument name="Height" type="numeric" required="yes" default="100">
		
		<cfset OrginalWidth = getWidth()>
		<cfset OrginalHeight = getHeight()>
		<cfset ratio = arguments.Height / OrginalHeight>
		
		<cfset NewWidth = int(ratio*OrginalWidth)>
		
		<cfset edit(NewWidth, arguments.Height)>
		
	</cffunction>
	
	<!--- ********************************************************************** --->
	
	<cffunction 
		name="Scale" 
		access="public"
		output="false" 
		returntype="void" 
		hint="Scale by the both height and width recive by the user">
		
		<cfargument name="Width" type="numeric" required="yes" default="100">
		<cfargument name="Height" type="numeric" required="yes" default="100">
		
		<cfset edit(arguments.Width, arguments.Height)>
		
	</cffunction>

	<!--- ********************************************************************** --->
	
	<cffunction 
		name="FixHeight" 
		access="public"
		output="false" 
		returntype="void" 
		hint="Keep the Orginal Width and replace the Heigth only">
		
		<cfargument name="Height" type="numeric" required="yes" default="100">
		
		<cfset OrginalWidth = getWidth()>
				
		<cfset edit(OrginalWidth, arguments.Height)>
		
	</cffunction>
	
	<!--- ********************************************************************** --->
	
	<cffunction 
		name="FixWidth" 
		access="public"
		output="false" 
		returntype="void" 
		hint="Keep the Orginal Height and replace the Width only">
		
		<cfargument name="Width" type="numeric" required="yes" default="100">
		
		<cfset OrginalHeight = getHeight()>
				
		<cfset edit(arguments.Width, OrginalHeight)>
		
	</cffunction>
	
	<!--- ********************************************************************** --->
	
	<cffunction 
		name="ScaletoFit" 
		access="public"
		output="false" 
		returntype="void" 
		hint="Keep the Orginal Height and replace the Width only">
		
		<cfargument name="Width" type="numeric" required="yes" default="100">
		<cfargument name="Height" type="numeric" required="yes" default="100">
		
		<cfset OrginalHeight = getHeight()>
		<cfset OrginalWidth = getWidth()>

		
		<cfif OrginalHeight GTE OrginalWidth>
			<cfset scaleHeight(arguments.Height)>
		<cfelse>
			<cfset scaleWidth(arguments.Width)>
		</cfif>
		
	</cffunction>
	

<!--- ************************************************************************** ---->
<!--- Crop Image                                                                 ---->
<!--- ************************************************************************** ---->
	
	<cffunction 
		name="Crop" 
		access="public" 
		output="false" 
		hint="Crop the image and send to output">

		<cfargument name="Width" type="numeric" required="false" default="100">
		<cfargument name="Height" type="numeric" required="false" default="100">
		<cfargument name="x" type="numeric" required="false" default="1">
		<cfargument name="y" type="numeric" required="false" default="1">

		<cfset OrginalHeight = getHeight()>
		<cfset OrginalWidth = getWidth()>
		
		<!--- Error Check                                                       --->
		
		<cfif (arguments.x+Width) gt OrginalWidth>
			<cfthrow 
				type="iedit.CropErrorWidth" 
				detail="Orginal Image Width is #OrginalWidth#. <br> Crop Start Point is #arguments.X# and Crop End point Currently #val(arguments.x+Width)#  [iEdit]"
				message="Crop Area Out of the Orginal Image size">
		</cfif>
		
		<cfif (arguments.Y+Height) gt OrginalHeight>
			<cfthrow 
				type="iedit.CropErrorHeight" 
				detail="Orginal Image Height is #OrginalHeight#. <br> Crop Start Point is #arguments.Y# and Crop End point Currently #val(arguments.Y+Height)#  [iEdit]"
				message="Crop Area Out of the Orginal Image size">
		</cfif>
		
		
		<!--- Get New Blank Image in the size we want                             --->
		<cfset NewImage = createNewImage(arguments.Width, arguments.Height)>
		<cfset BlankImage = NewImage.createGraphics()>
		
		
		<!--- Crop  the image                                                     --->
		<cfset CropImage = this.image.getSubimage(JavaCast("int", arguments.x),JavaCast("int", arguments.y), JavaCast("int", arguments.Width), JavaCast("int", arguments.Height))>	

		<cftry>
			<!--- Write the croped image on to the new image                     --->
			<cfset BlankImage.drawImage(CropImage, JavaCast("int", 0), JavaCast("int", 0), createObject("java","java.awt.Canvas").init())>
			
			<cfcatch type="any">
				<cfthrow 
					type="iedit.ResizeError" 
					detail="#cfcatch.Message#"
					message="Error Croping Image in iEdit.">
			</cfcatch>
			
		</cftry>
		
		<cfset this.image = NewImage>

		<!--- Clean the memory                                                   --->
		<cfset BlankImage.dispose()>
		<cfset CropImage.flush()>
		<cfset NewImage.flush()>
		
	</cffunction>


<!--- ************************************************************************** ---->
<!--- Add Watermark                                                              ---->
<!--- ************************************************************************** ---->

	<cffunction 
		name="watermark" 
		access="public" 
		output="false" 
		hint="add water make image">

		<cfargument name="path" required="yes" type="string">
		<cfargument name="x" type="numeric" required="false" default="0" hint="X position of the watermark">
		<cfargument name="y" type="numeric" required="false" default="0" hint="Y position of the watermark">
		<cfargument name="transparency" type="numeric" required="false" hint="Transparency of the image">
		
		<cfset var InputStream = CreateObject("Java", "java.io.FileInputStream")>
		<cfset var SmallImage = CreateObject("java", "java.awt.image.BufferedImage")>
		<cfset var Operation = CreateObject("Java", "java.awt.image.AffineTransformOp")>
		
		<!--- Error Check                                                        --->
		<cfif not len(arguments.path)>
			<cfthrow 
				type="iedit.watermarkfilenotfound" 
				message="Watermark image not found at #arguments.file# [iEdit]">
		</cfif>
		
		<cfif IsDefined('arguments.transparency')>
			<cfif arguments.transparency gt 100 or arguments.transparency lt 0>
				<cfthrow 
					type="iedit.watermarktransparency"
					message="Watermark image Transparency should be a Numeric value between 0 - 100">
			</cfif>
		</cfif>
		
		<!--- Read the watermak image                                            --->
		<cftry>
			<cfset InputStream.init(arguments.path)>
			<cfset SmallImage = getImageIO().read(InputStream)>
			
			<cfcatch>
				<cfthrow 
				type="iedit.ReadWatermark"
				message="Error Reading the watermark image at iEdit">
			</cfcatch>	
		</cftry>

		<!--- Get the Main Image                                                 --->
		<cfset Graphics = this.Image.getGraphics()>
		
		<!--- Set Transparency                                                   --->
		<cfif IsDefined('arguments.transparency')>
			<cfset AlphaComposite(Graphics,arguments.transparency)>
		</cfif>
		
		<!--- Draw the image in to this.image                                    --->
		<cfset Graphics.drawImage(SmallImage, Operation, JavaCast("int", arguments.x), JavaCast("int", arguments.y))>

		<!--- Clean up the memory                                                --->
		<cfset Graphics.finalize()>
		<cfset Graphics.dispose()>
		<cfset SmallImage.flush()>

	</cffunction>
	
	
<!--- ************************************************************************** ---->
<!--- Set AlphaComposite                                                         ---->
<!--- ************************************************************************** ---->

	<cffunction name="AlphaComposite" 
		access="private" 
		output="false" 
		returntype="void" 
		hint="Set AlphaComposite">
		
		<cfargument name="Graphics" required="yes" type="any">
		<cfargument name="transparency" hint="Transparency settings." required="yes" type="any">

		<cfset var AlphaComposite = CreateObject("Java", "java.awt.AlphaComposite")>

		<!--- Create the transparency                                            --->
		<cfset transparency = AlphaComposite.getInstance(AlphaComposite.SRC_OVER, val(arguments.transparency/100))>
		
		<!--- Set transparency                                                   --->
		<cfset arguments.Graphics.setComposite(transparency)>

	</cffunction>
	
	
<!--- ************************************************************************** ---->
<!--- Outouf getImage values                                                     ---->
<!--- ************************************************************************** ---->

    <cffunction name="getImageIO" access="private" output="false" returntype="any">
       <cfreturn variables.imageIO>
    </cffunction>

<!--- ************************************************************************** ---->
<!--- Write text on top of an image                                              ---->
<!--- ************************************************************************** ---->

	<cffunction 
		name="writeText" 
		access="public" 
		output="false" 
		returntype="void">

		<cfargument name="text" required="yes" type="string" hint="text string">
		
		<cfargument name="x" 			required="yes" 		type="numeric" 						hint="X Position of the text to start">
		<cfargument name="Y" 			required="yes" 		type="numeric" 						hint="Y Position of the text to start">
		
		<cfargument name="FontFace" 	required="no" 		type="string" 	default="Verdana"	hint="Font Face of the Image">
		<cfargument name="FontColor" 	required="no" 		type="string" 	default="000000" 	hint="Font Color">		
		<cfargument name="FontSize" 	required="no" 		type="numeric"	default="10" 		hint="Font Size">
		<cfargument name="Fontstyle" 	required="no" 		type="string" 	default="plain" 	hint="Font Style - plain, bold, italic, boldItalic">
		
		<cfargument name="transparency"	required="false"	type="numeric" 	default="0" 		hint="Transparency of the image" >
		<cfargument name="Aliasing" 	required="no" 		type="string" 	default="Yes" 		hint="Should Fonts anti-aliasing or not">
		
		<cfargument name="effectType" 		required="no" 	type="string" 	default="E" 		hint="effect Distance">		
		<cfargument name="effectColor" 		required="no" 	type="string" 	default="333333" 	hint="effect Color">
		<cfargument name="effectColorTop" 	required="no" 	type="string" 	default="333333" 	hint="effect Color">	
		<cfargument name="effectColorSide" 	required="no" 	type="string" 	default="333333" 	hint="effect Color">				
		<cfargument name="effectDistance" 	required="no" 	type="numeric" 	default="2" 		hint="effect Distance">
		
		<cfset var NewImage = this.image.getGraphics()>
		
		<!---- set anti-aliasing if user passed yet --->
		<cfif YesNoFormat(arguments.aliasing)>
			<cfset SetAliasing(NewImage) />
		</cfif>
		
		<!--- set transparency value if user passed --->
		<cfif val(arguments.transparency)>
			<CFSET AlphaComposite(NewImage,arguments.transparency) />
		</cfif>

		<cfset NewImage.setFont(setfont(arguments.FontFace, arguments.FontSize, arguments.Fontstyle))>

		<!--- set effect ---->
		<cfset i=0>
		<cfscript>
		
		switch(arguments.effectType) {
		   case "E1":  
					 NewImage.drawString(arguments.text, javaCast("int", ShiftNorth(arguments.x,arguments.effectDistance)), javaCast("int", ShiftSouth(arguments.y,arguments.effectDistance)));
					 NewImage.setColor(GetColor(arguments.FontColor));
					 NewImage.drawString(arguments.text, javaCast("int", arguments.x), javaCast("int", arguments.y));	// base text		  
			  break;
		   case "E2": 
					 NewImage.drawString(arguments.text, javaCast("int", ShiftWest(arguments.x,arguments.effectDistance)), javaCast("int", ShiftNorth(arguments.y,arguments.effectDistance)));
					 NewImage.drawString(arguments.text, javaCast("int", ShiftWest(arguments.x,arguments.effectDistance)), javaCast("int", ShiftSouth(arguments.y,arguments.effectDistance)));
					 NewImage.drawString(arguments.text, javaCast("int", ShiftEast(arguments.x,arguments.effectDistance)), javaCast("int", ShiftNorth(arguments.y,arguments.effectDistance)));
					 NewImage.drawString(arguments.text, javaCast("int", ShiftEast(arguments.x,arguments.effectDistance)), javaCast("int", ShiftSouth(arguments.y,arguments.effectDistance)));
				  
					 NewImage.setColor(GetColor(arguments.FontColor));
					 NewImage.drawString(arguments.text, javaCast("int", arguments.x), javaCast("int", arguments.y));// base text
			  break;
		   case "E3": 
		    
				for (i = 0; i LT 5; i=i+1) {
				   NewImage.setColor(GetColor(arguments.effectColorTop));//top_color
				   NewImage.drawString(arguments.text,javaCast("int",  ShiftEast(x, i)), javaCast("int", ShiftNorth(ShiftSouth(y, i), arguments.effectDistance)));
				   NewImage.setColor(GetColor(arguments.effectColorSide));//side_color
				   NewImage.drawString(arguments.text, javaCast("int",ShiftWest(ShiftEast(x, i), arguments.effectDistance)), javaCast("int", ShiftSouth(y, i)));
				  // base text  
				   NewImage.setColor(GetColor(arguments.FontColor));
				   NewImage.drawString(arguments.text,javaCast("int",ShiftEast(x, 5)), javaCast("int", ShiftSouth(y, 5)));// base text

				   }			  
		   		break;		   
		   default: 
		   		NewImage.drawString(arguments.text, javaCast("int", arguments.x), javaCast("int", arguments.y));	// base text	
		}  
		</cfscript> 
		<CFSET NewImage.dispose()>
		
	</cffunction>
	
<!--- ************************************************************************** ---->
<!--- Font Aliasing                                                              ---->
<!--- ************************************************************************** ---->

	<!--- applyGrapicsSettings --->
	<cffunction name="SetAliasing" 
		access="private" 
		output="false" 
		returntype="void" 
		hint="Set Aliasing for fonts">
		
		<cfargument name="NewImage" required="yes" type="any">

		<cfset RenderingHints = CreateObject("Java", "java.awt.RenderingHints")>

		<cfset RenderingHints.init(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON)>
		<cfset RenderingHints.init(RenderingHints.KEY_TEXT_ANTIALIASING, RenderingHints.VALUE_TEXT_ANTIALIAS_ON )>
		<cfset NewImage.addRenderingHints(RenderingHints)>

	</cffunction>
	
<!--- ************************************************************************** ---->
<!--- GetColor                                                                   ---->
<!--- ************************************************************************** ---->

	<cffunction 
		name="GetColor" 
		access="private" 
		output="false" 
		returntype="any">

		<cfargument name="fontColor" required="yes" type="string" hint="text string">
		<cfscript>   	
			c1 = createObject("java", "java.awt.Color"); 
			c1.init(HexToInt(arguments.fontColor)); 
		</cfscript> 
		<cfreturn c1>
	</cffunction>	
	
<!--- ************************************************************************** ---->
<!--- Hex To Integer                                                             ---->
<!--- ************************************************************************** ---->

	<cffunction 
		name="HexToInt" 
		access="private" 
		output="false" 
		returntype="numeric">

		<cfargument name="hexValue" required="yes" type="string" hint="text string">
 
		<cfobject action=create type=java class=java.lang.Integer name=obj>
		<cfset x= obj.init(12)>
		<cfset value=obj.parseInt(arguments.hexValue, 16)>
		<cfreturn value>
	</cffunction>
	
<!--- ************************************************************************** ---->
<!--- Set Font                                                                   ---->
<!--- ************************************************************************** ---->

	<cffunction 
		name="setfont"
		access="private"
		output="false"
		returntype="any">

		<cfargument name="FontFace" required="yes" type="string">
		<cfargument name="FontSize" required="no" type="numeric" default="10">
		<cfargument name="FontStyle" required="no" type="string" default="plain">

		<cfset Font = CreateObject("Java","java.awt.Font")>

		<cfreturn Font.decode("#arguments.FontFace#-#ucase(arguments.FontStyle)#-#arguments.FontSize#")>
	</cffunction>
	
<!--- ************************************************************************** ---->
<!--- Shifting                                                                   ---->
<!--- ************************************************************************** ---->	

	<cffunction 
		name="ShiftNorth" 
		access="private" 
		output="false" 
		returntype="numeric">

		<cfargument name="point" required="yes" type="numeric" hint="text string">
		<cfargument name="distance" required="yes" type="numeric" hint="text string">
		<cfset value = val(arguments.point)-val(arguments.distance)>
		
		<cfreturn value>
 
	</cffunction>
	
	<cffunction 
		name="ShiftSouth" 
		access="private" 
		output="false" 
		returntype="numeric">

		<cfargument name="point" required="yes" type="numeric" hint="text string">
		<cfargument name="distance" required="yes" type="numeric" hint="text string">
		<cfset value = val(arguments.point)+val(arguments.distance)>
		
		<cfreturn value>
 
	</cffunction>
	
	<cffunction 
		name="ShiftEast" 
		access="private" 
		output="false" 
		returntype="numeric">

		<cfargument name="point" required="yes" type="numeric" hint="text string">
		<cfargument name="distance" required="yes" type="numeric" hint="text string">
		<cfset value = val(arguments.point)+val(arguments.distance)>
		
		<cfreturn value>
 
	</cffunction>
	<cffunction 
		name="ShiftWest" 
		access="private" 
		output="false" 
		returntype="numeric">

		<cfargument name="point" required="yes" type="numeric" hint="text string">
		<cfargument name="distance" required="yes" type="numeric" hint="text string">
		<cfset value = val(arguments.point)-val(arguments.distance)>
		
		<cfreturn value>
 
	</cffunction>
	
<!--- ************************************************************************** ---->
<!--- About iEdit                                                                ---->
<!--- ************************************************************************** ---->

	<cffunction name="about" access="public" output="true" returntype="struct">
		<cfset about = StructNew()>
		<cfset about.product 			= "iEdit">
		<cfset about.version 			= "1.24">
		<cfset about.first_release_Date = "15/11/2005">
		<cfset about.release_Date 		= "05/02/2007">
		<cfset about.release_by 		= "Developer Office (PVT) Ltd">
		<cfset about.website 			= "http://www.developeroffice.com">
		<cfset about.support 			= "iedit@developeroffice.com">
		<cfset about.developer 			= "saman@developeroffice.com">
		<cfset about.copyright 			= "(c) 2005 by Developer Office (PVT) Ltd">
		<cfreturn about>
	</cffunction> 
	

</cfcomponent>