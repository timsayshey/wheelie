<cfoutput>
	<cfif !isNull(params.startDate) AND IsDate(params.startDate)>
		<cfset startDate = params.startDate>
	<cfelse>
		<cfset startDate = DateAdd("D", -7, now())>
	</cfif>
	
	<cfif !isNull(params.endDate) AND IsDate(params.endDate)>
		<cfset endDate = params.endDate>
	<cfelse>
		<cfset endDate = now()>
	</cfif>
	<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>Task Update</title>
	
	<cfinclude template="/models/services/global/includes/emailcss.cfm">
	
	</head>
	<body style="background:##f6f4f5">
	<div class="block"> 
		<!-- Start of preheader --><!-- End of preheader --> 
	</div>
	<div class="block"> 
		<!-- start of header -->
		<table width="100%" bgcolor="##f6f4f5" cellpadding="0" cellspacing="0" border="0" id="backgroundTable" st-sortable="header">
			<tbody>
				<tr>
					<td><table width="580"  bgcolor="##efefef" cellpadding="0" cellspacing="0" border="0" align="center" class="devicewidth" hlitebg="edit" shadow="edit">
							<tbody>
								<tr>
									<td><!-- logo -->
										
										<table width="280" cellpadding="0" cellspacing="0" border="0" align="left" class="devicewidth">
											<tbody>
												<tr>
													<td valign="middle" width="270" style="padding: 10px 0 10px 20px;" class="logo"><div class="imgpop"> <a href="##"><img src="http://#request.site.domain#/assets/css/front/logo.png" alt="logo" border="0" style="display:block; border:none; outline:none; text-decoration:none;" width="100" height="35" st-image="edit" class="logo"></a> </div></td>
												</tr>
											</tbody>
										</table>
										<table width="280" cellpadding="0" cellspacing="0" border="0" align="right" class="devicewidth">
											<tbody>
												<tr>
													<td width="270" valign="middle" style="font-family: Helvetica, Arial, sans-serif;font-size: 14px; color: ##999;line-height: 24px; padding-top: 15px; text-align:right; font-weight:bold;" align="right" class="menu" st-content="menu"> #session.user.fullname# </td>
													<td width="20"></td>
												</tr>
											</tbody>
										</table>
										
										<!-- End of logo --> 
										<!-- menu --><!-- End of Menu --></td>
								</tr>
							</tbody>
						</table></td>
				</tr>
			</tbody>
		</table>
		<!-- end of header --> 
	</div>
	<div class="block"> 
		<!-- image + text --></div>
	<div class="block"> 
		<!-- start textbox-with-title --><!-- end of textbox-with-title --> 
	</div>
	<div class="block"> 
		<!-- start of left image --><!-- end of left image --> 
	</div>
	<div class="block"> 
		<!-- start of left image --><!-- end of left image --> 
	</div>
	<div class="block"> 
		<!-- fulltext --><!-- end of fulltext --> 
	</div>
	<div class="block"> 
		<!-- Start of 2-columns --><!-- End of 2-columns --> 
	</div>
	<div class="block"> 
		<!-- 3-columns --><!-- end of 3-columns --> 
	</div>
	<div class="block"> 
		<!-- Full + text -->
		<table width="100%" bgcolor="##f6f4f5" cellpadding="0" cellspacing="0" border="0" id="backgroundTable" st-sortable="fullimage">
			<tbody>
				<tr>
					<td><table bgcolor="##ffffff" width="580" align="center" cellspacing="0" cellpadding="0" border="0" class="devicewidth" modulebg="edit">
							<tbody>
								<tr>
									<td width="100%" height="20"></td>
								</tr>
								<tr>
									<td><table width="540" align="center" cellspacing="0" cellpadding="0" border="0" class="devicewidthinner">
											<tbody>
												<!-- title -->
												<tr>
													<td height="60" style="font-family: Helvetica, arial, sans-serif; font-size: 18px; color: ##333333; text-align:left;line-height: 20px;" st-title="rightimage-title"><h1 style="color:##444; text-align:center; font-family:Arial, sans-serif;">Weekly Review</h1>
														<table border="0" cellpadding="0" cellspacing="0" align="center">
															<tr>
																<th width="219" align="left" valign="top" style="padding:10px;font-family: Helvetica, arial, sans-serif;"> <div style="font-size:.85em;color:##aaa;font-family: Helvetica, arial, sans-serif; ">FROM:</div>
#DateFormat(startDate,"MMMM D, YYYY")# 																	</th>
																<th width="294" valign="top" align="left" style="padding:10px; padding-left:70px; border-left:1px solid ##eee;font-family: Helvetica, arial, sans-serif; "> 
<div style="font-size:.85em;color:##aaa;font-family: Helvetica, arial, sans-serif;">TO:</div>
#DateFormat(endDate,"MMMM D, YYYY")# 																	</th>
															</tr>
														</table></td>
												</tr>
												<!-- end of title --> 
												<!-- Spacing -->
												<tr>
													<td width="100%" height="10"></td>
												</tr>
												<!-- Spacing --> 
												<!-- content -->
												<tr>
													<td style="font-family: Helvetica, arial, sans-serif; font-size: 13px; color: ##666666; text-align:left;line-height: 24px;" st-content="rightimage-paragraph"><table width="100%" border="0" cellspacing="0" cellpadding="0" style="color:##888;font:13px 'Helvetica Neue',Arial,sans-serif;line-height:1.6">
															<thead>
																<tr>
																	<th align="left" style="padding:.5em; background-color:##ddd;">&nbsp;</th>
																	<th align="left" style="padding:.5em; background-color:##ddd;">Task</th>
																	<th align="left" style="padding:.5em; background-color:##ddd;">Date Completed</th>
																</tr>
															</thead>
															<tbody>
																<cfset rowcount = 1>
																<cfloop query="todos">
																	<cfif isDate(todos.isDone) AND isDateWithin(startDate,endDate,todos.isDone)>
																		<cfset rowcount++>
																		<cfif rowcount mod 2>
																			<cfset rowColor = "##fff">
																			<cfelse>
																			<cfset rowColor = "##efefef">
																		</cfif>
																		<tr>
																			<td style="padding:.5em; background-color:#rowColor#;"><img src="http://#request.site.domain#/assets/img/checkmark_icon.png" width="20" height="20"></td>
																			<td style="padding:.5em; background-color:#rowColor#;"><strong>#todos.name#</strong><br>
#todos.description# 																				</td>
																			<td style="padding:.5em; background-color:#rowColor#;">#DateFormat(todos.isDone,"MMMM D, YYYY")# </td>
																		</tr>
																	</cfif>
																</cfloop>
															</tbody>
														</table></td>
												</tr>
												<!-- end of content --> 
												<!-- Spacing -->
												<tr>
													<td width="100%" height="10"></td>
												</tr>
												<!-- button -->
												<tr>
													<td></td>
												</tr>
												<!-- /button --> 
												<!-- Spacing -->
												<tr>
													<td width="100%" height="20"></td>
												</tr>
												<!-- Spacing -->
											</tbody>
										</table></td>
								</tr>
							</tbody>
						</table></td>
				</tr>
			</tbody>
		</table>
	</div>
	</body>
	</html>
</cfoutput>