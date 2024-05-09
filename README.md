pre-commit-docker-go-test
=========================

:rotating_light: This pre-commit config is adapted to personal projects. If you have the same
needs and plan to use this code you should read the license first, then make a fork or clone this
 repository to adapt it to your own environment. :rotating_light:

----

## About

pre-commit config to run `go test -v ./...` inside a docker container using dokcer-compose.

docker-compose hook for http://pre-commit.com/ created for container [golang:1.22-alpine](https://hub.docker.com/layers/library/golang/1.22-alpine/images/sha256-963da5f97ab931c0df6906e8c0ebc7db28c88d013735ae020f9558c3e6cf0580?context=explore)
using [air](https://github.com/cosmtrek/air) for hot reload.

## Docker testing container

You docker container used by **pre-commit** must run the test command using `CMD` or `ENTRYPOINT`,
else the error will not exit the program and the hook would succeed even if the tests fail.

For go you can even compile the tests binary when building the container, so you could build the
container and compile the binary before running pre-commit, this would make the hook faster to
execute.

You can do it using the following config at the end of your `Dockerfile`:

````dockerfile
...

RUN mkdir -p tests && go test -c -o tests/myapp.test myapp_test.go

ENTRYPOINT ["go", "test", "-exec", "tests/myapp.test"]
````

## Using hook

Add this to your `.pre-commit-config.yaml`

    - repo: https://github.com/euphoria-laxis/pre-commit-docker-go-test
      rev: master
      hooks:
        - id: euphoria-app-test
          container: test
          additional_containers:
              - database
              - cache

## Available hooks

* `euphoria-app-test` - Runs `docker-compose exec $container go test -v ./...`, requires 
[docker-compose](https://docs.docker.com/compose/install/). **Arguments**:
	* `container`: container used for tests name.
	* `file`: go test file *(must end by `_test.go`)*.
	* `additional_containers`: containers required by the test container to work *(database, redis, 
		elasticsearch, etc)*. They will be started before running the tests container.

## Contributors

#### Maintainer(s)

* **[Euphoria Laxis](https://github.com/euphoria-laxis)**. [Contact](mailto:euphoria.laxis@euphoria-laxis.com)


## License

This project is under [BSD 3-Clause License](./LICENSE). You should read it first if you plan any
commercial usage of this code.