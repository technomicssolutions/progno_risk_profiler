require "omnicontacts"

Rails.application.middleware.use OmniContacts::Builder do
  #importer :gmail, "891067340249-rbkcgb35anof69qjb5ahjfv1kclhb41q.apps.googleusercontent.com", "IP2zTipdB07r3JkuWFld8GRO"
  importer :gmail, "312465703043.apps.googleusercontent.com", "o4uhukCtR_OU55fyKfNHprwf", {:redirect_path => "/users/invite_contacts"}
end