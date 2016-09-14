<cfcomponent mixin="controller" dependency="NestedErrorMessageOn">

	<!---
		8888888b.           888      888 d8b          
		888   Y88b          888      888 Y8P          
		888    888          888      888              
		888   d88P 888  888 88888b.  888 888  .d8888b 
		8888888P"  888  888 888 "88b 888 888 d88P"    
		888        888  888 888  888 888 888 888      
		888        Y88b 888 888 d88P 888 888 Y88b.    
		888         "Y88888 88888P"  888 888  "Y8888P 
	
	Public --->

	<cffunction name="init">
		<cfset this.version = "1.3,1.3.1,1.3.2,1.3.3,1.4.4,1.4.5,1.4.6,1.4.7,1.4.8,1.4.9,1.5,1.5.0,1.5.1,1.5.2">
		<cfreturn this>
	</cffunction>

	<!---
		8888888888                                              88888888888                
		888                                                         888                    
		888                                                         888                    
		8888888  .d88b.  888d888 88888b.d88b.                       888   8888b.   .d88b.  
		888     d88""88b 888P"   888 "888 "88b                      888      "88b d88P"88b 
		888     888  888 888     888  888  888      888888          888  .d888888 888  888 
		888     Y88..88P 888     888  888  888                      888  888  888 Y88b 888 
		888      "Y88P"  888     888  888  888                      888  "Y888888  "Y88888 
		                                                                               888 
		                                                                          Y8b d88P 
		                                                                           "Y88P"  
	Form - tag helpers --->

	<cffunction name="bSelectTag" returntype="string" hint="Bootstrap markup version of the standard Wheels `selectTag` form helper.">
		<cfscript>
			var loc = {
				formFieldArgs=$bootstrapFormFieldArgs(arguments)
			};
		</cfscript>
		<cfreturn selectTag(argumentCollection=loc.formFieldArgs)>
	</cffunction>
	
	<cffunction name="bFileFieldTag" returntype="string" hint="Bootstrap markup version of the standard Wheels `filetag` form helper.">
		<cfscript>		
			param name="arguments.label" type="string" default="";
			param name="arguments.help" type="string" default="";
			
			if(len(arguments.help)) {
				helpIcon = '<span class="elusive icon-question-sign helper" title data-original-title="#arguments.help#"></span>';
			} else {
				helpIcon = '';
			}
			
			returnfield =
				'<label>#arguments.label# #helpIcon#</label>
				<div class="fileupload fileupload-new" data-provides="fileupload">
					<div class="input-group">
						<div class="form-control">
							<i class="icon-file fileupload-exists"></i>
							<span class="fileupload-preview"></span>
						</div>
						<span class="input-group-btn">
							<span class="btn btn-default btn-file">
								<span class="fileupload-new">Select file</span>
								<span class="fileupload-exists">Change</span>
								<input type="file">
								#fileFieldTag(argumentCollection=arguments, label="")#							
							</span>
							<a href="##" class="btn btn-danger fileupload-exists" data-dismiss="fileupload">Remove</a>
						</span>
					</div>
				</div>';			
		</cfscript>
		<cfreturn returnfield>
	</cffunction>
	
	<cffunction name="bImageUploadTag" returntype="string" hint="Bootstrap markup version of the standard Wheels `filetag` form helper.">
		<cfscript>		
			param name="arguments.label" type="string" default="";
			param name="arguments.help" type="string" default="";
			param name="arguments.filepath" type="string" default="";
			
			imageRemovalCheckbox = '
				<script src="/assets/vendor/bootstrap-checkbox.js"></script>
				<link href="/assets/vendor/bootstrap-checkbox.css" rel="stylesheet" type="text/css" media="screen">
				<script>
					$(function() {
						$(''.bcheckbox'').checkbox({
							 buttonStyle: ''btn-danger'',
							 checkedClass: ''icon-check'',
							 uncheckedClass: ''icon-check-empty'',
							 displayAsButton: true
						});
					});
				</script>
				<input type="checkbox" class="bcheckbox" name="#arguments.name#_delete" data-label="Delete"/>
			';
			browseBtnText = "Change";
			if(!len(arguments.filepath) OR !FileExists(ExpandPath(arguments.filepath)))
			{ 
				arguments.filepath = "/assets/img/upload-thumb-50x50.png";
				imageRemovalCheckbox = "";
				browseBtnText = "Select image";
			}
			
			if(len(arguments.help)) {
				helpIcon = '<span class="elusive icon-question-sign helper" title data-original-title="#arguments.help#"></span>';
			} else {
				helpIcon = '';
			}
			
			returnfield =
				'<label>#arguments.label# #helpIcon#</label>
				<div class="fileupload fileupload-new" data-provides="fileupload">
					<div class="fileupload-new fileupload-small thumbnail">
						<img src="#arguments.filepath#">
					</div>
					<div class="fileupload-preview fileupload-exists fileupload-small thumbnail"></div>
					<span class="btn btn-default btn-file">
						<span class="fileupload-new">#browseBtnText#</span>
						<span class="fileupload-exists">Change</span>
						#fileFieldTag(argumentCollection=arguments, label="")#
					</span>
					<a href="##" class="btn btn-warning fileupload-exists" data-dismiss="fileupload">Cancel</a>
					#imageRemovalCheckbox#
				</div>';			
		</cfscript>
		<cfreturn returnfield>
	</cffunction>
	
	<!--- <cffunction name="bCheckboxTag" returntype="string" hint="Bootstrap markup version of the standard Wheels `selectTag` form helper.">
		
		<cfscript>
		
			param name="arguments.label" type="string" default="";
			param name="arguments.help" type="string" default="";
			
			if(len(arguments.help)) {
				helpIcon = '<span class="elusive icon-question-sign helper" title data-original-title="#arguments.help#"></span>';
			} else {
				helpIcon = '';
			}
			
			returnfield =
				'<label>#arguments.label# #helpIcon#</label>
				<div class="checkbox styled-checkbox">
					<label class="checkbox">
						#checkBoxTag(
							argumentCollection=arguments,
							label=""
						)#
					</label>
				</div>';
		
		</cfscript>
		<cfreturn returnfield>
	</cffunction> --->
	
	<cffunction name="bCheckboxTag" returntype="string" hint="Bootstrap markup version of the standard Wheels `selectTag` form helper.">
		<cfscript>
			arguments.class = "";
			var loc = {				
				formFieldArgs=$bootstrapFormFieldArgs(arguments)
			};
		</cfscript>
		<cfreturn CheckboxTag(argumentCollection=arguments)>
	</cffunction>
	
	<cffunction name="bSubmitTag" returntype="string" hint="Bootstrap markup version of the standard Wheels `submitTag` form helper.">
		<cfargument name="class" type="string" required="false" default="" hint="Space-delimited list of classes to apply to the submit button.">
		<cfargument name="isPrimary" type="boolean" required="false" default="false" hint="Whether or not to apply the `btn-primary` style to the button.">
		<cfscript>
			var loc = {
				coreSubmitTag=core.submitTag,
				class=ListAppend(arguments.class, "btn", " "),
				isPrimary=arguments.isPrimary
			};

			StructDelete(arguments, "isPrimary");
			StructDelete(arguments, "class");

			if (loc.isPrimary)
				loc.class = ListAppend(loc.class, "btn-primary", " ");

			loc.submitTag = loc.coreSubmitTag(argumentCollection=arguments);
			loc.submitTag = ReplaceNoCase(loc.submitTag, '<input', '<input class="#loc.class#"');
		</cfscript>
		<cfreturn loc.submitTag>
	</cffunction>

	<cffunction name="bPasswordFieldTag" returntype="string" hint="Bootstrap markup version of the standard CFWheels `passwordFieldTag` form helper.">
		<cfscript>
			var loc = {
				formFieldArgs=$bootstrapFormFieldArgs(arguments)
			};
		</cfscript>
		<cfreturn passwordFieldTag(argumentCollection=arguments)>
	</cffunction>

	<cffunction name="bTextFieldTag" returntype="string" hint="Bootstrap markup version of the standard Wheels `textFieldTag` form helper.">
		<cfscript>
			var loc = {
				formFieldArgs=$bootstrapFormFieldArgs(arguments)
			};
		</cfscript>
		<cfreturn textFieldTag(argumentCollection=arguments)>
	</cffunction>
	
	<cffunction name="bTextAreaTag" returntype="string" hint="Bootstrap markup version of the standard Wheels `textAreaTag` form helper.">
		<cfscript>
			var loc = {
				formFieldArgs=$bootstrapFormFieldArgs(arguments)
			};
		</cfscript>
		<cfreturn textAreaTag(argumentCollection=arguments)>
	</cffunction>

	<cffunction name="hStartFormTag" returntype="string" hint="Bootstrap markup version of the Wheels `startFormTag` form helper, except with the `form-horizontal` class applied for you.">
		<cfargument name="class" type="string" required="false" default="" hint="Space-delimited list of classes to apply to the form tag.">
		<cfscript>
			arguments.class = ListAppend(arguments.class, "form-horizontal", " ");
		</cfscript>
		<cfreturn startFormTag(argumentCollection=arguments)>
	</cffunction>

	<!---
		8888888888                                               .d88888b.  888       d8b                   888    
		888                                                     d88P" "Y88b 888       Y8P                   888    
		888                                                     888     888 888                             888    
		8888888  .d88b.  888d888 88888b.d88b.                   888     888 88888b.  8888  .d88b.   .d8888b 888888 
		888     d88""88b 888P"   888 "888 "88b                  888     888 888 "88b "888 d8P  Y8b d88P"    888    
		888     888  888 888     888  888  888      888888      888     888 888  888  888 88888888 888      888    
		888     Y88..88P 888     888  888  888                  Y88b. .d88P 888 d88P  888 Y8b.     Y88b.    Y88b.  
		888      "Y88P"  888     888  888  888                   "Y88888P"  88888P"   888  "Y8888   "Y8888P  "Y888 
		                                                                              888                          
		                                                                             d88P                          
		                                                                           888P"                           
	Form - object helpers --->
	
	<cffunction name="bLabel" returntype="string" hint="Bootstrap markup version of the label">
		<cfscript>
			var loc = {};
			
			param name="arguments.label" type="string" default="";
			param name="arguments.help" type="string" default="";
			
			if(len(arguments.help)) {
				helpIcon = '<span class="elusive icon-question-sign helper" title data-original-title="#arguments.help#"></span>';
			} else {
				helpIcon = '';
			}
			
			loc.field = '<label>#arguments.label# #helpIcon#</label>';
		</cfscript>
		<cfreturn loc.field>
	</cffunction>
	
	<!--- <cffunction name="bCheckBox" returntype="string" hint="Bootstrap markup version of the Wheels `checkBox` form helper.">
		<cfscript>
			var loc = {};
			
			param name="arguments.label" type="string" default="";
			param name="arguments.help" type="string" default="";
			
			loc.field = checkBox(
				argumentCollection=arguments,
				label=""
			);

			loc.hasErrors = Evaluate($objectName(argumentCollection=arguments)).hasErrors(arguments.property);
			
			if(len(arguments.help)) {
				helpIcon = '<span class="elusive icon-question-sign helper" title data-original-title="#arguments.help#"></span>';
			} else {
				helpIcon = '';
			}
			
			loc.field =
				'<label>#arguments.label# #helpIcon#</label>
				<div class="checkbox styled-checkbox">
					<label class="checkbox #loc.hasErrors ? 'has-error': ''#">
						#loc.field#
					</label>
				</div>';
		</cfscript>
		<cfreturn loc.field>
	</cffunction> --->
	
	<cffunction name="bCheckBox" returntype="string" hint="Bootstrap markup version of the Wheels `checkBox` form helper.">
		<cfscript>
			arguments.class = "";
			var loc = {
				formFieldArgs=$boostrapObjectFormFieldArgs(arguments)
			};
		</cfscript>
		<cfreturn checkbox(argumentCollection=loc.formFieldArgs)>
	</cffunction>

	<cffunction name="bFileField" returntype="string" hint="Bootstrap markup version of the Wheels `fileField` form helper.">
		<cfscript>
			var loc = {
				formFieldArgs=$boostrapObjectFormFieldArgs(arguments)
			};
		</cfscript>
		<cfreturn fileField(argumentCollection=loc.formFieldArgs)>
	</cffunction>

	<cffunction name="bHasManyCheckBox" returntype="string" access="public" output="false" hint="Bootstrap version of the Wheels `hasManyCheckBox` form helper.">
		<cfscript>
			var loc = {};
			$args(name="hasManyCheckBox", args=arguments);
			loc.checked = true;
			loc.returnValue = "";
			loc.included = includedInObject(argumentCollection=arguments);

			if (!loc.included)
			{
				loc.included = "";
				loc.checked = false;
			}

			loc.tagId = "#arguments.objectName#-#arguments.association#-#Replace(arguments.keys, ",", "-", "all")#-_delete";
			loc.tagName = "#arguments.objectName#[#arguments.association#][#arguments.keys#][_delete]";

			// Override starts here
			StructDelete(arguments, "keys", false);
			StructDelete(arguments, "objectName", false);
			StructDelete(arguments, "association", false);

			loc.field = checkBoxTag(name=loc.tagName, id=loc.tagId, value=0, checked=loc.checked, uncheckedValue=1, argumentCollection=arguments);

			loc.field =
				'<div class="checkbox">
					#loc.field#
				</div>';
		</cfscript>
		<cfreturn loc.field>
	</cffunction>

	<cffunction name="bPasswordField" returntype="string" hint="Bootstrap markup version of the Wheels `passwordField` form helper.">
		<cfscript>
			var loc = {
				formFieldArgs=$boostrapObjectFormFieldArgs(arguments)
			};
		</cfscript>
		<cfreturn passwordField(argumentCollection=loc.formFieldArgs)>
	</cffunction>

	<cffunction name="bSelect" returntype="string" hint="Bootstrap markup version of the Wheels `select` form helper.">
		<cfscript>
			var loc = {
				formFieldArgs=$boostrapObjectFormFieldArgs(arguments)
			};
		</cfscript>
		<cfreturn select(argumentCollection=loc.formFieldArgs)>
	</cffunction>

	<cffunction name="bTextArea" returntype="string" hint="Boostrap markup version of the Wheels `textArea` form helper.">
		<cfscript>
			var loc = {
				formFieldArgs=$boostrapObjectFormFieldArgs(arguments)
			};
		</cfscript>
		<cfreturn textArea(argumentCollection=loc.formFieldArgs)>
	</cffunction>

	<cffunction name="bTextField" returntype="string" hint="Bootstrap markup version of the Wheels `textField` form helper.">
		<cfscript>
			var loc = {
				formFieldArgs=$boostrapObjectFormFieldArgs(arguments)
			};
		</cfscript>
		<cfreturn textField(argumentCollection=loc.formFieldArgs)>
	</cffunction>

	<cffunction name="bUneditableTextField" returntype="string" hint="Bootstrap helper for showing an uneditable text field.">
		<cfargument name="label" type="string" required="true" hint="Field label.">
		<cfargument name="value" type="string" required="true" hint="Value to display in box.">
		<cfargument name="class" type="string" required="false" default="" hint="Classes to apply to the box.">
		<cfscript>
			var loc = {};
			
			loc.field = '<div class="form-group">';
			loc.field &= '<label class="control-label col-sm-3">#h(arguments.label)#</label>';
			loc.field &= '<div class="col-sm-9"><span class="uneditable-input #h(arguments.class)#">#arguments.value#</span></div>';
			loc.field &= '</div>';
		</cfscript>
		<cfreturn loc.field>
	</cffunction>

	<!---
		888                                          888    
		888                                          888    
		888                                          888    
		888       8888b.  888  888  .d88b.  888  888 888888 
		888          "88b 888  888 d88""88b 888  888 888    
		888      .d888888 888  888 888  888 888  888 888    
		888      888  888 Y88b 888 Y88..88P Y88b 888 Y88b.  
		88888888 "Y888888  "Y88888  "Y88P"   "Y88888  "Y888 
		                       888                          
		                  Y8b d88P                          
		                   "Y88P"                           
	Layout helpers --->

	<cffunction name="bFlashMessages" returntype="string" hint="Bootstrap markup version of the Wheels `flashMessages` view helper.">
		<cfscript>
			var loc = {
				flash=flash(),
				flashKeyList=StructKeyList(flash()),
				flashMessages=""
			};

			if (flashCount()) {
				for (loc.i = 1; loc.i <= flashCount(); loc.i++) {
					loc.flashKey = ListGetAt(loc.flashKeyList, loc.i);

					switch (loc.flashKey) {
						case "error":
							loc.flashClass = "danger";
							break;
						case "notice":
							loc.flashClass = "warning";
							break;
						default:
							loc.flashClass = loc.flashKey;
					}

					loc.flashMessages &=
						'<div class="alert alert-#LCase(loc.flashClass)#">
							<a class="close" data-dismiss="alert" href="##" title="Dismiss">&times;</a>
							#h(flash(loc.flashKey))#
						</div>';
				}
			}
		</cfscript>
		<cfreturn loc.flashMessages>
	</cffunction>

	<!---
		888b     d888 d8b                   
		8888b   d8888 Y8P                   
		88888b.d88888                       
		888Y88888P888 888 .d8888b   .d8888b 
		888 Y888P 888 888 88K      d88P"    
		888  Y8P  888 888 "Y8888b. 888      
		888   "   888 888      X88 Y88b.    
		888       888 888  88888P'  "Y8888P 

	Miscellaneous helpers --->

	<cffunction name="bPaginationLinks" returntype="string" hint="Bootstrap markup version of the Wheels `paginationLinks` view helper.">
		<cfscript>
			var loc = {};

			loc.paginationArgs = Duplicate(arguments);

			loc.paginationArgs.prepend = '<ul class="pagination">';
			loc.paginationArgs.append = '</ul>';
			loc.paginationArgs.prependToPage = '<li>';
			loc.paginationArgs.appendToPage = '</li>'; 
			loc.paginationArgs.classForCurrent = "active";
			loc.paginationArgs.linkToCurrentPage = false;
			loc.paginationArgs.anchorDivider = '<li class="disabled"><span href="javascript:void(0)">...</span></li>';
			loc.paginationArgs.linkToCurrentPage = true;

			loc.paginationLinks = paginationLinks(argumentCollection=loc.paginationArgs);
			loc.paginationLinks = Replace(loc.paginationLinks, '<li><a class="active"', '<li class="active"><a', "all");
		</cfscript>
		<cfreturn loc.paginationLinks>
	</cffunction>

	<!---
		8888888b.          d8b                   888            
		888   Y88b         Y8P                   888            
		888    888                               888            
		888   d88P 888d888 888 888  888  8888b.  888888 .d88b.  
		8888888P"  888P"   888 888  888     "88b 888   d8P  Y8b 
		888        888     888 Y88  88P .d888888 888   88888888 
		888        888     888  Y8bd8P  888  888 Y88b. Y8b.     
		888        888     888   Y88P   "Y888888  "Y888 "Y8888  

	Private --->

	<cffunction name="$bootstrapFormFieldArgs" returntype="struct" hint="Factors out common elements that need to be set to get form fields to be Bootstrap-friendly.">
		<cfargument name="fieldArgs" type="struct" required="true" hint="`arguments` scope passed to form helper.">
		<cfscript>
			var loc = {};

			param name="arguments.fieldArgs.labelClass" type="string" default="";
			param name="arguments.fieldArgs.label" type="string" default="";
			param name="arguments.fieldArgs.class" type="string" default="form-control";
			param name="arguments.fieldArgs.groupClass" type="string" default="";
			param name="arguments.fieldArgs.prependToLabel" type="string" default='';
			param name="arguments.fieldArgs.appendToLabel" type="string" default='';
			param name="arguments.fieldArgs.colclass" type="string" default='';
			param name="arguments.fieldArgs.append" type="string" default='<div class="separator"></div>';
			
			if(!isNull(arguments.fieldArgs.isSelectize))
			{
				arguments.fieldArgs.colclass = '';
			}			

			arguments.fieldArgs.class = ListAppend(arguments.fieldArgs.class, "#arguments.fieldArgs.colclass#", " ");
			arguments.fieldArgs.labelPlacement = "before";
			arguments.fieldArgs.labelClass = ListAppend(arguments.fieldArgs.labelClass, "", " ");			
			
			arguments.fieldArgs.errorElement = "";
			arguments.fieldArgs.errorClass = "";
				
			// Add group class
			if (Len(arguments.fieldArgs.groupClass)) {
				arguments.fieldArgs.prependToLabel = Replace(arguments.fieldArgs.prependToLabel, "form-group", "form-group #h(arguments.fieldArgs.groupClass)#");
			}

			// Prepend/appended text
			loc.hasPrependedText = StructKeyExists(arguments.fieldArgs, "prependedText") && Len(arguments.fieldArgs.prependedText);
			loc.hashelp = StructKeyExists(arguments.fieldArgs, "help") && Len(arguments.fieldArgs.help);

			if (loc.hasPrependedText || loc.hashelp) {
				loc.prependClass = loc.hasPrependedText ? 'input-prepend' : '';
				loc.appendClass = loc.hashelp ? 'input-append' : '';
				arguments.fieldArgs.prepend = '<div class="#loc.prependClass# #loc.appendClass#">';
				arguments.fieldArgs.append = '</div>' & arguments.fieldArgs.append;

				if (loc.hasPrependedText) {
					if(StructKeyExists(arguments.fieldArgs, "prependedTextAppended") AND arguments.fieldArgs.prependedTextAppended eq true) {
						arguments.fieldArgs.prepend &= '<div class="input-group">';
						arguments.fieldArgs.append = '<span class="input-group-addon">#arguments.fieldArgs.prependedText#</span></div></div><div class="separator"></div>';
					} else {
						arguments.fieldArgs.prepend &= '<div class="input-group">
														<span class="input-group-addon">#arguments.fieldArgs.prependedText#</span>';
						arguments.fieldArgs.append = '</div></div><div class="separator"></div>';
					}
					
					
				}

				if (loc.hashelp) {
					
					arguments.fieldArgs.label = arguments.fieldArgs.label & '<span class="elusive icon-question-sign helper" title data-original-title="#arguments.fieldArgs.help#"></span>';
				}
			}

			// Help block
			if (StructKeyExists(arguments.fieldArgs, "helpBlock") && Len(arguments.fieldArgs.helpBlock)) {
				arguments.fieldArgs.append = '<span class="help-block">#arguments.fieldArgs.helpBlock#</span>' & arguments.fieldArgs.append;
			}

			// Remove arguments that will cause extra HTML attributes to be added
			StructDelete(arguments.fieldArgs, "helpBlock");
			StructDelete(arguments.fieldArgs, "prependedText");
			StructDelete(arguments.fieldArgs, "help");
			StructDelete(arguments.fieldArgs, "colclass");
			StructDelete(arguments.fieldArgs, "groupClass");
		</cfscript>
		<cfreturn arguments.fieldArgs>
	</cffunction>

	<cffunction name="$boostrapObjectFormFieldArgs" returntype="struct" hint="Factors out common elements that needs to be set to get object-based form fields to be Bootstrap-friendly.">
		<cfargument name="fieldArgs" type="struct" required="true" hint="`arguments` scope passed to form helper.">
		<cfscript>
			var loc = {};
			param name="arguments.fieldArgs.prepend" default="";
			
			// Get basic settings from general form field helper
			arguments.fieldArgs = $bootstrapFormFieldArgs(arguments.fieldArgs);

			// Arguments needed for `errorMessageOn`
			loc.errorMessageOnArgs = {
				objectName=arguments.fieldArgs.objectName,
				property=arguments.fieldArgs.property,
				wrapperElement="span",
				class="error-text"
			};
			if (StructKeyExists(arguments.fieldArgs, "association")) {
				loc.errorMessageOnArgs.association = arguments.fieldArgs.association;
			}
			if (StructKeyExists(arguments.fieldArgs, "position")) {
				loc.errorMessageOnArgs.position = arguments.fieldArgs.position;
			}

			// Error message			
			if (Evaluate($objectName(argumentCollection=arguments.fieldArgs)).hasErrors(arguments.fieldArgs.property)) {
				arguments.fieldArgs.prepend = Replace(
					arguments.fieldArgs.prepend,
					'input-append',
					'input-append has-error'
				);

				arguments.fieldArgs.append =
					Replace(arguments.fieldArgs.append,'<div class="separator"></div>','','ALL') & 
					' #errorMessageOn(argumentCollection=loc.errorMessageOnArgs)# <div class="separator"></div>';
			}
			
		</cfscript>
		<cfreturn arguments.fieldArgs>
	</cffunction>

</cfcomponent>