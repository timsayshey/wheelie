<!---
<fusedoc fuse="Validation.cfc" language="ColdFusion" specification="2.0">
	<responsibilities>
		I am a ColdFusion Component that performs server-side form validation.

		Copyright 2006-2008 Ryan J. Heldt. All rights reserved.

		Validation.cfc is licensed under the Apache License, Version 2.0 (the "License");
		you may not use this file except in compliance with the License. You may obtain
		a copy of the License at:

			http://www.apache.org/licenses/LICENSE-2.0

		Unless required by applicable law or agreed to in writing, software distributed
		under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
		CONDITIONS OF ANY KIND, either express or implied. See the License for the specific
		language governing permissions and limitations under the License.

		If you use this component in a live site, I would love to know where! Please end
		me a quick note at rheldt@ryanheldt.com with the name of the site the URL.
	</responsibilities>
	<properties>
		<history author="Ryan J. Heldt" date="2008-10-08" comments="Substantially added to the list of built-in MIME types."
			email="rheldt@ryanheldt.com" role="architect" type="modify" />
		<history author="Ryan J. Heldt" date="2007-10-07" comments="Added credit card validation."
			email="rheldt@ryanheldt.com" role="architect" type="modify" />
		<history author="Ryan J. Heldt" date="2007-09-30" comments="Clean up and small bug fixes."
			email="rheldt@ryanheldt.com" role="architect" type="modify" />
		<history author="Ryan J. Heldt" date="2007-09-23" comments="Added basic file upload and validation."
			email="rheldt@ryanheldt.com" role="architect" type="modify" />
		<history author="Ryan J. Heldt" date="2007-07-18" comments="Rewrite, addition of SSN validation and smarter postal code validation"
			email="rheldt@ryanheldt.com" role="architect" type="modify" />
		<history author="Ryan J. Heldt" date="2007-06-08" comments="Initial public release."
			email="rheldt@ryanheldt.com" role="architect" type="modify" />
		<history author="Ryan J. Heldt" date="2007-05-27" comments="Added init() constructor."
			email="rheldt@ryanheldt.com" role="architect" type="modify" />
		<history author="Ryan J. Heldt" date="2006-11-23" comments="Creation of initial cfc."
			email="rheldt@ryanheldt.com" role="architect" type="create" />
		<property name="version" value="1.00" />
		<property name="copyright" value="Copyright 2006-2008 Ryan J. Heldt." />
	</properties>
</fusedoc>
--->

<cfcomponent displayname="Validation" hint="ColdFusion component that performs server-side form validation." output="true">

	<!--- ---------- Properties ---------- --->

	<cfproperty name="fields" type="struct" />
	<cfproperty name="directories" type="struct" />
	<cfproperty name="files" type="struct" />
	<cfproperty name="errors" type="numeric" />
	<cfproperty name="messages" type="struct" />
	<cfproperty name="mimeTypes" type="array" />

	<!--- ---------- Constructors ---------- --->

	<cffunction name="init" access="public" output="false" returntype="Validation">
		<cfscript>
			_fields = structNew();
			_directories = structNew();
			_files = structNew();
			_uploadedFiles = structNew();
			_errors = 0;
			_messages = structNew();
			_cardTypes = structNew();
			_mimeTypes = arrayNew(1);
		</cfscript>
		<cfreturn this />
	</cffunction>

	<!--- ---------- Accessors and Mutators ---------- --->

	<cffunction name="getFields" access="public" output="false" returntype="struct">
		<cfreturn _fields />
	</cffunction>

	<cffunction name="setFields" access="public" output="false" >
		<cfargument name="fields" type="struct" required="true" />
		<cfset _fields = arguments.fields />
		<cfreturn />
	</cffunction>

	<cffunction name="getDirectories" access="public" output="false" returntype="struct">
		<cfreturn _directories />
	</cffunction>

	<cffunction name="setDirectories" access="public" output="false" >
		<cfargument name="directories" type="struct" required="true" />
		<cfset _directories = arguments.directories />
		<cfreturn />
	</cffunction>

	<cffunction name="getFiles" access="public" output="false" returntype="struct">
		<cfreturn _files />
	</cffunction>

	<cffunction name="getErrorCount" access="public" output="false" returntype="numeric">
		<cfreturn _errors />
	</cffunction>

	<cffunction name="getMessages" access="public" output="false" returntype="struct">
		<cfreturn _messages />
	</cffunction>

	<cffunction name="getMessage" access="public" output="false" returntype="string">
		<cfargument name="field" type="string" required="true" />
		<cfif structKeyExists(_messages,field)>
			<cfreturn _messages[field] />
		<cfelse>
			<cfreturn "" />
		</cfif>
	</cffunction>

	<cffunction name="getCardType" access="public" output="false" returntype="string">
		<cfargument name="field" type="string" required="true" />
		<cfif structKeyExists(_cardTypes,field)>
			<cfreturn _cardTypes[field] />
		<cfelse>
			<cfreturn "" />
		</cfif>
	</cffunction>

	<cffunction name="getMimeTypes" access="public" output="false" returntype="array">
		<cfreturn _mimeTypes />
	</cffunction>

	<!--- ---------- Public Methods ---------- --->

	<cffunction name="validator" access="public" output="true" >
		<cfset var rr = 0 />
		<cfloop list="#structKeyList(_fields)#" index="rr">
			<cfif lCase(left(rr,9)) is "validate_">
				<cfswitch expression="#lCase(rr)#">
					<cfcase value="validate_require">
						<!--- Required Fields --->
						<cfset validateRequired(_fields[rr]) />
					</cfcase>
					<cfcase value="validate_integer">
						<!--- Validate Integers --->
						<cfset validateInteger(_fields[rr]) />
					</cfcase>
					<cfcase value="validate_numeric">
						<!--- Validate Numeric --->
						<cfset validateNumeric(_fields[rr]) />
					</cfcase>
					<cfcase value="validate_email">
						<!--- Validate E-mail Addresses --->
						<cfset validateEmail(_fields[rr]) />
					</cfcase>
					<cfcase value="validate_url">
						<!--- Validate URLs --->
						<cfset validateURL(_fields[rr]) />
					</cfcase>
					<cfcase value="validate_ip">
						<!--- Validate IP Addresses --->
						<cfset validateIP(_fields[rr]) />
					</cfcase>
					<cfcase value="validate_ssn">
						<!--- Validate Socical Security Number (United States) nnn-nn-nnnn --->
						<cfset validateSSN(_fields[rr]) />
					</cfcase>
					<cfcase value="validate_postal">
						<!--- Validate Postal Code (United States and Canada) nnnnn or nnnnn-nnnn or ana-nan --->
						<cfset validatePostal(_fields[rr]) />
					</cfcase>
					<cfcase value="validate_dateus">
						<!--- Validate Date (United States) mm/dd/yyyy --->
						<cfset validateDateUS(_fields[rr]) />
					</cfcase>
					<cfcase value="validate_dateeu">
						<!--- Validate Date (Europe) dd/mm/yyyy --->
						<cfset validateDateEU(_fields[rr]) />
					</cfcase>
					<cfcase value="validate_time">
						<!--- Validate Time hh:mm:ss tt --->
						<cfset validateDateEU(_fields[rr]) />
					</cfcase>
					<cfcase value="validate_phoneus">
						<!--- Validate Phone Number (United States) nnn-nnn-nnnn --->
						<cfset validatePhoneUS(_fields[rr]) />
					</cfcase>
					<cfcase value="validate_currencyus">
						<!--- Validate Currency (United States) Allows optional "$", optional "-" or "()" but not both, optional cents, and optional commas separating thousands --->
						<cfset validateCurrencyUS(_fields[rr]) />
					</cfcase>
					<cfcase value="validate_creditcard">
						<!--- Validate Credit Card using Luhn Algorithm --->
						<cfset validateCreditCard(_fields[rr]) />
					</cfcase>
					<cfcase value="validate_password">
						<!--- Validate two fields to make sure they match. Comparison is case-sensitive --->
						<cfset validatePassword(_fields[rr]) />
					</cfcase>
					<cfcase value="validate_file">
						<!--- Upload files and validate their MIME types --->
						<cfset loadMimeTypes() />
						<cfset validateFile(_fields[rr]) />
					</cfcase>
				</cfswitch>
			</cfif>
		</cfloop>
		<cfif val(_errors)>
			<!--- If there were any validation errors, delete all the upload files --->
			<cfset cleanupFiles() />
		</cfif>
		<cfreturn />
	</cffunction>

	<!--- ---------- Package Methods ---------- --->

	<cffunction name="isValidRequired"  access="private" output="false">
		<cfargument name="checkValue" type="string" required="true" />
		<cfif not (structKeyExists(arguments,"checkValue") and len(arguments.checkValue))>
			<cfreturn false />
		</cfif>			
		<cfreturn true />
	</cffunction>

	<cffunction name="isValidInteger"  access="private" output="false">
		<cfargument name="checkValue" type="string" required="true" />		
		<cfif structKeyExists(arguments,"checkValue") and len(arguments.checkValue) and not reFind("^-?\d+$",arguments.checkValue)>
			<cfreturn false />
		</cfif>			
		<cfreturn true />
	</cffunction>

	<cffunction name="isValidNumeric"  access="private" output="false">
		<cfargument name="checkValue" type="string" required="true" />
		<cfif structKeyExists(arguments,"checkValue") and len(arguments.checkValue) and not isNumeric(arguments.checkValue)>
			<cfreturn false />
		</cfif>			
		<cfreturn true />
	</cffunction>

	<cffunction name="isValidEmail"  access="private" output="false">
		<cfargument name="checkValue" type="string" required="true" />
		<cfif structKeyExists(arguments,"checkValue") and len(arguments.checkValue) and not reFind("^[a-zA-Z][\w\.-]*[a-zA-Z0-9]@[a-zA-Z0-9][\w\.-]*[a-zA-Z0-9]\.[a-zA-Z][a-zA-Z\.]*[a-zA-Z]$",arguments.checkValue)>
			<cfreturn false />
		</cfif>			
		<cfreturn true />
	</cffunction>

	<cffunction name="isValidURL"  access="private" output="false">
		<cfargument name="checkValue" type="string" required="true" />
		<cfif structKeyExists(arguments,"checkValue") and len(arguments.checkValue) and not reFind("https?://([-\w\.]+)+(:\d+)?(/([\w/_\.]*(\?\S+)?)?)?",arguments.checkValue)>
			<cfreturn false />
		</cfif>			
		<cfreturn true />
	</cffunction>

	<cffunction name="isValidIP"  access="private" output="false">
		<cfargument name="checkValue" type="string" required="true" />
		<cfif structKeyExists(arguments,"checkValue") and len(arguments.checkValue) and not reFind("\b(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b",arguments.checkValue)>
			<cfreturn false />
		</cfif>			
		<cfreturn true />
	</cffunction>

	<cffunction name="isValidSSN"  access="private" output="false">
		<cfargument name="checkValue" type="string" required="true" />
		<cfif structKeyExists(arguments,"checkValue") and len(arguments.checkValue) and not reFind("^\d{3}-\d{2}-\d{4}$",arguments.checkValue)>
			<cfreturn false />
		</cfif>			
		<cfreturn true />
	</cffunction>

	<cffunction name="isValidPostal"  access="private" output="false">
		<cfargument name="checkValue" type="string" required="true" />
		<cfif structKeyExists(arguments,"checkValue") and len(arguments.checkValue) and not reFind("^((\d{5}-\d{4})|(\d{5})|([A-Z]\d[A-Z]\s\d[A-Z]\d))$",arguments.checkValue)>
			<cfreturn false />
		</cfif>			
		<cfreturn true />
	</cffunction>

	<cffunction name="isValidDateUS"  access="private" output="false">
		<cfargument name="checkValue" type="string" required="true" />
		<cfif structKeyExists(arguments,"checkValue") and len(arguments.checkValue) and not (reFind("(0[1-9]|1[012])[- /.](0[1-9]|[12][0-9]|3[01])[- /.](19|20)\d\d",arguments.checkValue) and isDate(arguments.checkValue))>
			<cfreturn false />
		</cfif>			
		<cfreturn true />
	</cffunction>

	<cffunction name="isValidDateEU"  access="private" output="false">
		<cfargument name="checkValue" type="string" required="true" />
		<cfif structKeyExists(arguments,"checkValue") and len(arguments.checkValue) and not (reFind("(0[1-9]|[12][0-9]|3[01])[- /.](0[1-9]|1[012])[- /.](19|20)\d\d",arguments.checkValue) and isDate(arguments.checkValue))>
			<cfreturn false />
		</cfif>			
		<cfreturn true />
	</cffunction>

	<cffunction name="isValidTime"  access="private" output="false">
		<cfargument name="checkValue" type="string" required="true" />
		<cfif structKeyExists(arguments,"checkValue") and len(arguments.checkValue) and not (reFind("^((0?[1-9]|1[012])(:[0-5]\d){0,2}(\ [AP]M))$|^([01]\d|2[0-3])",uCase(arguments.checkValue)) and isDate(arguments.checkValue))>
			<cfreturn false />
		</cfif>			
		<cfreturn true />
	</cffunction>

	<cffunction name="isValidPhoneUS"  access="private" output="false">
		<cfargument name="checkValue" type="string" required="true" />
		<cfif structKeyExists(arguments,"checkValue") and len(arguments.checkValue) and not reFind("^[2-9]\d{2}-\d{3}-\d{4}$",arguments.checkValue)>
			<cfreturn false />
		</cfif>			
		<cfreturn true />
	</cffunction>

	<cffunction name="isValidCurrencyUS"  access="private" output="false">
		<cfargument name="checkValue" type="string" required="true" />
		<cfif structKeyExists(arguments,"checkValue") and len(arguments.checkValue) and not reFind("^\$?\-?([1-9]{1}[0-9]{0,2}(\,\d{3})*(\.\d{0,2})?|[1-9]{1}\d{0,}(\.\d{0,2})?|0(\.\d{0,2})?|(\.\d{1,2}))$|^\-?\$?([1-9]{1}\d{0,2}(\,\d{3})*(\.\d{0,2})?|[1-9]{1}\d{0,}(\.\d{0,2})?|0(\.\d{0,2})?|(\.\d{1,2}))$|^\(\$?([1-9]{1}\d{0,2}(\,\d{3})*(\.\d{0,2})?|[1-9]{1}\d{0,}(\.\d{0,2})?|0(\.\d{0,2})?|(\.\d{1,2}))\)$",arguments.checkValue)>
			<cfreturn false />
		</cfif>			
		<cfreturn true />
	</cffunction>

	<cffunction name="isValidCreditCard"  access="private" output="false">
		<cfargument name="checkValue" type="string" required="true" />
			<!--- Based on isCreditCard() by Nick de Voil (cflib.org/udf.cfm?id=49) --->
			<cfset var strCardNumber = "" />
			<cfset var strProcessedNumber = "" />
			<cfset var intCalculatedNumber = 0 />
			<cfset var isValid = false />
			<cfset var rr = 0 />
			<cfset var i = 0 />
			
				<cfscript>
					// Take out spaces and dashes. Flip card number around for processing
					strCardNumber = replace(arguments.checkValue," ","","all");
					strCardNumber = replace(strCardNumber,"-","","all");
					strCardNumber = reverse(strCardNumber);
					_cardTypes[arguments.checkValue] = "Unknown";

					// Double every other digit
					if (isNumeric(strCardNumber) and len(strCardNumber) gt 12) {
						for(i = 1; i lte len(strCardNumber); i = i + 1) {
							if(i mod 2 is 0) {
								strProcessedNumber = strProcessedNumber & mid(strCardNumber,i,1) * 2;
							} else {
								strProcessedNumber = strProcessedNumber & mid(strCardNumber,i,1);
							}
						}

						// Sum processed digits
						for(i = 1; i lte len(strProcessedNumber); i = i + 1) {
							intCalculatedNumber = intCalculatedNumber + val(mid(strProcessedNumber,i,1));
						}

						// See if calculated number passed mod 10 test and attempt to determine card type
						if(intCalculatedNumber neq 0 and intCalculatedNumber mod 10 is 0) {
							isValid = true;
							strCardNumber = reverse(strCardNumber);
							if ((len(strCardNumber) eq 15) and (((left(strCardNumber,2) is "34")) or ((left(strCardNumber,2) is "37")))) {
								_cardTypes[arguments.checkValue] = "Amex";
							}
							if ((len(strCardNumber) eq 14) and (((left(strCardNumber,3) gte 300) and (left(strCardNumber,3) lte 305)) or (left(strCardNumber,2) is "36") or (left(strCardNumber, 2) is "38"))){
								_cardTypes[arguments.checkValue] = "Diners";
							}
							if ((len(strCardNumber) eq 16) and (left(strCardNumber,4) is "6011")) {
								_cardTypes[arguments.checkValue] = "Discover";
							}
							if ((len(strCardNumber) eq 16) and (left(strCardNumber,2) gte 51) and (left(strCardNumber,2) lte 55)) {
								_cardTypes[arguments.checkValue] = "MasterCard";
							}
							if (((len(strCardNumber) eq 13) or (len(strCardNumber) eq 16)) and (Left(strCardNumber,1) is "4")) {
								_cardTypes[arguments.checkValue] = "Visa";
							}
						}
					}

					// Not a valid card number
					if (not isValid) {
						return false;
					}
				</cfscript>
				
		<cfreturn true />
	</cffunction>

	<cffunction name="isValidPassword"  access="private" output="false">
		<cfargument name="checkValue" type="string" required="true" />
		<cfif structKeyExists(arguments,"checkValue") and isDefined("#listGetAt(rr,2,"|")#") and compare(arguments.checkValue,_fields[listGetAt(rr,2,"|")]) neq 0>
			<cfreturn false />
		</cfif>			
		<cfreturn true />
	</cffunction>

	<cffunction name="isValidFile"  access="private" output="true">
		<cfargument name="checkValue" type="string" required="true" />
		<cfset var rr = 0 />
		<cfset var strCurrentMimeType = "" />
		<cfset var strCurrentFileExt = "" />
		<cfset var aryValidFileExts = arrayNew(1) />
		<cfset var strFilename = "" />
		<cfset var blnValidFile = false />
		
			<cftry>
				<!--- Perform the upload --->
				<cfif structKeyExists(_directories,"#arguments.checkValue#")>
					<cfif len(evaluate("#arguments.checkValue#"))>
						<cffile action="upload" filefield="#arguments.checkValue#" destination="#_directories[arguments.checkValue]#" nameconflict="makeunique" />
						<cfset strCurrentMimeType = "#cffile.contentType#/#cffile.contentSubType#" />
						<cfset strCurrentFileExt = "" />
						<cfset aryValidFileExts = arrayNew(1) />
						<cfset blnValidFile = false />

						<!--- Determine file ext from MIME type --->
						<cfloop from="1" to="#arrayLen(_mimeTypes)#" index="i">
							<cfparam name="_mimeTypes[i]" default="0,0" />
							<cfif listGetAt(_mimeTypes[i],2) is strCurrentMimeType>
								<cfset strCurrentFileExt = "." & listGetAt(_mimeTypes[i],1) />
							</cfif>
						</cfloop>

						<!--- Look what the server returned if unable to determine from MIME type --->
						<cfif not len(strCurrentFileExt)>
							<cfset strCurrentFileExt = "." & cffile.serverFileExt />
						</cfif>

						<!--- Rename the file and register in case we have to clean house--->
						<cfset strFilename = "#generateFilename(cffile.clientFilename)##strCurrentFileExt#" />
						<cffile action="rename" source="#cffile.serverDirectory#/#cffile.serverFile#" destination="#strFilename#" />
						<cfset structInsert(_files,arguments.checkValue,strFilename)>
						<cfset structInsert(_uploadedFiles,arguments.checkValue,#cffile.serverDirectory#&"/"&strFilename)>

						<!--- Validate file type --->
						<cfif listGetAt(rr,2,"|") neq "*">
							<cfset aryValidFileExts = listToArray(listGetAt(rr,2,"|")) />
							<cfloop from="1" to="#arrayLen(aryValidFileExts)#" index="i">
								<cfif replaceNoCase(strCurrentFileExt,".","","all") is aryValidFileExts[i]>
									<cfset blnValidFile = true />
								</cfif>
							</cfloop>
						</cfif>

						<cfif not blnValidFile>
							<cfreturn false>
						</cfif>
					</cfif>
				<cfelse>
					<!--- Developer didn't tell us the upload directory --->
					<cfreturn false>
				</cfif>

				<cfcatch>
					<cfreturn false>
				</cfcatch>
			</cftry>
			
		<cfreturn true />
	</cffunction>

	<cffunction name="generateFilename" returntype="string" access="private" output="false">
		<cfargument name="originalFilename" type="string" required="true" />
		<cfset var rr = 0 />
		<cfset var strReturn="" />
		<cfset var intCurrentCharacter=0 />
		<cfset arguments.originalFilename=trim(lCase(arguments.originalFilename)) />
		<cfloop index="rr" from="1" to="#len(arguments.originalFilename)#">
			<cfset intCurrentCharacter=asc(mid(arguments.originalFilename,rr,1)) />
			<cfif intCurrentCharacter is 32>
				<!--- Space --->
				<cfset strReturn=strReturn&"_" />
			<cfelseif intCurrentCharacter gte 48 and intCurrentCharacter lte 57>
				<!--- Numbers 0-9 --->
				<cfset strReturn=strReturn&chr(intCurrentCharacter) />
			<cfelseif (intCurrentCharacter gte 97 and intCurrentCharacter lte 122)>
				<!--- Letters a-z --->
				<cfset strReturn=strReturn&chr(intCurrentCharacter) />
			<cfelse>
				<!--- Skip Everything Else--->
			</cfif>
		</cfloop>
		<cfif len(strReturn)>
			<cfset strReturn = lCase(left(strReturn,35)) & "_" />
		<cfelse>
			<cfset strReturn = "untitled_" />
		</cfif>
		<cfreturn strReturn & dateFormat(now(),"yyyymmdd") & timeFormat(now(),"HHmmss") />
	</cffunction>

	<cffunction name="cleanupFiles"  access="private" output="false">
		<cfset var rr = "" />
		<cfloop collection="#_uploadedFiles#" item="rr">
			<cfif fileExists(structFind(_uploadedFiles,rr))>
				<cffile action="delete" file="#structFind(_uploadedFiles,rr)#" />
			</cfif>
		</cfloop>
	</cffunction>

	<cffunction name="loadMimeTypes"  access="private" output="false">
		<cfscript>
			// Microsoft Office Formats (Office 2003 and Prior)
			_mimeTypes[1]="doc,application/msword";
			_mimeTypes[2]="doc,application/vnd.ms-word";
			_mimeTypes[3]="mdb,application/msaccess";
			_mimeTypes[4]="mdb,application/vnd.ms-access";
			_mimeTypes[5]="mpp,application/msproject";
			_mimeTypes[6]="mpp,application/vnd.ms-project";
			_mimeTypes[7]="one,application/msonenote";
			_mimeTypes[8]="one,application/vnd.ms-onenote";
			_mimeTypes[9]="ppt,application/mspowerpoint";
			_mimeTypes[10]="ppt,application/vnd.ms-powerpoint";
			_mimeTypes[11]="pub,application/mspublisher";
			_mimeTypes[12]="pub,application/vnd.ms-publisher";
			_mimeTypes[13]="xls,application/msexcel";
			_mimeTypes[14]="xls,application/vnd.ms-excel";

			// Microsoft Office Formats (Office 2007)
			_mimeTypes[15]="docx,application/vnd.openxmlformats-officedocument.wordprocessingml.document";
			_mimeTypes[16]="pptx,application/vnd.openxmlformats-officedocument.presentationml.presentation";
			_mimeTypes[17]="xlsx,application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";

			// Other Document Formats
			_mimeTypes[18]="csv,text/csv";
			_mimeTypes[19]="csv,text/comma-seperated-values";
			_mimeTypes[20]="htm,text/html";
			_mimeTypes[21]="pdf,application/pdf";
			_mimeTypes[22]="rtf,application/rtf";
			_mimeTypes[23]="rtf,text/rtf";
			_mimeTypes[24]="txt,text/plain";
			_mimeTypes[25]="xml,text/xml";

			// Bitmap Image Formats
			_mimeTypes[26]="bmp,image/bmp";
			_mimeTypes[27]="gif,image/gif";
			_mimeTypes[28]="jpg,image/jpeg";
			_mimeTypes[29]="jpg,image/pjpeg";
			_mimeTypes[30]="png,image/png";
			_mimeTypes[31]="png,image/x-png";
			_mimeTypes[32]="tif,image/tiff";

			// Vector Image Formats
			_mimeTypes[33]="ai,application/postscript";
			_mimeTypes[34]="swf,application/x-shockwave-flash";
			_mimeTypes[35]="svg,image/svg+xml";

			// Video Formats
			_mimeTypes[36]="avi,video/x-msvideo";
			_mimeTypes[37]="mov,video/quicktime";
			_mimeTypes[38]="mpg,video/mpeg";
			_mimeTypes[39]="wmv,video/x-ms-wmv";

			// Audio Formats
			_mimeTypes[40]="au,audio/basic";
			_mimeTypes[41]="mid,audio/midi";
			_mimeTypes[42]="mp3,audio/mpeg";
			_mimeTypes[43]="ogg,application/ogg";
			_mimeTypes[44]="wav,audio/x-wav";

			// Other Formats
			_mimeTypes[45]="zip,application/zip";
		</cfscript>
		<cfreturn />
	</cffunction>

</cfcomponent>