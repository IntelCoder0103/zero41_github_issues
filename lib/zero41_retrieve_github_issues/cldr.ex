 defmodule Zero41RetrieveGithubIssues.Cldr do
   use Cldr,
     locales: ["en", "fr", "ja"],
     providers: [Cldr.Number, Cldr.Calendar, Cldr.DateTime]

 end
