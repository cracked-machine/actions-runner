# Actions Runner dockerfile

This repo contains the Dockerfile for building images that can run self-hosted github runners. A helper script is provided for use on the deidcated server that launches the container and registers the runner with the specified development repo.

- The development repository is hosted on github.com.
- The github runner (or "action runner") is self-hosted on a dedicated server.
- Github runners can be registered with development repositories in a many-to-many relationship. 



## Rebuild this dockerfile 

1. Clone the repo to your linux workstation:
2. Build the dockerfile using your registry settings:

    ```
    BUILDKIT=1 docker build -t <github_account_url>/actions_runner:ubuntu2204 .
    ```

3. push to your registry:

    ```
    docker push -t <github_account_url>/actions_runner:ubuntu2204 .
    ```

Note, you must setup a [personal access token](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry#authenticating-to-the-container-registry) to push/pull this with the github docker registry used in the commands above.

## Using the docker image on a server

1. Upload the [launch.sh](launch.sh) script to the server
2. Modify the registry URL in the [launch.sh](launch.sh) script to match your own docker registry
3. Run the script using the following arguments:

    - `NAME`: 
        - The chosen name for the container
    - `URL`: 
        - The URL of the github repo
    - `TOKEN`: 
        - The secret token of the github repo (see `settings > Actions > Runners > Linux > Configure`). 
        - Note: these tokens can be viewed using the `docker inspect` command but the tokens expire quickly (after a couple of minutes).

4. Exit the container (without killing it) by pressing Ctrl-P and then Ctrl-Q.

Note: to kill the container use `docker stop <id>` and `docker rm <id>` as usual. DOn't forget to the remove the runner from the github.com settings page for the repository.
