<!--- @@Copyright: Copyright (c) 2011 ImageAid. All rights reserved. --->
<!--- @@License: Free :). Whatever. It's just a stupid little helper plugin --->
<cfcomponent output="false" mixin="controller">
	
	<cfproperty name="us_states" type="query" displayname="US States" hint="I am a query representing all US states" />
	<cfproperty name="canadian_provinces" type="query" displayname="Canadian Provinces" hint="I am a query representing all Canadian Provinces" />
	<cfproperty name="us_states_and_canadian_provinces" type="query" displayname="US States and Canadian Provinces" hint="I am a query representing all Canadian Provinces and US States" />
	<cfproperty name="countries" type="query" displayname="Countries" hint="I am a query representing all countries" />  
	<cfproperty name="asset_path" type="string" displayname="AssetPath" hint="I represet the location of the asset files" value="" />
	
	<cffunction access="public" returntype="StatesAndCountries" name="init">
		<cfscript>
			this.version = "1.0.4,1.0.5,1.1,1.1.1,1.1.2,1.1.3,1.1.4,1.1.5";      
			return this;
		</cfscript> 
	</cffunction>
	
	<cffunction name="getUSStates" returntype="query" access="public" output="false" displayname="getUSStates" hint="I return a query of structures for US states">
		<cfscript>			
			return $loadElements("us_states");
		</cfscript>
	</cffunction> 
	
	<cffunction name="getCanadianProvinces" returntype="query" access="public" output="false" displayname="getCanadianProvinces" hint="I return a query of structures for Canadian provinces">
		<cfscript> 
			return $loadElements("canadian_provinces");
		</cfscript>
	</cffunction>
	
	<cffunction name="getUSStatesAndCanadianProvinces" returntype="query" access="public" output="false" displayname="getUSStatesAndCanadianProvinces" hint="I return a query of structures for US states and Canadian provinces">
		<cfscript>			
			return $loadElements("us_states_and_canadian_provinces");
		</cfscript>
	</cffunction>
	
	<cffunction name="getCountries" returntype="query" access="public" output="false" displayname="getCountries" hint="I return a query of structures countries">
		<cfscript>			
			return $loadElements("countries");
		</cfscript>
	</cffunction>
	
	<!--- PRIVATE METHODS -- sort of --->
	<cffunction name="$loadElements" access="public" returntype="query" output="false" displayname="$loadElements" hint="I setup the arrays">
		<cfargument name="item_to_load" type="string" required="false" default="us_states" displayname="item_to_load" hint="I represend the items to load" />
		<cfscript>
			var us_states_xml = xmlNew();
			var canadian_provinces_xml = xmlNew();
			var countries_xml = xmlNew();                  
			var asset_path = "";
			variables.us_states = queryNew("name,abbreviation");
			variables.canadian_provinces = queryNew("name,abbreviation");
			variables.us_states_and_canadian_provinces = queryNew("name,abbreviation");
			variables.countries = queryNew("name,abbreviation");                       
			// check if the server is ACF and, if so, set a different asset_path (blank string for Railo and, I believe, OBD)
			if( structKeyExists(server.coldfusion,"productname") && lcase(trim(server.coldfusion.productname)) contains "coldfusion" ){
				asset_path = getDirectoryFromPath(getCurrentTemplatePath()) & "/";
			}
		</cfscript>
		<cfswitch expression="#trim(lcase(arguments.item_to_load))#">
			<cfcase value="us_states">
				<cffile action="read" file="#asset_path#assets/us_states.xml" variable="us_states_content" />  
				<cfscript>					         
					if(!structKeyExists(application,"usStates")){
						us_states_xml = xmlParse(us_states_content);    						
						for(i = 1; i lte arrayLen(us_states_xml.XMLChildren[1].XMLChildren); i = i + 1){
							queryAddRow(variables.us_states); 
							querySetCell(variables.us_states,"name",us_states_xml.XMLChildren[1].XMLChildren[i].XMLChildren[1].xmlText);
							querySetCell(variables.us_states,"abbreviation",us_states_xml.XMLChildren[1].XMLChildren[i].XMLChildren[2].xmlText); 
						}
						application.usStates = variables.us_states;
					}
					return application.usStates;
				</cfscript>
			</cfcase> 
			<cfcase value="canadian_provinces">
				<cffile action="read" file="#asset_path#assets/canadian_provinces.xml" variable="canadian_provinces_content" />
				<cfscript>        
					if(!structKeyExists(application,"canadianProvinces")){           						
						canadian_provinces_xml = xmlParse(canadian_provinces_content);
						for(i = 1; i lte arrayLen(canadian_provinces_xml.XMLChildren[1].XMLChildren); i = i + 1){
							queryAddRow(variables.canadian_provinces);
							querySetCell(variables.canadian_provinces,"name",canadian_provinces_xml.XMLChildren[1].XMLChildren[i].XMLChildren[1].xmlText);
							querySetCell(variables.canadian_provinces,"abbreviation",canadian_provinces_xml.XMLChildren[1].XMLChildren[i].XMLChildren[2].xmlText);
						}
						application.canadianProvinces = variables.canadian_provinces;
					}
					return application.canadianProvinces;
				</cfscript>
			</cfcase>
			<cfcase value="us_states_and_canadian_provinces">
				<cffile action="read" file="#asset_path#assets/canadian_provinces.xml" variable="canadian_provinces_content" />
				<cffile action="read" file="#asset_path#assets/us_states.xml" variable="us_states_content" />  
				<cfscript>
					if(!structKeyExists(application,"usStatesAndCanadianProvinces")){
					  	us_states_xml = xmlParse(us_states_content);
						canadian_provinces_xml = xmlParse(canadian_provinces_content);
						for(i = 1; i lte arrayLen(us_states_xml.XMLChildren[1].XMLChildren); i = i + 1){
							queryAddRow(variables.us_states_and_canadian_provinces);
							querySetCell(variables.us_states_and_canadian_provinces,"name",us_states_xml.XMLChildren[1].XMLChildren[i].XMLChildren[1].xmlText);
							querySetCell(variables.us_states_and_canadian_provinces, "abbreviation", us_states_xml.XMLChildren[1].XMLChildren[i].XMLChildren[2].xmlText);
						}
						for(i = 1; i lte arrayLen(canadian_provinces_xml.XMLChildren[1].XMLChildren); i = i + 1){
							queryAddRow(variables.us_states_and_canadian_provinces);
							querySetCell( variables.us_states_and_canadian_provinces, "name", canadian_provinces_xml.XMLChildren[1].XMLChildren[i].XMLChildren[1].xmlText );
							querySetCell( variables.us_states_and_canadian_provinces, "abbreviation", canadian_provinces_xml.XMLChildren[1].XMLChildren[i].XMLChildren[2].xmlText );    
						} 
						application.usStatesAndCanadianProvinces = variables.us_states_and_canadian_provinces; 
					}
					return application.usStatesAndCanadianProvinces; 
				</cfscript>
			</cfcase>
			<cfcase value="countries">
				<cffile action="read" file="#asset_path#assets/countries.xml" variable="countries_content" /> 
				<cfscript>                                                 
					if(!structKeyExists(application,"countries")){
						countries_xml = xmlParse(countries_content); 
						for(i = 1; i lte arrayLen(countries_xml.XMLChildren[1].XMLChildren); i = i + 1){ 
							queryAddRow(variables.countries);
							querySetCell(variables.countries,"name",countries_xml.XMLChildren[1].XMLChildren[i].xmlText);
							querySetCell(variables.countries,"abbreviation",countries_xml.XMLChildren[1].XMLChildren[i].XMLAttributes.code);
						}           
						application.countries = variables.countries;				
					}                                
					return application.countries;
				</cfscript>
			</cfcase>
		</cfswitch>		   
		                   
	</cffunction>
	
</cfcomponent>