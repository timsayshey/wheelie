<cfcomponent extends="models.Model">
	<cfscript>
		function init()
		{
			super.init();

			// @ucasePlural@
			property(name="categoryType", defaultValue="@lcaseSingular@");
			this.setWhere = setWhere();

			// Set
			table("categories");

			// Relations
			hasMany("@ucaseSingular@CategoryJoins");
			belongsTo(name="@ucaseSingular@CategoryJoin", foreignKey="id", joinKey="categoryid", joinType="inner");

			// Validations
			validatesUniquenessOf(property="urlid", scope="siteid");
			validatesUniquenessOf(property="name", scope="siteid");

			// Other
			beforeSave("sanitizeNameAndURLId");
		}

		function setWhere()
		{
			return "categoryType='@lcaseSingular@'#wherePermission('Category','AND')#";
		}

		function categoryInfo()
		{
			return {
				singular		= "@ucaseSingular@ Category",
				plural			= "@ucaseSingular@ Categories",
				singularShort	= "Category",
				pluralShort		= "Categories"
			};
		}
	</cfscript>
</cfcomponent>

