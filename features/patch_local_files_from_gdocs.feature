Feature: Patch local files from Google docs

	In order for non-technical stakeholders to specify user stories
	As a developer
	I want to merge in features from Google docs

		Scenario: Diff features
			
			Given I have a local feature store
			And a google docs feature store
			And the local feature store contains:
				| path 												   | version                   |
				| fruit/yellow/banana.feature    | 2009-02-20T00:36:34.402Z  |
				| fruit/green/apple.feature      | some-new-version          |
				| fruit/yellow/pineapple.feature | some-old-version          |
			And the google docs feature store contains:
				| path 												   | version                   |
				| fruit/yellow/banana.feature    | 2009-02-20T00:36:34.402Z  |
				| fruit/yellow/pineapple.feature | 2009-02-20T01:12:36.130Z  |
				| fruit/green/grape.feature      | 2009-02-21T10:27:16.971Z  |
			When I run the program
			Then I should see the following changes:
				| path													 | change    |
				| fruit/green/grape.feature      | created   |
				| fruit/green/apple.feature      | deleted   |
				| fruit/yellow/pineapple.feature | updated   |
		  When I apply change 1
			And  I run the program
			Then I should see the following changes:
				| path													 | change    |
				| fruit/green/apple.feature      | deleted   |
				| fruit/yellow/pineapple.feature | updated   |
			