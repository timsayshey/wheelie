<cfoutput>

<cfscript>
	optinCnt = 0;
	optoutCnt = 0;
	for(email in qEmails)
	{
		userEmail = email.email;
		if(!model("EmailOptout").findAll(where="email = '#userEmail#'").recordcount)
		{
			if(isValidEmail(email.email))
			{
				writeOutput("#email.email#<br>");
				optinCnt++;
			}		
		}
		else
		{
			optoutCnt++;
		}
	}
	for(inquiry in qInquiries)
	{
		if(isValidEmail(inquiry.email))
		{
			writeOutput("#inquiry.email#<br>");
			optinCnt++;
		}	
	}
</cfscript>
<br>
<br>

<strong>Total Opt-Ins: #optinCnt#</strong><br>
<strong>Total Opt-Outs: #optoutCnt#</strong>
	
</cfoutput>