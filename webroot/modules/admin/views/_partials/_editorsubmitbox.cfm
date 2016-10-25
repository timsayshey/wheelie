<cfoutput>
	<cfparam name="rightBottomClass" default="">
	<cfparam name="controllerName" default="">
	<cfparam name="currentStatus" default="draft">
	
	<div class="#rightBottomClass# data-block">
		<section>
			
				<button type="submit" name="submit" value="published" class="btn btn-primary">
					<cfif isNew OR currentStatus eq "draft">Save<cfelse>Update</cfif>	
				</button> 

				&nbsp;&nbsp;
				
				<cfif !isNew>	
					<button type="submit" name="submit" value="trash" class="btn btn-danger confirmDelete pull-right">
						Delete
					</button>					
				</cfif>
			<!--- <div class="btn-group dropdown">
			
				<button type="submit" name="submit" value="published" class="btn btn-primary">
					<cfif isNew OR currentStatus eq "draft">Save<cfelse>Update</cfif>	
				</button> 
				<button class="btn btn-primary dropdown-toggle" data-toggle="dropdown"><span class="caret"></span></button>
				
				<ul class="dropdown-menu dropdown-blue pull-right">	
				
					<li>
						<button type="submit" name="submit" value="draft" class="btn-linky">
							<cfif isNew OR currentStatus eq "draft">Save as Draft<cfelse>Move to Drafts</cfif>	
						</button> 	
					</li>
						
					<cfif !isNew>		
						<li>
							<button type="submit" name="submit" value="trash" class="btn-linky btn-danger confirmDelete">
								Delete forever
							</button>
						</li>						
					</cfif>
					
				</ul>
			</div> --->
		</section>
	</div>
</cfoutput>