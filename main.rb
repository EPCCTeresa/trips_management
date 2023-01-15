#!/usr/bin/env ruby
# frozen_string_literal: true

require 'bundler/setup'
Bundler.require(:default)

require_relative 'lib/cli'

Cli.new(ARGV).call
