# README

Assumtions
Because in the background and requirements for this code challenge there some things that wan's explicited, so I made some assumtions that are decribed below

Assumtions:
-Any authentication method was implemented, so there isn't a token or any other way to identify the current user who is creating an event. A user_id allways need to be provided to create an event.
-If finish date and duration both are provided, duration is taked into account.
-Default scope only queries events that aren´t finnished
-Any filter is provided, so there isn´t any query to filter by 'published' or 'draft'
-To create an event, you need to provide at least a start date, finnish date or duration, timezone and a user_id
-Event cannot be published if is removed. Neither transtitioned to draft.
-Any error handling approach was developed.




