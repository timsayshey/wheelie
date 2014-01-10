<cfoutput>

    <section class="page-wrapper" id="pagey">    
        <div class="container">
            <div class="row">
                <cfif IsStruct(users)>
                    <h1>#users.name#</h1>
                    #users.content#
                <cfelse>
                
                    <cfloop query="users">
                    
                        <div class="col-md-12">
                            <div class="panel">
                                <div class="row">
                                    <div class="col-xs-4 col-md-4 text-center">
                                        <img src="#users.portrait#" class="img-rounded img-responsive" />
                                    </div>
                                    <div class="col-xs-8 col-md-8 section-box">
                                        <h3>
                                           #users.firstname# 
                                            <cfif len(trim(users.spouse_firstname))>
                                                & #users.spouse_firstname#
                                            </cfif>
                                            #users.lastname#
                                            <cfif len(trim(users.title))>
                                             - #users.title#       
                                            </cfif>
                                        </h3>
                                       <p>#users.about#</p>
                                    </div>
                                </div>
                            </div>
                        </div> 
                        
                    </cfloop>
                    	
                </cfif>
            </div>
        </div>
    </section>
    
</cfoutput>