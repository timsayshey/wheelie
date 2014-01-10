<cfcomponent extends="validation">

	<!--- 
		Tim's Validator
		validator(obj=rc,ruleset="pages",only="",errors=existingErrorArray)
	--->
	
	<cffunction name="init" access="public" output="false">
		<cfset super.init()>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="isPassing" access="public" output="false">
		<cfargument name="validateType" default="required">
		<cfargument name="objVal">
		<cfscript>
			var type = arguments.validateType;
			var fieldVal = arguments.objVal;
			var pass = true;	
			
			if(type eq "required")
			{
				pass = isValidRequired(fieldVal);
			}
			
			if(len(fieldVal))
			{
				if (type eq "email")
				{
					pass = isValidEmail(fieldVal);
				}
				else if (type eq "integer")
				{
					pass = isValidInteger(fieldVal);
				}
				else if (type eq "numeric")
				{
					pass = isValidNumeric(fieldVal);
				}
			}
		</cfscript>
		
		<cfreturn pass>
	</cffunction>
	
	<cffunction name="check" access="public" output="false">
		<cfargument name="obj" type="struct">
		<cfargument name="rulesetname" default="" type="string">
		<cfargument name="only" default="" type="string">
		<cfargument name="errors" default="#ArrayNew(1)#" type="array">
		
		<cfset var fields = arguments.obj>
		
		<cfif len(only)>
			<cfset fieldlist = arguments.only>
		<cfelse>
			<cfset fieldlist = StructKeyList(fields)>
		</cfif>		
		
		<cfset var rules = FileRead(ExpandPath("/model/validate/rulebook.js"))>
		<cfset rules = DeserializeJSON(rules)>		
		<cfset var rulesets = rules.validations>
		
		<cfif StructKeyExists(rulesets,rulesetname)>
			<cfset rulesets = rulesets[rulesetname]>
		</cfif>
		
		<cfset var newerrors = []>
		<cfset newerrors.addAll(errors)>
		
		<cfloop list="#fieldlist#" index="field">		
				
			<cfloop array="#rulesets#" index="ruleset">
				<cfscript>
					if (StructKeyExists(ruleset,field))
					{				
						ruleset = ruleset[field];
						for(rule in ruleset) {
						
							if (!isNull(rule.type))				
							{
								// Do validations								
								if (!isPassing(rule.type, fields[field]))
								{										
									var fieldname = capitalize(field);
									
									// Set message
									if (!isNull(rule.msg) and len(rule.msg))
									{							
										arrayAppend(newerrors, rule.msg);
									} else {
										arrayAppend(newerrors, "#fieldname# is required");
									}
								}
							}	
						
						}
					}		
				</cfscript>	
			</cfloop>
			
		</cfloop>		
		<cfreturn newerrors>
	</cffunction> 
	
	<cffunction name="capitalize">
		<cfargument name="input">
		<cfset capInput = lcase(input)>
		<cfset capInput1 = UCase(Left(capInput,1))>
		<cfset capInput2 = right(capInput,len(capInput) - 1)>
		<cfreturn capInput1 & capInput2>
	</cffunction>
	
</cfcomponent>