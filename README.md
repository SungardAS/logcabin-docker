[GitHub][github-url] | [DockerHub][dockerhub-url]

## Overview




## How To Run container

## How to view logs

```
docker logs logcabin
```

## How to get to bash shell in running container to troubleshoot

```
docker exec -it logcabin bash
```

## How To Build Container

```
docker build build -t sungardas/logcabin-docker .
```

## Environment Variables

* key = value

## Next Steps


## License

Apache-2.0 ©

## Sungard Availability Services | Labs
[![Sungard Availability Services | Labs][labs-logo]][labs-github-url]

This project is maintained by the Labs team at [Sungard Availability
Services](http://sungardas.com)

GitHub: [https://sungardas.github.io](https://sungardas.github.io)

Blog:
[http://blog.sungardas.com/CTOLabs/](http://blog.sungardas.com/CTOLabs/)


[labs-github-url]: https://sungardas.github.io
[labs-logo]: https://raw.githubusercontent.com/SungardAS/repo-assets/master/images/logos/sungardas-labs-logo-small.png

[github-url]: https://github.com/SungardAS/logcabin-docker
[dockerhub-url]: https://hub.docker.com/r/sungardas/logcabin-docker