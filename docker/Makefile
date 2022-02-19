DOCKER := $(shell command -v docker 2> /dev/null)
PODMAN := $(shell command -v podman 2> /dev/null)

ifdef PODMAN
	d := podman
else
	d := docker
endif

all: jlm-eval-suite.tar

jlm-eval-suite.tar:
	cd .. && $(d) build -t jlm-eval-suite -f ./docker/jlm-eval-suite-dockerfile .
	echo $(d) image save -o jlm-eval-suite.tar jlm-eval-suite

run:
	$(d) run --rm -it -v ../:/home/jlm-eval-suite jlm-eval-suite /bin/bash

open:
	echo $(d) load < jlm-eval-suite.tar
	$(d) run --rm -it jlm-eval-suite /bin/bash

clean:
	rm -f jlm-eval-suite.tar
	$(d) image rm -f jlm-eval-suite
