#!/usr/bin/env ruby
# encoding: UTF-8
#
require 'thread'
require 'socket'
require 'find'
require "Qt"
require './p2p.rb'
require './notify.rb'

class  Windows < Qt::Dialog
	slots	'event_button_server()', 'event_button_client()','commandline()', 'verify()'
	def initialize(parent = nil)
	    super(parent)
    	self.setWindowIcon(Qt::Icon.new('images/icon.png')) 
	    self.windowTitle = tr("Download P2P")
	    self.setGeometry(500, 500, 430, 200)
	    self.setPalette(Qt::Palette.new(Qt::Color.new(112,128,144)))
	    self.setFont(Qt::Font.new('Times', 12, Qt::Font::Bold))

	    @tittle1 = Qt::Label.new("PREENCHA OS CAMPOS ABAIXO PARA FAZER O DOWNLOAD")
	    @hostLineEdit = Qt::LineEdit.new()
	    @hostLabel = Qt::Label.new("Ip do Servidor:")
	    @portLineEdit = Qt::LineEdit.new()
	    @portLabel = Qt::Label.new("Porta:")
	    @searchLineEdit = Qt::LineEdit.new()
	    @searchLabel = Qt::Label.new("Nome do arquivo:")
	    @serverLineEdit = Qt::LineEdit.new()

	    @tittle2 = Qt::Label.new("PREENCHA OS CAMPOS ABAIXO PARA SUA MÁQUINA SER UM SERVIDOR")
	    @serverLabel = Qt::Label.new("Ip do seu Servidor:")
	    @portServerLineEdit = Qt::LineEdit.new()
	    @portServerLabel = Qt::Label.new("Porta:")

	    @layout_tittle1 = Qt::HBoxLayout.new()
	    @layout_tittle2 = Qt::HBoxLayout.new()
		@layout_h1 = Qt::HBoxLayout.new()
		@layout_h2 = Qt::HBoxLayout.new()
		@layout_h3 = Qt::HBoxLayout.new()
		@layout_h4 = Qt::HBoxLayout.new()
		@layout_h5 = Qt::HBoxLayout.new()
		
	  	@up_client = Qt::PushButton.new()
	  	@up_client.setText("Start Download")
	  	@up_server = Qt::PushButton.new()
	  	@up_server.setText("Start Servidor Local")
	  	@ip_config =  Qt::PushButton.new()
	  	@ip_config.setText("Descubra seu Ip local")
	  	@find =  Qt::PushButton.new()
	  	@find.setText("Verificar Download?")

	  	@layout_tittle1.addWidget(@tittle1)
	    @layout_h1.addWidget(@hostLabel)
	    @layout_h1.addWidget(@hostLineEdit)
		@layout_h2.addWidget(@portLabel)
	  	@layout_h2.addWidget(@portLineEdit)
	  	@layout_h3.addWidget(@searchLabel)
	  	@layout_h3.addWidget(@searchLineEdit)
	  	@layout_tittle2.addWidget(@tittle2)
	  	@layout_h4.addWidget(@serverLabel)
	  	@layout_h4.addWidget(@serverLineEdit)
	  	@layout_h5.addWidget(@portServerLabel)
	  	@layout_h5.addWidget(@portServerLineEdit)
	  	
	  	@main = Qt::VBoxLayout.new()
	  	@main.addLayout(@layout_tittle1)
	  	@main.addLayout(@layout_h1)
	  	@main.addLayout(@layout_h2)
	  	@main.addLayout(@layout_h3)
	  	@main.addWidget(@up_client)
	  	@main.addWidget(@find)
	  	@main.addLayout(@layout_tittle2)
	  	@main.addLayout(@layout_h4)
	  	@main.addLayout(@layout_h5)
	  	@main.addWidget(@ip_config)
	  	@main.addWidget(@up_server)
	    setLayout(@main)
	    
	    self.connect(@up_client, SIGNAL('clicked()'), SLOT('event_button_client()'))
	    self.connect(@up_server, SIGNAL('clicked()'), SLOT('event_button_server()'))
	    self.connect(@ip_config, SIGNAL('clicked()'), SLOT('commandline()'))
	    self.connect(@find, SIGNAL('clicked()'), SLOT('verify()'))
	end
	def event_button_server
		host = @serverLineEdit.displayText()
		port = @portServerLineEdit.displayText()
		if host.eql?("") || port.eql?("")
			@notify = Notify.new
			@notify.form_fail
		    return
		else
		@up_server = Qt::Thread.new
		@up_server.server(host, port)
		end
	end # fim do evento_server
	def event_button_client
		host = @hostLineEdit.displayText()
		port = @portLineEdit.displayText()
		search = @searchLineEdit.displayText()
		if host.eql?("") || port.eql?("") || search.eql?("")
			@notify = Notify.new
			@notify.form_fail
		else
			@up_client = Qt::Thread.new
			@up_client.client(host, port, search)
		end
	end # fim do evento_client
	def commandline
		system('start cmd.rb')
	end #fim do comande
	def verify
		search = @searchLineEdit.displayText()
		find_ok = false
		Find.find('./') do |f|
		puts "procurando..."	
		if f.include?("copia_#{search}.")
			find_ok = true
			@notify = Notify.new
			@notify.download_complete
		end
		end	
		if find_ok.eql?(false)
			@notify = Notify.new
			@notify.download_fail
		end	
	end # fim do verify
end # fim da janela