<cfoutput>
	<cfif qColumns.key neq 'PRI' AND right(column,2) NEQ 'at' AND right(column,2) NEQ 'by' AND column NEQ 'Siteid' AND column NEQ 'Sortorder' AND column NEQ 'Globalized' AND right(column,2) NEQ 'id'>
		<cfscript>
			modelVal = qModel[column];
			type = columns[column];
			html5type = 'text';

			if(isDate(modelVal)) {
				html5type = 'datetime-local';
			} else if(type eq 'text') {
				html5type = 'textarea';
			} else if(type eq 'int(1)') {
				html5type = 'boolean';
			} else if(isNumeric(modelVal)) {
				html5type = 'number';
			}
			label = ReReplace(rereplace(column,"(^[a-z])","\u\1"),"([A-Z])"," \1","all");
			label = ReReplace(replace(lcase(label),"_"," ","ALL"),"\b(\w)","\u\1","ALL");
		</cfscript>

		<cfif html5type eq 'textarea'>
			<div class="col-sm-12">
				<!--- Description --->
				##btextarea(
					objectName 		= 'my#nameVars['@ucaseSingular@']#',
					property 		= '#column#',
					label 		 	= '#label#',
			        style			= "height:60px;"
				)##
			</div>
		<cfelseif html5type eq 'boolean'>
			<div class="col-sm-6">
				##bcheckbox(
		            objectName	= 'my#nameVars['@ucaseSingular@']#',
		            property 	= "#column#",
		            help		= "If checked, #ReReplace(replace(lcase(column),"_"," ","ALL"),"\b(\w)","\u\1","ALL")# will be true",
		            label		= '#label#'
		        )##
	        </div>
		<cfelse>
			<div class="col-sm-6">
				##btextfield(
					objectName	= 'my#nameVars['@ucaseSingular@']#',
					property 	= '#column#',
					label		= '#label#',
					type 		=  '#html5type#'
				)##
			</div>
		</cfif>
	</cfif>
</cfoutput>
