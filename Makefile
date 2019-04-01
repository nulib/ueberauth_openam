deps:
				mix local.hex --force
				mix local.rebar --force
				mix deps.get

test:		deps
				mix do compile --warnings-as-errors --force
			  mix format --check-formatted
		  	mix espec

report:
				mix coveralls.circle
	  		mix inch.report
