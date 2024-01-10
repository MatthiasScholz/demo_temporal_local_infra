up:
	colima start
	./start

open-ui: mail monitor web

monitor:
	open http://localhost:8085

mail:
	open http://localhost:8025

web:
	open http://localhost:8088/data-converter/8086

email ?= candidate@example.com
run:
	./run-cli bgc-company start --email $(email) --package full
	@echo "INFO :: Possible SSNs: 111-11-1111, 222-22-2222, 333-33-3333, 444-44-4444 - putting last into clipboard."
	echo "444-44-4444" | pbcopy
	open http://localhost:8025

status:
	./run-cli bgc-company list

run_id ?= unset
cancel:
	@echo NOTE: Obtain the Run Id from the Temporal Web UI: "http://localhost:8088/"
	./run-cli bgc-company cancel --email $(email) --id $(run_id)

logs:
	docker compose logs
