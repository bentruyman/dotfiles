# Dotfiles

![Screenshot of my shell prompt](https://user-images.githubusercontent.com/85315/42671056-fe37e606-8612-11e8-8d0d-6d966cdfbcbc.png)

## Installation

```
$ cd \
  && git clone https://github.com/bentruyman/dotfiles.git \
  && cd dotfiles \
  && bash bootstrap.sh
```

## Try It Out!

If you want to try these dotfiles on but don't want it to mess up your
existing environment, try out the
[Docker image](https://hub.docker.com/r/bentruyman/dotfiles/) I put together:

```
$ docker run -it --rm bentruyman/dotfiles
```

Running this will drop you into a shell as `test-user` in an Ubuntu
environment.

## Special Thanks

My dotfiles are the result of inspiration or outright stealing from:

* Ben Alman and his [dotfiles](https://github.com/cowboy/dotfiles)
* Gianni Chiappetta and his [dotfiles](https://github.com/gf3/dotfiles)
* Mathias Bynens and his [dotfiles](https://github.com/mathiasbynens/dotfiles)

## License

MIT © Ben Truyman
