<!---
 * @hint Videos Relational Model
--->
<cfcomponent extends="models.Model">
	<cfscript>
	
		/**
		 * @hint Constructor
		 */
		public void function init()
		{
			table("video_category");

			belongsTo(name="Video",foreignKey="video_id");			
			belongsTo(name="VideoCategory",foreignKey="category_id");
		}

	</cfscript>
</cfcomponent>