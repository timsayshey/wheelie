<cfprocessingdirective suppresswhitespace="yes">
<cfsetting enablecfoutputonly="yes">

<!---
====================================================
Name            : dbtree, v3.12
Author          : MEGALINGO, http://www.megalingo.com, Roger Grossglauser
Last Update     : November 10, 2008
====================================================
--->
<cfparam name="Attributes.instanceName" default="">
<cfparam name="Attributes.query" default="">
<cfparam name="Attributes.datasource" default="">
<cfparam name="Attributes.username" default="">
<cfparam name="Attributes.password" default="">
<cfparam name="Attributes.table" default="">
<cfparam name="Attributes.action" default="get">
<cfparam name="Attributes.type" default="list">
<cfparam name="Attributes.id" default="">
<cfparam name="Attributes.parent" default="">
<cfparam name="Attributes.contentfield" default="">
<cfparam name="Attributes.titlefield" default="">
<cfparam name="Attributes.targetfield" default="">
<cfparam name="Attributes.url_type" default="">
<cfparam name="Attributes.url" default="">
<cfparam name="Attributes.url_param" default="">
<cfparam name="Attributes.url_suffix" default="">
<cfparam name="Attributes.sort" default="sortorder ASC">
<cfparam name="Attributes.editpage" default="">
<cfparam name="Attributes.node" default="">
<cfparam name="Attributes.nodeto" default="">
<cfparam name="Attributes.levels" default="">
<cfparam name="Attributes.btn_addroot" default="">
<cfparam name="Attributes.btn_moveroot" default="">
<cfparam name="Attributes.btn_add" default="">
<cfparam name="Attributes.btn_edit" default="">
<cfparam name="Attributes.btn_delete" default="">
<cfparam name="Attributes.btn_up" default="">
<cfparam name="Attributes.btn_down" default="">
<cfparam name="Attributes.formfields" default="">
<cfparam name="Attributes.rootnode" default="0" type="numeric">
<cfparam name="Attributes.current" default="">
<cfparam name="Attributes.expandcurrent" default="false" type="boolean">
<cfparam name="Attributes.linkparent" default="false" type="boolean">
<cfparam name="Attributes.size" default="0" type="numeric">
<cfparam name="Attributes.multiple" default="true" type="boolean">
<cfparam name="Attributes.jump" default="false" type="boolean">
<cfparam name="Attributes.jumptarget" default="parent">
<cfparam name="Attributes.timeout" default="0" type="numeric">
<cfparam name="Attributes.styled" default="true" type="boolean">
<cfparam name="Attributes.color" default="000">
<cfparam name="Attributes.fontfamily" default="Arial">
<cfparam name="Attributes.fontsize" default="13px">
<cfparam name="Attributes.fontstyle" default="normal">
<cfparam name="Attributes.fontweight" default="normal">
<cfparam name="Attributes.imagewidth" default="20px">
<cfparam name="Attributes.imageheight" default="20px">
<cfparam name="Attributes.item" default="bullet.gif">
<cfparam name="Attributes.folderopen" default="minus.gif">
<cfparam name="Attributes.folderclosed" default="plus.gif">
<cfparam name="Attributes.tipcolor" default="000">
<cfparam name="Attributes.tipbgcolor" default="EEE">
<cfparam name="Attributes.contextlinkcolor" default="000">
<cfparam name="Attributes.contextbgcolor" default="EEE">
<cfparam name="Attributes.contextlinkcolor_over" default="EEE">
<cfparam name="Attributes.contextbgcolor_over" default="000">
<cfparam name="Attributes.class" default="">

<cfif isdefined("url.instanceName")>
	<cfset Attributes.instanceName=#url.instanceName#>
	<cfset Attributes.id=#url.id#>
	<cfset Attributes.parent=#url.parent#>
	<cfset Attributes.action=#url.action#>
	<cfset Attributes.type=#url.type#>
	<cfif isdefined("url.rootnode")>
		<cfset Attributes.rootnode=#url.rootnode#>
	</cfif>
	<cfset Attributes.node=#url.node#>
	<cfif isdefined("url.nodeto")>
		<cfset Attributes.nodeto=#url.nodeto#>
	</cfif>
	<cfif isdefined("url.datasource")>
		<cfset Attributes.datasource=#url.datasource#>
	</cfif>
	<cfif isdefined("url.username")>
		<cfset Attributes.username=#url.username#>
	</cfif>
	<cfif isdefined("url.password")>
		<cfset Attributes.password=#url.password#>
	</cfif>
	<cfif isdefined("url.table")>
		<cfset Attributes.table=#url.table#>
	</cfif>
	<cfif isdefined("url.contentfield")>
		<cfset Attributes.contentfield=#url.contentfield#>
	</cfif>
	<cfif isdefined("url.editpage")>
		<cfset Attributes.editpage=#url.editpage#>
	</cfif>
</cfif>

<cfif Attributes.id IS "">
	<cfabort showError="DBTree Error: The &quot;id&quot; attribute is required. That's the node id column.">		
</cfif>
<cfif Attributes.parent IS "">
	<cfabort showError="DBTree Error: The &quot;parent&quot; attribute is required. That's the node parent id column.">		
</cfif>
<cfswitch expression="#Attributes.action#">
<cfcase value="edit,get">
	<cfif Attributes.query IS "">
		<cfif (Attributes.datasource IS "") or (Attributes.table IS "")>
			<cfabort showerror="DBTree Error: If you are not using the &quot;query&quot; Attribute, you must define the &quot;datasource&quot; and the &quot;table&quot; Attributes."> 
		</cfif>
	<cfelseif (NOT Attributes.datasource IS "") or (NOT Attributes.table IS "")>
		<cfabort showerror="DBTree Error: Use either the &quot;query&quot; Attribute or the &quot;datasource&quot; and &quot;table&quot; Attributes."> 
	</cfif>
	<cfif Attributes.contentfield IS "">
		<cfabort showerror="DBTree Error: the attribute &quot;contentfield&quot; is required and must contain the DB columnname of the content."> 
	</cfif>
</cfcase>
<cfcase value="insert,update,delete,up,down,move,moveroot">
	<cfif (Attributes.datasource IS "") or (Attributes.table IS "")>
		<cfabort showerror="DBTree Error: If you are not using the &quot;query&quot; Attribute, you must define the &quot;datasource&quot; and the &quot;table&quot; Attributes."> 
	</cfif>
	<cfif Attributes.node IS "">
		<cfabort showerror="DBTree Error: for the &quot;insert&quot; action, the attribute &quot;node&quot; is required and must contain ID of the parent node."> 
	</cfif>
</cfcase>
<cfdefaultcase>
	<cfabort showerror="DBTree Error: Attribute action is wrong! supported actions are: get, edit, insert, update, delete, up, down, move, moveroot">
</cfdefaultcase>
</cfswitch>

<cfswitch expression="#Attributes.action#">
<cfcase value="edit">
	<cfif Attributes.instanceName IS "">
		<cfabort showError="DBTree Error: The &quot;instanceName&quot; attribute is required for this type.">		
	</cfif>
	<cfif (NOT Attributes.type IS "simple") and (NOT Attributes.type IS "advanced")>
		<cfabort showerror="DBTree Error: the attribute &quot;type&quot; has to be either &quot;simple&quot; or &quot;advanced&quot;"> 
	</cfif>
	<cfif Attributes.type IS "simple">
		<cfif Attributes.editpage IS "">
			<cfabort showerror="DBTree Error: for the &quot;edit&quot; action, the attribute &quot;editpage&quot; is required and must contain the relative path to the file with the code to modify the tree."> 
		</cfif>
	</cfif>
	<cfif Attributes.btn_addroot IS "">
		<cfabort showerror="DBTree Error: the attribute &quot;btn_addroot&quot; is required"> 
	</cfif>
</cfcase>
<cfcase value="insert,update">
	<cfif Attributes.formfields IS "">
		<cfabort showerror="DBTree Error: the attribute &quot;formfields&quot; is required and contain the formfields wich have the same name as in the database."> 
	</cfif>
</cfcase>
</cfswitch>

<cfswitch expression="#Attributes.type#">
<cfcase value="linked,path,hovertree,clicktree">
	<cfif (Attributes.url_type IS "") or ((NOT lcase(Attributes.url_type) IS "param") and (NOT lcase(Attributes.url_type) IS "db"))>
		<cfabort showerror="DBTree Error: the attribute &quot;url_type&quot; is required and must be either &quot;db&quot; or &quot;param&quot;."> 
	</cfif>
	<cfif Attributes.url IS "">
		<cfabort showerror="DBTree Error: the attribute &quot;url&quot; is required."> 
	</cfif>
	<cfif lcase(Attributes.url_type) IS "param">
		<cfif Attributes.url_param IS "">
			<cfabort showError="DBTree Error: The &quot;url_param&quot; attribute is required and must contain the database field with the url parameter to retrieve.">
		</cfif>
	<cfelseif lcase(Attributes.url_type) IS "db">
		<cfif NOT Attributes.url_param IS "">
			<cfabort showError="DBTree Error: The &quot;url&quot; attribute is required and must contain the database field with the url to retrieve. The &quot;url_param&quot; attribute should not be defined this case.">
		</cfif>
	</cfif>
	<cfif (Attributes.instanceName IS "") and (NOT Attributes.type IS "path")>
		<cfabort showError="DBTree Error: The &quot;instanceName&quot; attribute is required for this type.">			
	</cfif>
</cfcase>
<cfcase value="select,checkbox">
	<cfif Attributes.instanceName IS "">
		<cfabort showError="DBTree Error: The &quot;instanceName&quot; attribute is required for this type.">			
	</cfif>
</cfcase>
</cfswitch>

<cfif Attributes.type IS "select">
	<cfif (Attributes.jump IS "true") and (Attributes.multiple IS "true")>
		<cfabort showError="DBTree Error: the &quot;jump&quot; and the &quot;multiple&quot; attributes must have different values, now both are set to &quot;true&quot;.<br>Set either &quot;jump&quot; or &quot;multiple&quot; to false.">			
	<cfelseif Attributes.jump IS "true">
		<cfif (Attributes.url_type IS "") or ((NOT lcase(Attributes.url_type) IS "param") and (NOT lcase(Attributes.url_type) IS "db"))>
			<cfabort showerror="DBTree Error: the attribute &quot;url_type&quot; is required and must be either &quot;db&quot; or &quot;param&quot;."> 
		</cfif>
		<cfif Attributes.url IS "">
			<cfabort showerror="DBTree Error: the attribute &quot;url&quot; is required."> 
		</cfif>
		<cfif lcase(Attributes.url_type) IS "param">
			<cfif Attributes.url_param IS "">
				<cfabort showError="DBTree Error: The &quot;url_param&quot; attribute is required and must contain the database field with the url parameter to retrieve.">
			</cfif>
		<cfelseif lcase(Attributes.url_type) IS "db">
			<cfif NOT Attributes.url_param IS "">
				<cfabort showError="DBTree Error: The &quot;url&quot; attribute is required and must contain the database field with the url to retrieve. The &quot;url_param&quot; attribute should not be defined this case.">
			</cfif>
		</cfif>
	</cfif>
</cfif>
<cfif  (Attributes.action IS "get") and (NOT Attributes.type IS "path")>
	<cfif Attributes.sort IS "">
        <cfset Attributes.sort="sortorder ASC"> 
    </cfif>
</cfif>

<!---================ Breadcrumb Trail ==========================================--->
<cffunction name="getpath"> 
<cfargument name="rootnodeid" type="numeric">
<cfargument name="parentId" type="numeric">
<cfif #parentId# neq #rootnodeid#>
	<cfswitch expression="#lcase(Attributes.url_type)#">
		<cfcase value="param">
			<cfquery name="node" datasource="#Attributes.datasource#" username="#Attributes.username#" password="#Attributes.password#">
			SELECT *,#Attributes.url_param# AS param,#Attributes.id# FROM #Attributes.table# WHERE #Attributes.id#=#parentId#
			</cfquery> 
			<cfset theurl=#Attributes.url#>
		</cfcase>
		<cfcase value="db">
			<cfquery name="node" datasource="#Attributes.datasource#" username="#Attributes.username#" password="#Attributes.password#">
			SELECT *,#Attributes.url# AS theurl,#Attributes.id# FROM #Attributes.table# WHERE #Attributes.id#=#parentId#
			</cfquery> 
			<cfset param="">
		</cfcase>
	</cfswitch>
	<cfif (#node.recordcount# gt 0)>
		<cfoutput query="node">
			<cfif NOT Attributes.titlefield IS "">
				<cfset thetitle=evaluate("node.#Attributes.titlefield#")>
			<cfelse>
				<cfset thetitle=''>
			</cfif>
			<cfif (NOT Attributes.targetfield IS "") and (NOT evaluate("node.#Attributes.targetfield#") IS "")>
			<cfset thetarget=' target="'&evaluate("node.#Attributes.targetfield#")&'"'>
			<cfelse>
				<cfset thetarget=''>
			</cfif>
			<cfset arrayappend(baum,'<li><a href="#theurl##param##Attributes.url_suffix#"#thetarget# title="#thetitle#"><span>#evaluate("node.#Attributes.contentfield#")#</span></a></li>')>
		</cfoutput>
		<cfset getpath(#rootnodeid#,evaluate("node.#Attributes.parent#"))>
	</cfif> 
</cfif>
</cffunction>

<cffunction name="get_path"> 
<cfargument name="rootnodeid" type="numeric">
<cfargument name="nodeid" type="numeric">

	<cfswitch expression="#lcase(Attributes.url_type)#">
		<cfcase value="param">
			<cfquery name="node" datasource="#Attributes.datasource#" username="#Attributes.username#" password="#Attributes.password#">
			SELECT *,#Attributes.url_param# AS param,#Attributes.id# FROM #Attributes.table# WHERE #Attributes.id#=#nodeid#
			</cfquery> 
			<cfset theurl=#Attributes.url#>
		</cfcase>
		<cfcase value="db">
			<cfquery name="node" datasource="#Attributes.datasource#" username="#Attributes.username#" password="#Attributes.password#">
			SELECT *,#Attributes.url# AS theurl,#Attributes.id# FROM #Attributes.table# WHERE #Attributes.id#=#nodeid#
			</cfquery> 
			<cfset param="">
		</cfcase>
	</cfswitch>

	<cfif #node.recordcount# gt 0>
	
	<cfset baum=arraynew(1)>
	<cfoutput query="node">
		<cfif NOT Attributes.titlefield IS "">
			<cfset thetitle=evaluate("node.#Attributes.titlefield#")>
		<cfelse>
			<cfset thetitle=''>
		</cfif>
			<cfif (NOT Attributes.targetfield IS "") and (NOT evaluate("node.#Attributes.targetfield#") IS "")>
			<cfset thetarget=' target="'&evaluate("node.#Attributes.targetfield#")&'"'>
		<cfelse>
			<cfset thetarget=''>
		</cfif>
		<cfset arrayappend(baum,'<li><a href="#theurl##param##Attributes.url_suffix#"#thetarget# title="#thetitle#"><span>#evaluate("node.#Attributes.contentfield#")#</span></a></li>')>
	</cfoutput>
	<cfif #rootnodeid# neq evaluate("node.#Attributes.id#")>
		<cfset getpath(#rootnodeid#,evaluate("node.#Attributes.parent#"))>
	</cfif>
	<cfset pfad='<ul>'>
	<cfloop index="x" from="#arraylen(baum)#" to="1" step="-1">
		<cfset pfad=pfad&#baum[x]#>
	</cfloop>
	<cfset pfad=pfad&'</ul>'>
	<cfif NOT Attributes.instanceName IS ""> 
		<cfset pfad=replace(pfad,'<ul>','<ul id="#Attributes.instanceName#">','ONE')> 
	</cfif> 
	<cfoutput>#pfad#</cfoutput>

	<cfelse>
		<cfabort showerror="CF_DBTree Error: The given node does not exist.">
	</cfif>
</cffunction>


<!---===================== Simple unordered list =================================--->
<cffunction name="dispcontentchilds"> 
<cfargument name="parentId" type="numeric"> 
<cfloop index="x" from="1" to="#n_recs#"> 
	<cfif #pa[x][2]# eq #parentId#> 
		<cfset baum=baum&'<ul><li>#pa[x][3]#'>
		<cfset dispcontentchilds(#pa[x][1]#)> 
		<cfset baum=baum&'</li></ul>'> 
	</cfif> 
</cfloop> 
</cffunction> 
<cffunction name="get_content"> 
<cfif Attributes.query IS ""> 
	<cfquery name="liste" datasource="#Attributes.datasource#" username="#Attributes.username#" password="#Attributes.password#">
	SELECT * FROM #Attributes.table# ORDER BY #Attributes.sort#
	</cfquery>
<cfelse> 
	<cfset liste = evaluate("Caller.#Attributes.query#")> 
</cfif> 
<cfset n_recs=liste.recordcount> 
<cfset pa=arraynew(2)> 
<cfloop query="liste"> 
  <cfset pa[CurrentRow][1]=#evaluate(Attributes.id)#> 
  <cfset pa[CurrentRow][2]=#evaluate(Attributes.parent)#>
  <cfset pa[CurrentRow][3]=#evaluate(Attributes.contentfield)#> 
</cfloop> 
<cfif n_recs gt 0> 
<cfset baum=''> 
<cfset dispcontentchilds(#Attributes.rootnode#)> 
<cfset classname="">
<cfif #Attributes.class# neq "">
	<cfset classname=' class="' & #Attributes.class# & '"'>
</cfif>
<cfif NOT Attributes.instanceName IS ""> 
    <cfset baum=replace(baum,'<ul>','<ul id="#Attributes.instanceName#"#classname#>','ONE')> 
</cfif> 
<cfset baum=replace(baum,'</li></ul><ul><li>','</li><li>','ALL')> 
<cfoutput>#baum#</cfoutput>
</cfif> 
</cffunction>

<!---================ List with links: linked, tree, menu =========================--->
<cffunction name="dispchilds"> 
<cfargument name="parentId" type="numeric"> 
<cfloop index="x" from="1" to="#n_recs#"> 
	<cfif #pa[x][2]# eq #parentId#> 
		<cfif #pa[x][1]# eq #Attributes.current#>
			<cfset iscurrent=' id="#Attributes.instanceName#_active"'>
		<cfelse>
			<cfset iscurrent=''>
		</cfif>
		<cfif #pa[x][6]# neq "">
			<cfset thetarget=' target="#pa[x][6]#"'>
		<cfelse>
			<cfset thetarget=''>
		</cfif>
		<cfset baum=baum&'<ul><li#iscurrent#><a href="#pa[x][4]##pa[x][5]##Attributes.url_suffix#"#thetarget# title="#pa[x][7]#"><span>#pa[x][3]#</span></a>'>
		<cfset level=level+1>
		<cfif NOT Attributes.levels IS "">
			<cfif #level# lte #Attributes.levels#>
				<cfset dispchilds(#pa[x][1]#)> 
			</cfif>
		<cfelse>
			<cfset dispchilds(#pa[x][1]#)>		
		</cfif>
		<cfset level=level-1>
		<cfset baum=baum&'</li></ul>'> 
	</cfif> 
</cfloop> 
</cffunction> 
 
<cffunction name="get_tree"> 
<cfset level=1>
<cfif Attributes.query IS ""> 
	<cfquery name="liste" datasource="#Attributes.datasource#" username="#Attributes.username#" password="#Attributes.password#">
	SELECT * FROM #Attributes.table# ORDER BY #Attributes.sort# 
	</cfquery> 
<cfelse> 
	<cfset liste=evaluate("Caller.#Attributes.query#")> 
</cfif> 
<cfset n_recs=liste.recordcount> 
<cfset pa=arraynew(2)> 
<cfswitch expression="#Attributes.url_type#"> 
	<cfcase value="param"> 
		<cfloop query="liste"> 
		  <cfset pa[CurrentRow][1]=#evaluate(Attributes.id)#> 
		  <cfset pa[CurrentRow][2]=#evaluate(Attributes.parent)#> 
		  <cfset pa[CurrentRow][3]=#evaluate(Attributes.contentfield)#> 
		  <cfset pa[CurrentRow][4]=#Attributes.url#> 
		  <cfset pa[CurrentRow][5]=#evaluate(Attributes.url_param)#> 
		  <cfif NOT Attributes.targetfield IS "">
			  <cfset pa[CurrentRow][6]=#evaluate(Attributes.targetfield)#> 
		  <cfelse>
			  <cfset pa[CurrentRow][6]=''>
		  </cfif>
		  <cfif NOT Attributes.titlefield IS "">
			  <cfset pa[CurrentRow][7]=#evaluate(Attributes.titlefield)#> 
		  <cfelse>
			  <cfset pa[CurrentRow][7]=''> 
		  </cfif>
		</cfloop> 
	</cfcase> 
	<cfcase value="db"> 
		<cfloop query="liste"> 
		  <cfset pa[CurrentRow][1]=#evaluate(Attributes.id)#> 
		  <cfset pa[CurrentRow][2]=#evaluate(Attributes.parent)#> 
		  <cfset pa[CurrentRow][3]=#evaluate(Attributes.contentfield)#> 
		  <cfset pa[CurrentRow][4]=#evaluate(Attributes.url)#> 
		  <cfset pa[CurrentRow][5]=''> 
		  <cfif NOT Attributes.targetfield IS "">
			  <cfset pa[CurrentRow][6]=#evaluate(Attributes.targetfield)#> 
		  <cfelse>
			  <cfset pa[CurrentRow][6]=''> 
		  </cfif>
		  <cfif NOT Attributes.titlefield IS "">
			  <cfset pa[CurrentRow][7]=#evaluate(Attributes.titlefield)#> 
		  <cfelse>
			  <cfset pa[CurrentRow][7]=''> 
		  </cfif>
		</cfloop> 
	</cfcase> 
</cfswitch> 
  
<cfif n_recs gt 0> 
 
<cfset baum=''> 
<cfset dispchilds(#Attributes.rootnode#)> 
<cfset baum=replace(baum,'</li></ul><ul><li id="#Attributes.instanceName#_active">','</li><li id="#Attributes.instanceName#_active">','ALL')> 
<cfset baum=replace(baum,'</li></ul><ul><li>','</li><li>','ALL')> 
<cfset expand="">
<cfif #Attributes.expandcurrent# eq "true">
	<cfset expand=" expand">
</cfif>
<cfset linkparent="">
<cfif #Attributes.linkparent# eq "true">
	<cfset linkparent=" linkparent">
</cfif>
<cfset multiple="">
<cfif #Attributes.multiple# eq "true">
	<cfset multiple=" multiple">
</cfif>
<cfset timeout="">
<cfif #Attributes.timeout# gt 0>
	<cfset timeout=" to"&#Attributes.timeout#&"to">
</cfif>
<cfset classname="">
<cfif #Attributes.class# neq "">
	<cfset classname=' class="' & #Attributes.class# & '"'>
</cfif>

<cfswitch expression="#Attributes.type#">
	<cfcase value="hovertree">
		<cfset baum=replace(baum,'<ul>','<ul id="#Attributes.instanceName#" class="dbtree#expand##timeout#">','ONE')> 
	</cfcase>
	<cfcase value="clicktree">
		<cfset baum=replace(baum,'<ul>','<ul id="#Attributes.instanceName#" class="dbtree onclick#expand##linkparent##multiple#">','ONE')> 
	</cfcase>
	<cfdefaultcase>
		<cfset baum=replace(baum,'<ul>','<ul id="#Attributes.instanceName#"#classname#>','ONE')> 
	</cfdefaultcase>
</cfswitch>

<cfoutput>#baum#</cfoutput>

</cfif> 
 
</cffunction>

<!---===================== Selectbox =================================--->
<cffunction name="selectchilds"> 
<cfargument name="parentId" type="numeric"> 
<cfloop index="x" from="1" to="#n_recs#"> 
	<cfif #pa[x][2]# eq #parentId#> 
		<cfif NOT Attributes.multiple IS "true">
			<cfif #pa[x][1]# eq #Attributes.current#>
				<cfset iscurrent=' selected'>
			<cfelse>
				<cfset iscurrent=''>
			</cfif>
		<cfelse>
			<cfif listfind(Attributes.current,pa[x][1]) gt 0>
				<cfset iscurrent=' selected="selected"'>
			<cfelse>
				<cfset iscurrent=''>
			</cfif>
		</cfif>
		<cfset level=level+1>
		<cfif NOT Attributes.jump IS "true">
			<cfset baum=baum&'<option value="#pa[x][1]#"#iscurrent#>#repeatstring("&nbsp;&nbsp;&nbsp;&nbsp;",level-1)##pa[x][3]#'>
		<cfelse>
			<cfset baum=baum&'<option value="#pa[x][4]##pa[x][5]##Attributes.url_suffix#"#iscurrent#>#repeatstring("&nbsp;&nbsp;&nbsp;&nbsp;",level-1)##pa[x][3]#'>
		</cfif>
		<cfset baum=baum&'</option>'> 
		<cfset selectchilds(#pa[x][1]#)> 
		<cfset level=level-1> 
	</cfif>
</cfloop> 
</cffunction> 
 
<cffunction name="get_select"> 
 
<cfif Attributes.query IS ""> 
	<cfquery name="liste" datasource="#Attributes.datasource#" username="#Attributes.username#" password="#Attributes.password#">
	SELECT * FROM #Attributes.table# ORDER BY #Attributes.sort# 
	</cfquery> 
<cfelse> 
	<cfset liste = evaluate("Caller.#Attributes.query#")> 
</cfif> 
<cfset n_recs=liste.recordcount> 
<cfset pa=arraynew(2)> 
<cfif NOT Attributes.jump IS "true">
	<cfloop query="liste"> 
	  <cfset pa[CurrentRow][1]=#evaluate(Attributes.id)#> 
	  <cfset pa[CurrentRow][2]=#evaluate(Attributes.parent)#> 
	  <cfset pa[CurrentRow][3]=#evaluate(Attributes.contentfield)#> 
	</cfloop> 
<cfelse>
	<cfswitch expression="#Attributes.url_type#"> 
	<cfcase value="param"> 
		<cfloop query="liste"> 
		  <cfset pa[CurrentRow][1]=#evaluate(Attributes.id)#> 
		  <cfset pa[CurrentRow][2]=#evaluate(Attributes.parent)#> 
		  <cfset pa[CurrentRow][3]=#evaluate(Attributes.contentfield)#> 
		  <cfset pa[CurrentRow][4]=#Attributes.url#> 
		  <cfset pa[CurrentRow][5]=#evaluate(Attributes.url_param)#> 
		</cfloop> 
	</cfcase> 
	<cfcase value="db"> 
		<cfloop query="liste"> 
		  <cfset pa[CurrentRow][1]=#evaluate(Attributes.id)#> 
		  <cfset pa[CurrentRow][2]=#evaluate(Attributes.parent)#> 
		  <cfset pa[CurrentRow][3]=#evaluate(Attributes.contentfield)#> 
		  <cfset pa[CurrentRow][4]=#evaluate(Attributes.url)#> 
		  <cfset pa[CurrentRow][5]=''> 
		</cfloop> 
	</cfcase> 
	</cfswitch> 
</cfif>

<cfset level=0>
<cfset baum='<select name="#Attributes.instanceName#" id="#Attributes.instanceName#"'> 
<cfif NOT Attributes.size IS "0">
	<cfset baum=baum&' size="#Attributes.size#"'> 
</cfif>
<cfif NOT Attributes.jump IS "false">
	<cfif Attributes.jumptarget IS "">
		<cfset Attributes.jumptarget = "parent">
	<cfelseif left(Attributes.jumptarget,1) IS "_">
		<cfset Attributes.jumptarget = #replace(Attributes.jumptarget,"_","","ONE")#>
	</cfif>
	<cfset baum=baum&' onchange="jumpTo(''#Attributes.jumptarget#'',this)"'> 
<cfelse> 
	<cfif NOT Attributes.multiple IS "false">
		<cfset baum=baum&' multiple="multiple"'> 
	</cfif>
</cfif> 
<cfif NOT Attributes.class IS "">
	<cfset baum=baum&' class="' & Attributes.class & '"'>
</cfif>
<cfset baum=baum&'>'> 
<cfif n_recs gt 0> 
<cfset selectchilds(#Attributes.rootnode#)> 
</cfif> 
<cfset baum=baum&'</select>'> 
<cfoutput>#baum#</cfoutput>
 
</cffunction>

<!---===================== Checkbox Tree =================================--->
<cffunction name="checkboxchilds"> 
<cfargument name="parentId" type="numeric"> 
<cfloop index="x" from="1" to="#n_recs#"> 
	<cfif #pa[x][2]# eq #parentId#> 
		<cfset baum=baum&'<ul><li><input name="#Attributes.instanceName#" type="checkbox" value="#pa[x][1]#"'>
		<cfif #listfind(Attributes.current,pa[x][1])# neq 0>
			<cfset baum=baum&' checked="checked"'>
		</cfif>
		<cfset baum=baum&' />&nbsp;#pa[x][3]#'>
		<cfset checkboxchilds(#pa[x][1]#)> 
		<cfset baum=baum&'</li></ul>'> 
	</cfif>
</cfloop> 
</cffunction> 
 
<cffunction name="get_checkbox"> 
 
<cfif Attributes.query IS ""> 
	<cfquery name="liste" datasource="#Attributes.datasource#" username="#Attributes.username#" password="#Attributes.password#">
	SELECT * FROM #Attributes.table# ORDER BY #Attributes.sort# 
	</cfquery> 
<cfelse> 
	<cfset liste = evaluate("Caller.#Attributes.query#")> 
</cfif> 
<cfset n_recs=liste.recordcount> 
<cfset pa=arraynew(2)> 
<cfloop query="liste"> 
  <cfset pa[CurrentRow][1]=#evaluate(Attributes.id)#> 
  <cfset pa[CurrentRow][2]=#evaluate(Attributes.parent)#> 
  <cfset pa[CurrentRow][3]=#evaluate(Attributes.contentfield)#> 
</cfloop> 
  
<cfif n_recs gt 0> 
 
<cfset baum=''> 
<cfset checkboxchilds(#Attributes.rootnode#)> 
<cfset classname="">
<cfif #Attributes.class# neq "">
	<cfset classname=' class="' & #Attributes.class# & '"'>
</cfif>
<cfset baum=replace(baum,'<ul>','<ul id="ul#Attributes.instanceName#"#classname#>','ONE')> 
<cfset baum=replace(baum,'</li></ul><ul><li>','</li><li>','ALL')> 

<cfoutput>#baum#</cfoutput>

</cfif> 
 
</cffunction>


<!--- ======== Simple tree to modify ============================== --->
<cffunction name="dispchildsedit">
<cfargument name="parentId" type="numeric">
<cfloop index="x" from="1" to="#n_recs#">
	<cfset op=''>
	<cfif #pa[x][2]# eq #parentId#>
		<cfif (count eq 0) and (NOT Attributes.instanceName IS "")>
			<cfset baum=baum&'<ul id="#Attributes.instanceName#">'>
		<cfelse>
			<cfset baum=baum&'<ul>'>
		</cfif>
		<cfif NOT Attributes.btn_add IS "">
		<cfset op=op&' <a href="#Attributes.editpage##tok#node=#pa[x][1]#&amp;action=add">#Attributes.btn_add#</a>'>
		</cfif>
		<cfif NOT Attributes.btn_edit IS "">
		<cfset op=op&' <a href="#Attributes.editpage##tok#node=#pa[x][1]#&amp;action=edit">#Attributes.btn_edit#</a>'>
		</cfif>
		<cfif NOT Attributes.btn_delete IS "">
		<cfset op=op&' <a href="#Attributes.editpage##tok#node=#pa[x][1]#&amp;action=delete">#Attributes.btn_delete#</a>'>
		</cfif>
		<cfif NOT Attributes.btn_moveroot IS "">
		<cfset op=op&' <a href="#Attributes.editpage##tok#node=#pa[x][1]#&amp;action=moveroot">#Attributes.btn_moveroot#</a>'>
		</cfif>
		<cfif NOT Attributes.btn_up IS "">
		<cfset op=op&' <a href="#Attributes.editpage##tok#node=#pa[x][1]#&amp;action=up">#Attributes.btn_up#</a>'>
		</cfif>
		<cfif NOT Attributes.btn_down IS "">
		<cfset op=op&' <a href="#Attributes.editpage##tok#node=#pa[x][1]#&amp;action=down">#Attributes.btn_down#</a>'>
		</cfif>
		<cfset baum=baum&'<li>#pa[x][3]##op#'>
		<cfset count=count+1>
		<cfset dispchildsedit(#pa[x][1]#)>
		<cfset baum=baum&'</li></ul>'>
	</cfif>
</cfloop>
</cffunction>

<cffunction name="edit_tree">

<cfif Attributes.query IS "">
	<cfquery name="liste" datasource="#Attributes.datasource#" username="#Attributes.username#" password="#Attributes.password#">
	SELECT * FROM #Attributes.table# ORDER BY sortorder
	</cfquery> 
<cfelse>
	<cfset liste = evaluate("Caller.#Attributes.query#")>
</cfif>
<cfset n_recs=liste.recordcount>
<cfset pa=arraynew(2)>
<cfloop query="liste">
  <cfset pa[CurrentRow][1]=#evaluate(Attributes.id)#>
  <cfset pa[CurrentRow][2]=#evaluate(Attributes.parent)#>
  <cfset pa[CurrentRow][3]=#evaluate(Attributes.contentfield)#>
</cfloop>
<cfif findnocase("?",#Attributes.editpage#) gt 0>
	<cfset tok="&amp;">
<cfelse>
	<cfset tok="?">
</cfif>
<cfset classname="">
<cfif #Attributes.class# neq "">
	<cfset classname=' class="' & #Attributes.class# & '"'>
</cfif>
<cfoutput><ul#classname#><li><a href="#Attributes.editpage##tok#node=#Attributes.rootnode#&action=add">#Attributes.btn_addroot#</a></li></ul></cfoutput>

<cfif n_recs gt 0>

<cfset baum=''>
<cfset count=0>
<cfset dispchildsedit(#Attributes.rootnode#)> 
<cfoutput>#Replace(baum,'</li></ul><ul><li>','</li><li>','ALL')#</cfoutput>

</cfif>

</cffunction>

<!--- =========== Editieren im Advanced Mode: AJAX======================= --->
<cffunction name="childs_adv">
<cfargument name="parentId" type="numeric">
<cfloop index="x" from="1" to="#n_recs#">
	<cfif #pa[x][2]# eq #parentId#>
		<cfif count eq 0>
			<cfset baum=baum&'<ul id="#Attributes.instanceName#" class="dbtree onclick edit">'>
		<cfelse>
			<cfset baum=baum&'<ul>'>
		</cfif>
		<cfset baum=baum&'<li id="#Attributes.instanceName#_#pa[x][1]#"><a href="##"><span>#pa[x][3]#</span></a>'>
		<cfset count=count+1>
		<cfset childs_adv(#pa[x][1]#)>
		<cfset baum=baum&'</li></ul>'>
	</cfif>
</cfloop>
</cffunction>

<cffunction name="edit_tree_adv">
<cfset baum=''>
<cfset count=0>
<cfif Attributes.query IS "">
	<cfquery name="liste" datasource="#Attributes.datasource#" username="#Attributes.username#" password="#Attributes.password#">
	SELECT * FROM #Attributes.table# ORDER BY sortorder
	</cfquery> 
<cfelse>
	<cfset liste=evaluate("Caller.#Attributes.query#")>
</cfif>
<cfset n_recs=#liste.recordcount#>
<cfset pa=arraynew(2)>
<cfloop query="liste">
  <cfset pa[CurrentRow][1]=#evaluate(Attributes.id)#>
  <cfset pa[CurrentRow][2]=#evaluate(Attributes.parent)#>
  <cfset pa[CurrentRow][3]=#evaluate(Attributes.contentfield)#>
</cfloop>
<cfif findnocase("?",#Attributes.editpage#) gt 0>
	<cfset tok="&amp;">
<cfelse>
	<cfset tok="?">
</cfif>

<cfif #Attributes.rootnode# neq 0>
	<cfquery name="branch" datasource="#Attributes.datasource#" username="#Attributes.username#" password="#Attributes.password#">
	SELECT * FROM #Attributes.table# WHERE #Attributes.parent#=#Attributes.rootnode#
	</cfquery> 
	<cfif #branch.recordcount# gt 0>
		<cfset emp=0>
	<cfelse>
		<cfset emp=1>
	</cfif>
<cfelse>
	<cfset emp=0>
</cfif>

<cfif (#n_recs# gt 0) and (#emp# neq 1)>
	<cfset childs_adv(#Attributes.rootnode#)> 
	<cfset baum=replace(baum,'</li></ul><ul><li','</li><li','ALL')> 
	<cfset op='<li class="addroot"><a href="javascript:void(0);">#Attributes.btn_addroot#</a></li>'>
	<cfif NOT Attributes.btn_moveroot IS "">
	<cfset op=op&'<li class="moveroot"><a href="javascript:void(0);">#Attributes.btn_moveroot#</a></li>'>
	</cfif>
	<cfif NOT Attributes.btn_add IS "">
	<cfset op=op&'<li class="add"><a href="javascript:void(0);">#Attributes.btn_add#</a></li>'>
	</cfif>
	<cfif NOT Attributes.btn_edit IS "">
	<cfset op=op&'<li class="edit"><a href="javascript:void(0);">#Attributes.btn_edit#</a></li>'>
	</cfif>
	<cfif NOT Attributes.btn_delete IS "">
	<cfset op=op&'<li class="delete"><a href="javascript:void(0);">#Attributes.btn_delete#</a></li>'>
	</cfif>
	<cfif NOT Attributes.btn_up IS "">
	<cfset op=op&'<li class="up"><a href="javascript:void(0);">#Attributes.btn_up#</a></li>'>
	</cfif>
	<cfif NOT Attributes.btn_down IS "">
	<cfset op=op&'<li class="down"><a href="javascript:void(0);">#Attributes.btn_down#</a></li>'>
	</cfif>


	<cfset pfadbase="http://"&#cgi.HTTP_HOST#&#cgi.SCRIPT_NAME#>
    <cfset pfadpage=#ExpandPath('./')#>
    <cfset pfadtag=#GetCurrentTemplatePath()#>
    
    <cfif #len(listfirst(cgi.PATH_TRANSLATED,":\"))# eq 1>
    <!--- WINDOWS --->
        <cfset Variables.slash="\">
        <cfset currentDrive = ListGetAt( pfadpage, 1, ":\" )>
        <cfset destinationDrive = ListGetAt( pfadtag, 1, ":\" )>
        <cfif currentDrive IS NOT destinationDrive>
          <cfabort showerror="DBTree Error: The current path and destination path drive letters must match.">
        </cfif>
    <cfelse>
    <!--- UNIX, LINUX --->
        <cfset Variables.slash="/">
    </cfif>
    <!--- Get a list of directory by removing N:\ and trailing \ --->
    <cfset Variables.currentDir = GetDirectoryFromPath( pfadpage )>
    <cfset Variables.destinationDir = GetDirectoryFromPath( pfadtag )>
    <cfset Variables.currentDirs = Mid( Variables.currentDir, 4, (Len( Variables.currentDir ) - 4) )>
    <cfset Variables.destinationDirs = Mid( Variables.destinationDir, 4, (Len( Variables.destinationDir ) - 4) )>
    <!--- Fix 1.0.1:  We don't want to compare elements that don't exists. Get smallest length --->
    <cfif ListLen( Variables.currentDirs, Variables.slash ) LT ListLen( Variables.destinationDirs, Variables.slash )>
      <cfset Variables.to = ListLen( Variables.currentDirs, Variables.slash )>
    <cfelse>
      <cfset Variables.to = ListLen( Variables.destinationDirs, Variables.slash )>
    </cfif>
    <!--- Loop through directory list until directory don't match anymore --->
    <cfset Variables.matchingLevel = 0>
    <cfloop index="i" from="1" to="#Variables.to#">
      <cfif ListGetAt( Variables.currentDirs, i, Variables.slash ) IS ListGetAt( Variables.destinationDirs, i, Variables.slash )>
        <cfset Variables.matchingLevel = #Variables.matchingLevel# + 1>
      <cfelse>
        <cfbreak>
      </cfif>
    </cfloop>
    <cfset lc=(ListLen( Variables.currentDirs, Variables.slash ) - Variables.matchingLevel)>
    <cfset pc=#len(pfadbase)#>
    <cfset CountVar = 0>
    <cfloop condition = "CountVar LTE lc">
      <cfif right(pfadbase,1) eq "/">
         <cfset CountVar = CountVar + 1>
      </cfif>
        <cfset pfadbase=#removechars(pfadbase,pc,1)#>
        <cfset pc=#len(pfadbase)#>
    </cfloop>
    <!--- Append to the relativePath the directories from destination that didn't match --->
    <cfset Variables.relativePath = #pfadbase# & "/" >
    <cfloop index="i" from="#Evaluate('#Variables.matchingLevel#+1')#" to="#ListLen( Variables.destinationDirs, Variables.slash )#">
      <cfset Variables.relativePath =  #Variables.relativePath# & #ListGetAt( Variables.destinationDirs, i, Variables.slash )# &  "/">
    </cfloop>
    <!--- Now append the file to the relative path --->
    <cfset Variables.relativePath = #Variables.relativePath# & #ListGetAt( pfadtag, ListLen( pfadtag, Variables.slash ), Variables.slash )#>
    <!--- Save the result into the user's variable or our default variable --->
    <cfset path_result = #Variables.relativePath#>


<cfset pfad=#path_result#>
	
	<cfif isdefined("url.instanceName")>
		<cfoutput>#baum#</cfoutput>
	<cfelse>
		<cfif Attributes.styled EQ "true">
			<cfset css='<style type="text/css" media="screen,projection">'>
<cfset css=css&'###Attributes.instanceName#, ###Attributes.instanceName# a:link, ###Attributes.instanceName# li a:link, ###Attributes.instanceName# a:visited, ###Attributes.instanceName# li a:visited{color:###Attributes.color#;text-decoration:none}'>
<cfset css=css&'###Attributes.instanceName#,###Attributes.instanceName# ul{list-style-type:none;font:#Attributes.fontstyle# #Attributes.fontweight# #Attributes.fontsize# #Attributes.fontfamily#;width:auto;margin:0;padding:0}'>
<cfset css=css&'###Attributes.instanceName# ul{padding-left:#Attributes.imagewidth#;display:none;overflow:auto}'>
<cfset css=css&'###Attributes.instanceName# li ul{margin:0 auto}'>
<cfset css=css&'###Attributes.instanceName# li{display:block;width:100%;line-height:#Attributes.imageheight#;white-space:nowrap}'>
<cfset css=css&'###Attributes.instanceName# li a{display:block;padding-left:#Attributes.imagewidth#;color:###Attributes.color#;text-decoration:none;background:url(#Attributes.item#) center left no-repeat;white-space:nowrap}'>
<cfset css=css&'###Attributes.instanceName# li a:hover{text-decoration:underline;background-color:transparent;color:###Attributes.color#}'>
<cfset css=css&'###Attributes.instanceName# li ul.click{display:block}'>
<cfset css=css&'###Attributes.instanceName# li.click a{background:url(#Attributes.item#) center left no-repeat}'>
<cfset css=css&'###Attributes.instanceName# ul li.click a{background:url(#Attributes.item#) center left no-repeat}'>
<cfset css=css&'###Attributes.instanceName# li a.subMenu,###Attributes.instanceName# ul li a.subMenu{background:url(#Attributes.folderclosed#) center left no-repeat}'>
<cfset css=css&'###Attributes.instanceName# li a.click{background:url(#Attributes.folderopen#) center left no-repeat}'>
<cfset css=css&'###Attributes.instanceName# ul li a.click{background:url(#Attributes.folderopen#) center left no-repeat}'>
<cfset css=css&'###Attributes.instanceName#_tip{z-index:999;background:###Attributes.tipbgcolor#;display:none;position:absolute;top:0;left:0;padding:2px;margin:2px;font:#Attributes.fontstyle# #Attributes.fontweight# #Attributes.fontsize# #Attributes.fontfamily#;color:###Attributes.tipcolor#;filter:alpha(opacity=70);opacity:.7;}'>
<cfset css=css&'###Attributes.instanceName#_options{z-index:990;display:none;position:absolute;top:0;left:0;padding:0;margin:0;background-color:###Attributes.contextbgcolor#;border:1px solid ###Attributes.contextlinkcolor#;border-bottom-width:0}'>
<cfset css=css&'###Attributes.instanceName#_options ul{margin:0;padding:0;list-style:none;text-align:left;font:#Attributes.fontstyle# #Attributes.fontweight# #Attributes.fontsize# #Attributes.fontfamily#;color:###Attributes.color#;}'>
<cfset css=css&'###Attributes.instanceName#_options a{display:block;padding:3px;width:160px;background-color:###Attributes.contextbgcolor#;border-bottom:1px solid ###Attributes.contextlinkcolor#;margin-bottom:0}'>
<cfset css=css&'###Attributes.instanceName#_options a:link,###Attributes.instanceName#_options a:visited{color:###Attributes.contextlinkcolor#;text-decoration:none}'>
<cfset css=css&'###Attributes.instanceName#_options a:hover{background-color:###Attributes.contextbgcolor_over#;color:###Attributes.contextlinkcolor_over#}'>
<cfset css=css&'html>body ###Attributes.instanceName#_options a{margin-bottom:0}</style>'>
			<cfoutput>#css#</cfoutput>
		</cfif> 
		<cfoutput><script type="text/javascript">eval(decode('#toBase64('dbtreeObj.push({tagpath:"#pfad#",
		instanceName:"#Attributes.instanceName#",
		type:"#Attributes.type#",
		query:"#Attributes.query#",
		datasource:"#Attributes.datasource#",
		username:"#Attributes.username#",
		password:"#Attributes.password#",
		table:"#Attributes.table#",
		rootnode:#Attributes.rootnode#,
		id:"#Attributes.id#",
		parent:"#Attributes.parent#",
		contentfield:"#Attributes.contentfield#",
		editpage:"#Attributes.editpage##tok#"
		});')#'));</script>
		<div id="#Attributes.instanceName#_edit">#baum#</div><div id="#Attributes.instanceName#_options"><ul>#op#</ul></div></cfoutput>
	</cfif>

<cfelse>
	<cfoutput><a href="#Attributes.editpage##tok#action=add&amp;node=#Attributes.rootnode#">#Attributes.btn_addroot#</a></cfoutput>
</cfif>

</cffunction>

<!---=========== Insert Node ========================================--->
<cffunction name="insert_elem">
<cfargument name="nodeid" type="numeric">
<cfargument name="fields" type="any">

<cfset neworder=1>
<cfquery name="findorder" datasource="#Attributes.datasource#" username="#Attributes.username#" password="#Attributes.password#">
SELECT sortorder FROM #Attributes.table# WHERE #Attributes.parent#=#nodeid# ORDER BY sortorder DESC
</cfquery>
<cfif findorder.recordcount gt 0>
<cfoutput query="findorder" maxrows="1">
	<cfset neworder=#val(sortorder)#+1>
</cfoutput>
</cfif>

<cfset cf=0>
<cftransaction>
<cfquery name="insert_new" datasource="#Attributes.datasource#" username="#Attributes.username#" password="#Attributes.password#">
INSERT INTO #Attributes.table# (
<cfloop index="feld" list="#fields#">
	<cfloop item="key" collection="#form#">
		<cfif #comparenocase(key,feld)# eq 0>
			<cfif #cf# gt 0>, </cfif>#feld#
		</cfif>
	</cfloop>	
	<cfset cf=cf+1>
</cfloop>
,#Attributes.parent#,sortorder) VALUES (
<cfset cf=0>
<cfloop index="feld" list="#fields#">
	<cfloop item="key" collection="#form#">
		<cfif #comparenocase(key,feld)# eq 0>
			<cfif #cf# gt 0>, </cfif><cfif #isdate(form[key])# eq 1><cfqueryparam value="#form[key]#" cfsqltype="cf_sql_timestamp"><cfelse><cfqueryparam value="#form[key]#"></cfif>
		</cfif>
	</cfloop>	
	<cfset cf=cf+1>
</cfloop>
,#nodeid#,#neworder#)
</cfquery>
</cftransaction>

</cffunction>


<!---=========== Delete Node and Subnodes ========================================--->
<cffunction name="deletechilds">
<cfargument name="parentId" type="numeric">
	<cfquery name="parentnode" datasource="#Attributes.datasource#" username="#Attributes.username#" password="#Attributes.password#">
	SELECT #Attributes.id# AS id FROM #Attributes.table# WHERE #Attributes.parent#=#parentId#
	</cfquery>
	<cfif parentnode.recordcount gt 0>
		<cfset deletechilds(#parentnode.id#)>
		<cfquery name="del" datasource="#Attributes.datasource#" username="#Attributes.username#" password="#Attributes.password#">
		DELETE FROM #Attributes.table# WHERE #Attributes.parent#=#parentId#
		</cfquery>
	</cfif>
</cffunction>

<cffunction name="delete_elem">
<cfargument name="nodeid" type="numeric">
<cftransaction>
	<cfquery name="node" datasource="#Attributes.datasource#" username="#Attributes.username#" password="#Attributes.password#">
	SELECT #Attributes.parent# AS pid,sortorder FROM #Attributes.table# WHERE #Attributes.id#=#nodeid#
	</cfquery>
	<cfquery name="updaten" datasource="#Attributes.datasource#" username="#Attributes.username#" password="#Attributes.password#">
	UPDATE #Attributes.table# SET sortorder=sortorder-1 WHERE sortorder>#val(node.sortorder)# AND #Attributes.parent#=#node.pid#
	</cfquery>

	<cfset deletechilds(nodeid)>

	<cfquery name="del" datasource="#Attributes.datasource#" username="#Attributes.username#" password="#Attributes.password#">
	DELETE FROM #Attributes.table# WHERE #Attributes.id#=#nodeid#
	</cfquery>
</cftransaction>

<cfif isdefined("url.instanceName")>
	<cfset edit_tree_adv()>
</cfif>
	
</cffunction>

<!---=========== Update Node ========================================--->
<cffunction name="update_elem">
<cfargument name="nodeid" type="numeric">
<cfargument name="fields" type="any">

<cfset cf=0>
<cftransaction>
<cfquery name="updaten" datasource="#Attributes.datasource#" username="#Attributes.username#" password="#Attributes.password#">
UPDATE #Attributes.table# SET
<cfloop index="feld" list="#fields#">
	<cfloop item="key" collection="#form#">
		<cfif #comparenocase(key,feld)# eq 0>
			<cfif #cf# gt 0>, </cfif>
			#feld#=<cfif #isdate(form[key])# eq 1><cfqueryparam value="#form[key]#" cfsqltype="cf_sql_timestamp"><cfelse><cfqueryparam value="#form[key]#"></cfif>
		</cfif>
	</cfloop>	
	<cfset cf=cf+1>
</cfloop>
WHERE #Attributes.id#=#nodeid#
</cfquery>
</cftransaction>

</cffunction>


<!---=========== Move Node and Subnodes: UP ======================================== --->
<cffunction name="move_up">
<cfargument name="nodeid" type="numeric">

<cfquery name="node" datasource="#Attributes.datasource#" username="#Attributes.username#" password="#Attributes.password#">
SELECT #Attributes.parent# AS pid,sortorder FROM #Attributes.table# WHERE #Attributes.id#=#nodeid#
</cfquery>
<cfquery name="node_up" datasource="#Attributes.datasource#" username="#Attributes.username#" password="#Attributes.password#">
SELECT #Attributes.id# AS nid FROM #Attributes.table# WHERE #Attributes.parent#=#node.pid# AND sortorder=(#node.sortorder#-1)
</cfquery>

<!--- if its possible to move the node --->
<cfif #node_up.recordcount# gt 0>

<cftransaction>
	<cfquery name="updaten" datasource="#Attributes.datasource#" username="#Attributes.username#" password="#Attributes.password#">
	UPDATE #Attributes.table# SET sortorder=sortorder-1 WHERE #Attributes.id#=#nodeid#
	</cfquery>
	<cfquery name="updaten" datasource="#Attributes.datasource#" username="#Attributes.username#" password="#Attributes.password#">
	UPDATE #Attributes.table# SET sortorder=sortorder+1 WHERE #Attributes.id#=#node_up.nid#
	</cfquery>
</cftransaction>

</cfif>
<cfif isdefined("url.instanceName")>
	<cfset edit_tree_adv()>
</cfif>

</cffunction>

<!---=========== Move Node and Subnodes: DOWN ========================================--->
<cffunction name="move_down">
<cfargument name="nodeid" type="numeric">

<cfquery name="node" datasource="#Attributes.datasource#" username="#Attributes.username#" password="#Attributes.password#">
SELECT #Attributes.parent# AS pid,sortorder FROM #Attributes.table# WHERE #Attributes.id#=#nodeid#
</cfquery>
<cfquery name="node_down" datasource="#Attributes.datasource#" username="#Attributes.username#" password="#Attributes.password#">
SELECT #Attributes.id# AS nid FROM #Attributes.table# WHERE #Attributes.parent#=#node.pid# AND sortorder=(#node.sortorder#+1)
</cfquery>

<!--- if its possible to move the node --->
<cfif #node_down.recordcount# gt 0>

<cftransaction>
	<cfquery name="updaten" datasource="#Attributes.datasource#" username="#Attributes.username#" password="#Attributes.password#">
	UPDATE #Attributes.table# SET sortorder=sortorder+1 WHERE #Attributes.id#=#nodeid#
	</cfquery>
	<cfquery name="updaten" datasource="#Attributes.datasource#" username="#Attributes.username#" password="#Attributes.password#">
	UPDATE #Attributes.table# SET sortorder=sortorder-1 WHERE #Attributes.id#=#node_down.nid#
	</cfquery>
</cftransaction>

</cfif>
<cfif isdefined("url.instanceName")>
	<cfset edit_tree_adv()>
</cfif>

</cffunction>

<!--- =========== AJAX - MOVE ======================================== --->
<cffunction name="move_node">
<cfargument name="node1" type="numeric">
<cfargument name="node2" type="numeric">

<cfquery name="node" datasource="#Attributes.datasource#" username="#Attributes.username#" password="#Attributes.password#" maxrows="1">
SELECT * FROM #Attributes.table# WHERE #Attributes.parent#=#node2# ORDER BY sortorder DESC
</cfquery>

<cftransaction>
    <cfquery name="updaten" datasource="#Attributes.datasource#" username="#Attributes.username#" password="#Attributes.password#">
    UPDATE #Attributes.table# SET #Attributes.parent#=#node2#,sortorder=#val(node.sortorder)+1# WHERE #Attributes.id#=#node1#
    </cfquery>
</cftransaction>
<cfif isdefined("url.instanceName")>
	<cfset edit_tree_adv()>
</cfif>

</cffunction>


<!---=========== MAIN ===========================--->

<cfswitch expression="#lcase(Attributes.action)#">
	<cfcase value="insert">
		<cfset insert_elem(#Attributes.node#,#Attributes.formfields#)>
	</cfcase>
	<cfcase value="update">
		<cfset update_elem(#Attributes.node#,#Attributes.formfields#)>
	</cfcase>
	<cfcase value="delete">
		<cfset delete_elem(#Attributes.node#)>
	</cfcase>
	<cfcase value="up">
		<cfset move_up(#Attributes.node#)>
	</cfcase>
	<cfcase value="down">
		<cfset move_down(#Attributes.node#)>
	</cfcase>
	<cfcase value="move">
		<cfset move_node(#Attributes.node#,#Attributes.nodeto#)>
	</cfcase>
	<cfcase value="moveroot">
		<cfset move_node(#Attributes.node#,#Attributes.rootnode#)>
	</cfcase>
	<cfcase value="edit">
		<cfswitch expression="#lcase(Attributes.type)#">
			<cfcase value="advanced">
				<cfset edit_tree_adv()>
			</cfcase>
			<cfdefaultcase>
				<cfset edit_tree()>
			</cfdefaultcase>
		</cfswitch>
	</cfcase>
	<cfcase value="get">
		<cfswitch expression="#lcase(Attributes.type)#">
			<cfcase value="list">
				<cfset get_content()>
			</cfcase>
			<cfcase value="linked,clicktree,hovertree">
				<cfset get_tree()>
			</cfcase>
			<cfcase value="path">
				<cfset get_path(#Attributes.rootnode#,#Attributes.node#)>
			</cfcase>
			<cfcase value="select">
				<cfset get_select()>
			</cfcase>
			<cfcase value="checkbox">
				<cfset get_checkbox()>
			</cfcase>
			<cfdefaultcase>
				<cfset get_content()>
			</cfdefaultcase>
		</cfswitch>
	</cfcase>
	<cfdefaultcase>
		<cfset get_content()>
	</cfdefaultcase>
</cfswitch>

<cfsetting enablecfoutputonly="no">
</cfprocessingdirective><cfexit method="exittag">