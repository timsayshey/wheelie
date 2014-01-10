{
	"validations" : 
	{
		"pages" : [
			{
				"page_title": [
					{
						"type":"required",
						"msg":"Title is required."
					}					
				]
			}
		],
		"videos" : [
			{
				"urlid": [
					{
						"type":"required",
						"msg":"Video URL is required."
					},
					{
						"type":"integer",
						"msg":"Video URL must be a number."
					}					
				]
			},
			{
				"name": [
					{
						"type":"required",
						"msg":"Video Name is required."
					}					
				]
			}
		]
	}
}