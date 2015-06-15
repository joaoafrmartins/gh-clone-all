#!/usr/bin/env coffee

require 'shelljs/global'

minimist = require 'minimist'

{ resolve } = require 'path'

{ requestAll } = require 'github-request'

args = minimist process.argv.slice 2

{ username, workspace } = args

workspace = resolve workspace

[ "username", "workspace" ].map (arg) =>

  if typeof args[arg] is "undefined" then throw new Error "argument #{arg} is undefined"

requestAll { path: "/users/#{username}/repos" }, (err, repos) ->

  if err then throw new Error err

  repos.map (repo) ->

    { name, ssh_url } = repo

    dest = "#{workspace}/#{name}"

    if not test "-e", dest then exec "git clone #{ssh_url} #{dest}"

