Rails.application.routes.draw do
	get "/showinputfields" => "addition#showinputfields"
	get "/display" =>"addition#display"

	post "/perform" => "addition#perform"
end
