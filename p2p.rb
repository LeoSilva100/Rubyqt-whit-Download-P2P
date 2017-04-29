require 'thread'
require 'socket'
require 'find'
require "Qt"
require './notify.rb'
require './interface.rb'

class Qt::Thread
	$response = false
	def initialize
	@notify = Notify.new
	end
	def server(host, port)
		@notify.up_server
		serverSocket = TCPServer.new "#{host}",port.to_i
		Thread.new{
		puts "Servidor escutando..."
		loop do
			Thread.start(serverSocket.accept) do |clientSocket|
				name_file = clientSocket.gets.chomp
				puts name_file
				Find.find('./') do |f|
					puts "procurando..."
					if f.include?(name_file)
						doc = f
						tittle = f.split("/").last
						type = f.split(".").last
						clientSocket.puts(true)
						clientSocket.puts(doc)
						clientSocket.puts(tittle)
						clientSocket.puts(type)
						file = File.new("#{doc}","r")
						loading = File::size("#{doc}")
						bytes_file = file.read(loading)
						clientSocket.puts(loading.to_s)
						clientSocket.syswrite(bytes_file)
						file.close
						clientSocket.close
						break
					end # fim if
				end #fim do find
			end # thread
		end # fim loop
		}	
	end # fim server

	def client(host, port, search)
		@notify.up_client
		Thread.new{
		sockServer =  TCPSocket.new(host, port.to_i)
		Thread.start(sockServer) do |sockServer|
				sockServer.puts(search)
				$response  = sockServer.gets.chomp
				doc = sockServer.gets.chomp #recebe o caminho do arquivo
				tittle = sockServer.gets.chomp #recebe o titlo do arquivo arquivo
				type = sockServer.gets.chomp #recebe a extenssão do arquivo
				size_file = sockServer.gets.chomp.to_i # ler o tamnho em bytes do arquivo
				bytes_file = sockServer.read(size_file) # ler os bytes para fazer o upload
				file = File.new("copia_#{tittle}.""#{type}", "wb") #abre o arquivo para a 
				file.syswrite(bytes_file) #fazendo a upload do arquvo passado como parametro no servidor
				file.close #encerra a conexão			
		end
		}
	end #fim client
end #fim da classe app