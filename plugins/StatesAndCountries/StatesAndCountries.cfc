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
			this.version = "1.3,1.3.1,1.3.2,1.3.3,1.4.4,1.4.5,1.4.6,1.4.7,1.4.8,1.4.9,1.5,1.5.0,1.5.1,1.5.2";
			return this;
		</cfscript> 
	</cffunction>
	
	<cffunction name="getStatesAndProvinces" returntype="query" access="public" output="false" displayname="getStatesAndProvinces" hint="I return a query of structures for US states">
		<cfscript>			
			return $loadElements("statesAndProvinces");
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
			var asset_path = "/plugins/StatesAndCountries/";
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
			<cfcase value="statesAndProvinces">
				<cfscript>					
					if(!structKeyExists(application,"statesAndProvinces"))
					{
						application.statesAndProvinces = statesAndProvincesQuery();
					}
					return application.statesAndProvinces;
				</cfscript>
			</cfcase> 
			<cfcase value="countries">
				<cfscript>					
					if(!structKeyExists(application,"countries"))
					{
						application.countries = countriesQuery();
					}
					return application.countries;
				</cfscript>
			</cfcase>
		</cfswitch>		   
		                   
	</cffunction>
	
	<cffunction name="countriesQuery">
		<cfset countries = queryNew(
			"name,abbreviation",
			"varchar,varchar",
			[
				{name:"United States",abbreviation:"US"},
				{name:"Afghanistan",abbreviation:"AF"},
				{name:"Albania",abbreviation:"AL"},
				{name:"Algeria",abbreviation:"DZ"},
				{name:"American Samoa",abbreviation:"AS"},
				{name:"Andorra",abbreviation:"AD"},
				{name:"Angola",abbreviation:"AO"},
				{name:"Anguilla",abbreviation:"AI"},
				{name:"Antarctica",abbreviation:"AQ"},
				{name:"Antigua and Barbuda",abbreviation:"AG"},
				{name:"Argentina",abbreviation:"AR"},
				{name:"Armenia",abbreviation:"AM"},
				{name:"Aruba",abbreviation:"AW"},
				{name:"Australia",abbreviation:"AU"},
				{name:"Austria",abbreviation:"AT"},
				{name:"Azerbaijan",abbreviation:"AZ"},
				{name:"Bahamas",abbreviation:"BS"},
				{name:"Bahrain",abbreviation:"BH"},
				{name:"Bangladesh",abbreviation:"BD"},
				{name:"Barbados",abbreviation:"BB"},
				{name:"Belgium",abbreviation:"BE"},
				{name:"Belize",abbreviation:"BZ"},
				{name:"Benin",abbreviation:"BJ"},
				{name:"Bermuda",abbreviation:"BM"},
				{name:"Bhutan",abbreviation:"BT"},
				{name:"Bolivia",abbreviation:"BO"},
				{name:"Botswana",abbreviation:"BW"},
				{name:"Bouvet Island",abbreviation:"BV"},
				{name:"Brazil",abbreviation:"BR"},
				{name:"British Indian Ocean Territory",abbreviation:"IO"},
				{name:"Brunei Darussalam",abbreviation:"BN"},
				{name:"Bulgaria",abbreviation:"BG"},
				{name:"Burkina Faso",abbreviation:"BF"},
				{name:"Burundi",abbreviation:"BI"},
				{name:"Cambodia",abbreviation:"KH"},
				{name:"Cameroon",abbreviation:"CM"},
				{name:"Canada",abbreviation:"CA"},
				{name:"Cape Verde",abbreviation:"CV"},
				{name:"Cayman Islands",abbreviation:"KY"},
				{name:"Central African Republic",abbreviation:"CF"},
				{name:"Chad",abbreviation:"TD"},
				{name:"Chile",abbreviation:"CL"},
				{name:"China",abbreviation:"CN"},
				{name:"Christmas Island",abbreviation:"CX"},
				{name:"Cocos (Keeling) Islands",abbreviation:"CC"},
				{name:"Colombia",abbreviation:"CO"},
				{name:"Comoros",abbreviation:"KM"},
				{name:"Congo",abbreviation:"CG"},
				{name:"Congo-The Democratic Rep. Of The",abbreviation:"CD"},
				{name:"Cook Islands",abbreviation:"CK"},
				{name:"Costa Rica",abbreviation:"CR"},
				{name:"Croatia",abbreviation:"HR"},
				{name:"Cyprus",abbreviation:"CY"},
				{name:"Czech Republic",abbreviation:"CZ"},
				{name:"Denmark",abbreviation:"DK"},
				{name:"Djibouti",abbreviation:"DJ"},
				{name:"Dominica",abbreviation:"DM"},
				{name:"Dominican Republic",abbreviation:"DO"},
				{name:"East Timor",abbreviation:"TP"},
				{name:"Ecuador",abbreviation:"EC"},
				{name:"Egypt",abbreviation:"EG"},
				{name:"El Salvador",abbreviation:"SV"},
				{name:"Equatorial Guinea",abbreviation:"GQ"},
				{name:"Eritrea",abbreviation:"ER"},
				{name:"Estonia",abbreviation:"EE"},
				{name:"Ethiopia",abbreviation:"ET"},
				{name:"Falkland Islands (Malvinas)",abbreviation:"FK"},
				{name:"Faroe Islands",abbreviation:"FO"},
				{name:"Fiji",abbreviation:"FJ"},
				{name:"Finland",abbreviation:"FI"},
				{name:"France",abbreviation:"FR"},
				{name:"French Guiana",abbreviation:"GF"},
				{name:"French Polynesia",abbreviation:"PF"},
				{name:"French Southern Territories",abbreviation:"TF"},
				{name:"Gabon",abbreviation:"GA"},
				{name:"Gambia",abbreviation:"GM"},
				{name:"Georgia",abbreviation:"GE"},
				{name:"Germany",abbreviation:"DE"},
				{name:"Ghana",abbreviation:"GH"},
				{name:"Gibraltar",abbreviation:"GI"},
				{name:"Greece",abbreviation:"GR"},
				{name:"Greenland",abbreviation:"GL"},
				{name:"Grenada",abbreviation:"GD"},
				{name:"Guadeloupe",abbreviation:"GP"},
				{name:"Guam",abbreviation:"GU"},
				{name:"Guatemala",abbreviation:"GT"},
				{name:"Guinea",abbreviation:"GN"},
				{name:"Guinea-Bissau",abbreviation:"GW"},
				{name:"Guyana",abbreviation:"GY"},
				{name:"Haiti",abbreviation:"HT"},
				{name:"Heard Island and Mcdonald Islands",abbreviation:"HM"},
				{name:"Holy See (Vatican City State)",abbreviation:"VA"},
				{name:"Honduras",abbreviation:"HN"},
				{name:"Hong Kong",abbreviation:"HK"},
				{name:"Hungary",abbreviation:"HU"},
				{name:"Iceland",abbreviation:"IS"},
				{name:"India",abbreviation:"IN"},
				{name:"Indonesia",abbreviation:"ID"},
				{name:"Ireland",abbreviation:"IE"},
				{name:"Israel",abbreviation:"IL"},
				{name:"Italy",abbreviation:"IT"},
				{name:"Jamaica",abbreviation:"JM"},
				{name:"Japan",abbreviation:"JP"},
				{name:"Jordan",abbreviation:"JO"},
				{name:"Kazakstan",abbreviation:"KZ"},
				{name:"Kenya",abbreviation:"KE"},
				{name:"Kiribati",abbreviation:"KI"},
				{name:"South Korea",abbreviation:"KR"},
				{name:"Kuwait",abbreviation:"KW"},
				{name:"Kyrgyzstan",abbreviation:"KG"},
				{name:"Lao People's Democratic Republic",abbreviation:"LA"},
				{name:"Latvia",abbreviation:"LV"},
				{name:"Lebanon",abbreviation:"LB"},
				{name:"Lesotho",abbreviation:"LS"},
				{name:"Liechtenstein",abbreviation:"LI"},
				{name:"Lithuania",abbreviation:"LT"},
				{name:"Luxembourg",abbreviation:"LU"},
				{name:"Macau",abbreviation:"MO"},
				{name:"Madagascar",abbreviation:"MG"},
				{name:"Malawi",abbreviation:"MW"},
				{name:"Malaysia",abbreviation:"MY"},
				{name:"Maldives",abbreviation:"MV"},
				{name:"Mali",abbreviation:"ML"},
				{name:"Malta",abbreviation:"MT"},
				{name:"Marshall Islands",abbreviation:"MH"},
				{name:"Martinique",abbreviation:"MQ"},
				{name:"Mauritania",abbreviation:"MR"},
				{name:"Mauritius",abbreviation:"MU"},
				{name:"Mayotte",abbreviation:"YT"},
				{name:"Mexico",abbreviation:"MX"},
				{name:"Micronesia-Federated States Of",abbreviation:"FM"},
				{name:"Moldova-Republic Of",abbreviation:"MD"},
				{name:"Monaco",abbreviation:"MC"},
				{name:"Mongolia",abbreviation:"MN"},
				{name:"Montserrat",abbreviation:"MS"},
				{name:"Morocco",abbreviation:"MA"},
				{name:"Mozambique",abbreviation:"MZ"},
				{name:"Namibia",abbreviation:"NA"},
				{name:"Nauru",abbreviation:"NR"},
				{name:"Nepal",abbreviation:"NP"},
				{name:"Netherlands",abbreviation:"NL"},
				{name:"Netherlands Antilles",abbreviation:"AN"},
				{name:"New Caledonia",abbreviation:"NC"},
				{name:"New Zealand",abbreviation:"NZ"},
				{name:"Nicaragua",abbreviation:"NI"},
				{name:"Niger",abbreviation:"NE"},
				{name:"Nigeria",abbreviation:"NG"},
				{name:"Niue",abbreviation:"NU"},
				{name:"Norfolk Island",abbreviation:"NF"},
				{name:"Northern Mariana Islands",abbreviation:"MP"},
				{name:"Norway",abbreviation:"NO"},
				{name:"Oman",abbreviation:"OM"},
				{name:"Pakistan",abbreviation:"PK"},
				{name:"Palau",abbreviation:"PW"},
				{name:"Palestinian Territory-Occupied",abbreviation:"PS"},
				{name:"Panama",abbreviation:"PA"},
				{name:"Papua New Guinea",abbreviation:"PG"},
				{name:"Paraguay",abbreviation:"PY"},
				{name:"Peru",abbreviation:"PE"},
				{name:"Philippines",abbreviation:"PH"},
				{name:"Pitcairn",abbreviation:"PN"},
				{name:"Poland",abbreviation:"PL"},
				{name:"Portugal",abbreviation:"PT"},
				{name:"Puerto Rico",abbreviation:"PR"},
				{name:"Qatar",abbreviation:"QA"},
				{name:"RÃ©union",abbreviation:"RE"},
				{name:"Romania",abbreviation:"RO"},
				{name:"Russian Federation",abbreviation:"RU"},
				{name:"Rwanda",abbreviation:"RW"},
				{name:"Saint Helena",abbreviation:"SH"},
				{name:"Saint Kitts and Nevis",abbreviation:"KN"},
				{name:"Saint Lucia",abbreviation:"LC"},
				{name:"Saint Pierre and Miquelon",abbreviation:"PM"},
				{name:"Saint Vincent and The Grenadines",abbreviation:"VC"},
				{name:"Samoa",abbreviation:"WS"},
				{name:"San Marino",abbreviation:"SM"},
				{name:"Sao Tome and Principe",abbreviation:"ST"},
				{name:"Saudi Arabia",abbreviation:"SA"},
				{name:"Senegal",abbreviation:"SN"},
				{name:"Seychelles",abbreviation:"SC"},
				{name:"Singapore",abbreviation:"SG"},
				{name:"Slovakia",abbreviation:"SK"},
				{name:"Slovenia",abbreviation:"SI"},
				{name:"Solomon Islands",abbreviation:"SB"},
				{name:"Somalia",abbreviation:"SO"},
				{name:"South Africa",abbreviation:"ZA"},
				{name:"South Georgia & The So. Sandwich Is.",abbreviation:"GS"},
				{name:"Spain",abbreviation:"ES"},
				{name:"Sri Lanka",abbreviation:"LK"},
				{name:"Suriname",abbreviation:"SR"},
				{name:"Svalbard and Jan Mayen",abbreviation:"SJ"},
				{name:"Swaziland",abbreviation:"SZ"},
				{name:"Sweden",abbreviation:"SE"},
				{name:"Switzerland",abbreviation:"CH"},
				{name:"Taiwan",abbreviation:"TW"},
				{name:"Tajikistan",abbreviation:"TJ"},
				{name:"Tanzania- Republic Of",abbreviation:"TZ"},
				{name:"Thailand",abbreviation:"TH"},
				{name:"Togo",abbreviation:"TG"},
				{name:"Tokelau",abbreviation:"TK"},
				{name:"Tonga",abbreviation:"TO"},
				{name:"Trinidad and Tobago",abbreviation:"TT"},
				{name:"Tunisia",abbreviation:"TN"},
				{name:"Turkey",abbreviation:"TR"},
				{name:"Turkmenistan",abbreviation:"TM"},
				{name:"Turks and Caicos Islands",abbreviation:"TC"},
				{name:"Tuvalu",abbreviation:"TV"},
				{name:"Uganda",abbreviation:"UG"},
				{name:"Ukraine",abbreviation:"UA"},
				{name:"United Kingdom",abbreviation:"GB"},
				{name:"United States",abbreviation:"US"},
				{name:"United States Minor Outlying Islands",abbreviation:"UM"},
				{name:"Uruguay",abbreviation:"UY"},
				{name:"Uzbekistan",abbreviation:"UZ"},
				{name:"Vanuatu",abbreviation:"VU"},
				{name:"Venezuela",abbreviation:"VE"},
				{name:"Vietnam",abbreviation:"VN"},
				{name:"Virgin Islands-British",abbreviation:"VG"},
				{name:"Virgin Islands-U.S.",abbreviation:"VI"},
				{name:"Wallis and Futuna",abbreviation:"WF"},
				{name:"Western Sahara",abbreviation:"EH"},
				{name:"Yemen",abbreviation:"YE"},
				{name:"Zambia",abbreviation:"ZM"}
			]
		)>
		<!---
			// Disallowed
			// BA,Bosnia and Herzegovina
			// Burma, Cote d'lvoire (Ivory Coast)
			// Cuba, Dubai
			// Arab Emirates
			// ID,Indonesia
			// Iran
			// IQ Iraq
			// Liberia
			// Libya
			// MK,Macedonia-The Former Yugoslav Rep.
			// N. Korea
			// Serbia and Montenegro
			// Sierra Leone
			// Sudan
			// ZW,Zimbabwe
		--->
		<cfreturn countries>
	</cffunction>
	
	<cffunction name="statesAndProvincesQuery">
		<cfset statesAndProvinces = queryNew(
			"name,abbreviation",
			"varchar,varchar",
			[
				{name:"(Outside of US / Canada)",abbreviation:"OU"},
				{name:"(US Territory)",abbreviation:"TE"},
				{name:"Alaska",abbreviation:"AK"},
				{name:"Alabama",abbreviation:"AL"},
				{name:"Alberta",abbreviation:"AB"},
				{name:"Arizona",abbreviation:"AZ"},
				{name:"Arkansas",abbreviation:"AR"},
				{name:"British Columbia",abbreviation:"BC"},
				{name:"California",abbreviation:"CA"},
				{name:"Colorado",abbreviation:"CO"},
				{name:"Connecticut",abbreviation:"CT"},
				{name:"Delaware",abbreviation:"DE"},
				{name:"District Of Columbia",abbreviation:"DC"},
				{name:"Florida",abbreviation:"FL"},
				{name:"Georgia",abbreviation:"GA"},
				{name:"Hawaii",abbreviation:"HI"},
				{name:"Idaho",abbreviation:"ID"},
				{name:"Illinois",abbreviation:"IL"},
				{name:"Indiana",abbreviation:"IN"},
				{name:"Iowa",abbreviation:"IA"},
				{name:"Kansas",abbreviation:"KS"},
				{name:"Kentucky",abbreviation:"KY"},
				{name:"Louisiana",abbreviation:"LA"},
				{name:"Maine",abbreviation:"ME"},
				{name:"Manitoba",abbreviation:"MB"},
				{name:"Maryland",abbreviation:"MD"},
				{name:"Massachusetts",abbreviation:"MA"},
				{name:"Michigan",abbreviation:"MI"},
				{name:"Minnesota",abbreviation:"MN"},
				{name:"Mississippi",abbreviation:"MS"},
				{name:"Missouri",abbreviation:"MO"},
				{name:"Montana",abbreviation:"MT"},
				{name:"Nebraska",abbreviation:"NE"},
				{name:"Nevada",abbreviation:"NV"},
				{name:"New Brunswick",abbreviation:"NB"},
				{name:"New Hampshire",abbreviation:"NH"},
				{name:"New Jersey",abbreviation:"NJ"},
				{name:"New Mexico",abbreviation:"NM"},
				{name:"New York",abbreviation:"NY"},
				{name:"Newfoundland",abbreviation:"NF"},
				{name:"North Carolina",abbreviation:"NC"},
				{name:"North Dakota",abbreviation:"ND"},
				{name:"Nova Scotia",abbreviation:"NS"},
				{name:"Nunavut",abbreviation:"NT"},
				{name:"Nwt",abbreviation:"NT"},
				{name:"Ohio",abbreviation:"OH"},
				{name:"Oklahoma",abbreviation:"OK"},
				{name:"Ontario",abbreviation:"ON"},
				{name:"Oregon",abbreviation:"OR"},
				{name:"Pennsylvania",abbreviation:"PA"},
				{name:"Prince Edward Island",abbreviation:"PE"},
				{name:"Quebec",abbreviation:"QC"},
				{name:"Rhode Island",abbreviation:"RI"},
				{name:"Saskatchewan",abbreviation:"SK"},
				{name:"South Carolina",abbreviation:"SC"},
				{name:"South Dakota",abbreviation:"SD"},
				{name:"Tennessee",abbreviation:"TN"},
				{name:"Texas",abbreviation:"TX"},
				{name:"Utah",abbreviation:"UT"},
				{name:"Vermont",abbreviation:"VT"},
				{name:"Virginia",abbreviation:"VA"},
				{name:"Washington",abbreviation:"WA"},
				{name:"West Virginia",abbreviation:"WV"},
				{name:"Wisconsin",abbreviation:"WI"},
				{name:"Wyoming",abbreviation:"WY"},
				{name:"Yukon",abbreviation:"YT"},
				{name:"Armed Forces Africa",abbreviation:"AE"},
				{name:"Armed Forces Americas",abbreviation:"AA"},
				{name:"Armed Forces Canada",abbreviation:"AE"},
				{name:"Armed Forces Europe",abbreviation:"AE"},
				{name:"Armed Forces Middle East",abbreviation:"AE"},
				{name:"Armed Forces Pacific",abbreviation:"AP"}
			]
		)>
		<cfreturn statesAndProvinces>
	</cffunction>
	
</cfcomponent>