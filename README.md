# Multi-stage Dockerfile for Node.js apps

Here’s the list of things Dockerfile here is capable to do:

1. Run locally with dev dependencies
2. Hot-reload when code is changed on our machine
3. Build a production-ready version that excludes dev dependencies
4. Produce in a reasonably small container image file size

## How to run?

First make sure that you copy the content from `.env.template` to the root of your project to a file called `.env`.

Run `docker compose up` to build and spin up the container.

To run a production build, run `docker build . -t <my-project-name>:latest`.
