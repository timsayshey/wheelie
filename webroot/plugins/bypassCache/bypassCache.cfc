<cfcomponent>
	 <cffunction name="init">
		<cfset this.version = "1.3,1.3.1,1.3.2,1.3.3,1.4.4,1.4.5,1.4.6,1.4.7,1.4.8,1.4.9,1.5,1.5.0,1.5.1,1.5.2">
		<cfreturn this>
	</cffunction>	

	<!--- 
		Just added isNull(session.user) to 2 conditions so cache doesn't run for logged in users -- Per is working on fixing this for 1.3.3 or 2.0
		https://github.com/cfwheels/cfwheels/issues/439
	 --->
	
	<cffunction name="$processAction" returntype="boolean" access="public" output="false">
		<cfscript>
			var loc = {};
	
			// check if action should be cached and if so cache statically or set the time to use later when caching just the action
			loc.cache = 0;
			if ($hasCachableActions() && flashIsEmpty() && StructIsEmpty(form) && isNull(session.user))
			{
				loc.cachableActions = $cachableActions();
				loc.iEnd = ArrayLen(loc.cachableActions);
				for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
				{
					if (loc.cachableActions[loc.i].action == params.action || loc.cachableActions[loc.i].action == "*")
					{
						if (loc.cachableActions[loc.i].static)
						{
							$cache(action="serverCache", timeSpan=$timeSpanForCache(loc.cachableActions[loc.i].time), useQueryString=true);
							if (!$recacheRequired())
							{
								$abort();
							}
						}
						else
						{
							loc.cache = loc.cachableActions[loc.i].time;
						}
						break;
					}
				}
			}
	
			if (application.wheels.showDebugInformation)
			{
				$debugPoint("beforeFilters");
			}
	
			// run verifications if they exist on the controller
			$runVerifications(action=params.action, params=params);
			
			// return immediately if an abort is issued from a verification
			if ($abortIssued())
			{
				return true;
			}
	
			// run before filters if they exist on the controller
			$runFilters(type="before", action=params.action);
			
			// check to see if the controller params has changed and if so, instantiate the new controller and re-run filters and verifications
			if (params.controller != variables.$class.name)
			{
				return false;
			}
	
			if (application.wheels.showDebugInformation)
			{
				$debugPoint("beforeFilters,action");
			}
	
			// only proceed to call the action if the before filter has not already rendered content
			if (!$performedRenderOrRedirect())
			{
				if (loc.cache && isNull(session.user))
				{
					// get content from the cache if it exists there and set it to the request scope, if not the $callActionAndAddToCache function will run, calling the controller action (which in turn sets the content to the request scope)
					loc.category = "action";
					loc.key = $hashedKey(variables.$class.name, variables.params);
					loc.lockName = loc.category & loc.key;
					loc.conditionArgs = {key=loc.key, category=loc.category};
					loc.executeArgs = {controller=params.controller, action=params.action, key=loc.key, time=loc.cache, category=loc.category};
					variables.$instance.response = $doubleCheckedLock(name=loc.lockName, condition="$getFromCache", execute="$callActionAndAddToCache", conditionArgs=loc.conditionArgs, executeArgs=loc.executeArgs);
				}
				if (!$performedRender())
				{
					// if we didn't render anything from a cached action we call the action here
					$callAction(action=params.action);
				}
			}
	
			// run after filters with surrounding debug points (don't run the filters if a delayed redirect will occur though)
			if (application.wheels.showDebugInformation)
			{
				$debugPoint("action,afterFilters");
			}
			if (!$performedRedirect())
			{
				$runFilters(type="after", action=params.action);
			}
			if (application.wheels.showDebugInformation)
			{
				$debugPoint("afterFilters");
			}
		</cfscript>
		<cfreturn true>
	</cffunction>

</cfcomponent>