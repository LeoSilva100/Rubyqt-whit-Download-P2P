require 'thread'
require 'socket'
require 'find'
require "Qt"
require './interface.rb'
require './p2p.rb'

app = Qt::Application.new(ARGV)
p2pWin = Windows.new
p2pWin.show
p2pWin.exec