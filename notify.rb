require "Qt"

class Notify < Qt::Dialog
	signals 'up()', 'down()'
	slots 'up_server()', 'up_client()','download_complete()','download_fail()', 'form_fail()'
	def initialize(parent = nil)
	    super(parent)
	    connect(self, SIGNAL('up_server()'), self, SLOT('up_server()'))
	    connect(self, SIGNAL('up_client()'), self, SLOT('up_client()'))
	   	connect(self, SIGNAL('download_complete()'), self, SLOT('download_complete()'))
	    connect(self, SIGNAL('download_fail()'), self, SLOT('download_fail()'))
	    connect(self, SIGNAL('form_fail()'), self, SLOT('form_fail()'))
	end
	def up_server
	    Qt::MessageBox.information(self, tr("Servidor Levantado"),tr("Run Bary...Run!!!"),self.setWindowIcon(Qt::Icon.new('images/Fs.png')))
		return
	end
	def up_client
	    Qt::MessageBox.information(self, tr("Servidor Requisitado!"),tr("Run Bary...Run!!!"),self.setWindowIcon(Qt::Icon.new('images/Fs.png')))
		return
	end
	def download_complete
		Qt::MessageBox.information(self,tr("Baixado!"), tr("Today was a productive day"),self.setWindowIcon(Qt::Icon.new('images/Ng.png')))
		return	
	end
	def download_fail
		Qt::MessageBox.information(self, tr("Falha no Download!"),tr("Surprise Motherfucker"),self.setWindowIcon(Qt::Icon.new('images/Sp.png')))
		return		
	end
	def form_fail
		Qt::MessageBox.information(self,tr("Falha!"), tr("Existe campos nao prenchidos!!!"),self.setWindowIcon(Qt::Icon.new('images/Sp.png')))
		return	
	end
end # fim da janela